-- ============================================
-- REMOTE HUSTLE - ROW LEVEL SECURITY
-- ============================================

-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE evaluations ENABLE ROW LEVEL SECURITY;
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE stages ENABLE ROW LEVEL SECURITY;
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE analytics ENABLE ROW LEVEL SECURITY;
ALTER TABLE roles_permissions ENABLE ROW LEVEL SECURITY;

-- Admin full access policy
CREATE POLICY admin_all_access ON users
    FOR ALL
    TO PUBLIC
    USING (
        EXISTS (
            SELECT 1 FROM users
            WHERE user_id = current_setting('app.current_user_id')::UUID
            AND role = 'admin'
        )
    );

-- Participant own submissions policy
CREATE POLICY participant_own_submissions ON submissions
    FOR ALL
    TO PUBLIC
    USING (
        participant_id = (
            SELECT participant_id FROM participants
            WHERE user_id = current_setting('app.current_user_id')::UUID
        )
    );

-- Judge own evaluations policy
CREATE POLICY judge_own_evaluations ON evaluations
    FOR ALL
    TO PUBLIC
    USING (
        judge_id = current_setting('app.current_user_id')::UUID
    );

-- Stages readable by everyone
CREATE POLICY stages_read_all ON stages
    FOR SELECT
    TO PUBLIC
    USING (true);

-- Tasks readable by everyone
CREATE POLICY tasks_read_all ON tasks
    FOR SELECT
    TO PUBLIC
    USING (true);

-- Audit logs admin only
CREATE POLICY audit_logs_admin_only ON audit_logs
    FOR SELECT
    TO PUBLIC
    USING (
        EXISTS (
            SELECT 1 FROM users
            WHERE user_id = current_setting('app.current_user_id')::UUID
            AND role = 'admin'
        )
    );
