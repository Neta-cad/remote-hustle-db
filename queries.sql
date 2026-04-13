-- ============================================
-- REMOTE HUSTLE - QUERIES AND VIEWS
-- ============================================

-- Query 1: All participant profiles
SELECT 
    u.full_name,
    u.email,
    p.phone_number,
    p.country,
    p.skill_track,
    p.current_stage,
    p.status,
    p.registered_at
FROM participants p
JOIN users u ON p.user_id = u.user_id
ORDER BY p.registered_at DESC;

-- Query 2: Participants per country
SELECT 
    country,
    COUNT(*) AS total_participants
FROM participants
GROUP BY country
ORDER BY total_participants DESC;

-- Query 3: All submissions and status
SELECT 
    u.full_name AS participant_name,
    t.task_title,
    s.submission_url,
    s.status,
    s.submitted_at
FROM submissions s
JOIN participants p ON s.participant_id = p.participant_id
JOIN users u ON p.user_id = u.user_id
JOIN tasks t ON s.task_id = t.task_id
ORDER BY s.submitted_at DESC;

-- Query 4: Pending submissions
SELECT 
    u.full_name AS participant_name,
    u.email,
    t.task_title,
    s.submission_url,
    s.submitted_at
FROM submissions s
JOIN participants p ON s.participant_id = p.participant_id
JOIN users u ON p.user_id = u.user_id
JOIN tasks t ON s.task_id = t.task_id
WHERE s.status = 'pending'
ORDER BY s.submitted_at ASC;

-- Query 5: Judge scores and feedback
SELECT 
    u.full_name AS judge_name,
    participant.full_name AS participant_name,
    e.score,
    e.max_score,
    ROUND((e.score::DECIMAL / e.max_score) * 100, 2) AS percentage,
    e.feedback,
    e.evaluated_at
FROM evaluations e
JOIN users u ON e.judge_id = u.user_id
JOIN submissions s ON e.submission_id = s.submission_id
JOIN participants p ON s.participant_id = p.participant_id
JOIN users participant ON p.user_id = participant.user_id
ORDER BY e.evaluated_at DESC;

-- Query 6: Stage progress per participant
SELECT 
    u.full_name AS participant_name,
    p.skill_track,
    p.country,
    st.stage_name,
    a.total_submissions,
    a.average_score,
    a.highest_score,
    a.pass_status
FROM analytics a
JOIN participants p ON a.participant_id = p.participant_id
JOIN users u ON p.user_id = u.user_id
JOIN stages st ON a.stage_id = st.stage_id
ORDER BY a.average_score DESC;

-- Query 7: Top 10 performers
SELECT 
    u.full_name AS participant_name,
    p.skill_track,
    p.country,
    a.total_submissions,
    a.average_score,
    a.highest_score,
    a.pass_status
FROM analytics a
JOIN participants p ON a.participant_id = p.participant_id
JOIN users u ON p.user_id = u.user_id
WHERE a.pass_status = 'passed'
ORDER BY a.average_score DESC
LIMIT 10;

-- Query 8: Full competition summary
SELECT 
    COUNT(DISTINCT p.participant_id) AS total_participants,
    COUNT(DISTINCT s.submission_id) AS total_submissions,
    COUNT(DISTINCT e.evaluation_id) AS total_evaluations,
    ROUND(AVG(e.score), 2) AS overall_average_score,
    COUNT(DISTINCT CASE WHEN a.pass_status = 'passed' THEN p.participant_id END) AS total_passed,
    COUNT(DISTINCT CASE WHEN a.pass_status = 'failed' THEN p.participant_id END) AS total_failed,
    COUNT(DISTINCT CASE WHEN a.pass_status = 'pending' THEN p.participant_id END) AS total_pending
FROM participants p
LEFT JOIN submissions s ON p.participant_id = s.participant_id
LEFT JOIN evaluations e ON s.submission_id = e.submission_id
LEFT JOIN analytics a ON p.participant_id = a.participant_id;

-- Query 9: Recent audit logs
SELECT 
    u.full_name AS performed_by,
    u.role,
    al.action,
    al.table_name,
    al.ip_address,
    al.created_at
FROM audit_logs al
JOIN users u ON al.user_id = u.user_id
ORDER BY al.created_at DESC
LIMIT 50;

-- Query 10: Participants with no submission
SELECT 
    u.full_name AS participant_name,
    u.email,
    p.country,
    p.skill_track,
    p.registered_at
FROM participants p
JOIN users u ON p.user_id = u.user_id
LEFT JOIN submissions s ON p.participant_id = s.participant_id
WHERE s.submission_id IS NULL
ORDER BY p.registered_at ASC;

-- BONUS VIEW: Competition overview
CREATE VIEW competition_overview AS
SELECT 
    u.full_name AS participant_name,
    p.country,
    p.skill_track,
    st.stage_name AS current_stage,
    a.total_submissions,
    a.average_score,
    a.pass_status
FROM participants p
JOIN users u ON p.user_id = u.user_id
JOIN stages st ON p.current_stage = st.stage_number
LEFT JOIN analytics a ON p.participant_id = a.participant_id
ORDER BY a.average_score DESC;
