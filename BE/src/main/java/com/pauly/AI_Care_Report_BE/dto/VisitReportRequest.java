package com.pauly.AI_Care_Report_BE.dto;

import lombok.Data;

@Data
// 방문 보고서 생성 요청 DTO
public class VisitReportRequest {
    private Long targetid;
    private String visittime;
    // 담당자 이메일
    private String email;
}
