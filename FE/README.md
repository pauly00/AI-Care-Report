# AI-Care-Report-FE

AI 기반 상담 데이터 요약 및 리포트 자동화 시스템의 프론트엔드 레포지토리입니다. 
본 프로젝트는 미래내일 일경험 사업의 일환으로 수행되었으며 한전 MCS의 전국 단위 돌봄 사업을 지원하기 위한 기술적 해결책을 개발하였습니다. 팀 단위 스타트업 프로젝트 형식을 통해 현장의 상담 데이터를 구조화하고 행정 업무를 자동화하는 시스템을 구축하였습니다.


## 실행 방법

```bash
flutter pub get
flutter run
```

## 요구 사항

- Flutter 3.32+
- Dart 3.8+

## API 주소 설정

기본 API 주소는 `lib/core/constants.dart` 에서 관리합니다.

- Android Emulator: `http://10.0.2.2:8080`
- 실제 디바이스: PC의 로컬 IP 또는 배포 도메인으로 변경 필요

## 테스트 계정 안내

- 이메일: `test@test.com`
- 비밀번호: `test123!`

주의:

- 테스트 데이터 자동 생성(시드)은 백엔드 시작 시 동작합니다.
- 프론트엔드는 별도 더미 적재 로직을 갖고 있지 않습니다.

## 주요 화면/기능

### Auth

- 로그인/회원가입
- 이메일 중복 체크
- 토큰 저장 및 자동 로그인

### Home

- 오늘 일정 조회
- 미작성 리포트/추천 정책 건수 요약
- 일정 시간순 정렬 렌더링

### Visit

- 방문/전화 돌봄 목록
- 상담 체크/완료 흐름
- 음성 파일 업로드 및 STT 연계

### Report

- 단계별 리포트 작성 화면
- 대상자/요약/정책 체크 데이터 연동

### Manage / Record

- 월별 대상자 기록 조회
- 통합 리포트 관리(대상자 카드, 검색, 통계)

### MyPage

- 사용자 정보 및 통계 확인

## UI 시연 이미지

| 회원가입 | 로그인 | 홈 화면 | 방문 진행 | 기록 관리 | 리포트 관리 | 마이페이지 |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| [![signup](lib/docs/images/signup.png)](lib/docs/images/signup.png) | [![login](lib/docs/images/login.png)](lib/docs/images/login.png) | [![home](lib/docs/images/home.png)](lib/docs/images/home.png) | [![visit](lib/docs/images/visit.png)](lib/docs/images/visit.png) | [![record](lib/docs/images/record.png)](lib/docs/images/record.png) | [![report](lib/docs/images/report.png)](lib/docs/images/report.png) | [![mypage](lib/docs/images/mypage.png)](lib/docs/images/mypage.png) |

## 시연 영상

[Demo Video](https://www.youtube.com/watch?v=rGAkDS2AEVM)

## 기술 스택

| 항목 | 내용 |
|------|------|
| Framework | Flutter 3.32 (Dart 3.8) |
| Architecture | MVVM |
| State Management | Provider |
| Network | REST API (`http`) |
| Auth | JWT 기반 인증 |
| Real-time | WebSocket (STT) |

## 디렉토리 구조

```
lib/
├── core/         # 상수/설정
├── model/        # 데이터 모델
├── repository/   # 데이터 액세스 계층
├── service/      # API/외부 연동
├── view_model/   # 화면 상태 및 비즈니스 로직
├── view/         # 화면 UI
├── widget/       # 공통 위젯
├── provider/     # 전역 상태
├── main.dart
└── main_screen.dart
```
