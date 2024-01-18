/* TAKEAWAYS */
    -- GOALS
        -- normalize, in sense that we are eliminating redundancy within and between tables
        -- in case data is ever entered manually by BP staff or contractors, let's reduce likelihood of typos and other user error
        -- use officeholders table instead of new justices table?
    -- conventions BP uses
        -- use bigint primary keys in each table
        -- foreign keys reference the bigint primary keys
        -- for dates, use text type instead of date type
        -- snake_case (if you use camelCase, you will always need to select within "quotes" - ick)
        -- table names plural
        -- every table has id column, which is sequence
        -- often use columns called "name" and "description"
        -- we store dates as text (allows for partial dates where needed; also just a legacy decision)
        -- foreign key column type should equal the type of the column it references (e.g. both are integer, both bigint, etc)
        -- BP has used a lot of enums in the past, but i would like to use key tables instead to avoid some enum downsides
            -- entertaining article on the drawbacks of enums: https://web.archive.org/web/20180324095351/http://komlenic.com/244/8-reasons-why-mysqls-enum-data-type-is-evil/
    -- sequences are long-form of serial data type in postgres - can use either, but BP has used sequences
    -- double precision generally used only for decimals/percentages where absolute accuracy isn't important (floating point math gets weird)

/*** QUESTIONS ***/
    -- Are all cases included in the dataset already decided? 
    -- Are cases only argued for one day? Or is it a span of days?
    -- Do cases ever span more than one term?
    -- Does each case have one outcome? --> if yes, can include outcome in case table

/*** KIRSTEN TODO ***/
    -- created/updated columns for key tables
    -- triggers for audit and updated columns for all tables
    -- indexes for any columns as needed (not primary keys or unique - those are automatically made)

/*** KEY TABLES: 13 ***/
    /* DELETE: 2 */
        -- CASEID
            -- don't need a table with only one column, which won't be getting any more columns
            -- can just be a column in another table (i.e. cases)
        -- JUSTICENAMEKEY
            -- should use officeholder IDs instead --> opens up entire world of BP data
    /* CASE_ORIGINS */
        -- new
            -- sequence
            CREATE SEQUENCE scotus_case_origins_id_seq START 1 INCREMENT 1;
            ALTER SEQUENCE scotus_case_origins_id_seq OWNER TO rds_superuser;
            GRANT USAGE ON SEQUENCE scotus_case_origins_id_seq TO api_writer;

            -- table
            CREATE TABLE IF NOT EXISTS scotus_case_origins
            (
                id bigint PRIMARY KEY DEFAULT nextval('scotus_case_origins_id_seq'::regclass),
                name text NOT NULL UNIQUE
            )

            ALTER TABLE IF EXISTS scotus_case_origins OWNER to rds_superuser;

            GRANT SELECT ON TABLE scotus_case_origins TO api_reader;
            GRANT INSERT, UPDATE, SELECT, DELETE ON TABLE scotus_case_origins TO api_writer;
            GRANT ALL ON TABLE scotus_case_origins TO api_admin;


        -- original
            CREATE TABLE IF NOT EXISTS public."TEMP_caseOriginKey"
            (
                "caseOrigin" integer,
                "caseOriginVal" character varying COLLATE pg_catalog."default"
            )

            TABLESPACE pg_default;

            ALTER TABLE IF EXISTS public."TEMP_caseOriginKey"
                OWNER to api_user;

            REVOKE ALL ON TABLE public."TEMP_caseOriginKey" FROM api_reader;
            REVOKE ALL ON TABLE public."TEMP_caseOriginKey" FROM api_writer;

            GRANT SELECT ON TABLE public."TEMP_caseOriginKey" TO api_reader;

            GRANT ALL ON TABLE public."TEMP_caseOriginKey" TO api_user;

            GRANT INSERT, UPDATE, SELECT, DELETE ON TABLE public."TEMP_caseOriginKey" TO api_writer;

    /* ISSUES */
        -- new
            -- sequence
            CREATE SEQUENCE scotus_issues_id_seq START 1 INCREMENT 1;
            ALTER SEQUENCE scotus_issues_id_seq OWNER TO rds_superuser;
            GRANT USAGE ON SEQUENCE scotus_issues_id_seq TO api_writer;

            -- table
            CREATE TABLE IF NOT EXISTS scotus_issues
            (
                id bigint PRIMARY KEY DEFAULT nextval('scotus_issues_id_seq'::regclass),
                name text NOT NULL UNIQUE
            );

            ALTER TABLE IF EXISTS scotus_issues OWNER to rds_superuser;
            GRANT SELECT ON TABLE scotus_issues TO api_reader;
            GRANT INSERT, UPDATE, SELECT, DELETE ON TABLE scotus_issues TO api_writer;
            GRANT ALL ON TABLE scotus_issues TO api_admin;

        -- original
            CREATE TABLE IF NOT EXISTS public."TEMP_issueKey"
            (
                issue integer,
                "issueVal" character varying COLLATE pg_catalog."default"
            )

            TABLESPACE pg_default;

            ALTER TABLE IF EXISTS public."TEMP_issueKey"
                OWNER to api_user;

            REVOKE ALL ON TABLE public."TEMP_issueKey" FROM api_reader;
            REVOKE ALL ON TABLE public."TEMP_issueKey" FROM api_writer;

            GRANT SELECT ON TABLE public."TEMP_issueKey" TO api_reader;

            GRANT ALL ON TABLE public."TEMP_issueKey" TO api_user;

            GRANT INSERT, UPDATE, SELECT, DELETE ON TABLE public."TEMP_issueKey" TO api_writer;

    /* MAJOR_OPINION_WRITERS */
        -- new
            -- sequence
            CREATE SEQUENCE scotus_major_opinion_writers_id_seq START 1 INCREMENT 1;
            ALTER SEQUENCE scotus_major_opinion_writers_id_seq OWNER TO rds_superuser;
            GRANT USAGE ON SEQUENCE scotus_major_opinion_writers_id_seq TO api_writer;

            -- table
            CREATE TABLE IF NOT EXISTS scotus_major_opinion_writers
            (
                id bigint PRIMARY KEY DEFAULT nextval('scotus_major_opinion_writers_id_seq'::regclass),
                name text not null unique,
                description text
            );

            ALTER TABLE IF EXISTS scotus_major_opinion_writers OWNER to rds_superuser;
            GRANT SELECT ON TABLE scotus_major_opinion_writers TO api_reader;
            GRANT INSERT, UPDATE, SELECT, DELETE ON TABLE scotus_major_opinion_writers TO api_writer;
            GRANT ALL ON TABLE scotus_major_opinion_writers TO api_admin;

        -- original
            CREATE TABLE IF NOT EXISTS public."TEMP_justiceNameKey"
            (
                "justiceName" character varying COLLATE pg_catalog."default",
                "justiceFirstName" character varying COLLATE pg_catalog."default",
                "justiceLastName" character varying COLLATE pg_catalog."default"
            )

            TABLESPACE pg_default;

            ALTER TABLE IF EXISTS public."TEMP_justiceNameKey"
                OWNER to api_user;

            REVOKE ALL ON TABLE public."TEMP_justiceNameKey" FROM api_reader;
            REVOKE ALL ON TABLE public."TEMP_justiceNameKey" FROM api_writer;

            GRANT SELECT ON TABLE public."TEMP_justiceNameKey" TO api_reader;

            GRANT ALL ON TABLE public."TEMP_justiceNameKey" TO api_user;

            GRANT INSERT, UPDATE, SELECT, DELETE ON TABLE public."TEMP_justiceNameKey" TO api_writer;

    /* PETITIONERS */
        -- new
            -- sequence
            CREATE SEQUENCE scotus_petitioners_id_seq START 1 INCREMENT 1;
            ALTER SEQUENCE scotus_petitioners_id_seq OWNER TO rds_superuser;
            GRANT USAGE ON SEQUENCE scotus_petitioners_id_seq TO api_writer;

            -- table
            CREATE TABLE IF NOT EXISTS scotus_petitioners
            (
                id bigint PRIMARY KEY DEFAULT nextval('scotus_petitioners_id_seq'::regclass),
                name text not null unique
            );

            ALTER TABLE IF EXISTS scotus_petitioners OWNER to rds_superuser;
            GRANT SELECT ON TABLE scotus_petitioners TO api_reader;
            GRANT INSERT, UPDATE, SELECT, DELETE ON TABLE scotus_petitioners TO api_writer;
            GRANT ALL ON TABLE scotus_petitioners TO api_admin;

        -- original
            CREATE TABLE IF NOT EXISTS public."TEMP_justiceNameKey"
            (
                "justiceName" character varying COLLATE pg_catalog."default",
                "justiceFirstName" character varying COLLATE pg_catalog."default",
                "justiceLastName" character varying COLLATE pg_catalog."default"
            )

            TABLESPACE pg_default;

            ALTER TABLE IF EXISTS public."TEMP_justiceNameKey"
                OWNER to api_user;

            REVOKE ALL ON TABLE public."TEMP_justiceNameKey" FROM api_reader;
            REVOKE ALL ON TABLE public."TEMP_justiceNameKey" FROM api_writer;

            GRANT SELECT ON TABLE public."TEMP_justiceNameKey" TO api_reader;

            GRANT ALL ON TABLE public."TEMP_justiceNameKey" TO api_user;

            GRANT INSERT, UPDATE, SELECT, DELETE ON TABLE public."TEMP_justiceNameKey" TO api_writer;

    /* RESPONDENTS */
        -- new
            -- sequence
            CREATE SEQUENCE scotus_respondents_id_seq START 1 INCREMENT 1;
            ALTER SEQUENCE scotus_respondents_id_seq OWNER TO rds_superuser;
            GRANT USAGE ON SEQUENCE scotus_respondents_id_seq TO api_writer;

            -- table
            CREATE TABLE IF NOT EXISTS scotus_respondents
            (
                id bigint PRIMARY KEY DEFAULT nextval('scotus_respondents_id_seq'::regclass),
                name text not null unique
            );

            ALTER TABLE IF EXISTS scotus_respondents OWNER to rds_superuser;
            GRANT SELECT ON TABLE scotus_respondents TO api_reader;
            GRANT INSERT, UPDATE, SELECT, DELETE ON TABLE scotus_respondents TO api_writer;
            GRANT ALL ON TABLE scotus_respondents TO api_admin;

        -- original
            CREATE TABLE IF NOT EXISTS public."TEMP_respondentKey"
            (
                respondent integer,
                "respondentVal" character varying COLLATE pg_catalog."default"
            )

            TABLESPACE pg_default;

            ALTER TABLE IF EXISTS public."TEMP_respondentKey"
                OWNER to api_user;

            REVOKE ALL ON TABLE public."TEMP_respondentKey" FROM api_reader;
            REVOKE ALL ON TABLE public."TEMP_respondentKey" FROM api_writer;

            GRANT SELECT ON TABLE public."TEMP_respondentKey" TO api_reader;

            GRANT ALL ON TABLE public."TEMP_respondentKey" TO api_user;

            GRANT INSERT, UPDATE, SELECT, DELETE ON TABLE public."TEMP_respondentKey" TO api_writer;

    /* NEW KEY TABLES: 8 */
        /* ISSUE_AREAS */
            -- sequence
            CREATE SEQUENCE scotus_issue_areas_id_seq START 1 INCREMENT 1;
            ALTER SEQUENCE scotus_issue_areas_id_seq OWNER TO rds_superuser;
            GRANT USAGE ON SEQUENCE scotus_issue_areas_id_seq TO api_writer;

            -- table
            CREATE TABLE IF NOT EXISTS scotus_issue_areas
            (
                id bigint PRIMARY KEY DEFAULT nextval('scotus_issue_areas_id_seq'::regclass),
                name text not null unique
            );

            ALTER TABLE IF EXISTS scotus_issue_areas OWNER to rds_superuser;
            GRANT SELECT ON TABLE scotus_issue_areas TO api_reader;
            GRANT INSERT, UPDATE, SELECT, DELETE ON TABLE scotus_issue_areas TO api_writer;
            GRANT ALL ON TABLE scotus_issue_areas TO api_admin;

        /* JURISDICTIONS */
            -- sequence
            CREATE SEQUENCE scotus_jurisdictions_id_seq START 1 INCREMENT 1;
            ALTER SEQUENCE scotus_jurisdictions_id_seq OWNER TO rds_superuser;
            GRANT USAGE ON SEQUENCE scotus_jurisdictions_id_seq TO api_writer;

            -- table
            CREATE TABLE IF NOT EXISTS scotus_jurisdictions
            (
                id bigint PRIMARY KEY DEFAULT nextval('scotus_jurisdictions_id_seq'::regclass),
                name text not null unique
            );

            ALTER TABLE IF EXISTS scotus_jurisdictions OWNER to rds_superuser;
            GRANT SELECT ON TABLE scotus_jurisdictions TO api_reader;
            GRANT INSERT, UPDATE, SELECT, DELETE ON TABLE scotus_jurisdictions TO api_writer;
            GRANT ALL ON TABLE scotus_jurisdictions TO api_admin;

        /* DISPOSITIONS */
            -- sequence
            CREATE SEQUENCE scotus_dispositions_id_seq START 1 INCREMENT 1;
            ALTER SEQUENCE scotus_dispositions_id_seq OWNER TO rds_superuser;
            GRANT USAGE ON SEQUENCE scotus_dispositions_id_seq TO api_writer;

            -- table
            CREATE TABLE IF NOT EXISTS scotus_dispositions
            (
                id bigint PRIMARY KEY DEFAULT nextval('scotus_dispositions_id_seq'::regclass),
                name text not null unique
            );

            ALTER TABLE IF EXISTS scotus_dispositions OWNER to rds_superuser;
            GRANT SELECT ON TABLE scotus_dispositions TO api_reader;
            GRANT INSERT, UPDATE, SELECT, DELETE ON TABLE scotus_dispositions TO api_writer;
            GRANT ALL ON TABLE scotus_dispositions TO api_admin;

        /* VOTE_CHOICES */
            -- sequence
            CREATE SEQUENCE scotus_vote_choices_id_seq START 1 INCREMENT 1;
            ALTER SEQUENCE scotus_vote_choices_id_seq OWNER TO rds_superuser;
            GRANT USAGE ON SEQUENCE scotus_vote_choices_id_seq TO api_writer;

            -- table
            CREATE TABLE IF NOT EXISTS scotus_vote_choices
            (
                id bigint PRIMARY KEY DEFAULT nextval('scotus_vote_choices_id_seq'::regclass),
                name text not null unique
            );

            ALTER TABLE IF EXISTS scotus_vote_choices OWNER to rds_superuser;
            GRANT SELECT ON TABLE scotus_vote_choices TO api_reader;
            GRANT INSERT, UPDATE, SELECT, DELETE ON TABLE scotus_vote_choices TO api_writer;
            GRANT ALL ON TABLE scotus_vote_choices TO api_admin;

        /* DECISION_DIRECTIONS */
             -- sequence
            CREATE SEQUENCE scotus_decision_direction_id_seq START 1 INCREMENT 1;
            ALTER SEQUENCE scotus_decision_direction_id_seq OWNER TO rds_superuser;
            GRANT USAGE ON SEQUENCE scotus_decision_direction_id_seq TO api_writer;

            -- table
            CREATE TABLE IF NOT EXISTS scotus_decision_directions
            (
                id bigint PRIMARY KEY DEFAULT nextval('scotus_decision_direction_id_seq'::regclass),
                name text not null unique
            );

            ALTER TABLE IF EXISTS scotus_decision_directions OWNER to rds_superuser;
            GRANT SELECT ON TABLE scotus_decision_directions TO api_reader;
            GRANT INSERT, UPDATE, SELECT, DELETE ON TABLE scotus_decision_directions TO api_writer;
            GRANT ALL ON TABLE scotus_decision_directions TO api_admin;

        /* DECISION_TYPES */
             -- sequence
            CREATE SEQUENCE scotus_decision_types_id_seq START 1 INCREMENT 1;
            ALTER SEQUENCE scotus_decision_types_id_seq OWNER TO rds_superuser;
            GRANT USAGE ON SEQUENCE scotus_decision_types_id_seq TO api_writer;

            -- table
            CREATE TABLE IF NOT EXISTS scotus_decision_types
            (
                id bigint PRIMARY KEY DEFAULT nextval('scotus_decision_types_id_seq'::regclass),
                name text not null unique
            );

            ALTER TABLE IF EXISTS scotus_decision_types OWNER to rds_superuser;
            GRANT SELECT ON TABLE scotus_decision_types TO api_reader;
            GRANT INSERT, UPDATE, SELECT, DELETE ON TABLE scotus_decision_types TO api_writer;
            GRANT ALL ON TABLE scotus_decision_types TO api_admin;

        /* MAJORITIES? */
            -- TODO: is this just 1 for Republican, 2 for Democrat? if so, don't need
            -- sequence
            CREATE SEQUENCE scotus_majorities_id_seq START 1 INCREMENT 1;
            ALTER SEQUENCE scotus_majorities_id_seq OWNER TO rds_superuser;
            GRANT USAGE ON SEQUENCE scotus_majorities_id_seq TO api_writer;

            -- table
            CREATE TABLE IF NOT EXISTS scotus_majorities
            (
                id bigint PRIMARY KEY DEFAULT nextval('scotus_majorities_id_seq'::regclass),
                name text not null unique
            );

            ALTER TABLE IF EXISTS scotus_majorities OWNER to rds_superuser;
            GRANT SELECT ON TABLE scotus_majorities TO api_reader;
            GRANT INSERT, UPDATE, SELECT, DELETE ON TABLE scotus_majorities TO api_writer;
            GRANT ALL ON TABLE scotus_majorities TO api_admin;

        /* OPINIONS */
            --TODO: can we simplify these?
                -- None, 
            -- sequence
            CREATE SEQUENCE scotus_opinions_id_seq START 1 INCREMENT 1;
            ALTER SEQUENCE scotus_opinions_id_seq OWNER TO rds_superuser;
            GRANT USAGE ON SEQUENCE scotus_opinions_id_seq TO api_writer;

            -- table
            CREATE TABLE IF NOT EXISTS scotus_opinions
            (
                id bigint PRIMARY KEY DEFAULT nextval('scotus_opinions_id_seq'::regclass),
                name text not null unique
            );

            ALTER TABLE IF EXISTS scotus_opinions OWNER to rds_superuser;
            GRANT SELECT ON TABLE scotus_opinions TO api_reader;
            GRANT INSERT, UPDATE, SELECT, DELETE ON TABLE scotus_opinions TO api_writer;
            GRANT ALL ON TABLE scotus_opinions TO api_admin;

/*** DATA TABLES: 3 ***/
    /* CASES */
        -- new
            -- sequence
            CREATE SEQUENCE scotus_cases_id_seq START 1 INCREMENT 1;
            ALTER SEQUENCE scotus_cases_id_seq OWNER TO rds_superuser;
            GRANT USAGE ON SEQUENCE scotus_cases_id_seq TO api_writer;

            -- table
            -- TODO: which of these should be not null?
            -- TODO: why many duplicate rows? 
            CREATE TABLE IF NOT EXISTS scotus_cases
            (
                id bigint PRIMARY KEY DEFAULT nextval('scotus_cases_id_seq'::regclass),
                external_id text not null unique,   -- our IDs are always integers --> don't want to use a text ID
                citation text,
                name text,
                issue bigint references scotus_issues(id),
                issue_area bigint references scotus_issue_areas(id),
                origin bigint references scotus_case_origins(id),
                disposition bigint references scotus_dispositions(id),
                argument_date text,
                decision_date text,
                petitioner bigint references scotus_petitioners(id),
                respondent bigint references scotus_respondendents(id),
                jurisdiction bigint references scotus_jurisdictions(id),
                -- moved these here from TEMP_supreme_court_outcomes
                decision_type bigint references scotus_decision_types(id),
                decision_direction bigint references scotus_decision_directions(id),
                majority_opinion_writer bigint references officeholders(id),
                majority_votes integer,
                minority_votes integer,
                -- every table has these
                created timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
                updated timestamp without time zone,
                CONSTRAINT scotus_cases_argument_date_check CHECK (valid_yyyy_mm_dd(argument_date) OR argument_date IS NULL),
                CONSTRAINT scotus_cases_decision_date_check CHECK (valid_yyyy_mm_dd(decision_date) OR decision_date IS NULL)
            );

            ALTER TABLE IF EXISTS scotus_cases OWNER to rds_superuser;
            GRANT SELECT ON TABLE scotus_cases TO api_reader;
            GRANT INSERT, UPDATE, SELECT, DELETE ON TABLE scotus_cases TO api_writer;
            GRANT ALL ON TABLE scotus_cases TO api_admin;

        -- original
            CREATE TABLE IF NOT EXISTS public."TEMP_supreme_court_cases"
            (
                "caseID" character varying COLLATE pg_catalog."default" NOT NULL,
                "usCite" character varying COLLATE pg_catalog."default",
                "caseName" character varying COLLATE pg_catalog."default",
                "caseOrigin" double precision,
                "caseDisposition" character varying COLLATE pg_catalog."default",
                "dateArgument" date,
                "dateDecision" date,
                petitioner double precision,
                respondent double precision,
                jurisdiction character varying COLLATE pg_catalog."default"
            )

            TABLESPACE pg_default;

            ALTER TABLE IF EXISTS public."TEMP_supreme_court_cases"
                OWNER to api_user;

            REVOKE ALL ON TABLE public."TEMP_supreme_court_cases" FROM api_reader;
            REVOKE ALL ON TABLE public."TEMP_supreme_court_cases" FROM api_writer;

            GRANT SELECT ON TABLE public."TEMP_supreme_court_cases" TO api_reader;

            GRANT ALL ON TABLE public."TEMP_supreme_court_cases" TO api_user;

            GRANT INSERT, UPDATE, SELECT, DELETE ON TABLE public."TEMP_supreme_court_cases" TO api_writer;

    /* JUSTICES */
        -- TODO: table name TBD
        -- new
            -- sequence
            CREATE SEQUENCE scotus_case_votes_id_seq START 1 INCREMENT 1;
            ALTER SEQUENCE scotus_case_votes_id_seq OWNER TO rds_superuser;
            GRANT USAGE ON SEQUENCE scotus_case_votes_id_seq TO api_writer;

            -- table
            -- TODO: which of these should be not null?
            CREATE TABLE IF NOT EXISTS scotus_case_votes
            (
                id bigint PRIMARY KEY DEFAULT nextval('scotus_case_votes_id_seq'::regclass),
                scotus_case bigint REFERENCES scotus_cases(id) NOT NULL,    -- naming this scotus_case instead of case, because case is keyword
                term bigint references scotus_terms(id) NOT NULL,
                decision_date text not null,
                officeholder bigint REFERENCES officeholders(id) NOT NULL,   -- rather than storing the first initial and last name
                vote_choice bigint REFERENCES scotus_vote_choices(id) NOT NULL,
                direction bigint REFERENCES scotus_decision_directions(id) NOT NULL,
                --majority bigint REFERENCES scotus_majorities(id) NOT NULL,      -- is this just 1 for rep, 2 for dem?
                opinion bigint REFERENCES scotus_opinions(id) NOT NULL
                created timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
                updated timestamp without time zone,
                CONSTRAINT scotus_case_votes_decision_date_check CHECK (valid_yyyy_mm_dd(decision_date))
            );

            ALTER TABLE IF EXISTS scotus_case_votes OWNER to rds_superuser;
            GRANT SELECT ON TABLE scotus_case_votes TO api_reader;
            GRANT INSERT, UPDATE, SELECT, DELETE ON TABLE scotus_case_votes TO api_writer;
            GRANT ALL ON TABLE scotus_case_votes TO api_admin;

        -- original
            CREATE TABLE IF NOT EXISTS public."TEMP_supreme_court_justices"
            (
                "caseID" character varying COLLATE pg_catalog."default",
                term integer,
                chief character varying COLLATE pg_catalog."default",
                "dateDecision" date,
                "majOpinWriter" double precision,
                "justiceName" character varying COLLATE pg_catalog."default",
                vote character varying COLLATE pg_catalog."default",
                direction character varying COLLATE pg_catalog."default",
                majority double precision,
                opinon character varying COLLATE pg_catalog."default"
            )

            TABLESPACE pg_default;

            ALTER TABLE IF EXISTS public."TEMP_supreme_court_justices"
                OWNER to api_user;

            REVOKE ALL ON TABLE public."TEMP_supreme_court_justices" FROM api_reader;
            REVOKE ALL ON TABLE public."TEMP_supreme_court_justices" FROM api_writer;

            GRANT SELECT ON TABLE public."TEMP_supreme_court_justices" TO api_reader;

            GRANT ALL ON TABLE public."TEMP_supreme_court_justices" TO api_user;

            GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE public."TEMP_supreme_court_justices" TO api_writer;

    /* TERMS */
        -- new
            -- sequence
            CREATE SEQUENCE scotus_terms_id_seq START 1 INCREMENT 1;
            ALTER SEQUENCE scotus_terms_id_seq OWNER TO rds_superuser;
            GRANT USAGE ON SEQUENCE scotus_terms_id_seq TO api_writer;

            -- table
            CREATE TABLE IF NOT EXISTS scotus_terms
            (
                id bigint PRIMARY KEY DEFAULT nextval('scotus_terms_id_seq'::regclass),
                year integer not null,
                chief_justice bigint references officeholders(id) not null,
                created timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
                updated timestamp without time zone,
            );

            ALTER TABLE IF EXISTS scotus_terms OWNER to rds_superuser;
            GRANT SELECT ON TABLE scotus_terms TO api_reader;
            GRANT INSERT, UPDATE, SELECT, DELETE ON TABLE scotus_terms TO api_writer;
            GRANT ALL ON TABLE scotus_terms TO api_admin;

    /* DELETE - OUTCOMES */
        -- original
            CREATE TABLE IF NOT EXISTS public."TEMP_supreme_court_outcomes"
            (
                "caseID" character varying COLLATE pg_catalog."default" NOT NULL,
                "caseDisposition" double precision,
                "decisionType" character varying COLLATE pg_catalog."default",
                "decisionDirection" character varying COLLATE pg_catalog."default",
                "majVotes" integer,
                "minVotes" integer,
                issue double precision,
                "issueArea" character varying COLLATE pg_catalog."default"
            )

            TABLESPACE pg_default;

            ALTER TABLE IF EXISTS public."TEMP_supreme_court_outcomes"
                OWNER to api_user;

            REVOKE ALL ON TABLE public."TEMP_supreme_court_outcomes" FROM api_reader;
            REVOKE ALL ON TABLE public."TEMP_supreme_court_outcomes" FROM api_writer;

            GRANT SELECT ON TABLE public."TEMP_supreme_court_outcomes" TO api_reader;

            GRANT ALL ON TABLE public."TEMP_supreme_court_outcomes" TO api_user;

            GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE public."TEMP_supreme_court_outcomes" TO api_writer;