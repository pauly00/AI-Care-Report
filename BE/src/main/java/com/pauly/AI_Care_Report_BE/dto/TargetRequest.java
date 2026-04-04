package com.pauly.AI_Care_Report_BE.dto;

import lombok.Data;

@Data
public class TargetRequest {
    private String targetname;
    private String address1;
    private String address2;
    private String targetcallnum;
    private Integer gender;
    private Integer age;
    private String region;
}
