package com.pauly.AI_Care_Report_BE.controller;

import com.pauly.AI_Care_Report_BE.dto.TargetInfoResponse;
import com.pauly.AI_Care_Report_BE.dto.TargetRequest;
import com.pauly.AI_Care_Report_BE.entity.Target;
import com.pauly.AI_Care_Report_BE.entity.User;
import com.pauly.AI_Care_Report_BE.repository.UserRepository;
import com.pauly.AI_Care_Report_BE.service.TargetService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/db")
@RequiredArgsConstructor
// 대상자 API 컨트롤러
public class TargetController {

    private final TargetService targetService;
    private final UserRepository userRepository;

    // 대상자 등록 API
    @PostMapping("/addTarget")
    public ResponseEntity<?> addTarget(@RequestBody TargetRequest request,
                                       @AuthenticationPrincipal UserDetails userDetails) {
        User user = getUser(userDetails);
        Target target = targetService.addTarget(request, user);
        return ResponseEntity.ok(Map.of("status", true, "targetid", target.getId()));
    }

    // 대상자 목록 조회 API
    @GetMapping("/getAllTargets")
    public ResponseEntity<List<Target>> getAllTargets(@AuthenticationPrincipal UserDetails userDetails) {
        User user = getUser(userDetails);
        return ResponseEntity.ok(targetService.getAllTargets(user));
    }

    // 대상자 상세 조회 API
    @GetMapping("/getTargetInfo/{id}")
    public ResponseEntity<?> getTargetInfo(@PathVariable Long id) {
        try {
            TargetInfoResponse response = targetService.getTargetInfo(id);
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(404).body(Map.of("message", e.getMessage()));
        }
    }

    private User getUser(UserDetails userDetails) {
        return userRepository.findByEmail(userDetails.getUsername())
                .orElseThrow(() -> new IllegalStateException("인증된 사용자를 찾을 수 없습니다."));
    }
}
