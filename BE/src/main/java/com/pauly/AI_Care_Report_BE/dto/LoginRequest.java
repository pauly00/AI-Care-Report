package com.pauly.AI_Care_Report_BE.dto;

import lombok.Data;

@Data
public class LoginRequest {
    private String email;
    private String password;
}
