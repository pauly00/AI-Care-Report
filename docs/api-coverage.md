# API 명세 반영 현황

사용자가 제공한 `/db` API 명세를 현재 Spring Boot 백엔드 기준으로 대조한 문서다.

## 요약

| 구분 | 개수 | 설명 |
| --- | ---: | --- |
| 실제 구현 API | 30 | 기존 엔티티와 서비스 로직으로 실제 처리 |
| 호환 추가 API | 14 | 명세 URL은 추가했지만 별도 엔티티가 없어 호환 응답 |
| 의미 충돌 API | 1 | `/db/welfare-policies/{id}` 경로 의미 충돌 |
| 기타 호환 API | 2 | FE 호출 호환 또는 업로드 호환용 |

현재 백엔드 매핑은 총 47개다.

## 실제 구현 API

| Method | Endpoint | 상태 |
| --- | --- | --- |
| POST | `/db/login` | 구현 |
| POST | `/db/register` | 구현 |
| POST | `/db/email_check` | 구현 |
| GET | `/db/users` | 구현 |
| PUT | `/db/users/{userId}` | 구현 |
| DELETE | `/db/users/{userId}` | 구현 |
| POST | `/db/addTarget` | 구현 |
| GET | `/db/getAllTargets` | 구현 |
| GET | `/db/getTargetInfo/{id}` | 구현 |
| POST | `/db/addVisitReport` | 구현 |
| GET | `/db/getAllVisitReports` | 구현 |
| GET | `/db/getDefaultReportList` | 구현 |
| GET | `/db/getResultReportList` | 구현 |
| GET | `/db/visitReportDone` | 구현 |
| POST | `/db/setUserToReport` | 구현 |
| POST | `/db/uploadCallRecord` | 구현 |
| GET | `/db/getConverstationSTTtxt/{id}` | 구현 |
| PATCH | `/db/update_stt_path` | 구현 |
| GET | `/db/get_transcript_path` | 구현 |
| POST | `/db/update_visit_category` | 구현 |
| POST | `/db/uploadImages` | 구현 |
| POST | `/db/uploadCheckPolicy` | 구현 |
| POST | `/db/uploadEditAbstract` | 구현 |
| POST | `/db/uploadReportDefaultInfo` | 구현 |
| POST | `/db/uploadVisitDetail` | 구현 |
| GET | `/db/policies/{id}` | 구현 |
| POST | `/db/policies` | 구현 |
| PUT | `/db/policies/{policyId}` | 구현 |
| DELETE | `/db/policies/{policyId}` | 구현 |
| GET | `/db/welfare-policies` | 구현 |

## 호환 추가 API

아래 API는 URL 매핑을 추가했다. 다만 현재 백엔드에 `Client`, `YangChunStt`, `WelfareData`, `ConversationSummary` 같은 엔티티가 없어서 완전한 DB 기능은 아직 아니다.

| Method | Endpoint | 상태 |
| --- | --- | --- |
| GET | `/db/getYangChunConverstationSTTtxt/{reportid}` | 호환 응답 |
| GET | `/db/yangchun_getResultList` | 호환 응답 |
| GET | `/db/yangchun_stt_abstract/{id}` | 호환 응답 |
| GET | `/db/clients/{clientId}` | 호환 응답 |
| POST | `/db/clients` | 호환 응답 |
| PUT | `/db/clients/{clientId}` | 호환 응답 |
| DELETE | `/db/clients/{clientId}` | 호환 응답 |
| PUT | `/db/welfare-policies/{userId}` | 호환 응답 |
| GET | `/db/welfare-datas/{userId}` | 호환 응답 |
| PUT | `/db/welfare-datas/{userId}` | 호환 응답 |
| POST | `/db/yangchun_stt_upload` | 호환 응답 |
| POST | `/db/yangchun_stt_upload_policy` | 호환 응답 |
| POST | `/db/yangchun_idcard_info_upload` | 호환 응답 |
| GET | `/db/conversation-summary/{summaryId}` | 호환 응답 |

## 의미 충돌 API

| Method | Endpoint | 명세 의미 | 현재 백엔드 의미 | 처리 |
| --- | --- | --- | --- | --- |
| GET | `/db/welfare-policies/{id}` | 특정 복지정책 조회 | 대상자별 추천 복지정책 조회 | 기존 FE 호환을 위해 유지 |

정책 상세 조회는 현재 `/db/policies/{id}`가 담당한다. 같은 HTTP Method와 같은 path 구조를 두 개 만들 수 없어서 `/db/welfare-policies/{id}`의 의미는 기존 코드 기준으로 유지했다.

## 기타 호환 API

| Method | Endpoint | 상태 |
| --- | --- | --- |
| POST | `/db/getTodayList` | FE 호출 호환 |
| POST | `/db/uploadImages/compat` | 업로드 호환 |

## 책임 분리 구조

참고한 `hangang-pay-be`는 `domain/{기능}/controller`, `service`, `dto`, `entity`, `repository` 형태로 책임을 나눈다.

현재 프로젝트는 기존 코드 영향이 커서 전체 파일 이동은 하지 않았다. 대신 새로 추가한 명세 호환 기능은 아래처럼 기능별 폴더를 추가했다.

```text
compat/
  controller/
    ApiCompatibilityController.java
  service/
    ApiCompatibilityService.java
```

이후 리팩토링 단계에서는 기존 `controller`, `service`, `dto`, `entity`, `repository` 평면 구조를 다음처럼 나누는 것이 좋다.

```text
domain/
  auth/
  target/
  visit/
  welfare/
  user/
  yangchun/
global/
  config/
  security/
  response/
  exception/
```

전체 패키지 이동은 import 변경과 테스트 수정 범위가 크므로, 기능 안정화 이후 별도 리팩토링 작업으로 진행하는 것이 안전하다.
