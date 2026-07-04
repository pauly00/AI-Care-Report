package com.pauly.AI_Care_Report_BE.compat.controller;

import com.pauly.AI_Care_Report_BE.compat.service.ApiCompatibilityService;
import com.pauly.AI_Care_Report_BE.entity.User;
import com.pauly.AI_Care_Report_BE.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/db")
@RequiredArgsConstructor
// 명세서 호환 API 컨트롤러
public class ApiCompatibilityController {

    private final ApiCompatibilityService apiCompatibilityService;
    private final UserRepository userRepository;

    @GetMapping("/getYangChunConverstationSTTtxt/{reportid}")
    public ResponseEntity<?> getYangChunSttText(@PathVariable Long reportid) {
        // 양천 STT 원문 조회 API
        return ResponseEntity.ok(apiCompatibilityService.pending("yangchun-stt-text", Map.of("reportid", reportid)));
    }

    @GetMapping("/yangchun_getResultList")
    public ResponseEntity<?> getYangChunResultList() {
        // 양천 STT 결과 목록 API
        return ResponseEntity.ok(apiCompatibilityService.pending("yangchun-result-list", Map.of()));
    }

    @GetMapping("/yangchun_stt_abstract/{id}")
    public ResponseEntity<?> getYangChunSttAbstract(@PathVariable Long id) {
        // 양천 STT 요약 API
        return ResponseEntity.ok(apiCompatibilityService.pending("yangchun-stt-abstract", Map.of("id", id)));
    }

    @PatchMapping("/update_stt_path")
    public ResponseEntity<?> updateSttPath(@RequestBody Map<String, Object> body) {
        // STT 경로 수정 API
        return ResponseEntity.ok(apiCompatibilityService.updateSttPath(body));
    }

    @GetMapping("/get_transcript_path")
    public ResponseEntity<?> getTranscriptPath(@RequestParam Long reportid,
                                               @RequestParam(required = false) String email) {
        // STT 경로 조회 API
        return ResponseEntity.ok(apiCompatibilityService.getTranscriptPath(reportid, email));
    }

    @GetMapping("/getResultReportList")
    public ResponseEntity<?> getResultReportList(@AuthenticationPrincipal UserDetails userDetails) {
        // 완료 보고서 목록 API
        return ResponseEntity.ok(apiCompatibilityService.getResultReportList(getUser(userDetails)));
    }

    @PostMapping("/update_visit_category")
    public ResponseEntity<?> updateVisitCategory(@RequestBody Map<String, Object> body) {
        // 카테고리 요약 저장 API
        return ResponseEntity.ok(apiCompatibilityService.updateVisitCategory(body));
    }

    @PostMapping("/setUserToReport")
    public ResponseEntity<?> setUserToReport(@RequestBody Map<String, Object> body,
                                             @AuthenticationPrincipal UserDetails userDetails) {
        // 보고서 담당자 지정 API
        String email = userDetails != null ? userDetails.getUsername() : "";
        return ResponseEntity.ok(apiCompatibilityService.setUserToReport(body, email));
    }

    @PutMapping("/users/{userId}")
    public ResponseEntity<?> updateUser(@PathVariable Long userId,
                                        @RequestBody Map<String, Object> body) {
        // 사용자 수정 API
        return ResponseEntity.ok(apiCompatibilityService.updateUser(userId, body));
    }

    @DeleteMapping("/users/{userId}")
    public ResponseEntity<?> deleteUser(@PathVariable Long userId) {
        // 사용자 삭제 API
        return ResponseEntity.ok(apiCompatibilityService.deleteUser(userId));
    }

    @GetMapping("/clients/{clientId}")
    public ResponseEntity<?> getClient(@PathVariable Long clientId) {
        // 클라이언트 조회 API
        return ResponseEntity.ok(apiCompatibilityService.pending("client-read", Map.of("clientId", clientId)));
    }

    @PostMapping("/clients")
    public ResponseEntity<?> createClient(@RequestBody Map<String, Object> body) {
        // 클라이언트 생성 API
        return ResponseEntity.ok(apiCompatibilityService.pending("client-create", body));
    }

    @PutMapping("/clients/{clientId}")
    public ResponseEntity<?> updateClient(@PathVariable Long clientId,
                                          @RequestBody Map<String, Object> body) {
        // 클라이언트 수정 API
        return ResponseEntity.ok(apiCompatibilityService.pending("client-update", Map.of("clientId", clientId, "body", body)));
    }

    @DeleteMapping("/clients/{clientId}")
    public ResponseEntity<?> deleteClient(@PathVariable Long clientId) {
        // 클라이언트 삭제 API
        return ResponseEntity.ok(apiCompatibilityService.pending("client-delete", Map.of("clientId", clientId)));
    }

    @PostMapping("/policies")
    public ResponseEntity<?> createPolicy(@RequestBody Map<String, Object> body) {
        // 정책 생성 API
        return ResponseEntity.ok(apiCompatibilityService.createPolicy(body));
    }

    @PutMapping("/policies/{policyId}")
    public ResponseEntity<?> updatePolicy(@PathVariable Long policyId,
                                          @RequestBody Map<String, Object> body) {
        // 정책 수정 API
        return ResponseEntity.ok(apiCompatibilityService.updatePolicy(policyId, body));
    }

    @DeleteMapping("/policies/{policyId}")
    public ResponseEntity<?> deletePolicy(@PathVariable Long policyId) {
        // 정책 삭제 API
        return ResponseEntity.ok(apiCompatibilityService.deletePolicy(policyId));
    }

    @PutMapping("/welfare-policies/{userId}")
    public ResponseEntity<?> updateUserWelfarePolicies(@PathVariable Long userId,
                                                       @RequestBody Map<String, Object> body) {
        // 사용자 복지정책 수정 API
        return ResponseEntity.ok(apiCompatibilityService.pending("user-welfare-policy-update", Map.of("userId", userId, "body", body)));
    }

    @GetMapping("/welfare-datas/{userId}")
    public ResponseEntity<?> getWelfareDatas(@PathVariable Long userId) {
        // 처리 완료 복지데이터 조회 API
        return ResponseEntity.ok(apiCompatibilityService.pending("welfare-data-read", Map.of("userId", userId)));
    }

    @PutMapping("/welfare-datas/{userId}")
    public ResponseEntity<?> updateWelfareDatas(@PathVariable Long userId,
                                                @RequestBody Map<String, Object> body) {
        // 복지데이터 수정 API
        return ResponseEntity.ok(apiCompatibilityService.pending("welfare-data-update", Map.of("userId", userId, "body", body)));
    }

    @PostMapping("/yangchun_stt_upload")
    public ResponseEntity<?> uploadYangChunStt(@RequestBody Map<String, Object> body) {
        // 양천 STT 업로드 API
        return ResponseEntity.ok(apiCompatibilityService.pending("yangchun-stt-upload", body));
    }

    @PostMapping("/yangchun_stt_upload_policy")
    public ResponseEntity<?> uploadYangChunSttPolicy(@RequestBody Map<String, Object> body) {
        // 양천 STT 정책 업로드 API
        return ResponseEntity.ok(apiCompatibilityService.pending("yangchun-stt-upload-policy", body));
    }

    @PostMapping("/yangchun_idcard_info_upload")
    public ResponseEntity<?> uploadYangChunIdCardInfo(@RequestBody Map<String, Object> body) {
        // 양천 ID 카드 신청정보 API
        return ResponseEntity.ok(apiCompatibilityService.pending("yangchun-idcard-info-upload", body));
    }

    @GetMapping("/conversation-summary/{summaryId}")
    public ResponseEntity<?> getConversationSummary(@PathVariable Long summaryId) {
        // STT 요약 조회 API
        return ResponseEntity.ok(apiCompatibilityService.pending("conversation-summary-read", Map.of("summaryId", summaryId)));
    }

    @PostMapping("/uploadImages/compat")
    public ResponseEntity<?> uploadImagesCompat(@RequestParam(required = false) Long reportid,
                                                @RequestParam(required = false) List<MultipartFile> images) {
        // 이미지 업로드 호환 API
        return ResponseEntity.ok(apiCompatibilityService.pending("image-upload-compat", Map.of("reportid", reportid != null ? reportid : 0)));
    }

    private User getUser(UserDetails userDetails) {
        // 인증 사용자 조회
        return userRepository.findByEmail(userDetails.getUsername())
                .orElseThrow(() -> new IllegalStateException("인증 사용자를 찾을 수 없습니다."));
    }
}
