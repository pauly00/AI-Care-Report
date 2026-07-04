package com.pauly.AI_Care_Report_BE.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "visit_summaries")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
// 방문 요약 엔티티
public class VisitSummary {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "report_id")
    private VisitReport report;

    // 요약 주제
    private String subject;

    @Column(columnDefinition = "TEXT")
    // 요약 본문
    private String summaryText;

    @Column(columnDefinition = "TEXT")
    private String detail;
}
