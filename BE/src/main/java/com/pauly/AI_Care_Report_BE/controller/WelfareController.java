package com.pauly.AI_Care_Report_BE.controller;

import com.pauly.AI_Care_Report_BE.dto.UploadPolicyRequest;
import com.pauly.AI_Care_Report_BE.service.WelfareService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/db")
@RequiredArgsConstructor
public class WelfareController {

    private final WelfareService welfareService;

    // GET /db/welfare-policies/:targetId (대상자별 정책)
    @GetMapping("/welfare-policies/{targetId}")
    public ResponseEntity<?> getWelfarePoliciesForTarget(@PathVariable Long targetId) {
        try {
            Map<String, Object> result = welfareService.getWelfarePoliciesForTarget(targetId);
            return ResponseEntity.ok(result);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(404).body(Map.of("message", e.getMessage()));
        }
    }

    // GET /db/welfare-policies (전체 정책)
    @GetMapping("/welfare-policies")
    public ResponseEntity<List<Map<String, Object>>> getAllPolicies() {
        return ResponseEntity.ok(welfareService.getAllPolicies());
    }

    // GET /db/policies/:id (특정 정책 상세)
    @GetMapping("/policies/{id}")
    public ResponseEntity<?> getPolicyById(@PathVariable Long id) {
        try {
            Map<String, Object> result = welfareService.getPolicyById(id);
            return ResponseEntity.ok(result);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(404).body(Map.of("message", e.getMessage()));
        }
    }

    // POST /db/uploadCheckPolicy
    @PostMapping("/uploadCheckPolicy")
    public ResponseEntity<?> uploadCheckPolicy(@RequestBody UploadPolicyRequest request) {
        try {
            welfareService.uploadPolicyCheckStatus(request);
            return ResponseEntity.ok(Map.of("status", true, "message", "정책 체크 저장 완료"));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("status", false, "message", e.getMessage()));
        }
    }
}
