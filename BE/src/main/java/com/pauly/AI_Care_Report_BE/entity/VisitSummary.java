package com.pauly.AI_Care_Report_BE.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "visit_summaries")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class VisitSummary {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "report_id")
    private VisitReport report;

    private String subject; // 건강, 경제, 생활, 기타

    @Column(columnDefinition = "TEXT")
    private String summaryText; // JSON 'abstract' 필드 (abstract는 Java 예약어)

    @Column(columnDefinition = "TEXT")
    private String detail;
}
