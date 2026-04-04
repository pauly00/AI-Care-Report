package com.pauly.AI_Care_Report_BE.repository;

import com.pauly.AI_Care_Report_BE.entity.VisitReport;
import com.pauly.AI_Care_Report_BE.entity.VisitSummary;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface VisitSummaryRepository extends JpaRepository<VisitSummary, Long> {

    List<VisitSummary> findByReport(VisitReport report);

    void deleteByReport(VisitReport report);
}
