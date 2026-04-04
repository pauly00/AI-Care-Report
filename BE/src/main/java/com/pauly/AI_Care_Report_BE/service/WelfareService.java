package com.pauly.AI_Care_Report_BE.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.pauly.AI_Care_Report_BE.dto.UploadPolicyRequest;
import com.pauly.AI_Care_Report_BE.entity.*;
import com.pauly.AI_Care_Report_BE.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class WelfareService {

    private final WelfarePolicyRepository welfarePolicyRepository;
    private final PolicyCheckRepository policyCheckRepository;
    private final VisitReportRepository visitReportRepository;
    private final TargetRepository targetRepository;
    private final ObjectMapper objectMapper;

    // 대상자에 맞는 복지 정책 조회
    public Map<String, Object> getWelfarePoliciesForTarget(Long targetId) {
        Target target = targetRepository.findById(targetId)
                .orElseThrow(() -> new IllegalArgumentException("대상자를 찾을 수 없습니다."));

        // 지역 기반 필터링 (지역 없으면 전체 반환)
        List<WelfarePolicy> policies;
        if (target.getRegion() != null && !target.getRegion().isBlank()) {
            policies = welfarePolicyRepository.findByRegion(target.getRegion());
            if (policies.isEmpty()) {
                policies = welfarePolicyRepository.findAll();
            }
        } else {
            policies = welfarePolicyRepository.findAll();
        }

        List<Map<String, Object>> policyList = policies.stream().map(p -> {
            Map<String, Object> item = new HashMap<>();
            item.put("id", p.getId());
            item.put("policy_name", p.getPolicyName());
            item.put("short_description", p.getShortDescription());
            item.put("detailed_conditions", parseConditions(p.getDetailedConditions()));
            item.put("link", p.getLink() != null ? p.getLink() : "");
            item.put("checkStatus", 1);
            return item;
        }).collect(Collectors.toList());

        return Map.of(
                "id", target.getId(),
                "age", target.getAge() != null ? target.getAge() : 0,
                "region", target.getRegion() != null ? target.getRegion() : "",
                "policy", policyList
        );
    }

    // 전체 복지 정책 조회
    public List<Map<String, Object>> getAllPolicies() {
        return welfarePolicyRepository.findAll().stream().map(p -> {
            Map<String, Object> item = new HashMap<>();
            item.put("id", p.getId());
            item.put("policy_name", p.getPolicyName());
            item.put("short_description", p.getShortDescription());
            item.put("detailed_conditions", parseConditions(p.getDetailedConditions()));
            item.put("link", p.getLink() != null ? p.getLink() : "");
            item.put("region", p.getRegion() != null ? p.getRegion() : "");
            return item;
        }).collect(Collectors.toList());
    }

    // 특정 정책 상세 조회
    public Map<String, Object> getPolicyById(Long policyId) {
        WelfarePolicy p = welfarePolicyRepository.findById(policyId)
                .orElseThrow(() -> new IllegalArgumentException("정책을 찾을 수 없습니다."));

        Map<String, Object> item = new HashMap<>();
        item.put("id", p.getId());
        item.put("policy_name", p.getPolicyName());
        item.put("short_description", p.getShortDescription());
        item.put("detailed_conditions", parseConditions(p.getDetailedConditions()));
        item.put("link", p.getLink() != null ? p.getLink() : "");
        item.put("region", p.getRegion() != null ? p.getRegion() : "");
        return item;
    }

    // 정책 체크 상태 업로드
    @Transactional
    public void uploadPolicyCheckStatus(UploadPolicyRequest request) {
        VisitReport report = visitReportRepository.findById(request.getReportid())
                .orElseThrow(() -> new IllegalArgumentException("보고서를 찾을 수 없습니다."));

        policyCheckRepository.deleteByReport(report);

        if (request.getPolicy() != null) {
            List<PolicyCheck> checks = new ArrayList<>();
            for (Map<String, Object> item : request.getPolicy()) {
                Object idObj = item.get("id");
                if (idObj == null) continue;

                Long policyId = Long.valueOf(idObj.toString());
                welfarePolicyRepository.findById(policyId).ifPresent(policy -> {
                    int status = item.get("checkStatus") != null
                            ? Integer.parseInt(item.get("checkStatus").toString()) : 1;
                    checks.add(PolicyCheck.builder()
                            .report(report)
                            .policy(policy)
                            .checkStatus(status)
                            .build());
                });
            }
            policyCheckRepository.saveAll(checks);
        }
    }

    private List<String> parseConditions(String json) {
        if (json == null || json.isBlank()) return List.of();
        try {
            return objectMapper.readValue(json, new TypeReference<List<String>>() {});
        } catch (Exception e) {
            return List.of(json);
        }
    }
}
