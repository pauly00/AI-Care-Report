# AI-Care-Report-FE

AI 기반 상담 데이터 요약 및 돌봄 리포트 자동화 서비스의 Flutter 프론트엔드입니다.

## 실행 방법

```bash
flutter pub get
flutter run
```

현재 시연 기준 플랫폼은 Android입니다. `ios`, `web`, `linux`, `macos`, `windows` 폴더는 분석 범위와 관리 복잡도를 줄이기 위해 제거했으며, 추후 필요 시 `flutter create .` 명령으로 다시 생성할 수 있습니다.

## 요구 사항

- Flutter 3.32+
- Dart 3.8+
- Android SDK

## API 주소 설정

기본 API 주소는 `lib/core/constants.dart`에서 관리합니다.

- Android Emulator: `http://10.0.2.2:8080`
- 실제 Android 기기: PC 로컬 IP 또는 배포 도메인으로 변경 필요

## 주요 기능

- Auth: 로그인, 회원가입, 이메일 중복 확인, JWT 저장 및 자동 로그인
- Home: 오늘 일정 조회, 미작성 리포트와 추천 정책 요약
- Visit: 방문/전화 상담 목록, 상담 체크, 녹음 파일 업로드, STT 연동
- Report: 단계별 리포트 작성, 상담 요약 확인, 위험 정보 확인, 복지정책 추천, 리포트 완료
- Manage / Record: 대상자 기록 조회, 통합 리포트 관리, 검색
- MyPage: 사용자 정보와 통계 확인

## 테스트

프론트 테스트는 README의 주요 기능을 기준으로 아래 순서로 확장합니다.

```bash
flutter test
flutter analyze
```

우선 적용된 테스트:

- `UserModel.fromJson` 모델 변환 테스트
- `formatTime` 방문 시간 표시 테스트

추가 예정 테스트:

- 로그인/회원가입 ViewModel 테스트
- 방문 목록 ViewModel 테스트
- 리포트 단계 화면 위젯 테스트
- API Service Mock 테스트

## 디렉터리 구조

```text
lib/
├─ core/         # 상수 및 환경 설정
├─ model/        # 데이터 모델
├─ repository/   # 데이터 접근 계층
├─ service/      # API 및 외부 연동
├─ view_model/   # 화면 상태 및 비즈니스 로직
├─ view/         # 화면 UI
├─ widget/       # 공통 위젯
├─ provider/     # 전역 상태
├─ main.dart
└─ main_screen.dart
```
