package com.municipal.notification.config;

import com.municipal.security.JwtProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

@Configuration
@ComponentScan(basePackages = "com.municipal.security")
@EnableConfigurationProperties(JwtProperties.class)
public class SecurityCommonImportConfig {
}