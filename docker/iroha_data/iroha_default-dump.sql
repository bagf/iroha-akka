--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.25
-- Dumped by pg_dump version 9.5.25

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: account; Type: TABLE; Schema: public; Owner: iroha
--

CREATE TABLE public.account (
    account_id character varying(288) NOT NULL,
    domain_id character varying(255) NOT NULL,
    quorum integer NOT NULL,
    data jsonb
);


ALTER TABLE public.account OWNER TO iroha;

--
-- Name: account_has_asset; Type: TABLE; Schema: public; Owner: iroha
--

CREATE TABLE public.account_has_asset (
    account_id character varying(288) NOT NULL,
    asset_id character varying(288) NOT NULL,
    amount numeric NOT NULL
);


ALTER TABLE public.account_has_asset OWNER TO iroha;

--
-- Name: account_has_grantable_permissions; Type: TABLE; Schema: public; Owner: iroha
--

CREATE TABLE public.account_has_grantable_permissions (
    permittee_account_id character varying(288) NOT NULL,
    account_id character varying(288) NOT NULL,
    permission bit(6) NOT NULL
);


ALTER TABLE public.account_has_grantable_permissions OWNER TO iroha;

--
-- Name: account_has_roles; Type: TABLE; Schema: public; Owner: iroha
--

CREATE TABLE public.account_has_roles (
    account_id character varying(288) NOT NULL,
    role_id character varying(32) NOT NULL
);


ALTER TABLE public.account_has_roles OWNER TO iroha;

--
-- Name: account_has_signatory; Type: TABLE; Schema: public; Owner: iroha
--

CREATE TABLE public.account_has_signatory (
    account_id character varying(288) NOT NULL,
    public_key character varying NOT NULL
);


ALTER TABLE public.account_has_signatory OWNER TO iroha;

--
-- Name: asset; Type: TABLE; Schema: public; Owner: iroha
--

CREATE TABLE public.asset (
    asset_id character varying(288) NOT NULL,
    domain_id character varying(255) NOT NULL,
    "precision" integer NOT NULL
);


ALTER TABLE public.asset OWNER TO iroha;

--
-- Name: burrow_account_data; Type: TABLE; Schema: public; Owner: iroha
--

CREATE TABLE public.burrow_account_data (
    address character varying(40) NOT NULL,
    data text
);


ALTER TABLE public.burrow_account_data OWNER TO iroha;

--
-- Name: burrow_account_key_value; Type: TABLE; Schema: public; Owner: iroha
--

CREATE TABLE public.burrow_account_key_value (
    address character varying(40) NOT NULL,
    key character varying(64) NOT NULL,
    value text
);


ALTER TABLE public.burrow_account_key_value OWNER TO iroha;

--
-- Name: burrow_tx_logs; Type: TABLE; Schema: public; Owner: iroha
--

CREATE TABLE public.burrow_tx_logs (
    log_idx integer NOT NULL,
    call_id integer,
    address character varying(40),
    data text
);


ALTER TABLE public.burrow_tx_logs OWNER TO iroha;

--
-- Name: burrow_tx_logs_log_idx_seq; Type: SEQUENCE; Schema: public; Owner: iroha
--

CREATE SEQUENCE public.burrow_tx_logs_log_idx_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.burrow_tx_logs_log_idx_seq OWNER TO iroha;

--
-- Name: burrow_tx_logs_log_idx_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iroha
--

ALTER SEQUENCE public.burrow_tx_logs_log_idx_seq OWNED BY public.burrow_tx_logs.log_idx;


--
-- Name: burrow_tx_logs_topics; Type: TABLE; Schema: public; Owner: iroha
--

CREATE TABLE public.burrow_tx_logs_topics (
    topic character varying(64),
    log_idx integer
);


ALTER TABLE public.burrow_tx_logs_topics OWNER TO iroha;

--
-- Name: domain; Type: TABLE; Schema: public; Owner: iroha
--

CREATE TABLE public.domain (
    domain_id character varying(255) NOT NULL,
    default_role character varying(32) NOT NULL
);


ALTER TABLE public.domain OWNER TO iroha;

--
-- Name: engine_calls; Type: TABLE; Schema: public; Owner: iroha
--

CREATE TABLE public.engine_calls (
    call_id integer NOT NULL,
    tx_hash text NOT NULL,
    cmd_index bigint NOT NULL,
    engine_response text,
    callee character varying(40),
    created_address character varying(40)
);


ALTER TABLE public.engine_calls OWNER TO iroha;

--
-- Name: engine_calls_call_id_seq; Type: SEQUENCE; Schema: public; Owner: iroha
--

CREATE SEQUENCE public.engine_calls_call_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.engine_calls_call_id_seq OWNER TO iroha;

--
-- Name: engine_calls_call_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iroha
--

ALTER SEQUENCE public.engine_calls_call_id_seq OWNED BY public.engine_calls.call_id;


--
-- Name: peer; Type: TABLE; Schema: public; Owner: iroha
--

CREATE TABLE public.peer (
    public_key character varying NOT NULL,
    address character varying(261) NOT NULL,
    tls_certificate character varying
);


ALTER TABLE public.peer OWNER TO iroha;

--
-- Name: role; Type: TABLE; Schema: public; Owner: iroha
--

CREATE TABLE public.role (
    role_id character varying(32) NOT NULL
);


ALTER TABLE public.role OWNER TO iroha;

--
-- Name: role_has_permissions; Type: TABLE; Schema: public; Owner: iroha
--

CREATE TABLE public.role_has_permissions (
    role_id character varying(32) NOT NULL,
    permission bit(53) NOT NULL
);


ALTER TABLE public.role_has_permissions OWNER TO iroha;

--
-- Name: schema_version; Type: TABLE; Schema: public; Owner: iroha
--

CREATE TABLE public.schema_version (
    lock character(1) DEFAULT 'X'::bpchar NOT NULL,
    iroha_major integer NOT NULL,
    iroha_minor integer NOT NULL,
    iroha_patch integer NOT NULL
);


ALTER TABLE public.schema_version OWNER TO iroha;

--
-- Name: setting; Type: TABLE; Schema: public; Owner: iroha
--

CREATE TABLE public.setting (
    setting_key text NOT NULL,
    setting_value text
);


ALTER TABLE public.setting OWNER TO iroha;

--
-- Name: signatory; Type: TABLE; Schema: public; Owner: iroha
--

CREATE TABLE public.signatory (
    public_key character varying NOT NULL
);


ALTER TABLE public.signatory OWNER TO iroha;

--
-- Name: top_block_info; Type: TABLE; Schema: public; Owner: iroha
--

CREATE TABLE public.top_block_info (
    lock character(1) DEFAULT 'X'::bpchar NOT NULL,
    height integer,
    hash character varying(128)
);


ALTER TABLE public.top_block_info OWNER TO iroha;

--
-- Name: tx_positions; Type: TABLE; Schema: public; Owner: iroha
--

CREATE TABLE public.tx_positions (
    creator_id text,
    hash character varying(64) NOT NULL,
    asset_id text,
    ts bigint,
    height bigint,
    index bigint
);


ALTER TABLE public.tx_positions OWNER TO iroha;

--
-- Name: tx_status_by_hash; Type: TABLE; Schema: public; Owner: iroha
--

CREATE TABLE public.tx_status_by_hash (
    hash character varying,
    status boolean
);


ALTER TABLE public.tx_status_by_hash OWNER TO iroha;

--
-- Name: log_idx; Type: DEFAULT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.burrow_tx_logs ALTER COLUMN log_idx SET DEFAULT nextval('public.burrow_tx_logs_log_idx_seq'::regclass);


--
-- Name: call_id; Type: DEFAULT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.engine_calls ALTER COLUMN call_id SET DEFAULT nextval('public.engine_calls_call_id_seq'::regclass);


--
-- Data for Name: account; Type: TABLE DATA; Schema: public; Owner: iroha
--

COPY public.account (account_id, domain_id, quorum, data) FROM stdin;
admin@test	test	1	{}
test@test	test	1	{}
\.


--
-- Data for Name: account_has_asset; Type: TABLE DATA; Schema: public; Owner: iroha
--

COPY public.account_has_asset (account_id, asset_id, amount) FROM stdin;
\.


--
-- Data for Name: account_has_grantable_permissions; Type: TABLE DATA; Schema: public; Owner: iroha
--

COPY public.account_has_grantable_permissions (permittee_account_id, account_id, permission) FROM stdin;
\.


--
-- Data for Name: account_has_roles; Type: TABLE DATA; Schema: public; Owner: iroha
--

COPY public.account_has_roles (account_id, role_id) FROM stdin;
admin@test	user
test@test	user
admin@test	admin
admin@test	money_creator
\.


--
-- Data for Name: account_has_signatory; Type: TABLE DATA; Schema: public; Owner: iroha
--

COPY public.account_has_signatory (account_id, public_key) FROM stdin;
admin@test	313a07e6384776ed95447710d15e59148473ccfc052a681317a72a69f2a49910
test@test	716fe505f69f18511a1b083915aa9ff73ef36e6688199f3959750db38b8f4bfc
\.


--
-- Data for Name: asset; Type: TABLE DATA; Schema: public; Owner: iroha
--

COPY public.asset (asset_id, domain_id, "precision") FROM stdin;
coin#test	test	2
\.


--
-- Data for Name: burrow_account_data; Type: TABLE DATA; Schema: public; Owner: iroha
--

COPY public.burrow_account_data (address, data) FROM stdin;
\.


--
-- Data for Name: burrow_account_key_value; Type: TABLE DATA; Schema: public; Owner: iroha
--

COPY public.burrow_account_key_value (address, key, value) FROM stdin;
\.


--
-- Data for Name: burrow_tx_logs; Type: TABLE DATA; Schema: public; Owner: iroha
--

COPY public.burrow_tx_logs (log_idx, call_id, address, data) FROM stdin;
\.


--
-- Name: burrow_tx_logs_log_idx_seq; Type: SEQUENCE SET; Schema: public; Owner: iroha
--

SELECT pg_catalog.setval('public.burrow_tx_logs_log_idx_seq', 1, false);


--
-- Data for Name: burrow_tx_logs_topics; Type: TABLE DATA; Schema: public; Owner: iroha
--

COPY public.burrow_tx_logs_topics (topic, log_idx) FROM stdin;
\.


--
-- Data for Name: domain; Type: TABLE DATA; Schema: public; Owner: iroha
--

COPY public.domain (domain_id, default_role) FROM stdin;
test	user
\.


--
-- Data for Name: engine_calls; Type: TABLE DATA; Schema: public; Owner: iroha
--

COPY public.engine_calls (call_id, tx_hash, cmd_index, engine_response, callee, created_address) FROM stdin;
\.


--
-- Name: engine_calls_call_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iroha
--

SELECT pg_catalog.setval('public.engine_calls_call_id_seq', 1, false);


--
-- Data for Name: peer; Type: TABLE DATA; Schema: public; Owner: iroha
--

COPY public.peer (public_key, address, tls_certificate) FROM stdin;
bddd58404d1315e0eb27902c5d7c8eb0602c16238f005773df406bc191308929	127.0.0.1:10001	\N
\.


--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: iroha
--

COPY public.role (role_id) FROM stdin;
admin
user
money_creator
\.


--
-- Data for Name: role_has_permissions; Type: TABLE DATA; Schema: public; Owner: iroha
--

COPY public.role_has_permissions (role_id, permission) FROM stdin;
admin	00000000001000001001001001001001001011100001111100011
user	00000000000111110100100100100100100100011000111000000
money_creator	00000000000000000000000000000000000000011100000001000
\.


--
-- Data for Name: schema_version; Type: TABLE DATA; Schema: public; Owner: iroha
--

COPY public.schema_version (lock, iroha_major, iroha_minor, iroha_patch) FROM stdin;
X	1	2	0
\.


--
-- Data for Name: setting; Type: TABLE DATA; Schema: public; Owner: iroha
--

COPY public.setting (setting_key, setting_value) FROM stdin;
\.


--
-- Data for Name: signatory; Type: TABLE DATA; Schema: public; Owner: iroha
--

COPY public.signatory (public_key) FROM stdin;
313a07e6384776ed95447710d15e59148473ccfc052a681317a72a69f2a49910
716fe505f69f18511a1b083915aa9ff73ef36e6688199f3959750db38b8f4bfc
\.


--
-- Data for Name: top_block_info; Type: TABLE DATA; Schema: public; Owner: iroha
--

COPY public.top_block_info (lock, height, hash) FROM stdin;
X	1	05442a69e136eb4a065f9a7e732085fc29ae6e3f6d78343a26751bfaa3561a11
\.


--
-- Data for Name: tx_positions; Type: TABLE DATA; Schema: public; Owner: iroha
--

COPY public.tx_positions (creator_id, hash, asset_id, ts, height, index) FROM stdin;
	3822a0e1e7a344522ad8ef33ce4848ad8c6fdfb12585aea417a7bf4d7393e118	\N	0	1	0
\.


--
-- Data for Name: tx_status_by_hash; Type: TABLE DATA; Schema: public; Owner: iroha
--

COPY public.tx_status_by_hash (hash, status) FROM stdin;
3822a0e1e7a344522ad8ef33ce4848ad8c6fdfb12585aea417a7bf4d7393e118	t
\.


--
-- Name: account_has_asset_pkey; Type: CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.account_has_asset
    ADD CONSTRAINT account_has_asset_pkey PRIMARY KEY (account_id, asset_id);


--
-- Name: account_has_grantable_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.account_has_grantable_permissions
    ADD CONSTRAINT account_has_grantable_permissions_pkey PRIMARY KEY (permittee_account_id, account_id);


--
-- Name: account_has_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.account_has_roles
    ADD CONSTRAINT account_has_roles_pkey PRIMARY KEY (account_id, role_id);


--
-- Name: account_has_signatory_pkey; Type: CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.account_has_signatory
    ADD CONSTRAINT account_has_signatory_pkey PRIMARY KEY (account_id, public_key);


--
-- Name: account_pkey; Type: CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (account_id);


--
-- Name: asset_pkey; Type: CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.asset
    ADD CONSTRAINT asset_pkey PRIMARY KEY (asset_id);


--
-- Name: burrow_account_data_pkey; Type: CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.burrow_account_data
    ADD CONSTRAINT burrow_account_data_pkey PRIMARY KEY (address);


--
-- Name: burrow_account_key_value_pkey; Type: CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.burrow_account_key_value
    ADD CONSTRAINT burrow_account_key_value_pkey PRIMARY KEY (address, key);


--
-- Name: burrow_tx_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.burrow_tx_logs
    ADD CONSTRAINT burrow_tx_logs_pkey PRIMARY KEY (log_idx);


--
-- Name: domain_pkey; Type: CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.domain
    ADD CONSTRAINT domain_pkey PRIMARY KEY (domain_id);


--
-- Name: engine_calls_call_id_key; Type: CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.engine_calls
    ADD CONSTRAINT engine_calls_call_id_key UNIQUE (call_id);


--
-- Name: engine_calls_pkey; Type: CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.engine_calls
    ADD CONSTRAINT engine_calls_pkey PRIMARY KEY (tx_hash, cmd_index);


--
-- Name: peer_address_key; Type: CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.peer
    ADD CONSTRAINT peer_address_key UNIQUE (address);


--
-- Name: peer_pkey; Type: CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.peer
    ADD CONSTRAINT peer_pkey PRIMARY KEY (public_key);


--
-- Name: role_has_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_pkey PRIMARY KEY (role_id);


--
-- Name: role_pkey; Type: CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (role_id);


--
-- Name: schema_version_pkey; Type: CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.schema_version
    ADD CONSTRAINT schema_version_pkey PRIMARY KEY (lock);


--
-- Name: setting_pkey; Type: CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.setting
    ADD CONSTRAINT setting_pkey PRIMARY KEY (setting_key);


--
-- Name: signatory_pkey; Type: CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.signatory
    ADD CONSTRAINT signatory_pkey PRIMARY KEY (public_key);


--
-- Name: top_block_info_pkey; Type: CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.top_block_info
    ADD CONSTRAINT top_block_info_pkey PRIMARY KEY (lock);


--
-- Name: burrow_tx_logs_topics_log_idx; Type: INDEX; Schema: public; Owner: iroha
--

CREATE INDEX burrow_tx_logs_topics_log_idx ON public.burrow_tx_logs_topics USING btree (log_idx);


--
-- Name: tx_positions_creator_id_asset_index; Type: INDEX; Schema: public; Owner: iroha
--

CREATE INDEX tx_positions_creator_id_asset_index ON public.tx_positions USING btree (creator_id, asset_id);


--
-- Name: tx_positions_hash_index; Type: INDEX; Schema: public; Owner: iroha
--

CREATE INDEX tx_positions_hash_index ON public.tx_positions USING hash (hash);


--
-- Name: tx_positions_ts_height_index_index; Type: INDEX; Schema: public; Owner: iroha
--

CREATE INDEX tx_positions_ts_height_index_index ON public.tx_positions USING btree (ts);


--
-- Name: tx_status_by_hash_hash_index; Type: INDEX; Schema: public; Owner: iroha
--

CREATE INDEX tx_status_by_hash_hash_index ON public.tx_status_by_hash USING hash (hash);


--
-- Name: account_domain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_domain_id_fkey FOREIGN KEY (domain_id) REFERENCES public.domain(domain_id);


--
-- Name: account_has_asset_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.account_has_asset
    ADD CONSTRAINT account_has_asset_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.account(account_id);


--
-- Name: account_has_asset_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.account_has_asset
    ADD CONSTRAINT account_has_asset_asset_id_fkey FOREIGN KEY (asset_id) REFERENCES public.asset(asset_id);


--
-- Name: account_has_grantable_permissions_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.account_has_grantable_permissions
    ADD CONSTRAINT account_has_grantable_permissions_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.account(account_id);


--
-- Name: account_has_grantable_permissions_permittee_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.account_has_grantable_permissions
    ADD CONSTRAINT account_has_grantable_permissions_permittee_account_id_fkey FOREIGN KEY (permittee_account_id) REFERENCES public.account(account_id);


--
-- Name: account_has_roles_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.account_has_roles
    ADD CONSTRAINT account_has_roles_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.account(account_id);


--
-- Name: account_has_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.account_has_roles
    ADD CONSTRAINT account_has_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.role(role_id);


--
-- Name: account_has_signatory_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.account_has_signatory
    ADD CONSTRAINT account_has_signatory_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.account(account_id);


--
-- Name: account_has_signatory_public_key_fkey; Type: FK CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.account_has_signatory
    ADD CONSTRAINT account_has_signatory_public_key_fkey FOREIGN KEY (public_key) REFERENCES public.signatory(public_key);


--
-- Name: asset_domain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.asset
    ADD CONSTRAINT asset_domain_id_fkey FOREIGN KEY (domain_id) REFERENCES public.domain(domain_id);


--
-- Name: burrow_tx_logs_call_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.burrow_tx_logs
    ADD CONSTRAINT burrow_tx_logs_call_id_fkey FOREIGN KEY (call_id) REFERENCES public.engine_calls(call_id);


--
-- Name: burrow_tx_logs_topics_log_idx_fkey; Type: FK CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.burrow_tx_logs_topics
    ADD CONSTRAINT burrow_tx_logs_topics_log_idx_fkey FOREIGN KEY (log_idx) REFERENCES public.burrow_tx_logs(log_idx);


--
-- Name: domain_default_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.domain
    ADD CONSTRAINT domain_default_role_fkey FOREIGN KEY (default_role) REFERENCES public.role(role_id);


--
-- Name: role_has_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: iroha
--

ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.role(role_id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: iroha
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM iroha;
GRANT ALL ON SCHEMA public TO iroha;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

