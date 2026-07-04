package com.pauly.AI_Care_Report_BE.repository;

import com.pauly.AI_Care_Report_BE.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

// 사용자 데이터 접근 인터페이스
public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByEmail(String email);

    boolean existsByEmail(String email);
}
