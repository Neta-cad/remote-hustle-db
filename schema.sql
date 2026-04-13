--user table 
CREATE TABLE users (
        user_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
		full_name VARCHAR(100) NOT NULL,
		email VARCHAR(150) NOT NULL UNIQUE,
		password_hash TEXT NOT NULL,
		role VARCHAR(20) NOT NULL CHECK (role IN ('admin', 'judge', 'participant', 'support')),
		is_active BOOLEAN DEFAULT true,
		created_at TIMESTAMP DEFAULT now(),
		updated_at TIMESTAMP DEFAULT now()
);


--PARTICIPANTS TABLE

CREATE TABLE participants (
     participant_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
	 user_id UUID NOT NULL REFERENCES users(user_id),
	 phone_number VARCHAR(20) NOT NULL,
	 country VARCHAR(100) NOT NULL,
	 skill_track VARCHAR(100) NOT NULL,
	 current_stage INTEGER DEFAULT 1,
	 status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'disqualified', 'completed')),
	 registered_at TIMESTAMP DEFAULT now()
);


--stages table 
CREATE TABLE stages (
stage_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
stage_number INTEGER NOT NULL UNIQUE,
stage_name VARCHAR(100) NOT NULL,
description TEXT,
duration_days INTEGER NOT NULL,
is_active BOOLEAN DEFAULT false,
created_at TIMESTAMP DEFAULT now() 
);


--task table
CREATE TABLE tasks (
   task_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
   stage_id UUID NOT NULL REFERENCES stages(stage_id),
   task_title VARCHAR(150) NOT NULL,
   task_description TEXT NOT NULL,
   max_score INTEGER NOT NULL,
   deadline TIMESTAMP NOT NULL,
   created_at TIMESTAMP DEFAULT now()
);



--submissions table
CREATE TABLE submissions (
   submission_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
   participant_id UUID NOT NULL REFERENCES participants(participant_id),
   task_id UUID NOT NULL REFERENCES tasks(task_id),
   submission_url TEXT NOT NULL,
   notes TEXT,
   status VARCHAR(20) DEFAULT 'pending' CHECK(status IN ('pending', 'reviewed', 'accepted', 'rejected')),
   submitted_at TIMESTAMP DEFAULT now(),
   updated_at TIMESTAMP DEFAULT now()
);



--evaluations table
CREATE TABLE evaluations (
   evaluation_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
   submission_id UUID NOT NULL REFERENCES submissions(submission_id),
   judge_id UUID NOT NULL REFERENCES users(user_id),
   score INTEGER NOT NULL,
   max_score INTEGER NOT NULL,
   feedback TEXT,
   status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'completed')),
   evaluated_at TIMESTAMP DEFAULT now(),
   CONSTRAINT check_score CHECK (score >= 0 AND score <= max_score)
);



--report table
CREATE TABLE reports (
   report_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
   generated_by UUID NOT NULL REFERENCES users(user_id),
   report_type VARCHAR(20) NOT NULL CHECK (report_type IN ('stage', 'participant', 'overall')),
   stage_id UUID REFERENCES stages(stage_id),
   title VARCHAR(200) NOT NULL,
   content JSONB NOT NULL,
   generated_at TIMESTAMP DEFAULT now()
);





-- audit_logs Table
CREATE TABLE audit_logs (
    log_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(user_id),
    action VARCHAR(100) NOT NULL,
    table_name VARCHAR(100) NOT NULL,
    record_id UUID NOT NULL,
    old_data JSONB,
    new_data JSONB,
    ip_address VARCHAR(50),
    created_at TIMESTAMP DEFAULT now()
);




-- roles_permissions Table
CREATE TABLE roles_permissions (
    permission_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    role VARCHAR(20) NOT NULL CHECK (role IN ('admin', 'judge', 'participant', 'support')),
    table_name VARCHAR(100) NOT NULL,
    can_read BOOLEAN DEFAULT false,
    can_insert BOOLEAN DEFAULT false,
    can_update BOOLEAN DEFAULT false,
    can_delete BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT now(),
    CONSTRAINT unique_role_table UNIQUE (role, table_name)
);




-- analytics table
CREATE TABLE analytics (
    analytics_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    participant_id UUID NOT NULL REFERENCES participants(participant_id),
    stage_id UUID NOT NULL REFERENCES stages(stage_id),
    total_submissions INTEGER DEFAULT 0,
    total_score INTEGER DEFAULT 0,
    average_score DECIMAL(5,2) DEFAULT 0.00,
    highest_score INTEGER DEFAULT 0,
    lowest_score INTEGER DEFAULT 0,
    pass_status VARCHAR(20) DEFAULT 'pending' CHECK (pass_status IN ('pending', 'passed', 'failed')),
    last_activity TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now(),
    CONSTRAINT unique_participant_stage UNIQUE (participant_id, stage_id)
);
