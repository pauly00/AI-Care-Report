package com.pauly.AI_Care_Report_BE.dto;

import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
public class UploadSummaryRequest {
    private Long reportid;
    private List<Map<String, String>> items; // [{subject, abstract, detail}]
}
