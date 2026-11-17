CREATE TABLE "public"."announcements" (
  "notification_id" uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
  "job_id"          uuid,
  "title"           text NOT NULL,
  "message"         text NOT NULL,
  CONSTRAINT "announcements_pkey" PRIMARY KEY (notification_id)
);

ALTER TABLE "public"."announcements"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."applications" (
  "application_id" uuid                     NOT NULL DEFAULT extensions.uuid_generate_v4(),
  "job_id"         uuid,
  "student_id"     uuid,
  "applied_at"     timestamp with time zone DEFAULT now(),
  CONSTRAINT "applications_job_id_student_id_key" UNIQUE (job_id, student_id),
  CONSTRAINT "applications_pkey" PRIMARY KEY (application_id)
);

ALTER TABLE "public"."applications"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."audit_logs" (
  "log_id"            uuid                     NOT NULL DEFAULT extensions.uuid_generate_v4(),
  "action_by_user_id" uuid,
  "action_type"       text                     NOT NULL,
  "target_entity_id"  uuid,
  "timestamp"         timestamp with time zone DEFAULT now(),
  CONSTRAINT "audit_logs_pkey" PRIMARY KEY (log_id)
);

ALTER TABLE "public"."audit_logs"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."companies" (
  "company_id"    uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
  "company_name"  text NOT NULL,
  "industry_type" text,
  "company_size"  text,
  "headquarters"  text,
  "website"       text,
  "about_us"      text,
  "logo_url"      text,
  CONSTRAINT "companies_pkey" PRIMARY KEY (company_id)
);

ALTER TABLE "public"."companies"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."interview_schedules" (
  "schedule_id"           uuid                     NOT NULL DEFAULT extensions.uuid_generate_v4(),
  "job_id"                uuid,
  "round_name"            text                     NOT NULL,
  "round_type"            text,
  "start_time"            timestamp with time zone NOT NULL,
  "end_time"              timestamp with time zone NOT NULL,
  "venue_or_meeting_link" text,
  "interviewer_name"      text,
  CONSTRAINT "interview_schedules_pkey" PRIMARY KEY (schedule_id)
);

ALTER TABLE "public"."interview_schedules"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."job_offers" (
  "offer_id"         uuid          NOT NULL DEFAULT extensions.uuid_generate_v4(),
  "application_id"   uuid,
  "student_id"       uuid,
  "offered_ctc"      numeric(10,2) NOT NULL,
  "offer_letter_url" text,
  "offer_date"       date          DEFAULT CURRENT_DATE,
  CONSTRAINT "job_offers_pkey" PRIMARY KEY (offer_id)
);

ALTER TABLE "public"."job_offers"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."jobs" (
  "job_id"       uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
  "recruiter_id" uuid,
  "role_title"   text NOT NULL,
  CONSTRAINT "jobs_pkey" PRIMARY KEY (job_id)
);

ALTER TABLE "public"."jobs"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."penalties" (
  "penalty_id"            uuid                     NOT NULL DEFAULT extensions.uuid_generate_v4(),
  "student_id"            uuid,
  "reason"                text                     NOT NULL,
  "companies_blocked_for" integer                  DEFAULT 3,
  "issued_at"             timestamp with time zone DEFAULT now(),
  CONSTRAINT "penalties_pkey" PRIMARY KEY (penalty_id)
);

ALTER TABLE "public"."penalties"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."recruiters" (
  "recruiter_id"   uuid    NOT NULL,
  "company_id"     uuid,
  "name"           text    NOT NULL,
  "contact_number" text,
  "is_verified"    boolean DEFAULT false,
  CONSTRAINT "recruiters_pkey" PRIMARY KEY (recruiter_id)
);

ALTER TABLE "public"."recruiters"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."student_education" (
  "education_id" uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
  "student_id"   uuid,
  CONSTRAINT "student_education_pkey" PRIMARY KEY (education_id)
);

ALTER TABLE "public"."student_education"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."student_experience" (
  "exp_id"     uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
  "student_id" uuid,
  CONSTRAINT "student_experience_pkey" PRIMARY KEY (exp_id)
);

ALTER TABLE "public"."student_experience"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."student_skills" (
  "skill_id"   uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
  "student_id" uuid,
  "skill_name" text NOT NULL,
  CONSTRAINT "student_skills_pkey" PRIMARY KEY (skill_id)
);

ALTER TABLE "public"."student_skills"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."students" (
  "student_id"  uuid NOT NULL,
  "full_name"   text NOT NULL,
  "roll_number" text NOT NULL,
  CONSTRAINT "students_pkey" PRIMARY KEY (student_id),
  CONSTRAINT "students_roll_number_key" UNIQUE (roll_number)
);

ALTER TABLE "public"."students"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."users" (
  "id"    uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
  "email" text NOT NULL,
  CONSTRAINT "users_email_key" UNIQUE (email),
  CONSTRAINT "users_pkey" PRIMARY KEY (id)
);

ALTER TABLE "public"."users"
  ENABLE ROW LEVEL SECURITY;

CREATE TYPE "public"."approval_state" AS ENUM (
  'PENDING',
  'APPROVED',
  'REJECTED'
);

CREATE TYPE "public"."edu_level" AS ENUM (
  '10TH',
  '12TH',
  'DIPLOMA',
  'UG_DEGREE',
  'PG_DEGREE'
);

ALTER TABLE "public"."student_education"
  ADD COLUMN "level" public.edu_level NOT NULL;

ALTER TABLE "public"."student_education"
  ADD COLUMN "institution_name" text;

ALTER TABLE "public"."student_education"
  ADD COLUMN "board_or_university" text;

ALTER TABLE "public"."student_education"
  ADD COLUMN "passing_year" integer;

CREATE TYPE "public"."exp_type" AS ENUM (
  'INTERNSHIP',
  'PROJECT',
  'WORK_EXP'
);

ALTER TABLE "public"."student_experience"
  ADD COLUMN "type" public.exp_type NOT NULL;

ALTER TABLE "public"."student_experience"
  ADD COLUMN "title" text NOT NULL;

ALTER TABLE "public"."student_experience"
  ADD COLUMN "organization_name" text;

ALTER TABLE "public"."student_experience"
  ADD COLUMN "start_date" date;

ALTER TABLE "public"."student_experience"
  ADD COLUMN "end_date" date;

ALTER TABLE "public"."student_experience"
  ADD COLUMN "description" text;

ALTER TABLE "public"."student_experience"
  ADD COLUMN "tech_stack_used" text[];

ALTER TABLE "public"."student_experience"
  ADD COLUMN "link" text;

CREATE TYPE "public"."gender_type" AS ENUM (
  'MALE',
  'FEMALE',
  'OTHER'
);

ALTER TABLE "public"."students"
  ADD COLUMN "gender" public.gender_type;

ALTER TABLE "public"."students"
  ADD COLUMN "dob" date;

ALTER TABLE "public"."students"
  ADD COLUMN "personal_email" text;

ALTER TABLE "public"."students"
  ADD COLUMN "college_email" text;

ALTER TABLE "public"."students"
  ADD COLUMN "phone_number" text;

ALTER TABLE "public"."students"
  ADD COLUMN "current_address" text;

ALTER TABLE "public"."students"
  ADD COLUMN "permanent_address" text;

ALTER TABLE "public"."students"
  ADD COLUMN "portfolio_link" text;

ALTER TABLE "public"."students"
  ADD COLUMN "resume_link" text;

CREATE TYPE "public"."hiring_stage" AS ENUM (
  'APPLIED',
  'SHORTLISTED',
  'ABSENT',
  'REJECTED',
  'HIRED'
);

ALTER TABLE "public"."applications"
  ADD COLUMN "hiring_stage" public.hiring_stage DEFAULT 'APPLIED'::public.hiring_stage;

ALTER TABLE "public"."applications"
  ADD COLUMN "current_round" text;

ALTER TABLE "public"."applications"
  ADD COLUMN "test_score" numeric(5,2);

ALTER TABLE "public"."applications"
  ADD COLUMN "recruiter_remarks" text;

CREATE TYPE "public"."job_type" AS ENUM (
  'FULL_TIME',
  'INTERNSHIP',
  'PPO'
);

ALTER TABLE "public"."jobs"
  ADD COLUMN "job_type" public.job_type;

ALTER TABLE "public"."jobs"
  ADD COLUMN "job_location" text;

ALTER TABLE "public"."jobs"
  ADD COLUMN "ctc_details" text;

ALTER TABLE "public"."jobs"
  ADD COLUMN "ctc_value_lpa" numeric(10,2);

ALTER TABLE "public"."jobs"
  ADD COLUMN "stipend_details" text;

ALTER TABLE "public"."jobs"
  ADD COLUMN "service_agreement_months" integer;

ALTER TABLE "public"."jobs"
  ADD COLUMN "bond_amount" text;

ALTER TABLE "public"."jobs"
  ADD COLUMN "job_description" text;

ALTER TABLE "public"."jobs"
  ADD COLUMN "required_skills" text[];

ALTER TABLE "public"."jobs"
  ADD COLUMN "min_10th_score" numeric(5,2);

ALTER TABLE "public"."jobs"
  ADD COLUMN "min_12th_or_diploma_score" numeric(5,2);

ALTER TABLE "public"."jobs"
  ADD COLUMN "min_degree_cgpa" numeric(4,2);

ALTER TABLE "public"."jobs"
  ADD COLUMN "max_active_backlogs_allowed" integer DEFAULT 0;

ALTER TABLE "public"."jobs"
  ADD COLUMN "max_dead_backlogs_allowed" integer;

ALTER TABLE "public"."jobs"
  ADD COLUMN "max_gap_years_allowed" integer DEFAULT 1;

ALTER TABLE "public"."jobs"
  ADD COLUMN "allowed_genders" public.gender_type[];

ALTER TABLE "public"."jobs"
  ADD COLUMN "allowed_branches" text[];

ALTER TABLE "public"."jobs"
  ADD COLUMN "process_rounds" text[];

ALTER TABLE "public"."jobs"
  ADD COLUMN "vacancies" integer;

ALTER TABLE "public"."jobs"
  ADD COLUMN "deadline" timestamp WITH time zone;

ALTER TABLE "public"."jobs"
  ADD COLUMN "approval_status" public.approval_state DEFAULT 'PENDING'::public.approval_state;

CREATE TYPE "public"."offer_status" AS ENUM (
  'ACCEPTED',
  'REJECTED_BY_STUDENT',
  'EXPIRED'
);

ALTER TABLE "public"."job_offers"
  ADD COLUMN "acceptance_status" public.offer_status;

ALTER TABLE "public"."job_offers"
  ADD COLUMN "is_verified_by_spc" boolean DEFAULT false;

CREATE TYPE "public"."placement_status" AS ENUM (
  'ELIGIBLE',
  'DEBARRED',
  'PLACED'
);

ALTER TABLE "public"."students"
  ADD COLUMN "placement_status" public.placement_status DEFAULT 'ELIGIBLE'::public.placement_status;

ALTER TABLE "public"."students"
  ADD COLUMN "gap_years" integer DEFAULT 0;

ALTER TABLE "public"."students"
  ADD COLUMN "multiple_offers_allowed" boolean DEFAULT false;

ALTER TABLE "public"."students"
  ADD COLUMN "is_verified_by_spc" boolean DEFAULT false;

ALTER TABLE "public"."students"
  ADD COLUMN "category" text;

CREATE TYPE "public"."proficiency_level" AS ENUM (
  'BEGINNER',
  'INTERMEDIATE',
  'ADVANCED'
);

ALTER TABLE "public"."student_skills"
  ADD COLUMN "proficiency" public.proficiency_level;

CREATE TYPE "public"."score_type" AS ENUM (
  'CGPA',
  'PERCENTAGE'
);

ALTER TABLE "public"."student_education"
  ADD COLUMN "score_type" public.score_type;

ALTER TABLE "public"."student_education"
  ADD COLUMN "score" numeric(5,2);

ALTER TABLE "public"."student_education"
  ADD COLUMN "specialization_or_branch" text;

ALTER TABLE "public"."student_education"
  ADD COLUMN "marksheet_url" text;

CREATE TYPE "public"."target_audience" AS ENUM (
  'ALL_STUDENTS',
  'ELIGIBLE_STUDENTS',
  'SHORTLISTED_STUDENTS'
);

ALTER TABLE "public"."announcements"
  ADD COLUMN "target_audience" public.target_audience DEFAULT 'ALL_STUDENTS'::public.target_audience;

ALTER TABLE "public"."announcements"
  ADD COLUMN "created_at" timestamp WITH time zone DEFAULT now();

CREATE TYPE "public"."user_role" AS ENUM (
  'STUDENT',
  'RECRUITER',
  'ADMIN'
);

ALTER TABLE "public"."users"
  ADD COLUMN "role" public.user_role NOT NULL;

ALTER TABLE "public"."users"
  ADD COLUMN "created_at" timestamp WITH time zone DEFAULT now();

ALTER TABLE "public"."job_offers"
  ADD CONSTRAINT "job_offers_application_id_fkey" FOREIGN KEY (application_id) REFERENCES public.applications(application_id) ON DELETE CASCADE;

ALTER TABLE "public"."announcements"
  ADD CONSTRAINT "announcements_job_id_fkey" FOREIGN KEY (job_id) REFERENCES public.jobs(job_id) ON DELETE SET NULL;

ALTER TABLE "public"."applications"
  ADD CONSTRAINT "applications_job_id_fkey" FOREIGN KEY (job_id) REFERENCES public.jobs(job_id) ON DELETE CASCADE;

ALTER TABLE "public"."interview_schedules"
  ADD CONSTRAINT "interview_schedules_job_id_fkey" FOREIGN KEY (job_id) REFERENCES public.jobs(job_id) ON DELETE CASCADE;

ALTER TABLE "public"."recruiters"
  ADD CONSTRAINT "recruiters_company_id_fkey" FOREIGN KEY (company_id) REFERENCES public.companies(company_id) ON DELETE CASCADE;

ALTER TABLE "public"."jobs"
  ADD CONSTRAINT "jobs_recruiter_id_fkey" FOREIGN KEY (recruiter_id) REFERENCES public.recruiters(recruiter_id) ON DELETE CASCADE;

ALTER TABLE "public"."students"
  ADD CONSTRAINT "students_college_email_key" UNIQUE (college_email);

ALTER TABLE "public"."applications"
  ADD CONSTRAINT "applications_student_id_fkey" FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;

ALTER TABLE "public"."job_offers"
  ADD CONSTRAINT "job_offers_student_id_fkey" FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;

ALTER TABLE "public"."penalties"
  ADD CONSTRAINT "penalties_student_id_fkey" FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;

ALTER TABLE "public"."student_education"
  ADD CONSTRAINT "student_education_student_id_fkey" FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;

ALTER TABLE "public"."student_experience"
  ADD CONSTRAINT "student_experience_student_id_fkey" FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;

ALTER TABLE "public"."student_skills"
  ADD CONSTRAINT "student_skills_student_id_fkey" FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;

ALTER TABLE "public"."audit_logs"
  ADD CONSTRAINT "audit_logs_action_by_user_id_fkey" FOREIGN KEY (action_by_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

ALTER TABLE "public"."recruiters"
  ADD CONSTRAINT "recruiters_recruiter_id_fkey" FOREIGN KEY (recruiter_id) REFERENCES public.users(id) ON DELETE CASCADE;

ALTER TABLE "public"."students"
  ADD CONSTRAINT "students_student_id_fkey" FOREIGN KEY (student_id) REFERENCES public.users(id) ON DELETE CASCADE;

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."announcements" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."announcements" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."announcements" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."announcements" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."applications" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."applications" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."applications" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."applications" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."audit_logs" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."audit_logs" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."audit_logs" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."audit_logs" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."companies" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."companies" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."companies" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."companies" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."interview_schedules" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."interview_schedules" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."interview_schedules" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."interview_schedules" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."job_offers" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."job_offers" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."job_offers" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."job_offers" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."jobs" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."jobs" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."jobs" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."jobs" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."penalties" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."penalties" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."penalties" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."penalties" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."recruiters" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."recruiters" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."recruiters" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."recruiters" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."student_education" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."student_education" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."student_education" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."student_education" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."student_experience" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."student_experience" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."student_experience" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."student_experience" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."student_skills" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."student_skills" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."student_skills" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."student_skills" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."students" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."students" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."students" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."students" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."users" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."users" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."users" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."users" TO "service_role";

