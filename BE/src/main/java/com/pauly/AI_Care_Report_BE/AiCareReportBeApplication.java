package com.pauly.AI_Care_Report_BE;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;

@SpringBootApplication
// 백엔드 애플리케이션 진입점
public class AiCareReportBeApplication {
	public static void main(String[] args) {
		SpringApplication.run(AiCareReportBeApplication.class, args);
	}
}
