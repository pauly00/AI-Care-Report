package com.pauly.AI_Care_Report_BE.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "visit_reports")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class VisitReport {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "target_id")
    private Target target;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    private String visittime; // "2024-01-01 10:00"

    private Integer reportstatus; // 0=예정, 1=진행중, 2=완료

    private String visittype; // "전화돌봄", "현장돌봄"

    private String endtime;

    @Column(columnDefinition = "TEXT")
    private String detail; // 특이사항

    @Column(columnDefinition = "TEXT")
    private String sttText; // STT 변환 텍스트

    @Column(updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
}
