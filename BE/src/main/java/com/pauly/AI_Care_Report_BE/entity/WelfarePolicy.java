package com.pauly.AI_Care_Report_BE.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "welfare_policies")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WelfarePolicy {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String policyName;

    @Column(columnDefinition = "TEXT")
    private String shortDescription;

    @Column(columnDefinition = "TEXT")
    private String detailedConditions; // JSON 배열 문자열로 저장

    private String link;

    private String region; // 서울, 경기 등 지역 필터링용
}
