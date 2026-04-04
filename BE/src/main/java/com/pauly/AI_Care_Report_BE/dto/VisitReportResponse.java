package com.pauly.AI_Care_Report_BE.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.pauly.AI_Care_Report_BE.entity.VisitReport;
import lombok.Builder;
import lombok.Data;

import java.util.Map;

@Data
@Builder
public class VisitReportResponse {

    private Long reportid;
    private Integer reportstatus;
    private String visittime;

    @JsonProperty("targetInfo")
    private Map<String, Object> targetInfo;

    public static VisitReportResponse from(VisitReport report) {
        Map<String, Object> target = null;
        if (report.getTarget() != null) {
            target = Map.of(
                    "targetid", report.getTarget().getId(),
                    "targetname", nvl(report.getTarget().getTargetname()),
                    "address1", nvl(report.getTarget().getAddress1()),
                    "address2", nvl(report.getTarget().getAddress2()),
                    "targetcallnum", nvl(report.getTarget().getTargetcallnum()),
                    "gender", nvl(report.getTarget().getGender()),
                    "age", nvl(report.getTarget().getAge())
            );
        }

        return VisitReportResponse.builder()
                .reportid(report.getId())
                .reportstatus(report.getReportstatus())
                .visittime(report.getVisittime())
                .targetInfo(target)
                .build();
    }

    private static Object nvl(Object val) {
        return val != null ? val : "";
    }
}
