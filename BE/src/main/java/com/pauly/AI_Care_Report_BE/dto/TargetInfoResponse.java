package com.pauly.AI_Care_Report_BE.dto;

import com.pauly.AI_Care_Report_BE.entity.Target;
import com.pauly.AI_Care_Report_BE.entity.VisitReport;
import com.pauly.AI_Care_Report_BE.entity.VisitSummary;
import lombok.Builder;
import lombok.Data;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Data
@Builder
public class TargetInfoResponse {

    private Long targetid;
    private String targetname;
    private String address1;
    private String address2;
    private String targetcallnum;
    private Integer gender;
    private Integer age;
    private List<Map<String, String>> lastvisit;

    public static TargetInfoResponse from(Target target, List<VisitReport> recentReports,
                                          Map<Long, List<VisitSummary>> summariesByReport) {

        List<Map<String, String>> lastVisitList = recentReports.stream()
                .map(report -> {
                    String abstractText = "";
                    List<VisitSummary> summaries = summariesByReport.getOrDefault(report.getId(), List.of());
                    if (!summaries.isEmpty()) {
                        abstractText = summaries.stream()
                                .map(s -> s.getSummaryText() != null ? s.getSummaryText() : "")
                                .collect(Collectors.joining(", "));
                    }
                    return Map.of(
                            "date", report.getVisittime() != null ? report.getVisittime() : "",
                            "abstract", abstractText
                    );
                })
                .collect(Collectors.toList());

        return TargetInfoResponse.builder()
                .targetid(target.getId())
                .targetname(target.getTargetname())
                .address1(target.getAddress1())
                .address2(target.getAddress2())
                .targetcallnum(target.getTargetcallnum())
                .gender(target.getGender())
                .age(target.getAge())
                .lastvisit(lastVisitList)
                .build();
    }
}
