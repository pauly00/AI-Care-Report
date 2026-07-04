package com.pauly.AI_Care_Report_BE.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.Instant;
import java.util.Map;

@RestController
// Render 배포 확인 API
public class HealthController {

    @GetMapping({"/", "/api/hello"})
    public Map<String, Object> hello() {
        return Map.of(
                "service", "AI-Care-Report Backend",
                "message", "Render 백엔드 배포 완료",
                "status", "ok",
                "timestamp", Instant.now().toString()
        );
    }
}
