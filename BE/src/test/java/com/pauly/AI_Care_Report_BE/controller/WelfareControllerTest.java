package com.pauly.AI_Care_Report_BE.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.pauly.AI_Care_Report_BE.config.JwtUtil;
import com.pauly.AI_Care_Report_BE.service.WelfareService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;
import java.util.Map;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.doThrow;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(WelfareController.class)
class WelfareControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockBean
    private WelfareService welfareService;

    @MockBean
    private JwtUtil jwtUtil;

    private Map<String, Object> mockPolicy(long id, String name) {
        return Map.of(
                "id", id,
                "policy_name", name,
                "short_description", "지원 설명",
                "detailed_conditions", List.of("조건1", "조건2"),
                "link", "https://example.com",
                "checkStatus", 1
        );
    }

    // ── 대상자별 복지 정책 조회 ─────────────────────────

    @Test
    @WithMockUser
    @DisplayName("대상자별 복지 정책 조회 성공 - age/region/policy 포함")
    void getWelfarePoliciesForTarget_success() throws Exception {
        Map<String, Object> mockResponse = Map.of(
                "id", 1,
                "age", 78,
                "region", "서울",
                "policy", List.of(
                        mockPolicy(1L, "노인 의료비 지원"),
                        mockPolicy(2L, "에너지 바우처")
                )
        );

        given(welfareService.getWelfarePoliciesForTarget(1L)).willReturn(mockResponse);

        mockMvc.perform(get("/db/welfare-policies/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.age").value(78))
                .andExpect(jsonPath("$.region").value("서울"))
                .andExpect(jsonPath("$.policy.length()").value(2))
                .andExpect(jsonPath("$.policy[0].policy_name").value("노인 의료비 지원"));
    }

    @Test
    @WithMockUser
    @DisplayName("대상자별 복지 정책 조회 실패 - 존재하지 않는 대상자 → 404 반환")
    void getWelfarePoliciesForTarget_notFound() throws Exception {
        given(welfareService.getWelfarePoliciesForTarget(anyLong()))
                .willThrow(new IllegalArgumentException("대상자를 찾을 수 없습니다."));

        mockMvc.perform(get("/db/welfare-policies/999"))
                .andExpect(status().isNotFound());
    }

    // ── 전체 복지 정책 조회 ─────────────────────────────

    @Test
    @WithMockUser
    @DisplayName("전체 복지 정책 목록 조회 - 리스트 반환")
    void getAllPolicies_success() throws Exception {
        List<Map<String, Object>> mockList = List.of(
                mockPolicy(1L, "노인 의료비 지원"),
                mockPolicy(2L, "에너지 바우처"),
                mockPolicy(3L, "식료품 지원")
        );

        given(welfareService.getAllPolicies()).willReturn(mockList);

        mockMvc.perform(get("/db/welfare-policies"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.length()").value(3));
    }

    // ── 특정 정책 상세 조회 ─────────────────────────────

    @Test
    @WithMockUser
    @DisplayName("특정 정책 상세 조회 성공 - policy_name/conditions 포함")
    void getPolicyById_success() throws Exception {
        given(welfareService.getPolicyById(1L)).willReturn(mockPolicy(1L, "노인 의료비 지원"));

        mockMvc.perform(get("/db/policies/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.policy_name").value("노인 의료비 지원"))
                .andExpect(jsonPath("$.detailed_conditions").isArray());
    }

    @Test
    @WithMockUser
    @DisplayName("특정 정책 상세 조회 실패 - 존재하지 않는 ID → 404 반환")
    void getPolicyById_notFound() throws Exception {
        given(welfareService.getPolicyById(anyLong()))
                .willThrow(new IllegalArgumentException("정책을 찾을 수 없습니다."));

        mockMvc.perform(get("/db/policies/999"))
                .andExpect(status().isNotFound());
    }

    // ── 정책 체크 상태 업로드 ───────────────────────────

    @Test
    @WithMockUser
    @DisplayName("정책 체크 저장 성공 - 200 반환")
    void uploadCheckPolicy_success() throws Exception {
        doNothing().when(welfareService).uploadPolicyCheckStatus(any());

        String body = """
                {
                    "reportid": 1,
                    "policy": [
                        {"id": 1, "checkStatus": 1},
                        {"id": 2, "checkStatus": 0}
                    ]
                }
                """;

        mockMvc.perform(post("/db/uploadCheckPolicy")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value(true));
    }

    @Test
    @WithMockUser
    @DisplayName("정책 체크 저장 실패 - 존재하지 않는 reportid → 400 반환")
    void uploadCheckPolicy_reportNotFound() throws Exception {
        doThrow(new IllegalArgumentException("보고서를 찾을 수 없습니다."))
                .when(welfareService).uploadPolicyCheckStatus(any());

        mockMvc.perform(post("/db/uploadCheckPolicy")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"reportid\":999,\"policy\":[]}"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.status").value(false));
    }
}
