package com.pauly.AI_Care_Report_BE.repository;

import com.pauly.AI_Care_Report_BE.entity.Target;
import com.pauly.AI_Care_Report_BE.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

// 대상자 데이터 접근 인터페이스
public interface TargetRepository extends JpaRepository<Target, Long> {

    List<Target> findByUser(User user);
}
