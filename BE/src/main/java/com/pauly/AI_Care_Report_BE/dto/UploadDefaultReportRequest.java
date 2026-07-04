package com.pauly.AI_Care_Report_BE.dto;

import lombok.Data;

import java.util.Map;

@Data
// 보고서 기본정보 저장 요청 DTO
public class UploadDefaultReportRequest {
    private Long reportid;
    private Integer reportstatus;
    private String visittime;
    private Map<String, Object> targetInfo;
    private Map<String, Object> userInfo;
    private String visitType;
    private String endTime;
}
