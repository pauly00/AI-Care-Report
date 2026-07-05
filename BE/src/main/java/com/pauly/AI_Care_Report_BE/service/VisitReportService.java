package com.pauly.AI_Care_Report_BE.service;

import com.pauly.AI_Care_Report_BE.dto.*;
import com.pauly.AI_Care_Report_BE.entity.*;
import com.pauly.AI_Care_Report_BE.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
// 방문 보고서 비즈니스 서비스
public class VisitReportService {

    private final VisitReportRepository visitReportRepository;
    private final VisitSummaryRepository visitSummaryRepository;
    private final TargetRepository targetRepository;
    private final UserRepository userRepository;

    @Value("${app.upload.dir:uploads}")
    private String uploadDir;

    public VisitReport addVisitReport(VisitReportRequest request, User currentUser) {
        // 방문 보고서 생성
        Target target = targetRepository.findById(request.getTargetid())
                .orElseThrow(() -> new IllegalArgumentException("대상자를 찾을 수 없습니다."));

        User assignedUser = currentUser;
        if (request.getEmail() != null && !request.getEmail().equals(currentUser.getEmail())) {
            assignedUser = userRepository.findByEmail(request.getEmail())
                    .orElse(currentUser);
        }

        VisitReport report = VisitReport.builder()
                .target(target)
                .user(assignedUser)
                .visittime(request.getVisittime())
                .reportstatus(0)
                .build();

        return visitReportRepository.save(report);
    }

    public List<VisitReportResponse> getAllVisitReports(User user) {
        // 방문 보고서 목록 조회
        return visitReportRepository.findByUser(user).stream()
                .map(VisitReportResponse::from)
                .collect(Collectors.toList());
    }

    public List<VisitReportResponse> getDefaultReportList(User user) {
        // 미작성 보고서 목록 조회
        return visitReportRepository.findByUser(user).stream()
                .filter(report -> report.getReportstatus() == null || report.getReportstatus() < 2)
                .map(VisitReportResponse::from)
                .collect(Collectors.toList());
    }

    public List<Map<String, Object>> getTodayList(User user) {
        // 오늘 방문 목록 조회
        String today = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        List<VisitReport> reports = visitReportRepository
                .findByUserAndVisittimeStartingWith(user, today).stream()
                .filter(report -> report.getReportstatus() == null || report.getReportstatus() < 2)
                .sorted(Comparator.comparing(VisitReport::getVisittime, Comparator.nullsLast(String::compareTo)))
                .collect(Collectors.toList());

        return reports.stream().map(report -> {
            Map<String, Object> item = new HashMap<>();
            Integer visitTypeCode = toVisitTypeCode(report.getVisittype());

            item.put("reportid", report.getId());
            item.put("visitTime", report.getVisittime());
            item.put("visittime", report.getVisittime());
            item.put("reportstatus", report.getReportstatus() != null ? report.getReportstatus() : 0);
            item.put("visitType", visitTypeCode);
            item.put("visittype", visitTypeCode);

            if (report.getTarget() != null) {
                item.put("name", report.getTarget().getTargetname());
                item.put("address", report.getTarget().getAddress1());
                item.put("callNum", report.getTarget().getTargetcallnum());

                Map<String, Object> targetInfo = new HashMap<>();
                targetInfo.put("targetid", report.getTarget().getId());
                targetInfo.put("targetname", report.getTarget().getTargetname() != null ? report.getTarget().getTargetname() : "");
                targetInfo.put("address1", report.getTarget().getAddress1() != null ? report.getTarget().getAddress1() : "");
                targetInfo.put("address2", report.getTarget().getAddress2() != null ? report.getTarget().getAddress2() : "");
                targetInfo.put("targetcallnum", report.getTarget().getTargetcallnum() != null ? report.getTarget().getTargetcallnum() : "");
                targetInfo.put("gender", report.getTarget().getGender() != null ? report.getTarget().getGender() : 0);
                targetInfo.put("age", report.getTarget().getAge() != null ? report.getTarget().getAge() : 0);
                item.put("targetInfo", targetInfo);
            } else {
                item.put("name", "");
                item.put("address", "");
                item.put("callNum", "");
                item.put("targetInfo", Map.of());
            }
            return item;
        }).collect(Collectors.toList());
    }

    private Integer toVisitTypeCode(String visitType) {
        if (visitType == null || visitType.isBlank()) {
            return 1;
        }

        if ("전화돌봄".equals(visitType)) {
            return 0;
        }
        if ("현장돌봄".equals(visitType) || "방문돌봄".equals(visitType)) {
            return 1;
        }

        try {
            return Integer.parseInt(visitType);
        } catch (NumberFormatException e) {
            return 1;
        }
    }

    @Transactional
    public Map<String, Object> uploadDefaultReport(UploadDefaultReportRequest request) {
        // 기본 보고서 정보 저장
        VisitReport report = visitReportRepository.findById(request.getReportid())
                .orElseThrow(() -> new IllegalArgumentException("보고서를 찾을 수 없습니다."));

        if (request.getReportstatus() != null) {
            report.setReportstatus(request.getReportstatus());
        }
        if (request.getVisittime() != null) {
            report.setVisittime(request.getVisittime());
        }
        if (request.getVisitType() != null) {
            report.setVisittype(request.getVisitType());
        }
        if (request.getEndTime() != null) {
            report.setEndtime(request.getEndTime());
        }

        visitReportRepository.save(report);
        return Map.of("status", true, "message", "기본 보고서 정보 저장 완료");
    }

    @Transactional
    public void uploadVisitDetail(UploadVisitDetailRequest request) {
        // 방문 상세 내용 저장
        VisitReport report = visitReportRepository.findById(request.getReportid())
                .orElseThrow(() -> new IllegalArgumentException("보고서를 찾을 수 없습니다."));
        report.setDetail(request.getDetail());
        visitReportRepository.save(report);
    }

    @Transactional
    public void markDone(Long reportId) {
        // 상담 완료 처리
        VisitReport report = visitReportRepository.findById(reportId)
                .orElseThrow(() -> new IllegalArgumentException("보고서를 찾을 수 없습니다."));
        report.setReportstatus(2);
        visitReportRepository.save(report);
    }

    public void uploadCallRecord(Long reportId, MultipartFile audioFile) throws IOException {
        // 녹음 파일 업로드
        VisitReport report = visitReportRepository.findById(reportId)
                .orElseThrow(() -> new IllegalArgumentException("보고서를 찾을 수 없습니다."));

        // 업로드 디렉터리 생성
        File dir = new File(uploadDir + "/audio");
        if (!dir.exists()) dir.mkdirs();

        String filename = "report_" + reportId + "_" + audioFile.getOriginalFilename();
        audioFile.transferTo(new File(dir, filename));

        // STT 연동 대기값
        report.setSttText("[STT 변환 대기 중 - 파일: " + filename + "]");
        visitReportRepository.save(report);
    }

    public String getSttText(Long reportId) {
        // STT 텍스트 조회
        VisitReport report = visitReportRepository.findById(reportId)
                .orElseThrow(() -> new IllegalArgumentException("보고서를 찾을 수 없습니다."));
        return report.getSttText() != null ? report.getSttText() : "";
    }

    public Map<String, Object> getVisitDetails(Long reportId) {
        // 방문 요약 조회
        VisitReport report = visitReportRepository.findById(reportId)
                .orElseThrow(() -> new IllegalArgumentException("보고서를 찾을 수 없습니다."));

        List<VisitSummary> summaries = visitSummaryRepository.findByReport(report);

        List<Map<String, String>> items = summaries.stream().map(s -> {
            Map<String, String> item = new HashMap<>();
            item.put("subject", s.getSubject() != null ? s.getSubject() : "");
            item.put("abstract", s.getSummaryText() != null ? s.getSummaryText() : "");
            item.put("detail", s.getDetail() != null ? s.getDetail() : "");
            return item;
        }).collect(Collectors.toList());

        return Map.of("reportid", reportId, "items", items);
    }

    @Transactional
    public void uploadEditAbstract(UploadSummaryRequest request) {
        // 요약 수정 저장
        VisitReport report = visitReportRepository.findById(request.getReportid())
                .orElseThrow(() -> new IllegalArgumentException("보고서를 찾을 수 없습니다."));

        // 기존 요약 재저장
        visitSummaryRepository.deleteByReport(report);

        if (request.getItems() != null) {
            List<VisitSummary> summaries = request.getItems().stream().map(item ->
                    VisitSummary.builder()
                            .report(report)
                            .subject(item.get("subject"))
                            .summaryText(item.get("abstract"))
                            .detail(item.get("detail"))
                            .build()
            ).collect(Collectors.toList());
            visitSummaryRepository.saveAll(summaries);
        }
    }

    public void uploadImages(Long reportId, List<MultipartFile> images) throws IOException {
        // 이미지 업로드
        visitReportRepository.findById(reportId)
                .orElseThrow(() -> new IllegalArgumentException("보고서를 찾을 수 없습니다."));

        File dir = new File(uploadDir + "/images/report_" + reportId);
        if (!dir.exists()) dir.mkdirs();

        for (MultipartFile image : images) {
            String filename = System.currentTimeMillis() + "_" + image.getOriginalFilename();
            image.transferTo(new File(dir, filename));
        }
    }
}
