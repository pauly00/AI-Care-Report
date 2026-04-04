package com.pauly.AI_Care_Report_BE.controller;

import com.pauly.AI_Care_Report_BE.dto.LoginRequest;
import com.pauly.AI_Care_Report_BE.dto.RegisterRequest;
import com.pauly.AI_Care_Report_BE.dto.UserResponse;
import com.pauly.AI_Care_Report_BE.entity.User;
import com.pauly.AI_Care_Report_BE.repository.UserRepository;
import com.pauly.AI_Care_Report_BE.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/db")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;
    private final UserRepository userRepository;

    // POST /db/login
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest request) {
        try {
            Map<String, Object> result = authService.login(request);
            return ResponseEntity.ok(result);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(401).body(Map.of("status", false, "message", e.getMessage()));
        }
    }

    // POST /db/register
    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody RegisterRequest request) {
        try {
            Map<String, Object> result = authService.register(request);
            return ResponseEntity.ok(result);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("status", false, "msg", e.getMessage()));
        }
    }

    // POST /db/email_check
    @PostMapping("/email_check")
    public ResponseEntity<?> emailCheck(@RequestBody Map<String, String> body) {
        String email = body.get("email");
        boolean available = authService.isEmailAvailable(email);
        return ResponseEntity.ok(Map.of(
                "status", available,
                "message", available ? "사용 가능한 이메일입니다." : "이미 사용 중인 이메일입니다."
        ));
    }

    // GET /db/users (JWT 필요 - 내 정보 조회)
    @GetMapping("/users")
    public ResponseEntity<?> getMyInfo(@AuthenticationPrincipal UserDetails userDetails) {
        try {
            UserResponse user = authService.getUserByEmail(userDetails.getUsername());
            return ResponseEntity.ok(user);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(404).body(Map.of("message", e.getMessage()));
        }
    }
}
