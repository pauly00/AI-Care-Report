# AI-Care-Report-BE

AI 기반 상담 데이터 요약 및 리포트 자동화 시스템의 백엔드 리포지토리입니다. 기존 프론트엔드 프로젝트를 확장하고 개발 역량 강화를 위해 백엔드 아키텍처를 설계 및 구현하였습니다.

## 요구 사항

- Java 17
- Gradle Wrapper (`./gradlew`)
- PostgreSQL (Supabase Transaction Pooler 사용)

## 환경 변수

필수:

- `DB_PASSWORD`: DB 비밀번호
- `JWT_SECRET`: JWT 서명 키 (미지정 시 개발용 기본값 사용)

선택:

- `UPLOAD_DIR`: 업로드 파일 저장 경로 (기본값 `uploads`)

시드 관련(선택):

- `app.seed.enabled` (기본 `true`)
- `app.seed.user-email` (기본 `test@test.com`)
- `app.seed.user-password` (기본 `test123!`)

## 실행 방법

```bash
./gradlew bootRun
```

기본 실행 주소: `http://localhost:8080`

## 개발용 자동 시드

DB가 비어 있을 때 테스트 계정 기준으로 초기 데이터를 자동 생성합니다.

- 계정: `test@test.com` / `test123!`
- 생성 범위: users, targets, visit_reports, visit_summaries, welfare_policies, policy_checks
- 중복 방지: 기존 데이터가 있으면 재삽입하지 않음

## DB 스키마 생성

`spring.jpa.hibernate.ddl-auto=update` 로 동작하므로,
최초 실행 시 필요한 테이블이 자동 생성됩니다.

## API 요약

인증이 필요한 API는 아래 헤더를 사용합니다.

`Authorization: Bearer <token>`

### Auth

| Method | Endpoint | 설명 | 인증 |
|--------|----------|------|------|
| POST | `/db/login` | 로그인(JWT 발급) | No |
| POST | `/db/register` | 회원가입 | No |
| POST | `/db/email_check` | 이메일 중복 체크 | No |
| GET | `/db/users` | 내 정보 조회 | Yes |

### Target

| Method | Endpoint | 설명 | 인증 |
|--------|----------|------|------|
| POST | `/db/addTarget` | 대상자 등록 | Yes |
| GET | `/db/getAllTargets` | 대상자 전체 조회 | Yes |
| GET | `/db/getTargetInfo/:id` | 대상자 상세/최근 이력 | Yes |

### Visit / Report

| Method | Endpoint | 설명 | 인증 |
|--------|----------|------|------|
| POST | `/db/addVisitReport` | 방문 예약 생성 | Yes |
| GET | `/db/getAllVisitReports` | 방문 목록 조회 | Yes |
| GET | `/db/getDefaultReportList` | 리포트 작성 대상 조회 | Yes |
| GET | `/db/getTodayList` | 오늘 일정 조회 | Yes |
| POST | `/db/uploadReportDefaultInfo` | 리포트 기본 정보 저장 | Yes |
| POST | `/db/uploadVisitDetail` | 특이사항 저장 | Yes |
| GET | `/db/visitReportDone?reportid=` | 상담 완료 처리 | Yes |

### STT / Summary

| Method | Endpoint | 설명 | 인증 |
|--------|----------|------|------|
| POST | `/db/uploadCallRecord` | 녹음 파일 업로드 | Yes |
| GET | `/db/getConverstationSTTtxt/:id` | STT 텍스트 조회 | Yes |
| GET | `/db/getVisitDetails/:id` | 요약 데이터 조회 | Yes |
| POST | `/db/uploadEditAbstract` | 요약 수정 저장 | Yes |
| POST | `/db/uploadImages` | 이미지 업로드 | Yes |

### Welfare / Policy

| Method | Endpoint | 설명 | 인증 |
|--------|----------|------|------|
| GET | `/db/welfare-policies/:targetId` | 대상자별 추천 정책 | Yes |
| GET | `/db/welfare-policies` | 정책 목록 조회 | Yes |
| GET | `/db/policies/:id` | 정책 상세 조회 | Yes |
| POST | `/db/uploadCheckPolicy` | 정책 체크 저장 | Yes |

## 디렉토리 구조

```
src/main/java/com/pauly/AI_Care_Report_BE/
├── controller/   # REST API
├── service/      # 비즈니스 로직
├── repository/   # JPA Repository
├── entity/       # 엔티티
├── dto/          # 요청/응답 DTO
└── config/       # 보안, JWT, 시드, CORS 등 설정
```

## 기술 스택

| 항목 | 내용 |
|------|------|
| Language | Java 17 |
| Framework | Spring Boot 3.3.5 |
| Build Tool | Gradle |
| Database | PostgreSQL (Supabase) |
| ORM | Spring Data JPA |
| Security | Spring Security + JWT |
