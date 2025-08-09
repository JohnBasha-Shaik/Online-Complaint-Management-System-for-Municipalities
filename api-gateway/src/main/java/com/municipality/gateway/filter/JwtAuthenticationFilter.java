package com.municipality.gateway.filter;

import com.municipality.gateway.config.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.factory.AbstractGatewayFilterFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.util.List;

@Component
public class JwtAuthenticationFilter extends AbstractGatewayFilterFactory<JwtAuthenticationFilter.Config> {

    @Autowired
    private JwtUtil jwtUtil;

    public JwtAuthenticationFilter() {
        super(Config.class);
    }

    @Override
    public GatewayFilter apply(Config config) {
        return (exchange, chain) -> {
            ServerHttpRequest request = exchange.getRequest();
            
            // Skip authentication for auth endpoints
            if (isAuthEndpoint(request)) {
                return chain.filter(exchange);
            }

            if (!isAuthPresent(request)) {
                return onError(exchange, "Authorization header is missing", HttpStatus.UNAUTHORIZED);
            }

            String token = getAuthHeader(request);
            
            if (!jwtUtil.validateToken(token)) {
                return onError(exchange, "Authorization header is invalid", HttpStatus.UNAUTHORIZED);
            }

            return populateRequestWithHeaders(exchange, token, chain);
        };
    }

    private Mono<Void> populateRequestWithHeaders(ServerWebExchange exchange, String token, 
                                                 org.springframework.cloud.gateway.filter.GatewayFilterChain chain) {
        String username = jwtUtil.getUsernameFromToken(token);
        List<String> roles = jwtUtil.getRolesFromToken(token);
        
        ServerHttpRequest request = exchange.getRequest().mutate()
                .header("X-Username", username)
                .header("X-Roles", String.join(",", roles))
                .build();
        
        return chain.filter(exchange.mutate().request(request).build());
    }

    private Mono<Void> onError(ServerWebExchange exchange, String err, HttpStatus httpStatus) {
        ServerHttpResponse response = exchange.getResponse();
        response.setStatusCode(httpStatus);
        return response.setComplete();
    }

    private String getAuthHeader(ServerHttpRequest request) {
        String bearerToken = request.getHeaders().getOrEmpty("Authorization").get(0);
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        return null;
    }

    private boolean isAuthPresent(ServerHttpRequest request) {
        return request.getHeaders().containsKey("Authorization");
    }

    private boolean isAuthEndpoint(ServerHttpRequest request) {
        String path = request.getURI().getPath();
        return path.contains("/auth/") || path.contains("/login") || 
               path.contains("/register") || path.equals("/");
    }

    public static class Config {
        // Configuration properties if needed
    }
}