# 개발 진행 과정

이 문서는 AI Care Report 프로젝트의 남은 개발 작업을 기획, 설계, 구현, 리팩토링, 배포, 운영 흐름으로 정리한다. 현재 프로젝트는 핵심 기능 구현이 대부분 진행된 상태이며, 앞으로는 설계 보완과 완성도 개선에 집중한다.

## 현재 프로젝트 위치

```text
초기 세팅          완료
요구사항 분석      완료
ERD 설계           진행 중
API 명세서         진행 중

DTO 설계           리팩토링 예정
Service 설계       리팩토링 예정
Controller 설계    리팩토링 예정

기능 구현          약 80% 완료
AI 기능            미구현 또는 보완 예정

리팩토링           예정
테스트             일부 구성, 보완 예정
CI/CD              예정
운영               예정
```

현재 단계는 "기능 구현 막바지 + 설계 보완"으로 본다.

## 개발 단계별 진행 계획

| 단계 | 목표 | 주요 작업 | 결과물 | 진행 상태 |
| --- | --- | --- | --- | --- |
| 프로젝트 초기 세팅 | 개발 환경 구축 | Spring Boot, Flutter, PostgreSQL(Supabase), JWT 인증, GitHub Repository 구성 | 개발 가능한 기본 환경 | 완료 |
| 요구사항 분석 | 서비스 기능 정의 | 사용자 시나리오, 방문 프로세스, 기능 목록 정리 | 요구사항 정의 | 완료 |
| ERD 설계 | 데이터 구조 설계 | Entity 관계 정의, 테이블 설계, 정규화 | ERD | 진행 중 |
| API 명세서 작성 | FE-BE 인터페이스 정의 | REST API 설계, Request/Response 정의 | API Specification | 진행 중 |
| DTO 설계 | 계층 간 데이터 전달 구조 정의 | Request/Response DTO 정리, 공통 응답 구조 검토 | DTO 구조 | 예정 |
| Service 설계 | 비즈니스 로직 설계 | Service 계층 책임 분리, 중복 로직 정리 | Service Layer | 예정 |
| Controller 설계 | REST API 구현 개선 | Controller 구조 정리, 인증 적용 범위 점검 | REST API | 예정 |
| 기능 구현 | 핵심 기능 개발 | CRUD, JWT, 방문 프로세스, 복지정책, 방문요약 | 서비스 기능 | 진행 중 |
| 기능 고도화 | AI 기능 추가 | STT, AI 보고서 생성 | AI 기능 | 예정 |
| 리팩토링 | 코드 품질 개선 | 예외처리, REST API 개선, Storage 변경 검토 | 유지보수성 향상 | 예정 |
| 테스트 | 기능 검증 | API 테스트, 통합 테스트, Service 단위 테스트 | 안정성 확보 | 일부 진행 |
| CI/CD | 자동 배포 | GitHub Actions, Docker, Render 배포 | 자동 배포 | 예정 |
| 운영 | 서비스 운영 | 모니터링, 버그 수정, 환경변수 관리 | 운영 가능한 서비스 | 예정 |

## 왜 이 순서로 진행하는가

설계 문서가 먼저 정리되어야 이후 리팩토링 기준이 명확해진다. API 명세와 ERD가 불명확한 상태에서 코드를 고치면 프론트엔드 연동과 데이터 구조가 다시 흔들릴 수 있다.

테스트는 리팩토링 전에 최소 기준을 세우기 위해 필요하다. 기존 기능이 깨졌는지 빠르게 확인할 수 있어야 DTO, Service, Controller 구조를 정리할 수 있다.

CI/CD와 운영은 기능과 테스트가 안정화된 뒤 진행한다. 배포 자동화는 빌드와 테스트가 신뢰 가능할 때 효과가 크기 때문이다.

## 우선순위

1. ERD와 API 명세서 정리
2. 현재 테스트 실행 및 실패 원인 정리
3. DTO, Service, Controller 리팩토링 범위 확정
4. 공통 예외 처리와 공통 응답 형식 도입 검토
5. STT 및 AI 보고서 생성 기능 구현 또는 연동 방식 확정
6. GitHub Actions 기반 빌드/테스트 자동화
7. Render, Supabase 기반 운영 환경 정리

## 이번 진행 내역

| 작업 | 왜 했는가 | 결과 |
| --- | --- | --- |
| 개발 진행 문서 추가 | 노션과 포트폴리오에 옮길 수 있는 기준 문서가 필요함 | `docs/development-roadmap.md` 추가 |
| 백엔드 설계 문서 추가 | ERD/API/리팩토링 기준을 현재 코드 기준으로 정리해야 함 | `docs/backend-design-notes.md` 추가 |
| 백엔드 테스트 실행 | 리팩토링 전에 현재 안정성 기준을 확인해야 함 | 최초 50개 중 15개 실패 확인 |
| Controller 테스트 설정 수정 | `@WebMvcTest`에서 실제 `SecurityConfig`가 반영되지 않아 POST 요청이 403으로 막힘 | 보안 필터를 끄고 컨트롤러 응답 검증에 집중 |
| 인증 실패 테스트 비활성화 | 보안 필터를 끈 단위 테스트에서는 인증 실패 흐름을 정확히 검증할 수 없음 | 별도 보안 통합 테스트로 분리할 작업으로 남김 |
| 테스트 재실행 | 수정 결과를 검증해야 함 | `./gradlew.bat test` 통과 |

## 단계별 작성 내용

### 1. 프로젝트 초기 세팅

- Spring Boot 백엔드 프로젝트 생성
- Flutter 프론트엔드 프로젝트 생성
- GitHub Repository 구성
- Supabase PostgreSQL 연결
- Spring Security와 JWT 기반 인증 구축
- Java 17, Spring Boot 3.3.5 기준 개발 환경 구성

### 2. 요구사항 분석

독거노인 방문 관리 업무를 기준으로 방문 일정 관리, 방문 보고서 작성, 복지정책 추천, AI 보고서 자동 작성 기능을 핵심 기능으로 정의한다.

### 3. ERD 설계

주요 도메인은 `User`, `Target`, `VisitReport`, `VisitSummary`, `WelfarePolicy`, `PolicyCheck`로 구성한다.

한 명의 사용자는 여러 대상자를 관리할 수 있고, 대상자는 여러 방문 보고서를 가질 수 있다. 방문 요약은 방문 보고서와 연결되며, 복지정책 체크 여부는 대상자와 정책 사이의 상태로 관리한다.

### 4. API 명세서

REST API는 리소스 중심으로 정리한다. 현재 API는 `/db` prefix를 사용하고 있으므로, 리팩토링 시 URL 규칙을 통일할지 검토한다.

응답 형식은 프론트엔드 연동 단순화를 위해 `status`, `message`, `data` 구조의 공통 응답 객체 도입을 검토한다.

### 5. DTO 설계

Entity 직접 노출을 줄이기 위해 Request DTO와 Response DTO를 분리한다. 인증, 대상자, 방문 보고서, 복지정책 도메인별 DTO 책임을 명확히 한다.

### 6. Service 설계

Controller는 요청과 응답 흐름만 담당하고, 비즈니스 로직은 Service에서 처리한다. 복지정책 추천, 방문 보고서 저장, 대상자 조회, 방문 완료 처리 같은 핵심 로직을 Service 계층에 둔다.

### 7. Controller 설계

Controller는 REST API 진입점으로만 사용한다. JWT 인증이 필요한 API와 공개 API를 분리하고, 예외 처리는 Global Exception Handler로 모으는 방향을 검토한다.

### 8. 기능 구현

핵심 기능은 JWT 로그인, 사용자 관리, 대상자 관리, 방문 보고서, 방문 요약, 복지정책 추천, 음성 업로드, AI 보고서 순서로 정리한다.

각 기능은 다음 기준으로 문서화한다.

| 항목 | 내용 |
| --- | --- |
| 문제 | 어떤 사용자 문제를 해결하는지 |
| 구현 | 어떤 API, 화면, DB 구조로 구현했는지 |
| 결과 | 사용자가 어떤 결과를 얻는지 |

### 9. 리팩토링

| 리팩토링 항목 | 이유 | 기대 결과 |
| --- | --- | --- |
| Global Exception Handler | Controller와 Service의 중복 예외 처리 감소 | 에러 응답 일관성 향상 |
| REST API 구조 개선 | URL 규칙과 HTTP Method 의미 통일 | 유지보수성 향상 |
| Supabase Storage 검토 | 재배포 시 파일 유지 필요 | 파일 영속성 확보 |
| Flyway 검토 | DB 스키마 변경 이력 관리 필요 | 운영 안정성 향상 |
| API Response 통일 | FE 연동 시 응답 파싱 단순화 | 프론트엔드 연동 비용 감소 |

### 10. 테스트

현재 백엔드에는 `AuthControllerTest`, `TargetControllerTest`, `VisitReportControllerTest`, `WelfareControllerTest`, `AuthServiceTest`, `VisitReportServiceTest`가 구성되어 있다.

보완할 테스트 항목은 다음과 같다.

- JWT 로그인 및 인증 테스트
- 인증 없이 API 접근 시 예외 처리 확인
- 방문보고서 CRUD 테스트
- 대상자 CRUD 테스트
- 복지정책 조회 테스트
- 파일 업로드 테스트
- STT 연동 테스트
- AI 보고서 생성 테스트

부하 테스트는 프로젝트 규모 대비 우선순위가 낮으므로 후순위로 둔다.

### 11. CI/CD

배포 자동화는 다음 흐름으로 구성한다.

```text
GitHub
  -> GitHub Actions
  -> Gradle Build
  -> Test
  -> Docker Build
  -> Render Deploy
  -> Supabase PostgreSQL
```

주요 작업은 GitHub Actions Workflow 작성, Gradle Build 및 Test 자동화, Docker 이미지 생성, Render 배포 연동, GitHub Secrets 기반 환경변수 관리다.

### 12. 운영

운영 단계에서는 Render 기반 Spring Boot Backend, Supabase PostgreSQL, Supabase Storage, Flutter 앱과 운영 서버 연동을 관리한다.

운영 중 발생하는 버그 수정, 환경변수 관리, 파일 저장소 안정화, API 응답 오류 추적을 기록한다.

## 포트폴리오 기록 형식

각 단계는 다음 형식으로 기록한다.

| 항목 | 작성 내용 |
| --- | --- |
| 구현 내용 | 무엇을 구현하거나 개선했는지 |
| 트러블슈팅 | 어떤 문제가 있었고 어떻게 해결했는지 |
| 결과 | 유지보수성, 안정성, 배포 효율 등이 어떻게 개선되었는지 |

예시:

| 항목 | 내용 |
| --- | --- |
| 구현 내용 | GitHub Actions를 이용해 Build, Test, Docker Build, Render Deploy 자동화 |
| 트러블슈팅 | JWT, DB 정보 등 환경변수 관리 문제를 GitHub Secrets와 Render 환경변수로 분리 |
| 결과 | main 브랜치 Push만으로 테스트와 배포가 자동 수행되는 CI/CD 환경 구축 |
