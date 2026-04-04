package com.pauly.AI_Care_Report_BE.service;

import com.pauly.AI_Care_Report_BE.config.JwtUtil;
import com.pauly.AI_Care_Report_BE.dto.LoginRequest;
import com.pauly.AI_Care_Report_BE.dto.RegisterRequest;
import com.pauly.AI_Care_Report_BE.dto.UserResponse;
import com.pauly.AI_Care_Report_BE.entity.User;
import com.pauly.AI_Care_Report_BE.repository.UserRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Map;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.verify;

@ExtendWith(MockitoExtension.class)
class AuthServiceTest {

    @InjectMocks
    private AuthService authService;

    @Mock
    private UserRepository userRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private JwtUtil jwtUtil;

    private User testUser() {
        return User.builder()
                .id(1L)
                .email("test@test.com")
                .password("encodedPassword")
                .name("홍길동")
                .role("SOCIAL_WORKER")
                .permission(1)
                .build();
    }

    // ── 로그인 ──────────────────────────────────────────

    @Test
    @DisplayName("로그인 성공 - token과 user 정보 반환")
    void login_success() {
        LoginRequest request = new LoginRequest();
        request.setEmail("test@test.com");
        request.setPassword("password123");

        given(userRepository.findByEmail("test@test.com")).willReturn(Optional.of(testUser()));
        given(passwordEncoder.matches("password123", "encodedPassword")).willReturn(true);
        given(jwtUtil.generateToken("test@test.com")).willReturn("mock.jwt.token");

        Map<String, Object> result = authService.login(request);

        assertThat(result.get("status")).isEqualTo(true);
        assertThat(result.get("token")).isEqualTo("mock.jwt.token");
        assertThat(result.get("user")).isInstanceOf(UserResponse.class);
    }

    @Test
    @DisplayName("로그인 실패 - 이메일 없음 → 예외 발생")
    void login_fail_emailNotFound() {
        LoginRequest request = new LoginRequest();
        request.setEmail("noone@test.com");
        request.setPassword("password123");

        given(userRepository.findByEmail("noone@test.com")).willReturn(Optional.empty());

        assertThatThrownBy(() -> authService.login(request))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("이메일 또는 비밀번호");
    }

    @Test
    @DisplayName("로그인 실패 - 비밀번호 불일치 → 예외 발생")
    void login_fail_wrongPassword() {
        LoginRequest request = new LoginRequest();
        request.setEmail("test@test.com");
        request.setPassword("wrongpassword");

        given(userRepository.findByEmail("test@test.com")).willReturn(Optional.of(testUser()));
        given(passwordEncoder.matches("wrongpassword", "encodedPassword")).willReturn(false);

        assertThatThrownBy(() -> authService.login(request))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("이메일 또는 비밀번호");
    }

    // ── 회원가입 ────────────────────────────────────────

    @Test
    @DisplayName("회원가입 성공 - 저장 후 user 정보 반환")
    void register_success() {
        RegisterRequest request = new RegisterRequest();
        request.setEmail("newuser@test.com");
        request.setPassword("password123");
        request.setName("김철수");
        request.setPhoneNumber("01011112222");
        request.setGender(0);

        given(userRepository.existsByEmail("newuser@test.com")).willReturn(false);
        given(passwordEncoder.encode("password123")).willReturn("hashedPassword");
        given(userRepository.save(any())).willReturn(
                User.builder().id(2L).email("newuser@test.com").name("김철수").build()
        );

        Map<String, Object> result = authService.register(request);

        assertThat(result.get("status")).isEqualTo(true);
        assertThat(result.get("user")).isInstanceOf(UserResponse.class);
        verify(userRepository).save(any(User.class));
    }

    @Test
    @DisplayName("회원가입 실패 - 이메일 중복 → 예외 발생")
    void register_fail_duplicateEmail() {
        RegisterRequest request = new RegisterRequest();
        request.setEmail("existing@test.com");
        request.setPassword("password123");

        given(userRepository.existsByEmail("existing@test.com")).willReturn(true);

        assertThatThrownBy(() -> authService.register(request))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("이미 사용 중인 이메일");
    }

    // ── 이메일 중복 체크 ────────────────────────────────

    @Test
    @DisplayName("이메일 사용 가능 - true 반환")
    void isEmailAvailable_true() {
        given(userRepository.existsByEmail("free@test.com")).willReturn(false);
        assertThat(authService.isEmailAvailable("free@test.com")).isTrue();
    }

    @Test
    @DisplayName("이메일 이미 사용 중 - false 반환")
    void isEmailAvailable_false() {
        given(userRepository.existsByEmail("taken@test.com")).willReturn(true);
        assertThat(authService.isEmailAvailable("taken@test.com")).isFalse();
    }

    // ── 내 정보 조회 ────────────────────────────────────

    @Test
    @DisplayName("이메일로 유저 조회 성공 - UserResponse 반환")
    void getUserByEmail_success() {
        given(userRepository.findByEmail("test@test.com")).willReturn(Optional.of(testUser()));

        UserResponse result = authService.getUserByEmail("test@test.com");

        assertThat(result.getEmail()).isEqualTo("test@test.com");
        assertThat(result.getName()).isEqualTo("홍길동");
    }

    @Test
    @DisplayName("이메일로 유저 조회 실패 - 없는 유저 → 예외 발생")
    void getUserByEmail_notFound() {
        given(userRepository.findByEmail("ghost@test.com")).willReturn(Optional.empty());

        assertThatThrownBy(() -> authService.getUserByEmail("ghost@test.com"))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("사용자를 찾을 수 없습니다");
    }
}
