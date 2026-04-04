package com.pauly.AI_Care_Report_BE.dto;

import lombok.Data;

import java.util.Map;

@Data
public class UploadDefaultReportRequest {
    private Long reportid;
    private Integer reportstatus;
    private String visittime;
    private Map<String, Object> targetInfo;
    private Map<String, Object> userInfo;
    private String visitType;
    private String endTime;
}
