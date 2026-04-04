package com.pauly.AI_Care_Report_BE.repository;

import com.pauly.AI_Care_Report_BE.entity.User;
import com.pauly.AI_Care_Report_BE.entity.VisitReport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface VisitReportRepository extends JpaRepository<VisitReport, Long> {

    List<VisitReport> findByUser(User user);

    List<VisitReport> findByUserAndReportstatusNot(User user, Integer reportstatus);

    @Query("SELECT v FROM VisitReport v WHERE v.user = :user AND v.visittime LIKE :datePrefix%")
    List<VisitReport> findByUserAndVisittimeStartingWith(@Param("user") User user, @Param("datePrefix") String datePrefix);
}
