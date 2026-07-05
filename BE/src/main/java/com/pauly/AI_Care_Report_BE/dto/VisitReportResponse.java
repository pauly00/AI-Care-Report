package com.pauly.AI_Care_Report_BE.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.pauly.AI_Care_Report_BE.entity.VisitReport;
import lombok.Builder;
import lombok.Data;

import java.util.Map;

@Data
@Builder
// 방문 보고서 응답 DTO
public class VisitReportResponse {

    private Long reportid;
    private Integer reportstatus;
    private String visittime;
    private Integer visitType;
    private String visittype;

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
                .visitType(toVisitTypeCode(report.getVisittype()))
                .visittype(report.getVisittype())
                .targetInfo(target)
                .build();
    }

    private static Object nvl(Object val) {
        return val != null ? val : "";
    }

    private static Integer toVisitTypeCode(String visitType) {
        if (visitType == null || visitType.isBlank()) {
            return 1;
        }
        if ("전화돌봄".equals(visitType)) {
            return 0;
        }
        if ("현장돌봄".equals(visitType) || "방문돌봄".equals(visitType)) {
            return 1;
        }
        try {
            return Integer.parseInt(visitType);
        } catch (NumberFormatException e) {
            return 1;
        }
    }
}
