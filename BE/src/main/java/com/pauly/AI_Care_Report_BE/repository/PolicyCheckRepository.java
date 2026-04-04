package com.pauly.AI_Care_Report_BE.repository;

import com.pauly.AI_Care_Report_BE.entity.PolicyCheck;
import com.pauly.AI_Care_Report_BE.entity.VisitReport;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PolicyCheckRepository extends JpaRepository<PolicyCheck, Long> {

    List<PolicyCheck> findByReport(VisitReport report);

    void deleteByReport(VisitReport report);
}
