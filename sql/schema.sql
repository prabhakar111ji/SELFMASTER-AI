-- ==========================================
-- SELFMASTER AI - Complete Database Schema
-- ==========================================

CREATE DATABASE IF NOT EXISTS selfmaster_db;
USE selfmaster_db;

-- ---- Users & Authentication ----
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100),
    username VARCHAR(50) NOT NULL UNIQUE,
    avatar_url VARCHAR(500),
    bio TEXT,
    date_of_birth DATE,
    gender VARCHAR(20),
    timezone VARCHAR(50) DEFAULT 'UTC',
    email_verified BOOLEAN DEFAULT FALSE,
    verification_token VARCHAR(255),
    reset_token VARCHAR(255),
    reset_token_expiry DATETIME,
    enabled BOOLEAN DEFAULT TRUE,
    xp_points INT DEFAULT 0,
    level INT DEFAULT 1,
    current_streak INT DEFAULT 0,
    longest_streak INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_users_email (email),
    INDEX idx_users_username (username)
);

CREATE TABLE IF NOT EXISTS roles (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS user_roles (
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
);

-- ---- Goals ----
CREATE TABLE IF NOT EXISTS goals (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    goal_type ENUM('SHORT_TERM', 'LONG_TERM', 'DAILY') DEFAULT 'SHORT_TERM',
    priority ENUM('LOW', 'MEDIUM', 'HIGH', 'CRITICAL') DEFAULT 'MEDIUM',
    status ENUM('NOT_STARTED', 'IN_PROGRESS', 'COMPLETED', 'ABANDONED') DEFAULT 'NOT_STARTED',
    progress_percent INT DEFAULT 0,
    target_date DATE,
    completed_at TIMESTAMP NULL,
    ai_breakdown TEXT,
    is_smart BOOLEAN DEFAULT FALSE,
    specific_text TEXT,
    measurable_text TEXT,
    achievable_text TEXT,
    relevant_text TEXT,
    time_bound_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_goals_user (user_id),
    INDEX idx_goals_status (status)
);

CREATE TABLE IF NOT EXISTS milestones (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    goal_id BIGINT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    target_date DATE,
    completed BOOLEAN DEFAULT FALSE,
    completed_at TIMESTAMP NULL,
    order_index INT DEFAULT 0,
    FOREIGN KEY (goal_id) REFERENCES goals(id) ON DELETE CASCADE
);

-- ---- Habits ----
CREATE TABLE IF NOT EXISTS habits (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    frequency ENUM('DAILY', 'WEEKLY', 'CUSTOM') DEFAULT 'DAILY',
    habit_type ENUM('BUILD', 'BREAK') DEFAULT 'BUILD',
    trigger_cue TEXT,
    reward TEXT,
    current_streak INT DEFAULT 0,
    longest_streak INT DEFAULT 0,
    total_completions INT DEFAULT 0,
    total_misses INT DEFAULT 0,
    habit_score DOUBLE DEFAULT 0.0,
    is_active BOOLEAN DEFAULT TRUE,
    start_date DATE,
    color VARCHAR(7) DEFAULT '#6C5CE7',
    icon VARCHAR(50) DEFAULT 'fa-check',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_habits_user (user_id)
);

CREATE TABLE IF NOT EXISTS habit_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    habit_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    log_date DATE NOT NULL,
    completed BOOLEAN DEFAULT FALSE,
    notes TEXT,
    difficulty_rating INT DEFAULT 3,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (habit_id) REFERENCES habits(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY uk_habit_log_date (habit_id, log_date),
    INDEX idx_habit_logs_date (log_date)
);

-- ---- Focus Sessions ----
CREATE TABLE IF NOT EXISTS focus_sessions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    title VARCHAR(255),
    session_type ENUM('DEEP_WORK', 'POMODORO', 'FLOW', 'DOPAMINE_DETOX') DEFAULT 'DEEP_WORK',
    planned_duration_minutes INT NOT NULL,
    actual_duration_minutes INT DEFAULT 0,
    distractions_count INT DEFAULT 0,
    focus_score DOUBLE DEFAULT 0.0,
    notes TEXT,
    started_at TIMESTAMP NOT NULL,
    ended_at TIMESTAMP NULL,
    status ENUM('ACTIVE', 'COMPLETED', 'ABANDONED') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_focus_user (user_id),
    INDEX idx_focus_date (started_at)
);

-- ---- Emotional Logs ----
CREATE TABLE IF NOT EXISTS emotional_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    mood_score INT NOT NULL CHECK (mood_score BETWEEN 1 AND 10),
    energy_level INT DEFAULT 5 CHECK (energy_level BETWEEN 1 AND 10),
    stress_level INT DEFAULT 5 CHECK (stress_level BETWEEN 1 AND 10),
    anxiety_level INT DEFAULT 5 CHECK (anxiety_level BETWEEN 1 AND 10),
    primary_emotion VARCHAR(50),
    triggers TEXT,
    coping_strategy TEXT,
    notes TEXT,
    log_date DATE NOT NULL,
    log_time TIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_emotional_user_date (user_id, log_date)
);

-- ---- Accountability (Morning Plan / Night Review) ----
CREATE TABLE IF NOT EXISTS accountability_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    log_date DATE NOT NULL,
    log_type ENUM('MORNING_PLAN', 'NIGHT_REVIEW') NOT NULL,
    top_priorities TEXT,
    gratitude TEXT,
    intention TEXT,
    reflection TEXT,
    wins TEXT,
    lessons TEXT,
    tomorrow_plan TEXT,
    productivity_rating INT CHECK (productivity_rating BETWEEN 1 AND 10),
    discipline_rating INT CHECK (discipline_rating BETWEEN 1 AND 10),
    overall_rating INT CHECK (overall_rating BETWEEN 1 AND 10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY uk_accountability (user_id, log_date, log_type),
    INDEX idx_accountability_date (user_id, log_date)
);

-- ---- Journal Entries ----
CREATE TABLE IF NOT EXISTS journal_entries (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    title VARCHAR(255),
    content TEXT NOT NULL,
    mood VARCHAR(50),
    tags VARCHAR(500),
    is_private BOOLEAN DEFAULT TRUE,
    entry_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_journal_user_date (user_id, entry_date)
);

-- ---- AI Conversations ----
CREATE TABLE IF NOT EXISTS ai_conversations (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    session_id VARCHAR(100) NOT NULL,
    role ENUM('USER', 'ASSISTANT', 'SYSTEM') NOT NULL,
    message TEXT NOT NULL,
    conversation_type ENUM('LIFE_COACH', 'DECISION_SUPPORT', 'BEHAVIORAL_ANALYSIS', 'GENERAL') DEFAULT 'LIFE_COACH',
    tokens_used INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_ai_conv_session (session_id),
    INDEX idx_ai_conv_user (user_id)
);

-- ---- Discipline & Self-Analysis Scores ----
CREATE TABLE IF NOT EXISTS discipline_scores (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    score_date DATE NOT NULL,
    discipline_score DOUBLE DEFAULT 0.0,
    self_control_score DOUBLE DEFAULT 0.0,
    focus_score DOUBLE DEFAULT 0.0,
    consistency_score DOUBLE DEFAULT 0.0,
    emotional_balance_score DOUBLE DEFAULT 0.0,
    productivity_score DOUBLE DEFAULT 0.0,
    mental_resilience_score DOUBLE DEFAULT 0.0,
    overall_mastery_score DOUBLE DEFAULT 0.0,
    ai_insights TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY uk_discipline_date (user_id, score_date),
    INDEX idx_discipline_user (user_id)
);

CREATE TABLE IF NOT EXISTS self_analysis (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    analysis_type VARCHAR(100),
    analysis_data JSON,
    ai_recommendations TEXT,
    procrastination_level INT DEFAULT 5,
    comfort_zone_score INT DEFAULT 5,
    dopamine_dependency_score INT DEFAULT 5,
    social_media_addiction_score INT DEFAULT 5,
    laziness_score INT DEFAULT 5,
    action_taking_score INT DEFAULT 5,
    decision_quality_score INT DEFAULT 5,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_self_analysis_user (user_id)
);

-- ---- Productivity Logs ----
CREATE TABLE IF NOT EXISTS productivity_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    log_date DATE NOT NULL,
    tasks_planned INT DEFAULT 0,
    tasks_completed INT DEFAULT 0,
    deep_work_minutes INT DEFAULT 0,
    distractions_count INT DEFAULT 0,
    productivity_score DOUBLE DEFAULT 0.0,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY uk_productivity_date (user_id, log_date)
);

-- ---- Routines ----
CREATE TABLE IF NOT EXISTS routines (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    routine_type ENUM('MORNING', 'EVENING', 'CUSTOM') DEFAULT 'MORNING',
    items JSON,
    is_active BOOLEAN DEFAULT TRUE,
    ai_generated BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ---- Challenges ----
CREATE TABLE IF NOT EXISTS challenges (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    challenge_type VARCHAR(100),
    difficulty ENUM('EASY', 'MEDIUM', 'HARD', 'EXTREME') DEFAULT 'MEDIUM',
    duration_days INT DEFAULT 7,
    status ENUM('ACTIVE', 'COMPLETED', 'FAILED', 'PENDING') DEFAULT 'PENDING',
    progress_percent INT DEFAULT 0,
    xp_reward INT DEFAULT 100,
    start_date DATE,
    end_date DATE,
    ai_generated BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_challenges_user (user_id)
);

-- ---- Achievements / Badges ----
CREATE TABLE IF NOT EXISTS achievements (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    icon VARCHAR(100),
    category VARCHAR(100),
    xp_reward INT DEFAULT 50,
    criteria JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS user_achievements (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    achievement_id BIGINT NOT NULL,
    earned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (achievement_id) REFERENCES achievements(id) ON DELETE CASCADE,
    UNIQUE KEY uk_user_achievement (user_id, achievement_id)
);

-- ---- Notifications ----
CREATE TABLE IF NOT EXISTS notifications (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    notification_type ENUM('REMINDER', 'ALERT', 'MOTIVATION', 'ACHIEVEMENT', 'SYSTEM') DEFAULT 'SYSTEM',
    is_read BOOLEAN DEFAULT FALSE,
    action_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_notifications_user (user_id, is_read)
);

-- ---- Reports ----
CREATE TABLE IF NOT EXISTS reports (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    report_type ENUM('WEEKLY', 'MONTHLY', 'DISCIPLINE', 'FOCUS', 'BEHAVIORAL', 'EMOTIONAL') NOT NULL,
    title VARCHAR(255),
    report_data JSON,
    period_start DATE,
    period_end DATE,
    file_path VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_reports_user (user_id)
);

-- ---- Seed Data: Roles ----
INSERT IGNORE INTO roles (name) VALUES ('ROLE_USER'), ('ROLE_ADMIN');

-- ---- Seed Data: Achievements ----
INSERT IGNORE INTO achievements (name, description, icon, category, xp_reward) VALUES
('First Step', 'Completed your first habit', 'fa-shoe-prints', 'HABIT', 50),
('Week Warrior', '7-day habit streak', 'fa-fire', 'STREAK', 100),
('Month Master', '30-day habit streak', 'fa-crown', 'STREAK', 500),
('Deep Thinker', 'Completed 10 deep work sessions', 'fa-brain', 'FOCUS', 200),
('Emotion Explorer', 'Logged emotions for 7 days straight', 'fa-heart', 'EMOTIONAL', 100),
('Goal Getter', 'Completed your first goal', 'fa-bullseye', 'GOAL', 150),
('Journal Keeper', 'Wrote 10 journal entries', 'fa-book', 'JOURNAL', 100),
('Discipline Disciple', 'Achieved discipline score above 80', 'fa-shield', 'DISCIPLINE', 300),
('Self-Master', 'Achieved overall mastery score above 90', 'fa-gem', 'MASTERY', 1000),
('Challenge Champion', 'Completed 5 challenges', 'fa-trophy', 'CHALLENGE', 250);
