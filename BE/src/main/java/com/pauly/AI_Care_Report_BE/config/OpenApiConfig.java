package com.pauly.AI_Care_Report_BE.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.Operation;
import io.swagger.v3.oas.models.PathItem;
import io.swagger.v3.oas.models.info.Info;
import org.springdoc.core.customizers.OpenApiCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.LinkedHashMap;
import java.util.Map;

@Configuration
// Swagger API 문서 설정
public class OpenApiConfig {

    @Bean
    public OpenAPI openAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("AI-Care-Report Backend API")
                        .description("독거노인 방문 관리와 AI 상담 리포트 생성을 위한 백엔드 API")
                        .version("v1"));
    }

    @Bean
    public OpenApiCustomizer operationDescriptionCustomizer() {
        Map<String, ApiDoc> docs = apiDocs();
        return openApi -> openApi.getPaths().forEach((path, pathItem) ->
                pathItem.readOperationsMap().forEach((method, operation) -> {
                    ApiDoc doc = docs.get(key(method, path));
                    if (doc != null) {
                        applyDoc(operation, doc);
                    }
                })
        );
    }

    private void applyDoc(Operation operation, ApiDoc doc) {
        operation.setSummary(doc.summary());
        operation.setDescription(doc.description());
        operation.addTagsItem(doc.tag());
    }

    private Map<String, ApiDoc> apiDocs() {
        Map<String, ApiDoc> docs = new LinkedHashMap<>();

        add(docs, PathItem.HttpMethod.POST, "/db/login", "인증 API", "로그인", "이메일과 비밀번호로 로그인하고 JWT 토큰을 발급합니다.");
        add(docs, PathItem.HttpMethod.POST, "/db/register", "인증 API", "회원가입", "사용자 정보를 등록하고 계정을 생성합니다.");
        add(docs, PathItem.HttpMethod.POST, "/db/email_check", "인증 API", "이메일 중복 확인", "입력한 이메일의 사용 가능 여부를 확인합니다.");
        add(docs, PathItem.HttpMethod.GET, "/db/users", "인증 API", "내 정보 조회", "JWT 인증 사용자 정보를 조회합니다.");
        add(docs, PathItem.HttpMethod.PUT, "/db/users/{userId}", "인증 API", "사용자 정보 수정", "사용자 식별자로 사용자 정보를 수정합니다.");
        add(docs, PathItem.HttpMethod.DELETE, "/db/users/{userId}", "인증 API", "사용자 삭제", "사용자 식별자로 사용자 정보를 삭제합니다.");

        add(docs, PathItem.HttpMethod.POST, "/db/addTarget", "대상자 API", "대상자 등록", "인증 사용자의 돌봄 대상자를 등록합니다.");
        add(docs, PathItem.HttpMethod.GET, "/db/getAllTargets", "대상자 API", "대상자 목록 조회", "인증 사용자가 관리하는 대상자 목록을 조회합니다.");
        add(docs, PathItem.HttpMethod.GET, "/db/getTargetInfo/{id}", "대상자 API", "대상자 상세 조회", "대상자 기본 정보와 마지막 방문 기록을 조회합니다.");

        add(docs, PathItem.HttpMethod.POST, "/db/addVisitReport", "방문 보고서 API", "방문 보고서 생성", "방문 예정 대상자의 방문 보고서를 생성합니다.");
        add(docs, PathItem.HttpMethod.GET, "/db/getAllVisitReports", "방문 보고서 API", "방문 보고서 목록 조회", "인증 사용자의 전체 방문 보고서 목록을 조회합니다.");
        add(docs, PathItem.HttpMethod.GET, "/db/getDefaultReportList", "방문 보고서 API", "방문 예정 보고서 조회", "방문 예정 상태의 보고서 목록을 조회합니다.");
        add(docs, PathItem.HttpMethod.GET, "/db/getResultReportList", "방문 보고서 API", "방문 완료 보고서 조회", "상담 완료 상태의 방문 보고서 목록을 조회합니다.");
        add(docs, PathItem.HttpMethod.GET, "/db/getTodayList", "방문 보고서 API", "오늘 방문 목록 조회", "오늘 진행할 방문 목록을 조회합니다.");
        add(docs, PathItem.HttpMethod.POST, "/db/getTodayList", "방문 보고서 API", "오늘 방문 목록 조회", "오늘 진행할 방문 목록을 POST 방식으로 조회합니다.");
        add(docs, PathItem.HttpMethod.POST, "/db/uploadReportDefaultInfo", "방문 보고서 API", "보고서 기본 정보 저장", "방문 보고서의 기본 정보를 저장합니다.");
        add(docs, PathItem.HttpMethod.POST, "/db/uploadVisitDetail", "방문 보고서 API", "방문 상세 정보 저장", "방문 과정에서 확인한 상세 내용을 저장합니다.");
        add(docs, PathItem.HttpMethod.GET, "/db/visitReportDone", "방문 보고서 API", "방문 완료 처리", "방문 보고서를 상담 완료 상태로 변경합니다.");
        add(docs, PathItem.HttpMethod.POST, "/db/uploadCallRecord", "방문 보고서 API", "통화 녹음 업로드", "방문 보고서에 연결된 통화 녹음 파일을 업로드합니다.");
        add(docs, PathItem.HttpMethod.GET, "/db/getConverstationSTTtxt/{id}", "방문 보고서 API", "STT 원문 조회", "보고서 식별자로 STT 원본 텍스트를 조회합니다.");
        add(docs, PathItem.HttpMethod.GET, "/db/getVisitDetails/{id}", "방문 보고서 API", "방문 요약 조회", "보고서 식별자로 방문 상세 요약 정보를 조회합니다.");
        add(docs, PathItem.HttpMethod.POST, "/db/uploadEditAbstract", "방문 보고서 API", "방문 요약 수정", "수정된 방문 요약 내용을 저장합니다.");
        add(docs, PathItem.HttpMethod.POST, "/db/uploadImages", "방문 보고서 API", "방문 이미지 업로드", "방문 보고서에 연결된 이미지를 업로드합니다.");

        add(docs, PathItem.HttpMethod.GET, "/db/welfare-policies", "복지정책 API", "전체 복지정책 조회", "등록된 전체 복지정책 목록을 조회합니다.");
        add(docs, PathItem.HttpMethod.GET, "/db/welfare-policies/{targetId}", "복지정책 API", "대상자 복지정책 조회", "대상자 기준 추천 복지정책 정보를 조회합니다.");
        add(docs, PathItem.HttpMethod.GET, "/db/policies/{id}", "복지정책 API", "복지정책 상세 조회", "복지정책 식별자로 상세 정보를 조회합니다.");
        add(docs, PathItem.HttpMethod.POST, "/db/uploadCheckPolicy", "복지정책 API", "복지정책 체크 저장", "방문 보고서의 복지정책 체크 상태를 저장합니다.");

        add(docs, PathItem.HttpMethod.GET, "/db/getYangChunConverstationSTTtxt/{reportid}", "명세 호환 API", "양천 STT 원문 조회", "양천구청 보고서의 STT 원본 텍스트를 조회합니다.");
        add(docs, PathItem.HttpMethod.GET, "/db/yangchun_getResultList", "명세 호환 API", "양천 STT 결과 목록 조회", "양천구청 STT 처리 결과 목록을 조회합니다.");
        add(docs, PathItem.HttpMethod.GET, "/db/yangchun_stt_abstract/{id}", "명세 호환 API", "양천 STT 요약 조회", "양천구청 STT 요약과 상담 항목을 조회합니다.");
        add(docs, PathItem.HttpMethod.PATCH, "/db/update_stt_path", "명세 호환 API", "STT 경로 수정", "보고서의 STT 파일 경로를 수정합니다.");
        add(docs, PathItem.HttpMethod.GET, "/db/get_transcript_path", "명세 호환 API", "STT 경로 조회", "보고서의 STT 파일 경로를 조회합니다.");
        add(docs, PathItem.HttpMethod.POST, "/db/update_visit_category", "명세 호환 API", "방문 카테고리 저장", "카테고리 요약 텍스트를 방문 보고서에 저장합니다.");
        add(docs, PathItem.HttpMethod.POST, "/db/setUserToReport", "명세 호환 API", "보고서 사용자 지정", "보고서에 담당 사용자 이메일을 연결합니다.");
        add(docs, PathItem.HttpMethod.GET, "/db/clients/{clientId}", "명세 호환 API", "클라이언트 조회", "클라이언트 식별자로 정보를 조회합니다.");
        add(docs, PathItem.HttpMethod.POST, "/db/clients", "명세 호환 API", "클라이언트 생성", "클라이언트 기본 정보를 생성합니다.");
        add(docs, PathItem.HttpMethod.PUT, "/db/clients/{clientId}", "명세 호환 API", "클라이언트 수정", "클라이언트 식별자로 정보를 수정합니다.");
        add(docs, PathItem.HttpMethod.DELETE, "/db/clients/{clientId}", "명세 호환 API", "클라이언트 삭제", "클라이언트 식별자로 정보를 삭제합니다.");
        add(docs, PathItem.HttpMethod.POST, "/db/policies", "명세 호환 API", "정책 생성", "복지정책 정보를 생성합니다.");
        add(docs, PathItem.HttpMethod.PUT, "/db/policies/{policyId}", "명세 호환 API", "정책 수정", "복지정책 식별자로 정보를 수정합니다.");
        add(docs, PathItem.HttpMethod.DELETE, "/db/policies/{policyId}", "명세 호환 API", "정책 삭제", "복지정책 식별자로 정보를 삭제합니다.");
        add(docs, PathItem.HttpMethod.PUT, "/db/welfare-policies/{userId}", "명세 호환 API", "사용자 복지정책 수정", "사용자에게 연결된 복지정책 목록을 수정합니다.");
        add(docs, PathItem.HttpMethod.GET, "/db/welfare-datas/{userId}", "명세 호환 API", "복지 데이터 조회", "사용자의 처리 완료 복지 데이터를 조회합니다.");
        add(docs, PathItem.HttpMethod.PUT, "/db/welfare-datas/{userId}", "명세 호환 API", "복지 데이터 수정", "사용자의 복지 데이터 목록을 수정합니다.");
        add(docs, PathItem.HttpMethod.POST, "/db/yangchun_stt_upload", "명세 호환 API", "양천 STT 업로드", "양천구청 STT 파일 업로드 처리를 시작합니다.");
        add(docs, PathItem.HttpMethod.POST, "/db/yangchun_stt_upload_policy", "명세 호환 API", "양천 정책 STT 업로드", "사용자 이메일이 포함된 양천구청 STT 업로드를 시작합니다.");
        add(docs, PathItem.HttpMethod.POST, "/db/yangchun_idcard_info_upload", "명세 호환 API", "양천 신분증 정보 업로드", "양천구청 신분증 신청 정보를 업로드합니다.");
        add(docs, PathItem.HttpMethod.GET, "/db/conversation-summary/{summaryId}", "명세 호환 API", "상담 요약 조회", "상담 요약 식별자로 STT 요약 정보를 조회합니다.");
        add(docs, PathItem.HttpMethod.POST, "/db/uploadImages/compat", "명세 호환 API", "이미지 업로드 호환", "기존 명세와 호환되는 이미지 업로드 요청을 처리합니다.");

        return docs;
    }

    private void add(Map<String, ApiDoc> docs, PathItem.HttpMethod method, String path, String tag, String summary, String description) {
        docs.put(key(method, path), new ApiDoc(tag, summary, description));
    }

    private String key(PathItem.HttpMethod method, String path) {
        return method.name() + " " + path;
    }

    private record ApiDoc(String tag, String summary, String description) {
    }
}
