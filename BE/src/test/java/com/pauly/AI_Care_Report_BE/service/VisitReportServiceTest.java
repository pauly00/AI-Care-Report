package com.pauly.AI_Care_Report_BE.service;

import com.pauly.AI_Care_Report_BE.dto.UploadVisitDetailRequest;
import com.pauly.AI_Care_Report_BE.dto.VisitReportRequest;
import com.pauly.AI_Care_Report_BE.dto.VisitReportResponse;
import com.pauly.AI_Care_Report_BE.entity.Target;
import com.pauly.AI_Care_Report_BE.entity.User;
import com.pauly.AI_Care_Report_BE.entity.VisitReport;
import com.pauly.AI_Care_Report_BE.repository.*;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.verify;

@ExtendWith(MockitoExtension.class)
class VisitReportServiceTest {

    @InjectMocks
    private VisitReportService visitReportService;

    @Mock
    private VisitReportRepository visitReportRepository;

    @Mock
    private VisitSummaryRepository visitSummaryRepository;

    @Mock
    private TargetRepository targetRepository;

    @Mock
    private UserRepository userRepository;

    private User testUser() {
        return User.builder().id(1L).email("test@test.com").name("홍길동").build();
    }

    private Target testTarget() {
        return Target.builder().id(1L).targetname("김할머니")
                .address1("서울시 양천구").targetcallnum("01098765432")
                .gender(1).age(78).build();
    }

    private VisitReport testReport(Long id) {
        return VisitReport.builder()
                .id(id)
                .target(testTarget())
                .user(testUser())
                .visittime("2026-04-05 10:00")
                .reportstatus(0)
                .build();
    }

    // ── 방문 보고서 생성 ────────────────────────────────

    @Test
    @DisplayName("방문 보고서 생성 성공 - reportstatus=0으로 저장")
    void addVisitReport_success() {
        VisitReportRequest request = new VisitReportRequest();
        request.setTargetid(1L);
        request.setVisittime("2026-04-05 10:00");

        given(targetRepository.findById(1L)).willReturn(Optional.of(testTarget()));
        given(visitReportRepository.save(any())).willReturn(testReport(5L));

        VisitReport result = visitReportService.addVisitReport(request, testUser());

        assertThat(result.getId()).isEqualTo(5L);
        verify(visitReportRepository).save(any(VisitReport.class));
    }

    @Test
    @DisplayName("방문 보고서 생성 실패 - 없는 대상자 ID → 예외 발생")
    void addVisitReport_targetNotFound() {
        VisitReportRequest request = new VisitReportRequest();
        request.setTargetid(999L);

        given(targetRepository.findById(999L)).willReturn(Optional.empty());

        assertThatThrownBy(() -> visitReportService.addVisitReport(request, testUser()))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("대상자를 찾을 수 없습니다");
    }

    // ── 전체 방문 목록 조회 ─────────────────────────────

    @Test
    @DisplayName("전체 방문 보고서 조회 - 유저 소속 보고서 목록 반환")
    void getAllVisitReports_success() {
        given(visitReportRepository.findByUser(any())).willReturn(
                List.of(testReport(1L), testReport(2L))
        );

        List<VisitReportResponse> result = visitReportService.getAllVisitReports(testUser());

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getReportid()).isEqualTo(1L);
    }

    // ── 특이사항 업로드 ─────────────────────────────────

    @Test
    @DisplayName("특이사항 저장 성공 - detail 필드 업데이트")
    void uploadVisitDetail_success() {
        UploadVisitDetailRequest request = new UploadVisitDetailRequest();
        request.setReportid(1L);
        request.setDetail("혈압 높음, 주의 필요");

        VisitReport report = testReport(1L);
        given(visitReportRepository.findById(1L)).willReturn(Optional.of(report));
        given(visitReportRepository.save(any())).willReturn(report);

        visitReportService.uploadVisitDetail(request);

        assertThat(report.getDetail()).isEqualTo("혈압 높음, 주의 필요");
        verify(visitReportRepository).save(report);
    }

    @Test
    @DisplayName("특이사항 저장 실패 - 없는 reportid → 예외 발생")
    void uploadVisitDetail_notFound() {
        UploadVisitDetailRequest request = new UploadVisitDetailRequest();
        request.setReportid(999L);

        given(visitReportRepository.findById(999L)).willReturn(Optional.empty());

        assertThatThrownBy(() -> visitReportService.uploadVisitDetail(request))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("보고서를 찾을 수 없습니다");
    }

    // ── 상담 완료 처리 ──────────────────────────────────

    @Test
    @DisplayName("상담 완료 처리 - reportstatus가 2로 변경됨")
    void markDone_success() {
        VisitReport report = testReport(1L);
        given(visitReportRepository.findById(1L)).willReturn(Optional.of(report));
        given(visitReportRepository.save(any())).willReturn(report);

        visitReportService.markDone(1L);

        assertThat(report.getReportstatus()).isEqualTo(2);
    }

    @Test
    @DisplayName("상담 완료 처리 실패 - 없는 reportid → 예외 발생")
    void markDone_notFound() {
        given(visitReportRepository.findById(999L)).willReturn(Optional.empty());

        assertThatThrownBy(() -> visitReportService.markDone(999L))
                .isInstanceOf(IllegalArgumentException.class);
    }

    // ── STT 텍스트 조회 ─────────────────────────────────

    @Test
    @DisplayName("STT 텍스트 조회 성공 - sttText 반환")
    void getSttText_success() {
        VisitReport report = testReport(1L);
        report.setSttText("안녕하세요. 오늘 건강은 어떠세요?");

        given(visitReportRepository.findById(1L)).willReturn(Optional.of(report));

        String result = visitReportService.getSttText(1L);

        assertThat(result).isEqualTo("안녕하세요. 오늘 건강은 어떠세요?");
    }

    @Test
    @DisplayName("STT 텍스트 없을 때 - 빈 문자열 반환")
    void getSttText_empty() {
        VisitReport report = testReport(1L);
        // sttText = null

        given(visitReportRepository.findById(1L)).willReturn(Optional.of(report));

        String result = visitReportService.getSttText(1L);

        assertThat(result).isEmpty();
    }

    // ── 방문 요약 조회 ──────────────────────────────────

    @Test
    @DisplayName("방문 요약 조회 - reportid와 items 포함")
    void getVisitDetails_success() {
        VisitReport report = testReport(1L);

        given(visitReportRepository.findById(1L)).willReturn(Optional.of(report));
        given(visitSummaryRepository.findByReport(report)).willReturn(List.of());

        Map<String, Object> result = visitReportService.getVisitDetails(1L);

        assertThat(result.get("reportid")).isEqualTo(1L);
        assertThat(result.get("items")).isInstanceOf(List.class);
    }
}
