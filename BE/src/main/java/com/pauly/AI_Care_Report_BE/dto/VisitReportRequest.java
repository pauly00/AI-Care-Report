package com.pauly.AI_Care_Report_BE.dto;

import lombok.Data;

@Data
public class VisitReportRequest {
    private Long targetid;
    private String visittime;
    private String email; // 담당 사회복지사 이메일
}
