package com.pauly.AI_Care_Report_BE.repository;

import com.pauly.AI_Care_Report_BE.entity.WelfarePolicy;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

// 복지정책 데이터 접근 인터페이스
public interface WelfarePolicyRepository extends JpaRepository<WelfarePolicy, Long> {

    List<WelfarePolicy> findByRegion(String region);
}
