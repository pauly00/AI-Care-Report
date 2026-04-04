package com.pauly.AI_Care_Report_BE.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.pauly.AI_Care_Report_BE.config.JwtUtil;
import com.pauly.AI_Care_Report_BE.dto.LoginRequest;
import com.pauly.AI_Care_Report_BE.dto.RegisterRequest;
import com.pauly.AI_Care_Report_BE.dto.UserResponse;
import com.pauly.AI_Care_Report_BE.repository.UserRepository;
import com.pauly.AI_Care_Report_BE.service.AuthService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Map;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.BDDMockito.given;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(AuthController.class)
class AuthControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockBean
    private AuthService authService;

    @MockBean
    private UserRepository userRepository;

    @MockBean
    private JwtUtil jwtUtil;

    // ── 로그인 ──────────────────────────────────────────

    @Test
    @DisplayName("로그인 성공 - 200 + token 반환")
    void login_success() throws Exception {
        LoginRequest request = new LoginRequest();
        request.setEmail("test@test.com");
        request.setPassword("password123");

        Map<String, Object> mockResponse = Map.of(
                "status", true,
                "message", "로그인 성공",
                "token", "eyJhbGciOiJIUzI1NiJ9.test",
                "user", Map.of("user_id", 1, "name", "홍길동", "email", "test@test.com")
        );

        given(authService.login(any())).willReturn(mockResponse);

        mockMvc.perform(post("/db/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value(true))
                .andExpect(jsonPath("$.token").exists())
                .andExpect(jsonPath("$.user").exists());
    }

    @Test
    @DisplayName("로그인 실패 - 비밀번호 오류 시 401 반환")
    void login_fail_wrong_password() throws Exception {
        LoginRequest request = new LoginRequest();
        request.setEmail("test@test.com");
        request.setPassword("wrongpassword");

        given(authService.login(any()))
                .willThrow(new IllegalArgumentException("이메일 또는 비밀번호가 올바르지 않습니다."));

        mockMvc.perform(post("/db/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.status").value(false));
    }

    // ── 회원가입 ────────────────────────────────────────

    @Test
    @DisplayName("회원가입 성공 - 200 반환")
    void register_success() throws Exception {
        RegisterRequest request = new RegisterRequest();
        request.setName("홍길동");
        request.setEmail("newuser@test.com");
        request.setPassword("password123");
        request.setPhoneNumber("01012345678");
        request.setBirthdate("1990-01-01");
        request.setGender(0);

        Map<String, Object> mockResponse = Map.of(
                "status", true,
                "message", "회원가입 성공",
                "user", Map.of("user_id", 2, "name", "홍길동")
        );

        given(authService.register(any())).willReturn(mockResponse);

        mockMvc.perform(post("/db/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value(true));
    }

    @Test
    @DisplayName("회원가입 실패 - 이메일 중복 시 400 반환")
    void register_fail_duplicate_email() throws Exception {
        RegisterRequest request = new RegisterRequest();
        request.setEmail("existing@test.com");
        request.setPassword("password123");

        given(authService.register(any()))
                .willThrow(new IllegalArgumentException("이미 사용 중인 이메일입니다."));

        mockMvc.perform(post("/db/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.status").value(false))
                .andExpect(jsonPath("$.msg").value("이미 사용 중인 이메일입니다."));
    }

    // ── 이메일 중복 체크 ────────────────────────────────

    @Test
    @DisplayName("이메일 사용 가능 - status: true 반환")
    void emailCheck_available() throws Exception {
        given(authService.isEmailAvailable("new@test.com")).willReturn(true);

        mockMvc.perform(post("/db/email_check")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"email\":\"new@test.com\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value(true));
    }

    @Test
    @DisplayName("이메일 이미 사용 중 - status: false 반환")
    void emailCheck_taken() throws Exception {
        given(authService.isEmailAvailable("taken@test.com")).willReturn(false);

        mockMvc.perform(post("/db/email_check")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"email\":\"taken@test.com\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value(false));
    }

    // ── 내 정보 조회 ────────────────────────────────────

    @Test
    @WithMockUser(username = "test@test.com")
    @DisplayName("내 정보 조회 성공 - JWT 인증 후 200 반환")
    void getMyInfo_success() throws Exception {
        UserResponse mockUser = UserResponse.builder()
                .userId(1L).name("홍길동").email("test@test.com").phoneNumber("01012345678").build();

        given(authService.getUserByEmail(anyString())).willReturn(mockUser);

        mockMvc.perform(get("/db/users"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.user_id").value(1))
                .andExpect(jsonPath("$.name").value("홍길동"));
    }

    @Test
    @DisplayName("내 정보 조회 - 인증 없이 접근 시 403 반환")
    void getMyInfo_unauthorized() throws Exception {
        mockMvc.perform(get("/db/users"))
                .andExpect(status().isForbidden());
    }
}
