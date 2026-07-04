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
// 방문 보고서 엔티티
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

    // 방문 예정 시간
    private String visittime;

    // 보고서 상태 코드
    private Integer reportstatus;

    // 방문 유형
    private String visittype;

    private String endtime;

    @Column(columnDefinition = "TEXT")
    // 특이사항
    private String detail;

    @Column(columnDefinition = "TEXT")
    // STT 변환 텍스트
    private String sttText;

    @Column(updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
}
