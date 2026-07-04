package com.pauly.AI_Care_Report_BE.compat.service;

import com.pauly.AI_Care_Report_BE.entity.User;
import com.pauly.AI_Care_Report_BE.entity.VisitReport;
import com.pauly.AI_Care_Report_BE.entity.WelfarePolicy;
import com.pauly.AI_Care_Report_BE.repository.UserRepository;
import com.pauly.AI_Care_Report_BE.repository.VisitReportRepository;
import com.pauly.AI_Care_Report_BE.repository.WelfarePolicyRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
// 명세서 호환 비즈니스 서비스
public class ApiCompatibilityService {

    private final UserRepository userRepository;
    private final VisitReportRepository visitReportRepository;
    private final WelfarePolicyRepository welfarePolicyRepository;

    @Transactional
    public Map<String, Object> updateUser(Long userId, Map<String, Object> body) {
        // 사용자 정보 수정
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다."));

        if (body.get("name") != null) user.setName(body.get("name").toString());
        if (body.get("phoneNumber") != null) user.setPhoneNumber(body.get("phoneNumber").toString());
        if (body.get("birthdate") != null) user.setBirthdate(body.get("birthdate").toString());
        if (body.get("role") != null) user.setRole(body.get("role").toString());
        if (body.get("gender") != null) user.setGender(Integer.valueOf(body.get("gender").toString()));
        if (body.get("permission") != null) user.setPermission(Integer.valueOf(body.get("permission").toString()));

        User saved = userRepository.save(user);
        return Map.of("status", true, "user_id", saved.getId());
    }

    @Transactional
    public Map<String, Object> deleteUser(Long userId) {
        // 사용자 삭제
        if (!userRepository.existsById(userId)) {
            throw new IllegalArgumentException("사용자를 찾을 수 없습니다.");
        }
        userRepository.deleteById(userId);
        return Map.of("status", true, "user_id", userId);
    }

    @Transactional
    public Map<String, Object> setUserToReport(Map<String, Object> body, String fallbackEmail) {
        // 보고서 담당자 지정
        Long reportId = toLong(body.get("reportid"));
        String email = body.get("email") != null ? body.get("email").toString() : fallbackEmail;

        VisitReport report = visitReportRepository.findById(reportId)
                .orElseThrow(() -> new IllegalArgumentException("보고서를 찾을 수 없습니다."));
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다."));

        report.setUser(user);
        visitReportRepository.save(report);
        return Map.of("status", true, "reportid", report.getId(), "email", user.getEmail());
    }

    public List<Map<String, Object>> getResultReportList(User user) {
        // 완료 보고서 목록 조회
        return visitReportRepository.findByUser(user).stream()
                .filter(report -> report.getReportstatus() != null && report.getReportstatus() == 2)
                .map(this::toReportMap)
                .toList();
    }

    @Transactional
    public Map<String, Object> updateVisitCategory(Map<String, Object> body) {
        // 카테고리 요약 저장
        Long reportId = toLong(body.get("reportid"));
        VisitReport report = visitReportRepository.findById(reportId)
                .orElseThrow(() -> new IllegalArgumentException("보고서를 찾을 수 없습니다."));
        if (body.get("txt_file") != null) {
            report.setSttText(body.get("txt_file").toString());
        }
        visitReportRepository.save(report);
        return Map.of("status", true, "reportid", reportId);
    }

    @Transactional
    public Map<String, Object> updateSttPath(Map<String, Object> body) {
        // STT 경로 저장
        Long reportId = toLong(body.get("reportid"));
        VisitReport report = visitReportRepository.findById(reportId)
                .orElseThrow(() -> new IllegalArgumentException("보고서를 찾을 수 없습니다."));
        String newPath = body.get("newPath") != null ? body.get("newPath").toString() : "";
        report.setSttText(newPath);
        visitReportRepository.save(report);
        return Map.of("status", true, "reportid", reportId, "path", newPath);
    }

    public Map<String, Object> getTranscriptPath(Long reportId, String email) {
        // STT 경로 조회
        VisitReport report = visitReportRepository.findById(reportId)
                .orElseThrow(() -> new IllegalArgumentException("보고서를 찾을 수 없습니다."));
        return Map.of("status", true, "reportid", reportId, "email", email != null ? email : "", "path", report.getSttText() != null ? report.getSttText() : "");
    }

    @Transactional
    public Map<String, Object> createPolicy(Map<String, Object> body) {
        // 복지정책 생성
        WelfarePolicy policy = WelfarePolicy.builder()
                .policyName(text(body, "policyName", "policy_name"))
                .shortDescription(text(body, "shortDescription", "short_description"))
                .detailedConditions(text(body, "detailedConditions", "detailed_conditions"))
                .link(text(body, "link"))
                .region(text(body, "region"))
                .build();
        WelfarePolicy saved = welfarePolicyRepository.save(policy);
        return Map.of("status", true, "policyId", saved.getId());
    }

    @Transactional
    public Map<String, Object> updatePolicy(Long policyId, Map<String, Object> body) {
        // 복지정책 수정
        WelfarePolicy policy = welfarePolicyRepository.findById(policyId)
                .orElseThrow(() -> new IllegalArgumentException("정책을 찾을 수 없습니다."));
        if (has(body, "policyName", "policy_name")) policy.setPolicyName(text(body, "policyName", "policy_name"));
        if (has(body, "shortDescription", "short_description")) policy.setShortDescription(text(body, "shortDescription", "short_description"));
        if (has(body, "detailedConditions", "detailed_conditions")) policy.setDetailedConditions(text(body, "detailedConditions", "detailed_conditions"));
        if (has(body, "link")) policy.setLink(text(body, "link"));
        if (has(body, "region")) policy.setRegion(text(body, "region"));
        welfarePolicyRepository.save(policy);
        return Map.of("status", true, "policyId", policyId);
    }

    @Transactional
    public Map<String, Object> deletePolicy(Long policyId) {
        // 복지정책 삭제
        if (!welfarePolicyRepository.existsById(policyId)) {
            throw new IllegalArgumentException("정책을 찾을 수 없습니다.");
        }
        welfarePolicyRepository.deleteById(policyId);
        return Map.of("status", true, "policyId", policyId);
    }

    public Map<String, Object> pending(String feature, Map<String, Object> payload) {
        // 미구현 기능 응답
        Map<String, Object> response = new HashMap<>();
        response.put("status", false);
        response.put("feature", feature);
        response.put("message", "현재 백엔드 엔티티가 없어 호환 API만 추가된 상태입니다.");
        response.put("data", payload != null ? payload : Map.of());
        return response;
    }

    private Map<String, Object> toReportMap(VisitReport report) {
        // 보고서 응답 변환
        Map<String, Object> item = new HashMap<>();
        item.put("reportid", report.getId());
        item.put("visittime", report.getVisittime());
        item.put("reportstatus", report.getReportstatus());
        item.put("visittype", report.getVisittype());
        item.put("detail", report.getDetail());
        return item;
    }

    private Long toLong(Object value) {
        // 숫자 변환
        if (value == null) {
            throw new IllegalArgumentException("필수 ID 값이 없습니다.");
        }
        return Long.valueOf(value.toString());
    }

    private boolean has(Map<String, Object> body, String... keys) {
        // 키 존재 확인
        for (String key : keys) {
            if (body.containsKey(key)) return true;
        }
        return false;
    }

    private String text(Map<String, Object> body, String... keys) {
        // 문자열 추출
        for (String key : keys) {
            Object value = body.get(key);
            if (value != null) return value.toString();
        }
        return "";
    }
}
