package com.pauly.AI_Care_Report_BE.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
// Swagger API 문서 설정
public class OpenApiConfig {

    @Bean
    public OpenAPI openAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("AI-Care-Report Backend API")
                        .description("독거노인 방문 관리와 AI 상담 리포트 생성을 위한 백엔드 API")
                        .version("v1"));
    }
}
