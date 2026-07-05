-- Render 배포 확인용 일일 시연 데이터
-- Supabase PostgreSQL에서 직접 실행 가능한 보정 쿼리

WITH seed_user AS (
    SELECT id
    FROM users
    WHERE email = 'test@test.com'
    LIMIT 1
),
seed_targets AS (
    SELECT id, row_number() OVER (ORDER BY id) AS rn
    FROM targets
    WHERE user_id = (SELECT id FROM seed_user)
    ORDER BY id
    LIMIT 3
),
today_existing AS (
    SELECT count(*) AS cnt
    FROM visit_reports
    WHERE user_id = (SELECT id FROM seed_user)
      AND visittime LIKE to_char(current_date, 'YYYY-MM-DD') || '%'
      AND coalesce(reportstatus, 0) < 2
),
insert_source AS (
    SELECT
        id AS target_id,
        rn
    FROM seed_targets
    WHERE rn <= greatest(0, 3 - (SELECT cnt FROM today_existing))
)
INSERT INTO visit_reports (
    target_id,
    user_id,
    visittime,
    reportstatus,
    visittype,
    created_at
)
SELECT
    target_id,
    (SELECT id FROM seed_user),
    to_char(current_date, 'YYYY-MM-DD') || ' ' ||
        lpad((9 + rn)::text, 2, '0') || ':00',
    0,
    CASE WHEN rn % 2 = 0 THEN '전화돌봄' ELSE '현장돌봄' END,
    now()
FROM insert_source;

UPDATE visit_reports
SET visittime = to_char(current_date + ((row_number_value - 3) || ' days')::interval, 'YYYY-MM-DD') || ' 10:00',
    reportstatus = 0
FROM (
    SELECT
        id,
        row_number() OVER (ORDER BY id) AS row_number_value
    FROM visit_reports
    WHERE user_id = (SELECT id FROM seed_user)
      AND visittime LIKE to_char(current_date, 'YYYY-MM-DD') || '%'
      AND coalesce(reportstatus, 0) < 2
) ranked_reports
WHERE visit_reports.id = ranked_reports.id
  AND ranked_reports.row_number_value > 3;
