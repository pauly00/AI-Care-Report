package com.pauly.AI_Care_Report_BE.repository;

import com.pauly.AI_Care_Report_BE.entity.WelfarePolicy;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface WelfarePolicyRepository extends JpaRepository<WelfarePolicy, Long> {

    List<WelfarePolicy> findByRegion(String region);
}
