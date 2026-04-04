package com.pauly.AI_Care_Report_BE.dto;

import lombok.Data;

@Data
public class UploadVisitDetailRequest {
    private Long reportid;
    private String detail;
}
