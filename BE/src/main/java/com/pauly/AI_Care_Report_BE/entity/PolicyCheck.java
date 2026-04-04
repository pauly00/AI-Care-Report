package com.pauly.AI_Care_Report_BE.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "policy_checks")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PolicyCheck {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "report_id")
    private VisitReport report;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "policy_id")
    private WelfarePolicy policy;

    private Integer checkStatus; // 1=해당, 0=미해당
}
