# AI-Care-Report

AI 기반 상담 데이터 요약 및 리포트 자동화 시스템입니다.
본 프로젝트는 미래내일 일경험 사업의 일환으로 수행되었으며 한전 MCS의 전국 단위 돌봄 사업을 지원하기 위한 기술적 해결책을 개발하였습니다.
팀 단위 스타트업 프로젝트 형식을 통해 현장의 상담 데이터를 구조화하고 행정 업무를 자동화하는 시스템을 구축하였습니다.

---

## 프로젝트 개요

| 항목 | 내용 |
|------|------|
| **주제** | AI 기반 상담 데이터 요약 및 리포트 자동화 시스템 |
| **수행 기간** | 2025.07.16 ~ 2025.08.29 |
| **수행 기관** | [솔트웨어(주)] |

---


## 실행 방법

### 백엔드 (BE)

```bash
# IntelliJ Run/Debug Configurations → Environment variables 설정 후
./gradlew bootRun
# 또는 IntelliJ에서 AiCareReportBeApplication 실행
```

| 변수명 | 설명 |
|--------|------|
| `DB_PASSWORD` | Supabase 데이터베이스 비밀번호 |
| `JWT_SECRET` | JWT 서명 키 (32자 이상 권장, 생략 시 기본값 사용) |

서버는 `http://localhost:8080` 에서 동작합니다.

### 프론트엔드 (FE)

```bash
# 의존성 패키지 설치
flutter pub get

# 프로젝트 실행
flutter run
```

---

## 레포지토리 구조

```
AI-Care-Report/
├── BE/   # Spring Boot 백엔드
└── FE/   # Flutter 프론트엔드
```

- 백엔드 상세: [BE/README.md](BE/README.md)
- 프론트엔드 상세: [FE/README.md](FE/README.md)

---

## 주요 기능

### 인증 (Auth)

JWT 기반 로그인 및 회원가입 플로우를 제공합니다.

- 역할 선택 → 약관 동의 → 회원가입 폼의 3단계 온보딩 플로우
- 이메일 중복 체크 및 BCrypt 비밀번호 해시 저장
- 토큰 자동 저장 및 자동 로그인 세션 유지

### 홈 화면 (Home)

사회복지사의 하루 업무 현황을 한눈에 확인할 수 있는 대시보드입니다.

- 오늘 방문 일정 및 미작성 리포트 현황 카드 표시
- 맞춤형 복지 서비스 추천 알림 제공

### 방문 및 상담 관리 (Visit)

방문 대상자 관리부터 상담 녹음까지 현장 업무 전체 흐름을 지원합니다.

- 방문 대상자 목록 조회 및 상세 정보 확인
- WebSocket 기반 실시간 STT 녹음 및 텍스트 변환
- 방문 체크리스트 (2단계) 및 특이사항 입력
- 방문 완료 처리 API 연동

### 리포트 자동화 (Report)

상담 데이터를 기반으로 AI가 요약한 리포트를 6단계 프로세스로 작성합니다.

| 단계 | 내용 |
|------|------|
| 1단계 | 보고서 기본 정보 입력 |
| 2단계 | STT 변환 대화 내용 조회 |
| 3단계 | AI 요약 내용 확인 및 수정 |
| 4단계 | 현장 이미지 업로드 |
| 5단계 | 복지 정책 체크 |
| 6단계 | 리포트 완료 및 미리보기 |

### 복지 정책 추천 (Welfare)

대상자 특성에 맞는 복지 정책을 AI가 추천합니다.

- 대상자별 적합 정책 API 연동
- 정책 카드 UI 및 외부 정책 링크 연결

### 기록 관리 (Record / Manage)

월별 대상자별 방문 이력 및 리포트를 관리합니다.

- 월별 대상자 현황 및 리포트 목록 조회
- 방문 이전 기록 열람 및 케어 리포트 상세 확인

---

## UI 시연 이미지

| 회원가입 | 로그인 | 홈 화면 | 방문 진행 | 기록 관리 | 리포트 관리 | 마이페이지 |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| [![signup](FE/lib/docs/images/signup.png)](FE/lib/docs/images/signup.png) | [![login](FE/lib/docs/images/login.png)](FE/lib/docs/images/login.png) | [![home](FE/lib/docs/images/home.png)](FE/lib/docs/images/home.png) | [![visit](FE/lib/docs/images/visit.png)](FE/lib/docs/images/visit.png) | [![record](FE/lib/docs/images/record.png)](FE/lib/docs/images/record.png) | [![report](FE/lib/docs/images/report.png)](FE/lib/docs/images/report.png) | [![mypage](FE/lib/docs/images/mypage.png)](FE/lib/docs/images/mypage.png) |

---

## 시연 영상

[Demo Video](https://www.youtube.com/watch?v=rGAkDS2AEVM)

---


## 기술 스택

### 백엔드

| 항목 | 내용 |
|------|------|
| **Language** | Java 17 |
| **Framework** | Spring Boot 3.3.5 |
| **Build Tool** | Gradle (Groovy) |
| **Database** | PostgreSQL (Supabase) |
| **ORM** | Spring Data JPA (Hibernate) |
| **인증** | JWT (JJWT 0.12.6) + Spring Security |

### 프론트엔드

| 항목 | 내용 |
|------|------|
| **Framework** | Flutter 3.32 (Dart 3.8) |
| **Architecture** | MVVM (Model-View-ViewModel) |
| **State Management** | Provider |
| **Network** | http 패키지 기반 RESTful API |
| **Auth** | JWT 기반 인증 + 자동 로그인 |
| **Real-time** | WebSocket 기반 실시간 STT |
| **Design Pattern** | Atomic Design 기반 위젯 모듈화 |
