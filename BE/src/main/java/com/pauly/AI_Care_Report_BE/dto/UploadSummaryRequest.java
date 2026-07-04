package com.pauly.AI_Care_Report_BE.dto;

import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
// 방문 요약 저장 요청 DTO
public class UploadSummaryRequest {
    private Long reportid;
    // 요약 항목 목록
    private List<Map<String, String>> items;
}
