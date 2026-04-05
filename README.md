# AI-Care-Report

AI 기반 상담 데이터 요약 및 리포트 자동화 시스템입니다. 
본 프로젝트는 미래내일 일경험 사업의 일환으로 수행되었으며 한전 MCS의 전국 단위 돌봄 사업을 지원하기 위한 기술적 해결책을 개발하였습니다. 팀 단위 스타트업 프로젝트 형식을 통해 현장의 상담 데이터를 구조화하고 행정 업무를 자동화하는 시스템을 구축하였습니다.



## 프로젝트 개요

| 항목 | 내용 |
|------|------|
| 주제 | AI 기반 상담 데이터 요약 및 리포트 자동화 시스템 |
| 수행 기간 | 2025.07.16 ~ 2025.08.29 |
| 수행 기관 | 솔트웨어(주) 미래내일 일경험 (인턴) |

## 실행 화면

| 회원가입 | 로그인 | 홈 화면 | 방문 진행 | 기록 관리 | 리포트 관리 | 마이페이지 |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| [![signup](FE/lib/docs/images/signup.png)](FE/lib/docs/images/signup.png) | [![login](FE/lib/docs/images/login.png)](FE/lib/docs/images/login.png) | [![home](FE/lib/docs/images/home.png)](FE/lib/docs/images/home.png) | [![visit](FE/lib/docs/images/visit.png)](FE/lib/docs/images/visit.png) | [![record](FE/lib/docs/images/record.png)](FE/lib/docs/images/record.png) | [![report](FE/lib/docs/images/report.png)](FE/lib/docs/images/report.png) | [![mypage](FE/lib/docs/images/mypage.png)](FE/lib/docs/images/mypage.png) |

## 시연 영상

[Demo Video](https://www.youtube.com/watch?v=rGAkDS2AEVM)

## 레포지토리 구조

```
AI-Care-Report/
├── BE/  # Spring Boot 백엔드
└── FE/  # Flutter 프론트엔드
```

- 백엔드 상세 문서: [BE/README.md](BE/README.md)
- 프론트엔드 상세 문서: [FE/README.md](FE/README.md)

## 빠른 시작

### 1) 백엔드 실행

필수 환경 변수:

- `DB_PASSWORD`: PostgreSQL(Supabase) 비밀번호
- `JWT_SECRET`: JWT 서명 키 (32자 이상 권장)

```bash
cd BE
./gradlew bootRun
```

백엔드는 기본적으로 `http://localhost:8080` 에서 동작합니다.

### 2) 프론트엔드 실행

```bash
cd FE
flutter pub get
flutter run
```

기본 API 주소는 `FE/lib/core/constants.dart` 에서 관리합니다.

## 테스트 계정 및 자동 시드

개발 편의를 위해 백엔드가 비어 있는 경우 테스트 계정 데이터를 자동 생성합니다.

- 계정: `test@test.com`
- 비밀번호: `test123!`
- 시드 위치: 백엔드 시작 시 (`BE`)
- 생성 데이터: 사용자/대상자/방문리포트/요약/복지정책/정책체크

이미 데이터가 존재하면 중복 삽입하지 않습니다.

## 주요 기능

- 인증: JWT 로그인, 회원가입, 이메일 중복체크, 자동 로그인
- 홈: 오늘 일정, 미작성 리포트, 추천 정책 건수 요약
- 방문: 방문/전화 돌봄 목록, 체크리스트, 상담 완료 처리
- 리포트: 단계별 입력/요약/이미지/정책 체크/완료
- 기록/관리: 월별 대상자 기록, 통합 리포트 관리
- 마이페이지: 사용자 정보 및 통계 확인


## 기술 스택

### 백엔드

| 항목 | 내용 |
|------|------|
| Language | Java 17 |
| Framework | Spring Boot 3.3.5 |
| Build Tool | Gradle (Groovy) |
| Database | PostgreSQL (Supabase) |
| ORM | Spring Data JPA |
| 인증 | Spring Security + JWT |

### 프론트엔드

| 항목 | 내용 |
|------|------|
| Framework | Flutter 3.32 (Dart 3.8) |
| Architecture | MVVM |
| State Management | Provider |
| Network | REST API (`http`) |
| Real-time | WebSocket (STT) |
