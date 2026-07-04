package com.pauly.AI_Care_Report_BE.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "targets")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
// 대상자 엔티티
public class Target {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String targetname;

    private String address1;

    private String address2;

    private String targetcallnum;

    // 성별 코드
    private Integer gender;

    private Integer age;

    private String region;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    // 담당 사회복지사
    private User user;

    @Column(updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
}
