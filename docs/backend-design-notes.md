# 백엔드 설계 정리

이 문서는 현재 백엔드 코드 기준의 ERD 초안과 API 명세 초안이다. 이후 리팩토링과 포트폴리오 문서 작성 기준으로 사용한다.

## ERD 초안

```text
User 1 --- N Target
User 1 --- N VisitReport
Target 1 --- N VisitReport
VisitReport 1 --- N VisitSummary
VisitReport 1 --- N PolicyCheck
WelfarePolicy 1 --- N PolicyCheck
```

## 주요 테이블

### users

사용자 계정과 권한 정보를 관리한다.

| 컬럼 | 설명 |
| --- | --- |
| id | 사용자 PK |
| email | 로그인 이메일, unique |
| password | 암호화된 비밀번호 |
| name | 사용자 이름 |
| role | 역할 |
| phoneNumber | 연락처 |
| birthdate | 생년월일 |
| gender | 성별 코드 |
| permission | 권한 코드 |
| createdAt | 생성일 |

### targets

사회복지사가 관리하는 대상자 정보를 관리한다.

| 컬럼 | 설명 |
| --- | --- |
| id | 대상자 PK |
| targetname | 대상자 이름 |
| address1 | 기본 주소 |
| address2 | 상세 주소 |
| targetcallnum | 연락처 |
| gender | 성별 코드 |
| age | 나이 |
| region | 지역 |
| user_id | 담당 사용자 FK |
| createdAt | 생성일 |

### visit_reports

방문 일정, 방문 진행 상태, 상담 내용, STT 결과를 관리한다.

| 컬럼 | 설명 |
| --- | --- |
| id | 방문 보고서 PK |
| target_id | 대상자 FK |
| user_id | 담당 사용자 FK |
| visittime | 방문 예정 시간 |
| reportstatus | 방문 상태 |
| visittype | 방문 유형 |
| endtime | 종료 시간 |
| detail | 특이사항 |
| sttText | STT 변환 텍스트 |
| createdAt | 생성일 |

### visit_summaries

방문 보고서의 주제별 요약 정보를 관리한다.

| 컬럼 | 설명 |
| --- | --- |
| id | 요약 PK |
| report_id | 방문 보고서 FK |
| subject | 요약 주제 |
| summaryText | 요약 본문 |
| detail | 상세 내용 |

현재 코드는 `VisitReport`와 `VisitSummary`를 1:N으로 구성한다. 포트폴리오 문서에서 1:1 구조로 설명하려면 코드 구조와 맞지 않으므로, 실제 의도에 따라 1:1 또는 1:N 중 하나로 정리해야 한다.

### welfare_policies

복지정책 정보를 관리한다.

| 컬럼 | 설명 |
| --- | --- |
| id | 정책 PK |
| policyName | 정책명 |
| shortDescription | 간단 설명 |
| detailedConditions | 상세 조건 |
| link | 정책 링크 |
| region | 지역 |

### policy_checks

방문 보고서에서 복지정책 해당 여부를 관리한다.

| 컬럼 | 설명 |
| --- | --- |
| id | 정책 체크 PK |
| report_id | 방문 보고서 FK |
| policy_id | 복지정책 FK |
| checkStatus | 해당 여부 |

## API 명세 초안

현재 API는 `/db` prefix를 사용한다.

### Auth

| Method | Endpoint | 설명 | 인증 |
| --- | --- | --- | --- |
| POST | `/db/login` | 로그인 및 JWT 발급 | No |
| POST | `/db/register` | 회원가입 | No |
| POST | `/db/email_check` | 이메일 중복 확인 | No |
| GET | `/db/users` | 내 정보 조회 | Yes |

### Target

| Method | Endpoint | 설명 | 인증 |
| --- | --- | --- | --- |
| POST | `/db/addTarget` | 대상자 등록 | Yes |
| GET | `/db/getAllTargets` | 담당 대상자 목록 조회 | Yes |
| GET | `/db/getTargetInfo/{id}` | 대상자 상세 정보 조회 | Yes |

### Visit / Report

| Method | Endpoint | 설명 | 인증 |
| --- | --- | --- | --- |
| POST | `/db/addVisitReport` | 방문 일정 생성 | Yes |
| GET | `/db/getAllVisitReports` | 방문 보고서 목록 조회 | Yes |
| GET | `/db/getDefaultReportList` | 보고서 작성 대상 목록 조회 | Yes |
| GET | `/db/getTodayList` | 오늘 방문 일정 조회 | Yes |
| POST | `/db/getTodayList` | 오늘 방문 일정 조회, FE 호환용 | Yes |
| POST | `/db/uploadReportDefaultInfo` | 보고서 기본 정보 저장 | Yes |
| POST | `/db/uploadVisitDetail` | 방문 특이사항 저장 | Yes |
| GET | `/db/visitReportDone?reportid={id}` | 방문 완료 처리 | Yes |
| POST | `/db/uploadCallRecord` | 음성 파일 업로드 | Yes |
| GET | `/db/getConverstationSTTtxt/{id}` | STT 텍스트 조회 | Yes |
| GET | `/db/getVisitDetails/{id}` | 방문 상세 및 요약 조회 | Yes |
| POST | `/db/uploadEditAbstract` | 요약 수정 저장 | Yes |
| POST | `/db/uploadImages` | 이미지 업로드 | Yes |

`getConverstationSTTtxt`는 오타가 포함된 endpoint로 보인다. FE 연동을 확인한 뒤, 호환 endpoint를 유지하면서 새 endpoint를 추가하는 방식으로 개선하는 것이 안전하다.

### Welfare / Policy

| Method | Endpoint | 설명 | 인증 |
| --- | --- | --- | --- |
| GET | `/db/welfare-policies/{targetId}` | 대상자 기준 추천 복지정책 조회 | Yes |
| GET | `/db/welfare-policies` | 전체 복지정책 조회 | Yes |
| GET | `/db/policies/{id}` | 복지정책 상세 조회 | Yes |
| POST | `/db/uploadCheckPolicy` | 복지정책 체크 상태 저장 | Yes |

## 리팩토링 후보

| 항목 | 현재 상태 | 왜 필요한가 |
| --- | --- | --- |
| 공통 응답 객체 | `Map`, DTO, 문자열 응답이 섞여 있음 | FE 응답 파싱과 에러 처리를 단순화하기 위해 필요 |
| Global Exception Handler | Controller에서 try-catch 반복 | 중복 제거와 에러 응답 통일을 위해 필요 |
| REST URL 규칙 | `/db/addTarget`, `/db/getAllTargets`처럼 동사형 URL 사용 | 리소스 중심 API로 정리하면 유지보수성이 좋아짐 |
| Entity 직접 반환 | `TargetController#getAllTargets`에서 Entity 반환 | Entity 노출을 줄이고 응답 구조를 안정화하기 위해 필요 |
| 업로드 저장소 | 로컬 `uploads` 사용 | 배포 환경에서 파일 영속성을 확보하려면 Supabase Storage 검토 필요 |
| DB 마이그레이션 | `ddl-auto=update` 사용 | 운영 안정성을 위해 Flyway 같은 migration 도구 검토 필요 |

## 바로 진행할 다음 작업

1. 현재 테스트 전체 실행 후 실패 목록 정리
2. 공통 응답 객체 `ApiResponse<T>` 도입 범위 결정
3. `TargetController#getAllTargets`의 Entity 반환을 Response DTO로 변경
4. Controller try-catch를 Global Exception Handler로 이동
5. API URL 개선은 FE 영향이 크므로 호환 endpoint 유지 전략 수립
