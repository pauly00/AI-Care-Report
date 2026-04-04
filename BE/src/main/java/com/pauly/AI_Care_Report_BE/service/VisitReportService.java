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
public class VisitReportService {

    private final VisitReportRepository visitReportRepository;
    private final VisitSummaryRepository visitSummaryRepository;
    private final TargetRepository targetRepository;
    private final UserRepository userRepository;

    @Value("${app.upload.dir:uploads}")
    private String uploadDir;

    // 방문 보고서 생성
    public VisitReport addVisitReport(VisitReportRequest request, User currentUser) {
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

    // 모든 방문 보고서 조회 (FE: getAllVisitReports, getDefaultReportList)
    public List<VisitReportResponse> getAllVisitReports(User user) {
        return visitReportRepository.findByUser(user).stream()
                .map(VisitReportResponse::from)
                .collect(Collectors.toList());
    }

    // 오늘 방문 목록 조회 (FE: getTodayList)
    public List<Map<String, Object>> getTodayList(User user) {
        String today = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        List<VisitReport> reports = visitReportRepository
                .findByUserAndVisittimeStartingWith(user, today);

        return reports.stream().map(report -> {
            Map<String, Object> item = new HashMap<>();
            item.put("reportid", report.getId());
            item.put("visitTime", report.getVisittime());
            item.put("visitType", report.getVisittype() != null ? report.getVisittype() : 0);

            if (report.getTarget() != null) {
                item.put("name", report.getTarget().getTargetname());
                item.put("address", report.getTarget().getAddress1());
                item.put("callNum", report.getTarget().getTargetcallnum());
            } else {
                item.put("name", "");
                item.put("address", "");
                item.put("callNum", "");
            }
            return item;
        }).collect(Collectors.toList());
    }

    // 기본 보고서 정보 업로드
    @Transactional
    public Map<String, Object> uploadDefaultReport(UploadDefaultReportRequest request) {
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

    // 방문 상세 내용(특이사항) 업로드
    @Transactional
    public void uploadVisitDetail(UploadVisitDetailRequest request) {
        VisitReport report = visitReportRepository.findById(request.getReportid())
                .orElseThrow(() -> new IllegalArgumentException("보고서를 찾을 수 없습니다."));
        report.setDetail(request.getDetail());
        visitReportRepository.save(report);
    }

    // 상담 완료 처리
    @Transactional
    public void markDone(Long reportId) {
        VisitReport report = visitReportRepository.findById(reportId)
                .orElseThrow(() -> new IllegalArgumentException("보고서를 찾을 수 없습니다."));
        report.setReportstatus(2);
        visitReportRepository.save(report);
    }

    // 녹음 파일 업로드 (STT는 추후 구현)
    public void uploadCallRecord(Long reportId, MultipartFile audioFile) throws IOException {
        VisitReport report = visitReportRepository.findById(reportId)
                .orElseThrow(() -> new IllegalArgumentException("보고서를 찾을 수 없습니다."));

        // 업로드 디렉토리 생성 및 파일 저장
        File dir = new File(uploadDir + "/audio");
        if (!dir.exists()) dir.mkdirs();

        String filename = "report_" + reportId + "_" + audioFile.getOriginalFilename();
        audioFile.transferTo(new File(dir, filename));

        // STT 변환 로직 자리 (실제 STT 서비스 연동 시 여기에 구현)
        report.setSttText("[STT 변환 대기 중 - 파일: " + filename + "]");
        visitReportRepository.save(report);
    }

    // STT 텍스트 조회
    public String getSttText(Long reportId) {
        VisitReport report = visitReportRepository.findById(reportId)
                .orElseThrow(() -> new IllegalArgumentException("보고서를 찾을 수 없습니다."));
        return report.getSttText() != null ? report.getSttText() : "";
    }

    // 방문 요약(AI 분석) 조회
    public Map<String, Object> getVisitDetails(Long reportId) {
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

    // 요약 수정 내용 업로드
    @Transactional
    public void uploadEditAbstract(UploadSummaryRequest request) {
        VisitReport report = visitReportRepository.findById(request.getReportid())
                .orElseThrow(() -> new IllegalArgumentException("보고서를 찾을 수 없습니다."));

        // 기존 요약 삭제 후 재저장
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

    // 이미지 업로드
    public void uploadImages(Long reportId, List<MultipartFile> images) throws IOException {
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
