--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.5
-- Dumped by pg_dump version 9.6.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: api_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE api_tokens (
    id integer NOT NULL,
    user_id integer,
    team_id integer,
    revoked_at timestamp without time zone,
    token character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: api_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE api_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: api_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE api_tokens_id_seq OWNED BY api_tokens.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE attachments (
    id integer NOT NULL,
    name character varying,
    attachable_type character varying,
    attachable_id integer,
    story_id integer,
    owner_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    file_name character varying,
    file_size integer,
    content_type character varying,
    file_path character varying,
    process_data json DEFAULT '{}'::json,
    process_attempts integer DEFAULT 0,
    processed_at timestamp without time zone,
    team_id integer
);


--
-- Name: attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE attachments_id_seq OWNED BY attachments.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE comments (
    id integer NOT NULL,
    content text,
    commentable_type character varying,
    commentable_id integer,
    owner_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    team_id integer,
    story_id integer
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE notifications (
    id integer NOT NULL,
    user_id integer,
    project_id integer,
    story_id integer,
    notifiable_id integer,
    notifiable_type character varying,
    action_performed character varying,
    seen boolean DEFAULT false,
    delivered boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    team_id integer,
    actioner_id integer
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notifications_id_seq OWNED BY notifications.id;


--
-- Name: pg_search_documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pg_search_documents (
    id integer NOT NULL,
    content text,
    searchable_type character varying,
    searchable_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pg_search_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pg_search_documents_id_seq OWNED BY pg_search_documents.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE projects (
    id integer NOT NULL,
    name character varying,
    slug character varying,
    owner_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    team_id integer
);


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE projects_id_seq OWNED BY projects.id;


--
-- Name: projects_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE projects_users (
    id integer NOT NULL,
    user_id integer,
    project_id integer,
    receive_notifications boolean DEFAULT true
);


--
-- Name: projects_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE projects_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE projects_users_id_seq OWNED BY projects_users.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: search_documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE search_documents (
    id integer NOT NULL,
    searchable_type character varying,
    searchable_id integer,
    team_id integer,
    project_id integer,
    story_id integer,
    content text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: search_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE search_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: search_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE search_documents_id_seq OWNED BY search_documents.id;


--
-- Name: stories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE stories (
    id integer NOT NULL,
    project_id integer,
    name character varying,
    slug character varying,
    description text,
    owner_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    team_id integer,
    story_type character varying
);


--
-- Name: stories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stories_id_seq OWNED BY stories.id;


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tasks (
    id integer NOT NULL,
    label character varying,
    story_id integer,
    assigned_to integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    owner_id integer,
    completed boolean DEFAULT false NOT NULL,
    completed_on timestamp without time zone,
    completed_by integer,
    "order" integer,
    team_id integer,
    due_at timestamp without time zone
);


--
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tasks_id_seq OWNED BY tasks.id;


--
-- Name: team_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE team_users (
    id integer NOT NULL,
    team_id integer,
    user_id integer,
    role character varying DEFAULT 'user'::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    invite_accepted_at timestamp without time zone,
    invited_at timestamp without time zone,
    invited_by integer,
    status character varying DEFAULT 'active'::character varying NOT NULL,
    invitation_code character varying
);


--
-- Name: team_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE team_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: team_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE team_users_id_seq OWNED BY team_users.id;


--
-- Name: teams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE teams (
    id integer NOT NULL,
    name character varying,
    subdomain character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    setup_code character varying,
    setup_completed_at timestamp without time zone,
    setup_completed_by integer
);


--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE teams_id_seq OWNED BY teams.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    first_name character varying,
    last_name character varying,
    username citext,
    email citext DEFAULT ''::citext NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    notification_frequency character varying DEFAULT 'asap'::character varying,
    last_notified_at timestamp without time zone,
    deleted_at timestamp without time zone,
    job_title character varying,
    bio text,
    skype character varying,
    phone character varying,
    avatar_file_name character varying,
    avatar_file_path character varying,
    avatar_file_size integer,
    avatar_content_type character varying,
    confirmation_token character varying(128),
    remember_token character varying(128),
    admin boolean DEFAULT false NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: api_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY api_tokens ALTER COLUMN id SET DEFAULT nextval('api_tokens_id_seq'::regclass);


--
-- Name: attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY attachments ALTER COLUMN id SET DEFAULT nextval('attachments_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications ALTER COLUMN id SET DEFAULT nextval('notifications_id_seq'::regclass);


--
-- Name: pg_search_documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pg_search_documents ALTER COLUMN id SET DEFAULT nextval('pg_search_documents_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects ALTER COLUMN id SET DEFAULT nextval('projects_id_seq'::regclass);


--
-- Name: projects_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects_users ALTER COLUMN id SET DEFAULT nextval('projects_users_id_seq'::regclass);


--
-- Name: search_documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY search_documents ALTER COLUMN id SET DEFAULT nextval('search_documents_id_seq'::regclass);


--
-- Name: stories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY stories ALTER COLUMN id SET DEFAULT nextval('stories_id_seq'::regclass);


--
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tasks ALTER COLUMN id SET DEFAULT nextval('tasks_id_seq'::regclass);


--
-- Name: team_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY team_users ALTER COLUMN id SET DEFAULT nextval('team_users_id_seq'::regclass);


--
-- Name: teams id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY teams ALTER COLUMN id SET DEFAULT nextval('teams_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: api_tokens api_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY api_tokens
    ADD CONSTRAINT api_tokens_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: attachments attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY attachments
    ADD CONSTRAINT attachments_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: pg_search_documents pg_search_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pg_search_documents
    ADD CONSTRAINT pg_search_documents_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: projects_users projects_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects_users
    ADD CONSTRAINT projects_users_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: search_documents search_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY search_documents
    ADD CONSTRAINT search_documents_pkey PRIMARY KEY (id);


--
-- Name: stories stories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stories
    ADD CONSTRAINT stories_pkey PRIMARY KEY (id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: team_users team_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY team_users
    ADD CONSTRAINT team_users_pkey PRIMARY KEY (id);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_api_tokens_on_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_api_tokens_on_team_id ON api_tokens USING btree (team_id);


--
-- Name: index_api_tokens_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_api_tokens_on_token ON api_tokens USING btree (token);


--
-- Name: index_api_tokens_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_api_tokens_on_user_id ON api_tokens USING btree (user_id);


--
-- Name: index_attachments_on_attachable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_attachments_on_attachable_id ON attachments USING btree (attachable_id);


--
-- Name: index_attachments_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_attachments_on_owner_id ON attachments USING btree (owner_id);


--
-- Name: index_attachments_on_story_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_attachments_on_story_id ON attachments USING btree (story_id);


--
-- Name: index_attachments_on_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_attachments_on_team_id ON attachments USING btree (team_id);


--
-- Name: index_comments_on_commentable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_commentable_id ON comments USING btree (commentable_id);


--
-- Name: index_comments_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_owner_id ON comments USING btree (owner_id);


--
-- Name: index_comments_on_story_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_story_id ON comments USING btree (story_id);


--
-- Name: index_comments_on_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_team_id ON comments USING btree (team_id);


--
-- Name: index_notifications_on_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_team_id ON notifications USING btree (team_id);


--
-- Name: index_notifications_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_user_id ON notifications USING btree (user_id);


--
-- Name: index_pg_search_documents_on_searchable_type_and_searchable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pg_search_documents_on_searchable_type_and_searchable_id ON pg_search_documents USING btree (searchable_type, searchable_id);


--
-- Name: index_projects_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_deleted_at ON projects USING btree (deleted_at);


--
-- Name: index_projects_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_owner_id ON projects USING btree (owner_id);


--
-- Name: index_projects_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_projects_on_slug ON projects USING btree (slug);


--
-- Name: index_projects_on_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_team_id ON projects USING btree (team_id);


--
-- Name: index_projects_users_on_user_id_and_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_projects_users_on_user_id_and_project_id ON projects_users USING btree (user_id, project_id);


--
-- Name: index_search_documents_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_search_documents_on_project_id ON search_documents USING btree (project_id);


--
-- Name: index_search_documents_on_searchable_type_and_searchable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_search_documents_on_searchable_type_and_searchable_id ON search_documents USING btree (searchable_type, searchable_id);


--
-- Name: index_search_documents_on_story_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_search_documents_on_story_id ON search_documents USING btree (story_id);


--
-- Name: index_search_documents_on_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_search_documents_on_team_id ON search_documents USING btree (team_id);


--
-- Name: index_stories_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stories_on_deleted_at ON stories USING btree (deleted_at);


--
-- Name: index_stories_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stories_on_project_id ON stories USING btree (project_id);


--
-- Name: index_stories_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_stories_on_slug ON stories USING btree (slug);


--
-- Name: index_stories_on_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stories_on_team_id ON stories USING btree (team_id);


--
-- Name: index_tasks_on_assigned_to; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tasks_on_assigned_to ON tasks USING btree (assigned_to);


--
-- Name: index_tasks_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tasks_on_owner_id ON tasks USING btree (owner_id);


--
-- Name: index_tasks_on_story_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tasks_on_story_id ON tasks USING btree (story_id);


--
-- Name: index_tasks_on_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tasks_on_team_id ON tasks USING btree (team_id);


--
-- Name: index_team_users_on_invitation_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_team_users_on_invitation_code ON team_users USING btree (invitation_code);


--
-- Name: index_team_users_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_team_users_on_status ON team_users USING btree (status);


--
-- Name: index_team_users_on_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_team_users_on_team_id ON team_users USING btree (team_id);


--
-- Name: index_team_users_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_team_users_on_user_id ON team_users USING btree (user_id);


--
-- Name: index_teams_on_setup_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_teams_on_setup_code ON teams USING btree (setup_code);


--
-- Name: index_teams_on_subdomain; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_teams_on_subdomain ON teams USING btree (subdomain);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_remember_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_remember_token ON users USING btree (remember_token);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_username ON users USING btree (username);


--
-- Name: pg_search_documents_content; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pg_search_documents_content ON pg_search_documents USING gin (to_tsvector('english'::regconfig, content));


--
-- Name: search_documents_content; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX search_documents_content ON search_documents USING gin (to_tsvector('english'::regconfig, content));


--
-- Name: api_tokens fk_rails_3026241273; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY api_tokens
    ADD CONSTRAINT fk_rails_3026241273 FOREIGN KEY (team_id) REFERENCES teams(id);


--
-- Name: team_users fk_rails_6a8dc6a6fc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY team_users
    ADD CONSTRAINT fk_rails_6a8dc6a6fc FOREIGN KEY (team_id) REFERENCES teams(id);


--
-- Name: team_users fk_rails_8b0a3daf0d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY team_users
    ADD CONSTRAINT fk_rails_8b0a3daf0d FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: api_tokens fk_rails_f16b5e0447; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY api_tokens
    ADD CONSTRAINT fk_rails_f16b5e0447 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20150206163421'), ('20150206163523'), ('20150206163945'), ('20150206164025'), ('20150206164837'), ('20150206165324'), ('20150206165439'), ('20150206165858'), ('20150206170036'), ('20150206231753'), ('20150227113633'), ('20150306155556'), ('20150306162723'), ('20150619203825'), ('20150625135452'), ('20150625140256'), ('20150626105811'), ('20150709123308'), ('20150709153210'), ('20150709161745'), ('20150718133222'), ('20150724115748'), ('20150730132344'), ('20150730162623'), ('20150730170036'), ('20150811135707'), ('20150910113139'), ('20150910113223'), ('20150910115415'), ('20150910121953'), ('20150910155220'), ('20150910161337'), ('20150911135806'), ('20150914140555'), ('20150914170620'), ('20151002105613'), ('20151014104537'), ('20151020153443'), ('20160712191733'), ('20160727152048');


