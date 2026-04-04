# AI-Care-Report-FE

AI 기반 상담 데이터 요약 및 리포트 자동화 시스템의 프론트엔드 레포지토리입니다. 본 프로젝트는 미래내일 일경험 사업의 일환으로 수행되었으며 한전 MCS의 전국 단위 돌봄 사업을 지원하기 위한 기술적 해결책을 개발하였습니다. 팀 단위 스타트업 프로젝트 형식을 통해 현장의 상담 데이터를 구조화하고 행정 업무를 자동화하는 시스템을 구축하였습니다.

---

## 실행 방법

```bash
# 의존성 패키지 설치
flutter pub get

# 프로젝트 실행
flutter run
```

---

## 프로젝트 개요

| 항목 | 내용 |
|------|------|
| **주제** | AI 기반 상담 데이터 요약 및 리포트 자동화 시스템 |
| **수행 기간** | 2025.07.16 ~ 2025.08.29 |
| **수행 기관** | [솔트웨어(주)] 미래내일 일경험 인턴십 |


---

## 주요 기능

### 인증 (Auth)

JWT 기반 로그인 및 회원가입 플로우를 제공합니다.

- 역할 선택 → 약관 동의 → 회원가입 폼의 3단계 온보딩 플로우
- 이메일 중복 체크 API 연동
- `login_storage_helper.dart`를 통한 토큰 저장 및 자동 로그인 세션 유지

관련 파일: `view/login/`, `view/signup/`, `service/signup_service.dart`, `util/login_storage_helper.dart`

### 홈 화면 (Home)

사회복지사의 하루 업무 현황을 한눈에 확인할 수 있는 대시보드입니다.

- 오늘 방문 일정 및 미작성 리포트 현황 카드 표시
- `today_visit_service` / `today_visit_view_model` 연동으로 실시간 방문 데이터 렌더링
- 맞춤형 복지 서비스 추천 알림 제공

관련 파일: `view/home/`, `service/today_visit_service.dart`, `view_model/today_visit_view_model.dart`

### 방문 및 상담 관리 (Visit)

방문 대상자 관리부터 상담 녹음까지 현장 업무 전체 흐름을 지원합니다.

- 방문 대상자 목록 조회 및 상세 정보 확인
- WebSocket 기반 실시간 STT 녹음 및 텍스트 변환 (`websocket_service.dart`, Broadcast Stream 관리)
- 방문 체크리스트 (2단계) 및 특이사항 입력
- 복지 정책 추천 화면 연동 및 방문 완료 처리 API 연동

관련 파일: `view/visit/`, `service/visit_service.dart`, `service/websocket_service.dart`, `service/audio_service.dart`, `view_model/visit/`

### 리포트 자동화 (Report)

상담 데이터를 기반으로 AI가 요약한 리포트를 6단계 프로세스로 작성합니다.

| 단계 | 내용 |
|------|------|
| 1단계 | 보고서 기본 정보 입력 |
| 2단계 | STT 변환 대화 내용 조회 |
| 3단계 | AI 요약 내용 확인 및 수정 |
| 4단계 | 현장 이미지 업로드 (멀티파트) |
| 5단계 | 복지 정책 체크 |
| 6단계 | 리포트 완료 및 미리보기 |

관련 파일: `view/report/report_1.dart` ~ `report_6.dart`, `service/visit_summary_service.dart`, `view_model/visit_summary_view_model.dart`

### 복지 정책 추천 (Welfare)

대상자 특성에 맞는 복지 정책을 AI가 추천합니다.

- 대상자별 적합 정책 API 연동 (`welfare_service.dart`, `welfare_repository.dart`)
- 정책 카드 UI 및 외부 정책 링크 연결 (`url_launcher`)

관련 파일: `service/welfare_service.dart`, `repository/welfare_repository.dart`, `view/visit/visit_welfare_recommend.dart`

### 기록 관리 (Record / Manage)

월별 대상자별 방문 이력 및 리포트를 관리합니다.

- 월별 대상자 현황 및 리포트 목록 조회
- 방문 이전 기록 열람 및 케어 리포트 상세 확인

관련 파일: `view/record/`, `view/manage/`, `view/report/monthly_target_page.dart`

### 마이페이지 (MyPage)

사용자 정보 조회 및 앱 설정을 제공합니다.

관련 파일: `view/mypage/mypage.dart`, `service/user_service.dart`, `view_model/user_view_model.dart`

---

## UI 시연 이미지

| 회원가입 | 로그인 | 홈 화면 | 방문 진행 | 기록 관리 | 리포트 관리 | 마이페이지 |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| [![signup](lib/docs/images/signup.png)](lib/docs/images/signup.png) | [![login](lib/docs/images/login.png)](lib/docs/images/login.png) | [![home](lib/docs/images/home.png)](lib/docs/images/home.png) | [![visit](lib/docs/images/visit.png)](lib/docs/images/visit.png) | [![record](lib/docs/images/record.png)](lib/docs/images/record.png) | [![report](lib/docs/images/report.png)](lib/docs/images/report.png) | [![mypage](lib/docs/images/mypage.png)](lib/docs/images/mypage.png) |

---

## 시연 영상

[Demo Video](https://www.youtube.com/watch?v=rGAkDS2AEVM)

---

## 기술 스택

| 항목 | 내용 |
|------|------|
| **Framework** | Flutter 3.32 (Dart 3.8) |
| **Architecture** | MVVM (Model-View-ViewModel) |
| **State Management** | Provider |
| **Network** | http 패키지 기반 RESTful API |
| **Auth** | JWT 기반 인증 + 자동 로그인 |
| **Real-time** | WebSocket 기반 실시간 STT |
| **Design Pattern** | Atomic Design 기반 위젯 모듈화 |


---

## 디렉토리 구조

```
lib/
├── core/
│   └── constants.dart                  # API 주소 및 공통 상수
├── model/
│   ├── user_model.dart                 # 사용자 정보 모델
│   ├── user_register_model.dart        # 회원가입 요청 모델
│   ├── today_visit.dart                # 오늘 방문 모델
│   ├── visit_model.dart                # 방문 목록 모델
│   ├── visit_detail_model.dart         # 방문 상세 모델
│   ├── visit_summary_model.dart        # AI 요약 모델
│   ├── report_model.dart               # 리포트 모델
│   ├── monthly_report_item.dart        # 월별 리포트 항목
│   └── welfare_policy_model.dart       # 복지 정책 모델
├── provider/
│   ├── id/report_id.dart               # 리포트 ID 전역 상태
│   └── nav/bottom_nav_provider.dart    # 하단 내비게이션 상태
├── repository/
│   ├── user_repository.dart
│   ├── visit_repository.dart
│   ├── visit_summary_repository.dart
│   ├── report_repository.dart
│   └── welfare_repository.dart
├── service/
│   ├── user_service.dart               # 사용자 정보 API
│   ├── signup_service.dart             # 회원가입 API
│   ├── today_visit_service.dart        # 홈 화면 방문 데이터 API
│   ├── visit_service.dart              # 방문 관리 API
│   ├── visit_summary_service.dart      # AI 요약 API
│   ├── summary_service.dart            # 요약 가공 로직
│   ├── report_service.dart             # 리포트 API
│   ├── audio_service.dart              # 녹음 파일 처리
│   ├── websocket_service.dart          # 실시간 STT WebSocket
│   └── welfare_service.dart            # 복지 정책 API
├── util/
│   ├── http_helper.dart                # JWT 자동 주입 HTTP 클라이언트
│   ├── login_storage_helper.dart       # 토큰 저장 및 자동 로그인
│   ├── connectivity.dart               # 네트워크 연결 상태 체크
│   ├── responsive.dart                 # 태블릿/모바일 반응형 유틸
│   └── format_time.dart                # 시간 포맷 유틸
├── view/
│   ├── login/login_page.dart
│   ├── signup/                         # 역할선택 → 약관동의 → 회원가입 폼
│   ├── home/                           # 홈 대시보드
│   ├── visit/                          # 방문 목록, 상세, 상담 녹음, 체크리스트
│   ├── report/                         # 리포트 작성 6단계 (report_1 ~ report_6)
│   ├── record/                         # 방문 기록 조회
│   ├── manage/                         # 리포트 관리
│   └── mypage/mypage.dart
├── view_model/
│   ├── user_view_model.dart
│   ├── signup_view_model.dart
│   ├── today_visit_view_model.dart
│   ├── visit_summary_view_model.dart
│   ├── report_view_model.dart
│   └── visit/
│       ├── visit_list_view_model.dart
│       ├── visit_call_view_model.dart
│       └── visit_policy_view_model.dart
├── widget/
│   ├── appbar/                         # 공통 AppBar (기본, 뒤로가기)
│   ├── bottom_menubar/                 # 하단 내비게이션 바
│   ├── button/                         # 하단 버튼 (1개, 2개)
│   ├── card/                           # 방문 목록 카드, 월별 카드
│   ├── loading/                        # 공통 로딩 위젯
│   └── search/                         # 검색 바
├── main_screen.dart                    # 바텀 내비게이션 메인 화면
└── main.dart                           # 앱 진입점 및 Provider 등록
```
