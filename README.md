# remote-hustle-db
Remote Hustle Master Operational Database
# RemoteHustleDB — Master Operational Database

## Project Overview
A fully functional PostgreSQL database built to manage 
participants, submissions, evaluations, reports and 
analytics for the Remote Hustle competition.

## Problem Solved
Remote Hustle was managing everything manually causing:
- Manual tracking errors
- Scoring delays
- Messy and scattered submissions

## Tech Stack
- Database: PostgreSQL 15
- Hosting: Supabase
- Security: Row Level Security (RLS)
- Version Control: GitHub

## How To Connect
- Host: db.crnoxgxroxmcnxqzvlou.supabase.co
- Database: postgres
- Port: 5432
- User: postgres
- Password: [provided separately]

## Tables
1. users
2. participants
3. stages
4. tasks
5. submissions
6. evaluations
7. reports
8. audit_logs
9. roles_permissions
10. analytics

## Files In This Repository
- schema.sql — Creates all 10 tables
- seed.sql — Inserts all sample data
- queries.sql — 10 ready to run queries + 1 view
- security.sql — Row Level Security policies
- README.md — This file

## How To Run Queries
1. Connect using credentials above
2. Open queries.sql
3. Run any query directly

## Sample Queries
-- See all participants
SELECT * FROM competition_overview;

-- See top 10 performers
SELECT * FROM analytics 
ORDER BY average_score DESC LIMIT 10;

-- See pending submissions
SELECT * FROM submissions WHERE status = 'pending';

## Target Users
- Admins: manage everything
- Judges: score submissions
- Participants: submit tasks
- Support: assist participants

## How Remote Hustle Can Use It Today
1. Connect using provided credentials
2. Participants register and data saves automatically
3. Judges log in and score submissions instantly
4. Admins generate reports with one query
5. All actions tracked in audit logs automatically
