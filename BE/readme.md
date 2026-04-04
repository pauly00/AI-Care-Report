# AI-Care-Report-BE

AI 기반 상담 데이터 요약 및 리포트 자동화 시스템의 **백엔드 리포지토리**입니다.

## 기술 스택

| 항목 | 내용 |
|------|------|
| **Language** | Java 17 |
| **Framework** | Spring Boot 4.0.2 |
| **Build Tool** | Gradle (Groovy) |
| **Database** | PostgreSQL (Supabase) |
| **ORM** | Spring Data JPA (Hibernate) |
| **인증** | JWT (JJWT 0.12.6) + Spring Security |
| **Frontend** | Flutter (AI-Care-Report-FE) — `http://localhost:8080` 연결 |

---

## 실행 방법

### 1. 환경 변수 설정

IntelliJ의 `Run/Debug Configurations → Environment variables` 에 아래 두 값을 추가합니다.

| 변수명 | 설명 |
|--------|------|
| `DB_PASSWORD` | Supabase 데이터베이스 비밀번호 |
| `JWT_SECRET` | JWT 서명 키 (32자 이상 권장, 생략 시 기본값 사용) |

### 2. DB 스키마

`spring.jpa.hibernate.ddl-auto=update` 설정으로 **서버 최초 실행 시 테이블이 자동 생성**됩니다.

생성되는 테이블:
- `users` — 사회복지사 계정
- `targets` — 돌봄 대상자
- `visit_reports` — 방문 보고서
- `visit_summaries` — AI 요약 항목
- `welfare_policies` — 복지 정책
- `policy_checks` — 보고서별 정책 체크 현황

### 3. 서버 실행

```bash
./gradlew bootRun
# 또는 IntelliJ에서 AiCareReportBeApplication 실행
```

서버는 `http://localhost:8080` 에서 동작합니다.

---

## API 엔드포인트

> 인증이 필요한 API는 `Authorization: Bearer <token>` 헤더 필요

### 인증 (Auth)

| 메서드 | 엔드포인트 | 설명 | 인증 |
|--------|-----------|------|------|
| POST | `/db/login` | 로그인 → JWT 발급 | ❌ |
| POST | `/db/register` | 회원가입 | ❌ |
| POST | `/db/email_check` | 이메일 중복 체크 | ❌ |
| GET | `/db/users` | 내 정보 조회 | ✅ |

### 대상자 관리 (Target)

| 메서드 | 엔드포인트 | 설명 | 인증 |
|--------|-----------|------|------|
| POST | `/db/addTarget` | 대상자 등록 | ✅ |
| GET | `/db/getAllTargets` | 전체 대상자 조회 | ✅ |
| GET | `/db/getTargetInfo/:id` | 대상자 상세 + 최근 방문 이력 | ✅ |

### 방문 보고서 (VisitReport)

| 메서드 | 엔드포인트 | 설명 | 인증 |
|--------|-----------|------|------|
| POST | `/db/addVisitReport` | 방문 예약 생성 | ✅ |
| GET | `/db/getAllVisitReports` | 전체 방문 목록 | ✅ |
| GET | `/db/getDefaultReportList` | 보고서 작성용 목록 | ✅ |
| GET | `/db/getTodayList` | 오늘 방문 목록 | ✅ |
| POST | `/db/uploadReportDefaultInfo` | 보고서 기본 정보 저장 | ✅ |
| POST | `/db/uploadVisitDetail` | 특이사항 저장 | ✅ |
| GET | `/db/visitReportDone?reportid=` | 상담 완료 처리 | ✅ |

### STT / AI 분석

| 메서드 | 엔드포인트 | 설명 | 인증 |
|--------|-----------|------|------|
| POST | `/db/uploadCallRecord` | 녹음 파일 업로드 (multipart) | ✅ |
| GET | `/db/getConverstationSTTtxt/:id` | STT 변환 텍스트 조회 | ✅ |
| GET | `/db/getVisitDetails/:id` | AI 요약 조회 | ✅ |
| POST | `/db/uploadEditAbstract` | 요약 수정 저장 | ✅ |
| POST | `/db/uploadImages` | 이미지 업로드 (multipart) | ✅ |

### 복지 정책 (Welfare)

| 메서드 | 엔드포인트 | 설명 | 인증 |
|--------|-----------|------|------|
| GET | `/db/welfare-policies/:targetId` | 대상자별 적합 정책 | ✅ |
| GET | `/db/welfare-policies` | 전체 정책 목록 | ✅ |
| GET | `/db/policies/:id` | 정책 상세 | ✅ |
| POST | `/db/uploadCheckPolicy` | 정책 체크 현황 저장 | ✅ |

---

## 디렉토리 구조

```
src/main/java/com/pauly/AI_Care_Report_BE/
├── controller/       # REST API 엔드포인트
│   ├── AuthController.java
│   ├── TargetController.java
│   ├── VisitReportController.java
│   └── WelfareController.java
├── service/          # 비즈니스 로직
│   ├── AuthService.java
│   ├── TargetService.java
│   ├── VisitReportService.java
│   └── WelfareService.java
├── repository/       # JPA Repository 인터페이스
├── entity/           # JPA 엔티티 (DB 테이블 모델)
├── dto/              # 요청/응답 데이터 모델
└── config/           # JWT, Spring Security, CORS 설정
```

---

## FE 연동 시 주의사항

- Flutter FE의 `lib/core/constants.dart` → `baseUrl = "http://localhost:8080"` 설정 확인
- **STT 기능**: 현재는 파일만 저장되며 실제 음성 인식은 별도 STT 서비스 연동 필요
- **업로드 경로**: 서버 루트의 `uploads/` 폴더에 저장됨 (환경변수 `UPLOAD_DIR`로 변경 가능)
- **비밀번호**: BCrypt 해시 저장. 기존 평문 비밀번호 계정은 재가입 필요

## 네트워크 설정

공용 네트워크에서 5432 포트 차단 시 Supabase **6543 포트 (Transaction Pooler)** 사용
