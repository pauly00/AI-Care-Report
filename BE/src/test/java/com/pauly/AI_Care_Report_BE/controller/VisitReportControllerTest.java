package com.pauly.AI_Care_Report_BE.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.pauly.AI_Care_Report_BE.config.JwtUtil;
import com.pauly.AI_Care_Report_BE.dto.VisitReportRequest;
import com.pauly.AI_Care_Report_BE.dto.VisitReportResponse;
import com.pauly.AI_Care_Report_BE.entity.User;
import com.pauly.AI_Care_Report_BE.entity.VisitReport;
import com.pauly.AI_Care_Report_BE.repository.UserRepository;
import com.pauly.AI_Care_Report_BE.service.VisitReportService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.doThrow;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(VisitReportController.class)
class VisitReportControllerTest {

    @Autowired MockMvc mockMvc;
    @Autowired ObjectMapper objectMapper;

    @MockBean VisitReportService visitReportService;
    @MockBean UserRepository userRepository;
    @MockBean JwtUtil jwtUtil;

    private User mockUser() {
        return User.builder().id(1L).email("test@test.com").name("홍길동").build();
    }

    @Test
    @WithMockUser(username = "test@test.com")
    @DisplayName("방문 보고서 생성 성공 - reportid 반환")
    void addVisitReport_success() throws Exception {
        VisitReportRequest request = new VisitReportRequest();
        request.setTargetid(1L);
        request.setVisittime("2026-04-05 10:00");

        given(userRepository.findByEmail(anyString())).willReturn(Optional.of(mockUser()));
        given(visitReportService.addVisitReport(any(), any()))
                .willReturn(VisitReport.builder().id(5L).build());

        mockMvc.perform(post("/db/addVisitReport")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value(true))
                .andExpect(jsonPath("$.reportid").value(5));
    }

    @Test
    @WithMockUser(username = "test@test.com")
    @DisplayName("전체 방문 보고서 조회 - 목록 반환")
    void getAllVisitReports_success() throws Exception {
        given(userRepository.findByEmail(anyString())).willReturn(Optional.of(mockUser()));
        given(visitReportService.getAllVisitReports(any())).willReturn(List.of(
                VisitReportResponse.builder().reportid(1L).reportstatus(0).visittime("2026-04-05 10:00").build(),
                VisitReportResponse.builder().reportid(2L).reportstatus(2).visittime("2026-04-03 14:00").build()
        ));

        mockMvc.perform(get("/db/getAllVisitReports"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.length()").value(2))
                .andExpect(jsonPath("$[0].reportid").value(1));
    }

    @Test
    @WithMockUser(username = "test@test.com")
    @DisplayName("오늘 방문 목록 조회 - name/address 포함")
    void getTodayList_success() throws Exception {
        given(userRepository.findByEmail(anyString())).willReturn(Optional.of(mockUser()));
        given(visitReportService.getTodayList(any())).willReturn(List.of(
                Map.of("reportid", 1, "visitTime", "2026-04-04 10:00",
                        "name", "김할머니", "address", "서울시 양천구", "callNum", "01098765432")
        ));

        mockMvc.perform(get("/db/getTodayList"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].name").value("김할머니"));
    }

    @Test
    @WithMockUser
    @DisplayName("특이사항 업로드 성공 - 200 반환")
    void uploadVisitDetail_success() throws Exception {
        doNothing().when(visitReportService).uploadVisitDetail(any());

        mockMvc.perform(post("/db/uploadVisitDetail")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"reportid\":1,\"detail\":\"혈압 높음, 주의 필요\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value(true));
    }

    @Test
    @WithMockUser
    @DisplayName("특이사항 업로드 실패 - 없는 reportid → 400 반환")
    void uploadVisitDetail_notFound() throws Exception {
        doThrow(new IllegalArgumentException("보고서를 찾을 수 없습니다."))
                .when(visitReportService).uploadVisitDetail(any());

        mockMvc.perform(post("/db/uploadVisitDetail")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"reportid\":999,\"detail\":\"내용\"}"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.status").value(false));
    }

    @Test
    @WithMockUser
    @DisplayName("상담 완료 처리 성공")
    void visitReportDone_success() throws Exception {
        doNothing().when(visitReportService).markDone(1L);

        mockMvc.perform(get("/db/visitReportDone").param("reportid", "1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value(true));
    }

    @Test
    @WithMockUser
    @DisplayName("녹음 파일 업로드 성공 - 200 반환")
    void uploadCallRecord_success() throws Exception {
        MockMultipartFile audioFile = new MockMultipartFile(
                "audiofile", "recording.m4a", "audio/x-m4a", "audio content".getBytes()
        );
        doNothing().when(visitReportService).uploadCallRecord(anyLong(), any());

        mockMvc.perform(multipart("/db/uploadCallRecord")
                        .file(audioFile).param("reportid", "1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value(true));
    }

    @Test
    @WithMockUser
    @DisplayName("STT 텍스트 조회 성공")
    void getSttText_success() throws Exception {
        given(visitReportService.getSttText(1L)).willReturn("안녕하세요. 오늘 건강은 어떠세요?");

        mockMvc.perform(get("/db/getConverstationSTTtxt/1"))
                .andExpect(status().isOk())
                .andExpect(content().string("안녕하세요. 오늘 건강은 어떠세요?"));
    }

    @Test
    @WithMockUser
    @DisplayName("방문 요약 조회 성공 - reportid + items 반환")
    void getVisitDetails_success() throws Exception {
        given(visitReportService.getVisitDetails(1L)).willReturn(Map.of(
                "reportid", 1,
                "items", List.of(
                        Map.of("subject", "건강", "abstract", "혈압 이상", "detail", "수축기 150 이상"),
                        Map.of("subject", "생활", "abstract", "외출 감소", "detail", "최근 외출 없음")
                )
        ));

        mockMvc.perform(get("/db/getVisitDetails/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.reportid").value(1))
                .andExpect(jsonPath("$.items.length()").value(2))
                .andExpect(jsonPath("$.items[0].subject").value("건강"));
    }

    @Test
    @WithMockUser
    @DisplayName("요약 수정 저장 성공 - 200 반환")
    void uploadEditAbstract_success() throws Exception {
        doNothing().when(visitReportService).uploadEditAbstract(any());

        mockMvc.perform(post("/db/uploadEditAbstract")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                            {"reportid":1,"items":[
                                {"subject":"건강","abstract":"혈압 이상","detail":"수축기 150 이상"}
                            ]}
                        """))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value(true));
    }
}
