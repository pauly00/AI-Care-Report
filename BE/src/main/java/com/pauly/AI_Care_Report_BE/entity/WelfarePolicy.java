package com.pauly.AI_Care_Report_BE.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "welfare_policies")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
// 복지정책 엔티티
public class WelfarePolicy {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String policyName;

    @Column(columnDefinition = "TEXT")
    private String shortDescription;

    @Column(columnDefinition = "TEXT")
    // 상세 조건
    private String detailedConditions;

    private String link;

    // 정책 지역
    private String region;
}
