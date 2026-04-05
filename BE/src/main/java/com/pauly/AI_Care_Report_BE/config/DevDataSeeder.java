package com.pauly.AI_Care_Report_BE.config;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.pauly.AI_Care_Report_BE.entity.PolicyCheck;
import com.pauly.AI_Care_Report_BE.entity.Target;
import com.pauly.AI_Care_Report_BE.entity.User;
import com.pauly.AI_Care_Report_BE.entity.VisitReport;
import com.pauly.AI_Care_Report_BE.entity.VisitSummary;
import com.pauly.AI_Care_Report_BE.entity.WelfarePolicy;
import com.pauly.AI_Care_Report_BE.repository.PolicyCheckRepository;
import com.pauly.AI_Care_Report_BE.repository.TargetRepository;
import com.pauly.AI_Care_Report_BE.repository.UserRepository;
import com.pauly.AI_Care_Report_BE.repository.VisitReportRepository;
import com.pauly.AI_Care_Report_BE.repository.VisitSummaryRepository;
import com.pauly.AI_Care_Report_BE.repository.WelfarePolicyRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Random;

@Slf4j
@Component
@RequiredArgsConstructor
public class DevDataSeeder implements ApplicationRunner {

    private final UserRepository userRepository;
    private final TargetRepository targetRepository;
    private final VisitReportRepository visitReportRepository;
    private final VisitSummaryRepository visitSummaryRepository;
    private final WelfarePolicyRepository welfarePolicyRepository;
    private final PolicyCheckRepository policyCheckRepository;
    private final PasswordEncoder passwordEncoder;
    private final ObjectMapper objectMapper;

    @Value("${app.seed.enabled:true}")
    private boolean seedEnabled;

    @Value("${app.seed.user-email:test@test.com}")
    private String seedUserEmail;

    @Value("${app.seed.user-password:test123!}")
    private String seedUserPassword;

    private static final DateTimeFormatter VISIT_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    @Override
    @Transactional
    public void run(ApplicationArguments args) {
        if (!seedEnabled) {
            log.info("[SEED] app.seed.enabled=false, seeding skipped.");
            return;
        }

        User seedUser = ensureSeedUser();
        List<Target> targets = ensureTargets(seedUser);
        List<VisitReport> reports = ensureVisitReports(seedUser, targets);
        List<WelfarePolicy> policies = ensurePolicies();
        ensureSummariesAndPolicyChecks(reports, policies);

        log.info("[SEED] Completed for user={} targets={} reports={} policies={}",
                seedUserEmail, targets.size(), reports.size(), policies.size());
    }

    private User ensureSeedUser() {
        return userRepository.findByEmail(seedUserEmail).orElseGet(() -> {
            User user = User.builder()
                    .email(seedUserEmail)
                    .password(passwordEncoder.encode(seedUserPassword))
                    .name("테스트 매니저")
                    .role("SOCIAL_WORKER")
                    .phoneNumber("010-1111-2222")
                    .birthdate("1990-01-01")
                    .gender(1)
                    .permission(1)
                    .build();
            User saved = userRepository.save(user);
            log.info("[SEED] test user created: {}", seedUserEmail);
            return saved;
        });
    }

    private List<Target> ensureTargets(User user) {
        List<Target> existing = targetRepository.findByUser(user);
        if (!existing.isEmpty()) {
            return existing;
        }

        List<Target> targets = Arrays.asList(
                buildTarget(user, "오하이", "대전 서구 대덕대로 150", "경성큰마을아파트 102동 103호", "010-9001-1001", 0, 78, "대전"),
                buildTarget(user, "김민수", "대전 유성구 대학로 99", "행복주택 110동 902호", "010-9001-1002", 1, 81, "대전"),
                buildTarget(user, "홍길동", "대전 동구 용전동 11-2", "해오름빌라 201호", "010-9001-1003", 1, 75, "대전"),
                buildTarget(user, "이유진", "대전 중구 중앙로 121", "센트럴하임 504호", "010-9001-1004", 0, 83, "대전"),
                buildTarget(user, "박정자", "대전 대덕구 계족산로 35", "한솔아파트 203동 701호", "010-9001-1005", 0, 86, "대전"),
                buildTarget(user, "강병수", "대전 서구 갈마로 42", "가람주택 1동 302호", "010-9001-1006", 1, 79, "대전")
        );

        List<Target> saved = targetRepository.saveAll(targets);
        log.info("[SEED] targets created for user={} count={}", seedUserEmail, saved.size());
        return saved;
    }

    private Target buildTarget(User user, String name, String addr1, String addr2, String phone, int gender, int age, String region) {
        return Target.builder()
                .user(user)
                .targetname(name)
                .address1(addr1)
                .address2(addr2)
                .targetcallnum(phone)
                .gender(gender)
                .age(age)
                .region(region)
                .build();
    }

    private List<VisitReport> ensureVisitReports(User user, List<Target> targets) {
        List<VisitReport> existing = visitReportRepository.findByUser(user);
        if (!existing.isEmpty()) {
            return existing;
        }

        Random random = new Random(20260405L);
        List<Integer> offsets = new ArrayList<>();

        // 과거 40건
        for (int i = 0; i < 40; i++) {
            offsets.add(-1 * (random.nextInt(90) + 1));
        }
        // 오늘 6건
        offsets.addAll(Arrays.asList(0, 0, 0, 0, 0, 0));
        // 미래 10건
        for (int i = 0; i < 10; i++) {
            offsets.add(random.nextInt(20) + 1);
        }

        Collections.shuffle(offsets, random);

        List<VisitReport> reports = new ArrayList<>();
        for (int i = 0; i < offsets.size(); i++) {
            Target target = targets.get(i % targets.size());
            int offset = offsets.get(i);

            LocalDate day = LocalDate.now().plusDays(offset);
            LocalTime time = LocalTime.of(9 + random.nextInt(8), random.nextBoolean() ? 0 : 30);
            LocalDateTime visitAt = LocalDateTime.of(day, time);
            String visitType = random.nextBoolean() ? "전화돌봄" : "현장돌봄";

            int status;
            if (offset > 0) {
                status = 0;
            } else if (offset == 0) {
                status = random.nextBoolean() ? 0 : 1;
            } else {
                status = random.nextInt(100) < 80 ? 2 : 1;
            }

            VisitReport report = VisitReport.builder()
                    .user(user)
                    .target(target)
                    .visittime(visitAt.format(VISIT_TIME_FORMATTER))
                    .visittype(visitType)
                    .reportstatus(status)
                    .endtime(status == 2 ? visitAt.plusHours(1).format(VISIT_TIME_FORMATTER) : null)
                    .detail(status == 2 ? "어르신 상태 점검 및 상담을 완료했습니다." : null)
                    .sttText(status == 2 ? "오늘 컨디션은 양호하며 식사와 수면 상태를 확인했습니다." : null)
                    .build();
            reports.add(report);
        }

        List<VisitReport> saved = visitReportRepository.saveAll(reports);
        log.info("[SEED] visit reports created for user={} count={}", seedUserEmail, saved.size());
        return saved;
    }

    private List<WelfarePolicy> ensurePolicies() {
        List<WelfarePolicy> existing = welfarePolicyRepository.findAll();
        if (!existing.isEmpty()) {
            return existing;
        }

        List<WelfarePolicy> policies = Arrays.asList(
                buildPolicy("노인 무릎 인공관절 수술 지원사업", "무릎 관절 통증으로 거동이 어려운 어르신의 수술비를 지원합니다.",
                        Arrays.asList("만 60세 이상", "중위소득 80% 이하", "의사 소견서 필요"), "https://www.mohw.go.kr", "대전"),
                buildPolicy("독거노인 식사 지원", "조리와 식사 준비가 어려운 어르신께 도시락을 제공합니다.",
                        Arrays.asList("독거노인", "기초생활수급 또는 차상위", "주 3회 제공"), "https://www.bokjiro.go.kr", "대전"),
                buildPolicy("에너지 바우처", "냉난방비 부담 완화를 위해 바우처를 지원합니다.",
                        Arrays.asList("기초생활수급자", "노인 포함 가구", "계절별 차등 지원"), "https://www.energyv.or.kr", "대전"),
                buildPolicy("보행 보조기구 지원", "보행이 불편한 어르신에게 보조기구 구입비를 지원합니다.",
                        Arrays.asList("의료급여 또는 차상위", "보행장애 진단서", "연 1회"), "https://www.gov.kr", "대전")
        );

        List<WelfarePolicy> saved = welfarePolicyRepository.saveAll(policies);
        log.info("[SEED] welfare policies created count={}", saved.size());
        return saved;
    }

    private WelfarePolicy buildPolicy(String name, String shortDesc, List<String> conditions, String link, String region) {
        String conditionsJson;
        try {
            conditionsJson = objectMapper.writeValueAsString(conditions);
        } catch (JsonProcessingException e) {
            conditionsJson = "[]";
        }

        return WelfarePolicy.builder()
                .policyName(name)
                .shortDescription(shortDesc)
                .detailedConditions(conditionsJson)
                .link(link)
                .region(region)
                .build();
    }

    private void ensureSummariesAndPolicyChecks(List<VisitReport> reports, List<WelfarePolicy> policies) {
        int summaryCreated = 0;
        int policyCheckCreated = 0;

        for (VisitReport report : reports) {
            if (report.getReportstatus() != null && report.getReportstatus() == 2) {
                if (visitSummaryRepository.findByReport(report).isEmpty()) {
                    List<VisitSummary> summaries = Arrays.asList(
                            buildSummary(report, "신체 상태", "무릎 통증 호소가 있으나 일상 대화는 원활함", "실내 이동 시 통증이 있으나 안정 시 통증 감소"),
                            buildSummary(report, "생활 환경", "외출 빈도가 줄어 실내 활동 위주", "식사 준비와 정리 활동이 다소 부담되는 상태"),
                            buildSummary(report, "정서 상태", "외로움 표현이 간헐적으로 확인됨", "전화 통화 및 이웃 교류를 권장함")
                    );
                    visitSummaryRepository.saveAll(summaries);
                    summaryCreated += summaries.size();
                }

                if (!policies.isEmpty() && policyCheckRepository.findByReport(report).isEmpty()) {
                    List<PolicyCheck> checks = new ArrayList<>();
                    for (int i = 0; i < Math.min(2, policies.size()); i++) {
                        checks.add(PolicyCheck.builder()
                                .report(report)
                                .policy(policies.get(i))
                                .checkStatus(1)
                                .build());
                    }
                    policyCheckRepository.saveAll(checks);
                    policyCheckCreated += checks.size();
                }
            }
        }

        log.info("[SEED] summaries created={} policyChecks created={}", summaryCreated, policyCheckCreated);
    }

    private VisitSummary buildSummary(VisitReport report, String subject, String summary, String detail) {
        return VisitSummary.builder()
                .report(report)
                .subject(subject)
                .summaryText(summary)
                .detail(detail)
                .build();
    }
}
