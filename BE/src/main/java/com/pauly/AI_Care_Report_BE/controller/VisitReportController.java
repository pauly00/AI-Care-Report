package com.pauly.AI_Care_Report_BE.controller;

import com.pauly.AI_Care_Report_BE.dto.*;
import com.pauly.AI_Care_Report_BE.entity.User;
import com.pauly.AI_Care_Report_BE.entity.VisitReport;
import com.pauly.AI_Care_Report_BE.repository.UserRepository;
import com.pauly.AI_Care_Report_BE.service.VisitReportService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/db")
@RequiredArgsConstructor
public class VisitReportController {

    private final VisitReportService visitReportService;
    private final UserRepository userRepository;

    // POST /db/addVisitReport
    @PostMapping("/addVisitReport")
    public ResponseEntity<?> addVisitReport(@RequestBody VisitReportRequest request,
                                             @AuthenticationPrincipal UserDetails userDetails) {
        try {
            User user = getUser(userDetails);
            VisitReport report = visitReportService.addVisitReport(request, user);
            return ResponseEntity.ok(Map.of("status", true, "reportid", report.getId()));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("status", false, "message", e.getMessage()));
        }
    }

    // GET /db/getAllVisitReports
    @GetMapping("/getAllVisitReports")
    public ResponseEntity<List<VisitReportResponse>> getAllVisitReports(
            @AuthenticationPrincipal UserDetails userDetails) {
        User user = getUser(userDetails);
        return ResponseEntity.ok(visitReportService.getAllVisitReports(user));
    }

    // GET /db/getDefaultReportList (보고서 작성 화면용 - 미완료 목록)
    @GetMapping("/getDefaultReportList")
    public ResponseEntity<List<VisitReportResponse>> getDefaultReportList(
            @AuthenticationPrincipal UserDetails userDetails) {
        User user = getUser(userDetails);
        return ResponseEntity.ok(visitReportService.getAllVisitReports(user));
    }

    // GET /db/getTodayList
    @GetMapping("/getTodayList")
    public ResponseEntity<List<Map<String, Object>>> getTodayList(
            @AuthenticationPrincipal UserDetails userDetails) {
        User user = getUser(userDetails);
        return ResponseEntity.ok(visitReportService.getTodayList(user));
    }

    // POST /db/getTodayList (today_visit_service.dart 에서 POST로 호출)
    @PostMapping("/getTodayList")
    public ResponseEntity<List<Map<String, Object>>> getTodayListPost(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestBody(required = false) Map<String, Object> body) {
        User user = getUser(userDetails);
        return ResponseEntity.ok(visitReportService.getTodayList(user));
    }

    // POST /db/uploadReportDefaultInfo
    @PostMapping("/uploadReportDefaultInfo")
    public ResponseEntity<?> uploadDefaultReport(@RequestBody UploadDefaultReportRequest request) {
        try {
            Map<String, Object> result = visitReportService.uploadDefaultReport(request);
            return ResponseEntity.ok(result);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("status", false, "message", e.getMessage()));
        }
    }

    // POST /db/uploadVisitDetail
    @PostMapping("/uploadVisitDetail")
    public ResponseEntity<?> uploadVisitDetail(@RequestBody UploadVisitDetailRequest request) {
        try {
            visitReportService.uploadVisitDetail(request);
            return ResponseEntity.ok(Map.of("status", true, "message", "특이사항 저장 완료"));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("status", false, "message", e.getMessage()));
        }
    }

    // GET /db/visitReportDone?reportid=X
    @GetMapping("/visitReportDone")
    public ResponseEntity<?> visitReportDone(@RequestParam Long reportid) {
        try {
            visitReportService.markDone(reportid);
            return ResponseEntity.ok(Map.of("status", true, "message", "상담 완료 처리됨"));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("status", false, "message", e.getMessage()));
        }
    }

    // POST /db/uploadCallRecord (multipart)
    @PostMapping("/uploadCallRecord")
    public ResponseEntity<?> uploadCallRecord(@RequestParam("reportid") Long reportId,
                                               @RequestParam("audiofile") MultipartFile audioFile) {
        try {
            visitReportService.uploadCallRecord(reportId, audioFile);
            return ResponseEntity.ok(Map.of("status", true, "message", "녹음 파일 업로드 완료"));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("status", false, "message", e.getMessage()));
        } catch (IOException e) {
            return ResponseEntity.status(500).body(Map.of("status", false, "message", "파일 저장 실패"));
        }
    }

    // GET /db/getConverstationSTTtxt/:id
    @GetMapping("/getConverstationSTTtxt/{id}")
    public ResponseEntity<?> getSttText(@PathVariable Long id) {
        try {
            String sttText = visitReportService.getSttText(id);
            return ResponseEntity.ok(sttText);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(404).body(e.getMessage());
        }
    }

    // GET /db/getVisitDetails/:id (요약 정보 조회)
    @GetMapping("/getVisitDetails/{id}")
    public ResponseEntity<?> getVisitDetails(@PathVariable Long id) {
        try {
            Map<String, Object> result = visitReportService.getVisitDetails(id);
            return ResponseEntity.ok(result);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(404).body(Map.of("message", e.getMessage()));
        }
    }

    // POST /db/uploadEditAbstract (요약 수정 저장)
    @PostMapping("/uploadEditAbstract")
    public ResponseEntity<?> uploadEditAbstract(@RequestBody UploadSummaryRequest request) {
        try {
            visitReportService.uploadEditAbstract(request);
            return ResponseEntity.ok(Map.of("status", true, "message", "요약 저장 완료"));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("status", false, "message", e.getMessage()));
        }
    }

    // POST /db/uploadImages (multipart)
    @PostMapping("/uploadImages")
    public ResponseEntity<?> uploadImages(@RequestParam("reportid") Long reportId,
                                          @RequestParam("images") List<MultipartFile> images) {
        try {
            visitReportService.uploadImages(reportId, images);
            return ResponseEntity.ok(Map.of("status", true, "message", "이미지 업로드 완료"));
        } catch (IOException e) {
            return ResponseEntity.status(500).body(Map.of("status", false, "message", "이미지 저장 실패"));
        }
    }

    private User getUser(UserDetails userDetails) {
        return userRepository.findByEmail(userDetails.getUsername())
                .orElseThrow(() -> new IllegalStateException("인증된 사용자를 찾을 수 없습니다."));
    }
}
