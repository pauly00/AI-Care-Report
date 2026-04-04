package com.pauly.AI_Care_Report_BE.dto;

import lombok.Data;

@Data
public class RegisterRequest {
    private String name;
    private String email;
    private String password;
    private String phoneNumber;
    private String birthdate;
    private Integer gender;
    private Integer permission;
    private String role;
}
