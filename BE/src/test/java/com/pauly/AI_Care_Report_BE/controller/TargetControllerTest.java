package com.pauly.AI_Care_Report_BE.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.pauly.AI_Care_Report_BE.config.JwtUtil;
import com.pauly.AI_Care_Report_BE.dto.TargetInfoResponse;
import com.pauly.AI_Care_Report_BE.dto.TargetRequest;
import com.pauly.AI_Care_Report_BE.entity.Target;
import com.pauly.AI_Care_Report_BE.entity.User;
import com.pauly.AI_Care_Report_BE.repository.UserRepository;
import com.pauly.AI_Care_Report_BE.service.TargetService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.BDDMockito.given;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(TargetController.class)
class TargetControllerTest {

    @Autowired MockMvc mockMvc;
    @Autowired ObjectMapper objectMapper;

    @MockBean TargetService targetService;
    @MockBean UserRepository userRepository;
    @MockBean JwtUtil jwtUtil;

    private User mockUser() {
        return User.builder().id(1L).email("test@test.com").name("홍길동").build();
    }

    @Test
    @WithMockUser(username = "test@test.com")
    @DisplayName("대상자 등록 성공 - targetid 반환")
    void addTarget_success() throws Exception {
        TargetRequest request = new TargetRequest();
        request.setTargetname("김할머니");
        request.setAddress1("서울시 양천구");
        request.setTargetcallnum("01098765432");
        request.setGender(1);
        request.setAge(78);

        given(userRepository.findByEmail(anyString())).willReturn(Optional.of(mockUser()));
        given(targetService.addTarget(any(), any()))
                .willReturn(Target.builder().id(10L).targetname("김할머니").build());

        mockMvc.perform(post("/db/addTarget")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value(true))
                .andExpect(jsonPath("$.targetid").value(10));
    }

    @Test
    @WithMockUser(username = "test@test.com")
    @DisplayName("전체 대상자 조회 - 목록 반환")
    void getAllTargets_success() throws Exception {
        given(userRepository.findByEmail(anyString())).willReturn(Optional.of(mockUser()));
        given(targetService.getAllTargets(any())).willReturn(List.of(
                Target.builder().id(1L).targetname("김할머니").age(78).build(),
                Target.builder().id(2L).targetname("이할아버지").age(83).build()
        ));

        mockMvc.perform(get("/db/getAllTargets"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.length()").value(2))
                .andExpect(jsonPath("$[0].targetname").value("김할머니"));
    }

    @Test
    @WithMockUser(username = "test@test.com")
    @DisplayName("대상자 없을 때 빈 배열 반환")
    void getAllTargets_empty() throws Exception {
        given(userRepository.findByEmail(anyString())).willReturn(Optional.of(mockUser()));
        given(targetService.getAllTargets(any())).willReturn(List.of());

        mockMvc.perform(get("/db/getAllTargets"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.length()").value(0));
    }

    @Test
    @WithMockUser
    @DisplayName("대상자 상세 조회 성공 - lastvisit 포함")
    void getTargetInfo_success() throws Exception {
        given(targetService.getTargetInfo(1L)).willReturn(
                TargetInfoResponse.builder()
                        .targetid(1L).targetname("김할머니").address1("서울시 양천구")
                        .address2("신정동 123").targetcallnum("01098765432")
                        .gender(1).age(78).lastvisit(List.of()).build()
        );

        mockMvc.perform(get("/db/getTargetInfo/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.targetid").value(1))
                .andExpect(jsonPath("$.targetname").value("김할머니"))
                .andExpect(jsonPath("$.lastvisit").isArray());
    }

    @Test
    @WithMockUser
    @DisplayName("존재하지 않는 대상자 ID → 404 반환")
    void getTargetInfo_notFound() throws Exception {
        given(targetService.getTargetInfo(anyLong()))
                .willThrow(new IllegalArgumentException("대상자를 찾을 수 없습니다: 999"));

        mockMvc.perform(get("/db/getTargetInfo/999"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.message").exists());
    }
}
