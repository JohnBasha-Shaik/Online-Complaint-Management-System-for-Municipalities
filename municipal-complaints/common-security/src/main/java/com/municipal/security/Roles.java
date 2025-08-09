package com.municipal.security;

public enum Roles {
    CITIZEN,
    STAFF,
    ADMIN;

    public String asAuthority() {
        return "ROLE_" + name();
    }
}