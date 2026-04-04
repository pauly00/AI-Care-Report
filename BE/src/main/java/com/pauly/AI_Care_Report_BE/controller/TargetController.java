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
public class TargetController {

    private final TargetService targetService;
    private final UserRepository userRepository;

    // POST /db/addTarget
    @PostMapping("/addTarget")
    public ResponseEntity<?> addTarget(@RequestBody TargetRequest request,
                                       @AuthenticationPrincipal UserDetails userDetails) {
        User user = getUser(userDetails);
        Target target = targetService.addTarget(request, user);
        return ResponseEntity.ok(Map.of("status", true, "targetid", target.getId()));
    }

    // GET /db/getAllTargets
    @GetMapping("/getAllTargets")
    public ResponseEntity<List<Target>> getAllTargets(@AuthenticationPrincipal UserDetails userDetails) {
        User user = getUser(userDetails);
        return ResponseEntity.ok(targetService.getAllTargets(user));
    }

    // GET /db/getTargetInfo/:id
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
