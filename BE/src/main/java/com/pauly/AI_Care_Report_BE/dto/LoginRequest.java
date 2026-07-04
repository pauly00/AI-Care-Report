package com.pauly.AI_Care_Report_BE.dto;

import lombok.Data;

@Data
// 로그인 요청 DTO
public class LoginRequest {
    private String email;
    private String password;
}
