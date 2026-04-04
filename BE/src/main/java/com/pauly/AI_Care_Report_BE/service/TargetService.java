package com.pauly.AI_Care_Report_BE.service;

import com.pauly.AI_Care_Report_BE.dto.TargetInfoResponse;
import com.pauly.AI_Care_Report_BE.dto.TargetRequest;
import com.pauly.AI_Care_Report_BE.entity.Target;
import com.pauly.AI_Care_Report_BE.entity.User;
import com.pauly.AI_Care_Report_BE.entity.VisitReport;
import com.pauly.AI_Care_Report_BE.entity.VisitSummary;
import com.pauly.AI_Care_Report_BE.repository.TargetRepository;
import com.pauly.AI_Care_Report_BE.repository.VisitReportRepository;
import com.pauly.AI_Care_Report_BE.repository.VisitSummaryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class TargetService {

    private final TargetRepository targetRepository;
    private final VisitReportRepository visitReportRepository;
    private final VisitSummaryRepository visitSummaryRepository;

    public Target addTarget(TargetRequest request, User user) {
        Target target = Target.builder()
                .targetname(request.getTargetname())
                .address1(request.getAddress1())
                .address2(request.getAddress2())
                .targetcallnum(request.getTargetcallnum())
                .gender(request.getGender())
                .age(request.getAge())
                .region(request.getRegion())
                .user(user)
                .build();
        return targetRepository.save(target);
    }

    public List<Target> getAllTargets(User user) {
        return targetRepository.findByUser(user);
    }

    public TargetInfoResponse getTargetInfo(Long targetId) {
        Target target = targetRepository.findById(targetId)
                .orElseThrow(() -> new IllegalArgumentException("대상자를 찾을 수 없습니다: " + targetId));

        List<VisitReport> reports = visitReportRepository.findByUser(target.getUser());
        List<VisitReport> targetReports = reports.stream()
                .filter(r -> r.getTarget() != null && r.getTarget().getId().equals(targetId))
                .filter(r -> r.getReportstatus() != null && r.getReportstatus() == 2)
                .limit(5)
                .collect(Collectors.toList());

        Map<Long, List<VisitSummary>> summariesByReport = targetReports.stream()
                .collect(Collectors.toMap(
                        VisitReport::getId,
                        r -> visitSummaryRepository.findByReport(r)
                ));

        return TargetInfoResponse.from(target, targetReports, summariesByReport);
    }
}
