package com.pauly.AI_Care_Report_BE.dto;

import lombok.Data;

@Data
// 방문 상세 저장 요청 DTO
public class UploadVisitDetailRequest {
    private Long reportid;
    private String detail;
}
