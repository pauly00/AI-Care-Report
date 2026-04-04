package com.pauly.AI_Care_Report_BE.dto;

import com.pauly.AI_Care_Report_BE.entity.User;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class UserResponse {

    @JsonProperty("user_id")
    private Long userId;

    private String name;
    private String email;

    @JsonProperty("phone_number")
    private String phoneNumber;

    private String birthdate;
    private Integer gender;
    private Integer permission;
    private String role;

    public static UserResponse from(User user) {
        return UserResponse.builder()
                .userId(user.getId())
                .name(user.getName())
                .email(user.getEmail())
                .phoneNumber(user.getPhoneNumber())
                .birthdate(user.getBirthdate())
                .gender(user.getGender())
                .permission(user.getPermission())
                .role(user.getRole())
                .build();
    }
}
