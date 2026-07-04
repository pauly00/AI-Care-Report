package com.pauly.AI_Care_Report_BE.dto;

import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
// 정책 체크 저장 요청 DTO
public class UploadPolicyRequest {
    private Long reportid;
    // 정책 체크 목록
    private List<Map<String, Object>> policy;
}
