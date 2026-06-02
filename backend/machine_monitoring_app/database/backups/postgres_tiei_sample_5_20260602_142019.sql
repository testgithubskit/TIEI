--
-- PostgreSQL database dump
--

\restrict ery40vEvYTtllR9RZJwTDqumoWBoANMPnfhhBsHa1uo9deDWjqBvnCupWAc3vDV

-- Dumped from database version 16.6 (Ubuntu 16.6-1.pgdg24.04+1)
-- Dumped by pg_dump version 18.1

-- Started on 2026-06-02 14:20:19

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 7 (class 2615 OID 16798)
-- Name: tiei_sample_5; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tiei_sample_5;


ALTER SCHEMA tiei_sample_5 OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 217 (class 1259 OID 16799)
-- Name: UpdateLog; Type: TABLE; Schema: tiei_sample_5; Owner: postgres
--

CREATE TABLE tiei_sample_5."UpdateLog" (
    id integer NOT NULL,
    "user" character varying NOT NULL,
    parameter_name character varying NOT NULL,
    limit_value double precision,
    reference_signal double precision[],
    set_type character varying NOT NULL,
    date_changed timestamp with time zone NOT NULL,
    previous_limit double precision
);


ALTER TABLE tiei_sample_5."UpdateLog" OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16804)
-- Name: UpdateLog_id_seq; Type: SEQUENCE; Schema: tiei_sample_5; Owner: postgres
--

CREATE SEQUENCE tiei_sample_5."UpdateLog_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tiei_sample_5."UpdateLog_id_seq" OWNER TO postgres;

--
-- TOC entry 3688 (class 0 OID 0)
-- Dependencies: 218
-- Name: UpdateLog_id_seq; Type: SEQUENCE OWNED BY; Schema: tiei_sample_5; Owner: postgres
--

ALTER SEQUENCE tiei_sample_5."UpdateLog_id_seq" OWNED BY tiei_sample_5."UpdateLog".id;


--
-- TOC entry 219 (class 1259 OID 16805)
-- Name: activities_history; Type: TABLE; Schema: tiei_sample_5; Owner: postgres
--

CREATE TABLE tiei_sample_5.activities_history (
    date_of_identification timestamp without time zone NOT NULL,
    machine_parameters_id integer NOT NULL,
    latest_occurrence timestamp without time zone,
    target_date_of_completion date,
    number_of_occurrences integer,
    corrective_measurement text,
    spare_required text,
    support_needed text,
    responsible_person_id integer,
    actual_date_of_completion date,
    priority text,
    recent_value double precision,
    parameter_condition_id integer
);


ALTER TABLE tiei_sample_5.activities_history OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16810)
-- Name: corrective_activity; Type: TABLE; Schema: tiei_sample_5; Owner: postgres
--

CREATE TABLE tiei_sample_5.corrective_activity (
    id integer NOT NULL,
    machine_parameters_id integer NOT NULL,
    date_of_identification timestamp without time zone,
    latest_occurrence timestamp without time zone,
    target_date_of_completion date,
    number_of_occurrences integer,
    corrective_measurement text,
    spare_required text,
    support_needed text,
    priority text,
    recent_value double precision,
    parameter_condition_id integer,
    responsible_person_id integer
);


ALTER TABLE tiei_sample_5.corrective_activity OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16815)
-- Name: corrective_activity_id_seq; Type: SEQUENCE; Schema: tiei_sample_5; Owner: postgres
--

CREATE SEQUENCE tiei_sample_5.corrective_activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tiei_sample_5.corrective_activity_id_seq OWNER TO postgres;

--
-- TOC entry 3689 (class 0 OID 0)
-- Dependencies: 221
-- Name: corrective_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: tiei_sample_5; Owner: postgres
--

ALTER SEQUENCE tiei_sample_5.corrective_activity_id_seq OWNED BY tiei_sample_5.corrective_activity.id;


--
-- TOC entry 222 (class 1259 OID 16816)
-- Name: emailuser; Type: TABLE; Schema: tiei_sample_5; Owner: postgres
--

CREATE TABLE tiei_sample_5.emailuser (
    id integer NOT NULL,
    user_name character varying(30) NOT NULL,
    email_id character varying(40) NOT NULL
);


ALTER TABLE tiei_sample_5.emailuser OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16819)
-- Name: emailuser_id_seq; Type: SEQUENCE; Schema: tiei_sample_5; Owner: postgres
--

CREATE SEQUENCE tiei_sample_5.emailuser_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tiei_sample_5.emailuser_id_seq OWNER TO postgres;

--
-- TOC entry 3690 (class 0 OID 0)
-- Dependencies: 223
-- Name: emailuser_id_seq; Type: SEQUENCE OWNED BY; Schema: tiei_sample_5; Owner: postgres
--

ALTER SEQUENCE tiei_sample_5.emailuser_id_seq OWNED BY tiei_sample_5.emailuser.id;


--
-- TOC entry 224 (class 1259 OID 16820)
-- Name: event_static_machine_parameters; Type: TABLE; Schema: tiei_sample_5; Owner: postgres
--

CREATE TABLE tiei_sample_5.event_static_machine_parameters (
    id integer NOT NULL,
    value double precision NOT NULL,
    machine_event_timeline_id integer NOT NULL,
    machine_parameters_id integer NOT NULL
);


ALTER TABLE tiei_sample_5.event_static_machine_parameters OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16823)
-- Name: event_static_machine_parameters_id_seq; Type: SEQUENCE; Schema: tiei_sample_5; Owner: postgres
--

CREATE SEQUENCE tiei_sample_5.event_static_machine_parameters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tiei_sample_5.event_static_machine_parameters_id_seq OWNER TO postgres;

--
-- TOC entry 3691 (class 0 OID 0)
-- Dependencies: 225
-- Name: event_static_machine_parameters_id_seq; Type: SEQUENCE OWNED BY; Schema: tiei_sample_5; Owner: postgres
--

ALTER SEQUENCE tiei_sample_5.event_static_machine_parameters_id_seq OWNED BY tiei_sample_5.event_static_machine_parameters.id;


--
-- TOC entry 226 (class 1259 OID 16824)
-- Name: events; Type: TABLE; Schema: tiei_sample_5; Owner: postgres
--

CREATE TABLE tiei_sample_5.events (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description text NOT NULL
);


ALTER TABLE tiei_sample_5.events OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16829)
-- Name: events_id_seq; Type: SEQUENCE; Schema: tiei_sample_5; Owner: postgres
--

CREATE SEQUENCE tiei_sample_5.events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tiei_sample_5.events_id_seq OWNER TO postgres;

--
-- TOC entry 3692 (class 0 OID 0)
-- Dependencies: 227
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: tiei_sample_5; Owner: postgres
--

ALTER SEQUENCE tiei_sample_5.events_id_seq OWNED BY tiei_sample_5.events.id;


--
-- TOC entry 228 (class 1259 OID 16830)
-- Name: ignored_parameter; Type: TABLE; Schema: tiei_sample_5; Owner: postgres
--

CREATE TABLE tiei_sample_5.ignored_parameter (
    id integer NOT NULL,
    machine_parameter_id integer NOT NULL
);


ALTER TABLE tiei_sample_5.ignored_parameter OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16833)
-- Name: ignored_parameter_id_seq; Type: SEQUENCE; Schema: tiei_sample_5; Owner: postgres
--

CREATE SEQUENCE tiei_sample_5.ignored_parameter_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tiei_sample_5.ignored_parameter_id_seq OWNER TO postgres;

--
-- TOC entry 3693 (class 0 OID 0)
-- Dependencies: 229
-- Name: ignored_parameter_id_seq; Type: SEQUENCE OWNED BY; Schema: tiei_sample_5; Owner: postgres
--

ALTER SEQUENCE tiei_sample_5.ignored_parameter_id_seq OWNED BY tiei_sample_5.ignored_parameter.id;


--
-- TOC entry 230 (class 1259 OID 16834)
-- Name: machine_event_timeline; Type: TABLE; Schema: tiei_sample_5; Owner: postgres
--

CREATE TABLE tiei_sample_5.machine_event_timeline (
    id integer NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone,
    duration interval day to second,
    events_id integer NOT NULL,
    machine_id integer NOT NULL
);


ALTER TABLE tiei_sample_5.machine_event_timeline OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16837)
-- Name: machine_event_timeline_id_seq; Type: SEQUENCE; Schema: tiei_sample_5; Owner: postgres
--

CREATE SEQUENCE tiei_sample_5.machine_event_timeline_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tiei_sample_5.machine_event_timeline_id_seq OWNER TO postgres;

--
-- TOC entry 3694 (class 0 OID 0)
-- Dependencies: 231
-- Name: machine_event_timeline_id_seq; Type: SEQUENCE OWNED BY; Schema: tiei_sample_5; Owner: postgres
--

ALTER SEQUENCE tiei_sample_5.machine_event_timeline_id_seq OWNED BY tiei_sample_5.machine_event_timeline.id;


--
-- TOC entry 232 (class 1259 OID 16838)
-- Name: machine_parameters; Type: TABLE; Schema: tiei_sample_5; Owner: postgres
--

CREATE TABLE tiei_sample_5.machine_parameters (
    id integer NOT NULL,
    name character varying(80) NOT NULL,
    warning_limit double precision,
    critical_limit double precision,
    reference_signal double precision[],
    parameter_type text,
    internal_parameter_name text,
    display_name text,
    unit_id integer,
    parameter_group_id integer,
    machine_id integer
);


ALTER TABLE tiei_sample_5.machine_parameters OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16843)
-- Name: machine_parameters_id_seq; Type: SEQUENCE; Schema: tiei_sample_5; Owner: postgres
--

CREATE SEQUENCE tiei_sample_5.machine_parameters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tiei_sample_5.machine_parameters_id_seq OWNER TO postgres;

--
-- TOC entry 3695 (class 0 OID 0)
-- Dependencies: 233
-- Name: machine_parameters_id_seq; Type: SEQUENCE OWNED BY; Schema: tiei_sample_5; Owner: postgres
--

ALTER SEQUENCE tiei_sample_5.machine_parameters_id_seq OWNED BY tiei_sample_5.machine_parameters.id;


--
-- TOC entry 234 (class 1259 OID 16844)
-- Name: machine_production_timeline; Type: TABLE; Schema: tiei_sample_5; Owner: postgres
--

CREATE TABLE tiei_sample_5.machine_production_timeline (
    id integer NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone,
    part_number character varying(50) NOT NULL,
    duration interval day to second,
    machine_id integer NOT NULL,
    machine_event_timeline_id integer NOT NULL
);


ALTER TABLE tiei_sample_5.machine_production_timeline OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16847)
-- Name: machine_production_timeline_id_seq; Type: SEQUENCE; Schema: tiei_sample_5; Owner: postgres
--

CREATE SEQUENCE tiei_sample_5.machine_production_timeline_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tiei_sample_5.machine_production_timeline_id_seq OWNER TO postgres;

--
-- TOC entry 3696 (class 0 OID 0)
-- Dependencies: 235
-- Name: machine_production_timeline_id_seq; Type: SEQUENCE OWNED BY; Schema: tiei_sample_5; Owner: postgres
--

ALTER SEQUENCE tiei_sample_5.machine_production_timeline_id_seq OWNED BY tiei_sample_5.machine_production_timeline.id;


--
-- TOC entry 236 (class 1259 OID 16848)
-- Name: machinepartcount; Type: TABLE; Schema: tiei_sample_5; Owner: postgres
--

CREATE TABLE tiei_sample_5.machinepartcount (
    id integer NOT NULL,
    part_signal_name text NOT NULL,
    current_part_count bigint NOT NULL,
    last_reset_count bigint NOT NULL,
    latest_update_time timestamp without time zone,
    machine_id integer NOT NULL
);


ALTER TABLE tiei_sample_5.machinepartcount OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16853)
-- Name: machinepartcount_id_seq; Type: SEQUENCE; Schema: tiei_sample_5; Owner: postgres
--

CREATE SEQUENCE tiei_sample_5.machinepartcount_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tiei_sample_5.machinepartcount_id_seq OWNER TO postgres;

--
-- TOC entry 3697 (class 0 OID 0)
-- Dependencies: 237
-- Name: machinepartcount_id_seq; Type: SEQUENCE OWNED BY; Schema: tiei_sample_5; Owner: postgres
--

ALTER SEQUENCE tiei_sample_5.machinepartcount_id_seq OWNED BY tiei_sample_5.machinepartcount.id;


--
-- TOC entry 238 (class 1259 OID 16854)
-- Name: machines; Type: TABLE; Schema: tiei_sample_5; Owner: postgres
--

CREATE TABLE tiei_sample_5.machines (
    id integer NOT NULL,
    name text NOT NULL,
    location text NOT NULL,
    machine_number text,
    short_name text,
    description text,
    enabled boolean,
    parameters integer
);


ALTER TABLE tiei_sample_5.machines OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 16859)
-- Name: machines_id_seq; Type: SEQUENCE; Schema: tiei_sample_5; Owner: postgres
--

CREATE SEQUENCE tiei_sample_5.machines_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tiei_sample_5.machines_id_seq OWNER TO postgres;

--
-- TOC entry 3698 (class 0 OID 0)
-- Dependencies: 239
-- Name: machines_id_seq; Type: SEQUENCE OWNED BY; Schema: tiei_sample_5; Owner: postgres
--

ALTER SEQUENCE tiei_sample_5.machines_id_seq OWNED BY tiei_sample_5.machines.id;


--
-- TOC entry 240 (class 1259 OID 16860)
-- Name: parameter_comparison; Type: TABLE; Schema: tiei_sample_5; Owner: postgres
--

CREATE TABLE tiei_sample_5.parameter_comparison (
    id integer NOT NULL,
    "time" timestamp without time zone NOT NULL,
    line character varying(80) NOT NULL,
    machine_id integer,
    parameter_group_id integer,
    machine_parameter1_id integer,
    machine_parameter2_id integer,
    warning_limit double precision,
    critical_limit double precision,
    time_1 timestamp without time zone,
    time_2 timestamp without time zone,
    value_1 double precision NOT NULL,
    value_2 double precision NOT NULL,
    difference double precision NOT NULL,
    condition_id integer
);


ALTER TABLE tiei_sample_5.parameter_comparison OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 16863)
-- Name: parameter_comparison_id_seq; Type: SEQUENCE; Schema: tiei_sample_5; Owner: postgres
--

CREATE SEQUENCE tiei_sample_5.parameter_comparison_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tiei_sample_5.parameter_comparison_id_seq OWNER TO postgres;

--
-- TOC entry 3699 (class 0 OID 0)
-- Dependencies: 241
-- Name: parameter_comparison_id_seq; Type: SEQUENCE OWNED BY; Schema: tiei_sample_5; Owner: postgres
--

ALTER SEQUENCE tiei_sample_5.parameter_comparison_id_seq OWNED BY tiei_sample_5.parameter_comparison.id;


--
-- TOC entry 242 (class 1259 OID 16864)
-- Name: parameter_conditions; Type: TABLE; Schema: tiei_sample_5; Owner: postgres
--

CREATE TABLE tiei_sample_5.parameter_conditions (
    id integer NOT NULL,
    name character varying(30) NOT NULL
);


ALTER TABLE tiei_sample_5.parameter_conditions OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 16867)
-- Name: parameter_conditions_id_seq; Type: SEQUENCE; Schema: tiei_sample_5; Owner: postgres
--

CREATE SEQUENCE tiei_sample_5.parameter_conditions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tiei_sample_5.parameter_conditions_id_seq OWNER TO postgres;

--
-- TOC entry 3700 (class 0 OID 0)
-- Dependencies: 243
-- Name: parameter_conditions_id_seq; Type: SEQUENCE OWNED BY; Schema: tiei_sample_5; Owner: postgres
--

ALTER SEQUENCE tiei_sample_5.parameter_conditions_id_seq OWNED BY tiei_sample_5.parameter_conditions.id;


--
-- TOC entry 244 (class 1259 OID 16868)
-- Name: parameters_group; Type: TABLE; Schema: tiei_sample_5; Owner: postgres
--

CREATE TABLE tiei_sample_5.parameters_group (
    id integer NOT NULL,
    group_name text NOT NULL,
    mongodb_query text NOT NULL,
    latest_update_time timestamp without time zone,
    warning_limit double precision,
    critical_limit double precision,
    parameter_type text NOT NULL
);


ALTER TABLE tiei_sample_5.parameters_group OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 16873)
-- Name: parameters_group_id_seq; Type: SEQUENCE; Schema: tiei_sample_5; Owner: postgres
--

CREATE SEQUENCE tiei_sample_5.parameters_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tiei_sample_5.parameters_group_id_seq OWNER TO postgres;

--
-- TOC entry 3701 (class 0 OID 0)
-- Dependencies: 245
-- Name: parameters_group_id_seq; Type: SEQUENCE OWNED BY; Schema: tiei_sample_5; Owner: postgres
--

ALTER SEQUENCE tiei_sample_5.parameters_group_id_seq OWNED BY tiei_sample_5.parameters_group.id;


--
-- TOC entry 246 (class 1259 OID 16874)
-- Name: real_time_machine_parameters; Type: TABLE; Schema: tiei_sample_5; Owner: postgres
--

CREATE TABLE tiei_sample_5.real_time_machine_parameters (
    "time" timestamp without time zone NOT NULL,
    value double precision NOT NULL,
    condition_id integer,
    machine_parameters_id integer NOT NULL
);


ALTER TABLE tiei_sample_5.real_time_machine_parameters OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 16877)
-- Name: real_time_machine_parameters_active; Type: TABLE; Schema: tiei_sample_5; Owner: postgres
--

CREATE TABLE tiei_sample_5.real_time_machine_parameters_active (
    id integer NOT NULL,
    "time" timestamp without time zone NOT NULL,
    value double precision,
    condition_id integer,
    machine_parameters_id integer NOT NULL
);


ALTER TABLE tiei_sample_5.real_time_machine_parameters_active OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 16880)
-- Name: real_time_machine_parameters_active_id_seq; Type: SEQUENCE; Schema: tiei_sample_5; Owner: postgres
--

CREATE SEQUENCE tiei_sample_5.real_time_machine_parameters_active_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tiei_sample_5.real_time_machine_parameters_active_id_seq OWNER TO postgres;

--
-- TOC entry 3702 (class 0 OID 0)
-- Dependencies: 248
-- Name: real_time_machine_parameters_active_id_seq; Type: SEQUENCE OWNED BY; Schema: tiei_sample_5; Owner: postgres
--

ALTER SEQUENCE tiei_sample_5.real_time_machine_parameters_active_id_seq OWNED BY tiei_sample_5.real_time_machine_parameters_active.id;


--
-- TOC entry 249 (class 1259 OID 16881)
-- Name: spare_part; Type: TABLE; Schema: tiei_sample_5; Owner: postgres
--

CREATE TABLE tiei_sample_5.spare_part (
    id integer NOT NULL,
    part_name text NOT NULL,
    reference_part_number bigint NOT NULL,
    warning_limit integer NOT NULL,
    critical_limit integer NOT NULL,
    machine_id integer NOT NULL
);


ALTER TABLE tiei_sample_5.spare_part OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 16886)
-- Name: spare_part_activity; Type: TABLE; Schema: tiei_sample_5; Owner: postgres
--

CREATE TABLE tiei_sample_5.spare_part_activity (
    id integer NOT NULL,
    machine_id integer NOT NULL,
    spare_part_id integer NOT NULL,
    spare_part_name text NOT NULL,
    date_of_identification timestamp without time zone NOT NULL,
    priority text NOT NULL,
    target_date_of_completion date,
    corrective_measurement text NOT NULL,
    spare_required text NOT NULL,
    support_needed text NOT NULL,
    responsible_person_id integer
);


ALTER TABLE tiei_sample_5.spare_part_activity OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 16891)
-- Name: spare_part_activity_history; Type: TABLE; Schema: tiei_sample_5; Owner: postgres
--

CREATE TABLE tiei_sample_5.spare_part_activity_history (
    id integer NOT NULL,
    machine_id integer NOT NULL,
    spare_part_id integer NOT NULL,
    spare_part_name text NOT NULL,
    date_of_identification timestamp without time zone NOT NULL,
    priority text NOT NULL,
    target_date_of_completion date,
    corrective_measurement text NOT NULL,
    spare_required text NOT NULL,
    support_needed text NOT NULL,
    responsible_person_id integer,
    date_of_completion date
);


ALTER TABLE tiei_sample_5.spare_part_activity_history OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 16896)
-- Name: spare_part_activity_history_id_seq; Type: SEQUENCE; Schema: tiei_sample_5; Owner: postgres
--

CREATE SEQUENCE tiei_sample_5.spare_part_activity_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tiei_sample_5.spare_part_activity_history_id_seq OWNER TO postgres;

--
-- TOC entry 3703 (class 0 OID 0)
-- Dependencies: 252
-- Name: spare_part_activity_history_id_seq; Type: SEQUENCE OWNED BY; Schema: tiei_sample_5; Owner: postgres
--

ALTER SEQUENCE tiei_sample_5.spare_part_activity_history_id_seq OWNED BY tiei_sample_5.spare_part_activity_history.id;


--
-- TOC entry 253 (class 1259 OID 16897)
-- Name: spare_part_activity_id_seq; Type: SEQUENCE; Schema: tiei_sample_5; Owner: postgres
--

CREATE SEQUENCE tiei_sample_5.spare_part_activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tiei_sample_5.spare_part_activity_id_seq OWNER TO postgres;

--
-- TOC entry 3704 (class 0 OID 0)
-- Dependencies: 253
-- Name: spare_part_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: tiei_sample_5; Owner: postgres
--

ALTER SEQUENCE tiei_sample_5.spare_part_activity_id_seq OWNED BY tiei_sample_5.spare_part_activity.id;


--
-- TOC entry 254 (class 1259 OID 16898)
-- Name: spare_part_id_seq; Type: SEQUENCE; Schema: tiei_sample_5; Owner: postgres
--

CREATE SEQUENCE tiei_sample_5.spare_part_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tiei_sample_5.spare_part_id_seq OWNER TO postgres;

--
-- TOC entry 3705 (class 0 OID 0)
-- Dependencies: 254
-- Name: spare_part_id_seq; Type: SEQUENCE OWNED BY; Schema: tiei_sample_5; Owner: postgres
--

ALTER SEQUENCE tiei_sample_5.spare_part_id_seq OWNED BY tiei_sample_5.spare_part.id;


--
-- TOC entry 255 (class 1259 OID 16899)
-- Name: units; Type: TABLE; Schema: tiei_sample_5; Owner: postgres
--

CREATE TABLE tiei_sample_5.units (
    id integer NOT NULL,
    name character varying(80) NOT NULL,
    short_name character varying(30) NOT NULL,
    description text NOT NULL,
    type character varying(50) NOT NULL
);


ALTER TABLE tiei_sample_5.units OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 16904)
-- Name: units_id_seq; Type: SEQUENCE; Schema: tiei_sample_5; Owner: postgres
--

CREATE SEQUENCE tiei_sample_5.units_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tiei_sample_5.units_id_seq OWNER TO postgres;

--
-- TOC entry 3706 (class 0 OID 0)
-- Dependencies: 256
-- Name: units_id_seq; Type: SEQUENCE OWNED BY; Schema: tiei_sample_5; Owner: postgres
--

ALTER SEQUENCE tiei_sample_5.units_id_seq OWNED BY tiei_sample_5.units.id;


--
-- TOC entry 257 (class 1259 OID 16905)
-- Name: user; Type: TABLE; Schema: tiei_sample_5; Owner: postgres
--

CREATE TABLE tiei_sample_5."user" (
    id integer NOT NULL,
    username text NOT NULL,
    email text NOT NULL,
    full_name text NOT NULL,
    disabled boolean,
    hashed_password text NOT NULL,
    role text NOT NULL,
    company_id bigint
);


ALTER TABLE tiei_sample_5."user" OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 16910)
-- Name: user_access_log; Type: TABLE; Schema: tiei_sample_5; Owner: postgres
--

CREATE TABLE tiei_sample_5.user_access_log (
    id integer NOT NULL,
    user_id integer NOT NULL,
    "timestamp" timestamp without time zone NOT NULL
);


ALTER TABLE tiei_sample_5.user_access_log OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 16913)
-- Name: user_access_log_id_seq; Type: SEQUENCE; Schema: tiei_sample_5; Owner: postgres
--

CREATE SEQUENCE tiei_sample_5.user_access_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tiei_sample_5.user_access_log_id_seq OWNER TO postgres;

--
-- TOC entry 3707 (class 0 OID 0)
-- Dependencies: 259
-- Name: user_access_log_id_seq; Type: SEQUENCE OWNED BY; Schema: tiei_sample_5; Owner: postgres
--

ALTER SEQUENCE tiei_sample_5.user_access_log_id_seq OWNED BY tiei_sample_5.user_access_log.id;


--
-- TOC entry 260 (class 1259 OID 16914)
-- Name: user_id_seq; Type: SEQUENCE; Schema: tiei_sample_5; Owner: postgres
--

CREATE SEQUENCE tiei_sample_5.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tiei_sample_5.user_id_seq OWNER TO postgres;

--
-- TOC entry 3708 (class 0 OID 0)
-- Dependencies: 260
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: tiei_sample_5; Owner: postgres
--

ALTER SEQUENCE tiei_sample_5.user_id_seq OWNED BY tiei_sample_5."user".id;


--
-- TOC entry 3359 (class 2604 OID 17565)
-- Name: UpdateLog id; Type: DEFAULT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5."UpdateLog" ALTER COLUMN id SET DEFAULT nextval('tiei_sample_5."UpdateLog_id_seq"'::regclass);


--
-- TOC entry 3360 (class 2604 OID 17566)
-- Name: corrective_activity id; Type: DEFAULT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.corrective_activity ALTER COLUMN id SET DEFAULT nextval('tiei_sample_5.corrective_activity_id_seq'::regclass);


--
-- TOC entry 3361 (class 2604 OID 17567)
-- Name: emailuser id; Type: DEFAULT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.emailuser ALTER COLUMN id SET DEFAULT nextval('tiei_sample_5.emailuser_id_seq'::regclass);


--
-- TOC entry 3362 (class 2604 OID 17568)
-- Name: event_static_machine_parameters id; Type: DEFAULT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.event_static_machine_parameters ALTER COLUMN id SET DEFAULT nextval('tiei_sample_5.event_static_machine_parameters_id_seq'::regclass);


--
-- TOC entry 3363 (class 2604 OID 17569)
-- Name: events id; Type: DEFAULT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.events ALTER COLUMN id SET DEFAULT nextval('tiei_sample_5.events_id_seq'::regclass);


--
-- TOC entry 3364 (class 2604 OID 17570)
-- Name: ignored_parameter id; Type: DEFAULT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.ignored_parameter ALTER COLUMN id SET DEFAULT nextval('tiei_sample_5.ignored_parameter_id_seq'::regclass);


--
-- TOC entry 3365 (class 2604 OID 17571)
-- Name: machine_event_timeline id; Type: DEFAULT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.machine_event_timeline ALTER COLUMN id SET DEFAULT nextval('tiei_sample_5.machine_event_timeline_id_seq'::regclass);


--
-- TOC entry 3366 (class 2604 OID 17572)
-- Name: machine_parameters id; Type: DEFAULT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.machine_parameters ALTER COLUMN id SET DEFAULT nextval('tiei_sample_5.machine_parameters_id_seq'::regclass);


--
-- TOC entry 3367 (class 2604 OID 17573)
-- Name: machine_production_timeline id; Type: DEFAULT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.machine_production_timeline ALTER COLUMN id SET DEFAULT nextval('tiei_sample_5.machine_production_timeline_id_seq'::regclass);


--
-- TOC entry 3368 (class 2604 OID 17574)
-- Name: machinepartcount id; Type: DEFAULT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.machinepartcount ALTER COLUMN id SET DEFAULT nextval('tiei_sample_5.machinepartcount_id_seq'::regclass);


--
-- TOC entry 3369 (class 2604 OID 17575)
-- Name: machines id; Type: DEFAULT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.machines ALTER COLUMN id SET DEFAULT nextval('tiei_sample_5.machines_id_seq'::regclass);


--
-- TOC entry 3370 (class 2604 OID 17576)
-- Name: parameter_comparison id; Type: DEFAULT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.parameter_comparison ALTER COLUMN id SET DEFAULT nextval('tiei_sample_5.parameter_comparison_id_seq'::regclass);


--
-- TOC entry 3371 (class 2604 OID 17577)
-- Name: parameter_conditions id; Type: DEFAULT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.parameter_conditions ALTER COLUMN id SET DEFAULT nextval('tiei_sample_5.parameter_conditions_id_seq'::regclass);


--
-- TOC entry 3372 (class 2604 OID 17578)
-- Name: parameters_group id; Type: DEFAULT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.parameters_group ALTER COLUMN id SET DEFAULT nextval('tiei_sample_5.parameters_group_id_seq'::regclass);


--
-- TOC entry 3373 (class 2604 OID 17579)
-- Name: real_time_machine_parameters_active id; Type: DEFAULT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.real_time_machine_parameters_active ALTER COLUMN id SET DEFAULT nextval('tiei_sample_5.real_time_machine_parameters_active_id_seq'::regclass);


--
-- TOC entry 3374 (class 2604 OID 17580)
-- Name: spare_part id; Type: DEFAULT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.spare_part ALTER COLUMN id SET DEFAULT nextval('tiei_sample_5.spare_part_id_seq'::regclass);


--
-- TOC entry 3375 (class 2604 OID 16931)
-- Name: spare_part_activity id; Type: DEFAULT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.spare_part_activity ALTER COLUMN id SET DEFAULT nextval('tiei_sample_5.spare_part_activity_id_seq'::regclass);


--
-- TOC entry 3376 (class 2604 OID 16932)
-- Name: spare_part_activity_history id; Type: DEFAULT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.spare_part_activity_history ALTER COLUMN id SET DEFAULT nextval('tiei_sample_5.spare_part_activity_history_id_seq'::regclass);


--
-- TOC entry 3377 (class 2604 OID 17581)
-- Name: units id; Type: DEFAULT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.units ALTER COLUMN id SET DEFAULT nextval('tiei_sample_5.units_id_seq'::regclass);


--
-- TOC entry 3378 (class 2604 OID 17582)
-- Name: user id; Type: DEFAULT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5."user" ALTER COLUMN id SET DEFAULT nextval('tiei_sample_5.user_id_seq'::regclass);


--
-- TOC entry 3379 (class 2604 OID 17583)
-- Name: user_access_log id; Type: DEFAULT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.user_access_log ALTER COLUMN id SET DEFAULT nextval('tiei_sample_5.user_access_log_id_seq'::regclass);


--
-- TOC entry 3639 (class 0 OID 16799)
-- Dependencies: 217
-- Data for Name: UpdateLog; Type: TABLE DATA; Schema: tiei_sample_5; Owner: postgres
--

COPY tiei_sample_5."UpdateLog" (id, "user", parameter_name, limit_value, reference_signal, set_type, date_changed, previous_limit) FROM stdin;
1	cmti	ServoLeakResistData_5_path1_T_B_OP230	105	{0}	warning_limit	2024-07-22 10:19:05.714893+00	\N
2	cmti	ServoLeakResistData_5_path1_T_B_OP230	105	{0}	warning_limit	2024-07-22 10:19:07.210089+00	\N
3	cmti	ServoLeakResistData_5_path1_T_B_OP230	105	{0}	warning_limit	2024-07-22 10:21:19.561525+00	\N
4	cmti	ServoLeakResistData_5_path1_T_B_OP230	50	{0}	warning_limit	2024-07-22 10:23:16.009691+00	\N
5	cmti	ServoLeakResistData_5_path1_T_B_OP230	50	{0}	warning_limit	2024-07-22 10:32:32.264528+00	\N
6	cmti	ServoLeakResistData_5_path1_T_B_OP230	50	{0}	warning_limit	2024-07-22 10:34:36.238475+00	\N
7	cmti	ServoLeakResistData_5_path1_T_B_OP230	50	{0}	warning_limit	2024-07-22 10:37:28.468432+00	\N
8	cmti	ServoLeakResistData_5_path1_T_B_OP230	50	{0}	warning_limit	2024-07-22 10:37:34.901552+00	\N
9	cmti	ServoLeakResistData_5_path1_T_B_OP230	50	{0}	warning_limit	2024-07-22 10:38:49.499219+00	\N
10	cmti	ServoLeakResistData_5_path1_T_B_OP230	105	{0}	warning_limit	2024-07-22 10:39:36.859198+00	\N
11	NihalDM	ServoLeakResistData_5_path1_T_B_OP230	106	{0}	warning_limit	2024-07-22 10:41:02.206678+00	\N
12	cmti	ServoLeakResistData_5_path1_T_B_OP230	112	{0}	warning_limit	2024-07-23 10:06:44.288492+00	106
13	cmti	ServoLeakResistData_5_path1_T_B_OP230	112	{0}	warning_limit	2024-07-23 10:07:27.391671+00	112
14	cmti	ServoLeakResistData_5_path1_T_B_OP230	112	{0}	warning_limit	2024-07-23 10:11:12.399615+00	112
15	cmti	ServoLeakResistData_5_path1_T_B_OP230	109	{0}	warning_limit	2024-07-23 10:11:38.906395+00	112
16	NihalDM	ServoLeakResistData_3_path1_T_C_OP160	70	{0}	warning_limit	2024-07-23 10:30:03.938907+00	\N
17	cmti	ServoLeakResistData_5_path1_T_B_OP230	109	{0}	warning_limit	2024-07-23 10:38:23.824893+00	109
18	cmti	ServoLeakResistData_5_path1_T_B_OP230	109	{0}	warning_limit	2024-07-23 10:41:58.438759+00	109
19	cmti	ServoLeakResistData_5_path1_T_B_OP230	109	{0}	warning_limit	2024-07-23 10:42:08.442093+00	109
20	cmti	ServoLeakResistData_5_path1_T_B_OP230	109	{0}	warning_limit	2024-07-23 10:44:08.508103+00	109
27	cmti	ServoLeakResistData_5_path1_T_B_OP230	109	{0}	warning_limit	2024-07-23 11:14:30.145446+00	106
28	cmti	ServoLeakResistData_5_path1_T_B_OP230	108	{0}	warning_limit	2024-07-23 11:17:00.470118+00	109
29	cmti	ServoLeakResistData_5_path1_T_B_OP230	108	{0}	warning_limit	2024-07-23 11:17:13.053083+00	108
30	NihalDM	ServoLeakResistData_3_path1_T_B_OP230	100	{0}	warning_limit	2024-07-23 11:18:22.692151+00	50
31	NihalDM	ServoLeakResistData_0_path1_T_B_OP230	140	{0}	warning_limit	2024-07-23 11:27:04.73012+00	50
32	cmti	PulseCoderTemp_4_path1_T_B_OP195B	50	{0}	warning_limit	2024-09-10 05:02:36.909101+00	50
33	cmti	ServoLeakResistData_3_path1_T_B_OP195A	555	{0}	warning_limit	2024-10-14 08:59:33.733397+00	50
38	cmti	ServoTemp_3_path1_T_B_OP230	65	{0}	warning_limit	2026-05-19 05:21:16.11543+00	65
39	cmti	ServoTemp_3_path1_T_B_OP230	70	{0}	warning_limit	2026-05-19 05:21:21.719011+00	65
40	cmti	ServoTemp_3_path1_T_B_OP230	50	{0}	warning_limit	2026-05-19 05:21:26.13511+00	70
41	cmti	ServoTemp_3_path1_T_B_OP230	10	{0}	warning_limit	2026-05-19 05:21:38.714748+00	50
42	cmti	ServoTemp_3_path1_T_B_OP230	10	{0}	warning_limit	2026-05-19 05:21:47.811761+00	10
43	cmti	ServoTemp_3_path1_T_B_OP230	74	{0}	warning_limit	2026-05-19 05:22:53.342158+00	10
44	cmti	ServoTemp_3_path1_T_B_OP230	74.9999	{0}	warning_limit	2026-05-19 05:23:06.776003+00	74
45	cmti	ServoTemp_3_path1_T_B_OP230	45	{0}	warning_limit	2026-05-19 05:23:11.358861+00	74.9999
46	cmti	ServoTemp_3_path1_T_B_OP230	75	{0}	critical_limit	2026-05-19 05:24:41.284718+00	75
47	cmti	ServoTemp_3_path1_T_B_OP230	46	{0}	critical_limit	2026-05-19 05:25:15.547092+00	75
48	cmti	ServoTemp_3_path1_T_B_OP230	45	{0}	warning_limit	2026-05-19 05:25:42.468664+00	45
49	cmti	ServoTemp_3_path1_T_B_OP230	46	{0}	critical_limit	2026-05-19 05:26:10.320282+00	46
50	cmti	ServoTemp_3_path1_T_B_OP230	46	{0}	critical_limit	2026-05-19 05:27:01.503818+00	46
34	cmti	ServoLeakResistData_7_path1_T_H_OP240	50	{0}	warning_limit	2024-11-25 09:40:02.853673+00	50
35	cmti	ServoLeakResistData_7_path1_T_H_OP240	50	{0}	warning_limit	2024-11-25 09:40:06.233575+00	50
36	cmti	ServoLeakResistData_7_path1_T_H_OP240	50	{0}	warning_limit	2024-11-25 09:40:07.414226+00	50
37	cmti	ServoLeakResistData_7_path1_T_H_OP240	30	{0}	critical_limit	2024-11-25 09:40:09.732471+00	30
\.


--
-- TOC entry 3641 (class 0 OID 16805)
-- Dependencies: 219
-- Data for Name: activities_history; Type: TABLE DATA; Schema: tiei_sample_5; Owner: postgres
--

COPY tiei_sample_5.activities_history (date_of_identification, machine_parameters_id, latest_occurrence, target_date_of_completion, number_of_occurrences, corrective_measurement, spare_required, support_needed, responsible_person_id, actual_date_of_completion, priority, recent_value, parameter_condition_id) FROM stdin;
2024-03-15 04:19:31.5	3706	2024-03-15 07:00:31.5	2024-03-19	6	Check the encoder condition	none	-	\N	2024-03-18	A	60	2
2024-05-06 15:27:34.5	6757	2024-05-06 15:27:34.5	2024-05-06	80	Alarm generated during battery replacement	No	No	\N	2024-05-15	C	1	3
2024-05-06 15:27:34.5	6760	2024-05-06 15:27:34.5	2024-05-06	80	Alarm generated during battery replacement	No	No	\N	2024-05-15	C	1	3
2024-05-06 15:33:34.5	5096	2024-05-06 15:33:34.5	2024-05-06	26	Alarm generated during battery replacement	No	No	\N	2024-05-15	C	1	3
2024-05-06 15:33:34.5	5097	2024-05-06 15:33:34.5	2024-05-06	26	Alarm generated during battery replacement	No	No	\N	2024-05-15	C	1	3
2024-05-06 15:33:34.5	5098	2024-05-06 15:33:34.5	2024-05-06	26	Alarm generated during battery replacement	No	No	\N	2024-05-15	C	1	3
2024-05-06 15:34:34.5	5100	2024-05-06 15:34:34.5	2024-05-06	54	Alarm generated during battery replacement	No	No	\N	2024-05-15	C	1	3
2024-05-06 15:34:34.5	6759	2024-05-06 15:34:34.5	2024-05-06	54	Alarm generated during battery replacement	No	No	\N	2024-05-15	C	1	3
2024-05-06 15:36:34.5	6758	2024-05-06 15:36:34.5	2024-05-06	80	Alarm generated during battery replacement	No	No	\N	2024-05-15	C	1	3
2024-05-06 15:36:34.5	6761	2024-05-06 15:36:34.5	2024-05-06	80	Alarm generated during battery replacement	No	No	\N	2024-05-15	C	1	3
2024-05-12 06:01:43	6927	2024-05-17 14:15:35.5	2024-05-18	195	X2 axis servo amplifier fan replaced	GX314L00035	-	\N	2024-05-18	C	8800	3
2024-05-09 21:46:28.5	1398	2024-05-09 21:46:28.5	2024-05-10	52	Alarm generated during battery replacement	No	No	\N	2024-05-17	C	1	3
2024-05-28 21:33:28.5	1625	2024-05-28 21:33:28.5	2024-05-30	6	Battery replacement	Yes	NO	\N	2024-05-29	A	1	3
2024-03-01 05:11:36.5	6532	2024-03-19 13:25:44.5	2024-07-18	13004	-	-	-	4	2024-07-16	A	9000	3
2024-03-01 04:51:54	792	2024-03-01 23:56:42.5	2024-07-25	567	none	None	None	4	2024-07-22	C	8800	3
2022-06-22 02:33:28.5	602	2022-06-22 02:33:28.5	2024-07-26	1	sasdsadasd	asdasd	ASas	4	2024-07-22	C	0	3
2024-03-01 06:24:41.5	6580	2024-03-19 08:47:47	2024-07-04	93	-asdasd	-asdasd	-asdadas	4	2024-07-22	C	9000	3
2024-03-01 05:48:35	2206	2024-05-31 04:08:28	2024-07-30	34116	-	-	-	4	2024-07-25	C	60	2
2024-03-01 06:24:41	6928	2024-03-20 01:34:44.5	2024-07-31	394	-	-	-	4	2024-07-25	C	8800	3
2024-03-01 06:24:41.5	6484	2024-03-19 04:19:40.5	2024-07-26	93	-	-	-	4	2024-07-26	C	9000	3
2024-03-01 05:02:38	6548	2024-03-19 23:58:44.5	2024-08-31	6007	-	-	-	4	2024-07-26	C	9000	3
2024-08-15 06:24:41.5	6516	2024-03-18 09:57:43	2024-08-24	3315	-	-	-	1	2024-08-22	B	8800	3
2024-03-01 06:24:41.5	6468	2024-03-19 23:18:39.5	2024-08-30	5347	-wqwe	-qwe	-wqe	1	2024-08-22	C	8800	3
2024-08-18 12:47:22	1451	2024-05-30 15:37:13	2024-08-30	2269	-adasd	-dasd	-asdasd	1	2024-08-22	C	75	2
2024-08-17 12:46:44	5042	2024-05-30 21:44:28	2024-10-09	23226	-	-	-	1	2024-10-23	C	60	2
\.


--
-- TOC entry 3642 (class 0 OID 16810)
-- Dependencies: 220
-- Data for Name: corrective_activity; Type: TABLE DATA; Schema: tiei_sample_5; Owner: postgres
--

COPY tiei_sample_5.corrective_activity (id, machine_parameters_id, date_of_identification, latest_occurrence, target_date_of_completion, number_of_occurrences, corrective_measurement, spare_required, support_needed, priority, recent_value, parameter_condition_id, responsible_person_id) FROM stdin;
11592	6958	2024-03-01 06:24:41.5	2024-03-19 04:19:37	\N	243		-	-	C	8800	3	\N
11630	5038	2024-03-02 09:44:50.5	2024-05-06 15:34:34.5	\N	1652	\N	\N	\N	\N	85	2	\N
11509	6449	2024-08-01 04:51:54	2024-03-01 23:56:42.5	\N	567	-	-	-	C	8800	3	5
11510	2321	2024-08-01 04:57:35	2024-05-31 04:07:28	\N	20775		-	-	C	55	2	5
11513	6332	2024-08-11 05:34:56.5	2024-05-22 04:43:49.5	\N	4554	-	-	-	C	90	2	\N
11599	6564	2024-03-01 06:24:41.5	2024-03-06 03:40:45.5	\N	1037	-	-	-	C	9000	3	1
11589	5636	2024-08-01 06:24:41	2024-03-20 01:34:44.5	\N	1534	-	-	-	C	9000	3	\N
11593	6974	2024-08-01 06:24:41.5	2024-03-19 04:19:38	\N	122	-	-	-	C	8800	3	\N
11588	5635	2024-08-12 06:24:41	2024-03-20 01:34:44.5	\N	1534	-	-	-	C	9000	3	1
11591	6942	2024-08-14 06:24:41.5	2024-03-20 15:06:37	\N	596	-	-	-	C	8800	3	\N
11594	6990	2024-08-01 06:24:41.5	2024-03-19 09:15:38.5	\N	372	-	-	-	C	8800	3	\N
11597	6500	2024-08-01 06:24:41.5	2024-03-20 02:31:42	\N	6422	-	-	-	C	8800	3	\N
11612	5039	2024-08-01 13:08:43.5	2024-05-30 18:08:28.5	\N	11211	-	-	-	C	70	2	\N
11633	932	2024-08-04 08:36:39	2024-05-30 17:01:26	\N	3829	-	-	-	C	55	2	\N
11601	6596	2024-08-16 06:24:41.5	2024-03-19 04:18:47.5	\N	243	-	-	-	C	8800	3	\N
11613	4197	2024-03-01 13:18:19	2024-05-30 21:54:28	\N	21404	-	-	-	C	55	2	\N
11614	409	2024-03-01 13:27:46.5	2024-05-31 03:58:26.5	\N	6735	-	-	-	C	51	2	\N
11624	1444	2024-03-01 13:55:18	2024-05-30 16:23:26.5	\N	6584	-	-	-	C	55	2	\N
11626	1528	2024-03-01 14:15:50.5	2024-05-30 21:56:27	\N	14803	-	-	-	C	65	2	\N
11627	1355	2024-03-01 14:38:18	2024-05-31 04:03:26.5	\N	9102	-	-	-	C	65	2	\N
11631	1595	2024-03-04 07:59:19.5	2024-03-28 06:47:08.5	\N	786	-	-	-	C	60	2	\N
11639	522	2024-08-04 09:08:22	2024-05-28 13:54:15	\N	1293	-	-	-	C	95	2	\N
11608	6800	2024-08-16 06:52:44	2024-05-31 02:14:28.5	\N	8172	-	-	-	C	90	2	\N
11637	1950	2024-03-04 08:46:45	2024-05-30 17:10:26	\N	3048	-	-	-	C	67	2	\N
11638	1834	2024-03-04 08:58:15	2024-05-30 14:38:21	\N	6115	-	-	-	C	70	2	\N
11629	1770	2024-08-17 08:52:17	2024-05-30 17:39:26	\N	5168	-	-	-	C	60	2	\N
11634	1830	2024-08-14 08:37:53.5	2024-05-30 17:09:26	\N	2194	-	-	-	C	65	2	\N
11640	655	2024-08-04 10:19:29	2024-05-30 14:27:22.5	\N	3365	-	-	-	C	55	2	\N
11641	281	2024-08-04 10:21:13.5	2024-05-22 06:52:47.5	\N	1525	-	-	-	C	92	2	\N
11647	5317	2024-08-04 11:04:30.5	2024-05-30 12:48:21	\N	1182	-	-	-	C	55	2	\N
11646	282	2024-03-04 11:03:13.5	2024-04-01 11:29:03.5	\N	299	-	-	-	C	60	2	\N
11636	855	2024-08-17 08:40:38.5	2024-05-30 17:01:26	\N	5835	-	-	-	C	60	2	\N
11660	2322	2024-08-04 20:03:50	2024-05-30 21:45:27.5	\N	11407	-	-	-	C	55	2	\N
11652	1015	2024-03-04 12:35:23	2024-05-30 15:16:12.5	\N	2437	-	-	-	C	63	2	\N
11654	1246	2024-03-04 12:55:34	2024-05-30 17:05:27	\N	8556	-	-	-	C	60	2	\N
11655	2197	2024-03-04 13:19:41.5	2024-05-30 23:59:28	\N	16618	-	-	-	C	55	2	\N
11656	1955	2024-03-04 13:27:56.5	2024-05-30 21:55:28	\N	21092	-	-	-	C	60	2	\N
11683	3204	2024-08-07 14:44:22.5	2024-05-30 17:19:28	\N	7703	-	-	-	C	60	2	\N
11658	5036	2024-03-04 13:49:16	2024-05-30 16:01:23.5	\N	3076	-	-	-	C	60	2	\N
11650	1710	2024-08-18 11:50:56.5	2024-05-30 12:23:11.5	\N	1896	-	-	-	C	67	2	\N
11661	2331	2024-03-05 06:15:40.5	2024-05-30 21:53:28	\N	13016	-	-	-	C	60	2	\N
11685	532	2024-08-08 09:33:52	2024-04-29 15:02:20	\N	443	-	-	-	C	90	2	\N
11663	5408	2024-03-05 07:26:28	2024-05-11 10:48:37	\N	1350	-	-	-	C	55	2	\N
11664	5363	2024-03-05 07:37:49	2024-05-30 08:42:21	\N	1650	-	-	-	C	55	2	\N
11687	2455	2024-08-08 15:42:32	2024-05-30 23:38:09.5	\N	17558	-	-	-	C	60	2	\N
11667	5168	2024-03-05 08:25:15.5	2024-05-04 14:10:33.5	\N	1886	-	-	-	C	70	2	\N
11669	5409	2024-03-05 08:37:28	2024-05-11 12:48:37	\N	1819	-	-	-	C	55	2	\N
11670	1247	2024-03-05 08:49:33.5	2024-05-30 21:12:27	\N	15040	-	-	-	C	60	2	\N
11672	1835	2024-03-05 10:37:15	2024-05-06 09:54:35.5	\N	3787	-	-	-	C	60	2	\N
11675	6363	2024-03-05 10:57:29	2024-04-15 11:28:10	\N	93	-	-	-	C	100	2	\N
11676	1079	2024-03-05 11:00:22	2024-05-31 03:57:26	\N	619577	-	-	-	C	46.7	2	\N
11677	4946	2024-03-05 11:21:35	2024-05-30 19:35:26	\N	6143	-	-	-	C	55	2	\N
11678	1890	2024-03-05 12:46:15	2024-05-30 12:38:21	\N	914	-	-	-	C	65	2	\N
11679	4706	2024-03-06 18:06:21.5	2024-05-30 21:52:28	\N	7420	-	-	-	C	75	2	\N
11680	1349	2024-03-07 12:58:10	2024-04-16 14:41:20	\N	84	-	-	-	C	55	2	\N
11689	1594	2024-03-09 08:35:25	2024-05-06 10:02:38	\N	818	-	-	-	C	70	2	\N
1	601	2022-06-22 02:33:28.5	2022-06-22 02:33:28.5	\N	1					0	3	\N
3	600	2022-06-22 02:33:28.5	2022-06-22 02:33:28.5	\N	1					0	3	\N
11609	5500	2024-03-01 08:06:17	2024-05-30 11:06:21	\N	2557	-	-	-	C	55	2	\N
11625	400	2024-03-01 14:15:45.5	2024-05-30 17:49:27	\N	5965	-	-	-	C	43	2	\N
11642	406	2024-03-04 10:26:22	2024-05-22 13:54:47.5	\N	590	-	-	-	C	95	2	\N
11651	1590	2024-03-04 12:09:39.5	2024-05-06 09:28:32	\N	226	-	-	-	C	65	2	\N
11659	856	2024-03-04 14:45:39	2024-05-30 17:25:26	\N	5165	-	-	-	C	60	2	\N
11674	1077	2024-03-05 10:50:22.5	2024-05-31 03:57:26	\N	554031	-	-	-	C	48	2	\N
11682	4705	2024-03-07 14:13:31.5	2024-05-30 21:48:28	\N	4858	-	-	-	C	60	2	\N
11692	5499	2024-03-09 10:41:25	2024-05-11 13:22:37	\N	1991	-	-	-	C	70	2	\N
11693	1716	2024-03-09 10:56:25	2024-05-06 08:57:08.5	\N	1992	-	-	-	C	60	2	\N
11603	6676	2024-03-01 06:24:41.5	2024-03-19 04:18:52.5	\N	650	-	-	-	C	9000	3	4
11607	2831	2024-03-01 06:29:28	2024-05-31 04:11:28	\N	4382	-	-	-	C	60	2	4
11632	5316	2024-03-04 08:13:30.5	2024-05-30 12:42:21	\N	2042	-	-	-	C	55	2	1
11643	5678	2024-03-04 10:31:43	2024-05-30 09:34:22.5	\N	2669	-	-	-	C	60	2	5
11648	1535	2024-03-04 11:15:39.5	2024-05-11 10:31:37	\N	2167	-	-	-	C	60	2	1
11657	6058	2024-03-04 13:30:24.5	2024-05-31 00:05:28	\N	33833	-	-	-	C	60	2	6
11671	657	2024-03-05 10:26:29	2024-05-30 15:12:22.5	\N	1500	-	-	-	C	75	2	1
11673	5628	2024-03-05 10:48:43.5	2024-05-11 08:52:38	\N	3263	-	-	-	C	70	2	1
11684	5038	2024-03-08 06:58:51	2024-05-06 12:33:34.5	\N	43	\N	\N	\N	\N	90	3	4
11686	5808	2024-03-08 15:41:00	2024-05-30 21:50:27.5	\N	17465	-	-	-	C	60	2	5
11691	4831	2024-03-09 09:58:56	2024-05-30 13:43:21	\N	2910	-	-	-	C	60	2	6
11635	1534	2024-08-04 08:39:39.5	2024-05-30 15:39:21	\N	3280	-	-	-	C	70	2	\N
11644	533	2024-08-04 10:36:14	2024-04-29 14:27:19.5	\N	3054	-	-	-	C	70	2	5
11645	1775	2024-08-04 10:37:53.5	2024-05-30 10:36:21	\N	3470	-	-	-	C	60	2	5
11662	2947	2024-08-05 06:23:19	2024-05-30 21:43:28	\N	666	-	-	-	C	55	2	1
11665	3081	2024-08-05 07:40:56	2024-05-30 21:39:28.5	\N	2704	-	-	-	C	60	2	4
11668	1653	2024-08-05 08:30:56.5	2024-05-30 11:47:11.5	\N	2260	-	-	-	C	60	2	5
11681	4822	2024-08-07 14:05:32	2024-05-30 21:38:28	\N	1576	-	-	-	C	70	2	6
11688	1774	2024-08-09 07:28:25	2024-05-04 14:44:31	\N	2210	-	-	-	C	70	2	4
11690	4832	2024-08-09 09:17:56	2024-05-30 16:19:21	\N	1464	-	-	-	C	60	2	\N
11602	6628	2024-08-15 06:24:41.5	2024-03-19 04:18:49.5	\N	264	-	-	-	C	8800	3	4
11604	6736	2024-08-15 06:24:41.5	2024-03-19 23:56:55.5	\N	8203	-	-	-	C	8800	3	4
11610	5037	2024-08-17 12:30:44	2024-05-30 19:31:28.5	\N	10502	-	-	-	C	80	2	1
11666	5501	2024-08-14 08:15:38.5	2024-05-11 12:43:37	\N	1811	-	-	-	C	55	2	\N
4	5690	2022-06-22 01:54:39	2022-06-22 01:54:39	\N	2					0	3	6
5	407	2024-06-22 05:52:03	2024-06-22 05:52:03	\N	3					90	3	\N
\.


--
-- TOC entry 3644 (class 0 OID 16816)
-- Dependencies: 222
-- Data for Name: emailuser; Type: TABLE DATA; Schema: tiei_sample_5; Owner: postgres
--

COPY tiei_sample_5.emailuser (id, user_name, email_id) FROM stdin;
\.


--
-- TOC entry 3646 (class 0 OID 16820)
-- Dependencies: 224
-- Data for Name: event_static_machine_parameters; Type: TABLE DATA; Schema: tiei_sample_5; Owner: postgres
--

COPY tiei_sample_5.event_static_machine_parameters (id, value, machine_event_timeline_id, machine_parameters_id) FROM stdin;
\.


--
-- TOC entry 3648 (class 0 OID 16824)
-- Dependencies: 226
-- Data for Name: events; Type: TABLE DATA; Schema: tiei_sample_5; Owner: postgres
--

COPY tiei_sample_5.events (id, name, description) FROM stdin;
\.


--
-- TOC entry 3650 (class 0 OID 16830)
-- Dependencies: 228
-- Data for Name: ignored_parameter; Type: TABLE DATA; Schema: tiei_sample_5; Owner: postgres
--

COPY tiei_sample_5.ignored_parameter (id, machine_parameter_id) FROM stdin;
\.


--
-- TOC entry 3652 (class 0 OID 16834)
-- Dependencies: 230
-- Data for Name: machine_event_timeline; Type: TABLE DATA; Schema: tiei_sample_5; Owner: postgres
--

COPY tiei_sample_5.machine_event_timeline (id, start_time, end_time, duration, events_id, machine_id) FROM stdin;
\.


--
-- TOC entry 3654 (class 0 OID 16838)
-- Dependencies: 232
-- Data for Name: machine_parameters; Type: TABLE DATA; Schema: tiei_sample_5; Owner: postgres
--

COPY tiei_sample_5.machine_parameters (id, name, warning_limit, critical_limit, reference_signal, parameter_type, internal_parameter_name, display_name, unit_id, parameter_group_id, machine_id) FROM stdin;
1	seat_diameter	\N	\N	{}	\N	\N	\N	12	\N	1
2	fan_speed	\N	\N	{}	\N	\N	\N	1	\N	1
3	powder_wait_time	55	70	{}	\N	\N	\N	3	\N	1
4	laser_line_t1_data_table	\N	\N	{}	\N	\N	\N	3	\N	1
5	laser_line_t2_data_table	\N	\N	{}	\N	\N	\N	3	\N	1
6	laser_line_t3_data_table	\N	\N	{}	\N	\N	\N	3	\N	1
7	laser_line_t4_data_table	\N	\N	{}	\N	\N	\N	3	\N	1
8	laser_line_t5_data_table	\N	\N	{}	\N	\N	\N	3	\N	1
9	laser_line_t6_data_table	\N	\N	{}	\N	\N	\N	3	\N	1
10	laser_line_v0_data_table	\N	\N	{}	\N	\N	\N	2	\N	1
11	laser_line_v1_data_table	\N	\N	{}	\N	\N	\N	2	\N	1
12	laser_line_v2_data_table	\N	\N	{}	\N	\N	\N	2	\N	1
13	laser_line_v3_data_table	\N	\N	{}	\N	\N	\N	2	\N	1
14	feeder_t0_data_table	\N	\N	{}	\N	\N	\N	9	\N	1
15	feeder_t1_data_table	\N	\N	{}	\N	\N	\N	9	\N	1
16	feeder_t2_data_table	\N	\N	{}	\N	\N	\N	9	\N	1
17	feeder_t3_data_table	\N	\N	{}	\N	\N	\N	9	\N	1
18	feeder_q1_data_table	\N	\N	{}	\N	\N	\N	4	\N	1
19	feeder_q2_data_table	\N	\N	{}	\N	\N	\N	4	\N	1
20	feeder_q3_data_table	\N	\N	{}	\N	\N	\N	4	\N	1
21	powder_measuring_output_value	\N	\N	{}	\N	\N	\N	2	\N	1
22	powder_measuring_value	\N	\N	{}	\N	\N	\N	10	\N	1
23	process_cycle_running_seat_number	\N	\N	{}	spm_static	\N	\N	6	\N	1
24	c_axis_machine_position	\N	\N	{}	spm_static	\N	\N	5	\N	1
25	laser_output_monitor_value	\N	\N	{}	spm_dynamic	\N	\N	11	\N	1
26	feeder_powder_flow	\N	\N	{}	spm_dynamic	\N	\N	4	\N	1
27	feeder_internal_pressure	\N	\N	{}	spm_dynamic	\N	\N	7	\N	1
28	carrier_gas_flow	\N	\N	{}	spm_dynamic	\N	\N	8	\N	1
29	center_gas_flow	\N	\N	{}	spm_dynamic	\N	\N	8	\N	1
30	PulseCoderTemp_0_path1_T_B_OP160	48	60	{}	increasing	A0-P1	X	13	4	2
31	PulseCoderTemp_1_path1_T_B_OP160	87	108	{}	increasing	A1-P1	Y	13	4	2
32	PulseCoderTemp_2_path1_T_B_OP160	60	65	{}	increasing	A2-P1	Z	13	4	2
33	PulseCoderTemp_3_path1_T_B_OP160	60	60	{}	increasing	A3-P1	BA5	13	4	2
34	PulseCoderTemp_4_path1_T_B_OP160	60	60	{}	increasing	A4-P1	AM5	13	4	2
38	CncFan1Speed_path1_T_B_OP160	4500	4000	{}	decreasing	A0-P1	F1	16	6	2
39	CncFan2Speed_path1_T_B_OP160	9600	8600	{}	decreasing	A1-P1	F2	16	6	2
42	InFan1SrvAmpSpeed_0_path1_T_B_OP160	9500	9000	{}	decreasing	A0-P1	X	2	8	2
43	InFan1SrvAmpSpeed_1_path1_T_B_OP160	9500	9000	{}	decreasing	A1-P1	Y	2	8	2
44	InFan1SrvAmpSpeed_2_path1_T_B_OP160	9500	9000	{}	decreasing	A2-P1	Z	2	8	2
45	InFan1SrvAmpSpeed_3_path1_T_B_OP160	9500	9000	{}	decreasing	A3-P1	BA5	2	8	2
46	InFan1SrvAmpSpeed_4_path1_T_B_OP160	8500	7500	{}	decreasing	A4-P1	AM5	2	8	2
50	ServoLoad_0_path1_T_B_OP160	NaN	NaN	{}	increasing	A0-P1	X	17	17	2
51	ServoLoad_1_path1_T_B_OP160	NaN	NaN	{}	increasing	A1-P1	Y	17	17	2
52	ServoLoad_2_path1_T_B_OP160	NaN	NaN	{}	increasing	A2-P1	Z	17	17	2
53	ServoLoad_3_path1_T_B_OP160	NaN	NaN	{}	increasing	A3-P1	BA5	17	17	2
54	ServoLoad_4_path1_T_B_OP160	NaN	NaN	{}	increasing	A4-P1	AM5	17	17	2
58	SpindleLoad_0_path1_T_B_OP160	NaN	NaN	{}	increasing	SP-P1	SP	17	17	2
59	SpdBatZero_0_path1_T_B_OP160	NaN	NaN	{}	bool	A0-P1	X	6	13	2
60	SpdBatZero_1_path1_T_B_OP160	NaN	NaN	{}	bool	A1-P1	Y	6	13	2
61	SpdBatZero_2_path1_T_B_OP160	NaN	NaN	{}	bool	A2-P1	Z	6	13	2
62	SpdBatZero_3_path1_T_B_OP160	NaN	NaN	{}	bool	A3-P1	BA5	6	13	2
63	SpdBatZero_4_path1_T_B_OP160	NaN	NaN	{}	bool	A4-P1	AM5	6	13	2
67	SSpdBatZero_0_path1_T_B_OP160	NaN	NaN	{}	bool	AO-P1	X	6	14	2
68	SSpdBatZero_1_path1_T_B_OP160	NaN	NaN	{}	bool	A1-P1	Y	6	14	2
69	SSpdBatZero_2_path1_T_B_OP160	NaN	NaN	{}	bool	A2-P1	Z	6	14	2
70	SSpdBatZero_3_path1_T_B_OP160	NaN	NaN	{}	bool	A3-P1	BA5	6	14	2
71	SSpdBatZero_4_path1_T_B_OP160	NaN	NaN	{}	bool	A4-P1	AM5	6	14	2
75	RadFan2SpindleAmpSpeed_0_path1_T_B_OP160	5000	4500	{}	decreasing	SP-P1	SP	2	16	2
76	RadFan2SrvAmpSpeed_0_path1_T_B_OP160	5000	4500	{}	decreasing	A0-P1	X	2	16	2
77	RadFan2SrvAmpSpeed_1_path1_T_B_OP160	5000	4500	{}	decreasing	A1-P1	Y	2	16	2
78	RadFan2SrvAmpSpeed_2_path1_T_B_OP160	5000	4500	{}	decreasing	A2-P1	Z	2	16	2
79	RadFan2SrvAmpSpeed_3_path1_T_B_OP160	5000	4500	{}	decreasing	A3-P1	BA5	2	16	2
80	RadFan2SrvAmpSpeed_4_path1_T_B_OP160	5000	4500	{}	decreasing	A4-P1	AM5	2	16	2
84	ApcBatLow_0_path1_T_B_OP160	NaN	NaN	{}	bool	A0-P1	X	6	1	2
85	ApcBatLow_1_path1_T_B_OP160	NaN	NaN	{}	bool	A1-P1	Y	6	1	2
86	ApcBatLow_2_path1_T_B_OP160	NaN	NaN	{}	bool	A2-P1	Z	6	1	2
87	ApcBatLow_3_path1_T_B_OP160	NaN	NaN	{}	bool	A3-P1	BA5	6	1	2
88	ApcBatLow_4_path1_T_B_OP160	NaN	NaN	{}	bool	A4-P1	AM5	6	1	2
92	CncBatLow_0_path1_T_B_OP160	NaN	NaN	{}	bool	A0-P1	X	6	2	2
93	CncBatLow_1_path1_T_B_OP160	NaN	NaN	{}	bool	A1-P1	Y	6	2	2
94	CncBatLow_2_path1_T_B_OP160	NaN	NaN	{}	bool	A2-P1	Z	6	2	2
95	CncBatLow_3_path1_T_B_OP160	NaN	NaN	{}	bool	A3-P1	BA5	6	2	2
96	CncBatLow_4_path1_T_B_OP160	NaN	NaN	{}	bool	A4-P1	AM5	6	2	2
100	ServoLeakResistData_0_path1_T_B_OP160	50	30	{}	decreasing	A0-P1	X	15	5	2
101	ServoLeakResistData_1_path1_T_B_OP160	50	30	{}	decreasing	A1-P1	Y	15	5	2
102	ServoLeakResistData_2_path1_T_B_OP160	50	30	{}	decreasing	A2-P1	Z	15	5	2
103	ServoLeakResistData_3_path1_T_B_OP160	50	30	{}	decreasing	A3-P1	BA5	15	5	2
104	ServoLeakResistData_4_path1_T_B_OP160	50	30	{}	decreasing	A4-P1	AM5	15	5	2
108	SpindleLeakResistData_0_path1_T_B_OP160	50	30	{}	decreasing	SP-P1	SP	15	5	2
109	InFan1SrvComPwSpeed_0_path1_T_B_OP160	6200	6000	{}	decreasing	A0-P1	X	2	9	2
110	InFan1SrvComPwSpeed_1_path1_T_B_OP160	6200	6000	{}	decreasing	A1-P1	Y	2	9	2
111	InFan1SrvComPwSpeed_2_path1_T_B_OP160	6200	6000	{}	decreasing	A2-P1	Z	2	9	2
112	InFan1SrvComPwSpeed_3_path1_T_B_OP160	6200	6000	{}	decreasing	A3-P1	BA5	2	9	2
113	InFan1SrvComPwSpeed_4_path1_T_B_OP160	6200	6000	{}	decreasing	A4-P1	AM5	2	9	2
117	InFan2SrvAmpSpeed_0_path1_T_B_OP160	5000	4500	{}	decreasing	A0-P1	X	2	11	2
118	InFan2SrvAmpSpeed_1_path1_T_B_OP160	5000	4500	{}	decreasing	A1-P1	Y	2	11	2
119	InFan2SrvAmpSpeed_2_path1_T_B_OP160	5000	4500	{}	decreasing	A2-P1	Z	2	11	2
120	InFan2SrvAmpSpeed_3_path1_T_B_OP160	5000	4500	{}	decreasing	A3-P1	BA5	2	11	2
121	InFan2SrvAmpSpeed_4_path1_T_B_OP160	5000	4500	{}	decreasing	A4-P1	AM5	2	11	2
125	RadFan1SpindleAmpSpeed_0_path1_T_B_OP160	5000	4500	{}	decreasing	SP-P1	SP	2	15	2
126	RadFan1SrvAmpSpeed_0_path1_T_B_OP160	5000	4500	{}	decreasing	A0-P1	X	2	15	2
127	RadFan1SrvAmpSpeed_1_path1_T_B_OP160	5000	4500	{}	decreasing	A1-P1	Y	2	15	2
128	RadFan1SrvAmpSpeed_2_path1_T_B_OP160	5000	4500	{}	decreasing	A2-P1	Z	2	15	2
129	RadFan1SrvAmpSpeed_3_path1_T_B_OP160	5000	4500	{}	decreasing	A3-P1	BA5	2	15	2
130	RadFan1SrvAmpSpeed_4_path1_T_B_OP160	5000	4500	{}	decreasing	A4-P1	AM5	2	15	2
134	InFan2SpdlComPwSpeed_0_path1_T_B_OP160	5000	4500	{}	decreasing	A0-P1	SAS	2	10	2
135	InFan2SpindleAmpSpeed_0_path1_T_B_OP160	5000	4500	{}	decreasing	A1-P1	SCS	2	10	2
136	InFan2SrvComPwSpeed_0_path1_T_B_OP160	5000	4500	{}	decreasing	A0-P1	X	2	12	2
137	InFan2SrvComPwSpeed_1_path1_T_B_OP160	5000	4500	{}	decreasing	A1-P1	Y	2	12	2
138	InFan2SrvComPwSpeed_2_path1_T_B_OP160	5000	4500	{}	decreasing	A2-P1	Z	2	12	2
139	InFan2SrvComPwSpeed_3_path1_T_B_OP160	5000	4500	{}	decreasing	A3-P1	BA5	2	12	2
140	InFan2SrvComPwSpeed_4_path1_T_B_OP160	5000	4500	{}	decreasing	A4-P1	AM5	2	12	2
144	InFan1SpdlComPwSpeed_0_path1_T_B_OP160	5000	4500	{}	decreasing	A0-P1	SAS	2	7	2
145	InFan1SpindleAmpSpeed_0_path1_T_B_OP160	6200	6000	{}	decreasing	A1-P1	SCS	2	7	2
146	ServoTemp_0_path1_T_B_OP160	40	50	{}	increasing	A0-P1	X	13	3	2
147	ServoTemp_1_path1_T_B_OP160	86	108	{}	increasing	A1-P1	Y	13	3	2
148	ServoTemp_2_path1_T_B_OP160	48	60	{}	increasing	A2-P1	Z	13	3	2
149	ServoTemp_3_path1_T_B_OP160	40	50	{}	increasing	A3-P1	BA5	13	3	2
150	ServoTemp_4_path1_T_B_OP160	43	50	{}	increasing	A4-P1	AM5	13	3	2
154	SpindleTemp_0_path1_T_B_OP160	80	100	{}	increasing	SP-P1	SP	13	3	2
155	PulseCoderTemp_0_path1_T_B_OP180	48	60	{}	increasing	A0-P1	Z	13	4	3
156	PulseCoderTemp_1_path1_T_B_OP180	87	108	{}	increasing	A1-P1	AX2	13	4	3
157	PulseCoderTemp_2_path1_T_B_OP180	60	65	{}	increasing	A2-P1	AZ3	13	4	3
158	PulseCoderTemp_3_path1_T_B_OP180	60	60	{}	increasing	A3-P1	AC4	13	4	3
159	PulseCoderTemp_4_path1_T_B_OP180	60	60	{}	increasing	A4-P1	AM5	13	4	3
163	CncFan1Speed_path1_T_B_OP180	4500	4000	{}	decreasing	A0-P1	F1	16	6	3
164	CncFan2Speed_path1_T_B_OP180	9600	8600	{}	decreasing	A1-P1	F2	16	6	3
167	InFan1SrvAmpSpeed_0_path1_T_B_OP180	9500	9000	{}	decreasing	A0-P1	Z	2	8	3
168	InFan1SrvAmpSpeed_1_path1_T_B_OP180	9500	9000	{}	decreasing	A1-P1	AX2	2	8	3
169	InFan1SrvAmpSpeed_2_path1_T_B_OP180	9500	9000	{}	decreasing	A2-P1	AZ3	2	8	3
170	InFan1SrvAmpSpeed_3_path1_T_B_OP180	9500	9000	{}	decreasing	A3-P1	AC4	2	8	3
171	InFan1SrvAmpSpeed_4_path1_T_B_OP180	8500	7500	{}	decreasing	A4-P1	AM5	2	8	3
175	ServoLoad_0_path1_T_B_OP180	NaN	NaN	{}	increasing	A0-P1	Z	17	17	3
176	ServoLoad_1_path1_T_B_OP180	NaN	NaN	{}	increasing	A1-P1	AX2	17	17	3
177	ServoLoad_2_path1_T_B_OP180	NaN	NaN	{}	increasing	A2-P1	AZ3	17	17	3
178	ServoLoad_3_path1_T_B_OP180	NaN	NaN	{}	increasing	A3-P1	AC4	17	17	3
179	ServoLoad_4_path1_T_B_OP180	NaN	NaN	{}	increasing	A4-P1	AM5	17	17	3
183	SpindleLoad_0_path1_T_B_OP180	NaN	NaN	{}	increasing	SP-P1	SP	17	17	3
184	SpdBatZero_0_path1_T_B_OP180	NaN	NaN	{}	bool	A0-P1	Z	6	13	3
185	SpdBatZero_1_path1_T_B_OP180	NaN	NaN	{}	bool	A1-P1	AX2	6	13	3
186	SpdBatZero_2_path1_T_B_OP180	NaN	NaN	{}	bool	A2-P1	AZ3	6	13	3
187	SpdBatZero_3_path1_T_B_OP180	NaN	NaN	{}	bool	A3-P1	AC4	6	13	3
188	SpdBatZero_4_path1_T_B_OP180	NaN	NaN	{}	bool	A4-P1	AM5	6	13	3
192	SSpdBatZero_0_path1_T_B_OP180	NaN	NaN	{}	bool	A0-P1	Z	6	14	3
193	SSpdBatZero_1_path1_T_B_OP180	NaN	NaN	{}	bool	A1-P1	AX2	6	14	3
194	SSpdBatZero_2_path1_T_B_OP180	NaN	NaN	{}	bool	A2-P1	AZ3	6	14	3
195	SSpdBatZero_3_path1_T_B_OP180	NaN	NaN	{}	bool	A3-P1	AC4	6	14	3
196	SSpdBatZero_4_path1_T_B_OP180	NaN	NaN	{}	bool	A4-P1	AM5	6	14	3
200	RadFan2SpindleAmpSpeed_0_path1_T_B_OP180	5000	4500	{}	decreasing	SP-P1	SP	2	16	3
201	RadFan2SrvAmpSpeed_0_path1_T_B_OP180	5000	4500	{}	decreasing	A0-P1	Z	2	16	3
202	RadFan2SrvAmpSpeed_1_path1_T_B_OP180	5000	4500	{}	decreasing	A1-P1	AX2	2	16	3
203	RadFan2SrvAmpSpeed_2_path1_T_B_OP180	5000	4500	{}	decreasing	A2-P1	AZ3	2	16	3
204	RadFan2SrvAmpSpeed_3_path1_T_B_OP180	5000	4500	{}	decreasing	A3-P1	AC4	2	16	3
205	RadFan2SrvAmpSpeed_4_path1_T_B_OP180	5000	4500	{}	decreasing	A4-P1	AM5	2	16	3
209	ApcBatLow_0_path1_T_B_OP180	NaN	NaN	{}	bool	A0-P1	Z	6	1	3
210	ApcBatLow_1_path1_T_B_OP180	NaN	NaN	{}	bool	A1-P1	AX2	6	1	3
211	ApcBatLow_2_path1_T_B_OP180	NaN	NaN	{}	bool	A2-P1	AZ3	6	1	3
212	ApcBatLow_3_path1_T_B_OP180	NaN	NaN	{}	bool	A3-P1	AC4	6	1	3
213	ApcBatLow_4_path1_T_B_OP180	NaN	NaN	{}	bool	A4-P1	AM5	6	1	3
217	CncBatLow_0_path1_T_B_OP180	NaN	NaN	{}	bool	A0-P1	Z	6	2	3
218	CncBatLow_1_path1_T_B_OP180	NaN	NaN	{}	bool	A1-P1	AX2	6	2	3
219	CncBatLow_2_path1_T_B_OP180	NaN	NaN	{}	bool	A2-P1	AZ3	6	2	3
220	CncBatLow_3_path1_T_B_OP180	NaN	NaN	{}	bool	A3-P1	AC4	6	2	3
221	CncBatLow_4_path1_T_B_OP180	NaN	NaN	{}	bool	A4-P1	AM5	6	2	3
225	ServoLeakResistData_0_path1_T_B_OP180	50	30	{}	decreasing	A0-P1	Z	15	5	3
226	ServoLeakResistData_1_path1_T_B_OP180	50	30	{}	decreasing	A1-P1	AX2	15	5	3
227	ServoLeakResistData_2_path1_T_B_OP180	50	30	{}	decreasing	A2-P1	AZ3	15	5	3
228	ServoLeakResistData_3_path1_T_B_OP180	50	30	{}	decreasing	A3-P1	AC4	15	5	3
229	ServoLeakResistData_4_path1_T_B_OP180	50	30	{}	decreasing	A4-P1	AM5	15	5	3
233	SpindleLeakResistData_0_path1_T_B_OP180	50	30	{}	decreasing	SP-P1	SP	15	5	3
234	InFan1SrvComPwSpeed_0_path1_T_B_OP180	6200	6000	{}	decreasing	A0-P1	Z	2	9	3
235	InFan1SrvComPwSpeed_1_path1_T_B_OP180	6200	6000	{}	decreasing	A1-P1	AX2	2	9	3
236	InFan1SrvComPwSpeed_2_path1_T_B_OP180	6200	6000	{}	decreasing	A2-P1	AZ3	2	9	3
237	InFan1SrvComPwSpeed_3_path1_T_B_OP180	6200	6000	{}	decreasing	A3-P1	AC4	2	9	3
238	InFan1SrvComPwSpeed_4_path1_T_B_OP180	6200	6000	{}	decreasing	A4-P1	AM5	2	9	3
242	InFan2SrvAmpSpeed_0_path1_T_B_OP180	5000	4500	{}	decreasing	A0-P1	Z	2	11	3
243	InFan2SrvAmpSpeed_1_path1_T_B_OP180	5000	4500	{}	decreasing	A1-P1	AX2	2	11	3
244	InFan2SrvAmpSpeed_2_path1_T_B_OP180	5000	4500	{}	decreasing	A2-P1	AZ3	2	11	3
245	InFan2SrvAmpSpeed_3_path1_T_B_OP180	5000	4500	{}	decreasing	A3-P1	AC4	2	11	3
246	InFan2SrvAmpSpeed_4_path1_T_B_OP180	5000	4500	{}	decreasing	A4-P1	AM5	2	11	3
250	RadFan1SpindleAmpSpeed_0_path1_T_B_OP180	5000	4500	{}	decreasing	SP-P1	SP	2	15	3
251	RadFan1SrvAmpSpeed_0_path1_T_B_OP180	5000	4500	{}	decreasing	A0-P1	Z	2	15	3
252	RadFan1SrvAmpSpeed_1_path1_T_B_OP180	5000	4500	{}	decreasing	A1-P1	AX2	2	15	3
253	RadFan1SrvAmpSpeed_2_path1_T_B_OP180	5000	4500	{}	decreasing	A2-P1	AZ3	2	15	3
254	RadFan1SrvAmpSpeed_3_path1_T_B_OP180	5000	4500	{}	decreasing	A3-P1	AC4	2	15	3
255	RadFan1SrvAmpSpeed_4_path1_T_B_OP180	5000	4500	{}	decreasing	A4-P1	AM5	2	15	3
259	InFan2SpdlComPwSpeed_0_path1_T_B_OP180	5000	4500	{}	decreasing	A0-P1	Z	2	10	3
260	InFan2SpindleAmpSpeed_0_path1_T_B_OP180	5000	4500	{}	decreasing	A1-P1	AX2	2	10	3
261	InFan2SrvComPwSpeed_0_path1_T_B_OP180	5000	4500	{}	decreasing	A0-P1	Z	2	12	3
262	InFan2SrvComPwSpeed_1_path1_T_B_OP180	5000	4500	{}	decreasing	A1-P1	AX2	2	12	3
263	InFan2SrvComPwSpeed_2_path1_T_B_OP180	5000	4500	{}	decreasing	A2-P1	AZ3	2	12	3
264	InFan2SrvComPwSpeed_3_path1_T_B_OP180	5000	4500	{}	decreasing	A3-P1	AC4	2	12	3
265	InFan2SrvComPwSpeed_4_path1_T_B_OP180	5000	4500	{}	decreasing	A4-P1	AM5	2	12	3
269	InFan1SpdlComPwSpeed_0_path1_T_B_OP180	5000	4500	{}	decreasing	A0-P1	Z	2	7	3
270	InFan1SpindleAmpSpeed_0_path1_T_B_OP180	6200	6000	{}	decreasing	A1-P1	AX2	2	7	3
271	ServoTemp_0_path1_T_B_OP180	40	50	{}	increasing	A0-P1	Z	13	3	3
272	ServoTemp_1_path1_T_B_OP180	86	108	{}	increasing	A1-P1	AX2	13	3	3
273	ServoTemp_2_path1_T_B_OP180	48	60	{}	increasing	A2-P1	AZ3	13	3	3
274	ServoTemp_3_path1_T_B_OP180	40	50	{}	increasing	A3-P1	AC4	13	3	3
275	ServoTemp_4_path1_T_B_OP180	36	45	{}	increasing	A4-P1	AM5	13	3	3
279	SpindleTemp_0_path1_T_B_OP180	80	100	{}	increasing	SP-P1	SP	13	3	3
280	PulseCoderTemp_0_path1_T_B_OP195A	55	65	{}	increasing	A0-P1	X	13	4	4
281	PulseCoderTemp_1_path1_T_B_OP195A	92	108	{}	increasing	A1-P1	Y	13	4	4
282	PulseCoderTemp_2_path1_T_B_OP195A	80	100	{}	increasing	A2-P1	Z	13	4	4
6283	feeder_q1_data_table	\N	\N	{}	\N	\N	\N	4	\N	64
283	PulseCoderTemp_3_path1_T_B_OP195A	60	60	{}	increasing	A3-P1	BA5	13	4	4
284	PulseCoderTemp_4_path1_T_B_OP195A	55	60	{}	increasing	A4-P1	AM5	13	4	4
288	CncFan1Speed_path1_T_B_OP195A	4500	4000	{}	decreasing	A0-P1	F1	16	6	4
289	CncFan2Speed_path1_T_B_OP195A	9600	8600	{}	decreasing	A1-P1	F2	16	6	4
292	InFan1SrvAmpSpeed_0_path1_T_B_OP195A	9500	9000	{}	decreasing	A0-P1	X	2	8	4
293	InFan1SrvAmpSpeed_1_path1_T_B_OP195A	9500	9000	{}	decreasing	A1-P1	Y	2	8	4
294	InFan1SrvAmpSpeed_2_path1_T_B_OP195A	9500	9000	{}	decreasing	A2-P1	Z	2	8	4
295	InFan1SrvAmpSpeed_3_path1_T_B_OP195A	9500	9000	{}	decreasing	A3-P1	BA5	2	8	4
296	InFan1SrvAmpSpeed_4_path1_T_B_OP195A	8500	7500	{}	decreasing	A4-P1	AM5	2	8	4
300	ServoLoad_0_path1_T_B_OP195A	NaN	NaN	{}	increasing	A0-P1	X	17	17	4
301	ServoLoad_1_path1_T_B_OP195A	NaN	NaN	{}	increasing	A1-P1	Y	17	17	4
302	ServoLoad_2_path1_T_B_OP195A	NaN	NaN	{}	increasing	A2-P1	Z	17	17	4
303	ServoLoad_3_path1_T_B_OP195A	NaN	NaN	{}	increasing	A3-P1	BA5	17	17	4
304	ServoLoad_4_path1_T_B_OP195A	NaN	NaN	{}	increasing	A4-P1	AM5	17	17	4
308	SpindleLoad_0_path1_T_B_OP195A	NaN	NaN	{}	increasing	SP-P1	SP	17	17	4
309	SpdBatZero_0_path1_T_B_OP195A	NaN	NaN	{}	bool	A0-P1	X	6	13	4
310	SpdBatZero_1_path1_T_B_OP195A	NaN	NaN	{}	bool	A1-P1	Y	6	13	4
311	SpdBatZero_2_path1_T_B_OP195A	NaN	NaN	{}	bool	A2-P1	Z	6	13	4
312	SpdBatZero_3_path1_T_B_OP195A	NaN	NaN	{}	bool	A3-P1	BA5	6	13	4
313	SpdBatZero_4_path1_T_B_OP195A	NaN	NaN	{}	bool	A4-P1	AM5	6	13	4
317	SSpdBatZero_0_path1_T_B_OP195A	NaN	NaN	{}	bool	A0-P1	X	6	14	4
318	SSpdBatZero_1_path1_T_B_OP195A	NaN	NaN	{}	bool	A1-P1	Y	6	14	4
319	SSpdBatZero_2_path1_T_B_OP195A	NaN	NaN	{}	bool	A2-P1	Z	6	14	4
320	SSpdBatZero_3_path1_T_B_OP195A	NaN	NaN	{}	bool	A3-P1	BA5	6	14	4
321	SSpdBatZero_4_path1_T_B_OP195A	NaN	NaN	{}	bool	A4-P1	AM5	6	14	4
325	RadFan2SpindleAmpSpeed_0_path1_T_B_OP195A	5000	4500	{}	decreasing	SP-P1	SP	2	16	4
326	RadFan2SrvAmpSpeed_0_path1_T_B_OP195A	5000	4500	{}	decreasing	A0-P1	X	2	16	4
327	RadFan2SrvAmpSpeed_1_path1_T_B_OP195A	5000	4500	{}	decreasing	A1-P1	Y	2	16	4
328	RadFan2SrvAmpSpeed_2_path1_T_B_OP195A	5000	4500	{}	decreasing	A2-P1	Z	2	16	4
329	RadFan2SrvAmpSpeed_3_path1_T_B_OP195A	5000	4500	{}	decreasing	A3-P1	BA5	2	16	4
330	RadFan2SrvAmpSpeed_4_path1_T_B_OP195A	5000	4500	{}	decreasing	A4-P1	AM5	2	16	4
334	ApcBatLow_0_path1_T_B_OP195A	NaN	NaN	{}	bool	A0-P1	X	6	1	4
335	ApcBatLow_1_path1_T_B_OP195A	NaN	NaN	{}	bool	A1-P1	Y	6	1	4
336	ApcBatLow_2_path1_T_B_OP195A	NaN	NaN	{}	bool	A2-P1	Z	6	1	4
337	ApcBatLow_3_path1_T_B_OP195A	NaN	NaN	{}	bool	A3-P1	BA5	6	1	4
338	ApcBatLow_4_path1_T_B_OP195A	NaN	NaN	{}	bool	A4-P1	AM5	6	1	4
342	CncBatLow_0_path1_T_B_OP195A	NaN	NaN	{}	bool	A0-P1	X	6	2	4
343	CncBatLow_1_path1_T_B_OP195A	NaN	NaN	{}	bool	A1-P1	Y	6	2	4
344	CncBatLow_2_path1_T_B_OP195A	NaN	NaN	{}	bool	A2-P1	Z	6	2	4
345	CncBatLow_3_path1_T_B_OP195A	NaN	NaN	{}	bool	A3-P1	BA5	6	2	4
346	CncBatLow_4_path1_T_B_OP195A	NaN	NaN	{}	bool	A4-P1	AM5	6	2	4
350	ServoLeakResistData_0_path1_T_B_OP195A	50	30	{}	decreasing	A0-P1	X	15	5	4
351	ServoLeakResistData_1_path1_T_B_OP195A	90	75	{}	decreasing	A1-P1	Y	15	5	4
352	ServoLeakResistData_2_path1_T_B_OP195A	50	30	{}	decreasing	A2-P1	Z	15	5	4
354	ServoLeakResistData_4_path1_T_B_OP195A	50	30	{}	decreasing	A4-P1	AM5	15	5	4
358	SpindleLeakResistData_0_path1_T_B_OP195A	50	30	{}	decreasing	SP-P1	SP	15	5	4
359	InFan1SrvComPwSpeed_0_path1_T_B_OP195A	6200	6000	{}	decreasing	A0-P1	X	2	9	4
360	InFan1SrvComPwSpeed_1_path1_T_B_OP195A	6200	6000	{}	decreasing	A1-P1	Y	2	9	4
361	InFan1SrvComPwSpeed_2_path1_T_B_OP195A	6200	6000	{}	decreasing	A2-P1	Z	2	9	4
362	InFan1SrvComPwSpeed_3_path1_T_B_OP195A	6200	6000	{}	decreasing	A3-P1	BA5	2	9	4
363	InFan1SrvComPwSpeed_4_path1_T_B_OP195A	6200	6000	{}	decreasing	A4-P1	AM5	2	9	4
367	InFan2SrvAmpSpeed_0_path1_T_B_OP195A	5000	4500	{}	decreasing	A0-P1	X	2	11	4
368	InFan2SrvAmpSpeed_1_path1_T_B_OP195A	5000	4500	{}	decreasing	A1-P1	Y	2	11	4
369	InFan2SrvAmpSpeed_2_path1_T_B_OP195A	5000	4500	{}	decreasing	A2-P1	Z	2	11	4
370	InFan2SrvAmpSpeed_3_path1_T_B_OP195A	5000	4500	{}	decreasing	A3-P1	BA5	2	11	4
371	InFan2SrvAmpSpeed_4_path1_T_B_OP195A	5000	4500	{}	decreasing	A4-P1	AM5	2	11	4
375	RadFan1SpindleAmpSpeed_0_path1_T_B_OP195A	5000	4500	{}	decreasing	SP-P1	SP	2	15	4
376	RadFan1SrvAmpSpeed_0_path1_T_B_OP195A	5000	4500	{}	decreasing	A0-P1	X	2	15	4
377	RadFan1SrvAmpSpeed_1_path1_T_B_OP195A	5000	4500	{}	decreasing	A1-P1	Y	2	15	4
378	RadFan1SrvAmpSpeed_2_path1_T_B_OP195A	5000	4500	{}	decreasing	A2-P1	Z	2	15	4
379	RadFan1SrvAmpSpeed_3_path1_T_B_OP195A	5000	4500	{}	decreasing	A3-P1	BA5	2	15	4
380	RadFan1SrvAmpSpeed_4_path1_T_B_OP195A	5000	4500	{}	decreasing	A4-P1	AM5	2	15	4
384	InFan2SpdlComPwSpeed_0_path1_T_B_OP195A	5000	4500	{}	decreasing	A0-P1	X	2	10	4
385	InFan2SpindleAmpSpeed_0_path1_T_B_OP195A	5000	4500	{}	decreasing	A1-P1	Y	2	10	4
386	InFan2SrvComPwSpeed_0_path1_T_B_OP195A	5000	4500	{}	decreasing	A0-P1	X	2	12	4
387	InFan2SrvComPwSpeed_1_path1_T_B_OP195A	5000	4500	{}	decreasing	A1-P1	Y	2	12	4
388	InFan2SrvComPwSpeed_2_path1_T_B_OP195A	5000	4500	{}	decreasing	A2-P1	Z	2	12	4
389	InFan2SrvComPwSpeed_3_path1_T_B_OP195A	5000	4500	{}	decreasing	A3-P1	BA5	2	12	4
390	InFan2SrvComPwSpeed_4_path1_T_B_OP195A	5000	4500	{}	decreasing	A4-P1	AM5	2	12	4
394	InFan1SpdlComPwSpeed_0_path1_T_B_OP195A	5000	4500	{}	decreasing	A0-P1	X	2	7	4
395	InFan1SpindleAmpSpeed_0_path1_T_B_OP195A	6200	6000	{}	decreasing	A1-P1	Y	2	7	4
396	ServoTemp_0_path1_T_B_OP195A	50	60	{}	increasing	A0-P1	X	13	3	4
397	ServoTemp_1_path1_T_B_OP195A	100	108	{}	increasing	A1-P1	Y	13	3	4
398	ServoTemp_2_path1_T_B_OP195A	55	60	{}	increasing	A2-P1	Z	13	3	4
399	ServoTemp_3_path1_T_B_OP195A	48	55	{}	increasing	A3-P1	BA5	13	3	4
400	ServoTemp_4_path1_T_B_OP195A	43	50	{}	increasing	A4-P1	AM5	13	3	4
404	SpindleTemp_0_path1_T_B_OP195A	80	100	{}	increasing	SP-P1	SP	13	3	4
405	PulseCoderTemp_0_path1_T_B_OP195B	55	65	{}	increasing	A0-P1	X	13	4	5
406	PulseCoderTemp_1_path1_T_B_OP195B	95	108	{}	increasing	A1-P1	Y	13	4	5
408	PulseCoderTemp_3_path1_T_B_OP195B	60	60	{}	increasing	A3-P1	BA5	13	4	5
413	CncFan1Speed_path1_T_B_OP195B	4500	4000	{}	decreasing	A0-P1	F1	16	6	5
414	CncFan2Speed_path1_T_B_OP195B	9600	8600	{}	decreasing	A1-P1	F2	16	6	5
417	InFan1SrvAmpSpeed_0_path1_T_B_OP195B	9500	9000	{}	decreasing	A0-P1	X	2	8	5
418	InFan1SrvAmpSpeed_1_path1_T_B_OP195B	9500	9000	{}	decreasing	A1-P1	Y	2	8	5
419	InFan1SrvAmpSpeed_2_path1_T_B_OP195B	9500	9000	{}	decreasing	A2-P1	Z	2	8	5
420	InFan1SrvAmpSpeed_3_path1_T_B_OP195B	9500	9000	{}	decreasing	A3-P1	BA5	2	8	5
421	InFan1SrvAmpSpeed_4_path1_T_B_OP195B	8500	7500	{}	decreasing	A4-P1	AM5	2	8	5
425	ServoLoad_0_path1_T_B_OP195B	NaN	NaN	{}	increasing	A0-P1	X	17	17	5
426	ServoLoad_1_path1_T_B_OP195B	NaN	NaN	{}	increasing	A1-P1	Y	17	17	5
427	ServoLoad_2_path1_T_B_OP195B	NaN	NaN	{}	increasing	A2-P1	Z	17	17	5
428	ServoLoad_3_path1_T_B_OP195B	NaN	NaN	{}	increasing	A3-P1	BA5	17	17	5
429	ServoLoad_4_path1_T_B_OP195B	NaN	NaN	{}	increasing	A4-P1	AM5	17	17	5
433	SpindleLoad_0_path1_T_B_OP195B	NaN	NaN	{}	increasing	SP-P1	SP	17	17	5
434	SpdBatZero_0_path1_T_B_OP195B	NaN	NaN	{}	bool	A0-P1	X	6	13	5
435	SpdBatZero_1_path1_T_B_OP195B	NaN	NaN	{}	bool	A1-P1	Y	6	13	5
436	SpdBatZero_2_path1_T_B_OP195B	NaN	NaN	{}	bool	A2-P1	Z	6	13	5
437	SpdBatZero_3_path1_T_B_OP195B	NaN	NaN	{}	bool	A3-P1	BA5	6	13	5
438	SpdBatZero_4_path1_T_B_OP195B	NaN	NaN	{}	bool	A4-P1	AM5	6	13	5
442	SSpdBatZero_0_path1_T_B_OP195B	NaN	NaN	{}	bool	A0-P1	X	6	14	5
443	SSpdBatZero_1_path1_T_B_OP195B	NaN	NaN	{}	bool	A1-P1	Y	6	14	5
444	SSpdBatZero_2_path1_T_B_OP195B	NaN	NaN	{}	bool	A2-P1	Z	6	14	5
445	SSpdBatZero_3_path1_T_B_OP195B	NaN	NaN	{}	bool	A3-P1	BA5	6	14	5
446	SSpdBatZero_4_path1_T_B_OP195B	NaN	NaN	{}	bool	A4-P1	AM5	6	14	5
450	RadFan2SpindleAmpSpeed_0_path1_T_B_OP195B	5000	4500	{}	decreasing	SP-P1	SP	2	16	5
451	RadFan2SrvAmpSpeed_0_path1_T_B_OP195B	5000	4500	{}	decreasing	A0-P1	X	2	16	5
452	RadFan2SrvAmpSpeed_1_path1_T_B_OP195B	5000	4500	{}	decreasing	A1-P1	Y	2	16	5
453	RadFan2SrvAmpSpeed_2_path1_T_B_OP195B	5000	4500	{}	decreasing	A2-P1	Z	2	16	5
454	RadFan2SrvAmpSpeed_3_path1_T_B_OP195B	5000	4500	{}	decreasing	A3-P1	BA5	2	16	5
455	RadFan2SrvAmpSpeed_4_path1_T_B_OP195B	5000	4500	{}	decreasing	A4-P1	AM5	2	16	5
459	ApcBatLow_0_path1_T_B_OP195B	NaN	NaN	{}	bool	A0-P1	X	6	1	5
460	ApcBatLow_1_path1_T_B_OP195B	NaN	NaN	{}	bool	A1-P1	Y	6	1	5
461	ApcBatLow_2_path1_T_B_OP195B	NaN	NaN	{}	bool	A2-P1	Z	6	1	5
462	ApcBatLow_3_path1_T_B_OP195B	NaN	NaN	{}	bool	A3-P1	BA5	6	1	5
463	ApcBatLow_4_path1_T_B_OP195B	NaN	NaN	{}	bool	A4-P1	AM5	6	1	5
467	CncBatLow_0_path1_T_B_OP195B	NaN	NaN	{}	bool	A0-P1	X	6	2	5
468	CncBatLow_1_path1_T_B_OP195B	NaN	NaN	{}	bool	A1-P1	Y	6	2	5
469	CncBatLow_2_path1_T_B_OP195B	NaN	NaN	{}	bool	A2-P1	Z	6	2	5
470	CncBatLow_3_path1_T_B_OP195B	NaN	NaN	{}	bool	A3-P1	BA5	6	2	5
471	CncBatLow_4_path1_T_B_OP195B	NaN	NaN	{}	bool	A4-P1	AM5	6	2	5
6284	feeder_q2_data_table	\N	\N	{}	\N	\N	\N	4	\N	64
409	PulseCoderTemp_4_path1_T_B_OP195B	50	60	{}	increasing	A4-P1	AM5	13	4	5
475	ServoLeakResistData_0_path1_T_B_OP195B	50	30	{}	decreasing	A0-P1	X	15	5	5
477	ServoLeakResistData_2_path1_T_B_OP195B	50	30	{}	decreasing	A2-P1	Z	15	5	5
478	ServoLeakResistData_3_path1_T_B_OP195B	50	30	{}	decreasing	A3-P1	BA5	15	5	5
479	ServoLeakResistData_4_path1_T_B_OP195B	50	30	{}	decreasing	A4-P1	AM5	15	5	5
483	SpindleLeakResistData_0_path1_T_B_OP195B	50	30	{}	decreasing	SP-P1	SP	15	5	5
484	InFan1SrvComPwSpeed_0_path1_T_B_OP195B	6200	6000	{}	decreasing	A0-P1	X	2	9	5
485	InFan1SrvComPwSpeed_1_path1_T_B_OP195B	6200	6000	{}	decreasing	A1-P1	Y	2	9	5
486	InFan1SrvComPwSpeed_2_path1_T_B_OP195B	6200	6000	{}	decreasing	A2-P1	Z	2	9	5
487	InFan1SrvComPwSpeed_3_path1_T_B_OP195B	6200	6000	{}	decreasing	A3-P1	BA5	2	9	5
488	InFan1SrvComPwSpeed_4_path1_T_B_OP195B	6200	6000	{}	decreasing	A4-P1	AM5	2	9	5
492	InFan2SrvAmpSpeed_0_path1_T_B_OP195B	5000	4500	{}	decreasing	A0-P1	X	2	11	5
493	InFan2SrvAmpSpeed_1_path1_T_B_OP195B	5000	4500	{}	decreasing	A1-P1	Y	2	11	5
494	InFan2SrvAmpSpeed_2_path1_T_B_OP195B	5000	4500	{}	decreasing	A2-P1	Z	2	11	5
495	InFan2SrvAmpSpeed_3_path1_T_B_OP195B	5000	4500	{}	decreasing	A3-P1	BA5	2	11	5
496	InFan2SrvAmpSpeed_4_path1_T_B_OP195B	5000	4500	{}	decreasing	A4-P1	AM5	2	11	5
500	RadFan1SpindleAmpSpeed_0_path1_T_B_OP195B	5000	4500	{}	decreasing	SP-P1	SP	2	15	5
501	RadFan1SrvAmpSpeed_0_path1_T_B_OP195B	5000	4500	{}	decreasing	A0-P1	X	2	15	5
502	RadFan1SrvAmpSpeed_1_path1_T_B_OP195B	5000	4500	{}	decreasing	A1-P1	Y	2	15	5
503	RadFan1SrvAmpSpeed_2_path1_T_B_OP195B	5000	4500	{}	decreasing	A2-P1	Z	2	15	5
504	RadFan1SrvAmpSpeed_3_path1_T_B_OP195B	5000	4500	{}	decreasing	A3-P1	BA5	2	15	5
505	RadFan1SrvAmpSpeed_4_path1_T_B_OP195B	5000	4500	{}	decreasing	A4-P1	AM5	2	15	5
509	InFan2SpdlComPwSpeed_0_path1_T_B_OP195B	5000	4500	{}	decreasing	A0-P1	X	2	10	5
510	InFan2SpindleAmpSpeed_0_path1_T_B_OP195B	5000	4500	{}	decreasing	A1-P1	Y	2	10	5
511	InFan2SrvComPwSpeed_0_path1_T_B_OP195B	5000	4500	{}	decreasing	A0-P1	X	2	12	5
512	InFan2SrvComPwSpeed_1_path1_T_B_OP195B	5000	4500	{}	decreasing	A1-P1	Y	2	12	5
513	InFan2SrvComPwSpeed_2_path1_T_B_OP195B	5000	4500	{}	decreasing	A2-P1	Z	2	12	5
514	InFan2SrvComPwSpeed_3_path1_T_B_OP195B	5000	4500	{}	decreasing	A3-P1	BA5	2	12	5
515	InFan2SrvComPwSpeed_4_path1_T_B_OP195B	5000	4500	{}	decreasing	A4-P1	AM5	2	12	5
519	InFan1SpdlComPwSpeed_0_path1_T_B_OP195B	5000	4500	{}	decreasing	A0-P1	X	2	7	5
520	InFan1SpindleAmpSpeed_0_path1_T_B_OP195B	6200	6000	{}	decreasing	A1-P1	Y	2	7	5
521	ServoTemp_0_path1_T_B_OP195B	45	55	{}	increasing	A0-P1	X	13	3	5
522	ServoTemp_1_path1_T_B_OP195B	95	108	{}	increasing	A1-P1	Y	13	3	5
523	ServoTemp_2_path1_T_B_OP195B	55	60	{}	increasing	A2-P1	Z	13	3	5
524	ServoTemp_3_path1_T_B_OP195B	48	55	{}	increasing	A3-P1	BA5	13	3	5
525	ServoTemp_4_path1_T_B_OP195B	45	55	{}	increasing	A4-P1	AM5	13	3	5
529	SpindleTemp_0_path1_T_B_OP195B	80	100	{}	increasing	SP-P1	SP	13	3	5
530	PulseCoderTemp_0_path1_T_B_OP230	65	80	{}	increasing	A0-P1	X	13	4	6
531	PulseCoderTemp_1_path1_T_B_OP230	87	108	{}	increasing	A1-P1	Y1	13	4	6
532	PulseCoderTemp_2_path1_T_B_OP230	90	95	{}	increasing	A2-P1	Y2	13	4	6
533	PulseCoderTemp_3_path1_T_B_OP230	70	80	{}	increasing	A3-P1	Z1	13	4	6
535	PulseCoderTemp_5_path1_T_B_OP230	60	80	{}	increasing	A5-P1	B1	13	4	6
536	PulseCoderTemp_6_path1_T_B_OP230	60	80	{}	increasing	A6-P1	B2	13	4	6
538	CncFan1Speed_path1_T_B_OP230	4500	4000	{}	decreasing	A1-P1	F1	16	6	6
539	CncFan2Speed_path1_T_B_OP230	9600	8600	{}	decreasing	A2-P1	F3	16	6	6
542	InFan1SrvAmpSpeed_0_path1_T_B_OP230	9500	9000	{}	decreasing	A0-P1	X	2	8	6
543	InFan1SrvAmpSpeed_1_path1_T_B_OP230	9500	9000	{}	decreasing	A1-P1	Y1	2	8	6
544	InFan1SrvAmpSpeed_2_path1_T_B_OP230	9500	9000	{}	decreasing	A2-P1	Y2	2	8	6
545	InFan1SrvAmpSpeed_3_path1_T_B_OP230	9500	9000	{}	decreasing	A3-P1	Z1	2	8	6
547	InFan1SrvAmpSpeed_5_path1_T_B_OP230	8500	7500	{}	decreasing	A5-P1	B1	2	8	6
548	InFan1SrvAmpSpeed_6_path1_T_B_OP230	9500	9000	{}	decreasing	A6-P1	B2	2	8	6
550	ServoLoad_0_path1_T_B_OP230	NaN	NaN	{}	increasing	A0-P1	X	17	17	6
551	ServoLoad_1_path1_T_B_OP230	NaN	NaN	{}	increasing	A1-P1	Y1	17	17	6
552	ServoLoad_2_path1_T_B_OP230	NaN	NaN	{}	increasing	A2-P1	Y2	17	17	6
553	ServoLoad_3_path1_T_B_OP230	NaN	NaN	{}	increasing	A3-P1	Z1	17	17	6
555	ServoLoad_5_path1_T_B_OP230	NaN	NaN	{}	increasing	A5-P1	B1	17	17	6
556	ServoLoad_6_path1_T_B_OP230	NaN	NaN	{}	increasing	A6-P1	B2	17	17	6
559	SpdBatZero_0_path1_T_B_OP230	NaN	NaN	{}	bool	A0-P1	X	6	13	6
560	SpdBatZero_1_path1_T_B_OP230	NaN	NaN	{}	bool	A1-P1	Y1	6	13	6
561	SpdBatZero_2_path1_T_B_OP230	NaN	NaN	{}	bool	A2-P1	Y2	6	13	6
562	SpdBatZero_3_path1_T_B_OP230	NaN	NaN	{}	bool	A3-P1	Z1	6	13	6
564	SpdBatZero_5_path1_T_B_OP230	NaN	NaN	{}	bool	A5-P1	B1	6	13	6
565	SpdBatZero_6_path1_T_B_OP230	NaN	NaN	{}	bool	A6-P1	B2	6	13	6
567	SSpdBatZero_0_path1_T_B_OP230	NaN	NaN	{}	bool	A0-P1	X	6	14	6
568	SSpdBatZero_1_path1_T_B_OP230	NaN	NaN	{}	bool	A1-P1	Y1	6	14	6
569	SSpdBatZero_2_path1_T_B_OP230	NaN	NaN	{}	bool	A2-P1	Y2	6	14	6
570	SSpdBatZero_3_path1_T_B_OP230	NaN	NaN	{}	bool	A3-P1	Z1	6	14	6
572	SSpdBatZero_5_path1_T_B_OP230	NaN	NaN	{}	bool	A5-P1	B1	6	14	6
573	SSpdBatZero_6_path1_T_B_OP230	NaN	NaN	{}	bool	A6-P1	B2	6	14	6
576	RadFan2SrvAmpSpeed_0_path1_T_B_OP230	5000	4500	{}	decreasing	A0-P1	X	2	16	6
577	RadFan2SrvAmpSpeed_1_path1_T_B_OP230	5000	4500	{}	decreasing	A1-P1	Y1	2	16	6
578	RadFan2SrvAmpSpeed_2_path1_T_B_OP230	5000	4500	{}	decreasing	A2-P1	Y2	2	16	6
579	RadFan2SrvAmpSpeed_3_path1_T_B_OP230	5000	4500	{}	decreasing	A3-P1	Z1	2	16	6
581	RadFan2SrvAmpSpeed_5_path1_T_B_OP230	5000	4500	{}	decreasing	A5-P1	B1	2	16	6
582	RadFan2SrvAmpSpeed_6_path1_T_B_OP230	5000	4500	{}	decreasing	A6-P1	B2	2	16	6
584	ApcBatLow_0_path1_T_B_OP230	NaN	NaN	{}	bool	A0-P1	X	6	1	6
585	ApcBatLow_1_path1_T_B_OP230	NaN	NaN	{}	bool	A1-P1	Y1	6	1	6
586	ApcBatLow_2_path1_T_B_OP230	NaN	NaN	{}	bool	A2-P1	Y2	6	1	6
587	ApcBatLow_3_path1_T_B_OP230	NaN	NaN	{}	bool	A3-P1	Z1	6	1	6
589	ApcBatLow_5_path1_T_B_OP230	NaN	NaN	{}	bool	A5-P1	B1	6	1	6
590	ApcBatLow_6_path1_T_B_OP230	NaN	NaN	{}	bool	A6-P1	B2	6	1	6
592	CncBatLow_0_path1_T_B_OP230	NaN	NaN	{}	bool	A0-P1	X	6	2	6
593	CncBatLow_1_path1_T_B_OP230	NaN	NaN	{}	bool	A1-P1	Y1	6	2	6
594	CncBatLow_2_path1_T_B_OP230	NaN	NaN	{}	bool	A2-P1	Y2	6	2	6
595	CncBatLow_3_path1_T_B_OP230	NaN	NaN	{}	bool	A3-P1	Z1	6	2	6
597	CncBatLow_5_path1_T_B_OP230	NaN	NaN	{}	bool	A5-P1	B1	6	2	6
598	CncBatLow_6_path1_T_B_OP230	NaN	NaN	{}	bool	A6-P1	B2	6	2	6
601	ServoLeakResistData_1_path1_T_B_OP230	50	30	{}	decreasing	A1-P1	Y1	15	5	6
602	ServoLeakResistData_2_path1_T_B_OP230	50	30	{}	decreasing	A2-P1	Y2	15	5	6
606	ServoLeakResistData_6_path1_T_B_OP230	50	30	{}	decreasing	A6-P1	B2	15	5	6
609	InFan1SrvComPwSpeed_0_path1_T_B_OP230	6200	6000	{}	decreasing	A0-P1	X	2	9	6
610	InFan1SrvComPwSpeed_1_path1_T_B_OP230	6200	6000	{}	decreasing	A1-P1	Y1	2	9	6
611	InFan1SrvComPwSpeed_2_path1_T_B_OP230	6200	6000	{}	decreasing	A2-P1	Y2	2	9	6
612	InFan1SrvComPwSpeed_3_path1_T_B_OP230	6200	6000	{}	decreasing	A3-P1	Z1	2	9	6
614	InFan1SrvComPwSpeed_5_path1_T_B_OP230	6200	6000	{}	decreasing	A5-P1	B1	2	9	6
615	InFan1SrvComPwSpeed_6_path1_T_B_OP230	6200	6000	{}	decreasing	A6-P1	B2	2	9	6
617	InFan2SrvAmpSpeed_0_path1_T_B_OP230	5000	4500	{}	decreasing	A0-P1	X	2	11	6
618	InFan2SrvAmpSpeed_1_path1_T_B_OP230	5000	4500	{}	decreasing	A1-P1	Y1	2	11	6
619	InFan2SrvAmpSpeed_2_path1_T_B_OP230	5000	4500	{}	decreasing	A2-P1	Y2	2	11	6
620	InFan2SrvAmpSpeed_3_path1_T_B_OP230	5000	4500	{}	decreasing	A3-P1	Z1	2	11	6
622	InFan2SrvAmpSpeed_5_path1_T_B_OP230	5000	4500	{}	decreasing	A5-P1	B1	2	11	6
623	InFan2SrvAmpSpeed_6_path1_T_B_OP230	5000	4500	{}	decreasing	A6-P1	B2	2	11	6
626	RadFan1SrvAmpSpeed_0_path1_T_B_OP230	5000	4500	{}	decreasing	A0-P1	X	2	15	6
627	RadFan1SrvAmpSpeed_1_path1_T_B_OP230	5000	4500	{}	decreasing	A1-P1	Y1	2	15	6
628	RadFan1SrvAmpSpeed_2_path1_T_B_OP230	5000	4500	{}	decreasing	A2-P1	Y2	2	15	6
629	RadFan1SrvAmpSpeed_3_path1_T_B_OP230	5000	4500	{}	decreasing	A3-P1	Z1	2	15	6
631	RadFan1SrvAmpSpeed_5_path1_T_B_OP230	5000	4500	{}	decreasing	A5-P1	B1	2	15	6
632	RadFan1SrvAmpSpeed_6_path1_T_B_OP230	5000	4500	{}	decreasing	A6-P1	B2	2	15	6
634	InFan2SpdlComPwSpeed_0_path1_T_B_OP230	5000	4500	{}	decreasing	A0-P1	X	2	10	6
635	InFan2SpindleAmpSpeed_0_path1_T_B_OP230	5000	4500	{}	decreasing	SP-P1	SP	2	10	6
636	InFan2SrvComPwSpeed_0_path1_T_B_OP230	5000	4500	{}	decreasing	A0-P1	X	2	12	6
637	InFan2SrvComPwSpeed_1_path1_T_B_OP230	5000	4500	{}	decreasing	A1-P1	Y1	2	12	6
638	InFan2SrvComPwSpeed_2_path1_T_B_OP230	5000	4500	{}	decreasing	A2-P1	Y2	2	12	6
639	InFan2SrvComPwSpeed_3_path1_T_B_OP230	5000	4500	{}	decreasing	A3-P1	Z1	2	12	6
641	InFan2SrvComPwSpeed_5_path1_T_B_OP230	5000	4500	{}	decreasing	A5-P1	B1	2	12	6
642	InFan2SrvComPwSpeed_6_path1_T_B_OP230	5000	4500	{}	decreasing	A6-P1	B2	2	12	6
644	InFan1SpdlComPwSpeed_0_path1_T_B_OP230	5000	4500	{}	decreasing	A0-P1	X	2	7	6
645	InFan1SpindleAmpSpeed_0_path1_T_B_OP230	5000	4500	{}	decreasing	SP-P1	SP	2	7	6
6285	feeder_q3_data_table	\N	\N	{}	\N	\N	\N	4	\N	64
603	ServoLeakResistData_3_path1_T_B_OP230	100	30	{}	decreasing	A3-P1	Z1	15	5	6
600	ServoLeakResistData_0_path1_T_B_OP230	140	30	{}	decreasing	A0-P1	X	15	5	6
646	ServoTemp_0_path1_T_B_OP230	40	50	{}	increasing	A0-P1	X	13	3	6
647	ServoTemp_1_path1_T_B_OP230	86	108	{}	increasing	A1-P1	Y1	13	3	6
648	ServoTemp_2_path1_T_B_OP230	48	60	{}	increasing	A2-P1	Y2	13	3	6
651	ServoTemp_5_path1_T_B_OP230	55	70	{}	increasing	A5-P1	B1	13	3	6
652	ServoTemp_6_path1_T_B_OP230	55	70	{}	increasing	A6-P1	B2	13	3	6
655	PulseCoderTemp_0_path1_T_B_OP235	55	65	{}	increasing	A0-P1	X	13	4	7
656	PulseCoderTemp_1_path1_T_B_OP235	87	108	{}	increasing	A1-P1	Y1	13	4	7
657	PulseCoderTemp_2_path1_T_B_OP235	75	85	{}	increasing	A2-P1	Y2	13	4	7
663	CncFan1Speed_path1_T_B_OP235	4500	4000	{}	decreasing	A1-P1	F1	16	6	7
664	CncFan2Speed_path1_T_B_OP235	9600	8600	{}	decreasing	A2-P1	F3	16	6	7
667	InFan1SrvAmpSpeed_0_path1_T_B_OP235	9500	9000	{}	decreasing	A0-P1	X	2	8	7
668	InFan1SrvAmpSpeed_1_path1_T_B_OP235	9500	9000	{}	decreasing	A1-P1	Y1	2	8	7
669	InFan1SrvAmpSpeed_2_path1_T_B_OP235	9500	9000	{}	decreasing	A2-P1	Y2	2	8	7
675	ServoLoad_0_path1_T_B_OP235	NaN	NaN	{}	increasing	A0-P1	X	17	17	7
676	ServoLoad_1_path1_T_B_OP235	NaN	NaN	{}	increasing	A1-P1	Y1	17	17	7
677	ServoLoad_2_path1_T_B_OP235	NaN	NaN	{}	increasing	A2-P1	Y2	17	17	7
684	SpdBatZero_0_path1_T_B_OP235	NaN	NaN	{}	bool	A0-P1	X	6	13	7
685	SpdBatZero_1_path1_T_B_OP235	NaN	NaN	{}	bool	A1-P1	Y1	6	13	7
686	SpdBatZero_2_path1_T_B_OP235	NaN	NaN	{}	bool	A2-P1	Y2	6	13	7
692	SSpdBatZero_0_path1_T_B_OP235	NaN	NaN	{}	bool	A0-P1	X	6	14	7
693	SSpdBatZero_1_path1_T_B_OP235	NaN	NaN	{}	bool	A1-P1	Y1	6	14	7
694	SSpdBatZero_2_path1_T_B_OP235	NaN	NaN	{}	bool	A2-P1	Y2	6	14	7
701	RadFan2SrvAmpSpeed_0_path1_T_B_OP235	5000	4500	{}	decreasing	A0-P1	X	2	16	7
702	RadFan2SrvAmpSpeed_1_path1_T_B_OP235	5000	4500	{}	decreasing	A1-P1	Y1	2	16	7
703	RadFan2SrvAmpSpeed_2_path1_T_B_OP235	5000	4500	{}	decreasing	A2-P1	Y2	2	16	7
709	ApcBatLow_0_path1_T_B_OP235	NaN	NaN	{}	bool	A0-P1	X	6	1	7
710	ApcBatLow_1_path1_T_B_OP235	NaN	NaN	{}	bool	A1-P1	Y1	6	1	7
711	ApcBatLow_2_path1_T_B_OP235	NaN	NaN	{}	bool	A2-P1	Y2	6	1	7
717	CncBatLow_0_path1_T_B_OP235	NaN	NaN	{}	bool	A0-P1	X	6	2	7
718	CncBatLow_1_path1_T_B_OP235	NaN	NaN	{}	bool	A1-P1	Y1	6	2	7
719	CncBatLow_2_path1_T_B_OP235	NaN	NaN	{}	bool	A2-P1	Y2	6	2	7
725	ServoLeakResistData_0_path1_T_B_OP235	50	30	{}	decreasing	A0-P1	X	15	5	7
726	ServoLeakResistData_1_path1_T_B_OP235	50	30	{}	decreasing	A1-P1	Y1	15	5	7
727	ServoLeakResistData_2_path1_T_B_OP235	50	30	{}	decreasing	A2-P1	Y2	15	5	7
734	InFan1SrvComPwSpeed_0_path1_T_B_OP235	6200	6000	{}	decreasing	A0-P1	X	2	9	7
735	InFan1SrvComPwSpeed_1_path1_T_B_OP235	6200	6000	{}	decreasing	A1-P1	Y1	2	9	7
736	InFan1SrvComPwSpeed_2_path1_T_B_OP235	6200	6000	{}	decreasing	A2-P1	Y2	2	9	7
742	InFan2SrvAmpSpeed_0_path1_T_B_OP235	5000	4500	{}	decreasing	A0-P1	X	2	11	7
743	InFan2SrvAmpSpeed_1_path1_T_B_OP235	5000	4500	{}	decreasing	A1-P1	Y1	2	11	7
744	InFan2SrvAmpSpeed_2_path1_T_B_OP235	5000	4500	{}	decreasing	A2-P1	Y2	2	11	7
751	RadFan1SrvAmpSpeed_0_path1_T_B_OP235	5000	4500	{}	decreasing	A0-P1	X	2	15	7
752	RadFan1SrvAmpSpeed_1_path1_T_B_OP235	5000	4500	{}	decreasing	A1-P1	Y1	2	15	7
753	RadFan1SrvAmpSpeed_2_path1_T_B_OP235	5000	4500	{}	decreasing	A2-P1	Y2	2	15	7
759	InFan2SpdlComPwSpeed_0_path1_T_B_OP235	5000	4500	{}	decreasing	A0-P1	SAS	2	10	7
760	InFan2SpindleAmpSpeed_0_path1_T_B_OP235	5000	4500	{}	decreasing	A0-P1	SCS	2	10	7
761	InFan2SrvComPwSpeed_0_path1_T_B_OP235	5000	4500	{}	decreasing	A0-P1	X	2	12	7
762	InFan2SrvComPwSpeed_1_path1_T_B_OP235	5000	4500	{}	decreasing	A1-P1	Y1	2	12	7
763	InFan2SrvComPwSpeed_2_path1_T_B_OP235	5000	4500	{}	decreasing	A2-P1	Y2	2	12	7
769	InFan1SpdlComPwSpeed_0_path1_T_B_OP235	5000	4500	{}	decreasing	A0-P1	SAS	2	7	7
770	InFan1SpindleAmpSpeed_0_path1_T_B_OP235	5000	4500	{}	decreasing	A0-P1	SCS	2	7	7
771	ServoTemp_0_path1_T_B_OP235	40	50	{}	increasing	A0-P1	X	13	3	7
772	ServoTemp_1_path1_T_B_OP235	86	108	{}	increasing	A1-P1	Y1	13	3	7
773	ServoTemp_2_path1_T_B_OP235	48	60	{}	increasing	A2-P1	Y2	13	3	7
780	PulseCoderTemp_0_path1_T_B_OP540	75	85	{}	increasing	A0-P1	X	13	4	8
781	PulseCoderTemp_1_path1_T_B_OP540	87	108	{}	increasing	A1-P1	Y1	13	4	8
782	PulseCoderTemp_2_path1_T_B_OP540	60	65	{}	increasing	A2-P1	Z1	13	4	8
783	PulseCoderTemp_3_path1_T_B_OP540	60	60	{}	increasing	A3-P1	A1	13	4	8
784	PulseCoderTemp_4_path1_T_B_OP540	60	60	{}	increasing	A4-P1	A2	13	4	8
785	CncFan1Speed_path1_T_B_OP540	4500	4000	{}	decreasing	A1-P1	F1	16	6	8
786	CncFan2Speed_path1_T_B_OP540	9600	8600	{}	decreasing	A2-P1	F3	16	6	8
789	InFan1SrvAmpSpeed_0_path1_T_B_OP540	9500	9000	{}	decreasing	A0-P1	X	2	8	8
790	InFan1SrvAmpSpeed_1_path1_T_B_OP540	9500	9000	{}	decreasing	A1-P1	Y1	2	8	8
791	InFan1SrvAmpSpeed_2_path1_T_B_OP540	9500	9000	{}	decreasing	A2-P1	Z1	2	8	8
792	InFan1SrvAmpSpeed_3_path1_T_B_OP540	8200	8000	{}	decreasing	A3-P1	A1	2	8	8
793	InFan1SrvAmpSpeed_4_path1_T_B_OP540	8500	7500	{}	decreasing	A4-P1	A2	2	8	8
794	ServoLoad_0_path1_T_B_OP540	NaN	NaN	{}	increasing	A0-P1	X	17	17	8
795	ServoLoad_1_path1_T_B_OP540	NaN	NaN	{}	increasing	A1-P1	Y1	17	17	8
796	ServoLoad_2_path1_T_B_OP540	NaN	NaN	{}	increasing	A2-P1	Z1	17	17	8
797	ServoLoad_3_path1_T_B_OP540	NaN	NaN	{}	increasing	A3-P1	A1	17	17	8
798	ServoLoad_4_path1_T_B_OP540	NaN	NaN	{}	increasing	A4-P1	A2	17	17	8
799	SpdBatZero_0_path1_T_B_OP540	NaN	NaN	{}	bool	A0-P1	X	6	13	8
800	SpdBatZero_1_path1_T_B_OP540	NaN	NaN	{}	bool	A1-P1	Y1	6	13	8
801	SpdBatZero_2_path1_T_B_OP540	NaN	NaN	{}	bool	A2-P1	Z1	6	13	8
802	SpdBatZero_3_path1_T_B_OP540	NaN	NaN	{}	bool	A3-P1	A1	6	13	8
803	SpdBatZero_4_path1_T_B_OP540	NaN	NaN	{}	bool	A4-P1	A2	6	13	8
804	SSpdBatZero_0_path1_T_B_OP540	NaN	NaN	{}	bool	A0-P1	X	6	14	8
805	SSpdBatZero_1_path1_T_B_OP540	NaN	NaN	{}	bool	A1-P1	Y1	6	14	8
806	SSpdBatZero_2_path1_T_B_OP540	NaN	NaN	{}	bool	A2-P1	Z1	6	14	8
807	SSpdBatZero_3_path1_T_B_OP540	NaN	NaN	{}	bool	A3-P1	A1	6	14	8
808	SSpdBatZero_4_path1_T_B_OP540	NaN	NaN	{}	bool	A4-P1	A2	6	14	8
809	RadFan2SrvAmpSpeed_0_path1_T_B_OP540	5000	4500	{}	decreasing	A0-P1	X	2	16	8
810	RadFan2SrvAmpSpeed_1_path1_T_B_OP540	5000	4500	{}	decreasing	A1-P1	Y1	2	16	8
811	RadFan2SrvAmpSpeed_2_path1_T_B_OP540	5000	4500	{}	decreasing	A2-P1	Z1	2	16	8
812	RadFan2SrvAmpSpeed_3_path1_T_B_OP540	5000	4500	{}	decreasing	A3-P1	A1	2	16	8
813	RadFan2SrvAmpSpeed_4_path1_T_B_OP540	5000	4500	{}	decreasing	A4-P1	A2	2	16	8
814	ApcBatLow_0_path1_T_B_OP540	NaN	NaN	{}	bool	A0-P1	X	6	1	8
815	ApcBatLow_1_path1_T_B_OP540	NaN	NaN	{}	bool	A1-P1	Y1	6	1	8
816	ApcBatLow_2_path1_T_B_OP540	NaN	NaN	{}	bool	A2-P1	Z1	6	1	8
817	ApcBatLow_3_path1_T_B_OP540	NaN	NaN	{}	bool	A3-P1	A1	6	1	8
818	ApcBatLow_4_path1_T_B_OP540	NaN	NaN	{}	bool	A4-P1	A2	6	1	8
819	CncBatLow_0_path1_T_B_OP540	NaN	NaN	{}	bool	A0-P1	X	6	2	8
820	CncBatLow_1_path1_T_B_OP540	NaN	NaN	{}	bool	A1-P1	Y1	6	2	8
821	CncBatLow_2_path1_T_B_OP540	NaN	NaN	{}	bool	A2-P1	Z1	6	2	8
822	CncBatLow_3_path1_T_B_OP540	NaN	NaN	{}	bool	A3-P1	A1	6	2	8
823	CncBatLow_4_path1_T_B_OP540	NaN	NaN	{}	bool	A4-P1	A2	6	2	8
824	ServoLeakResistData_0_path1_T_B_OP540	50	30	{}	decreasing	A0-P1	X	15	5	8
825	ServoLeakResistData_1_path1_T_B_OP540	50	30	{}	decreasing	A1-P1	Y1	15	5	8
826	ServoLeakResistData_2_path1_T_B_OP540	50	30	{}	decreasing	A2-P1	Z1	15	5	8
827	ServoLeakResistData_3_path1_T_B_OP540	50	30	{}	decreasing	A3-P1	A1	15	5	8
828	ServoLeakResistData_4_path1_T_B_OP540	50	30	{}	decreasing	A4-P1	A2	15	5	8
829	InFan1SrvComPwSpeed_0_path1_T_B_OP540	6200	6000	{}	decreasing	A0-P1	X	2	9	8
830	InFan1SrvComPwSpeed_1_path1_T_B_OP540	6200	6000	{}	decreasing	A1-P1	Y1	2	9	8
831	InFan1SrvComPwSpeed_2_path1_T_B_OP540	6200	6000	{}	decreasing	A2-P1	Z1	2	9	8
832	InFan1SrvComPwSpeed_3_path1_T_B_OP540	6200	6000	{}	decreasing	A3-P1	A1	2	9	8
833	InFan1SrvComPwSpeed_4_path1_T_B_OP540	6200	6000	{}	decreasing	A4-P1	A2	2	9	8
834	InFan2SrvAmpSpeed_0_path1_T_B_OP540	5000	4500	{}	decreasing	A0-P1	X	2	11	8
835	InFan2SrvAmpSpeed_1_path1_T_B_OP540	5000	4500	{}	decreasing	A1-P1	Y1	2	11	8
836	InFan2SrvAmpSpeed_2_path1_T_B_OP540	5000	4500	{}	decreasing	A2-P1	Z1	2	11	8
837	InFan2SrvAmpSpeed_3_path1_T_B_OP540	5000	4500	{}	decreasing	A3-P1	A1	2	11	8
838	InFan2SrvAmpSpeed_4_path1_T_B_OP540	5000	4500	{}	decreasing	A4-P1	A2	2	11	8
839	RadFan1SrvAmpSpeed_0_path1_T_B_OP540	5000	4500	{}	decreasing	A0-P1	X	2	15	8
840	RadFan1SrvAmpSpeed_1_path1_T_B_OP540	5000	4500	{}	decreasing	A1-P1	Y1	2	15	8
841	RadFan1SrvAmpSpeed_2_path1_T_B_OP540	5000	4500	{}	decreasing	A2-P1	Z1	2	15	8
842	RadFan1SrvAmpSpeed_3_path1_T_B_OP540	5000	4500	{}	decreasing	A3-P1	A1	2	15	8
843	RadFan1SrvAmpSpeed_4_path1_T_B_OP540	5000	4500	{}	decreasing	A4-P1	A2	2	15	8
844	InFan2SrvComPwSpeed_0_path1_T_B_OP540	5000	4500	{}	decreasing	A0-P1	X	2	12	8
845	InFan2SrvComPwSpeed_1_path1_T_B_OP540	5000	4500	{}	decreasing	A1-P1	Y1	2	12	8
846	InFan2SrvComPwSpeed_2_path1_T_B_OP540	5000	4500	{}	decreasing	A2-P1	Z1	2	12	8
847	InFan2SrvComPwSpeed_3_path1_T_B_OP540	5000	4500	{}	decreasing	A3-P1	A1	2	12	8
848	InFan2SrvComPwSpeed_4_path1_T_B_OP540	5000	4500	{}	decreasing	A4-P1	A2	2	12	8
849	ServoTemp_0_path1_T_B_OP540	70	80	{}	increasing	A0-P1	X	13	3	8
850	ServoTemp_1_path1_T_B_OP540	86	108	{}	increasing	A1-P1	Y1	13	3	8
851	ServoTemp_2_path1_T_B_OP540	48	60	{}	increasing	A2-P1	Z1	13	3	8
852	ServoTemp_3_path1_T_B_OP540	40	50	{}	increasing	A3-P1	A1	13	3	8
853	ServoTemp_4_path1_T_B_OP540	36	45	{}	increasing	A4-P1	A2	13	3	8
854	PulseCoderTemp_0_path1_T_C_OP10	60	80	{}	increasing	A0-P1	X	13	4	9
855	PulseCoderTemp_1_path1_T_C_OP10	60	80	{}	increasing	A1-P1	Y	13	4	9
856	PulseCoderTemp_2_path1_T_C_OP10	60	80	{}	increasing	A2-P1	Z	13	4	9
857	PulseCoderTemp_3_path1_T_C_OP10	60	80	{}	increasing	A3-P1	W	13	4	9
858	PulseCoderTemp_4_path1_T_C_OP10	60	80	{}	increasing	A4-P1	B	13	4	9
859	CncFan1Speed_path1_T_C_OP10	4500	4000	{}	decreasing	A1-P1	F1	16	6	9
860	CncFan2Speed_path1_T_C_OP10	9600	8600	{}	decreasing	A2-P1	F2	16	6	9
863	InFan1SrvAmpSpeed_0_path1_T_C_OP10	9500	9000	{}	decreasing	A0-P1	X	2	8	9
864	InFan1SrvAmpSpeed_1_path1_T_C_OP10	9500	9000	{}	decreasing	A1-P1	Y	2	8	9
865	InFan1SrvAmpSpeed_2_path1_T_C_OP10	9500	9000	{}	decreasing	A2-P1	Z	2	8	9
866	InFan1SrvAmpSpeed_3_path1_T_C_OP10	9500	9000	{}	decreasing	A3-P1	W	2	8	9
867	InFan1SrvAmpSpeed_4_path1_T_C_OP10	8500	7500	{}	decreasing	A4-P1	B	2	8	9
868	ServoLoad_0_path1_T_C_OP10	NaN	NaN	{}	increasing	A0-P1	X	17	17	9
869	ServoLoad_1_path1_T_C_OP10	NaN	NaN	{}	increasing	A1-P1	Y	17	17	9
870	ServoLoad_2_path1_T_C_OP10	NaN	NaN	{}	increasing	A2-P1	Z	17	17	9
871	ServoLoad_3_path1_T_C_OP10	NaN	NaN	{}	increasing	A3-P1	W	17	17	9
872	ServoLoad_4_path1_T_C_OP10	NaN	NaN	{}	increasing	A4-P1	B	17	17	9
873	SpindleLoad_0_path1_T_C_OP10	NaN	NaN	{}	increasing	SP-P1	SP	17	17	9
874	SpdBatZero_0_path1_T_C_OP10	NaN	NaN	{}	bool	A0-P1	X	6	13	9
875	SpdBatZero_1_path1_T_C_OP10	NaN	NaN	{}	bool	A1-P1	Y	6	13	9
876	SpdBatZero_2_path1_T_C_OP10	NaN	NaN	{}	bool	A2-P1	Z	6	13	9
877	SpdBatZero_3_path1_T_C_OP10	NaN	NaN	{}	bool	A3-P1	W	6	13	9
878	SpdBatZero_4_path1_T_C_OP10	NaN	NaN	{}	bool	A4-P1	B	6	13	9
879	SSpdBatZero_0_path1_T_C_OP10	NaN	NaN	{}	bool	A0-P1	X	6	14	9
880	SSpdBatZero_1_path1_T_C_OP10	NaN	NaN	{}	bool	A1-P1	Y	6	14	9
881	SSpdBatZero_2_path1_T_C_OP10	NaN	NaN	{}	bool	A2-P1	Z	6	14	9
882	SSpdBatZero_3_path1_T_C_OP10	NaN	NaN	{}	bool	A3-P1	W	6	14	9
883	SSpdBatZero_4_path1_T_C_OP10	NaN	NaN	{}	bool	A4-P1	B	6	14	9
884	RadFan2SpindleAmpSpeed_0_path1_T_C_OP10	5000	4500	{}	decreasing	SP-P1	SP	2	16	9
885	RadFan2SrvAmpSpeed_0_path1_T_C_OP10	5000	4500	{}	decreasing	A0-P1	X	2	16	9
886	RadFan2SrvAmpSpeed_1_path1_T_C_OP10	5000	4500	{}	decreasing	A1-P1	Y	2	16	9
887	RadFan2SrvAmpSpeed_2_path1_T_C_OP10	5000	4500	{}	decreasing	A2-P1	Z	2	16	9
888	RadFan2SrvAmpSpeed_3_path1_T_C_OP10	5000	4500	{}	decreasing	A3-P1	W	2	16	9
889	RadFan2SrvAmpSpeed_4_path1_T_C_OP10	5000	4500	{}	decreasing	A4-P1	B	2	16	9
890	ApcBatLow_0_path1_T_C_OP10	NaN	NaN	{}	bool	A0-P1	X	6	1	9
891	ApcBatLow_1_path1_T_C_OP10	NaN	NaN	{}	bool	A1-P1	Y	6	1	9
892	ApcBatLow_2_path1_T_C_OP10	NaN	NaN	{}	bool	A2-P1	Z	6	1	9
893	ApcBatLow_3_path1_T_C_OP10	NaN	NaN	{}	bool	A3-P1	W	6	1	9
894	ApcBatLow_4_path1_T_C_OP10	NaN	NaN	{}	bool	A4-P1	B	6	1	9
895	CncBatLow_0_path1_T_C_OP10	NaN	NaN	{}	bool	A0-P1	X	6	2	9
896	CncBatLow_1_path1_T_C_OP10	NaN	NaN	{}	bool	A1-P1	Y	6	2	9
897	CncBatLow_2_path1_T_C_OP10	NaN	NaN	{}	bool	A2-P1	Z	6	2	9
898	CncBatLow_3_path1_T_C_OP10	NaN	NaN	{}	bool	A3-P1	W	6	2	9
899	CncBatLow_4_path1_T_C_OP10	NaN	NaN	{}	bool	A4-P1	B	6	2	9
900	ServoLeakResistData_0_path1_T_C_OP10	50	30	{}	decreasing	A0-P1	X	15	5	9
901	ServoLeakResistData_1_path1_T_C_OP10	50	30	{}	decreasing	A1-P1	Y	15	5	9
902	ServoLeakResistData_2_path1_T_C_OP10	50	30	{}	decreasing	A2-P1	Z	15	5	9
903	ServoLeakResistData_3_path1_T_C_OP10	50	30	{}	decreasing	A3-P1	W	15	5	9
904	ServoLeakResistData_4_path1_T_C_OP10	50	30	{}	decreasing	A4-P1	B	15	5	9
905	SpindleLeakResistData_0_path1_T_C_OP10	50	30	{}	decreasing	SP-P1	SP	15	5	9
906	InFan1SrvComPwSpeed_0_path1_T_C_OP10	6200	6000	{}	decreasing	A0-P1	X	2	9	9
907	InFan1SrvComPwSpeed_1_path1_T_C_OP10	6200	6000	{}	decreasing	A1-P1	Y	2	9	9
908	InFan1SrvComPwSpeed_2_path1_T_C_OP10	6200	6000	{}	decreasing	A2-P1	Z	2	9	9
909	InFan1SrvComPwSpeed_3_path1_T_C_OP10	6200	6000	{}	decreasing	A3-P1	W	2	9	9
910	InFan1SrvComPwSpeed_4_path1_T_C_OP10	6200	6000	{}	decreasing	A4-P1	B	2	9	9
911	InFan2SrvAmpSpeed_0_path1_T_C_OP10	5000	4500	{}	decreasing	A2-P1	X	2	11	9
912	InFan2SrvAmpSpeed_1_path1_T_C_OP10	5000	4500	{}	decreasing	A3-P1	Y	2	11	9
913	InFan2SrvAmpSpeed_2_path1_T_C_OP10	5000	4500	{}	decreasing	A4-P1	Z	2	11	9
914	InFan2SrvAmpSpeed_3_path1_T_C_OP10	5000	4500	{}	decreasing	A3-P1	W	2	11	9
915	InFan2SrvAmpSpeed_4_path1_T_C_OP10	5000	4500	{}	decreasing	A4-P1	B	2	11	9
916	RadFan1SpindleAmpSpeed_0_path1_T_C_OP10	5000	4500	{}	decreasing	SP-P1	SP	2	15	9
6286	powder_measuring_output_value	\N	\N	{}	\N	\N	\N	2	\N	64
917	RadFan1SrvAmpSpeed_0_path1_T_C_OP10	5000	4500	{}	decreasing	A0-P1	X	2	15	9
918	RadFan1SrvAmpSpeed_1_path1_T_C_OP10	5000	4500	{}	decreasing	A1-P1	Y	2	15	9
919	RadFan1SrvAmpSpeed_2_path1_T_C_OP10	5000	4500	{}	decreasing	A2-P1	Z	2	15	9
920	RadFan1SrvAmpSpeed_3_path1_T_C_OP10	5000	4500	{}	decreasing	A3-P1	W	2	15	9
921	RadFan1SrvAmpSpeed_4_path1_T_C_OP10	5000	4500	{}	decreasing	A4-P1	B	2	15	9
922	InFan2SpdlComPwSpeed_0_path1_T_C_OP10	5000	4500	{}	decreasing	A0-P1	SAS	2	10	9
923	InFan2SpindleAmpSpeed_0_path1_T_C_OP10	5000	4500	{}	decreasing	A1-P1	SCS	2	10	9
924	InFan2SrvComPwSpeed_0_path1_T_C_OP10	5000	4500	{}	decreasing	A0-P1	X	2	12	9
925	InFan2SrvComPwSpeed_1_path1_T_C_OP10	5000	4500	{}	decreasing	A1-P1	Y	2	12	9
926	InFan2SrvComPwSpeed_2_path1_T_C_OP10	5000	4500	{}	decreasing	A2-P1	Z	2	12	9
927	InFan2SrvComPwSpeed_3_path1_T_C_OP10	5000	4500	{}	decreasing	A3-P1	W	2	12	9
928	InFan2SrvComPwSpeed_4_path1_T_C_OP10	5000	4500	{}	decreasing	A4-P1	B	2	12	9
929	InFan1SpdlComPwSpeed_0_path1_T_C_OP10	5000	4500	{}	decreasing	A0-P1	SAS	2	7	9
930	InFan1SpindleAmpSpeed_0_path1_T_C_OP10	6200	6000	{}	decreasing	A0-P1	SCS	2	7	9
931	ServoTemp_0_path1_T_C_OP10	55	70	{}	increasing	A0-P1	X	13	3	9
932	ServoTemp_1_path1_T_C_OP10	55	70	{}	increasing	A1-P1	Y	13	3	9
933	ServoTemp_2_path1_T_C_OP10	55	70	{}	increasing	A2-P1	Z	13	3	9
934	ServoTemp_3_path1_T_C_OP10	55	70	{}	increasing	A3-P1	W	13	3	9
935	ServoTemp_4_path1_T_C_OP10	55	70	{}	increasing	A4-P1	B	13	3	9
936	SpindleTemp_0_path1_T_C_OP10	80	100	{}	increasing	SP-P1	SP	13	3	9
937	PulseCoderTemp_0_path1_T_C_OP100	60	80	{}	increasing	A0-P1	X	13	4	10
938	PulseCoderTemp_1_path1_T_C_OP100	70	80	{}	increasing	A1-P1	Y	13	4	10
939	PulseCoderTemp_2_path1_T_C_OP100	60	80	{}	increasing	A2-P1	Z	13	4	10
940	PulseCoderTemp_3_path1_T_C_OP100	70	80	{}	increasing	A3-P1	W	13	4	10
941	PulseCoderTemp_4_path1_T_C_OP100	60	80	{}	increasing	A4-P1	B	13	4	10
942	CncFan1Speed_path1_T_C_OP100	4500	4000	{}	decreasing	A1-P1	F1	16	6	10
943	CncFan2Speed_path1_T_C_OP100	9600	8600	{}	decreasing	A2-P1	F2	16	6	10
946	InFan1SrvAmpSpeed_0_path1_T_C_OP100	9500	9000	{}	decreasing	A0-P1	X	2	8	10
947	InFan1SrvAmpSpeed_1_path1_T_C_OP100	9500	9000	{}	decreasing	A1-P1	Y	2	8	10
948	InFan1SrvAmpSpeed_2_path1_T_C_OP100	9500	9000	{}	decreasing	A2-P1	Z	2	8	10
949	InFan1SrvAmpSpeed_3_path1_T_C_OP100	9500	9000	{}	decreasing	A3-P1	W	2	8	10
950	InFan1SrvAmpSpeed_4_path1_T_C_OP100	8500	7500	{}	decreasing	A4-P1	B	2	8	10
951	ServoLoad_0_path1_T_C_OP100	NaN	NaN	{}	increasing	A0-P1	X	17	17	10
952	ServoLoad_1_path1_T_C_OP100	NaN	NaN	{}	increasing	A1-P1	Y	17	17	10
953	ServoLoad_2_path1_T_C_OP100	NaN	NaN	{}	increasing	A2-P1	Z	17	17	10
954	ServoLoad_3_path1_T_C_OP100	NaN	NaN	{}	increasing	A3-P1	W	17	17	10
955	ServoLoad_4_path1_T_C_OP100	NaN	NaN	{}	increasing	A4-P1	B	17	17	10
956	SpindleLoad_0_path1_T_C_OP100	NaN	NaN	{}	increasing	SP-P1	SP	17	17	10
957	SpdBatZero_0_path1_T_C_OP100	NaN	NaN	{}	bool	A0-P1	X	6	13	10
958	SpdBatZero_1_path1_T_C_OP100	NaN	NaN	{}	bool	A1-P1	Y	6	13	10
959	SpdBatZero_2_path1_T_C_OP100	NaN	NaN	{}	bool	A2-P1	Z	6	13	10
960	SpdBatZero_3_path1_T_C_OP100	NaN	NaN	{}	bool	A3-P1	W	6	13	10
961	SpdBatZero_4_path1_T_C_OP100	NaN	NaN	{}	bool	A4-P1	B	6	13	10
962	SSpdBatZero_0_path1_T_C_OP100	NaN	NaN	{}	bool	A0-P1	X	6	14	10
963	SSpdBatZero_1_path1_T_C_OP100	NaN	NaN	{}	bool	A1-P1	Y	6	14	10
964	SSpdBatZero_2_path1_T_C_OP100	NaN	NaN	{}	bool	A2-P1	Z	6	14	10
965	SSpdBatZero_3_path1_T_C_OP100	NaN	NaN	{}	bool	A3-P1	W	6	14	10
966	SSpdBatZero_4_path1_T_C_OP100	NaN	NaN	{}	bool	A4-P1	B	6	14	10
967	RadFan2SpindleAmpSpeed_0_path1_T_C_OP100	5000	4500	{}	decreasing	SP-P1	SP	2	16	10
968	RadFan2SrvAmpSpeed_0_path1_T_C_OP100	5000	4500	{}	decreasing	A0-P1	X	2	16	10
969	RadFan2SrvAmpSpeed_1_path1_T_C_OP100	5000	4500	{}	decreasing	A1-P1	Y	2	16	10
970	RadFan2SrvAmpSpeed_2_path1_T_C_OP100	5000	4500	{}	decreasing	A2-P1	Z	2	16	10
971	RadFan2SrvAmpSpeed_3_path1_T_C_OP100	5000	4500	{}	decreasing	A3-P1	W	2	16	10
972	RadFan2SrvAmpSpeed_4_path1_T_C_OP100	5000	4500	{}	decreasing	A4-P1	B	2	16	10
973	ApcBatLow_0_path1_T_C_OP100	NaN	NaN	{}	bool	A0-P1	X	6	1	10
974	ApcBatLow_1_path1_T_C_OP100	NaN	NaN	{}	bool	A1-P1	Y	6	1	10
975	ApcBatLow_2_path1_T_C_OP100	NaN	NaN	{}	bool	A2-P1	Z	6	1	10
976	ApcBatLow_3_path1_T_C_OP100	NaN	NaN	{}	bool	A3-P1	W	6	1	10
977	ApcBatLow_4_path1_T_C_OP100	NaN	NaN	{}	bool	A4-P1	B	6	1	10
978	CncBatLow_0_path1_T_C_OP100	NaN	NaN	{}	bool	A0-P1	X	6	2	10
979	CncBatLow_1_path1_T_C_OP100	NaN	NaN	{}	bool	A1-P1	Y	6	2	10
980	CncBatLow_2_path1_T_C_OP100	NaN	NaN	{}	bool	A2-P1	Z	6	2	10
981	CncBatLow_3_path1_T_C_OP100	NaN	NaN	{}	bool	A3-P1	W	6	2	10
982	CncBatLow_4_path1_T_C_OP100	NaN	NaN	{}	bool	A4-P1	B	6	2	10
983	ServoLeakResistData_0_path1_T_C_OP100	50	30	{}	decreasing	SP-P1	SP	15	5	10
984	ServoLeakResistData_1_path1_T_C_OP100	50	30	{}	decreasing	A0-P1	X	15	5	10
985	ServoLeakResistData_2_path1_T_C_OP100	50	30	{}	decreasing	A1-P1	Y	15	5	10
986	ServoLeakResistData_3_path1_T_C_OP100	50	30	{}	decreasing	A2-P1	Z	15	5	10
987	ServoLeakResistData_4_path1_T_C_OP100	50	30	{}	decreasing	A3-P1	W	15	5	10
988	SpindleLeakResistData_0_path1_T_C_OP100	50	30	{}	decreasing	A4-P1	B	15	5	10
989	InFan1SrvComPwSpeed_0_path1_T_C_OP100	6200	6000	{}	decreasing	A0-P1	X	2	9	10
990	InFan1SrvComPwSpeed_1_path1_T_C_OP100	6200	6000	{}	decreasing	A1-P1	Y	2	9	10
991	InFan1SrvComPwSpeed_2_path1_T_C_OP100	6200	6000	{}	decreasing	A2-P1	Z	2	9	10
992	InFan1SrvComPwSpeed_3_path1_T_C_OP100	6200	6000	{}	decreasing	A3-P1	W	2	9	10
993	InFan1SrvComPwSpeed_4_path1_T_C_OP100	6200	6000	{}	decreasing	A4-P1	B	2	9	10
994	InFan2SrvAmpSpeed_0_path1_T_C_OP100	5000	4500	{}	decreasing	A0-P1	X	2	11	10
995	InFan2SrvAmpSpeed_1_path1_T_C_OP100	5000	4500	{}	decreasing	A1-P1	Y	2	11	10
996	InFan2SrvAmpSpeed_2_path1_T_C_OP100	5000	4500	{}	decreasing	A2-P1	Z	2	11	10
997	InFan2SrvAmpSpeed_3_path1_T_C_OP100	5000	4500	{}	decreasing	A3-P1	W	2	11	10
998	InFan2SrvAmpSpeed_4_path1_T_C_OP100	5000	4500	{}	decreasing	A4-P1	B	2	11	10
999	RadFan1SpindleAmpSpeed_0_path1_T_C_OP100	5000	4500	{}	decreasing	SP-P1	SP	2	15	10
1000	RadFan1SrvAmpSpeed_0_path1_T_C_OP100	5000	4500	{}	decreasing	A0-P1	X	2	15	10
1001	RadFan1SrvAmpSpeed_1_path1_T_C_OP100	5000	4500	{}	decreasing	A1-P1	Y	2	15	10
1002	RadFan1SrvAmpSpeed_2_path1_T_C_OP100	5000	4500	{}	decreasing	A2-P1	Z	2	15	10
1003	RadFan1SrvAmpSpeed_3_path1_T_C_OP100	5000	4500	{}	decreasing	A3-P1	W	2	15	10
1004	RadFan1SrvAmpSpeed_4_path1_T_C_OP100	5000	4500	{}	decreasing	A4-P1	B	2	15	10
1005	InFan2SpdlComPwSpeed_0_path1_T_C_OP100	5000	4500	{}	decreasing	A0-P1	SAS	2	10	10
1006	InFan2SpindleAmpSpeed_0_path1_T_C_OP100	5000	4500	{}	decreasing	A0-P1	SCS	2	10	10
1007	InFan2SrvComPwSpeed_0_path1_T_C_OP100	5000	4500	{}	decreasing	A0-P1	X	2	12	10
1008	InFan2SrvComPwSpeed_1_path1_T_C_OP100	5000	4500	{}	decreasing	A1-P1	Y	2	12	10
1009	InFan2SrvComPwSpeed_2_path1_T_C_OP100	5000	4500	{}	decreasing	A2-P1	Z	2	12	10
1010	InFan2SrvComPwSpeed_3_path1_T_C_OP100	5000	4500	{}	decreasing	A3-P1	W	2	12	10
1011	InFan2SrvComPwSpeed_4_path1_T_C_OP100	5000	4500	{}	decreasing	A4-P1	B	2	12	10
1012	InFan1SpdlComPwSpeed_0_path1_T_C_OP100	5000	4500	{}	decreasing	A0-P1	SAS	2	7	10
1013	InFan1SpindleAmpSpeed_0_path1_T_C_OP100	6200	6000	{}	decreasing	A0-P1	SCS	2	7	10
1014	ServoTemp_0_path1_T_C_OP100	55	70	{}	increasing	A0-P1	X	13	3	10
1015	ServoTemp_1_path1_T_C_OP100	63	70	{}	increasing	A1-P1	Y	13	3	10
1016	ServoTemp_2_path1_T_C_OP100	55	70	{}	increasing	A2-P1	Z	13	3	10
1017	ServoTemp_3_path1_T_C_OP100	55	70	{}	increasing	A3-P1	W	13	3	10
1018	ServoTemp_4_path1_T_C_OP100	55	70	{}	increasing	A4-P1	B	13	3	10
1019	SpindleTemp_0_path1_T_C_OP100	80	100	{}	increasing	SP-P1	SP	13	3	10
1020	PulseCoderTemp_0_path1_T_C_OP160	60	80	{}	increasing	A0-P1	X	13	4	11
1021	PulseCoderTemp_1_path1_T_C_OP160	70	80	{}	increasing	A1-P1	Y	13	4	11
1022	PulseCoderTemp_2_path1_T_C_OP160	60	80	{}	increasing	A2-P1	Z	13	4	11
1023	PulseCoderTemp_3_path1_T_C_OP160	60	80	{}	increasing	A3-P1	W	13	4	11
1024	PulseCoderTemp_4_path1_T_C_OP160	60	80	{}	increasing	A4-P1	A	13	4	11
1025	PulseCoderTemp_5_path1_T_C_OP160	60	80	{}	increasing	A5-P1	B	13	4	11
1026	CncFan1Speed_path1_T_C_OP160	4500	4000	{}	decreasing	A1-P1	F1	16	6	11
1027	CncFan2Speed_path1_T_C_OP160	9600	8600	{}	decreasing	A2-P1	F2	16	6	11
1030	InFan1SrvAmpSpeed_0_path1_T_C_OP160	9500	9000	{}	decreasing	A0-P1	X	2	8	11
1031	InFan1SrvAmpSpeed_1_path1_T_C_OP160	8500	7500	{}	decreasing	A1-P1	Y	2	8	11
1032	InFan1SrvAmpSpeed_2_path1_T_C_OP160	8500	7500	{}	decreasing	A2-P1	Z	2	8	11
1033	InFan1SrvAmpSpeed_3_path1_T_C_OP160	8500	7500	{}	decreasing	A3-P1	W	2	8	11
1034	InFan1SrvAmpSpeed_4_path1_T_C_OP160	8500	7500	{}	decreasing	A4-P1	A	2	8	11
1035	InFan1SrvAmpSpeed_5_path1_T_C_OP160	8500	7500	{}	decreasing	A5-P1	B	2	8	11
1036	ServoLoad_0_path1_T_C_OP160	NaN	NaN	{}	increasing	A0-P1	X	17	17	11
1037	ServoLoad_1_path1_T_C_OP160	NaN	NaN	{}	increasing	A1-P1	Y	17	17	11
1038	ServoLoad_2_path1_T_C_OP160	NaN	NaN	{}	increasing	A2-P1	Z	17	17	11
1039	ServoLoad_3_path1_T_C_OP160	NaN	NaN	{}	increasing	A3-P1	W	17	17	11
1040	ServoLoad_4_path1_T_C_OP160	NaN	NaN	{}	increasing	A4-P1	A	17	17	11
1041	ServoLoad_5_path1_T_C_OP160	NaN	NaN	{}	increasing	A5-P1	B	17	17	11
1042	SpindleLoad_0_path1_T_C_OP160	NaN	NaN	{}	increasing	SP-P1	SP	17	17	11
1043	SpdBatZero_0_path1_T_C_OP160	NaN	NaN	{}	bool	A0-P1	X	6	13	11
1044	SpdBatZero_1_path1_T_C_OP160	NaN	NaN	{}	bool	A1-P1	Y	6	13	11
1045	SpdBatZero_2_path1_T_C_OP160	NaN	NaN	{}	bool	A2-P1	Z	6	13	11
1046	SpdBatZero_3_path1_T_C_OP160	NaN	NaN	{}	bool	A3-P1	W	6	13	11
1047	SpdBatZero_4_path1_T_C_OP160	NaN	NaN	{}	bool	A4-P1	A	6	13	11
1048	SpdBatZero_5_path1_T_C_OP160	NaN	NaN	{}	bool	A5-P1	B	6	13	11
1049	SSpdBatZero_0_path1_T_C_OP160	NaN	NaN	{}	bool	A0-P1	X	6	14	11
1050	SSpdBatZero_1_path1_T_C_OP160	NaN	NaN	{}	bool	A1-P1	Y	6	14	11
1051	SSpdBatZero_2_path1_T_C_OP160	NaN	NaN	{}	bool	A2-P1	Z	6	14	11
1052	SSpdBatZero_3_path1_T_C_OP160	NaN	NaN	{}	bool	A3-P1	W	6	14	11
1053	SSpdBatZero_4_path1_T_C_OP160	NaN	NaN	{}	bool	A4-P1	A	6	14	11
1054	SSpdBatZero_5_path1_T_C_OP160	NaN	NaN	{}	bool	A5-P1	B	6	14	11
1055	RadFan2SpindleAmpSpeed_0_path1_T_C_OP160	5000	4500	{}	decreasing	SP-P1	SP	2	16	11
1056	RadFan2SrvAmpSpeed_0_path1_T_C_OP160	5000	4500	{}	decreasing	A0-P1	X	2	16	11
1057	RadFan2SrvAmpSpeed_1_path1_T_C_OP160	5000	4500	{}	decreasing	A1-P1	Y	2	16	11
1058	RadFan2SrvAmpSpeed_2_path1_T_C_OP160	5000	4500	{}	decreasing	A2-P1	Z	2	16	11
1059	RadFan2SrvAmpSpeed_3_path1_T_C_OP160	5000	4500	{}	decreasing	A3-P1	W	2	16	11
1060	RadFan2SrvAmpSpeed_4_path1_T_C_OP160	5000	4500	{}	decreasing	A4-P1	A	2	16	11
1061	RadFan2SrvAmpSpeed_5_path1_T_C_OP160	5000	4500	{}	decreasing	A5-P1	B	2	16	11
1062	ApcBatLow_0_path1_T_C_OP160	NaN	NaN	{}	bool	A0-P1	X	6	1	11
1063	ApcBatLow_1_path1_T_C_OP160	NaN	NaN	{}	bool	A1-P1	Y	6	1	11
1064	ApcBatLow_2_path1_T_C_OP160	NaN	NaN	{}	bool	A2-P1	Z	6	1	11
1065	ApcBatLow_3_path1_T_C_OP160	NaN	NaN	{}	bool	A3-P1	W	6	1	11
1066	ApcBatLow_4_path1_T_C_OP160	NaN	NaN	{}	bool	A4-P1	A	6	1	11
1067	ApcBatLow_5_path1_T_C_OP160	NaN	NaN	{}	bool	A5-P1	B	6	1	11
1068	CncBatLow_0_path1_T_C_OP160	NaN	NaN	{}	bool	A0-P1	X	6	2	11
1069	CncBatLow_1_path1_T_C_OP160	NaN	NaN	{}	bool	A1-P1	Y	6	2	11
1070	CncBatLow_2_path1_T_C_OP160	NaN	NaN	{}	bool	A2-P1	Z	6	2	11
1071	CncBatLow_3_path1_T_C_OP160	NaN	NaN	{}	bool	A3-P1	W	6	2	11
1072	CncBatLow_4_path1_T_C_OP160	NaN	NaN	{}	bool	A4-P1	A	6	2	11
1073	CncBatLow_5_path1_T_C_OP160	NaN	NaN	{}	bool	A5-P1	B	6	2	11
1074	ServoLeakResistData_0_path1_T_C_OP160	50	30	{}	decreasing	A0-P1	X	15	5	11
1075	ServoLeakResistData_1_path1_T_C_OP160	50	30	{}	decreasing	A1-P1	Y	15	5	11
1076	ServoLeakResistData_2_path1_T_C_OP160	50	30	{}	decreasing	A2-P1	Z	15	5	11
1078	ServoLeakResistData_4_path1_T_C_OP160	50	30	{}	decreasing	A4-P1	A	15	5	11
1079	ServoLeakResistData_5_path1_T_C_OP160	50	30	{}	decreasing	A5-P1	B	15	5	11
1080	SpindleLeakResistData_0_path1_T_C_OP160	50	30	{}	decreasing	SP-P1	SP	15	5	11
1081	InFan1SrvComPwSpeed_0_path1_T_C_OP160	6200	6000	{}	decreasing	A0-P1	X	2	9	11
1082	InFan1SrvComPwSpeed_1_path1_T_C_OP160	6200	6000	{}	decreasing	A1-P1	Y	2	9	11
1083	InFan1SrvComPwSpeed_2_path1_T_C_OP160	6200	6000	{}	decreasing	A2-P1	Z	2	9	11
1084	InFan1SrvComPwSpeed_3_path1_T_C_OP160	6200	6000	{}	decreasing	A3-P1	W	2	9	11
1085	InFan1SrvComPwSpeed_4_path1_T_C_OP160	6200	6000	{}	decreasing	A4-P1	A	2	9	11
1086	InFan1SrvComPwSpeed_5_path1_T_C_OP160	6200	6000	{}	decreasing	A5-P1	B	2	9	11
1087	InFan2SrvAmpSpeed_0_path1_T_C_OP160	5000	4500	{}	decreasing	A0-P1	X	2	11	11
1088	InFan2SrvAmpSpeed_1_path1_T_C_OP160	5000	4500	{}	decreasing	A1-P1	Y	2	11	11
1089	InFan2SrvAmpSpeed_2_path1_T_C_OP160	5000	4500	{}	decreasing	A2-P1	Z	2	11	11
1090	InFan2SrvAmpSpeed_3_path1_T_C_OP160	5000	4500	{}	decreasing	A3-P1	W	2	11	11
1091	InFan2SrvAmpSpeed_4_path1_T_C_OP160	5000	4500	{}	decreasing	A4-P1	A	2	11	11
1092	InFan2SrvAmpSpeed_5_path1_T_C_OP160	5000	4500	{}	decreasing	A5-P1	B	2	11	11
1093	RadFan1SpindleAmpSpeed_0_path1_T_C_OP160	5000	4500	{}	decreasing	SP-P1	SP	2	15	11
1094	RadFan1SrvAmpSpeed_0_path1_T_C_OP160	5000	4500	{}	decreasing	A0-P1	X	2	15	11
1095	RadFan1SrvAmpSpeed_1_path1_T_C_OP160	5000	4500	{}	decreasing	A1-P1	Y	2	15	11
1096	RadFan1SrvAmpSpeed_2_path1_T_C_OP160	5000	4500	{}	decreasing	A2-P1	Z	2	15	11
1097	RadFan1SrvAmpSpeed_3_path1_T_C_OP160	5000	4500	{}	decreasing	A3-P1	W	2	15	11
1098	RadFan1SrvAmpSpeed_4_path1_T_C_OP160	5000	4500	{}	decreasing	A4-P1	A	2	15	11
1099	RadFan1SrvAmpSpeed_5_path1_T_C_OP160	5000	4500	{}	decreasing	A5-P1	B	2	15	11
1100	InFan2SpdlComPwSpeed_0_path1_T_C_OP160	5000	4500	{}	decreasing	A0-P1	SAS	2	10	11
1101	InFan2SpindleAmpSpeed_0_path1_T_C_OP160	5000	4500	{}	decreasing	A0-P1	SCS	2	10	11
1102	InFan2SrvComPwSpeed_0_path1_T_C_OP160	5000	4500	{}	decreasing	A0-P1	X	2	12	11
1103	InFan2SrvComPwSpeed_1_path1_T_C_OP160	5000	4500	{}	decreasing	A1-P1	Y	2	12	11
1104	InFan2SrvComPwSpeed_2_path1_T_C_OP160	5000	4500	{}	decreasing	A2-P1	Z	2	12	11
1105	InFan2SrvComPwSpeed_3_path1_T_C_OP160	5000	4500	{}	decreasing	A3-P1	W	2	12	11
6287	powder_measuring_value	\N	\N	{}	\N	\N	\N	10	\N	64
1106	InFan2SrvComPwSpeed_4_path1_T_C_OP160	5000	4500	{}	decreasing	A4-P1	A	2	12	11
1107	InFan2SrvComPwSpeed_5_path1_T_C_OP160	5000	4500	{}	decreasing	A5-P1	B	2	12	11
1108	InFan1SpdlComPwSpeed_0_path1_T_C_OP160	5000	4500	{}	decreasing	A0-P1	SAS	2	7	11
4319	ServoTemp_0_path1_T_H_OP230	55	70	{}	increasing	A0-P1	X	13	3	41
1109	InFan1SpindleAmpSpeed_0_path1_T_C_OP160	6200	6000	{}	decreasing	A0-P1	SCS	2	7	11
1110	ServoTemp_0_path1_T_C_OP160	55	70	{}	increasing	A0-P1	X	13	3	11
1111	ServoTemp_1_path1_T_C_OP160	55	70	{}	increasing	A1-P1	Y	13	3	11
1112	ServoTemp_2_path1_T_C_OP160	55	70	{}	increasing	A2-P1	Z	13	3	11
1113	ServoTemp_3_path1_T_C_OP160	55	70	{}	increasing	A3-P1	W	13	3	11
1114	ServoTemp_4_path1_T_C_OP160	55	70	{}	increasing	A4-P1	A	13	3	11
1115	ServoTemp_5_path1_T_C_OP160	55	70	{}	increasing	A5-P1	B	13	3	11
1116	SpindleTemp_0_path1_T_C_OP160	80	100	{}	increasing	SP-P1	SP	13	3	11
1117	PulseCoderTemp_0_path1_T_C_OP190	80	90	{}	increasing	A0-P1	X	13	4	12
1118	PulseCoderTemp_1_path1_T_C_OP190	60	80	{}	increasing	A1-P1	A	13	4	12
1119	PulseCoderTemp_2_path1_T_C_OP190	60	80	{}	increasing	A2-P1	B	13	4	12
1120	PulseCoderTemp_3_path1_T_C_OP190	60	80	{}	increasing	A3-P1	C	13	4	12
1125	CncFan1Speed_path1_T_C_OP190	4500	4000	{}	decreasing	A1-P1	F1	16	6	12
1126	CncFan2Speed_path1_T_C_OP190	9600	8600	{}	decreasing	A2-P1	F2	16	6	12
1129	InFan1SrvAmpSpeed_0_path1_T_C_OP190	9500	9000	{}	decreasing	A0-P1	X	2	8	12
1130	InFan1SrvAmpSpeed_1_path1_T_C_OP190	9500	9000	{}	decreasing	A1-P1	A	2	8	12
1131	InFan1SrvAmpSpeed_2_path1_T_C_OP190	9500	9000	{}	decreasing	A2-P1	B	2	8	12
1132	InFan1SrvAmpSpeed_3_path1_T_C_OP190	9500	9000	{}	decreasing	A3-P1	C	2	8	12
1137	ServoLoad_0_path1_T_C_OP190	NaN	NaN	{}	increasing	A0-P1	X	17	17	12
1138	ServoLoad_1_path1_T_C_OP190	NaN	NaN	{}	increasing	A1-P1	A	17	17	12
1139	ServoLoad_2_path1_T_C_OP190	NaN	NaN	{}	increasing	A2-P1	B	17	17	12
1140	ServoLoad_3_path1_T_C_OP190	NaN	NaN	{}	increasing	A3-P1	C	17	17	12
1145	SpindleLoad_0_path1_T_C_OP190	NaN	NaN	{}	increasing	SP-P1	SP	17	17	12
1146	SpdBatZero_0_path1_T_C_OP190	NaN	NaN	{}	bool	A0-P1	X	6	13	12
1147	SpdBatZero_1_path1_T_C_OP190	NaN	NaN	{}	bool	A1-P1	A	6	13	12
1148	SpdBatZero_2_path1_T_C_OP190	NaN	NaN	{}	bool	A2-P1	B	6	13	12
1149	SpdBatZero_3_path1_T_C_OP190	NaN	NaN	{}	bool	A3-P1	C	6	13	12
1154	SSpdBatZero_0_path1_T_C_OP190	NaN	NaN	{}	bool	A0-P1	X	6	14	12
1155	SSpdBatZero_1_path1_T_C_OP190	NaN	NaN	{}	bool	A1-P1	A	6	14	12
1156	SSpdBatZero_2_path1_T_C_OP190	NaN	NaN	{}	bool	A2-P1	B	6	14	12
1157	SSpdBatZero_3_path1_T_C_OP190	NaN	NaN	{}	bool	A3-P1	C	6	14	12
1162	RadFan2SpindleAmpSpeed_0_path1_T_C_OP190	5000	4500	{}	decreasing	SP-P1	SP	2	16	12
1163	RadFan2SrvAmpSpeed_0_path1_T_C_OP190	5000	4500	{}	decreasing	A0-P1	X	2	16	12
1164	RadFan2SrvAmpSpeed_1_path1_T_C_OP190	5000	4500	{}	decreasing	A1-P1	A	2	16	12
1165	RadFan2SrvAmpSpeed_2_path1_T_C_OP190	5000	4500	{}	decreasing	A2-P1	B	2	16	12
1166	RadFan2SrvAmpSpeed_3_path1_T_C_OP190	5000	4500	{}	decreasing	A3-P1	C	2	16	12
1171	ApcBatLow_0_path1_T_C_OP190	NaN	NaN	{}	bool	A0-P1	X	6	1	12
1172	ApcBatLow_1_path1_T_C_OP190	NaN	NaN	{}	bool	A1-P1	A	6	1	12
1173	ApcBatLow_2_path1_T_C_OP190	NaN	NaN	{}	bool	A2-P1	B	6	1	12
1174	ApcBatLow_3_path1_T_C_OP190	NaN	NaN	{}	bool	A3-P1	C	6	1	12
1179	CncBatLow_0_path1_T_C_OP190	NaN	NaN	{}	bool	A0-P1	X	6	2	12
1180	CncBatLow_1_path1_T_C_OP190	NaN	NaN	{}	bool	A1-P1	A	6	2	12
1181	CncBatLow_2_path1_T_C_OP190	NaN	NaN	{}	bool	A2-P1	B	6	2	12
1182	CncBatLow_3_path1_T_C_OP190	NaN	NaN	{}	bool	A3-P1	C	6	2	12
1187	ServoLeakResistData_0_path1_T_C_OP190	50	30	{}	decreasing	A0-P1	X	15	5	12
1188	ServoLeakResistData_1_path1_T_C_OP190	50	30	{}	decreasing	A1-P1	A	15	5	12
1189	ServoLeakResistData_2_path1_T_C_OP190	50	30	{}	decreasing	A2-P1	B	15	5	12
1190	ServoLeakResistData_3_path1_T_C_OP190	50	30	{}	decreasing	A3-P1	C	15	5	12
1195	SpindleLeakResistData_0_path1_T_C_OP190	50	30	{}	decreasing	SP-P1	SP	15	5	12
1196	InFan1SrvComPwSpeed_0_path1_T_C_OP190	6200	6000	{}	decreasing	A0-P1	X	2	9	12
1197	InFan1SrvComPwSpeed_1_path1_T_C_OP190	6200	6000	{}	decreasing	A1-P1	A	2	9	12
1198	InFan1SrvComPwSpeed_2_path1_T_C_OP190	6200	6000	{}	decreasing	A2-P1	B	2	9	12
1199	InFan1SrvComPwSpeed_3_path1_T_C_OP190	6200	6000	{}	decreasing	A3-P1	C	2	9	12
1204	InFan2SrvAmpSpeed_0_path1_T_C_OP190	5000	4500	{}	decreasing	A0-P1	X	2	11	12
1205	InFan2SrvAmpSpeed_1_path1_T_C_OP190	5000	4500	{}	decreasing	A1-P1	A	2	11	12
1206	InFan2SrvAmpSpeed_2_path1_T_C_OP190	5000	4500	{}	decreasing	A2-P1	B	2	11	12
1207	InFan2SrvAmpSpeed_3_path1_T_C_OP190	5000	4500	{}	decreasing	A3-P1	C	2	11	12
1212	RadFan1SpindleAmpSpeed_0_path1_T_C_OP190	5000	4500	{}	decreasing	SP-P1	SP	2	15	12
1213	RadFan1SrvAmpSpeed_0_path1_T_C_OP190	5000	4500	{}	decreasing	A0-P1	X	2	15	12
1214	RadFan1SrvAmpSpeed_1_path1_T_C_OP190	5000	4500	{}	decreasing	A1-P1	A	2	15	12
1215	RadFan1SrvAmpSpeed_2_path1_T_C_OP190	5000	4500	{}	decreasing	A2-P1	B	2	15	12
1216	RadFan1SrvAmpSpeed_3_path1_T_C_OP190	5000	4500	{}	decreasing	A3-P1	C	2	15	12
1221	InFan2SpdlComPwSpeed_0_path1_T_C_OP190	5000	4500	{}	decreasing	A0-P1	SAS	2	10	12
1222	InFan2SpindleAmpSpeed_0_path1_T_C_OP190	5000	4500	{}	decreasing	A0-P1	SCS	2	10	12
1223	InFan2SrvComPwSpeed_0_path1_T_C_OP190	5000	4500	{}	decreasing	A0-P1	X	2	12	12
1224	InFan2SrvComPwSpeed_1_path1_T_C_OP190	5000	4500	{}	decreasing	A1-P1	A	2	12	12
1225	InFan2SrvComPwSpeed_2_path1_T_C_OP190	5000	4500	{}	decreasing	A2-P1	B	2	12	12
1226	InFan2SrvComPwSpeed_3_path1_T_C_OP190	5000	4500	{}	decreasing	A3-P1	C	2	12	12
1231	InFan1SpdlComPwSpeed_0_path1_T_C_OP190	5000	4500	{}	decreasing	A0-P1	SAS	2	7	12
1232	InFan1SpindleAmpSpeed_0_path1_T_C_OP190	5000	4500	{}	decreasing	A0-P1	SCS	2	7	12
1233	ServoTemp_0_path1_T_C_OP190	60	70	{}	increasing	A0-P1	X	13	3	12
1234	ServoTemp_1_path1_T_C_OP190	55	70	{}	increasing	A1-P1	A	13	3	12
1235	ServoTemp_2_path1_T_C_OP190	55	70	{}	increasing	A2-P1	B	13	3	12
1236	ServoTemp_3_path1_T_C_OP190	55	70	{}	increasing	A3-P1	C	13	3	12
1241	SpindleTemp_0_path1_T_C_OP190	80	100	{}	increasing	SP-P1	SP	13	3	12
1242	PulseCoderTemp_0_path1_T_C_OP30	60	80	{}	increasing	A0-P1	X	13	4	13
1243	PulseCoderTemp_1_path1_T_C_OP30	60	80	{}	increasing	A1-P1	Z	13	4	13
1246	PulseCoderTemp_4_path1_T_C_OP30	60	80	{}	increasing	A4-P1	B	13	4	13
1247	PulseCoderTemp_5_path1_T_C_OP30	60	80	{}	increasing	A5-P1	C	13	4	13
1248	PulseCoderTemp_6_path1_T_C_OP30	60	80	{}	increasing	A6-P1	U	13	4	13
1249	CncFan1Speed_path1_T_C_OP30	4500	4000	{}	decreasing	A1-P1	F1	16	6	13
1250	CncFan2Speed_path1_T_C_OP30	9600	8600	{}	decreasing	A2-P1	F2	16	6	13
1253	InFan1SrvAmpSpeed_0_path1_T_C_OP30	8000	7000	{}	decreasing	A0-P1	X	2	8	13
1254	InFan1SrvAmpSpeed_1_path1_T_C_OP30	8000	7500	{}	decreasing	A1-P1	Z	2	8	13
1257	InFan1SrvAmpSpeed_4_path1_T_C_OP30	8500	7500	{}	decreasing	A4-P1	B	2	8	13
1258	InFan1SrvAmpSpeed_5_path1_T_C_OP30	8500	7500	{}	decreasing	A5-P1	C	2	8	13
1259	InFan1SrvAmpSpeed_6_path1_T_C_OP30	8000	7500	{}	decreasing	A6-P1	U	2	8	13
1260	ServoLoad_0_path1_T_C_OP30	NaN	NaN	{}	increasing	A0-P1	X	17	17	13
1261	ServoLoad_1_path1_T_C_OP30	NaN	NaN	{}	increasing	A1-P1	Z	17	17	13
1264	ServoLoad_4_path1_T_C_OP30	NaN	NaN	{}	increasing	A4-P1	B	17	17	13
1265	ServoLoad_5_path1_T_C_OP30	NaN	NaN	{}	increasing	A5-P1	C	17	17	13
1266	ServoLoad_6_path1_T_C_OP30	NaN	NaN	{}	increasing	A6-P1	U	17	17	13
1267	SpindleLoad_0_path1_T_C_OP30	NaN	NaN	{}	increasing	SP-P1	SP	17	17	13
1268	SpdBatZero_0_path1_T_C_OP30	NaN	NaN	{}	bool	A0-P1	X	6	13	13
1269	SpdBatZero_1_path1_T_C_OP30	NaN	NaN	{}	bool	A1-P1	Z	6	13	13
1272	SpdBatZero_4_path1_T_C_OP30	NaN	NaN	{}	bool	A4-P1	B	6	13	13
1273	SpdBatZero_5_path1_T_C_OP30	NaN	NaN	{}	bool	A5-P1	C	6	13	13
1274	SpdBatZero_6_path1_T_C_OP30	NaN	NaN	{}	bool	A6-P1	U	6	13	13
1275	SSpdBatZero_0_path1_T_C_OP30	NaN	NaN	{}	bool	A0-P1	X	6	14	13
1276	SSpdBatZero_1_path1_T_C_OP30	NaN	NaN	{}	bool	A1-P1	Z	6	14	13
1279	SSpdBatZero_4_path1_T_C_OP30	NaN	NaN	{}	bool	A4-P1	B	6	14	13
1280	SSpdBatZero_5_path1_T_C_OP30	NaN	NaN	{}	bool	A5-P1	C	6	14	13
1281	SSpdBatZero_6_path1_T_C_OP30	NaN	NaN	{}	bool	A6-P1	U	6	14	13
1282	RadFan2SpindleAmpSpeed_0_path1_T_C_OP30	5000	4500	{}	decreasing	SP-P1	SP	2	16	13
1283	RadFan2SrvAmpSpeed_0_path1_T_C_OP30	5000	4500	{}	decreasing	A0-P1	X	2	16	13
1284	RadFan2SrvAmpSpeed_1_path1_T_C_OP30	5000	4500	{}	decreasing	A1-P1	Z	2	16	13
1287	RadFan2SrvAmpSpeed_4_path1_T_C_OP30	5000	4500	{}	decreasing	A4-P1	B	2	16	13
1288	RadFan2SrvAmpSpeed_5_path1_T_C_OP30	5000	4500	{}	decreasing	A5-P1	C	2	16	13
1289	RadFan2SrvAmpSpeed_6_path1_T_C_OP30	5000	4500	{}	decreasing	A6-P1	U	2	16	13
1290	ApcBatLow_0_path1_T_C_OP30	NaN	NaN	{}	bool	A0-P1	X	6	1	13
1291	ApcBatLow_1_path1_T_C_OP30	NaN	NaN	{}	bool	A1-P1	Z	6	1	13
1294	ApcBatLow_4_path1_T_C_OP30	NaN	NaN	{}	bool	A4-P1	B	6	1	13
1295	ApcBatLow_5_path1_T_C_OP30	NaN	NaN	{}	bool	A5-P1	C	6	1	13
1296	ApcBatLow_6_path1_T_C_OP30	NaN	NaN	{}	bool	A6-P1	U	6	1	13
1297	CncBatLow_0_path1_T_C_OP30	NaN	NaN	{}	bool	A0-P1	X	6	2	13
1298	CncBatLow_1_path1_T_C_OP30	NaN	NaN	{}	bool	A1-P1	Z	6	2	13
1301	CncBatLow_4_path1_T_C_OP30	NaN	NaN	{}	bool	A4-P1	B	6	2	13
1302	CncBatLow_5_path1_T_C_OP30	NaN	NaN	{}	bool	A5-P1	C	6	2	13
1303	CncBatLow_6_path1_T_C_OP30	NaN	NaN	{}	bool	A6-P1	U	6	2	13
1304	ServoLeakResistData_0_path1_T_C_OP30	50	30	{}	decreasing	A0-P1	X	15	5	13
1305	ServoLeakResistData_1_path1_T_C_OP30	50	30	{}	decreasing	A1-P1	Z	15	5	13
1308	ServoLeakResistData_4_path1_T_C_OP30	50	30	{}	decreasing	A4-P1	B	15	5	13
1309	ServoLeakResistData_5_path1_T_C_OP30	50	30	{}	decreasing	A5-P1	C	15	5	13
1310	ServoLeakResistData_6_path1_T_C_OP30	50	30	{}	decreasing	A6-P1	U	15	5	13
1311	SpindleLeakResistData_0_path1_T_C_OP30	50	30	{}	decreasing	SP-P1	SP	15	5	13
1312	InFan1SrvComPwSpeed_0_path1_T_C_OP30	6200	6000	{}	decreasing	A0-P1	X	2	9	13
1313	InFan1SrvComPwSpeed_1_path1_T_C_OP30	6200	6000	{}	decreasing	A1-P1	Z	2	9	13
1316	InFan1SrvComPwSpeed_4_path1_T_C_OP30	6200	6000	{}	decreasing	A4-P1	B	2	9	13
1317	InFan1SrvComPwSpeed_5_path1_T_C_OP30	6200	6000	{}	decreasing	A5-P1	C	2	9	13
1318	InFan1SrvComPwSpeed_6_path1_T_C_OP30	6200	6000	{}	decreasing	A6-P1	U	2	9	13
1319	InFan2SrvAmpSpeed_0_path1_T_C_OP30	5000	4500	{}	decreasing	A0-P1	X	2	11	13
1320	InFan2SrvAmpSpeed_1_path1_T_C_OP30	5000	4500	{}	decreasing	A1-P1	Z	2	11	13
1323	InFan2SrvAmpSpeed_4_path1_T_C_OP30	5000	4500	{}	decreasing	A4-P1	B	2	11	13
1324	InFan2SrvAmpSpeed_5_path1_T_C_OP30	5000	4500	{}	decreasing	A5-P1	C	2	11	13
1325	InFan2SrvAmpSpeed_6_path1_T_C_OP30	5000	4500	{}	decreasing	A6-P1	U	2	11	13
1326	RadFan1SpindleAmpSpeed_0_path1_T_C_OP30	5000	4500	{}	decreasing	SP-P1	SP	2	15	13
1327	RadFan1SrvAmpSpeed_0_path1_T_C_OP30	5000	4500	{}	decreasing	A0-P1	X	2	15	13
1328	RadFan1SrvAmpSpeed_1_path1_T_C_OP30	5000	4500	{}	decreasing	A1-P1	Z	2	15	13
1331	RadFan1SrvAmpSpeed_4_path1_T_C_OP30	5000	4500	{}	decreasing	A4-P1	B	2	15	13
1332	RadFan1SrvAmpSpeed_5_path1_T_C_OP30	5000	4500	{}	decreasing	A5-P1	C	2	15	13
1333	RadFan1SrvAmpSpeed_6_path1_T_C_OP30	5000	4500	{}	decreasing	A6-P1	U	2	15	13
1334	InFan2SpdlComPwSpeed_0_path1_T_C_OP30	5000	4500	{}	decreasing	A0-P1	SAS	2	10	13
1335	InFan2SpindleAmpSpeed_0_path1_T_C_OP30	5000	4500	{}	decreasing	A0-P1	SCS	2	10	13
1336	InFan2SrvComPwSpeed_0_path1_T_C_OP30	5000	4500	{}	decreasing	A0-P1	X	2	12	13
1337	InFan2SrvComPwSpeed_1_path1_T_C_OP30	5000	4500	{}	decreasing	A1-P1	Z	2	12	13
1340	InFan2SrvComPwSpeed_4_path1_T_C_OP30	5000	4500	{}	decreasing	A4-P1	B	2	12	13
1341	InFan2SrvComPwSpeed_5_path1_T_C_OP30	5000	4500	{}	decreasing	A5-P1	C	2	12	13
1342	InFan2SrvComPwSpeed_6_path1_T_C_OP30	5000	4500	{}	decreasing	A6-P1	U	2	12	13
1343	InFan1SpdlComPwSpeed_0_path1_T_C_OP30	5000	4500	{}	decreasing	A0-P1	SAS	2	7	13
1344	InFan1SpindleAmpSpeed_0_path1_T_C_OP30	6200	6000	{}	decreasing	A0-P1	SCS	2	7	13
1345	ServoTemp_0_path1_T_C_OP30	55	70	{}	increasing	A0-P1	X	13	3	13
1346	ServoTemp_1_path1_T_C_OP30	55	70	{}	increasing	A1-P1	Z	13	3	13
1349	ServoTemp_4_path1_T_C_OP30	55	70	{}	increasing	A4-P1	B	13	3	13
1350	ServoTemp_5_path1_T_C_OP30	55	70	{}	increasing	A5-P1	C	13	3	13
1351	ServoTemp_6_path1_T_C_OP30	55	70	{}	increasing	A6-P1	U	13	3	13
1352	SpindleTemp_0_path1_T_C_OP30	80	100	{}	increasing	SP-P1	SP	13	3	13
1353	PulseCoderTemp_0_path1_T_C_OP40	60	80	{}	increasing	A0-P1	X	13	4	14
1354	PulseCoderTemp_1_path1_T_C_OP40	70	80	{}	increasing	A1-P1	Y	13	4	14
1355	PulseCoderTemp_2_path1_T_C_OP40	65	80	{}	increasing	A2-P1	Z	13	4	14
1356	PulseCoderTemp_3_path1_T_C_OP40	60	80	{}	increasing	A3-P1	W	13	4	14
1357	PulseCoderTemp_4_path1_T_C_OP40	60	80	{}	increasing	A4-P1	A	13	4	14
1358	PulseCoderTemp_5_path1_T_C_OP40	60	80	{}	increasing	A5-P1	B	13	4	14
1359	CncFan1Speed_path1_T_C_OP40	4500	4000	{}	decreasing	A1-P1	F1	16	6	14
1360	CncFan2Speed_path1_T_C_OP40	9600	8600	{}	decreasing	A2-P1	F2	16	6	14
1363	InFan1SrvAmpSpeed_0_path1_T_C_OP40	9500	9000	{}	decreasing	A0-P1	X	2	8	14
1364	InFan1SrvAmpSpeed_1_path1_T_C_OP40	9500	9000	{}	decreasing	A1-P1	Y	2	8	14
1365	InFan1SrvAmpSpeed_2_path1_T_C_OP40	9500	9000	{}	decreasing	A2-P1	Z	2	8	14
1366	InFan1SrvAmpSpeed_3_path1_T_C_OP40	9500	9000	{}	decreasing	A3-P1	W	2	8	14
1367	InFan1SrvAmpSpeed_4_path1_T_C_OP40	8500	7500	{}	decreasing	A4-P1	A	2	8	14
1368	InFan1SrvAmpSpeed_5_path1_T_C_OP40	8500	7500	{}	decreasing	A5-P1	B	2	8	14
1369	ServoLoad_0_path1_T_C_OP40	NaN	NaN	{}	increasing	A0-P1	X	17	17	14
1370	ServoLoad_1_path1_T_C_OP40	NaN	NaN	{}	increasing	A1-P1	Y	17	17	14
1371	ServoLoad_2_path1_T_C_OP40	NaN	NaN	{}	increasing	A2-P1	Z	17	17	14
1372	ServoLoad_3_path1_T_C_OP40	NaN	NaN	{}	increasing	A3-P1	W	17	17	14
1373	ServoLoad_4_path1_T_C_OP40	NaN	NaN	{}	increasing	A4-P1	A	17	17	14
1374	ServoLoad_5_path1_T_C_OP40	NaN	NaN	{}	increasing	A5-P1	B	17	17	14
1375	SpindleLoad_0_path1_T_C_OP40	NaN	NaN	{}	increasing	SP-P1	SP	17	17	14
1376	SpdBatZero_0_path1_T_C_OP40	NaN	NaN	{}	bool	A0-P1	X	6	13	14
1377	SpdBatZero_1_path1_T_C_OP40	NaN	NaN	{}	bool	A1-P1	Y	6	13	14
1378	SpdBatZero_2_path1_T_C_OP40	NaN	NaN	{}	bool	A2-P1	Z	6	13	14
1379	SpdBatZero_3_path1_T_C_OP40	NaN	NaN	{}	bool	A3-P1	W	6	13	14
1380	SpdBatZero_4_path1_T_C_OP40	NaN	NaN	{}	bool	A4-P1	A	6	13	14
1381	SpdBatZero_5_path1_T_C_OP40	NaN	NaN	{}	bool	A5-P1	B	6	13	14
1382	SSpdBatZero_0_path1_T_C_OP40	NaN	NaN	{}	bool	A0-P1	X	6	14	14
1383	SSpdBatZero_1_path1_T_C_OP40	NaN	NaN	{}	bool	A1-P1	Y	6	14	14
1384	SSpdBatZero_2_path1_T_C_OP40	NaN	NaN	{}	bool	A2-P1	Z	6	14	14
1385	SSpdBatZero_3_path1_T_C_OP40	NaN	NaN	{}	bool	A3-P1	W	6	14	14
1386	SSpdBatZero_4_path1_T_C_OP40	NaN	NaN	{}	bool	A4-P1	A	6	14	14
1387	SSpdBatZero_5_path1_T_C_OP40	NaN	NaN	{}	bool	A5-P1	B	6	14	14
1388	RadFan2SpindleAmpSpeed_0_path1_T_C_OP40	5000	4500	{}	decreasing	SP-P1	SP	2	16	14
1389	RadFan2SrvAmpSpeed_0_path1_T_C_OP40	5000	4500	{}	decreasing	A0-P1	X	2	16	14
1390	RadFan2SrvAmpSpeed_1_path1_T_C_OP40	5000	4500	{}	decreasing	A1-P1	Y	2	16	14
1391	RadFan2SrvAmpSpeed_2_path1_T_C_OP40	5000	4500	{}	decreasing	A2-P1	Z	2	16	14
1392	RadFan2SrvAmpSpeed_3_path1_T_C_OP40	5000	4500	{}	decreasing	A3-P1	W	2	16	14
1393	RadFan2SrvAmpSpeed_4_path1_T_C_OP40	5000	4500	{}	decreasing	A4-P1	A	2	16	14
1394	RadFan2SrvAmpSpeed_5_path1_T_C_OP40	5000	4500	{}	decreasing	A5-P1	B	2	16	14
1395	ApcBatLow_0_path1_T_C_OP40	NaN	NaN	{}	bool	A0-P1	X	6	1	14
1396	ApcBatLow_1_path1_T_C_OP40	NaN	NaN	{}	bool	A1-P1	Y	6	1	14
1397	ApcBatLow_2_path1_T_C_OP40	NaN	NaN	{}	bool	A2-P1	Z	6	1	14
1398	ApcBatLow_3_path1_T_C_OP40	NaN	NaN	{}	bool	A3-P1	W	6	1	14
1399	ApcBatLow_4_path1_T_C_OP40	NaN	NaN	{}	bool	A4-P1	A	6	1	14
1400	ApcBatLow_5_path1_T_C_OP40	NaN	NaN	{}	bool	A5-P1	B	6	1	14
1401	CncBatLow_0_path1_T_C_OP40	NaN	NaN	{}	bool	A0-P1	X	6	2	14
1402	CncBatLow_1_path1_T_C_OP40	NaN	NaN	{}	bool	A1-P1	Y	6	2	14
1403	CncBatLow_2_path1_T_C_OP40	NaN	NaN	{}	bool	A2-P1	Z	6	2	14
1404	CncBatLow_3_path1_T_C_OP40	NaN	NaN	{}	bool	A3-P1	W	6	2	14
1405	CncBatLow_4_path1_T_C_OP40	NaN	NaN	{}	bool	A4-P1	A	6	2	14
1406	CncBatLow_5_path1_T_C_OP40	NaN	NaN	{}	bool	A5-P1	B	6	2	14
1407	ServoLeakResistData_0_path1_T_C_OP40	50	30	{}	decreasing	A0-P1	X	15	5	14
1408	ServoLeakResistData_1_path1_T_C_OP40	50	30	{}	decreasing	A1-P1	Y	15	5	14
1409	ServoLeakResistData_2_path1_T_C_OP40	50	30	{}	decreasing	A2-P1	Z	15	5	14
1410	ServoLeakResistData_3_path1_T_C_OP40	50	30	{}	decreasing	A3-P1	W	15	5	14
1411	ServoLeakResistData_4_path1_T_C_OP40	50	30	{}	decreasing	A4-P1	A	15	5	14
1412	ServoLeakResistData_5_path1_T_C_OP40	50	30	{}	decreasing	A5-P1	B	15	5	14
1413	SpindleLeakResistData_0_path1_T_C_OP40	50	30	{}	decreasing	SP-P1	SP	15	5	14
1414	InFan1SrvComPwSpeed_0_path1_T_C_OP40	6200	6000	{}	decreasing	A0-P1	X	2	9	14
1415	InFan1SrvComPwSpeed_1_path1_T_C_OP40	6200	6000	{}	decreasing	A1-P1	Y	2	9	14
1416	InFan1SrvComPwSpeed_2_path1_T_C_OP40	6200	6000	{}	decreasing	A2-P1	Z	2	9	14
1417	InFan1SrvComPwSpeed_3_path1_T_C_OP40	6200	6000	{}	decreasing	A3-P1	W	2	9	14
1418	InFan1SrvComPwSpeed_4_path1_T_C_OP40	6200	6000	{}	decreasing	A4-P1	A	2	9	14
1419	InFan1SrvComPwSpeed_5_path1_T_C_OP40	6200	6000	{}	decreasing	A5-P1	B	2	9	14
1420	InFan2SrvAmpSpeed_0_path1_T_C_OP40	5000	4500	{}	decreasing	A0-P1	X	2	11	14
1421	InFan2SrvAmpSpeed_1_path1_T_C_OP40	5000	4500	{}	decreasing	A1-P1	Y	2	11	14
1422	InFan2SrvAmpSpeed_2_path1_T_C_OP40	5000	4500	{}	decreasing	A2-P1	Z	2	11	14
1423	InFan2SrvAmpSpeed_3_path1_T_C_OP40	5000	4500	{}	decreasing	A3-P1	W	2	11	14
1424	InFan2SrvAmpSpeed_4_path1_T_C_OP40	5000	4500	{}	decreasing	A4-P1	A	2	11	14
1425	InFan2SrvAmpSpeed_5_path1_T_C_OP40	5000	4500	{}	decreasing	A5-P1	B	2	11	14
1426	RadFan1SpindleAmpSpeed_0_path1_T_C_OP40	5000	4500	{}	decreasing	SP-P1	SP	2	15	14
1427	RadFan1SrvAmpSpeed_0_path1_T_C_OP40	5000	4500	{}	decreasing	A0-P1	X	2	15	14
1428	RadFan1SrvAmpSpeed_1_path1_T_C_OP40	5000	4500	{}	decreasing	A1-P1	Y	2	15	14
1429	RadFan1SrvAmpSpeed_2_path1_T_C_OP40	5000	4500	{}	decreasing	A2-P1	Z	2	15	14
1430	RadFan1SrvAmpSpeed_3_path1_T_C_OP40	5000	4500	{}	decreasing	A3-P1	W	2	15	14
1431	RadFan1SrvAmpSpeed_4_path1_T_C_OP40	5000	4500	{}	decreasing	A4-P1	A	2	15	14
1432	RadFan1SrvAmpSpeed_5_path1_T_C_OP40	5000	4500	{}	decreasing	A5-P1	B	2	15	14
1433	InFan2SpdlComPwSpeed_0_path1_T_C_OP40	5000	4500	{}	decreasing	A0-P1	SAS	2	10	14
1434	InFan2SpindleAmpSpeed_0_path1_T_C_OP40	5000	4500	{}	decreasing	A0-P1	SCS	2	10	14
1435	InFan2SrvComPwSpeed_0_path1_T_C_OP40	5000	4500	{}	decreasing	A0-P1	X	2	12	14
1436	InFan2SrvComPwSpeed_1_path1_T_C_OP40	5000	4500	{}	decreasing	A1-P1	Y	2	12	14
1437	InFan2SrvComPwSpeed_2_path1_T_C_OP40	5000	4500	{}	decreasing	A2-P1	Z	2	12	14
1438	InFan2SrvComPwSpeed_3_path1_T_C_OP40	5000	4500	{}	decreasing	A3-P1	W	2	12	14
1439	InFan2SrvComPwSpeed_4_path1_T_C_OP40	5000	4500	{}	decreasing	A4-P1	A	2	12	14
1440	InFan2SrvComPwSpeed_5_path1_T_C_OP40	5000	4500	{}	decreasing	A5-P1	B	2	12	14
1441	InFan1SpdlComPwSpeed_0_path1_T_C_OP40	5000	4500	{}	decreasing	A0-P1	SAS	2	7	14
1442	InFan1SpindleAmpSpeed_0_path1_T_C_OP40	6200	6000	{}	decreasing	A0-P1	SCS	2	7	14
1443	ServoTemp_0_path1_T_C_OP40	55	70	{}	increasing	A0-P1	X	13	3	14
1444	ServoTemp_1_path1_T_C_OP40	55	70	{}	increasing	A1-P1	Y	13	3	14
1445	ServoTemp_2_path1_T_C_OP40	65	75	{}	increasing	A2-P1	Z	13	3	14
1446	ServoTemp_3_path1_T_C_OP40	55	70	{}	increasing	A3-P1	W	13	3	14
1447	ServoTemp_4_path1_T_C_OP40	55	70	{}	increasing	A4-P1	A	13	3	14
1448	ServoTemp_5_path1_T_C_OP40	55	70	{}	increasing	A5-P1	B	13	3	14
1449	SpindleTemp_0_path1_T_C_OP40	80	100	{}	increasing	SP-P1	SP	13	3	14
1450	PulseCoderTemp_0_path1_T_C_OP90	60	80	{}	increasing	A0-P1	X	13	4	15
1451	PulseCoderTemp_1_path1_T_C_OP90	75	80	{}	increasing	A1-P1	Y	13	4	15
1452	PulseCoderTemp_2_path1_T_C_OP90	70	80	{}	increasing	A2-P1	Z	13	4	15
1453	PulseCoderTemp_3_path1_T_C_OP90	70	80	{}	increasing	A3-P1	W	13	4	15
1454	PulseCoderTemp_4_path1_T_C_OP90	60	80	{}	increasing	A4-P1	A	13	4	15
1455	CncFan1Speed_path1_T_C_OP90	4500	4000	{}	decreasing	A1-P1	F1	16	6	15
1456	CncFan2Speed_path1_T_C_OP90	9600	8600	{}	decreasing	A2-P1	F2	16	6	15
1459	InFan1SrvAmpSpeed_0_path1_T_C_OP90	9500	9000	{}	decreasing	A0-P1	X	2	8	15
1460	InFan1SrvAmpSpeed_1_path1_T_C_OP90	9500	9000	{}	decreasing	A1-P1	Y	2	8	15
1461	InFan1SrvAmpSpeed_2_path1_T_C_OP90	9500	9000	{}	decreasing	A2-P1	Z	2	8	15
1462	InFan1SrvAmpSpeed_3_path1_T_C_OP90	9500	9000	{}	decreasing	A3-P1	W	2	8	15
1463	InFan1SrvAmpSpeed_4_path1_T_C_OP90	8500	7500	{}	decreasing	A4-P1	A	2	8	15
1464	ServoLoad_0_path1_T_C_OP90	NaN	NaN	{}	increasing	A0-P1	X	17	17	15
1465	ServoLoad_1_path1_T_C_OP90	NaN	NaN	{}	increasing	A1-P1	Y	17	17	15
1466	ServoLoad_2_path1_T_C_OP90	NaN	NaN	{}	increasing	A2-P1	Z	17	17	15
1467	ServoLoad_3_path1_T_C_OP90	NaN	NaN	{}	increasing	A3-P1	W	17	17	15
1468	ServoLoad_4_path1_T_C_OP90	NaN	NaN	{}	increasing	A4-P1	A	17	17	15
1469	SpindleLoad_0_path1_T_C_OP90	NaN	NaN	{}	increasing	SP-P1	SP	17	17	15
1470	SpdBatZero_0_path1_T_C_OP90	NaN	NaN	{}	bool	A0-P1	X	6	13	15
1471	SpdBatZero_1_path1_T_C_OP90	NaN	NaN	{}	bool	A1-P1	Y	6	13	15
1472	SpdBatZero_2_path1_T_C_OP90	NaN	NaN	{}	bool	A2-P1	Z	6	13	15
1473	SpdBatZero_3_path1_T_C_OP90	NaN	NaN	{}	bool	A3-P1	W	6	13	15
1474	SpdBatZero_4_path1_T_C_OP90	NaN	NaN	{}	bool	A4-P1	A	6	13	15
1475	SSpdBatZero_0_path1_T_C_OP90	NaN	NaN	{}	bool	A0-P1	X	6	14	15
1476	SSpdBatZero_1_path1_T_C_OP90	NaN	NaN	{}	bool	A1-P1	Y	6	14	15
1477	SSpdBatZero_2_path1_T_C_OP90	NaN	NaN	{}	bool	A2-P1	Z	6	14	15
1478	SSpdBatZero_3_path1_T_C_OP90	NaN	NaN	{}	bool	A3-P1	W	6	14	15
1479	SSpdBatZero_4_path1_T_C_OP90	NaN	NaN	{}	bool	A4-P1	A	6	14	15
1480	RadFan2SpindleAmpSpeed_0_path1_T_C_OP90	5000	4500	{}	decreasing	SP-P1	SP	2	16	15
1481	RadFan2SrvAmpSpeed_0_path1_T_C_OP90	5000	4500	{}	decreasing	A0-P1	X	2	16	15
1482	RadFan2SrvAmpSpeed_1_path1_T_C_OP90	5000	4500	{}	decreasing	A1-P1	Y	2	16	15
1483	RadFan2SrvAmpSpeed_2_path1_T_C_OP90	5000	4500	{}	decreasing	A2-P1	Z	2	16	15
1484	RadFan2SrvAmpSpeed_3_path1_T_C_OP90	5000	4500	{}	decreasing	A3-P1	W	2	16	15
1485	RadFan2SrvAmpSpeed_4_path1_T_C_OP90	5000	4500	{}	decreasing	A4-P1	A	2	16	15
1486	ApcBatLow_0_path1_T_C_OP90	NaN	NaN	{}	bool	A0-P1	X	6	1	15
1487	ApcBatLow_1_path1_T_C_OP90	NaN	NaN	{}	bool	A1-P1	Y	6	1	15
1488	ApcBatLow_2_path1_T_C_OP90	NaN	NaN	{}	bool	A2-P1	Z	6	1	15
1489	ApcBatLow_3_path1_T_C_OP90	NaN	NaN	{}	bool	A3-P1	W	6	1	15
1490	ApcBatLow_4_path1_T_C_OP90	NaN	NaN	{}	bool	A4-P1	A	6	1	15
1491	CncBatLow_0_path1_T_C_OP90	NaN	NaN	{}	bool	A0-P1	X	6	2	15
1492	CncBatLow_1_path1_T_C_OP90	NaN	NaN	{}	bool	A1-P1	Y	6	2	15
1493	CncBatLow_2_path1_T_C_OP90	NaN	NaN	{}	bool	A2-P1	Z	6	2	15
1494	CncBatLow_3_path1_T_C_OP90	NaN	NaN	{}	bool	A3-P1	W	6	2	15
1495	CncBatLow_4_path1_T_C_OP90	NaN	NaN	{}	bool	A4-P1	A	6	2	15
1496	ServoLeakResistData_0_path1_T_C_OP90	50	30	{}	decreasing	SP-P1	SP	15	5	15
1497	ServoLeakResistData_1_path1_T_C_OP90	50	30	{}	decreasing	A0-P1	X	15	5	15
1498	ServoLeakResistData_2_path1_T_C_OP90	50	30	{}	decreasing	A1-P1	Y	15	5	15
1499	ServoLeakResistData_3_path1_T_C_OP90	50	30	{}	decreasing	A2-P1	Z	15	5	15
1500	ServoLeakResistData_4_path1_T_C_OP90	31	30	{}	decreasing	A3-P1	W	15	5	15
1501	SpindleLeakResistData_0_path1_T_C_OP90	50	30	{}	decreasing	A4-P1	A	15	5	15
1502	InFan1SrvComPwSpeed_0_path1_T_C_OP90	6200	6000	{}	decreasing	A0-P1	X	2	9	15
1503	InFan1SrvComPwSpeed_1_path1_T_C_OP90	6200	6000	{}	decreasing	A1-P1	Y	2	9	15
1504	InFan1SrvComPwSpeed_2_path1_T_C_OP90	6200	6000	{}	decreasing	A2-P1	Z	2	9	15
1505	InFan1SrvComPwSpeed_3_path1_T_C_OP90	6200	6000	{}	decreasing	A3-P1	W	2	9	15
1506	InFan1SrvComPwSpeed_4_path1_T_C_OP90	6200	6000	{}	decreasing	A4-P1	A	2	9	15
1507	InFan2SrvAmpSpeed_0_path1_T_C_OP90	5000	4500	{}	decreasing	A0-P1	X	2	11	15
1508	InFan2SrvAmpSpeed_1_path1_T_C_OP90	5000	4500	{}	decreasing	A1-P1	Y	2	11	15
1509	InFan2SrvAmpSpeed_2_path1_T_C_OP90	5000	4500	{}	decreasing	A2-P1	Z	2	11	15
1510	InFan2SrvAmpSpeed_3_path1_T_C_OP90	5000	4500	{}	decreasing	A3-P1	W	2	11	15
1511	InFan2SrvAmpSpeed_4_path1_T_C_OP90	5000	4500	{}	decreasing	A4-P1	A	2	11	15
1512	RadFan1SpindleAmpSpeed_0_path1_T_C_OP90	5000	4500	{}	decreasing	SP-P1	SP	2	15	15
1513	RadFan1SrvAmpSpeed_0_path1_T_C_OP90	5000	4500	{}	decreasing	A0-P1	X	2	15	15
1514	RadFan1SrvAmpSpeed_1_path1_T_C_OP90	5000	4500	{}	decreasing	A1-P1	Y	2	15	15
1515	RadFan1SrvAmpSpeed_2_path1_T_C_OP90	5000	4500	{}	decreasing	A2-P1	Z	2	15	15
1516	RadFan1SrvAmpSpeed_3_path1_T_C_OP90	5000	4500	{}	decreasing	A3-P1	W	2	15	15
1517	RadFan1SrvAmpSpeed_4_path1_T_C_OP90	5000	4500	{}	decreasing	A4-P1	A	2	15	15
1518	InFan2SpdlComPwSpeed_0_path1_T_C_OP90	5000	4500	{}	decreasing	A0-P1	SAS	2	10	15
1519	InFan2SpindleAmpSpeed_0_path1_T_C_OP90	5000	4500	{}	decreasing	A0-P1	SCS	2	10	15
1520	InFan2SrvComPwSpeed_0_path1_T_C_OP90	5000	4500	{}	decreasing	A0-P1	X	2	12	15
1521	InFan2SrvComPwSpeed_1_path1_T_C_OP90	5000	4500	{}	decreasing	A1-P1	Y	2	12	15
1522	InFan2SrvComPwSpeed_2_path1_T_C_OP90	5000	4500	{}	decreasing	A2-P1	Z	2	12	15
1523	InFan2SrvComPwSpeed_3_path1_T_C_OP90	5000	4500	{}	decreasing	A3-P1	W	2	12	15
1524	InFan2SrvComPwSpeed_4_path1_T_C_OP90	5000	4500	{}	decreasing	A4-P1	A	2	12	15
1525	InFan1SpdlComPwSpeed_0_path1_T_C_OP90	5000	4500	{}	decreasing	A0-P1	SAS	2	7	15
1526	InFan1SpindleAmpSpeed_0_path1_T_C_OP90	6200	6000	{}	decreasing	A0-P1	SCS	2	7	15
1527	ServoTemp_0_path1_T_C_OP90	55	70	{}	increasing	SP-P1	SP	13	3	15
1528	ServoTemp_1_path1_T_C_OP90	65	75	{}	increasing	A0-P1	X	13	3	15
1529	ServoTemp_2_path1_T_C_OP90	65	75	{}	increasing	A1-P1	Y	13	3	15
1530	ServoTemp_3_path1_T_C_OP90	60	70	{}	increasing	A2-P1	Z	13	3	15
1531	ServoTemp_4_path1_T_C_OP90	55	70	{}	increasing	A3-P1	W	13	3	15
1532	SpindleTemp_0_path1_T_C_OP90	80	100	{}	increasing	A4-P1	A	13	3	15
1533	PulseCoderTemp_0_path1_T_C_OP910	60	80	{}	increasing	A0-P1	X	13	4	16
1534	PulseCoderTemp_1_path1_T_C_OP910	70	80	{}	increasing	A1-P1	Y	13	4	16
1535	PulseCoderTemp_2_path1_T_C_OP910	60	80	{}	increasing	A2-P1	U	13	4	16
1536	PulseCoderTemp_3_path1_T_C_OP910	60	80	{}	increasing	A3-P1	Z	13	4	16
1537	CncFan1Speed_path1_T_C_OP910	4500	4000	{}	decreasing	A1-P1	F1	16	6	16
1538	CncFan2Speed_path1_T_C_OP910	9600	8600	{}	decreasing	A2-P1	F2	16	6	16
1541	InFan1SrvAmpSpeed_0_path1_T_C_OP910	9500	9000	{}	decreasing	A0-P1	X	2	8	16
1542	InFan1SrvAmpSpeed_1_path1_T_C_OP910	9500	9000	{}	decreasing	A1-P1	Y	2	8	16
1543	InFan1SrvAmpSpeed_2_path1_T_C_OP910	9500	9000	{}	decreasing	A2-P1	U	2	8	16
1544	InFan1SrvAmpSpeed_3_path1_T_C_OP910	9500	9000	{}	decreasing	A3-P1	Z	2	8	16
1545	ServoLoad_0_path1_T_C_OP910	NaN	NaN	{}	increasing	A0-P1	X	17	17	16
1546	ServoLoad_1_path1_T_C_OP910	NaN	NaN	{}	increasing	A1-P1	Y	17	17	16
1547	ServoLoad_2_path1_T_C_OP910	NaN	NaN	{}	increasing	A2-P1	U	17	17	16
1548	ServoLoad_3_path1_T_C_OP910	NaN	NaN	{}	increasing	A3-P1	Z	17	17	16
1549	SpdBatZero_0_path1_T_C_OP910	NaN	NaN	{}	bool	A0-P1	X	6	13	16
1550	SpdBatZero_1_path1_T_C_OP910	NaN	NaN	{}	bool	A1-P1	Y	6	13	16
1551	SpdBatZero_2_path1_T_C_OP910	NaN	NaN	{}	bool	A2-P1	U	6	13	16
1552	SpdBatZero_3_path1_T_C_OP910	NaN	NaN	{}	bool	A3-P1	Z	6	13	16
1553	SSpdBatZero_0_path1_T_C_OP910	NaN	NaN	{}	bool	A0-P1	X	6	14	16
1554	SSpdBatZero_1_path1_T_C_OP910	NaN	NaN	{}	bool	A1-P1	Y	6	14	16
1555	SSpdBatZero_2_path1_T_C_OP910	NaN	NaN	{}	bool	A2-P1	U	6	14	16
1556	SSpdBatZero_3_path1_T_C_OP910	NaN	NaN	{}	bool	A3-P1	Z	6	14	16
1557	RadFan2SrvAmpSpeed_0_path1_T_C_OP910	5000	4500	{}	decreasing	A0-P1	X	2	16	16
1558	RadFan2SrvAmpSpeed_1_path1_T_C_OP910	5000	4500	{}	decreasing	A1-P1	Y	2	16	16
1559	RadFan2SrvAmpSpeed_2_path1_T_C_OP910	5000	4500	{}	decreasing	A2-P1	U	2	16	16
1560	RadFan2SrvAmpSpeed_3_path1_T_C_OP910	5000	4500	{}	decreasing	A3-P1	Z	2	16	16
1561	ApcBatLow_0_path1_T_C_OP910	NaN	NaN	{}	bool	A0-P1	X	6	1	16
1562	ApcBatLow_1_path1_T_C_OP910	NaN	NaN	{}	bool	A1-P1	Y	6	1	16
1563	ApcBatLow_2_path1_T_C_OP910	NaN	NaN	{}	bool	A2-P1	U	6	1	16
1564	ApcBatLow_3_path1_T_C_OP910	NaN	NaN	{}	bool	A3-P1	Z	6	1	16
1565	CncBatLow_0_path1_T_C_OP910	NaN	NaN	{}	bool	A0-P1	X	6	2	16
1566	CncBatLow_1_path1_T_C_OP910	NaN	NaN	{}	bool	A1-P1	Y	6	2	16
1567	CncBatLow_2_path1_T_C_OP910	NaN	NaN	{}	bool	A2-P1	U	6	2	16
1568	CncBatLow_3_path1_T_C_OP910	NaN	NaN	{}	bool	A3-P1	Z	6	2	16
1569	ServoLeakResistData_0_path1_T_C_OP910	50	30	{}	decreasing	A0-P1	X	15	5	16
1570	ServoLeakResistData_1_path1_T_C_OP910	50	30	{}	decreasing	A1-P1	Y	15	5	16
1571	ServoLeakResistData_2_path1_T_C_OP910	50	30	{}	decreasing	A2-P1	U	15	5	16
1572	ServoLeakResistData_3_path1_T_C_OP910	50	30	{}	decreasing	A3-P1	Z	15	5	16
1573	InFan1SrvComPwSpeed_0_path1_T_C_OP910	6200	6000	{}	decreasing	A0-P1	X	2	9	16
1574	InFan1SrvComPwSpeed_1_path1_T_C_OP910	6200	6000	{}	decreasing	A1-P1	Y	2	9	16
1575	InFan1SrvComPwSpeed_2_path1_T_C_OP910	6200	6000	{}	decreasing	A2-P1	U	2	9	16
1576	InFan1SrvComPwSpeed_3_path1_T_C_OP910	6200	6000	{}	decreasing	A3-P1	Z	2	9	16
1577	InFan2SrvAmpSpeed_0_path1_T_C_OP910	5000	4500	{}	decreasing	A0-P1	X	2	11	16
1578	InFan2SrvAmpSpeed_1_path1_T_C_OP910	5000	4500	{}	decreasing	A1-P1	Y	2	11	16
1579	InFan2SrvAmpSpeed_2_path1_T_C_OP910	5000	4500	{}	decreasing	A2-P1	U	2	11	16
1580	InFan2SrvAmpSpeed_3_path1_T_C_OP910	5000	4500	{}	decreasing	A3-P1	Z	2	11	16
1581	RadFan1SrvAmpSpeed_0_path1_T_C_OP910	5000	4500	{}	decreasing	A0-P1	X	2	15	16
1582	RadFan1SrvAmpSpeed_1_path1_T_C_OP910	5000	4500	{}	decreasing	A1-P1	Y	2	15	16
1583	RadFan1SrvAmpSpeed_2_path1_T_C_OP910	5000	4500	{}	decreasing	A2-P1	U	2	15	16
1584	RadFan1SrvAmpSpeed_3_path1_T_C_OP910	5000	4500	{}	decreasing	A3-P1	Z	2	15	16
1585	InFan2SrvComPwSpeed_0_path1_T_C_OP910	5000	4500	{}	decreasing	A0-P1	X	2	12	16
1586	InFan2SrvComPwSpeed_1_path1_T_C_OP910	5000	4500	{}	decreasing	A1-P1	Y	2	12	16
1587	InFan2SrvComPwSpeed_2_path1_T_C_OP910	5000	4500	{}	decreasing	A2-P1	U	2	12	16
1588	InFan2SrvComPwSpeed_3_path1_T_C_OP910	5000	4500	{}	decreasing	A3-P1	Z	2	12	16
1589	ServoTemp_0_path1_T_C_OP910	55	70	{}	increasing	A0-P1	X	13	3	16
1590	ServoTemp_1_path1_T_C_OP910	65	75	{}	increasing	A1-P1	Y	13	3	16
1591	ServoTemp_2_path1_T_C_OP910	55	70	{}	increasing	A2-P1	U	13	3	16
1592	ServoTemp_3_path1_T_C_OP910	55	70	{}	increasing	A3-P1	Z	13	3	16
1593	PulseCoderTemp_0_path1_T_C_OP911	60	80	{}	increasing	A0-P1	X	13	4	17
1594	PulseCoderTemp_1_path1_T_C_OP911	70	80	{}	increasing	A1-P1	Y	13	4	17
1595	PulseCoderTemp_2_path1_T_C_OP911	80	100	{}	increasing	A2-P1	U	13	4	17
1596	PulseCoderTemp_3_path1_T_C_OP911	70	80	{}	increasing	A3-P1	Z	13	4	17
1597	CncFan1Speed_path1_T_C_OP911	4500	4000	{}	decreasing	A1-P1	F1	16	6	17
1598	CncFan2Speed_path1_T_C_OP911	9600	8600	{}	decreasing	A2-P1	F2	16	6	17
1601	InFan1SrvAmpSpeed_0_path1_T_C_OP911	9500	9000	{}	decreasing	A0-P1	X	2	8	17
1602	InFan1SrvAmpSpeed_1_path1_T_C_OP911	9500	9000	{}	decreasing	A1-P1	Y	2	8	17
1603	InFan1SrvAmpSpeed_2_path1_T_C_OP911	9500	9000	{}	decreasing	A2-P1	U	2	8	17
1604	InFan1SrvAmpSpeed_3_path1_T_C_OP911	9500	9000	{}	decreasing	A3-P1	Z	2	8	17
1605	ServoLoad_0_path1_T_C_OP911	NaN	NaN	{}	increasing	A0-P1	X	17	17	17
1606	ServoLoad_1_path1_T_C_OP911	NaN	NaN	{}	increasing	A1-P1	Y	17	17	17
1607	ServoLoad_2_path1_T_C_OP911	NaN	NaN	{}	increasing	A2-P1	U	17	17	17
1608	ServoLoad_3_path1_T_C_OP911	NaN	NaN	{}	increasing	A3-P1	Z	17	17	17
1609	SpdBatZero_0_path1_T_C_OP911	NaN	NaN	{}	bool	A0-P1	X	6	13	17
1610	SpdBatZero_1_path1_T_C_OP911	NaN	NaN	{}	bool	A1-P1	Y	6	13	17
1611	SpdBatZero_2_path1_T_C_OP911	NaN	NaN	{}	bool	A2-P1	U	6	13	17
1612	SpdBatZero_3_path1_T_C_OP911	NaN	NaN	{}	bool	A3-P1	Z	6	13	17
1613	SSpdBatZero_0_path1_T_C_OP911	NaN	NaN	{}	bool	A0-P1	X	6	14	17
1614	SSpdBatZero_1_path1_T_C_OP911	NaN	NaN	{}	bool	A1-P1	Y	6	14	17
1615	SSpdBatZero_2_path1_T_C_OP911	NaN	NaN	{}	bool	A2-P1	U	6	14	17
1616	SSpdBatZero_3_path1_T_C_OP911	NaN	NaN	{}	bool	A3-P1	Z	6	14	17
1617	RadFan2SrvAmpSpeed_0_path1_T_C_OP911	5000	4500	{}	decreasing	A0-P1	X	2	16	17
1618	RadFan2SrvAmpSpeed_1_path1_T_C_OP911	5000	4500	{}	decreasing	A1-P1	Y	2	16	17
1619	RadFan2SrvAmpSpeed_2_path1_T_C_OP911	5000	4500	{}	decreasing	A2-P1	U	2	16	17
1620	RadFan2SrvAmpSpeed_3_path1_T_C_OP911	5000	4500	{}	decreasing	A3-P1	Z	2	16	17
1621	ApcBatLow_0_path1_T_C_OP911	NaN	NaN	{}	bool	A0-P1	X	6	1	17
1622	ApcBatLow_1_path1_T_C_OP911	NaN	NaN	{}	bool	A1-P1	Y	6	1	17
1623	ApcBatLow_2_path1_T_C_OP911	NaN	NaN	{}	bool	A2-P1	U	6	1	17
1624	ApcBatLow_3_path1_T_C_OP911	NaN	NaN	{}	bool	A3-P1	Z	6	1	17
1625	CncBatLow_0_path1_T_C_OP911	NaN	NaN	{}	bool	A0-P1	X	6	2	17
1626	CncBatLow_1_path1_T_C_OP911	NaN	NaN	{}	bool	A1-P1	Y	6	2	17
1627	CncBatLow_2_path1_T_C_OP911	NaN	NaN	{}	bool	A2-P1	U	6	2	17
1628	CncBatLow_3_path1_T_C_OP911	NaN	NaN	{}	bool	A3-P1	Z	6	2	17
1629	ServoLeakResistData_0_path1_T_C_OP911	50	30	{}	decreasing	A0-P1	X	15	5	17
1630	ServoLeakResistData_1_path1_T_C_OP911	50	30	{}	decreasing	A1-P1	Y	15	5	17
1631	ServoLeakResistData_2_path1_T_C_OP911	50	30	{}	decreasing	A2-P1	U	15	5	17
1632	ServoLeakResistData_3_path1_T_C_OP911	50	30	{}	decreasing	A3-P1	Z	15	5	17
1633	InFan1SrvComPwSpeed_0_path1_T_C_OP911	6200	6000	{}	decreasing	A0-P1	X	2	9	17
1634	InFan1SrvComPwSpeed_1_path1_T_C_OP911	6200	6000	{}	decreasing	A1-P1	Y	2	9	17
1635	InFan1SrvComPwSpeed_2_path1_T_C_OP911	6200	6000	{}	decreasing	A2-P1	U	2	9	17
1636	InFan1SrvComPwSpeed_3_path1_T_C_OP911	6200	6000	{}	decreasing	A3-P1	Z	2	9	17
1637	InFan2SrvAmpSpeed_0_path1_T_C_OP911	5000	4500	{}	decreasing	A0-P1	X	2	11	17
1638	InFan2SrvAmpSpeed_1_path1_T_C_OP911	5000	4500	{}	decreasing	A1-P1	Y	2	11	17
1639	InFan2SrvAmpSpeed_2_path1_T_C_OP911	5000	4500	{}	decreasing	A2-P1	U	2	11	17
1640	InFan2SrvAmpSpeed_3_path1_T_C_OP911	5000	4500	{}	decreasing	A3-P1	Z	2	11	17
1641	RadFan1SrvAmpSpeed_0_path1_T_C_OP911	5000	4500	{}	decreasing	A0-P1	X	2	15	17
1642	RadFan1SrvAmpSpeed_1_path1_T_C_OP911	5000	4500	{}	decreasing	A1-P1	Y	2	15	17
1643	RadFan1SrvAmpSpeed_2_path1_T_C_OP911	5000	4500	{}	decreasing	A2-P1	U	2	15	17
1644	RadFan1SrvAmpSpeed_3_path1_T_C_OP911	5000	4500	{}	decreasing	A3-P1	Z	2	15	17
1645	InFan2SrvComPwSpeed_0_path1_T_C_OP911	5000	4500	{}	decreasing	A0-P1	X	2	12	17
1646	InFan2SrvComPwSpeed_1_path1_T_C_OP911	5000	4500	{}	decreasing	A1-P1	Y	2	12	17
1647	InFan2SrvComPwSpeed_2_path1_T_C_OP911	5000	4500	{}	decreasing	A2-P1	U	2	12	17
1648	InFan2SrvComPwSpeed_3_path1_T_C_OP911	5000	4500	{}	decreasing	A3-P1	Z	2	12	17
1649	ServoTemp_0_path1_T_C_OP911	55	70	{}	increasing	A0-P1	X	13	3	17
1650	ServoTemp_1_path1_T_C_OP911	65	75	{}	increasing	A1-P1	Y	13	3	17
1651	ServoTemp_2_path1_T_C_OP911	55	70	{}	increasing	A2-P1	U	13	3	17
1652	ServoTemp_3_path1_T_C_OP911	55	70	{}	increasing	A3-P1	Z	13	3	17
1653	PulseCoderTemp_0_path1_T_C_OP912	60	80	{}	increasing	A0-P1	X	13	4	18
1654	PulseCoderTemp_1_path1_T_C_OP912	80	90	{}	increasing	A1-P1	Y	13	4	18
1655	PulseCoderTemp_2_path1_T_C_OP912	70	80	{}	increasing	A2-P1	U	13	4	18
1656	PulseCoderTemp_3_path1_T_C_OP912	60	80	{}	increasing	A3-P1	Z	13	4	18
1657	CncFan1Speed_path1_T_C_OP912	4500	4000	{}	decreasing	A1-P1	F1	16	6	18
1658	CncFan2Speed_path1_T_C_OP912	9600	8600	{}	decreasing	A2-P1	F2	16	6	18
1661	InFan1SrvAmpSpeed_0_path1_T_C_OP912	9500	9000	{}	decreasing	A0-P1	X	2	8	18
1662	InFan1SrvAmpSpeed_1_path1_T_C_OP912	9500	9000	{}	decreasing	A1-P1	Y	2	8	18
1663	InFan1SrvAmpSpeed_2_path1_T_C_OP912	9500	9000	{}	decreasing	A2-P1	U	2	8	18
1664	InFan1SrvAmpSpeed_3_path1_T_C_OP912	9500	9000	{}	decreasing	A3-P1	Z	2	8	18
1665	ServoLoad_0_path1_T_C_OP912	NaN	NaN	{}	increasing	A0-P1	X	17	17	18
1666	ServoLoad_1_path1_T_C_OP912	NaN	NaN	{}	increasing	A1-P1	Y	17	17	18
1667	ServoLoad_2_path1_T_C_OP912	NaN	NaN	{}	increasing	A2-P1	U	17	17	18
1668	ServoLoad_3_path1_T_C_OP912	NaN	NaN	{}	increasing	A3-P1	Z	17	17	18
1669	SpdBatZero_0_path1_T_C_OP912	NaN	NaN	{}	bool	A0-P1	X	6	13	18
1670	SpdBatZero_1_path1_T_C_OP912	NaN	NaN	{}	bool	A1-P1	Y	6	13	18
1671	SpdBatZero_2_path1_T_C_OP912	NaN	NaN	{}	bool	A2-P1	U	6	13	18
1672	SpdBatZero_3_path1_T_C_OP912	NaN	NaN	{}	bool	A3-P1	Z	6	13	18
1673	SSpdBatZero_0_path1_T_C_OP912	NaN	NaN	{}	bool	A0-P1	X	6	14	18
1674	SSpdBatZero_1_path1_T_C_OP912	NaN	NaN	{}	bool	A1-P1	Y	6	14	18
1675	SSpdBatZero_2_path1_T_C_OP912	NaN	NaN	{}	bool	A2-P1	U	6	14	18
1676	SSpdBatZero_3_path1_T_C_OP912	NaN	NaN	{}	bool	A3-P1	Z	6	14	18
1677	RadFan2SrvAmpSpeed_0_path1_T_C_OP912	5000	4500	{}	decreasing	A0-P1	X	2	16	18
1678	RadFan2SrvAmpSpeed_1_path1_T_C_OP912	5000	4500	{}	decreasing	A1-P1	Y	2	16	18
1679	RadFan2SrvAmpSpeed_2_path1_T_C_OP912	5000	4500	{}	decreasing	A2-P1	U	2	16	18
1680	RadFan2SrvAmpSpeed_3_path1_T_C_OP912	5000	4500	{}	decreasing	A3-P1	Z	2	16	18
1681	ApcBatLow_0_path1_T_C_OP912	NaN	NaN	{}	bool	A0-P1	X	6	1	18
1682	ApcBatLow_1_path1_T_C_OP912	NaN	NaN	{}	bool	A1-P1	Y	6	1	18
1683	ApcBatLow_2_path1_T_C_OP912	NaN	NaN	{}	bool	A2-P1	U	6	1	18
1684	ApcBatLow_3_path1_T_C_OP912	NaN	NaN	{}	bool	A3-P1	Z	6	1	18
1685	CncBatLow_0_path1_T_C_OP912	NaN	NaN	{}	bool	A0-P1	X	6	2	18
1686	CncBatLow_1_path1_T_C_OP912	NaN	NaN	{}	bool	A1-P1	Y	6	2	18
1687	CncBatLow_2_path1_T_C_OP912	NaN	NaN	{}	bool	A2-P1	U	6	2	18
1688	CncBatLow_3_path1_T_C_OP912	NaN	NaN	{}	bool	A3-P1	Z	6	2	18
1689	ServoLeakResistData_0_path1_T_C_OP912	50	30	{}	decreasing	A0-P1	X	15	5	18
1690	ServoLeakResistData_1_path1_T_C_OP912	50	30	{}	decreasing	A1-P1	Y	15	5	18
1691	ServoLeakResistData_2_path1_T_C_OP912	50	30	{}	decreasing	A2-P1	U	15	5	18
1692	ServoLeakResistData_3_path1_T_C_OP912	50	30	{}	decreasing	A3-P1	Z	15	5	18
1693	InFan1SrvComPwSpeed_0_path1_T_C_OP912	6200	6000	{}	decreasing	A0-P1	X	2	9	18
1694	InFan1SrvComPwSpeed_1_path1_T_C_OP912	6200	6000	{}	decreasing	A1-P1	Y	2	9	18
1695	InFan1SrvComPwSpeed_2_path1_T_C_OP912	6200	6000	{}	decreasing	A2-P1	U	2	9	18
1696	InFan1SrvComPwSpeed_3_path1_T_C_OP912	6200	6000	{}	decreasing	A3-P1	Z	2	9	18
1697	InFan2SrvAmpSpeed_0_path1_T_C_OP912	5000	4500	{}	decreasing	A0-P1	X	2	11	18
1698	InFan2SrvAmpSpeed_1_path1_T_C_OP912	5000	4500	{}	decreasing	A1-P1	Y	2	11	18
1699	InFan2SrvAmpSpeed_2_path1_T_C_OP912	5000	4500	{}	decreasing	A2-P1	U	2	11	18
1700	InFan2SrvAmpSpeed_3_path1_T_C_OP912	5000	4500	{}	decreasing	A3-P1	Z	2	11	18
1701	RadFan1SrvAmpSpeed_0_path1_T_C_OP912	5000	4500	{}	decreasing	A0-P1	X	2	15	18
1702	RadFan1SrvAmpSpeed_1_path1_T_C_OP912	5000	4500	{}	decreasing	A1-P1	Y	2	15	18
1703	RadFan1SrvAmpSpeed_2_path1_T_C_OP912	5000	4500	{}	decreasing	A2-P1	U	2	15	18
1704	RadFan1SrvAmpSpeed_3_path1_T_C_OP912	5000	4500	{}	decreasing	A3-P1	Z	2	15	18
1705	InFan2SrvComPwSpeed_0_path1_T_C_OP912	5000	4500	{}	decreasing	A0-P1	X	2	12	18
1706	InFan2SrvComPwSpeed_1_path1_T_C_OP912	5000	4500	{}	decreasing	A1-P1	Y	2	12	18
1707	InFan2SrvComPwSpeed_2_path1_T_C_OP912	5000	4500	{}	decreasing	A2-P1	U	2	12	18
1708	InFan2SrvComPwSpeed_3_path1_T_C_OP912	5000	4500	{}	decreasing	A3-P1	Z	2	12	18
1709	ServoTemp_0_path1_T_C_OP912	55	70	{}	increasing	A0-P1	X	13	3	18
1710	ServoTemp_1_path1_T_C_OP912	67	72	{}	increasing	A1-P1	Y	13	3	18
1711	ServoTemp_2_path1_T_C_OP912	55	70	{}	increasing	A2-P1	U	13	3	18
1712	ServoTemp_3_path1_T_C_OP912	55	70	{}	increasing	A3-P1	Z	13	3	18
1713	PulseCoderTemp_0_path1_T_C_OP913	60	80	{}	increasing	A0-P1	X	13	4	19
1714	PulseCoderTemp_1_path1_T_C_OP913	70	80	{}	increasing	A1-P1	Y	13	4	19
1715	PulseCoderTemp_2_path1_T_C_OP913	60	80	{}	increasing	A2-P1	U	13	4	19
1716	PulseCoderTemp_3_path1_T_C_OP913	60	80	{}	increasing	A3-P1	Z	13	4	19
1717	CncFan1Speed_path1_T_C_OP913	4500	4000	{}	decreasing	A1-P1	F1	16	6	19
1718	CncFan2Speed_path1_T_C_OP913	9600	8600	{}	decreasing	A2-P1	F2	16	6	19
1721	InFan1SrvAmpSpeed_0_path1_T_C_OP913	9500	9000	{}	decreasing	A0-P1	X	2	8	19
1722	InFan1SrvAmpSpeed_1_path1_T_C_OP913	9500	9000	{}	decreasing	A1-P1	Y	2	8	19
1723	InFan1SrvAmpSpeed_2_path1_T_C_OP913	9500	9000	{}	decreasing	A2-P1	U	2	8	19
1724	InFan1SrvAmpSpeed_3_path1_T_C_OP913	9500	9000	{}	decreasing	A3-P1	Z	2	8	19
1725	ServoLoad_0_path1_T_C_OP913	NaN	NaN	{}	increasing	A0-P1	X	17	17	19
1726	ServoLoad_1_path1_T_C_OP913	NaN	NaN	{}	increasing	A1-P1	Y	17	17	19
1727	ServoLoad_2_path1_T_C_OP913	NaN	NaN	{}	increasing	A2-P1	U	17	17	19
1728	ServoLoad_3_path1_T_C_OP913	NaN	NaN	{}	increasing	A3-P1	Z	17	17	19
1729	SpdBatZero_0_path1_T_C_OP913	NaN	NaN	{}	bool	A0-P1	X	6	13	19
1730	SpdBatZero_1_path1_T_C_OP913	NaN	NaN	{}	bool	A1-P1	Y	6	13	19
1731	SpdBatZero_2_path1_T_C_OP913	NaN	NaN	{}	bool	A2-P1	U	6	13	19
1732	SpdBatZero_3_path1_T_C_OP913	NaN	NaN	{}	bool	A3-P1	Z	6	13	19
1733	SSpdBatZero_0_path1_T_C_OP913	NaN	NaN	{}	bool	A0-P1	X	6	14	19
1734	SSpdBatZero_1_path1_T_C_OP913	NaN	NaN	{}	bool	A1-P1	Y	6	14	19
1735	SSpdBatZero_2_path1_T_C_OP913	NaN	NaN	{}	bool	A2-P1	U	6	14	19
1736	SSpdBatZero_3_path1_T_C_OP913	NaN	NaN	{}	bool	A3-P1	Z	6	14	19
1737	RadFan2SrvAmpSpeed_0_path1_T_C_OP913	5000	4500	{}	decreasing	A0-P1	X	2	16	19
1738	RadFan2SrvAmpSpeed_1_path1_T_C_OP913	5000	4500	{}	decreasing	A1-P1	Y	2	16	19
1739	RadFan2SrvAmpSpeed_2_path1_T_C_OP913	5000	4500	{}	decreasing	A2-P1	U	2	16	19
1740	RadFan2SrvAmpSpeed_3_path1_T_C_OP913	5000	4500	{}	decreasing	A3-P1	Z	2	16	19
1741	ApcBatLow_0_path1_T_C_OP913	NaN	NaN	{}	bool	A0-P1	X	6	1	19
1742	ApcBatLow_1_path1_T_C_OP913	NaN	NaN	{}	bool	A1-P1	Y	6	1	19
1743	ApcBatLow_2_path1_T_C_OP913	NaN	NaN	{}	bool	A2-P1	U	6	1	19
1744	ApcBatLow_3_path1_T_C_OP913	NaN	NaN	{}	bool	A3-P1	Z	6	1	19
1745	CncBatLow_0_path1_T_C_OP913	NaN	NaN	{}	bool	A0-P1	X	6	2	19
1746	CncBatLow_1_path1_T_C_OP913	NaN	NaN	{}	bool	A1-P1	Y	6	2	19
1747	CncBatLow_2_path1_T_C_OP913	NaN	NaN	{}	bool	A2-P1	U	6	2	19
1748	CncBatLow_3_path1_T_C_OP913	NaN	NaN	{}	bool	A3-P1	Z	6	2	19
1749	ServoLeakResistData_0_path1_T_C_OP913	50	30	{}	decreasing	A0-P1	X	15	5	19
1750	ServoLeakResistData_1_path1_T_C_OP913	50	30	{}	decreasing	A1-P1	Y	15	5	19
1751	ServoLeakResistData_2_path1_T_C_OP913	50	30	{}	decreasing	A2-P1	U	15	5	19
1752	ServoLeakResistData_3_path1_T_C_OP913	50	30	{}	decreasing	A3-P1	Z	15	5	19
1753	InFan1SrvComPwSpeed_0_path1_T_C_OP913	6200	6000	{}	decreasing	A0-P1	X	2	9	19
1754	InFan1SrvComPwSpeed_1_path1_T_C_OP913	6200	6000	{}	decreasing	A1-P1	Y	2	9	19
1755	InFan1SrvComPwSpeed_2_path1_T_C_OP913	6200	6000	{}	decreasing	A2-P1	U	2	9	19
1756	InFan1SrvComPwSpeed_3_path1_T_C_OP913	6200	6000	{}	decreasing	A3-P1	Z	2	9	19
1757	InFan2SrvAmpSpeed_0_path1_T_C_OP913	5000	4500	{}	decreasing	A0-P1	X	2	11	19
1758	InFan2SrvAmpSpeed_1_path1_T_C_OP913	5000	4500	{}	decreasing	A1-P1	Y	2	11	19
1759	InFan2SrvAmpSpeed_2_path1_T_C_OP913	5000	4500	{}	decreasing	A2-P1	U	2	11	19
1760	InFan2SrvAmpSpeed_3_path1_T_C_OP913	5000	4500	{}	decreasing	A3-P1	Z	2	11	19
1761	RadFan1SrvAmpSpeed_0_path1_T_C_OP913	5000	4500	{}	decreasing	A0-P1	X	2	15	19
1762	RadFan1SrvAmpSpeed_1_path1_T_C_OP913	5000	4500	{}	decreasing	A1-P1	Y	2	15	19
1763	RadFan1SrvAmpSpeed_2_path1_T_C_OP913	5000	4500	{}	decreasing	A2-P1	U	2	15	19
1764	RadFan1SrvAmpSpeed_3_path1_T_C_OP913	5000	4500	{}	decreasing	A3-P1	Z	2	15	19
1765	InFan2SrvComPwSpeed_0_path1_T_C_OP913	5000	4500	{}	decreasing	A0-P1	X	2	12	19
1766	InFan2SrvComPwSpeed_1_path1_T_C_OP913	5000	4500	{}	decreasing	A1-P1	Y	2	12	19
1767	InFan2SrvComPwSpeed_2_path1_T_C_OP913	5000	4500	{}	decreasing	A2-P1	U	2	12	19
1768	InFan2SrvComPwSpeed_3_path1_T_C_OP913	5000	4500	{}	decreasing	A3-P1	Z	2	12	19
1769	ServoTemp_0_path1_T_C_OP913	55	70	{}	increasing	A0-P1	X	13	3	19
1770	ServoTemp_1_path1_T_C_OP913	60	70	{}	increasing	A1-P1	Y	13	3	19
1771	ServoTemp_2_path1_T_C_OP913	55	70	{}	increasing	A2-P1	U	13	3	19
1772	ServoTemp_3_path1_T_C_OP913	55	70	{}	increasing	A3-P1	Z	13	3	19
1773	PulseCoderTemp_0_path1_T_C_OP914	60	80	{}	increasing	A0-P1	X	13	4	20
1774	PulseCoderTemp_1_path1_T_C_OP914	70	80	{}	increasing	A1-P1	Y	13	4	20
1775	PulseCoderTemp_2_path1_T_C_OP914	60	80	{}	increasing	A2-P1	U	13	4	20
1776	PulseCoderTemp_3_path1_T_C_OP914	70	80	{}	increasing	A3-P1	Z	13	4	20
1777	CncFan1Speed_path1_T_C_OP914	4500	4000	{}	decreasing	A1-P1	F1	16	6	20
1778	CncFan2Speed_path1_T_C_OP914	9600	8600	{}	decreasing	A2-P1	F2	16	6	20
1781	InFan1SrvAmpSpeed_0_path1_T_C_OP914	9500	9000	{}	decreasing	A0-P1	X	2	8	20
1782	InFan1SrvAmpSpeed_1_path1_T_C_OP914	9500	9000	{}	decreasing	A1-P1	Y	2	8	20
1783	InFan1SrvAmpSpeed_2_path1_T_C_OP914	9500	9000	{}	decreasing	A2-P1	U	2	8	20
1784	InFan1SrvAmpSpeed_3_path1_T_C_OP914	9500	9000	{}	decreasing	A3-P1	Z	2	8	20
1785	ServoLoad_0_path1_T_C_OP914	NaN	NaN	{}	increasing	A0-P1	X	17	17	20
1786	ServoLoad_1_path1_T_C_OP914	NaN	NaN	{}	increasing	A1-P1	Y	17	17	20
1787	ServoLoad_2_path1_T_C_OP914	NaN	NaN	{}	increasing	A2-P1	U	17	17	20
1788	ServoLoad_3_path1_T_C_OP914	NaN	NaN	{}	increasing	A3-P1	Z	17	17	20
1789	SpdBatZero_0_path1_T_C_OP914	NaN	NaN	{}	bool	A0-P1	X	6	13	20
1790	SpdBatZero_1_path1_T_C_OP914	NaN	NaN	{}	bool	A1-P1	Y	6	13	20
1791	SpdBatZero_2_path1_T_C_OP914	NaN	NaN	{}	bool	A2-P1	U	6	13	20
1792	SpdBatZero_3_path1_T_C_OP914	NaN	NaN	{}	bool	A3-P1	Z	6	13	20
1793	SSpdBatZero_0_path1_T_C_OP914	NaN	NaN	{}	bool	A0-P1	X	6	14	20
1794	SSpdBatZero_1_path1_T_C_OP914	NaN	NaN	{}	bool	A1-P1	Y	6	14	20
1795	SSpdBatZero_2_path1_T_C_OP914	NaN	NaN	{}	bool	A2-P1	U	6	14	20
1796	SSpdBatZero_3_path1_T_C_OP914	NaN	NaN	{}	bool	A3-P1	Z	6	14	20
1797	RadFan2SrvAmpSpeed_0_path1_T_C_OP914	5000	4500	{}	decreasing	A0-P1	X	2	16	20
1798	RadFan2SrvAmpSpeed_1_path1_T_C_OP914	5000	4500	{}	decreasing	A1-P1	Y	2	16	20
1799	RadFan2SrvAmpSpeed_2_path1_T_C_OP914	5000	4500	{}	decreasing	A2-P1	U	2	16	20
1800	RadFan2SrvAmpSpeed_3_path1_T_C_OP914	5000	4500	{}	decreasing	A3-P1	Z	2	16	20
1801	ApcBatLow_0_path1_T_C_OP914	NaN	NaN	{}	bool	A0-P1	X	6	1	20
1802	ApcBatLow_1_path1_T_C_OP914	NaN	NaN	{}	bool	A1-P1	Y	6	1	20
1803	ApcBatLow_2_path1_T_C_OP914	NaN	NaN	{}	bool	A2-P1	U	6	1	20
1804	ApcBatLow_3_path1_T_C_OP914	NaN	NaN	{}	bool	A3-P1	Z	6	1	20
1805	CncBatLow_0_path1_T_C_OP914	NaN	NaN	{}	bool	A0-P1	X	6	2	20
1806	CncBatLow_1_path1_T_C_OP914	NaN	NaN	{}	bool	A1-P1	Y	6	2	20
1807	CncBatLow_2_path1_T_C_OP914	NaN	NaN	{}	bool	A2-P1	U	6	2	20
1808	CncBatLow_3_path1_T_C_OP914	NaN	NaN	{}	bool	A3-P1	Z	6	2	20
1809	ServoLeakResistData_0_path1_T_C_OP914	50	30	{}	decreasing	A0-P1	X	15	5	20
1810	ServoLeakResistData_1_path1_T_C_OP914	50	30	{}	decreasing	A1-P1	Y	15	5	20
1811	ServoLeakResistData_2_path1_T_C_OP914	50	30	{}	decreasing	A2-P1	U	15	5	20
1812	ServoLeakResistData_3_path1_T_C_OP914	50	30	{}	decreasing	A3-P1	Z	15	5	20
1813	InFan1SrvComPwSpeed_0_path1_T_C_OP914	6200	6000	{}	decreasing	A0-P1	X	2	9	20
1814	InFan1SrvComPwSpeed_1_path1_T_C_OP914	6200	6000	{}	decreasing	A1-P1	Y	2	9	20
1815	InFan1SrvComPwSpeed_2_path1_T_C_OP914	6200	6000	{}	decreasing	A2-P1	U	2	9	20
1816	InFan1SrvComPwSpeed_3_path1_T_C_OP914	6200	6000	{}	decreasing	A3-P1	Z	2	9	20
1817	InFan2SrvAmpSpeed_0_path1_T_C_OP914	5000	4500	{}	decreasing	A0-P1	X	2	11	20
1818	InFan2SrvAmpSpeed_1_path1_T_C_OP914	5000	4500	{}	decreasing	A1-P1	Y	2	11	20
1819	InFan2SrvAmpSpeed_2_path1_T_C_OP914	5000	4500	{}	decreasing	A2-P1	U	2	11	20
1820	InFan2SrvAmpSpeed_3_path1_T_C_OP914	5000	4500	{}	decreasing	A3-P1	Z	2	11	20
1821	RadFan1SrvAmpSpeed_0_path1_T_C_OP914	5000	4500	{}	decreasing	A0-P1	X	2	15	20
1822	RadFan1SrvAmpSpeed_1_path1_T_C_OP914	5000	4500	{}	decreasing	A1-P1	Y	2	15	20
1823	RadFan1SrvAmpSpeed_2_path1_T_C_OP914	5000	4500	{}	decreasing	A2-P1	U	2	15	20
1824	RadFan1SrvAmpSpeed_3_path1_T_C_OP914	5000	4500	{}	decreasing	A3-P1	Z	2	15	20
1825	InFan2SrvComPwSpeed_0_path1_T_C_OP914	5000	4500	{}	decreasing	A0-P1	X	2	12	20
1826	InFan2SrvComPwSpeed_1_path1_T_C_OP914	5000	4500	{}	decreasing	A1-P1	Y	2	12	20
1827	InFan2SrvComPwSpeed_2_path1_T_C_OP914	5000	4500	{}	decreasing	A2-P1	U	2	12	20
1828	InFan2SrvComPwSpeed_3_path1_T_C_OP914	5000	4500	{}	decreasing	A3-P1	Z	2	12	20
1829	ServoTemp_0_path1_T_C_OP914	55	70	{}	increasing	A0-P1	X	13	3	20
1830	ServoTemp_1_path1_T_C_OP914	65	75	{}	increasing	A1-P1	Y	13	3	20
1831	ServoTemp_2_path1_T_C_OP914	55	70	{}	increasing	A2-P1	U	13	3	20
1832	ServoTemp_3_path1_T_C_OP914	55	70	{}	increasing	A3-P1	Z	13	3	20
1833	PulseCoderTemp_0_path1_T_C_OP915	60	80	{}	increasing	A0-P1	X	13	4	21
1834	PulseCoderTemp_1_path1_T_C_OP915	70	80	{}	increasing	A1-P1	Y	13	4	21
1835	PulseCoderTemp_2_path1_T_C_OP915	60	80	{}	increasing	A2-P1	U	13	4	21
1836	PulseCoderTemp_3_path1_T_C_OP915	70	80	{}	increasing	A3-P1	Z	13	4	21
1837	CncFan1Speed_path1_T_C_OP915	4500	4000	{}	decreasing	A1-P1	F1	16	6	21
1838	CncFan2Speed_path1_T_C_OP915	9600	8600	{}	decreasing	A2-P1	F2	16	6	21
1841	InFan1SrvAmpSpeed_0_path1_T_C_OP915	9500	9000	{}	decreasing	A0-P1	X	2	8	21
1842	InFan1SrvAmpSpeed_1_path1_T_C_OP915	9500	9000	{}	decreasing	A1-P1	Y	2	8	21
1843	InFan1SrvAmpSpeed_2_path1_T_C_OP915	9500	9000	{}	decreasing	A2-P1	U	2	8	21
1844	InFan1SrvAmpSpeed_3_path1_T_C_OP915	9500	9000	{}	decreasing	A3-P1	Z	2	8	21
1845	ServoLoad_0_path1_T_C_OP915	NaN	NaN	{}	increasing	A0-P1	X	17	17	21
1846	ServoLoad_1_path1_T_C_OP915	NaN	NaN	{}	increasing	A1-P1	Y	17	17	21
1847	ServoLoad_2_path1_T_C_OP915	NaN	NaN	{}	increasing	A2-P1	U	17	17	21
1848	ServoLoad_3_path1_T_C_OP915	NaN	NaN	{}	increasing	A3-P1	Z	17	17	21
1849	SpdBatZero_0_path1_T_C_OP915	NaN	NaN	{}	bool	A0-P1	X	6	13	21
1850	SpdBatZero_1_path1_T_C_OP915	NaN	NaN	{}	bool	A1-P1	Y	6	13	21
1851	SpdBatZero_2_path1_T_C_OP915	NaN	NaN	{}	bool	A2-P1	U	6	13	21
1852	SpdBatZero_3_path1_T_C_OP915	NaN	NaN	{}	bool	A3-P1	Z	6	13	21
1853	SSpdBatZero_0_path1_T_C_OP915	NaN	NaN	{}	bool	A0-P1	X	6	14	21
1854	SSpdBatZero_1_path1_T_C_OP915	NaN	NaN	{}	bool	A1-P1	Y	6	14	21
1855	SSpdBatZero_2_path1_T_C_OP915	NaN	NaN	{}	bool	A2-P1	U	6	14	21
1856	SSpdBatZero_3_path1_T_C_OP915	NaN	NaN	{}	bool	A3-P1	Z	6	14	21
1857	RadFan2SrvAmpSpeed_0_path1_T_C_OP915	5000	4500	{}	decreasing	A0-P1	X	2	16	21
1858	RadFan2SrvAmpSpeed_1_path1_T_C_OP915	5000	4500	{}	decreasing	A1-P1	Y	2	16	21
1859	RadFan2SrvAmpSpeed_2_path1_T_C_OP915	5000	4500	{}	decreasing	A2-P1	U	2	16	21
1860	RadFan2SrvAmpSpeed_3_path1_T_C_OP915	5000	4500	{}	decreasing	A3-P1	Z	2	16	21
1861	ApcBatLow_0_path1_T_C_OP915	NaN	NaN	{}	bool	A0-P1	X	6	1	21
1862	ApcBatLow_1_path1_T_C_OP915	NaN	NaN	{}	bool	A1-P1	Y	6	1	21
1863	ApcBatLow_2_path1_T_C_OP915	NaN	NaN	{}	bool	A2-P1	U	6	1	21
1864	ApcBatLow_3_path1_T_C_OP915	NaN	NaN	{}	bool	A3-P1	Z	6	1	21
1865	CncBatLow_0_path1_T_C_OP915	NaN	NaN	{}	bool	A0-P1	X	6	2	21
1866	CncBatLow_1_path1_T_C_OP915	NaN	NaN	{}	bool	A1-P1	Y	6	2	21
1867	CncBatLow_2_path1_T_C_OP915	NaN	NaN	{}	bool	A2-P1	U	6	2	21
1868	CncBatLow_3_path1_T_C_OP915	NaN	NaN	{}	bool	A3-P1	Z	6	2	21
1869	ServoLeakResistData_0_path1_T_C_OP915	50	30	{}	decreasing	A0-P1	X	15	5	21
1870	ServoLeakResistData_1_path1_T_C_OP915	50	30	{}	decreasing	A1-P1	Y	15	5	21
1871	ServoLeakResistData_2_path1_T_C_OP915	50	30	{}	decreasing	A2-P1	U	15	5	21
1872	ServoLeakResistData_3_path1_T_C_OP915	50	30	{}	decreasing	A3-P1	Z	15	5	21
1873	InFan1SrvComPwSpeed_0_path1_T_C_OP915	6200	6000	{}	decreasing	A0-P1	X	2	9	21
1874	InFan1SrvComPwSpeed_1_path1_T_C_OP915	6200	6000	{}	decreasing	A1-P1	Y	2	9	21
1875	InFan1SrvComPwSpeed_2_path1_T_C_OP915	6200	6000	{}	decreasing	A2-P1	U	2	9	21
1876	InFan1SrvComPwSpeed_3_path1_T_C_OP915	6200	6000	{}	decreasing	A3-P1	Z	2	9	21
1877	InFan2SrvAmpSpeed_0_path1_T_C_OP915	5000	4500	{}	decreasing	A0-P1	X	2	11	21
1878	InFan2SrvAmpSpeed_1_path1_T_C_OP915	5000	4500	{}	decreasing	A1-P1	Y	2	11	21
1879	InFan2SrvAmpSpeed_2_path1_T_C_OP915	5000	4500	{}	decreasing	A2-P1	U	2	11	21
1880	InFan2SrvAmpSpeed_3_path1_T_C_OP915	5000	4500	{}	decreasing	A3-P1	Z	2	11	21
1881	RadFan1SrvAmpSpeed_0_path1_T_C_OP915	5000	4500	{}	decreasing	A0-P1	X	2	15	21
1882	RadFan1SrvAmpSpeed_1_path1_T_C_OP915	5000	4500	{}	decreasing	A1-P1	Y	2	15	21
1883	RadFan1SrvAmpSpeed_2_path1_T_C_OP915	5000	4500	{}	decreasing	A2-P1	U	2	15	21
1884	RadFan1SrvAmpSpeed_3_path1_T_C_OP915	5000	4500	{}	decreasing	A3-P1	Z	2	15	21
1885	InFan2SrvComPwSpeed_0_path1_T_C_OP915	5000	4500	{}	decreasing	A0-P1	X	2	12	21
1886	InFan2SrvComPwSpeed_1_path1_T_C_OP915	5000	4500	{}	decreasing	A1-P1	Y	2	12	21
1887	InFan2SrvComPwSpeed_2_path1_T_C_OP915	5000	4500	{}	decreasing	A2-P1	U	2	12	21
1888	InFan2SrvComPwSpeed_3_path1_T_C_OP915	5000	4500	{}	decreasing	A3-P1	Z	2	12	21
1889	ServoTemp_0_path1_T_C_OP915	55	70	{}	increasing	A0-P1	X	13	3	21
1890	ServoTemp_1_path1_T_C_OP915	65	75	{}	increasing	A1-P1	Y	13	3	21
1891	ServoTemp_2_path1_T_C_OP915	55	70	{}	increasing	A2-P1	U	13	3	21
1892	ServoTemp_3_path1_T_C_OP915	55	70	{}	increasing	A3-P1	Z	13	3	21
1893	PulseCoderTemp_0_path1_T_C_OP916	60	80	{}	increasing	A0-P1	X	13	4	22
1894	PulseCoderTemp_1_path1_T_C_OP916	80	90	{}	increasing	A1-P1	Y	13	4	22
1895	PulseCoderTemp_2_path1_T_C_OP916	60	80	{}	increasing	A2-P1	U	13	4	22
1896	PulseCoderTemp_3_path1_T_C_OP916	70	80	{}	increasing	A3-P1	Z	13	4	22
1897	CncFan1Speed_path1_T_C_OP916	4500	4000	{}	decreasing	A1-P1	F1	16	6	22
1898	CncFan2Speed_path1_T_C_OP916	9600	8600	{}	decreasing	A2-P1	F2	16	6	22
1901	InFan1SrvAmpSpeed_0_path1_T_C_OP916	9500	9000	{}	decreasing	A0-P1	X	2	8	22
1902	InFan1SrvAmpSpeed_1_path1_T_C_OP916	9500	9000	{}	decreasing	A1-P1	Y	2	8	22
1903	InFan1SrvAmpSpeed_2_path1_T_C_OP916	9500	9000	{}	decreasing	A2-P1	U	2	8	22
1904	InFan1SrvAmpSpeed_3_path1_T_C_OP916	9500	9000	{}	decreasing	A3-P1	Z	2	8	22
1905	ServoLoad_0_path1_T_C_OP916	NaN	NaN	{}	increasing	A0-P1	X	17	17	22
1906	ServoLoad_1_path1_T_C_OP916	NaN	NaN	{}	increasing	A1-P1	Y	17	17	22
1907	ServoLoad_2_path1_T_C_OP916	NaN	NaN	{}	increasing	A2-P1	U	17	17	22
1908	ServoLoad_3_path1_T_C_OP916	NaN	NaN	{}	increasing	A3-P1	Z	17	17	22
1909	SpdBatZero_0_path1_T_C_OP916	NaN	NaN	{}	bool	A0-P1	X	6	13	22
1910	SpdBatZero_1_path1_T_C_OP916	NaN	NaN	{}	bool	A1-P1	Y	6	13	22
1911	SpdBatZero_2_path1_T_C_OP916	NaN	NaN	{}	bool	A2-P1	U	6	13	22
1912	SpdBatZero_3_path1_T_C_OP916	NaN	NaN	{}	bool	A3-P1	Z	6	13	22
1913	SSpdBatZero_0_path1_T_C_OP916	NaN	NaN	{}	bool	A0-P1	X	6	14	22
1914	SSpdBatZero_1_path1_T_C_OP916	NaN	NaN	{}	bool	A1-P1	Y	6	14	22
1915	SSpdBatZero_2_path1_T_C_OP916	NaN	NaN	{}	bool	A2-P1	U	6	14	22
1916	SSpdBatZero_3_path1_T_C_OP916	NaN	NaN	{}	bool	A3-P1	Z	6	14	22
1917	RadFan2SrvAmpSpeed_0_path1_T_C_OP916	5000	4500	{}	decreasing	A0-P1	X	2	16	22
1918	RadFan2SrvAmpSpeed_1_path1_T_C_OP916	5000	4500	{}	decreasing	A1-P1	Y	2	16	22
1919	RadFan2SrvAmpSpeed_2_path1_T_C_OP916	5000	4500	{}	decreasing	A2-P1	U	2	16	22
1920	RadFan2SrvAmpSpeed_3_path1_T_C_OP916	5000	4500	{}	decreasing	A3-P1	Z	2	16	22
1921	ApcBatLow_0_path1_T_C_OP916	NaN	NaN	{}	bool	A0-P1	X	6	1	22
1922	ApcBatLow_1_path1_T_C_OP916	NaN	NaN	{}	bool	A1-P1	Y	6	1	22
1923	ApcBatLow_2_path1_T_C_OP916	NaN	NaN	{}	bool	A2-P1	U	6	1	22
1924	ApcBatLow_3_path1_T_C_OP916	NaN	NaN	{}	bool	A3-P1	Z	6	1	22
1925	CncBatLow_0_path1_T_C_OP916	NaN	NaN	{}	bool	A0-P1	X	6	2	22
1926	CncBatLow_1_path1_T_C_OP916	NaN	NaN	{}	bool	A1-P1	Y	6	2	22
1927	CncBatLow_2_path1_T_C_OP916	NaN	NaN	{}	bool	A2-P1	U	6	2	22
1928	CncBatLow_3_path1_T_C_OP916	NaN	NaN	{}	bool	A3-P1	Z	6	2	22
1929	ServoLeakResistData_0_path1_T_C_OP916	50	30	{}	decreasing	A0-P1	X	15	5	22
1930	ServoLeakResistData_1_path1_T_C_OP916	50	30	{}	decreasing	A1-P1	Y	15	5	22
1931	ServoLeakResistData_2_path1_T_C_OP916	50	30	{}	decreasing	A2-P1	U	15	5	22
1932	ServoLeakResistData_3_path1_T_C_OP916	50	30	{}	decreasing	A3-P1	Z	15	5	22
1933	InFan1SrvComPwSpeed_0_path1_T_C_OP916	6200	6000	{}	decreasing	A0-P1	X	2	9	22
1934	InFan1SrvComPwSpeed_1_path1_T_C_OP916	6200	6000	{}	decreasing	A1-P1	Y	2	9	22
1935	InFan1SrvComPwSpeed_2_path1_T_C_OP916	6200	6000	{}	decreasing	A2-P1	U	2	9	22
1936	InFan1SrvComPwSpeed_3_path1_T_C_OP916	6200	6000	{}	decreasing	A3-P1	Z	2	9	22
1937	InFan2SrvAmpSpeed_0_path1_T_C_OP916	5000	4500	{}	decreasing	A0-P1	X	2	11	22
1938	InFan2SrvAmpSpeed_1_path1_T_C_OP916	5000	4500	{}	decreasing	A1-P1	Y	2	11	22
1939	InFan2SrvAmpSpeed_2_path1_T_C_OP916	5000	4500	{}	decreasing	A2-P1	U	2	11	22
1940	InFan2SrvAmpSpeed_3_path1_T_C_OP916	5000	4500	{}	decreasing	A3-P1	Z	2	11	22
1941	RadFan1SrvAmpSpeed_0_path1_T_C_OP916	5000	4500	{}	decreasing	A0-P1	X	2	15	22
1942	RadFan1SrvAmpSpeed_1_path1_T_C_OP916	5000	4500	{}	decreasing	A1-P1	Y	2	15	22
1943	RadFan1SrvAmpSpeed_2_path1_T_C_OP916	5000	4500	{}	decreasing	A2-P1	U	2	15	22
1944	RadFan1SrvAmpSpeed_3_path1_T_C_OP916	5000	4500	{}	decreasing	A3-P1	Z	2	15	22
1945	InFan2SrvComPwSpeed_0_path1_T_C_OP916	5000	4500	{}	decreasing	A0-P1	X	2	12	22
1946	InFan2SrvComPwSpeed_1_path1_T_C_OP916	5000	4500	{}	decreasing	A1-P1	Y	2	12	22
1947	InFan2SrvComPwSpeed_2_path1_T_C_OP916	5000	4500	{}	decreasing	A2-P1	U	2	12	22
1948	InFan2SrvComPwSpeed_3_path1_T_C_OP916	5000	4500	{}	decreasing	A3-P1	Z	2	12	22
1949	ServoTemp_0_path1_T_C_OP916	55	70	{}	increasing	A0-P1	X	13	3	22
1950	ServoTemp_1_path1_T_C_OP916	67	75	{}	increasing	A1-P1	Y	13	3	22
1951	ServoTemp_2_path1_T_C_OP916	55	70	{}	increasing	A2-P1	U	13	3	22
1952	ServoTemp_3_path1_T_C_OP916	55	70	{}	increasing	A3-P1	Z	13	3	22
1953	PulseCoderTemp_0_path1_T_H_OP10	60	80	{}	increasing	A0-P1	X	13	4	23
1954	PulseCoderTemp_1_path1_T_H_OP10	60	80	{}	increasing	A1-P1	Z	13	4	23
1955	PulseCoderTemp_2_path1_T_H_OP10	60	80	{}	increasing	A2-P1	Y	13	4	23
1956	PulseCoderTemp_3_path1_T_H_OP10	70	80	{}	increasing	A3-P1	YS	13	4	23
1958	PulseCoderTemp_5_path1_T_H_OP10	60	80	{}	increasing	A5-P1	BMG	13	4	23
1959	PulseCoderTemp_6_path1_T_H_OP10	60	80	{}	increasing	A6-P1	A2	13	4	23
1960	PulseCoderTemp_7_path1_T_H_OP10	60	80	{}	increasing	A7-P1	AT	13	4	23
1961	CncFan1Speed_path1_T_H_OP10	4500	4000	{}	decreasing	A1-P1	F1	16	6	23
1962	CncFan2Speed_path1_T_H_OP10	9600	8600	{}	decreasing	A2-P1	F2	16	6	23
1965	InFan1SrvAmpSpeed_0_path1_T_H_OP10	9500	9000	{}	decreasing	A0-P1	X	2	8	23
1966	InFan1SrvAmpSpeed_1_path1_T_H_OP10	9500	9000	{}	decreasing	A1-P1	Z	2	8	23
1967	InFan1SrvAmpSpeed_2_path1_T_H_OP10	9500	9000	{}	decreasing	A2-P1	Y	2	8	23
1968	InFan1SrvAmpSpeed_3_path1_T_H_OP10	9500	9000	{}	decreasing	A3-P1	YS	2	8	23
1970	InFan1SrvAmpSpeed_5_path1_T_H_OP10	8500	7500	{}	decreasing	A5-P1	BMG	2	8	23
1971	InFan1SrvAmpSpeed_6_path1_T_H_OP10	9500	9000	{}	decreasing	A6-P1	A2	2	8	23
1972	InFan1SrvAmpSpeed_7_path1_T_H_OP10	8500	7500	{}	decreasing	A7-P1	AT	2	8	23
1973	ServoLoad_0_path1_T_H_OP10	NaN	NaN	{}	increasing	A0-P1	X	17	17	23
1974	ServoLoad_1_path1_T_H_OP10	NaN	NaN	{}	increasing	A1-P1	Z	17	17	23
1975	ServoLoad_2_path1_T_H_OP10	NaN	NaN	{}	increasing	A2-P1	Y	17	17	23
1976	ServoLoad_3_path1_T_H_OP10	NaN	NaN	{}	increasing	A3-P1	YS	17	17	23
1978	ServoLoad_5_path1_T_H_OP10	NaN	NaN	{}	increasing	A5-P1	BMG	17	17	23
1979	ServoLoad_6_path1_T_H_OP10	NaN	NaN	{}	increasing	A6-P1	A2	17	17	23
1980	ServoLoad_7_path1_T_H_OP10	NaN	NaN	{}	increasing	A7-P1	AT	17	17	23
1981	SpindleLoad_0_path1_T_H_OP10	NaN	NaN	{}	increasing	SP-P1	SP	17	17	23
1982	SpdBatZero_0_path1_T_H_OP10	NaN	NaN	{}	bool	A0-P1	X	6	13	23
1983	SpdBatZero_1_path1_T_H_OP10	NaN	NaN	{}	bool	A1-P1	Z	6	13	23
1984	SpdBatZero_2_path1_T_H_OP10	NaN	NaN	{}	bool	A2-P1	Y	6	13	23
1985	SpdBatZero_3_path1_T_H_OP10	NaN	NaN	{}	bool	A3-P1	YS	6	13	23
1987	SpdBatZero_5_path1_T_H_OP10	NaN	NaN	{}	bool	A5-P1	BMG	6	13	23
1988	SpdBatZero_6_path1_T_H_OP10	NaN	NaN	{}	bool	A6-P1	A2	6	13	23
1989	SpdBatZero_7_path1_T_H_OP10	NaN	NaN	{}	bool	A7-P1	AT	6	13	23
1990	SSpdBatZero_0_path1_T_H_OP10	NaN	NaN	{}	bool	A0-P1	X	6	14	23
1991	SSpdBatZero_1_path1_T_H_OP10	NaN	NaN	{}	bool	A1-P1	Z	6	14	23
1992	SSpdBatZero_2_path1_T_H_OP10	NaN	NaN	{}	bool	A2-P1	Y	6	14	23
1993	SSpdBatZero_3_path1_T_H_OP10	NaN	NaN	{}	bool	A3-P1	YS	6	14	23
1995	SSpdBatZero_5_path1_T_H_OP10	NaN	NaN	{}	bool	A5-P1	BMG	6	14	23
1996	SSpdBatZero_6_path1_T_H_OP10	NaN	NaN	{}	bool	A6-P1	A2	6	14	23
1997	SSpdBatZero_7_path1_T_H_OP10	NaN	NaN	{}	bool	A7-P1	AT	6	14	23
1998	RadFan2SpindleAmpSpeed_0_path1_T_H_OP10	5000	4500	{}	decreasing	SP-P1	SP	2	16	23
1999	RadFan2SrvAmpSpeed_0_path1_T_H_OP10	5000	4500	{}	decreasing	A0-P1	X	2	16	23
2000	RadFan2SrvAmpSpeed_1_path1_T_H_OP10	5000	4500	{}	decreasing	A1-P1	Z	2	16	23
2001	RadFan2SrvAmpSpeed_2_path1_T_H_OP10	5000	4500	{}	decreasing	A2-P1	Y	2	16	23
2002	RadFan2SrvAmpSpeed_3_path1_T_H_OP10	5000	4500	{}	decreasing	A3-P1	YS	2	16	23
2004	RadFan2SrvAmpSpeed_5_path1_T_H_OP10	5000	4500	{}	decreasing	A5-P1	BMG	2	16	23
2005	RadFan2SrvAmpSpeed_6_path1_T_H_OP10	5000	4500	{}	decreasing	A6-P1	A2	2	16	23
2006	RadFan2SrvAmpSpeed_7_path1_T_H_OP10	5000	4500	{}	decreasing	A7-P1	AT	2	16	23
2007	ApcBatLow_0_path1_T_H_OP10	NaN	NaN	{}	bool	A0-P1	X	6	1	23
2008	ApcBatLow_1_path1_T_H_OP10	NaN	NaN	{}	bool	A1-P1	Z	6	1	23
2009	ApcBatLow_2_path1_T_H_OP10	NaN	NaN	{}	bool	A2-P1	Y	6	1	23
2010	ApcBatLow_3_path1_T_H_OP10	NaN	NaN	{}	bool	A3-P1	YS	6	1	23
2012	ApcBatLow_5_path1_T_H_OP10	NaN	NaN	{}	bool	A5-P1	BMG	6	1	23
2013	ApcBatLow_6_path1_T_H_OP10	NaN	NaN	{}	bool	A6-P1	A2	6	1	23
2014	ApcBatLow_7_path1_T_H_OP10	NaN	NaN	{}	bool	A7-P1	AT	6	1	23
2015	CncBatLow_0_path1_T_H_OP10	NaN	NaN	{}	bool	A0-P1	X	6	2	23
2016	CncBatLow_1_path1_T_H_OP10	NaN	NaN	{}	bool	A1-P1	Z	6	2	23
2017	CncBatLow_2_path1_T_H_OP10	NaN	NaN	{}	bool	A2-P1	Y	6	2	23
2018	CncBatLow_3_path1_T_H_OP10	NaN	NaN	{}	bool	A3-P1	YS	6	2	23
2020	CncBatLow_5_path1_T_H_OP10	NaN	NaN	{}	bool	A5-P1	BMG	6	2	23
2021	CncBatLow_6_path1_T_H_OP10	NaN	NaN	{}	bool	A6-P1	A2	6	2	23
2022	CncBatLow_7_path1_T_H_OP10	NaN	NaN	{}	bool	A7-P1	AT	6	2	23
2023	ServoLeakResistData_0_path1_T_H_OP10	50	30	{}	decreasing	A0-P1	X	15	5	23
2024	ServoLeakResistData_1_path1_T_H_OP10	50	30	{}	decreasing	A1-P1	Z	15	5	23
2025	ServoLeakResistData_2_path1_T_H_OP10	50	30	{}	decreasing	A2-P1	Y	15	5	23
2026	ServoLeakResistData_3_path1_T_H_OP10	50	30	{}	decreasing	A3-P1	YS	15	5	23
2028	ServoLeakResistData_5_path1_T_H_OP10	50	30	{}	decreasing	A5-P1	BMG	15	5	23
2029	ServoLeakResistData_6_path1_T_H_OP10	50	30	{}	decreasing	A6-P1	A2	15	5	23
2030	ServoLeakResistData_7_path1_T_H_OP10	50	30	{}	decreasing	A7-P1	AT	15	5	23
2031	SpindleLeakResistData_0_path1_T_H_OP10	50	30	{}	decreasing	SP-P1	SP	15	5	23
2032	InFan1SrvComPwSpeed_0_path1_T_H_OP10	6200	6000	{}	decreasing	A0-P1	X	2	9	23
2033	InFan1SrvComPwSpeed_1_path1_T_H_OP10	6200	6000	{}	decreasing	A1-P1	Z	2	9	23
2034	InFan1SrvComPwSpeed_2_path1_T_H_OP10	6200	6000	{}	decreasing	A2-P1	Y	2	9	23
2035	InFan1SrvComPwSpeed_3_path1_T_H_OP10	6200	6000	{}	decreasing	A3-P1	YS	2	9	23
2037	InFan1SrvComPwSpeed_5_path1_T_H_OP10	6200	6000	{}	decreasing	A5-P1	BMG	2	9	23
2038	InFan1SrvComPwSpeed_6_path1_T_H_OP10	6200	6000	{}	decreasing	A6-P1	A2	2	9	23
2039	InFan1SrvComPwSpeed_7_path1_T_H_OP10	6200	6000	{}	decreasing	A7-P1	AT	2	9	23
2040	InFan2SrvAmpSpeed_0_path1_T_H_OP10	5000	4500	{}	decreasing	A0-P1	X	2	11	23
2041	InFan2SrvAmpSpeed_1_path1_T_H_OP10	5000	4500	{}	decreasing	A1-P1	Z	2	11	23
2042	InFan2SrvAmpSpeed_2_path1_T_H_OP10	5000	4500	{}	decreasing	A2-P1	Y	2	11	23
2043	InFan2SrvAmpSpeed_3_path1_T_H_OP10	5000	4500	{}	decreasing	A3-P1	YS	2	11	23
2045	InFan2SrvAmpSpeed_5_path1_T_H_OP10	5000	4500	{}	decreasing	A5-P1	BMG	2	11	23
2046	InFan2SrvAmpSpeed_6_path1_T_H_OP10	5000	4500	{}	decreasing	A6-P1	A2	2	11	23
2047	InFan2SrvAmpSpeed_7_path1_T_H_OP10	5000	4500	{}	decreasing	A7-P1	AT	2	11	23
2048	RadFan1SpindleAmpSpeed_0_path1_T_H_OP10	5000	4500	{}	decreasing	SP-P1	SP	2	15	23
2049	RadFan1SrvAmpSpeed_0_path1_T_H_OP10	5000	4500	{}	decreasing	A0-P1	X	2	15	23
2050	RadFan1SrvAmpSpeed_1_path1_T_H_OP10	5000	4500	{}	decreasing	A1-P1	Z	2	15	23
2051	RadFan1SrvAmpSpeed_2_path1_T_H_OP10	5000	4500	{}	decreasing	A2-P1	Y	2	15	23
2052	RadFan1SrvAmpSpeed_3_path1_T_H_OP10	5000	4500	{}	decreasing	A3-P1	YS	2	15	23
2054	RadFan1SrvAmpSpeed_5_path1_T_H_OP10	5000	4500	{}	decreasing	A5-P1	BMG	2	15	23
2055	RadFan1SrvAmpSpeed_6_path1_T_H_OP10	5000	4500	{}	decreasing	A6-P1	A2	2	15	23
2056	RadFan1SrvAmpSpeed_7_path1_T_H_OP10	5000	4500	{}	decreasing	A7-P1	AT	2	15	23
2057	InFan2SpdlComPwSpeed_0_path1_T_H_OP10	5000	4500	{}	decreasing	A0-P1	SAS	2	10	23
2058	InFan2SpindleAmpSpeed_0_path1_T_H_OP10	5000	4500	{}	decreasing	A0-P1	SCS	2	10	23
2059	InFan2SrvComPwSpeed_0_path1_T_H_OP10	5000	4500	{}	decreasing	A0-P1	X	2	12	23
2060	InFan2SrvComPwSpeed_1_path1_T_H_OP10	5000	4500	{}	decreasing	A1-P1	Z	2	12	23
2061	InFan2SrvComPwSpeed_2_path1_T_H_OP10	5000	4500	{}	decreasing	A2-P1	Y	2	12	23
2062	InFan2SrvComPwSpeed_3_path1_T_H_OP10	5000	4500	{}	decreasing	A3-P1	YS	2	12	23
2064	InFan2SrvComPwSpeed_5_path1_T_H_OP10	5000	4500	{}	decreasing	A5-P1	BMG	2	12	23
2065	InFan2SrvComPwSpeed_6_path1_T_H_OP10	5000	4500	{}	decreasing	A6-P1	A2	2	12	23
2066	InFan2SrvComPwSpeed_7_path1_T_H_OP10	5000	4500	{}	decreasing	A7-P1	AT	2	12	23
2067	InFan1SpdlComPwSpeed_0_path1_T_H_OP10	5000	4500	{}	decreasing	A0-P1	SAS	2	7	23
2068	InFan1SpindleAmpSpeed_0_path1_T_H_OP10	6200	6000	{}	decreasing	A0-P1	SCS	2	7	23
2069	ServoTemp_0_path1_T_H_OP10	55	70	{}	increasing	A0-P1	X	13	3	23
2070	ServoTemp_1_path1_T_H_OP10	55	70	{}	increasing	A1-P1	Z	13	3	23
2071	ServoTemp_2_path1_T_H_OP10	55	70	{}	increasing	A2-P1	Y	13	3	23
2072	ServoTemp_3_path1_T_H_OP10	55	70	{}	increasing	A3-P1	YS	13	3	23
2074	ServoTemp_5_path1_T_H_OP10	55	70	{}	increasing	A5-P1	BMG	13	3	23
2075	ServoTemp_6_path1_T_H_OP10	55	70	{}	increasing	A6-P1	A2	13	3	23
2076	ServoTemp_7_path1_T_H_OP10	55	70	{}	increasing	A7-P1	AT	13	3	23
2077	SpindleTemp_0_path1_T_H_OP10	80	100	{}	increasing	SP-P1	SP	13	3	23
2078	PulseCoderTemp_0_path1_T_H_OP100A	60	80	{}	increasing	A0-P1	X	13	4	24
2079	PulseCoderTemp_1_path1_T_H_OP100A	60	80	{}	increasing	A1-P1	Z	13	4	24
2080	PulseCoderTemp_2_path1_T_H_OP100A	65	80	{}	increasing	A2-P1	Y	13	4	24
2081	PulseCoderTemp_3_path1_T_H_OP100A	70	80	{}	increasing	A3-P1	YS	13	4	24
2082	PulseCoderTemp_4_path1_T_H_OP100A	60	80	{}	increasing	A4-P1	B1	13	4	24
2083	PulseCoderTemp_5_path1_T_H_OP100A	60	80	{}	increasing	A5-P1	BMG	13	4	24
2084	PulseCoderTemp_6_path1_T_H_OP100A	60	80	{}	increasing	A6-P1	A2	13	4	24
2085	PulseCoderTemp_7_path1_T_H_OP100A	60	80	{}	increasing	A7-P1	AT	13	4	24
2090	InFan1SrvAmpSpeed_0_path1_T_H_OP100A	9500	9000	{}	decreasing	A0-P1	X	2	8	24
2091	InFan1SrvAmpSpeed_1_path1_T_H_OP100A	9500	9000	{}	decreasing	A1-P1	Z	2	8	24
2092	InFan1SrvAmpSpeed_2_path1_T_H_OP100A	9500	9000	{}	decreasing	A2-P1	Y	2	8	24
2093	InFan1SrvAmpSpeed_3_path1_T_H_OP100A	9500	9000	{}	decreasing	A3-P1	YS	2	8	24
2094	InFan1SrvAmpSpeed_4_path1_T_H_OP100A	8500	7500	{}	decreasing	A4-P1	B1	2	8	24
2095	InFan1SrvAmpSpeed_5_path1_T_H_OP100A	8500	7500	{}	decreasing	A5-P1	BMG	2	8	24
2096	InFan1SrvAmpSpeed_6_path1_T_H_OP100A	9500	9000	{}	decreasing	A6-P1	A2	2	8	24
2097	InFan1SrvAmpSpeed_7_path1_T_H_OP100A	8500	7500	{}	decreasing	A7-P1	AT	2	8	24
2098	ServoLoad_0_path1_T_H_OP100A	NaN	NaN	{}	increasing	A0-P1	X	17	17	24
2099	ServoLoad_1_path1_T_H_OP100A	NaN	NaN	{}	increasing	A1-P1	Z	17	17	24
2100	ServoLoad_2_path1_T_H_OP100A	NaN	NaN	{}	increasing	A2-P1	Y	17	17	24
2101	ServoLoad_3_path1_T_H_OP100A	NaN	NaN	{}	increasing	A3-P1	YS	17	17	24
2102	ServoLoad_4_path1_T_H_OP100A	NaN	NaN	{}	increasing	A4-P1	B1	17	17	24
2103	ServoLoad_5_path1_T_H_OP100A	NaN	NaN	{}	increasing	A5-P1	BMG	17	17	24
2104	ServoLoad_6_path1_T_H_OP100A	NaN	NaN	{}	increasing	A6-P1	A2	17	17	24
2105	ServoLoad_7_path1_T_H_OP100A	NaN	NaN	{}	increasing	A7-P1	AT	17	17	24
2106	SpindleLoad_0_path1_T_H_OP100A	NaN	NaN	{}	increasing	SP-P1	SP	17	17	24
2107	SpdBatZero_0_path1_T_H_OP100A	NaN	NaN	{}	bool	A0-P1	X	6	13	24
2108	SpdBatZero_1_path1_T_H_OP100A	NaN	NaN	{}	bool	A1-P1	Z	6	13	24
2109	SpdBatZero_2_path1_T_H_OP100A	NaN	NaN	{}	bool	A2-P1	Y	6	13	24
2110	SpdBatZero_3_path1_T_H_OP100A	NaN	NaN	{}	bool	A3-P1	YS	6	13	24
2111	SpdBatZero_4_path1_T_H_OP100A	NaN	NaN	{}	bool	A4-P1	B1	6	13	24
2112	SpdBatZero_5_path1_T_H_OP100A	NaN	NaN	{}	bool	A5-P1	BMG	6	13	24
2113	SpdBatZero_6_path1_T_H_OP100A	NaN	NaN	{}	bool	A6-P1	A2	6	13	24
2114	SpdBatZero_7_path1_T_H_OP100A	NaN	NaN	{}	bool	A7-P1	AT	6	13	24
2115	SSpdBatZero_0_path1_T_H_OP100A	NaN	NaN	{}	bool	A0-P1	X	6	14	24
2116	SSpdBatZero_1_path1_T_H_OP100A	NaN	NaN	{}	bool	A1-P1	Z	6	14	24
2117	SSpdBatZero_2_path1_T_H_OP100A	NaN	NaN	{}	bool	A2-P1	Y	6	14	24
2118	SSpdBatZero_3_path1_T_H_OP100A	NaN	NaN	{}	bool	A3-P1	YS	6	14	24
2119	SSpdBatZero_4_path1_T_H_OP100A	NaN	NaN	{}	bool	A4-P1	B1	6	14	24
2120	SSpdBatZero_5_path1_T_H_OP100A	NaN	NaN	{}	bool	A5-P1	BMG	6	14	24
2121	SSpdBatZero_6_path1_T_H_OP100A	NaN	NaN	{}	bool	A6-P1	A2	6	14	24
2122	SSpdBatZero_7_path1_T_H_OP100A	NaN	NaN	{}	bool	A7-P1	AT	6	14	24
2123	RadFan2SpindleAmpSpeed_0_path1_T_H_OP100A	5000	4500	{}	decreasing	SP-P1	SP	2	16	24
2124	RadFan2SrvAmpSpeed_0_path1_T_H_OP100A	5000	4500	{}	decreasing	A0-P1	X	2	16	24
2125	RadFan2SrvAmpSpeed_1_path1_T_H_OP100A	5000	4500	{}	decreasing	A1-P1	Z	2	16	24
2126	RadFan2SrvAmpSpeed_2_path1_T_H_OP100A	5000	4500	{}	decreasing	A2-P1	Y	2	16	24
2127	RadFan2SrvAmpSpeed_3_path1_T_H_OP100A	5000	4500	{}	decreasing	A3-P1	YS	2	16	24
2128	RadFan2SrvAmpSpeed_4_path1_T_H_OP100A	5000	4500	{}	decreasing	A4-P1	B1	2	16	24
2129	RadFan2SrvAmpSpeed_5_path1_T_H_OP100A	5000	4500	{}	decreasing	A5-P1	BMG	2	16	24
2130	RadFan2SrvAmpSpeed_6_path1_T_H_OP100A	5000	4500	{}	decreasing	A6-P1	A2	2	16	24
2131	RadFan2SrvAmpSpeed_7_path1_T_H_OP100A	5000	4500	{}	decreasing	A7-P1	AT	2	16	24
2132	ApcBatLow_0_path1_T_H_OP100A	NaN	NaN	{}	bool	A0-P1	X	6	1	24
2133	ApcBatLow_1_path1_T_H_OP100A	NaN	NaN	{}	bool	A1-P1	Z	6	1	24
2134	ApcBatLow_2_path1_T_H_OP100A	NaN	NaN	{}	bool	A2-P1	Y	6	1	24
2135	ApcBatLow_3_path1_T_H_OP100A	NaN	NaN	{}	bool	A3-P1	YS	6	1	24
2136	ApcBatLow_4_path1_T_H_OP100A	NaN	NaN	{}	bool	A4-P1	B1	6	1	24
2137	ApcBatLow_5_path1_T_H_OP100A	NaN	NaN	{}	bool	A5-P1	BMG	6	1	24
2138	ApcBatLow_6_path1_T_H_OP100A	NaN	NaN	{}	bool	A6-P1	A2	6	1	24
2139	ApcBatLow_7_path1_T_H_OP100A	NaN	NaN	{}	bool	A7-P1	AT	6	1	24
2140	CncBatLow_0_path1_T_H_OP100A	NaN	NaN	{}	bool	A0-P1	X	6	2	24
2141	CncBatLow_1_path1_T_H_OP100A	NaN	NaN	{}	bool	A1-P1	Z	6	2	24
2142	CncBatLow_2_path1_T_H_OP100A	NaN	NaN	{}	bool	A2-P1	Y	6	2	24
2143	CncBatLow_3_path1_T_H_OP100A	NaN	NaN	{}	bool	A3-P1	YS	6	2	24
2144	CncBatLow_4_path1_T_H_OP100A	NaN	NaN	{}	bool	A4-P1	B1	6	2	24
2145	CncBatLow_5_path1_T_H_OP100A	NaN	NaN	{}	bool	A5-P1	BMG	6	2	24
2146	CncBatLow_6_path1_T_H_OP100A	NaN	NaN	{}	bool	A6-P1	A2	6	2	24
2147	CncBatLow_7_path1_T_H_OP100A	NaN	NaN	{}	bool	A7-P1	AT	6	2	24
2148	ServoLeakResistData_0_path1_T_H_OP100A	50	30	{}	decreasing	A0-P1	X	15	5	24
2149	ServoLeakResistData_1_path1_T_H_OP100A	50	30	{}	decreasing	A1-P1	Z	15	5	24
2150	ServoLeakResistData_2_path1_T_H_OP100A	50	30	{}	decreasing	A2-P1	Y	15	5	24
2151	ServoLeakResistData_3_path1_T_H_OP100A	50	30	{}	decreasing	A3-P1	YS	15	5	24
2152	ServoLeakResistData_4_path1_T_H_OP100A	50	30	{}	decreasing	A4-P1	B1	15	5	24
2153	ServoLeakResistData_5_path1_T_H_OP100A	50	30	{}	decreasing	A5-P1	BMG	15	5	24
2154	ServoLeakResistData_6_path1_T_H_OP100A	50	30	{}	decreasing	A6-P1	A2	15	5	24
2155	ServoLeakResistData_7_path1_T_H_OP100A	50	30	{}	decreasing	A7-P1	AT	15	5	24
2156	SpindleLeakResistData_0_path1_T_H_OP100A	50	30	{}	decreasing	SP-P1	SP	15	5	24
2157	InFan1SrvComPwSpeed_0_path1_T_H_OP100A	6200	6000	{}	decreasing	A0-P1	X	2	9	24
2158	InFan1SrvComPwSpeed_1_path1_T_H_OP100A	6200	6000	{}	decreasing	A1-P1	Z	2	9	24
2159	InFan1SrvComPwSpeed_2_path1_T_H_OP100A	6200	6000	{}	decreasing	A2-P1	Y	2	9	24
2160	InFan1SrvComPwSpeed_3_path1_T_H_OP100A	6200	6000	{}	decreasing	A3-P1	YS	2	9	24
2161	InFan1SrvComPwSpeed_4_path1_T_H_OP100A	6200	6000	{}	decreasing	A4-P1	B1	2	9	24
2162	InFan1SrvComPwSpeed_5_path1_T_H_OP100A	6200	6000	{}	decreasing	A5-P1	BMG	2	9	24
2163	InFan1SrvComPwSpeed_6_path1_T_H_OP100A	6200	6000	{}	decreasing	A6-P1	A2	2	9	24
2164	InFan1SrvComPwSpeed_7_path1_T_H_OP100A	6200	6000	{}	decreasing	A7-P1	AT	2	9	24
2165	InFan2SrvAmpSpeed_0_path1_T_H_OP100A	5000	4500	{}	decreasing	A0-P1	X	2	11	24
2166	InFan2SrvAmpSpeed_1_path1_T_H_OP100A	5000	4500	{}	decreasing	A1-P1	Z	2	11	24
2167	InFan2SrvAmpSpeed_2_path1_T_H_OP100A	5000	4500	{}	decreasing	A2-P1	Y	2	11	24
2168	InFan2SrvAmpSpeed_3_path1_T_H_OP100A	5000	4500	{}	decreasing	A3-P1	YS	2	11	24
2169	InFan2SrvAmpSpeed_4_path1_T_H_OP100A	5000	4500	{}	decreasing	A4-P1	B1	2	11	24
2170	InFan2SrvAmpSpeed_5_path1_T_H_OP100A	5000	4500	{}	decreasing	A5-P1	BMG	2	11	24
2171	InFan2SrvAmpSpeed_6_path1_T_H_OP100A	5000	4500	{}	decreasing	A6-P1	A2	2	11	24
2172	InFan2SrvAmpSpeed_7_path1_T_H_OP100A	5000	4500	{}	decreasing	A7-P1	AT	2	11	24
2173	RadFan1SpindleAmpSpeed_0_path1_T_H_OP100A	5000	4500	{}	decreasing	SP-P1	SP	2	15	24
2174	RadFan1SrvAmpSpeed_0_path1_T_H_OP100A	5000	4500	{}	decreasing	A0-P1	X	2	15	24
2175	RadFan1SrvAmpSpeed_1_path1_T_H_OP100A	5000	4500	{}	decreasing	A1-P1	Z	2	15	24
2176	RadFan1SrvAmpSpeed_2_path1_T_H_OP100A	5000	4500	{}	decreasing	A2-P1	Y	2	15	24
2177	RadFan1SrvAmpSpeed_3_path1_T_H_OP100A	5000	4500	{}	decreasing	A3-P1	YS	2	15	24
2178	RadFan1SrvAmpSpeed_4_path1_T_H_OP100A	5000	4500	{}	decreasing	A4-P1	B1	2	15	24
2179	RadFan1SrvAmpSpeed_5_path1_T_H_OP100A	5000	4500	{}	decreasing	A5-P1	BMG	2	15	24
2180	RadFan1SrvAmpSpeed_6_path1_T_H_OP100A	5000	4500	{}	decreasing	A6-P1	A2	2	15	24
2181	RadFan1SrvAmpSpeed_7_path1_T_H_OP100A	5000	4500	{}	decreasing	A7-P1	AT	2	15	24
2182	InFan2SpdlComPwSpeed_0_path1_T_H_OP100A	5000	4500	{}	decreasing	A0-P1	SAS	2	10	24
2183	InFan2SpindleAmpSpeed_0_path1_T_H_OP100A	5000	4500	{}	decreasing	A0-P1	SCS	2	10	24
2184	InFan2SrvComPwSpeed_0_path1_T_H_OP100A	5000	4500	{}	decreasing	A0-P1	X	2	12	24
2185	InFan2SrvComPwSpeed_1_path1_T_H_OP100A	5000	4500	{}	decreasing	A1-P1	Z	2	12	24
2186	InFan2SrvComPwSpeed_2_path1_T_H_OP100A	5000	4500	{}	decreasing	A2-P1	Y	2	12	24
2187	InFan2SrvComPwSpeed_3_path1_T_H_OP100A	5000	4500	{}	decreasing	A3-P1	YS	2	12	24
2188	InFan2SrvComPwSpeed_4_path1_T_H_OP100A	5000	4500	{}	decreasing	A4-P1	B1	2	12	24
2189	InFan2SrvComPwSpeed_5_path1_T_H_OP100A	5000	4500	{}	decreasing	A5-P1	BMG	2	12	24
2190	InFan2SrvComPwSpeed_6_path1_T_H_OP100A	5000	4500	{}	decreasing	A6-P1	A2	2	12	24
2191	InFan2SrvComPwSpeed_7_path1_T_H_OP100A	5000	4500	{}	decreasing	A7-P1	AT	2	12	24
2192	InFan1SpdlComPwSpeed_0_path1_T_H_OP100A	5000	4500	{}	decreasing	A0-P1	SAS	2	7	24
2193	InFan1SpindleAmpSpeed_0_path1_T_H_OP100A	6200	6000	{}	decreasing	A0-P1	SCS	2	7	24
2194	ServoTemp_0_path1_T_H_OP100A	55	70	{}	increasing	A0-P1	X	13	3	24
2195	ServoTemp_1_path1_T_H_OP100A	55	70	{}	increasing	A1-P1	Z	13	3	24
2196	ServoTemp_2_path1_T_H_OP100A	55	70	{}	increasing	A2-P1	Y	13	3	24
2197	ServoTemp_3_path1_T_H_OP100A	55	70	{}	increasing	A3-P1	YS	13	3	24
2198	ServoTemp_4_path1_T_H_OP100A	55	70	{}	increasing	A4-P1	B1	13	3	24
2199	ServoTemp_5_path1_T_H_OP100A	55	70	{}	increasing	A5-P1	BMG	13	3	24
2200	ServoTemp_6_path1_T_H_OP100A	55	70	{}	increasing	A6-P1	A2	13	3	24
2201	ServoTemp_7_path1_T_H_OP100A	55	70	{}	increasing	A7-P1	AT	13	3	24
2202	SpindleTemp_0_path1_T_H_OP100A	80	100	{}	increasing	SP-P1	SP	13	3	24
2203	PulseCoderTemp_0_path1_T_H_OP100B	60	80	{}	increasing	A0-P1	X	13	4	25
2204	PulseCoderTemp_1_path1_T_H_OP100B	60	80	{}	increasing	A1-P1	Z	13	4	25
2205	PulseCoderTemp_2_path1_T_H_OP100B	70	80	{}	increasing	A2-P1	Y	13	4	25
2206	PulseCoderTemp_3_path1_T_H_OP100B	60	80	{}	increasing	A3-P1	YS	13	4	25
2207	PulseCoderTemp_4_path1_T_H_OP100B	60	80	{}	increasing	A4-P1	B1	13	4	25
2208	PulseCoderTemp_5_path1_T_H_OP100B	60	80	{}	increasing	A5-P1	BMG	13	4	25
2209	PulseCoderTemp_6_path1_T_H_OP100B	60	80	{}	increasing	A6-P1	A2	13	4	25
2210	PulseCoderTemp_7_path1_T_H_OP100B	60	80	{}	increasing	A7-P1	AT	13	4	25
2211	CncFan1Speed_path1_T_H_OP100B	4500	4000	{}	decreasing	A1-P1	F1	16	6	25
2212	CncFan2Speed_path1_T_H_OP100B	9600	8600	{}	decreasing	A2-P1	F3	16	6	25
2215	InFan1SrvAmpSpeed_0_path1_T_H_OP100B	9500	9000	{}	decreasing	A0-P1	X	2	8	25
2216	InFan1SrvAmpSpeed_1_path1_T_H_OP100B	9500	9000	{}	decreasing	A1-P1	Z	2	8	25
2217	InFan1SrvAmpSpeed_2_path1_T_H_OP100B	9500	9000	{}	decreasing	A2-P1	Y	2	8	25
2218	InFan1SrvAmpSpeed_3_path1_T_H_OP100B	9500	9000	{}	decreasing	A3-P1	YS	2	8	25
2219	InFan1SrvAmpSpeed_4_path1_T_H_OP100B	8500	7500	{}	decreasing	A4-P1	B1	2	8	25
2220	InFan1SrvAmpSpeed_5_path1_T_H_OP100B	8500	7500	{}	decreasing	A5-P1	BMG	2	8	25
2221	InFan1SrvAmpSpeed_6_path1_T_H_OP100B	9500	9000	{}	decreasing	A6-P1	A2	2	8	25
2222	InFan1SrvAmpSpeed_7_path1_T_H_OP100B	8500	7500	{}	decreasing	A7-P1	AT	2	8	25
2223	ServoLoad_0_path1_T_H_OP100B	NaN	NaN	{}	increasing	A0-P1	X	17	17	25
2224	ServoLoad_1_path1_T_H_OP100B	NaN	NaN	{}	increasing	A1-P1	Z	17	17	25
2225	ServoLoad_2_path1_T_H_OP100B	NaN	NaN	{}	increasing	A2-P1	Y	17	17	25
2226	ServoLoad_3_path1_T_H_OP100B	NaN	NaN	{}	increasing	A3-P1	YS	17	17	25
2227	ServoLoad_4_path1_T_H_OP100B	NaN	NaN	{}	increasing	A4-P1	B1	17	17	25
2228	ServoLoad_5_path1_T_H_OP100B	NaN	NaN	{}	increasing	A5-P1	BMG	17	17	25
2229	ServoLoad_6_path1_T_H_OP100B	NaN	NaN	{}	increasing	A6-P1	A2	17	17	25
2230	ServoLoad_7_path1_T_H_OP100B	NaN	NaN	{}	increasing	A7-P1	AT	17	17	25
2231	SpindleLoad_0_path1_T_H_OP100B	NaN	NaN	{}	increasing	SP-P1	SP	17	17	25
2232	SpdBatZero_0_path1_T_H_OP100B	NaN	NaN	{}	bool	A0-P1	X	6	13	25
2233	SpdBatZero_1_path1_T_H_OP100B	NaN	NaN	{}	bool	A1-P1	Z	6	13	25
2234	SpdBatZero_2_path1_T_H_OP100B	NaN	NaN	{}	bool	A2-P1	Y	6	13	25
2235	SpdBatZero_3_path1_T_H_OP100B	NaN	NaN	{}	bool	A3-P1	YS	6	13	25
2236	SpdBatZero_4_path1_T_H_OP100B	NaN	NaN	{}	bool	A4-P1	B1	6	13	25
2237	SpdBatZero_5_path1_T_H_OP100B	NaN	NaN	{}	bool	A5-P1	BMG	6	13	25
2238	SpdBatZero_6_path1_T_H_OP100B	NaN	NaN	{}	bool	A6-P1	A2	6	13	25
2239	SpdBatZero_7_path1_T_H_OP100B	NaN	NaN	{}	bool	A7-P1	AT	6	13	25
2240	SSpdBatZero_0_path1_T_H_OP100B	NaN	NaN	{}	bool	A0-P1	X	6	14	25
2241	SSpdBatZero_1_path1_T_H_OP100B	NaN	NaN	{}	bool	A1-P1	Z	6	14	25
2242	SSpdBatZero_2_path1_T_H_OP100B	NaN	NaN	{}	bool	A2-P1	Y	6	14	25
2243	SSpdBatZero_3_path1_T_H_OP100B	NaN	NaN	{}	bool	A3-P1	YS	6	14	25
2244	SSpdBatZero_4_path1_T_H_OP100B	NaN	NaN	{}	bool	A4-P1	B1	6	14	25
2245	SSpdBatZero_5_path1_T_H_OP100B	NaN	NaN	{}	bool	A5-P1	BMG	6	14	25
2246	SSpdBatZero_6_path1_T_H_OP100B	NaN	NaN	{}	bool	A6-P1	A2	6	14	25
2247	SSpdBatZero_7_path1_T_H_OP100B	NaN	NaN	{}	bool	A7-P1	AT	6	14	25
2248	RadFan2SpindleAmpSpeed_0_path1_T_H_OP100B	5000	4500	{}	decreasing	SP-P1	SP	2	16	25
2249	RadFan2SrvAmpSpeed_0_path1_T_H_OP100B	5000	4500	{}	decreasing	A0-P1	X	2	16	25
2250	RadFan2SrvAmpSpeed_1_path1_T_H_OP100B	5000	4500	{}	decreasing	A1-P1	Z	2	16	25
2251	RadFan2SrvAmpSpeed_2_path1_T_H_OP100B	5000	4500	{}	decreasing	A2-P1	Y	2	16	25
2252	RadFan2SrvAmpSpeed_3_path1_T_H_OP100B	5000	4500	{}	decreasing	A3-P1	YS	2	16	25
2253	RadFan2SrvAmpSpeed_4_path1_T_H_OP100B	5000	4500	{}	decreasing	A4-P1	B1	2	16	25
2254	RadFan2SrvAmpSpeed_5_path1_T_H_OP100B	5000	4500	{}	decreasing	A5-P1	BMG	2	16	25
2255	RadFan2SrvAmpSpeed_6_path1_T_H_OP100B	5000	4500	{}	decreasing	A6-P1	A2	2	16	25
2256	RadFan2SrvAmpSpeed_7_path1_T_H_OP100B	5000	4500	{}	decreasing	A7-P1	AT	2	16	25
2257	ApcBatLow_0_path1_T_H_OP100B	NaN	NaN	{}	bool	A0-P1	X	6	1	25
2258	ApcBatLow_1_path1_T_H_OP100B	NaN	NaN	{}	bool	A1-P1	Z	6	1	25
2259	ApcBatLow_2_path1_T_H_OP100B	NaN	NaN	{}	bool	A2-P1	Y	6	1	25
2260	ApcBatLow_3_path1_T_H_OP100B	NaN	NaN	{}	bool	A3-P1	YS	6	1	25
2261	ApcBatLow_4_path1_T_H_OP100B	NaN	NaN	{}	bool	A4-P1	B1	6	1	25
2262	ApcBatLow_5_path1_T_H_OP100B	NaN	NaN	{}	bool	A5-P1	BMG	6	1	25
2263	ApcBatLow_6_path1_T_H_OP100B	NaN	NaN	{}	bool	A6-P1	A2	6	1	25
2264	ApcBatLow_7_path1_T_H_OP100B	NaN	NaN	{}	bool	A7-P1	AT	6	1	25
2265	CncBatLow_0_path1_T_H_OP100B	NaN	NaN	{}	bool	A0-P1	X	6	2	25
2266	CncBatLow_1_path1_T_H_OP100B	NaN	NaN	{}	bool	A1-P1	Z	6	2	25
2267	CncBatLow_2_path1_T_H_OP100B	NaN	NaN	{}	bool	A2-P1	Y	6	2	25
2268	CncBatLow_3_path1_T_H_OP100B	NaN	NaN	{}	bool	A3-P1	YS	6	2	25
2269	CncBatLow_4_path1_T_H_OP100B	NaN	NaN	{}	bool	A4-P1	B1	6	2	25
2270	CncBatLow_5_path1_T_H_OP100B	NaN	NaN	{}	bool	A5-P1	BMG	6	2	25
2271	CncBatLow_6_path1_T_H_OP100B	NaN	NaN	{}	bool	A6-P1	A2	6	2	25
2272	CncBatLow_7_path1_T_H_OP100B	NaN	NaN	{}	bool	A7-P1	AT	6	2	25
2273	ServoLeakResistData_0_path1_T_H_OP100B	50	30	{}	decreasing	A0-P1	X	15	5	25
2274	ServoLeakResistData_1_path1_T_H_OP100B	50	30	{}	decreasing	A1-P1	Z	15	5	25
2275	ServoLeakResistData_2_path1_T_H_OP100B	50	30	{}	decreasing	A2-P1	Y	15	5	25
2276	ServoLeakResistData_3_path1_T_H_OP100B	50	30	{}	decreasing	A3-P1	YS	15	5	25
2277	ServoLeakResistData_4_path1_T_H_OP100B	50	30	{}	decreasing	A4-P1	B1	15	5	25
2278	ServoLeakResistData_5_path1_T_H_OP100B	50	30	{}	decreasing	A5-P1	BMG	15	5	25
2279	ServoLeakResistData_6_path1_T_H_OP100B	50	30	{}	decreasing	A6-P1	A2	15	5	25
2280	ServoLeakResistData_7_path1_T_H_OP100B	50	30	{}	decreasing	A7-P1	AT	15	5	25
2281	SpindleLeakResistData_0_path1_T_H_OP100B	50	30	{}	decreasing	SP-P1	SP	15	5	25
2282	InFan1SrvComPwSpeed_0_path1_T_H_OP100B	6200	6000	{}	decreasing	A0-P1	X	2	9	25
2283	InFan1SrvComPwSpeed_1_path1_T_H_OP100B	6200	6000	{}	decreasing	A1-P1	Z	2	9	25
2284	InFan1SrvComPwSpeed_2_path1_T_H_OP100B	6200	6000	{}	decreasing	A2-P1	Y	2	9	25
2285	InFan1SrvComPwSpeed_3_path1_T_H_OP100B	6200	6000	{}	decreasing	A3-P1	YS	2	9	25
2286	InFan1SrvComPwSpeed_4_path1_T_H_OP100B	6200	6000	{}	decreasing	A4-P1	B1	2	9	25
2287	InFan1SrvComPwSpeed_5_path1_T_H_OP100B	6200	6000	{}	decreasing	A5-P1	BMG	2	9	25
2288	InFan1SrvComPwSpeed_6_path1_T_H_OP100B	6200	6000	{}	decreasing	A6-P1	A2	2	9	25
2289	InFan1SrvComPwSpeed_7_path1_T_H_OP100B	6200	6000	{}	decreasing	A7-P1	AT	2	9	25
2290	InFan2SrvAmpSpeed_0_path1_T_H_OP100B	5000	4500	{}	decreasing	A0-P1	X	2	11	25
2291	InFan2SrvAmpSpeed_1_path1_T_H_OP100B	5000	4500	{}	decreasing	A1-P1	Z	2	11	25
2292	InFan2SrvAmpSpeed_2_path1_T_H_OP100B	5000	4500	{}	decreasing	A2-P1	Y	2	11	25
2293	InFan2SrvAmpSpeed_3_path1_T_H_OP100B	5000	4500	{}	decreasing	A3-P1	YS	2	11	25
2294	InFan2SrvAmpSpeed_4_path1_T_H_OP100B	5000	4500	{}	decreasing	A4-P1	B1	2	11	25
2295	InFan2SrvAmpSpeed_5_path1_T_H_OP100B	5000	4500	{}	decreasing	A5-P1	BMG	2	11	25
2296	InFan2SrvAmpSpeed_6_path1_T_H_OP100B	5000	4500	{}	decreasing	A6-P1	A2	2	11	25
2297	InFan2SrvAmpSpeed_7_path1_T_H_OP100B	5000	4500	{}	decreasing	A7-P1	AT	2	11	25
2298	RadFan1SpindleAmpSpeed_0_path1_T_H_OP100B	5000	4500	{}	decreasing	SP-P1	SP	2	15	25
2299	RadFan1SrvAmpSpeed_0_path1_T_H_OP100B	5000	4500	{}	decreasing	A0-P1	X	2	15	25
2300	RadFan1SrvAmpSpeed_1_path1_T_H_OP100B	5000	4500	{}	decreasing	A1-P1	Z	2	15	25
2301	RadFan1SrvAmpSpeed_2_path1_T_H_OP100B	5000	4500	{}	decreasing	A2-P1	Y	2	15	25
2302	RadFan1SrvAmpSpeed_3_path1_T_H_OP100B	5000	4500	{}	decreasing	A3-P1	YS	2	15	25
2303	RadFan1SrvAmpSpeed_4_path1_T_H_OP100B	5000	4500	{}	decreasing	A4-P1	B1	2	15	25
2304	RadFan1SrvAmpSpeed_5_path1_T_H_OP100B	5000	4500	{}	decreasing	A5-P1	BMG	2	15	25
2305	RadFan1SrvAmpSpeed_6_path1_T_H_OP100B	5000	4500	{}	decreasing	A6-P1	A2	2	15	25
2306	RadFan1SrvAmpSpeed_7_path1_T_H_OP100B	5000	4500	{}	decreasing	A7-P1	AT	2	15	25
2307	InFan2SpdlComPwSpeed_0_path1_T_H_OP100B	5000	4500	{}	decreasing	A0-P1	SAS	2	10	25
2308	InFan2SpindleAmpSpeed_0_path1_T_H_OP100B	5000	4500	{}	decreasing	A0-P1	SCS	2	10	25
2309	InFan2SrvComPwSpeed_0_path1_T_H_OP100B	5000	4500	{}	decreasing	A0-P1	X	2	12	25
2310	InFan2SrvComPwSpeed_1_path1_T_H_OP100B	5000	4500	{}	decreasing	A1-P1	Z	2	12	25
2311	InFan2SrvComPwSpeed_2_path1_T_H_OP100B	5000	4500	{}	decreasing	A2-P1	Y	2	12	25
2312	InFan2SrvComPwSpeed_3_path1_T_H_OP100B	5000	4500	{}	decreasing	A3-P1	YS	2	12	25
2313	InFan2SrvComPwSpeed_4_path1_T_H_OP100B	5000	4500	{}	decreasing	A4-P1	B1	2	12	25
2314	InFan2SrvComPwSpeed_5_path1_T_H_OP100B	5000	4500	{}	decreasing	A5-P1	BMG	2	12	25
2315	InFan2SrvComPwSpeed_6_path1_T_H_OP100B	5000	4500	{}	decreasing	A6-P1	A2	2	12	25
2316	InFan2SrvComPwSpeed_7_path1_T_H_OP100B	5000	4500	{}	decreasing	A7-P1	AT	2	12	25
2317	InFan1SpdlComPwSpeed_0_path1_T_H_OP100B	5000	4500	{}	decreasing	A0-P1	SAS	2	7	25
2318	InFan1SpindleAmpSpeed_0_path1_T_H_OP100B	6200	6000	{}	decreasing	A0-P1	SCS	2	7	25
2319	ServoTemp_0_path1_T_H_OP100B	55	70	{}	increasing	A0-P1	X	13	3	25
2320	ServoTemp_1_path1_T_H_OP100B	55	70	{}	increasing	A1-P1	Z	13	3	25
2321	ServoTemp_2_path1_T_H_OP100B	55	70	{}	increasing	A2-P1	Y	13	3	25
2322	ServoTemp_3_path1_T_H_OP100B	55	70	{}	increasing	A3-P1	YS	13	3	25
2323	ServoTemp_4_path1_T_H_OP100B	55	70	{}	increasing	A4-P1	B1	13	3	25
2324	ServoTemp_5_path1_T_H_OP100B	55	70	{}	increasing	A5-P1	BMG	13	3	25
2325	ServoTemp_6_path1_T_H_OP100B	55	70	{}	increasing	A6-P1	A2	13	3	25
2326	ServoTemp_7_path1_T_H_OP100B	55	70	{}	increasing	A7-P1	AT	13	3	25
2327	SpindleTemp_0_path1_T_H_OP100B	80	100	{}	increasing	SP-P1	SP	13	3	25
2328	PulseCoderTemp_0_path1_T_H_OP110A	60	80	{}	increasing	A0-P1	X	13	4	26
2329	PulseCoderTemp_1_path1_T_H_OP110A	60	80	{}	increasing	A1-P1	Z	13	4	26
2330	PulseCoderTemp_2_path1_T_H_OP110A	60	80	{}	increasing	A2-P1	Y	13	4	26
2331	PulseCoderTemp_3_path1_T_H_OP110A	60	80	{}	increasing	A3-P1	YS	13	4	26
2332	PulseCoderTemp_4_path1_T_H_OP110A	60	80	{}	increasing	A4-P1	B1	13	4	26
2333	PulseCoderTemp_5_path1_T_H_OP110A	60	80	{}	increasing	A5-P1	BMG	13	4	26
2334	PulseCoderTemp_6_path1_T_H_OP110A	60	80	{}	increasing	A6-P1	A2	13	4	26
2335	PulseCoderTemp_7_path1_T_H_OP110A	60	80	{}	increasing	A7-P1	AT	13	4	26
2336	CncFan1Speed_path1_T_H_OP110A	4500	4000	{}	decreasing	A1-P1	F1	16	6	26
2337	CncFan2Speed_path1_T_H_OP110A	9600	8600	{}	decreasing	A2-P1	F3	16	6	26
2340	InFan1SrvAmpSpeed_0_path1_T_H_OP110A	9500	9000	{}	decreasing	A0-P1	X	2	8	26
2341	InFan1SrvAmpSpeed_1_path1_T_H_OP110A	9500	9000	{}	decreasing	A1-P1	Z	2	8	26
2342	InFan1SrvAmpSpeed_2_path1_T_H_OP110A	9500	9000	{}	decreasing	A2-P1	Y	2	8	26
2343	InFan1SrvAmpSpeed_3_path1_T_H_OP110A	9500	9000	{}	decreasing	A3-P1	YS	2	8	26
2344	InFan1SrvAmpSpeed_4_path1_T_H_OP110A	8500	7500	{}	decreasing	A4-P1	B1	2	8	26
2345	InFan1SrvAmpSpeed_5_path1_T_H_OP110A	8500	7500	{}	decreasing	A5-P1	BMG	2	8	26
2346	InFan1SrvAmpSpeed_6_path1_T_H_OP110A	9500	9000	{}	decreasing	A6-P1	A2	2	8	26
2347	InFan1SrvAmpSpeed_7_path1_T_H_OP110A	8500	7500	{}	decreasing	A7-P1	AT	2	8	26
2348	ServoLoad_0_path1_T_H_OP110A	NaN	NaN	{}	increasing	A0-P1	X	17	17	26
2349	ServoLoad_1_path1_T_H_OP110A	NaN	NaN	{}	increasing	A1-P1	Z	17	17	26
2350	ServoLoad_2_path1_T_H_OP110A	NaN	NaN	{}	increasing	A2-P1	Y	17	17	26
2351	ServoLoad_3_path1_T_H_OP110A	NaN	NaN	{}	increasing	A3-P1	YS	17	17	26
2352	ServoLoad_4_path1_T_H_OP110A	NaN	NaN	{}	increasing	A4-P1	B1	17	17	26
2353	ServoLoad_5_path1_T_H_OP110A	NaN	NaN	{}	increasing	A5-P1	BMG	17	17	26
2354	ServoLoad_6_path1_T_H_OP110A	NaN	NaN	{}	increasing	A6-P1	A2	17	17	26
2355	ServoLoad_7_path1_T_H_OP110A	NaN	NaN	{}	increasing	A7-P1	AT	17	17	26
2356	SpindleLoad_0_path1_T_H_OP110A	NaN	NaN	{}	increasing	SP-P1	SP	17	17	26
2357	SpdBatZero_0_path1_T_H_OP110A	NaN	NaN	{}	bool	A0-P1	X	6	13	26
2358	SpdBatZero_1_path1_T_H_OP110A	NaN	NaN	{}	bool	A1-P1	Z	6	13	26
2359	SpdBatZero_2_path1_T_H_OP110A	NaN	NaN	{}	bool	A2-P1	Y	6	13	26
2360	SpdBatZero_3_path1_T_H_OP110A	NaN	NaN	{}	bool	A3-P1	YS	6	13	26
2361	SpdBatZero_4_path1_T_H_OP110A	NaN	NaN	{}	bool	A4-P1	B1	6	13	26
2362	SpdBatZero_5_path1_T_H_OP110A	NaN	NaN	{}	bool	A5-P1	BMG	6	13	26
2363	SpdBatZero_6_path1_T_H_OP110A	NaN	NaN	{}	bool	A6-P1	A2	6	13	26
2364	SpdBatZero_7_path1_T_H_OP110A	NaN	NaN	{}	bool	A7-P1	AT	6	13	26
2365	SSpdBatZero_0_path1_T_H_OP110A	NaN	NaN	{}	bool	A0-P1	X	6	14	26
2366	SSpdBatZero_1_path1_T_H_OP110A	NaN	NaN	{}	bool	A1-P1	Z	6	14	26
2367	SSpdBatZero_2_path1_T_H_OP110A	NaN	NaN	{}	bool	A2-P1	Y	6	14	26
2368	SSpdBatZero_3_path1_T_H_OP110A	NaN	NaN	{}	bool	A3-P1	YS	6	14	26
2369	SSpdBatZero_4_path1_T_H_OP110A	NaN	NaN	{}	bool	A4-P1	B1	6	14	26
2370	SSpdBatZero_5_path1_T_H_OP110A	NaN	NaN	{}	bool	A5-P1	BMG	6	14	26
2371	SSpdBatZero_6_path1_T_H_OP110A	NaN	NaN	{}	bool	A6-P1	A2	6	14	26
2372	SSpdBatZero_7_path1_T_H_OP110A	NaN	NaN	{}	bool	A7-P1	AT	6	14	26
2373	RadFan2SpindleAmpSpeed_0_path1_T_H_OP110A	5000	4500	{}	decreasing	SP-P1	SP	2	16	26
2374	RadFan2SrvAmpSpeed_0_path1_T_H_OP110A	5000	4500	{}	decreasing	A0-P1	X	2	16	26
2375	RadFan2SrvAmpSpeed_1_path1_T_H_OP110A	5000	4500	{}	decreasing	A1-P1	Z	2	16	26
2376	RadFan2SrvAmpSpeed_2_path1_T_H_OP110A	5000	4500	{}	decreasing	A2-P1	Y	2	16	26
2377	RadFan2SrvAmpSpeed_3_path1_T_H_OP110A	5000	4500	{}	decreasing	A3-P1	YS	2	16	26
2378	RadFan2SrvAmpSpeed_4_path1_T_H_OP110A	5000	4500	{}	decreasing	A4-P1	B1	2	16	26
2379	RadFan2SrvAmpSpeed_5_path1_T_H_OP110A	5000	4500	{}	decreasing	A5-P1	BMG	2	16	26
2380	RadFan2SrvAmpSpeed_6_path1_T_H_OP110A	5000	4500	{}	decreasing	A6-P1	A2	2	16	26
2381	RadFan2SrvAmpSpeed_7_path1_T_H_OP110A	5000	4500	{}	decreasing	A7-P1	AT	2	16	26
2382	ApcBatLow_0_path1_T_H_OP110A	NaN	NaN	{}	bool	A0-P1	X	6	1	26
2383	ApcBatLow_1_path1_T_H_OP110A	NaN	NaN	{}	bool	A1-P1	Z	6	1	26
2384	ApcBatLow_2_path1_T_H_OP110A	NaN	NaN	{}	bool	A2-P1	Y	6	1	26
2385	ApcBatLow_3_path1_T_H_OP110A	NaN	NaN	{}	bool	A3-P1	YS	6	1	26
2386	ApcBatLow_4_path1_T_H_OP110A	NaN	NaN	{}	bool	A4-P1	B1	6	1	26
2387	ApcBatLow_5_path1_T_H_OP110A	NaN	NaN	{}	bool	A5-P1	BMG	6	1	26
2388	ApcBatLow_6_path1_T_H_OP110A	NaN	NaN	{}	bool	A6-P1	A2	6	1	26
2389	ApcBatLow_7_path1_T_H_OP110A	NaN	NaN	{}	bool	A7-P1	AT	6	1	26
2390	CncBatLow_0_path1_T_H_OP110A	NaN	NaN	{}	bool	A0-P1	X	6	2	26
2391	CncBatLow_1_path1_T_H_OP110A	NaN	NaN	{}	bool	A1-P1	Z	6	2	26
2392	CncBatLow_2_path1_T_H_OP110A	NaN	NaN	{}	bool	A2-P1	Y	6	2	26
2393	CncBatLow_3_path1_T_H_OP110A	NaN	NaN	{}	bool	A3-P1	YS	6	2	26
2394	CncBatLow_4_path1_T_H_OP110A	NaN	NaN	{}	bool	A4-P1	B1	6	2	26
2395	CncBatLow_5_path1_T_H_OP110A	NaN	NaN	{}	bool	A5-P1	BMG	6	2	26
2396	CncBatLow_6_path1_T_H_OP110A	NaN	NaN	{}	bool	A6-P1	A2	6	2	26
2397	CncBatLow_7_path1_T_H_OP110A	NaN	NaN	{}	bool	A7-P1	AT	6	2	26
2398	ServoLeakResistData_0_path1_T_H_OP110A	50	30	{}	decreasing	A0-P1	X	15	5	26
2399	ServoLeakResistData_1_path1_T_H_OP110A	50	30	{}	decreasing	A1-P1	Z	15	5	26
2400	ServoLeakResistData_2_path1_T_H_OP110A	50	30	{}	decreasing	A2-P1	Y	15	5	26
2401	ServoLeakResistData_3_path1_T_H_OP110A	50	30	{}	decreasing	A3-P1	YS	15	5	26
2402	ServoLeakResistData_4_path1_T_H_OP110A	50	30	{}	decreasing	A4-P1	B1	15	5	26
2403	ServoLeakResistData_5_path1_T_H_OP110A	50	30	{}	decreasing	A5-P1	BMG	15	5	26
2404	ServoLeakResistData_6_path1_T_H_OP110A	50	30	{}	decreasing	A6-P1	A2	15	5	26
2405	ServoLeakResistData_7_path1_T_H_OP110A	50	30	{}	decreasing	A7-P1	AT	15	5	26
2406	SpindleLeakResistData_0_path1_T_H_OP110A	50	30	{}	decreasing	SP-P1	SP	15	5	26
2407	InFan1SrvComPwSpeed_0_path1_T_H_OP110A	6200	6000	{}	decreasing	A0-P1	X	2	9	26
2408	InFan1SrvComPwSpeed_1_path1_T_H_OP110A	6200	6000	{}	decreasing	A1-P1	Z	2	9	26
2409	InFan1SrvComPwSpeed_2_path1_T_H_OP110A	6200	6000	{}	decreasing	A2-P1	Y	2	9	26
2410	InFan1SrvComPwSpeed_3_path1_T_H_OP110A	6200	6000	{}	decreasing	A3-P1	YS	2	9	26
2411	InFan1SrvComPwSpeed_4_path1_T_H_OP110A	6200	6000	{}	decreasing	A4-P1	B1	2	9	26
2412	InFan1SrvComPwSpeed_5_path1_T_H_OP110A	6200	6000	{}	decreasing	A5-P1	BMG	2	9	26
2413	InFan1SrvComPwSpeed_6_path1_T_H_OP110A	6200	6000	{}	decreasing	A6-P1	A2	2	9	26
2414	InFan1SrvComPwSpeed_7_path1_T_H_OP110A	6200	6000	{}	decreasing	A7-P1	AT	2	9	26
2415	InFan2SrvAmpSpeed_0_path1_T_H_OP110A	5000	4500	{}	decreasing	A0-P1	X	2	11	26
2416	InFan2SrvAmpSpeed_1_path1_T_H_OP110A	5000	4500	{}	decreasing	A1-P1	Z	2	11	26
2417	InFan2SrvAmpSpeed_2_path1_T_H_OP110A	5000	4500	{}	decreasing	A2-P1	Y	2	11	26
2418	InFan2SrvAmpSpeed_3_path1_T_H_OP110A	5000	4500	{}	decreasing	A3-P1	YS	2	11	26
2419	InFan2SrvAmpSpeed_4_path1_T_H_OP110A	5000	4500	{}	decreasing	A4-P1	B1	2	11	26
2420	InFan2SrvAmpSpeed_5_path1_T_H_OP110A	5000	4500	{}	decreasing	A5-P1	BMG	2	11	26
2421	InFan2SrvAmpSpeed_6_path1_T_H_OP110A	5000	4500	{}	decreasing	A6-P1	A2	2	11	26
2422	InFan2SrvAmpSpeed_7_path1_T_H_OP110A	5000	4500	{}	decreasing	A7-P1	AT	2	11	26
2423	RadFan1SpindleAmpSpeed_0_path1_T_H_OP110A	5000	4500	{}	decreasing	SP-P1	SP	2	15	26
2424	RadFan1SrvAmpSpeed_0_path1_T_H_OP110A	5000	4500	{}	decreasing	A0-P1	X	2	15	26
2425	RadFan1SrvAmpSpeed_1_path1_T_H_OP110A	5000	4500	{}	decreasing	A1-P1	Z	2	15	26
2426	RadFan1SrvAmpSpeed_2_path1_T_H_OP110A	5000	4500	{}	decreasing	A2-P1	Y	2	15	26
2427	RadFan1SrvAmpSpeed_3_path1_T_H_OP110A	5000	4500	{}	decreasing	A3-P1	YS	2	15	26
2428	RadFan1SrvAmpSpeed_4_path1_T_H_OP110A	5000	4500	{}	decreasing	A4-P1	B1	2	15	26
2429	RadFan1SrvAmpSpeed_5_path1_T_H_OP110A	5000	4500	{}	decreasing	A5-P1	BMG	2	15	26
2430	RadFan1SrvAmpSpeed_6_path1_T_H_OP110A	5000	4500	{}	decreasing	A6-P1	A2	2	15	26
2431	RadFan1SrvAmpSpeed_7_path1_T_H_OP110A	5000	4500	{}	decreasing	A7-P1	AT	2	15	26
2432	InFan2SpdlComPwSpeed_0_path1_T_H_OP110A	5000	4500	{}	decreasing	A0-P1	SAS	2	10	26
2433	InFan2SpindleAmpSpeed_0_path1_T_H_OP110A	5000	4500	{}	decreasing	A0-P1	SCS	2	10	26
2434	InFan2SrvComPwSpeed_0_path1_T_H_OP110A	5000	4500	{}	decreasing	A0-P1	X	2	12	26
2435	InFan2SrvComPwSpeed_1_path1_T_H_OP110A	5000	4500	{}	decreasing	A1-P1	Z	2	12	26
2436	InFan2SrvComPwSpeed_2_path1_T_H_OP110A	5000	4500	{}	decreasing	A2-P1	Y	2	12	26
2437	InFan2SrvComPwSpeed_3_path1_T_H_OP110A	5000	4500	{}	decreasing	A3-P1	YS	2	12	26
2438	InFan2SrvComPwSpeed_4_path1_T_H_OP110A	5000	4500	{}	decreasing	A4-P1	B1	2	12	26
2439	InFan2SrvComPwSpeed_5_path1_T_H_OP110A	5000	4500	{}	decreasing	A5-P1	BMG	2	12	26
2440	InFan2SrvComPwSpeed_6_path1_T_H_OP110A	5000	4500	{}	decreasing	A6-P1	A2	2	12	26
2441	InFan2SrvComPwSpeed_7_path1_T_H_OP110A	5000	4500	{}	decreasing	A7-P1	AT	2	12	26
2442	InFan1SpdlComPwSpeed_0_path1_T_H_OP110A	5000	4500	{}	decreasing	A0-P1	SAS	2	7	26
2443	InFan1SpindleAmpSpeed_0_path1_T_H_OP110A	6200	6000	{}	decreasing	A0-P1	SCS	2	7	26
2444	ServoTemp_0_path1_T_H_OP110A	55	70	{}	increasing	A0-P1	X	13	3	26
2445	ServoTemp_1_path1_T_H_OP110A	55	70	{}	increasing	A1-P1	Z	13	3	26
2446	ServoTemp_2_path1_T_H_OP110A	55	70	{}	increasing	A2-P1	Y	13	3	26
2447	ServoTemp_3_path1_T_H_OP110A	55	70	{}	increasing	A3-P1	YS	13	3	26
2448	ServoTemp_4_path1_T_H_OP110A	55	70	{}	increasing	A4-P1	B1	13	3	26
2449	ServoTemp_5_path1_T_H_OP110A	55	70	{}	increasing	A5-P1	BMG	13	3	26
2450	ServoTemp_6_path1_T_H_OP110A	55	70	{}	increasing	A6-P1	A2	13	3	26
2451	ServoTemp_7_path1_T_H_OP110A	55	70	{}	increasing	A7-P1	AT	13	3	26
2452	SpindleTemp_0_path1_T_H_OP110A	80	100	{}	increasing	SP-P1	SP	13	3	26
2453	PulseCoderTemp_0_path1_T_H_OP110B	60	80	{}	increasing	A0-P1	X	13	4	27
2454	PulseCoderTemp_1_path1_T_H_OP110B	60	80	{}	increasing	A1-P1	Z	13	4	27
2455	PulseCoderTemp_2_path1_T_H_OP110B	60	80	{}	increasing	A2-P1	Y	13	4	27
2456	PulseCoderTemp_3_path1_T_H_OP110B	70	80	{}	increasing	A3-P1	Y2	13	4	27
2457	PulseCoderTemp_4_path1_T_H_OP110B	60	80	{}	increasing	A4-P1	B1	13	4	27
2458	PulseCoderTemp_5_path1_T_H_OP110B	60	80	{}	increasing	A5-P1	BMG	13	4	27
2459	PulseCoderTemp_6_path1_T_H_OP110B	60	80	{}	increasing	A6-P1	A2	13	4	27
2460	PulseCoderTemp_7_path1_T_H_OP110B	60	80	{}	increasing	A7-P1	AT	13	4	27
2461	CncFan1Speed_path1_T_H_OP110B	4500	4000	{}	decreasing	A1-P1	F1	16	6	27
2462	CncFan2Speed_path1_T_H_OP110B	9600	8600	{}	decreasing	A2-P1	F3	16	6	27
2465	InFan1SrvAmpSpeed_0_path1_T_H_OP110B	9500	9000	{}	decreasing	A0-P1	X	2	8	27
2466	InFan1SrvAmpSpeed_1_path1_T_H_OP110B	9500	9000	{}	decreasing	A1-P1	Z	2	8	27
2467	InFan1SrvAmpSpeed_2_path1_T_H_OP110B	9500	9000	{}	decreasing	A2-P1	Y	2	8	27
2468	InFan1SrvAmpSpeed_3_path1_T_H_OP110B	9500	9000	{}	decreasing	A3-P1	Y2	2	8	27
2469	InFan1SrvAmpSpeed_4_path1_T_H_OP110B	8500	7500	{}	decreasing	A4-P1	B1	2	8	27
2470	InFan1SrvAmpSpeed_5_path1_T_H_OP110B	8500	7500	{}	decreasing	A5-P1	BMG	2	8	27
2471	InFan1SrvAmpSpeed_6_path1_T_H_OP110B	9500	9000	{}	decreasing	A6-P1	A2	2	8	27
2472	InFan1SrvAmpSpeed_7_path1_T_H_OP110B	8500	7500	{}	decreasing	A7-P1	AT	2	8	27
2473	ServoLoad_0_path1_T_H_OP110B	NaN	NaN	{}	increasing	A0-P1	X	17	17	27
2474	ServoLoad_1_path1_T_H_OP110B	NaN	NaN	{}	increasing	A1-P1	Z	17	17	27
2475	ServoLoad_2_path1_T_H_OP110B	NaN	NaN	{}	increasing	A2-P1	Y	17	17	27
2476	ServoLoad_3_path1_T_H_OP110B	NaN	NaN	{}	increasing	A3-P1	Y2	17	17	27
2477	ServoLoad_4_path1_T_H_OP110B	NaN	NaN	{}	increasing	A4-P1	B1	17	17	27
2478	ServoLoad_5_path1_T_H_OP110B	NaN	NaN	{}	increasing	A5-P1	BMG	17	17	27
2479	ServoLoad_6_path1_T_H_OP110B	NaN	NaN	{}	increasing	A6-P1	A2	17	17	27
2480	ServoLoad_7_path1_T_H_OP110B	NaN	NaN	{}	increasing	A7-P1	AT	17	17	27
2481	SpindleLoad_0_path1_T_H_OP110B	NaN	NaN	{}	increasing	SP-P1	SP	17	17	27
2482	SpdBatZero_0_path1_T_H_OP110B	NaN	NaN	{}	bool	A0-P1	X	6	13	27
2483	SpdBatZero_1_path1_T_H_OP110B	NaN	NaN	{}	bool	A1-P1	Z	6	13	27
2484	SpdBatZero_2_path1_T_H_OP110B	NaN	NaN	{}	bool	A2-P1	Y	6	13	27
2485	SpdBatZero_3_path1_T_H_OP110B	NaN	NaN	{}	bool	A3-P1	Y2	6	13	27
2486	SpdBatZero_4_path1_T_H_OP110B	NaN	NaN	{}	bool	A4-P1	B1	6	13	27
2487	SpdBatZero_5_path1_T_H_OP110B	NaN	NaN	{}	bool	A5-P1	BMG	6	13	27
2488	SpdBatZero_6_path1_T_H_OP110B	NaN	NaN	{}	bool	A6-P1	A2	6	13	27
2489	SpdBatZero_7_path1_T_H_OP110B	NaN	NaN	{}	bool	A7-P1	AT	6	13	27
2490	SSpdBatZero_0_path1_T_H_OP110B	NaN	NaN	{}	bool	A0-P1	X	6	14	27
2491	SSpdBatZero_1_path1_T_H_OP110B	NaN	NaN	{}	bool	A1-P1	Z	6	14	27
2492	SSpdBatZero_2_path1_T_H_OP110B	NaN	NaN	{}	bool	A2-P1	Y	6	14	27
2493	SSpdBatZero_3_path1_T_H_OP110B	NaN	NaN	{}	bool	A3-P1	Y2	6	14	27
2494	SSpdBatZero_4_path1_T_H_OP110B	NaN	NaN	{}	bool	A4-P1	B1	6	14	27
2495	SSpdBatZero_5_path1_T_H_OP110B	NaN	NaN	{}	bool	A5-P1	BMG	6	14	27
2496	SSpdBatZero_6_path1_T_H_OP110B	NaN	NaN	{}	bool	A6-P1	A2	6	14	27
2497	SSpdBatZero_7_path1_T_H_OP110B	NaN	NaN	{}	bool	A7-P1	AT	6	14	27
2498	RadFan2SpindleAmpSpeed_0_path1_T_H_OP110B	5000	4500	{}	decreasing	SP-P1	SP	2	16	27
2499	RadFan2SrvAmpSpeed_0_path1_T_H_OP110B	5000	4500	{}	decreasing	A0-P1	X	2	16	27
2500	RadFan2SrvAmpSpeed_1_path1_T_H_OP110B	5000	4500	{}	decreasing	A1-P1	Z	2	16	27
2501	RadFan2SrvAmpSpeed_2_path1_T_H_OP110B	5000	4500	{}	decreasing	A2-P1	Y	2	16	27
2502	RadFan2SrvAmpSpeed_3_path1_T_H_OP110B	5000	4500	{}	decreasing	A3-P1	Y2	2	16	27
2503	RadFan2SrvAmpSpeed_4_path1_T_H_OP110B	5000	4500	{}	decreasing	A4-P1	B1	2	16	27
2504	RadFan2SrvAmpSpeed_5_path1_T_H_OP110B	5000	4500	{}	decreasing	A5-P1	BMG	2	16	27
2505	RadFan2SrvAmpSpeed_6_path1_T_H_OP110B	5000	4500	{}	decreasing	A6-P1	A2	2	16	27
2506	RadFan2SrvAmpSpeed_7_path1_T_H_OP110B	5000	4500	{}	decreasing	A7-P1	AT	2	16	27
2507	ApcBatLow_0_path1_T_H_OP110B	NaN	NaN	{}	bool	A0-P1	X	6	1	27
2508	ApcBatLow_1_path1_T_H_OP110B	NaN	NaN	{}	bool	A1-P1	Z	6	1	27
2509	ApcBatLow_2_path1_T_H_OP110B	NaN	NaN	{}	bool	A2-P1	Y	6	1	27
2510	ApcBatLow_3_path1_T_H_OP110B	NaN	NaN	{}	bool	A3-P1	Y2	6	1	27
2511	ApcBatLow_4_path1_T_H_OP110B	NaN	NaN	{}	bool	A4-P1	B1	6	1	27
2512	ApcBatLow_5_path1_T_H_OP110B	NaN	NaN	{}	bool	A5-P1	BMG	6	1	27
2513	ApcBatLow_6_path1_T_H_OP110B	NaN	NaN	{}	bool	A6-P1	A2	6	1	27
2514	ApcBatLow_7_path1_T_H_OP110B	NaN	NaN	{}	bool	A7-P1	AT	6	1	27
2515	CncBatLow_0_path1_T_H_OP110B	NaN	NaN	{}	bool	A0-P1	X	6	2	27
2516	CncBatLow_1_path1_T_H_OP110B	NaN	NaN	{}	bool	A1-P1	Z	6	2	27
2517	CncBatLow_2_path1_T_H_OP110B	NaN	NaN	{}	bool	A2-P1	Y	6	2	27
2518	CncBatLow_3_path1_T_H_OP110B	NaN	NaN	{}	bool	A3-P1	Y2	6	2	27
2519	CncBatLow_4_path1_T_H_OP110B	NaN	NaN	{}	bool	A4-P1	B1	6	2	27
2520	CncBatLow_5_path1_T_H_OP110B	NaN	NaN	{}	bool	A5-P1	BMG	6	2	27
2521	CncBatLow_6_path1_T_H_OP110B	NaN	NaN	{}	bool	A6-P1	A2	6	2	27
2522	CncBatLow_7_path1_T_H_OP110B	NaN	NaN	{}	bool	A7-P1	AT	6	2	27
2523	ServoLeakResistData_0_path1_T_H_OP110B	50	30	{}	decreasing	A0-P1	X	15	5	27
2524	ServoLeakResistData_1_path1_T_H_OP110B	50	30	{}	decreasing	A1-P1	Z	15	5	27
2525	ServoLeakResistData_2_path1_T_H_OP110B	50	30	{}	decreasing	A2-P1	Y	15	5	27
2526	ServoLeakResistData_3_path1_T_H_OP110B	50	30	{}	decreasing	A3-P1	Y2	15	5	27
2527	ServoLeakResistData_4_path1_T_H_OP110B	50	30	{}	decreasing	A4-P1	B1	15	5	27
2528	ServoLeakResistData_5_path1_T_H_OP110B	50	30	{}	decreasing	A5-P1	BMG	15	5	27
2529	ServoLeakResistData_6_path1_T_H_OP110B	50	30	{}	decreasing	A6-P1	A2	15	5	27
2530	ServoLeakResistData_7_path1_T_H_OP110B	50	30	{}	decreasing	A7-P1	AT	15	5	27
2531	SpindleLeakResistData_0_path1_T_H_OP110B	50	30	{}	decreasing	SP-P1	SP	15	5	27
2532	InFan1SrvComPwSpeed_0_path1_T_H_OP110B	6200	6000	{}	decreasing	A0-P1	X	2	9	27
2533	InFan1SrvComPwSpeed_1_path1_T_H_OP110B	6200	6000	{}	decreasing	A1-P1	Z	2	9	27
2534	InFan1SrvComPwSpeed_2_path1_T_H_OP110B	6200	6000	{}	decreasing	A2-P1	Y	2	9	27
2535	InFan1SrvComPwSpeed_3_path1_T_H_OP110B	6200	6000	{}	decreasing	A3-P1	Y2	2	9	27
2536	InFan1SrvComPwSpeed_4_path1_T_H_OP110B	6200	6000	{}	decreasing	A4-P1	B1	2	9	27
2537	InFan1SrvComPwSpeed_5_path1_T_H_OP110B	6200	6000	{}	decreasing	A5-P1	BMG	2	9	27
2538	InFan1SrvComPwSpeed_6_path1_T_H_OP110B	6200	6000	{}	decreasing	A6-P1	A2	2	9	27
2539	InFan1SrvComPwSpeed_7_path1_T_H_OP110B	6200	6000	{}	decreasing	A7-P1	AT	2	9	27
2540	InFan2SrvAmpSpeed_0_path1_T_H_OP110B	5000	4500	{}	decreasing	A0-P1	X	2	11	27
2541	InFan2SrvAmpSpeed_1_path1_T_H_OP110B	5000	4500	{}	decreasing	A1-P1	Z	2	11	27
2542	InFan2SrvAmpSpeed_2_path1_T_H_OP110B	5000	4500	{}	decreasing	A2-P1	Y	2	11	27
2543	InFan2SrvAmpSpeed_3_path1_T_H_OP110B	5000	4500	{}	decreasing	A3-P1	Y2	2	11	27
2544	InFan2SrvAmpSpeed_4_path1_T_H_OP110B	5000	4500	{}	decreasing	A4-P1	B1	2	11	27
2545	InFan2SrvAmpSpeed_5_path1_T_H_OP110B	5000	4500	{}	decreasing	A5-P1	BMG	2	11	27
2546	InFan2SrvAmpSpeed_6_path1_T_H_OP110B	5000	4500	{}	decreasing	A6-P1	A2	2	11	27
2547	InFan2SrvAmpSpeed_7_path1_T_H_OP110B	5000	4500	{}	decreasing	A7-P1	AT	2	11	27
2548	RadFan1SpindleAmpSpeed_0_path1_T_H_OP110B	5000	4500	{}	decreasing	SP-P1	SP	2	15	27
2549	RadFan1SrvAmpSpeed_0_path1_T_H_OP110B	5000	4500	{}	decreasing	A0-P1	X	2	15	27
2550	RadFan1SrvAmpSpeed_1_path1_T_H_OP110B	5000	4500	{}	decreasing	A1-P1	Z	2	15	27
2551	RadFan1SrvAmpSpeed_2_path1_T_H_OP110B	5000	4500	{}	decreasing	A2-P1	Y	2	15	27
2552	RadFan1SrvAmpSpeed_3_path1_T_H_OP110B	5000	4500	{}	decreasing	A3-P1	Y2	2	15	27
2553	RadFan1SrvAmpSpeed_4_path1_T_H_OP110B	5000	4500	{}	decreasing	A4-P1	B1	2	15	27
2554	RadFan1SrvAmpSpeed_5_path1_T_H_OP110B	5000	4500	{}	decreasing	A5-P1	BMG	2	15	27
2555	RadFan1SrvAmpSpeed_6_path1_T_H_OP110B	5000	4500	{}	decreasing	A6-P1	A2	2	15	27
2556	RadFan1SrvAmpSpeed_7_path1_T_H_OP110B	5000	4500	{}	decreasing	A7-P1	AT	2	15	27
2557	InFan2SpdlComPwSpeed_0_path1_T_H_OP110B	5000	4500	{}	decreasing	A0-P1	SAS	2	10	27
2558	InFan2SpindleAmpSpeed_0_path1_T_H_OP110B	5000	4500	{}	decreasing	A0-P1	SCS	2	10	27
2559	InFan2SrvComPwSpeed_0_path1_T_H_OP110B	5000	4500	{}	decreasing	A0-P1	X	2	12	27
2560	InFan2SrvComPwSpeed_1_path1_T_H_OP110B	5000	4500	{}	decreasing	A1-P1	Z	2	12	27
2561	InFan2SrvComPwSpeed_2_path1_T_H_OP110B	5000	4500	{}	decreasing	A2-P1	Y	2	12	27
2562	InFan2SrvComPwSpeed_3_path1_T_H_OP110B	5000	4500	{}	decreasing	A3-P1	Y2	2	12	27
2563	InFan2SrvComPwSpeed_4_path1_T_H_OP110B	5000	4500	{}	decreasing	A4-P1	B1	2	12	27
2564	InFan2SrvComPwSpeed_5_path1_T_H_OP110B	5000	4500	{}	decreasing	A5-P1	BMG	2	12	27
2565	InFan2SrvComPwSpeed_6_path1_T_H_OP110B	5000	4500	{}	decreasing	A6-P1	A2	2	12	27
2566	InFan2SrvComPwSpeed_7_path1_T_H_OP110B	5000	4500	{}	decreasing	A7-P1	AT	2	12	27
2567	InFan1SpdlComPwSpeed_0_path1_T_H_OP110B	5000	4500	{}	decreasing	A0-P1	SAS	2	7	27
2568	InFan1SpindleAmpSpeed_0_path1_T_H_OP110B	6200	6000	{}	decreasing	A0-P1	SCS	2	7	27
2569	ServoTemp_0_path1_T_H_OP110B	55	70	{}	increasing	A0-P1	X	13	3	27
2570	ServoTemp_1_path1_T_H_OP110B	55	70	{}	increasing	A1-P1	Z	13	3	27
2571	ServoTemp_2_path1_T_H_OP110B	55	70	{}	increasing	A2-P1	Y	13	3	27
2572	ServoTemp_3_path1_T_H_OP110B	55	70	{}	increasing	A3-P1	Y2	13	3	27
2573	ServoTemp_4_path1_T_H_OP110B	55	70	{}	increasing	A4-P1	B1	13	3	27
2574	ServoTemp_5_path1_T_H_OP110B	55	70	{}	increasing	A5-P1	BMG	13	3	27
2575	ServoTemp_6_path1_T_H_OP110B	55	70	{}	increasing	A6-P1	A2	13	3	27
2576	ServoTemp_7_path1_T_H_OP110B	55	70	{}	increasing	A7-P1	AT	13	3	27
2577	SpindleTemp_0_path1_T_H_OP110B	80	100	{}	increasing	SP-P1	SP	13	3	27
2578	PulseCoderTemp_0_path1_T_H_OP120A	60	80	{}	increasing	A0-P1	X	13	4	28
2579	PulseCoderTemp_1_path1_T_H_OP120A	60	80	{}	increasing	A1-P1	Z	13	4	28
2580	PulseCoderTemp_2_path1_T_H_OP120A	60	80	{}	increasing	A2-P1	Y	13	4	28
2581	PulseCoderTemp_3_path1_T_H_OP120A	60	80	{}	increasing	A3-P1	YS	13	4	28
2583	PulseCoderTemp_5_path1_T_H_OP120A	60	80	{}	increasing	A5-P1	BMG	13	4	28
2584	PulseCoderTemp_6_path1_T_H_OP120A	60	80	{}	increasing	A6-P1	A2	13	4	28
2585	PulseCoderTemp_7_path1_T_H_OP120A	60	80	{}	increasing	A7-P1	AT	13	4	28
2586	CncFan1Speed_path1_T_H_OP120A	4500	4000	{}	decreasing	A1-P1	F1	16	6	28
2587	CncFan2Speed_path1_T_H_OP120A	9600	8600	{}	decreasing	A2-P1	F3	16	6	28
2590	InFan1SrvAmpSpeed_0_path1_T_H_OP120A	9500	9000	{}	decreasing	A0-P1	X	2	8	28
2591	InFan1SrvAmpSpeed_1_path1_T_H_OP120A	9500	9000	{}	decreasing	A1-P1	Z	2	8	28
2592	InFan1SrvAmpSpeed_2_path1_T_H_OP120A	9500	9000	{}	decreasing	A2-P1	Y	2	8	28
2593	InFan1SrvAmpSpeed_3_path1_T_H_OP120A	9500	9000	{}	decreasing	A3-P1	YS	2	8	28
2595	InFan1SrvAmpSpeed_5_path1_T_H_OP120A	8500	7500	{}	decreasing	A5-P1	BMG	2	8	28
2596	InFan1SrvAmpSpeed_6_path1_T_H_OP120A	9500	9000	{}	decreasing	A6-P1	A2	2	8	28
2597	InFan1SrvAmpSpeed_7_path1_T_H_OP120A	8500	7500	{}	decreasing	A7-P1	AT	2	8	28
2598	ServoLoad_0_path1_T_H_OP120A	NaN	NaN	{}	increasing	A0-P1	X	17	17	28
2599	ServoLoad_1_path1_T_H_OP120A	NaN	NaN	{}	increasing	A1-P1	Z	17	17	28
2600	ServoLoad_2_path1_T_H_OP120A	NaN	NaN	{}	increasing	A2-P1	Y	17	17	28
2601	ServoLoad_3_path1_T_H_OP120A	NaN	NaN	{}	increasing	A3-P1	YS	17	17	28
2603	ServoLoad_5_path1_T_H_OP120A	NaN	NaN	{}	increasing	A5-P1	BMG	17	17	28
2604	ServoLoad_6_path1_T_H_OP120A	NaN	NaN	{}	increasing	A6-P1	A2	17	17	28
2605	ServoLoad_7_path1_T_H_OP120A	NaN	NaN	{}	increasing	A7-P1	AT	17	17	28
2606	SpindleLoad_0_path1_T_H_OP120A	NaN	NaN	{}	increasing	SP-P1	SP	17	17	28
2607	SpdBatZero_0_path1_T_H_OP120A	NaN	NaN	{}	bool	A0-P1	X	6	13	28
2608	SpdBatZero_1_path1_T_H_OP120A	NaN	NaN	{}	bool	A1-P1	Z	6	13	28
2609	SpdBatZero_2_path1_T_H_OP120A	NaN	NaN	{}	bool	A2-P1	Y	6	13	28
2610	SpdBatZero_3_path1_T_H_OP120A	NaN	NaN	{}	bool	A3-P1	YS	6	13	28
2612	SpdBatZero_5_path1_T_H_OP120A	NaN	NaN	{}	bool	A5-P1	BMG	6	13	28
2613	SpdBatZero_6_path1_T_H_OP120A	NaN	NaN	{}	bool	A6-P1	A2	6	13	28
2614	SpdBatZero_7_path1_T_H_OP120A	NaN	NaN	{}	bool	A7-P1	AT	6	13	28
2615	SSpdBatZero_0_path1_T_H_OP120A	NaN	NaN	{}	bool	A0-P1	X	6	14	28
2616	SSpdBatZero_1_path1_T_H_OP120A	NaN	NaN	{}	bool	A1-P1	Z	6	14	28
2617	SSpdBatZero_2_path1_T_H_OP120A	NaN	NaN	{}	bool	A2-P1	Y	6	14	28
2618	SSpdBatZero_3_path1_T_H_OP120A	NaN	NaN	{}	bool	A3-P1	YS	6	14	28
2620	SSpdBatZero_5_path1_T_H_OP120A	NaN	NaN	{}	bool	A5-P1	BMG	6	14	28
2621	SSpdBatZero_6_path1_T_H_OP120A	NaN	NaN	{}	bool	A6-P1	A2	6	14	28
2622	SSpdBatZero_7_path1_T_H_OP120A	NaN	NaN	{}	bool	A7-P1	AT	6	14	28
2623	RadFan2SpindleAmpSpeed_0_path1_T_H_OP120A	5000	4500	{}	decreasing	SP-P1	SP	2	16	28
2624	RadFan2SrvAmpSpeed_0_path1_T_H_OP120A	5000	4500	{}	decreasing	A0-P1	X	2	16	28
2625	RadFan2SrvAmpSpeed_1_path1_T_H_OP120A	5000	4500	{}	decreasing	A1-P1	Z	2	16	28
2626	RadFan2SrvAmpSpeed_2_path1_T_H_OP120A	5000	4500	{}	decreasing	A2-P1	Y	2	16	28
2627	RadFan2SrvAmpSpeed_3_path1_T_H_OP120A	5000	4500	{}	decreasing	A3-P1	YS	2	16	28
2629	RadFan2SrvAmpSpeed_5_path1_T_H_OP120A	5000	4500	{}	decreasing	A5-P1	BMG	2	16	28
2630	RadFan2SrvAmpSpeed_6_path1_T_H_OP120A	5000	4500	{}	decreasing	A6-P1	A2	2	16	28
2631	RadFan2SrvAmpSpeed_7_path1_T_H_OP120A	5000	4500	{}	decreasing	A7-P1	AT	2	16	28
2632	ApcBatLow_0_path1_T_H_OP120A	NaN	NaN	{}	bool	A0-P1	X	6	1	28
2633	ApcBatLow_1_path1_T_H_OP120A	NaN	NaN	{}	bool	A1-P1	Z	6	1	28
2634	ApcBatLow_2_path1_T_H_OP120A	NaN	NaN	{}	bool	A2-P1	Y	6	1	28
2635	ApcBatLow_3_path1_T_H_OP120A	NaN	NaN	{}	bool	A3-P1	YS	6	1	28
2637	ApcBatLow_5_path1_T_H_OP120A	NaN	NaN	{}	bool	A5-P1	BMG	6	1	28
2638	ApcBatLow_6_path1_T_H_OP120A	NaN	NaN	{}	bool	A6-P1	A2	6	1	28
2639	ApcBatLow_7_path1_T_H_OP120A	NaN	NaN	{}	bool	A7-P1	AT	6	1	28
2640	CncBatLow_0_path1_T_H_OP120A	NaN	NaN	{}	bool	A0-P1	X	6	2	28
2641	CncBatLow_1_path1_T_H_OP120A	NaN	NaN	{}	bool	A1-P1	Z	6	2	28
2642	CncBatLow_2_path1_T_H_OP120A	NaN	NaN	{}	bool	A2-P1	Y	6	2	28
2643	CncBatLow_3_path1_T_H_OP120A	NaN	NaN	{}	bool	A3-P1	YS	6	2	28
2645	CncBatLow_5_path1_T_H_OP120A	NaN	NaN	{}	bool	A5-P1	BMG	6	2	28
2646	CncBatLow_6_path1_T_H_OP120A	NaN	NaN	{}	bool	A6-P1	A2	6	2	28
2647	CncBatLow_7_path1_T_H_OP120A	NaN	NaN	{}	bool	A7-P1	AT	6	2	28
2648	ServoLeakResistData_0_path1_T_H_OP120A	50	30	{}	decreasing	A0-P1	X	15	5	28
2649	ServoLeakResistData_1_path1_T_H_OP120A	50	30	{}	decreasing	A1-P1	Z	15	5	28
2650	ServoLeakResistData_2_path1_T_H_OP120A	50	30	{}	decreasing	A2-P1	Y	15	5	28
2651	ServoLeakResistData_3_path1_T_H_OP120A	50	30	{}	decreasing	A3-P1	YS	15	5	28
2653	ServoLeakResistData_5_path1_T_H_OP120A	50	30	{}	decreasing	A5-P1	BMG	15	5	28
2654	ServoLeakResistData_6_path1_T_H_OP120A	50	30	{}	decreasing	A6-P1	A2	15	5	28
2655	ServoLeakResistData_7_path1_T_H_OP120A	50	30	{}	decreasing	A7-P1	AT	15	5	28
2656	SpindleLeakResistData_0_path1_T_H_OP120A	50	30	{}	decreasing	SP-P1	SP	15	5	28
2657	InFan1SrvComPwSpeed_0_path1_T_H_OP120A	6200	6000	{}	decreasing	A0-P1	X	2	9	28
2658	InFan1SrvComPwSpeed_1_path1_T_H_OP120A	6200	6000	{}	decreasing	A1-P1	Z	2	9	28
2659	InFan1SrvComPwSpeed_2_path1_T_H_OP120A	6200	6000	{}	decreasing	A2-P1	Y	2	9	28
2660	InFan1SrvComPwSpeed_3_path1_T_H_OP120A	6200	6000	{}	decreasing	A3-P1	YS	2	9	28
2662	InFan1SrvComPwSpeed_5_path1_T_H_OP120A	6200	6000	{}	decreasing	A5-P1	BMG	2	9	28
2663	InFan1SrvComPwSpeed_6_path1_T_H_OP120A	6200	6000	{}	decreasing	A6-P1	A2	2	9	28
2664	InFan1SrvComPwSpeed_7_path1_T_H_OP120A	6200	6000	{}	decreasing	A7-P1	AT	2	9	28
2665	InFan2SrvAmpSpeed_0_path1_T_H_OP120A	5000	4500	{}	decreasing	A0-P1	X	2	11	28
2666	InFan2SrvAmpSpeed_1_path1_T_H_OP120A	5000	4500	{}	decreasing	A1-P1	Z	2	11	28
2667	InFan2SrvAmpSpeed_2_path1_T_H_OP120A	5000	4500	{}	decreasing	A2-P1	Y	2	11	28
4320	ServoTemp_1_path1_T_H_OP230	55	70	{}	increasing	A1-P1	Z	13	3	41
2668	InFan2SrvAmpSpeed_3_path1_T_H_OP120A	5000	4500	{}	decreasing	A3-P1	YS	2	11	28
2670	InFan2SrvAmpSpeed_5_path1_T_H_OP120A	5000	4500	{}	decreasing	A5-P1	BMG	2	11	28
2671	InFan2SrvAmpSpeed_6_path1_T_H_OP120A	5000	4500	{}	decreasing	A6-P1	A2	2	11	28
2672	InFan2SrvAmpSpeed_7_path1_T_H_OP120A	5000	4500	{}	decreasing	A7-P1	AT	2	11	28
2673	RadFan1SpindleAmpSpeed_0_path1_T_H_OP120A	5000	4500	{}	decreasing	SP-P1	SP	2	15	28
2674	RadFan1SrvAmpSpeed_0_path1_T_H_OP120A	5000	4500	{}	decreasing	A0-P1	X	2	15	28
2675	RadFan1SrvAmpSpeed_1_path1_T_H_OP120A	5000	4500	{}	decreasing	A1-P1	Z	2	15	28
2676	RadFan1SrvAmpSpeed_2_path1_T_H_OP120A	5000	4500	{}	decreasing	A2-P1	Y	2	15	28
2677	RadFan1SrvAmpSpeed_3_path1_T_H_OP120A	5000	4500	{}	decreasing	A3-P1	YS	2	15	28
2679	RadFan1SrvAmpSpeed_5_path1_T_H_OP120A	5000	4500	{}	decreasing	A5-P1	BMG	2	15	28
2680	RadFan1SrvAmpSpeed_6_path1_T_H_OP120A	5000	4500	{}	decreasing	A6-P1	A2	2	15	28
2681	RadFan1SrvAmpSpeed_7_path1_T_H_OP120A	5000	4500	{}	decreasing	A7-P1	AT	2	15	28
2682	InFan2SpdlComPwSpeed_0_path1_T_H_OP120A	5000	4500	{}	decreasing	A0-P1	SAS	2	10	28
2683	InFan2SpindleAmpSpeed_0_path1_T_H_OP120A	5000	4500	{}	decreasing	A0-P1	SCS	2	10	28
2684	InFan2SrvComPwSpeed_0_path1_T_H_OP120A	5000	4500	{}	decreasing	A0-P1	X	2	12	28
2685	InFan2SrvComPwSpeed_1_path1_T_H_OP120A	5000	4500	{}	decreasing	A1-P1	Z	2	12	28
2686	InFan2SrvComPwSpeed_2_path1_T_H_OP120A	5000	4500	{}	decreasing	A2-P1	Y	2	12	28
2687	InFan2SrvComPwSpeed_3_path1_T_H_OP120A	5000	4500	{}	decreasing	A3-P1	YS	2	12	28
2689	InFan2SrvComPwSpeed_5_path1_T_H_OP120A	5000	4500	{}	decreasing	A5-P1	BMG	2	12	28
2690	InFan2SrvComPwSpeed_6_path1_T_H_OP120A	5000	4500	{}	decreasing	A6-P1	A2	2	12	28
2691	InFan2SrvComPwSpeed_7_path1_T_H_OP120A	5000	4500	{}	decreasing	A7-P1	AT	2	12	28
2692	InFan1SpdlComPwSpeed_0_path1_T_H_OP120A	5000	4500	{}	decreasing	A0-P1	SAS	2	7	28
2693	InFan1SpindleAmpSpeed_0_path1_T_H_OP120A	6200	6000	{}	decreasing	A0-P1	SCS	2	7	28
2694	ServoTemp_0_path1_T_H_OP120A	55	70	{}	increasing	A0-P1	X	13	3	28
2695	ServoTemp_1_path1_T_H_OP120A	55	70	{}	increasing	A1-P1	Z	13	3	28
2696	ServoTemp_2_path1_T_H_OP120A	55	70	{}	increasing	A2-P1	Y	13	3	28
2697	ServoTemp_3_path1_T_H_OP120A	55	70	{}	increasing	A3-P1	YS	13	3	28
2699	ServoTemp_5_path1_T_H_OP120A	55	70	{}	increasing	A5-P1	BMG	13	3	28
2700	ServoTemp_6_path1_T_H_OP120A	55	70	{}	increasing	A6-P1	A2	13	3	28
2701	ServoTemp_7_path1_T_H_OP120A	55	70	{}	increasing	A7-P1	AT	13	3	28
2702	SpindleTemp_0_path1_T_H_OP120A	80	100	{}	increasing	SP-P1	SP	13	3	28
2703	PulseCoderTemp_0_path1_T_H_OP120B	60	80	{}	increasing	A0-P1	X	13	4	29
2704	PulseCoderTemp_1_path1_T_H_OP120B	60	80	{}	increasing	A1-P1	Z	13	4	29
2705	PulseCoderTemp_2_path1_T_H_OP120B	60	80	{}	increasing	A2-P1	Y	13	4	29
2706	PulseCoderTemp_3_path1_T_H_OP120B	60	80	{}	increasing	A3-P1	YS	13	4	29
2708	PulseCoderTemp_5_path1_T_H_OP120B	60	80	{}	increasing	A5-P1	BMG	13	4	29
2709	PulseCoderTemp_6_path1_T_H_OP120B	60	80	{}	increasing	A6-P1	A2	13	4	29
2710	PulseCoderTemp_7_path1_T_H_OP120B	60	80	{}	increasing	A7-P1	AT	13	4	29
2711	CncFan1Speed_path1_T_H_OP120B	4500	4000	{}	decreasing	A1-P1	F1	16	6	29
2712	CncFan2Speed_path1_T_H_OP120B	9600	8600	{}	decreasing	A2-P1	F3	16	6	29
2715	InFan1SrvAmpSpeed_0_path1_T_H_OP120B	9500	9000	{}	decreasing	A0-P1	X	2	8	29
2716	InFan1SrvAmpSpeed_1_path1_T_H_OP120B	9500	9000	{}	decreasing	A1-P1	Z	2	8	29
2717	InFan1SrvAmpSpeed_2_path1_T_H_OP120B	9500	9000	{}	decreasing	A2-P1	Y	2	8	29
2718	InFan1SrvAmpSpeed_3_path1_T_H_OP120B	9500	9000	{}	decreasing	A3-P1	YS	2	8	29
2720	InFan1SrvAmpSpeed_5_path1_T_H_OP120B	8500	7500	{}	decreasing	A5-P1	BMG	2	8	29
2721	InFan1SrvAmpSpeed_6_path1_T_H_OP120B	9500	9000	{}	decreasing	A6-P1	A2	2	8	29
2722	InFan1SrvAmpSpeed_7_path1_T_H_OP120B	8500	7500	{}	decreasing	A7-P1	AT	2	8	29
2723	ServoLoad_0_path1_T_H_OP120B	NaN	NaN	{}	increasing	A0-P1	X	17	17	29
2724	ServoLoad_1_path1_T_H_OP120B	NaN	NaN	{}	increasing	A1-P1	Z	17	17	29
2725	ServoLoad_2_path1_T_H_OP120B	NaN	NaN	{}	increasing	A2-P1	Y	17	17	29
2726	ServoLoad_3_path1_T_H_OP120B	NaN	NaN	{}	increasing	A3-P1	YS	17	17	29
2728	ServoLoad_5_path1_T_H_OP120B	NaN	NaN	{}	increasing	A5-P1	BMG	17	17	29
2729	ServoLoad_6_path1_T_H_OP120B	NaN	NaN	{}	increasing	A6-P1	A2	17	17	29
2730	ServoLoad_7_path1_T_H_OP120B	NaN	NaN	{}	increasing	A7-P1	AT	17	17	29
2731	SpindleLoad_0_path1_T_H_OP120B	NaN	NaN	{}	increasing	SP-P1	SP	17	17	29
2732	SpdBatZero_0_path1_T_H_OP120B	NaN	NaN	{}	bool	A0-P1	X	6	13	29
2733	SpdBatZero_1_path1_T_H_OP120B	NaN	NaN	{}	bool	A1-P1	Z	6	13	29
2734	SpdBatZero_2_path1_T_H_OP120B	NaN	NaN	{}	bool	A2-P1	Y	6	13	29
2735	SpdBatZero_3_path1_T_H_OP120B	NaN	NaN	{}	bool	A3-P1	YS	6	13	29
2737	SpdBatZero_5_path1_T_H_OP120B	NaN	NaN	{}	bool	A5-P1	BMG	6	13	29
2738	SpdBatZero_6_path1_T_H_OP120B	NaN	NaN	{}	bool	A6-P1	A2	6	13	29
2739	SpdBatZero_7_path1_T_H_OP120B	NaN	NaN	{}	bool	A7-P1	AT	6	13	29
2740	SSpdBatZero_0_path1_T_H_OP120B	NaN	NaN	{}	bool	A0-P1	X	6	14	29
2741	SSpdBatZero_1_path1_T_H_OP120B	NaN	NaN	{}	bool	A1-P1	Z	6	14	29
2742	SSpdBatZero_2_path1_T_H_OP120B	NaN	NaN	{}	bool	A2-P1	Y	6	14	29
2743	SSpdBatZero_3_path1_T_H_OP120B	NaN	NaN	{}	bool	A3-P1	YS	6	14	29
2745	SSpdBatZero_5_path1_T_H_OP120B	NaN	NaN	{}	bool	A5-P1	BMG	6	14	29
2746	SSpdBatZero_6_path1_T_H_OP120B	NaN	NaN	{}	bool	A6-P1	A2	6	14	29
2747	SSpdBatZero_7_path1_T_H_OP120B	NaN	NaN	{}	bool	A7-P1	AT	6	14	29
2748	RadFan2SpindleAmpSpeed_0_path1_T_H_OP120B	5000	4500	{}	decreasing	SP-P1	SP	2	16	29
2749	RadFan2SrvAmpSpeed_0_path1_T_H_OP120B	5000	4500	{}	decreasing	A0-P1	X	2	16	29
2750	RadFan2SrvAmpSpeed_1_path1_T_H_OP120B	5000	4500	{}	decreasing	A1-P1	Z	2	16	29
2751	RadFan2SrvAmpSpeed_2_path1_T_H_OP120B	5000	4500	{}	decreasing	A2-P1	Y	2	16	29
2752	RadFan2SrvAmpSpeed_3_path1_T_H_OP120B	5000	4500	{}	decreasing	A3-P1	YS	2	16	29
2754	RadFan2SrvAmpSpeed_5_path1_T_H_OP120B	5000	4500	{}	decreasing	A5-P1	BMG	2	16	29
2755	RadFan2SrvAmpSpeed_6_path1_T_H_OP120B	5000	4500	{}	decreasing	A6-P1	A2	2	16	29
2756	RadFan2SrvAmpSpeed_7_path1_T_H_OP120B	5000	4500	{}	decreasing	A7-P1	AT	2	16	29
2757	ApcBatLow_0_path1_T_H_OP120B	NaN	NaN	{}	bool	A0-P1	X	6	1	29
2758	ApcBatLow_1_path1_T_H_OP120B	NaN	NaN	{}	bool	A1-P1	Z	6	1	29
2759	ApcBatLow_2_path1_T_H_OP120B	NaN	NaN	{}	bool	A2-P1	Y	6	1	29
2760	ApcBatLow_3_path1_T_H_OP120B	NaN	NaN	{}	bool	A3-P1	YS	6	1	29
2762	ApcBatLow_5_path1_T_H_OP120B	NaN	NaN	{}	bool	A5-P1	BMG	6	1	29
2763	ApcBatLow_6_path1_T_H_OP120B	NaN	NaN	{}	bool	A6-P1	A2	6	1	29
2764	ApcBatLow_7_path1_T_H_OP120B	NaN	NaN	{}	bool	A7-P1	AT	6	1	29
2765	CncBatLow_0_path1_T_H_OP120B	NaN	NaN	{}	bool	A0-P1	X	6	2	29
2766	CncBatLow_1_path1_T_H_OP120B	NaN	NaN	{}	bool	A1-P1	Z	6	2	29
2767	CncBatLow_2_path1_T_H_OP120B	NaN	NaN	{}	bool	A2-P1	Y	6	2	29
2768	CncBatLow_3_path1_T_H_OP120B	NaN	NaN	{}	bool	A3-P1	YS	6	2	29
2770	CncBatLow_5_path1_T_H_OP120B	NaN	NaN	{}	bool	A5-P1	BMG	6	2	29
2771	CncBatLow_6_path1_T_H_OP120B	NaN	NaN	{}	bool	A6-P1	A2	6	2	29
2772	CncBatLow_7_path1_T_H_OP120B	NaN	NaN	{}	bool	A7-P1	AT	6	2	29
2773	ServoLeakResistData_0_path1_T_H_OP120B	50	30	{}	decreasing	A0-P1	X	15	5	29
2774	ServoLeakResistData_1_path1_T_H_OP120B	50	30	{}	decreasing	A1-P1	Z	15	5	29
2775	ServoLeakResistData_2_path1_T_H_OP120B	50	30	{}	decreasing	A2-P1	Y	15	5	29
2776	ServoLeakResistData_3_path1_T_H_OP120B	50	30	{}	decreasing	A3-P1	YS	15	5	29
2778	ServoLeakResistData_5_path1_T_H_OP120B	50	30	{}	decreasing	A5-P1	BMG	15	5	29
2779	ServoLeakResistData_6_path1_T_H_OP120B	50	30	{}	decreasing	A6-P1	A2	15	5	29
2780	ServoLeakResistData_7_path1_T_H_OP120B	50	30	{}	decreasing	A7-P1	AT	15	5	29
2781	SpindleLeakResistData_0_path1_T_H_OP120B	50	30	{}	decreasing	SP-P1	SP	15	5	29
2782	InFan1SrvComPwSpeed_0_path1_T_H_OP120B	6200	6000	{}	decreasing	A0-P1	X	2	9	29
2783	InFan1SrvComPwSpeed_1_path1_T_H_OP120B	6200	6000	{}	decreasing	A1-P1	Z	2	9	29
2784	InFan1SrvComPwSpeed_2_path1_T_H_OP120B	6200	6000	{}	decreasing	A2-P1	Y	2	9	29
2785	InFan1SrvComPwSpeed_3_path1_T_H_OP120B	6200	6000	{}	decreasing	A3-P1	YS	2	9	29
2787	InFan1SrvComPwSpeed_5_path1_T_H_OP120B	6200	6000	{}	decreasing	A5-P1	BMG	2	9	29
2788	InFan1SrvComPwSpeed_6_path1_T_H_OP120B	6200	6000	{}	decreasing	A6-P1	A2	2	9	29
2789	InFan1SrvComPwSpeed_7_path1_T_H_OP120B	6200	6000	{}	decreasing	A7-P1	AT	2	9	29
2790	InFan2SrvAmpSpeed_0_path1_T_H_OP120B	5000	4500	{}	decreasing	A0-P1	X	2	11	29
2791	InFan2SrvAmpSpeed_1_path1_T_H_OP120B	5000	4500	{}	decreasing	A1-P1	Z	2	11	29
2792	InFan2SrvAmpSpeed_2_path1_T_H_OP120B	5000	4500	{}	decreasing	A2-P1	Y	2	11	29
2793	InFan2SrvAmpSpeed_3_path1_T_H_OP120B	5000	4500	{}	decreasing	A3-P1	YS	2	11	29
2795	InFan2SrvAmpSpeed_5_path1_T_H_OP120B	5000	4500	{}	decreasing	A5-P1	BMG	2	11	29
2796	InFan2SrvAmpSpeed_6_path1_T_H_OP120B	5000	4500	{}	decreasing	A6-P1	A2	2	11	29
2797	InFan2SrvAmpSpeed_7_path1_T_H_OP120B	5000	4500	{}	decreasing	A7-P1	AT	2	11	29
2798	RadFan1SpindleAmpSpeed_0_path1_T_H_OP120B	5000	4500	{}	decreasing	SP-P1	SP	2	15	29
2799	RadFan1SrvAmpSpeed_0_path1_T_H_OP120B	5000	4500	{}	decreasing	A0-P1	X	2	15	29
2800	RadFan1SrvAmpSpeed_1_path1_T_H_OP120B	5000	4500	{}	decreasing	A1-P1	Z	2	15	29
2801	RadFan1SrvAmpSpeed_2_path1_T_H_OP120B	5000	4500	{}	decreasing	A2-P1	Y	2	15	29
2802	RadFan1SrvAmpSpeed_3_path1_T_H_OP120B	5000	4500	{}	decreasing	A3-P1	YS	2	15	29
2804	RadFan1SrvAmpSpeed_5_path1_T_H_OP120B	5000	4500	{}	decreasing	A5-P1	BMG	2	15	29
2805	RadFan1SrvAmpSpeed_6_path1_T_H_OP120B	5000	4500	{}	decreasing	A6-P1	A2	2	15	29
4321	ServoTemp_2_path1_T_H_OP230	55	70	{}	increasing	A2-P1	Y	13	3	41
2806	RadFan1SrvAmpSpeed_7_path1_T_H_OP120B	5000	4500	{}	decreasing	A7-P1	AT	2	15	29
2807	InFan2SpdlComPwSpeed_0_path1_T_H_OP120B	5000	4500	{}	decreasing	A0-P1	SAS	2	10	29
2808	InFan2SpindleAmpSpeed_0_path1_T_H_OP120B	5000	4500	{}	decreasing	A0-P1	SCS	2	10	29
2809	InFan2SrvComPwSpeed_0_path1_T_H_OP120B	5000	4500	{}	decreasing	A0-P1	X	2	12	29
2810	InFan2SrvComPwSpeed_1_path1_T_H_OP120B	5000	4500	{}	decreasing	A1-P1	Z	2	12	29
2811	InFan2SrvComPwSpeed_2_path1_T_H_OP120B	5000	4500	{}	decreasing	A2-P1	Y	2	12	29
2812	InFan2SrvComPwSpeed_3_path1_T_H_OP120B	5000	4500	{}	decreasing	A3-P1	YS	2	12	29
2814	InFan2SrvComPwSpeed_5_path1_T_H_OP120B	5000	4500	{}	decreasing	A5-P1	BMG	2	12	29
2815	InFan2SrvComPwSpeed_6_path1_T_H_OP120B	5000	4500	{}	decreasing	A6-P1	A2	2	12	29
2816	InFan2SrvComPwSpeed_7_path1_T_H_OP120B	5000	4500	{}	decreasing	A7-P1	AT	2	12	29
2817	InFan1SpdlComPwSpeed_0_path1_T_H_OP120B	5000	4500	{}	decreasing	A0-P1	SAS	2	7	29
2818	InFan1SpindleAmpSpeed_0_path1_T_H_OP120B	6200	6000	{}	decreasing	A0-P1	SCS	2	7	29
2819	ServoTemp_0_path1_T_H_OP120B	55	70	{}	increasing	A0-P1	X	13	3	29
2820	ServoTemp_1_path1_T_H_OP120B	55	70	{}	increasing	A1-P1	Z	13	3	29
2821	ServoTemp_2_path1_T_H_OP120B	55	70	{}	increasing	A2-P1	Y	13	3	29
2822	ServoTemp_3_path1_T_H_OP120B	55	70	{}	increasing	A3-P1	YS	13	3	29
2824	ServoTemp_5_path1_T_H_OP120B	55	70	{}	increasing	A5-P1	BMG	13	3	29
2825	ServoTemp_6_path1_T_H_OP120B	55	70	{}	increasing	A6-P1	A2	13	3	29
2826	ServoTemp_7_path1_T_H_OP120B	55	70	{}	increasing	A7-P1	AT	13	3	29
2827	SpindleTemp_0_path1_T_H_OP120B	80	100	{}	increasing	SP-P1	SP	13	3	29
2828	PulseCoderTemp_0_path1_T_H_OP140A	60	80	{}	increasing	A0-P1	X	13	4	30
2829	PulseCoderTemp_1_path1_T_H_OP140A	60	80	{}	increasing	A1-P1	Z	13	4	30
2830	PulseCoderTemp_2_path1_T_H_OP140A	60	80	{}	increasing	A2-P1	Y	13	4	30
2831	PulseCoderTemp_3_path1_T_H_OP140A	60	80	{}	increasing	A3-P1	YS	13	4	30
2833	PulseCoderTemp_5_path1_T_H_OP140A	60	80	{}	increasing	A5-P1	BMG	13	4	30
2834	PulseCoderTemp_6_path1_T_H_OP140A	60	80	{}	increasing	A6-P1	A2	13	4	30
2835	PulseCoderTemp_7_path1_T_H_OP140A	60	80	{}	increasing	A7-P1	AT	13	4	30
2836	CncFan1Speed_path1_T_H_OP140A	4500	4000	{}	decreasing	A1-P1	F1	16	6	30
2837	CncFan2Speed_path1_T_H_OP140A	9600	8600	{}	decreasing	A2-P1	F3	16	6	30
2840	InFan1SrvAmpSpeed_0_path1_T_H_OP140A	9500	9000	{}	decreasing	A0-P1	X	2	8	30
2841	InFan1SrvAmpSpeed_1_path1_T_H_OP140A	9500	9000	{}	decreasing	A1-P1	Z	2	8	30
2842	InFan1SrvAmpSpeed_2_path1_T_H_OP140A	9500	9000	{}	decreasing	A2-P1	Y	2	8	30
2843	InFan1SrvAmpSpeed_3_path1_T_H_OP140A	9500	9000	{}	decreasing	A3-P1	YS	2	8	30
2845	InFan1SrvAmpSpeed_5_path1_T_H_OP140A	8500	7500	{}	decreasing	A5-P1	BMG	2	8	30
2846	InFan1SrvAmpSpeed_6_path1_T_H_OP140A	9500	9000	{}	decreasing	A6-P1	A2	2	8	30
2847	InFan1SrvAmpSpeed_7_path1_T_H_OP140A	8500	7500	{}	decreasing	A7-P1	AT	2	8	30
2848	ServoLoad_0_path1_T_H_OP140A	NaN	NaN	{}	increasing	A0-P1	X	17	17	30
2849	ServoLoad_1_path1_T_H_OP140A	NaN	NaN	{}	increasing	A1-P1	Z	17	17	30
2850	ServoLoad_2_path1_T_H_OP140A	NaN	NaN	{}	increasing	A2-P1	Y	17	17	30
2851	ServoLoad_3_path1_T_H_OP140A	NaN	NaN	{}	increasing	A3-P1	YS	17	17	30
2853	ServoLoad_5_path1_T_H_OP140A	NaN	NaN	{}	increasing	A5-P1	BMG	17	17	30
2854	ServoLoad_6_path1_T_H_OP140A	NaN	NaN	{}	increasing	A6-P1	A2	17	17	30
2855	ServoLoad_7_path1_T_H_OP140A	NaN	NaN	{}	increasing	A7-P1	AT	17	17	30
2856	SpindleLoad_0_path1_T_H_OP140A	NaN	NaN	{}	increasing	SP-P1	SP	17	17	30
2857	SpdBatZero_0_path1_T_H_OP140A	NaN	NaN	{}	bool	A0-P1	X	6	13	30
2858	SpdBatZero_1_path1_T_H_OP140A	NaN	NaN	{}	bool	A1-P1	Z	6	13	30
2859	SpdBatZero_2_path1_T_H_OP140A	NaN	NaN	{}	bool	A2-P1	Y	6	13	30
2860	SpdBatZero_3_path1_T_H_OP140A	NaN	NaN	{}	bool	A3-P1	YS	6	13	30
2862	SpdBatZero_5_path1_T_H_OP140A	NaN	NaN	{}	bool	A5-P1	BMG	6	13	30
2863	SpdBatZero_6_path1_T_H_OP140A	NaN	NaN	{}	bool	A6-P1	A2	6	13	30
2864	SpdBatZero_7_path1_T_H_OP140A	NaN	NaN	{}	bool	A7-P1	AT	6	13	30
2865	SSpdBatZero_0_path1_T_H_OP140A	NaN	NaN	{}	bool	A0-P1	X	6	14	30
2866	SSpdBatZero_1_path1_T_H_OP140A	NaN	NaN	{}	bool	A1-P1	Z	6	14	30
2867	SSpdBatZero_2_path1_T_H_OP140A	NaN	NaN	{}	bool	A2-P1	Y	6	14	30
2868	SSpdBatZero_3_path1_T_H_OP140A	NaN	NaN	{}	bool	A3-P1	YS	6	14	30
2870	SSpdBatZero_5_path1_T_H_OP140A	NaN	NaN	{}	bool	A5-P1	BMG	6	14	30
2871	SSpdBatZero_6_path1_T_H_OP140A	NaN	NaN	{}	bool	A6-P1	A2	6	14	30
2872	SSpdBatZero_7_path1_T_H_OP140A	NaN	NaN	{}	bool	A7-P1	AT	6	14	30
2873	RadFan2SpindleAmpSpeed_0_path1_T_H_OP140A	5000	4500	{}	decreasing	SP-P1	SP	2	16	30
2874	RadFan2SrvAmpSpeed_0_path1_T_H_OP140A	5000	4500	{}	decreasing	A0-P1	X	2	16	30
2875	RadFan2SrvAmpSpeed_1_path1_T_H_OP140A	5000	4500	{}	decreasing	A1-P1	Z	2	16	30
2876	RadFan2SrvAmpSpeed_2_path1_T_H_OP140A	5000	4500	{}	decreasing	A2-P1	Y	2	16	30
2877	RadFan2SrvAmpSpeed_3_path1_T_H_OP140A	5000	4500	{}	decreasing	A3-P1	YS	2	16	30
2879	RadFan2SrvAmpSpeed_5_path1_T_H_OP140A	5000	4500	{}	decreasing	A5-P1	BMG	2	16	30
2880	RadFan2SrvAmpSpeed_6_path1_T_H_OP140A	5000	4500	{}	decreasing	A6-P1	A2	2	16	30
2881	RadFan2SrvAmpSpeed_7_path1_T_H_OP140A	5000	4500	{}	decreasing	A7-P1	AT	2	16	30
2882	ApcBatLow_0_path1_T_H_OP140A	NaN	NaN	{}	bool	A0-P1	X	6	1	30
2883	ApcBatLow_1_path1_T_H_OP140A	NaN	NaN	{}	bool	A1-P1	Z	6	1	30
2884	ApcBatLow_2_path1_T_H_OP140A	NaN	NaN	{}	bool	A2-P1	Y	6	1	30
2885	ApcBatLow_3_path1_T_H_OP140A	NaN	NaN	{}	bool	A3-P1	YS	6	1	30
2887	ApcBatLow_5_path1_T_H_OP140A	NaN	NaN	{}	bool	A5-P1	BMG	6	1	30
2888	ApcBatLow_6_path1_T_H_OP140A	NaN	NaN	{}	bool	A6-P1	A2	6	1	30
2889	ApcBatLow_7_path1_T_H_OP140A	NaN	NaN	{}	bool	A7-P1	AT	6	1	30
2890	CncBatLow_0_path1_T_H_OP140A	NaN	NaN	{}	bool	A0-P1	X	6	2	30
2891	CncBatLow_1_path1_T_H_OP140A	NaN	NaN	{}	bool	A1-P1	Z	6	2	30
2892	CncBatLow_2_path1_T_H_OP140A	NaN	NaN	{}	bool	A2-P1	Y	6	2	30
2893	CncBatLow_3_path1_T_H_OP140A	NaN	NaN	{}	bool	A3-P1	YS	6	2	30
2895	CncBatLow_5_path1_T_H_OP140A	NaN	NaN	{}	bool	A5-P1	BMG	6	2	30
2896	CncBatLow_6_path1_T_H_OP140A	NaN	NaN	{}	bool	A6-P1	A2	6	2	30
2897	CncBatLow_7_path1_T_H_OP140A	NaN	NaN	{}	bool	A7-P1	AT	6	2	30
2898	ServoLeakResistData_0_path1_T_H_OP140A	50	30	{}	decreasing	A0-P1	X	15	5	30
2899	ServoLeakResistData_1_path1_T_H_OP140A	50	30	{}	decreasing	A1-P1	Z	15	5	30
2900	ServoLeakResistData_2_path1_T_H_OP140A	50	30	{}	decreasing	A2-P1	Y	15	5	30
2901	ServoLeakResistData_3_path1_T_H_OP140A	50	30	{}	decreasing	A3-P1	YS	15	5	30
2903	ServoLeakResistData_5_path1_T_H_OP140A	50	30	{}	decreasing	A5-P1	BMG	15	5	30
2904	ServoLeakResistData_6_path1_T_H_OP140A	50	30	{}	decreasing	A6-P1	A2	15	5	30
2905	ServoLeakResistData_7_path1_T_H_OP140A	50	30	{}	decreasing	A7-P1	AT	15	5	30
2906	SpindleLeakResistData_0_path1_T_H_OP140A	50	30	{}	decreasing	SP-P1	SP	15	5	30
2907	InFan1SrvComPwSpeed_0_path1_T_H_OP140A	6200	6000	{}	decreasing	A0-P1	X	2	9	30
2908	InFan1SrvComPwSpeed_1_path1_T_H_OP140A	6200	6000	{}	decreasing	A1-P1	Z	2	9	30
2909	InFan1SrvComPwSpeed_2_path1_T_H_OP140A	6200	6000	{}	decreasing	A2-P1	Y	2	9	30
2910	InFan1SrvComPwSpeed_3_path1_T_H_OP140A	6200	6000	{}	decreasing	A3-P1	YS	2	9	30
2912	InFan1SrvComPwSpeed_5_path1_T_H_OP140A	6200	6000	{}	decreasing	A5-P1	BMG	2	9	30
2913	InFan1SrvComPwSpeed_6_path1_T_H_OP140A	6200	6000	{}	decreasing	A6-P1	A2	2	9	30
2914	InFan1SrvComPwSpeed_7_path1_T_H_OP140A	6200	6000	{}	decreasing	A7-P1	AT	2	9	30
2915	InFan2SrvAmpSpeed_0_path1_T_H_OP140A	5000	4500	{}	decreasing	A0-P1	X	2	11	30
2916	InFan2SrvAmpSpeed_1_path1_T_H_OP140A	5000	4500	{}	decreasing	A1-P1	Z	2	11	30
2917	InFan2SrvAmpSpeed_2_path1_T_H_OP140A	5000	4500	{}	decreasing	A2-P1	Y	2	11	30
2918	InFan2SrvAmpSpeed_3_path1_T_H_OP140A	5000	4500	{}	decreasing	A3-P1	YS	2	11	30
2920	InFan2SrvAmpSpeed_5_path1_T_H_OP140A	5000	4500	{}	decreasing	A5-P1	BMG	2	11	30
2921	InFan2SrvAmpSpeed_6_path1_T_H_OP140A	5000	4500	{}	decreasing	A6-P1	A2	2	11	30
2922	InFan2SrvAmpSpeed_7_path1_T_H_OP140A	5000	4500	{}	decreasing	A7-P1	AT	2	11	30
2923	RadFan1SpindleAmpSpeed_0_path1_T_H_OP140A	5000	4500	{}	decreasing	SP-P1	SP	2	15	30
2924	RadFan1SrvAmpSpeed_0_path1_T_H_OP140A	5000	4500	{}	decreasing	A0-P1	X	2	15	30
2925	RadFan1SrvAmpSpeed_1_path1_T_H_OP140A	5000	4500	{}	decreasing	A1-P1	Z	2	15	30
2926	RadFan1SrvAmpSpeed_2_path1_T_H_OP140A	5000	4500	{}	decreasing	A2-P1	Y	2	15	30
2927	RadFan1SrvAmpSpeed_3_path1_T_H_OP140A	5000	4500	{}	decreasing	A3-P1	YS	2	15	30
2929	RadFan1SrvAmpSpeed_5_path1_T_H_OP140A	5000	4500	{}	decreasing	A5-P1	BMG	2	15	30
2930	RadFan1SrvAmpSpeed_6_path1_T_H_OP140A	5000	4500	{}	decreasing	A6-P1	A2	2	15	30
2931	RadFan1SrvAmpSpeed_7_path1_T_H_OP140A	5000	4500	{}	decreasing	A7-P1	AT	2	15	30
2932	InFan2SpdlComPwSpeed_0_path1_T_H_OP140A	5000	4500	{}	decreasing	A0-P1	SAS	2	10	30
2933	InFan2SpindleAmpSpeed_0_path1_T_H_OP140A	5000	4500	{}	decreasing	A0-P1	SCS	2	10	30
2934	InFan2SrvComPwSpeed_0_path1_T_H_OP140A	5000	4500	{}	decreasing	A0-P1	X	2	12	30
2935	InFan2SrvComPwSpeed_1_path1_T_H_OP140A	5000	4500	{}	decreasing	A1-P1	Z	2	12	30
2936	InFan2SrvComPwSpeed_2_path1_T_H_OP140A	5000	4500	{}	decreasing	A2-P1	Y	2	12	30
2937	InFan2SrvComPwSpeed_3_path1_T_H_OP140A	5000	4500	{}	decreasing	A3-P1	YS	2	12	30
2939	InFan2SrvComPwSpeed_5_path1_T_H_OP140A	5000	4500	{}	decreasing	A5-P1	BMG	2	12	30
2940	InFan2SrvComPwSpeed_6_path1_T_H_OP140A	5000	4500	{}	decreasing	A6-P1	A2	2	12	30
2941	InFan2SrvComPwSpeed_7_path1_T_H_OP140A	5000	4500	{}	decreasing	A7-P1	AT	2	12	30
2942	InFan1SpdlComPwSpeed_0_path1_T_H_OP140A	5000	4500	{}	decreasing	A0-P1	SAS	2	7	30
4322	ServoTemp_3_path1_T_H_OP230	55	70	{}	increasing	A3-P1	YS	13	3	41
2943	InFan1SpindleAmpSpeed_0_path1_T_H_OP140A	6200	6000	{}	decreasing	A0-P1	SCS	2	7	30
2944	ServoTemp_0_path1_T_H_OP140A	55	70	{}	increasing	A0-P1	X	13	3	30
2945	ServoTemp_1_path1_T_H_OP140A	55	70	{}	increasing	A1-P1	Z	13	3	30
2946	ServoTemp_2_path1_T_H_OP140A	55	70	{}	increasing	A2-P1	Y	13	3	30
2947	ServoTemp_3_path1_T_H_OP140A	55	70	{}	increasing	A3-P1	YS	13	3	30
2949	ServoTemp_5_path1_T_H_OP140A	55	70	{}	increasing	A5-P1	BMG	13	3	30
2950	ServoTemp_6_path1_T_H_OP140A	55	70	{}	increasing	A6-P1	A2	13	3	30
2951	ServoTemp_7_path1_T_H_OP140A	55	70	{}	increasing	A7-P1	AT	13	3	30
2952	SpindleTemp_0_path1_T_H_OP140A	80	100	{}	increasing	SP-P1	SP	13	3	30
2953	PulseCoderTemp_0_path1_T_H_OP140B	60	80	{}	increasing	A0-P1	X	13	4	31
2954	PulseCoderTemp_1_path1_T_H_OP140B	60	80	{}	increasing	A1-P1	Z	13	4	31
2955	PulseCoderTemp_2_path1_T_H_OP140B	60	80	{}	increasing	A2-P1	Y	13	4	31
2956	PulseCoderTemp_3_path1_T_H_OP140B	70	80	{}	increasing	A3-P1	YS	13	4	31
2958	PulseCoderTemp_5_path1_T_H_OP140B	60	80	{}	increasing	A5-P1	BMG	13	4	31
2959	PulseCoderTemp_6_path1_T_H_OP140B	60	80	{}	increasing	A6-P1	A2	13	4	31
2960	PulseCoderTemp_7_path1_T_H_OP140B	60	80	{}	increasing	A7-P1	AT	13	4	31
2961	CncFan1Speed_path1_T_H_OP140B	4500	4000	{}	decreasing	A1-P1	F1	16	6	31
2962	CncFan2Speed_path1_T_H_OP140B	9600	8600	{}	decreasing	A2-P1	F3	16	6	31
2965	InFan1SrvAmpSpeed_0_path1_T_H_OP140B	9500	9000	{}	decreasing	A0-P1	X	2	8	31
2966	InFan1SrvAmpSpeed_1_path1_T_H_OP140B	9500	9000	{}	decreasing	A1-P1	Z	2	8	31
2967	InFan1SrvAmpSpeed_2_path1_T_H_OP140B	9500	9000	{}	decreasing	A2-P1	Y	2	8	31
2968	InFan1SrvAmpSpeed_3_path1_T_H_OP140B	9500	9000	{}	decreasing	A3-P1	YS	2	8	31
2970	InFan1SrvAmpSpeed_5_path1_T_H_OP140B	8500	7500	{}	decreasing	A5-P1	BMG	2	8	31
2971	InFan1SrvAmpSpeed_6_path1_T_H_OP140B	9500	9000	{}	decreasing	A6-P1	A2	2	8	31
2972	InFan1SrvAmpSpeed_7_path1_T_H_OP140B	8500	7500	{}	decreasing	A7-P1	AT	2	8	31
2973	ServoLoad_0_path1_T_H_OP140B	NaN	NaN	{}	increasing	A0-P1	X	17	17	31
2974	ServoLoad_1_path1_T_H_OP140B	NaN	NaN	{}	increasing	A1-P1	Z	17	17	31
2975	ServoLoad_2_path1_T_H_OP140B	NaN	NaN	{}	increasing	A2-P1	Y	17	17	31
2976	ServoLoad_3_path1_T_H_OP140B	NaN	NaN	{}	increasing	A3-P1	YS	17	17	31
2978	ServoLoad_5_path1_T_H_OP140B	NaN	NaN	{}	increasing	A5-P1	BMG	17	17	31
2979	ServoLoad_6_path1_T_H_OP140B	NaN	NaN	{}	increasing	A6-P1	A2	17	17	31
2980	ServoLoad_7_path1_T_H_OP140B	NaN	NaN	{}	increasing	A7-P1	AT	17	17	31
2981	SpindleLoad_0_path1_T_H_OP140B	NaN	NaN	{}	increasing	SP-P1	SP	17	17	31
2982	SpdBatZero_0_path1_T_H_OP140B	NaN	NaN	{}	bool	A0-P1	X	6	13	31
2983	SpdBatZero_1_path1_T_H_OP140B	NaN	NaN	{}	bool	A1-P1	Z	6	13	31
2984	SpdBatZero_2_path1_T_H_OP140B	NaN	NaN	{}	bool	A2-P1	Y	6	13	31
2985	SpdBatZero_3_path1_T_H_OP140B	NaN	NaN	{}	bool	A3-P1	YS	6	13	31
2987	SpdBatZero_5_path1_T_H_OP140B	NaN	NaN	{}	bool	A5-P1	BMG	6	13	31
2988	SpdBatZero_6_path1_T_H_OP140B	NaN	NaN	{}	bool	A6-P1	A2	6	13	31
2989	SpdBatZero_7_path1_T_H_OP140B	NaN	NaN	{}	bool	A7-P1	AT	6	13	31
2990	SSpdBatZero_0_path1_T_H_OP140B	NaN	NaN	{}	bool	A0-P1	X	6	14	31
2991	SSpdBatZero_1_path1_T_H_OP140B	NaN	NaN	{}	bool	A1-P1	Z	6	14	31
2992	SSpdBatZero_2_path1_T_H_OP140B	NaN	NaN	{}	bool	A2-P1	Y	6	14	31
2993	SSpdBatZero_3_path1_T_H_OP140B	NaN	NaN	{}	bool	A3-P1	YS	6	14	31
2995	SSpdBatZero_5_path1_T_H_OP140B	NaN	NaN	{}	bool	A5-P1	BMG	6	14	31
2996	SSpdBatZero_6_path1_T_H_OP140B	NaN	NaN	{}	bool	A6-P1	A2	6	14	31
2997	SSpdBatZero_7_path1_T_H_OP140B	NaN	NaN	{}	bool	A7-P1	AT	6	14	31
2998	RadFan2SpindleAmpSpeed_0_path1_T_H_OP140B	5000	4500	{}	decreasing	SP-P1	SP	2	16	31
2999	RadFan2SrvAmpSpeed_0_path1_T_H_OP140B	5000	4500	{}	decreasing	A0-P1	X	2	16	31
3000	RadFan2SrvAmpSpeed_1_path1_T_H_OP140B	5000	4500	{}	decreasing	A1-P1	Z	2	16	31
3001	RadFan2SrvAmpSpeed_2_path1_T_H_OP140B	5000	4500	{}	decreasing	A2-P1	Y	2	16	31
3002	RadFan2SrvAmpSpeed_3_path1_T_H_OP140B	5000	4500	{}	decreasing	A3-P1	YS	2	16	31
3004	RadFan2SrvAmpSpeed_5_path1_T_H_OP140B	5000	4500	{}	decreasing	A5-P1	BMG	2	16	31
3005	RadFan2SrvAmpSpeed_6_path1_T_H_OP140B	5000	4500	{}	decreasing	A6-P1	A2	2	16	31
3006	RadFan2SrvAmpSpeed_7_path1_T_H_OP140B	5000	4500	{}	decreasing	A7-P1	AT	2	16	31
3007	ApcBatLow_0_path1_T_H_OP140B	NaN	NaN	{}	bool	A0-P1	X	6	1	31
3008	ApcBatLow_1_path1_T_H_OP140B	NaN	NaN	{}	bool	A1-P1	Z	6	1	31
3009	ApcBatLow_2_path1_T_H_OP140B	NaN	NaN	{}	bool	A2-P1	Y	6	1	31
3010	ApcBatLow_3_path1_T_H_OP140B	NaN	NaN	{}	bool	A3-P1	YS	6	1	31
3012	ApcBatLow_5_path1_T_H_OP140B	NaN	NaN	{}	bool	A5-P1	BMG	6	1	31
3013	ApcBatLow_6_path1_T_H_OP140B	NaN	NaN	{}	bool	A6-P1	A2	6	1	31
3014	ApcBatLow_7_path1_T_H_OP140B	NaN	NaN	{}	bool	A7-P1	AT	6	1	31
3015	CncBatLow_0_path1_T_H_OP140B	NaN	NaN	{}	bool	A0-P1	X	6	2	31
3016	CncBatLow_1_path1_T_H_OP140B	NaN	NaN	{}	bool	A1-P1	Z	6	2	31
3017	CncBatLow_2_path1_T_H_OP140B	NaN	NaN	{}	bool	A2-P1	Y	6	2	31
3018	CncBatLow_3_path1_T_H_OP140B	NaN	NaN	{}	bool	A3-P1	YS	6	2	31
3020	CncBatLow_5_path1_T_H_OP140B	NaN	NaN	{}	bool	A5-P1	BMG	6	2	31
3021	CncBatLow_6_path1_T_H_OP140B	NaN	NaN	{}	bool	A6-P1	A2	6	2	31
3022	CncBatLow_7_path1_T_H_OP140B	NaN	NaN	{}	bool	A7-P1	AT	6	2	31
3023	ServoLeakResistData_0_path1_T_H_OP140B	50	30	{}	decreasing	A0-P1	X	15	5	31
3024	ServoLeakResistData_1_path1_T_H_OP140B	50	30	{}	decreasing	A1-P1	Z	15	5	31
3025	ServoLeakResistData_2_path1_T_H_OP140B	50	30	{}	decreasing	A2-P1	Y	15	5	31
3026	ServoLeakResistData_3_path1_T_H_OP140B	50	30	{}	decreasing	A3-P1	YS	15	5	31
3028	ServoLeakResistData_5_path1_T_H_OP140B	50	30	{}	decreasing	A5-P1	BMG	15	5	31
3029	ServoLeakResistData_6_path1_T_H_OP140B	50	30	{}	decreasing	A6-P1	A2	15	5	31
3030	ServoLeakResistData_7_path1_T_H_OP140B	50	30	{}	decreasing	A7-P1	AT	15	5	31
3031	SpindleLeakResistData_0_path1_T_H_OP140B	50	30	{}	decreasing	SP-P1	SP	15	5	31
3032	InFan1SrvComPwSpeed_0_path1_T_H_OP140B	6200	6000	{}	decreasing	A0-P1	X	2	9	31
3033	InFan1SrvComPwSpeed_1_path1_T_H_OP140B	6200	6000	{}	decreasing	A1-P1	Z	2	9	31
3034	InFan1SrvComPwSpeed_2_path1_T_H_OP140B	6200	6000	{}	decreasing	A2-P1	Y	2	9	31
3035	InFan1SrvComPwSpeed_3_path1_T_H_OP140B	6200	6000	{}	decreasing	A3-P1	YS	2	9	31
3037	InFan1SrvComPwSpeed_5_path1_T_H_OP140B	6200	6000	{}	decreasing	A5-P1	BMG	2	9	31
3038	InFan1SrvComPwSpeed_6_path1_T_H_OP140B	6200	6000	{}	decreasing	A6-P1	A2	2	9	31
3039	InFan1SrvComPwSpeed_7_path1_T_H_OP140B	6200	6000	{}	decreasing	A7-P1	AT	2	9	31
3040	InFan2SrvAmpSpeed_0_path1_T_H_OP140B	5000	4500	{}	decreasing	A0-P1	X	2	11	31
3041	InFan2SrvAmpSpeed_1_path1_T_H_OP140B	5000	4500	{}	decreasing	A1-P1	Z	2	11	31
3042	InFan2SrvAmpSpeed_2_path1_T_H_OP140B	5000	4500	{}	decreasing	A2-P1	Y	2	11	31
3043	InFan2SrvAmpSpeed_3_path1_T_H_OP140B	5000	4500	{}	decreasing	A3-P1	YS	2	11	31
3045	InFan2SrvAmpSpeed_5_path1_T_H_OP140B	5000	4500	{}	decreasing	A5-P1	BMG	2	11	31
3046	InFan2SrvAmpSpeed_6_path1_T_H_OP140B	5000	4500	{}	decreasing	A6-P1	A2	2	11	31
3047	InFan2SrvAmpSpeed_7_path1_T_H_OP140B	5000	4500	{}	decreasing	A7-P1	AT	2	11	31
3048	RadFan1SpindleAmpSpeed_0_path1_T_H_OP140B	5000	4500	{}	decreasing	SP-P1	SP	2	15	31
3049	RadFan1SrvAmpSpeed_0_path1_T_H_OP140B	5000	4500	{}	decreasing	A0-P1	X	2	15	31
3050	RadFan1SrvAmpSpeed_1_path1_T_H_OP140B	5000	4500	{}	decreasing	A1-P1	Z	2	15	31
3051	RadFan1SrvAmpSpeed_2_path1_T_H_OP140B	5000	4500	{}	decreasing	A2-P1	Y	2	15	31
3052	RadFan1SrvAmpSpeed_3_path1_T_H_OP140B	5000	4500	{}	decreasing	A3-P1	YS	2	15	31
3054	RadFan1SrvAmpSpeed_5_path1_T_H_OP140B	5000	4500	{}	decreasing	A5-P1	BMG	2	15	31
3055	RadFan1SrvAmpSpeed_6_path1_T_H_OP140B	5000	4500	{}	decreasing	A6-P1	A2	2	15	31
3056	RadFan1SrvAmpSpeed_7_path1_T_H_OP140B	5000	4500	{}	decreasing	A7-P1	AT	2	15	31
3057	InFan2SpdlComPwSpeed_0_path1_T_H_OP140B	5000	4500	{}	decreasing	A0-P1	SAS	2	10	31
3058	InFan2SpindleAmpSpeed_0_path1_T_H_OP140B	5000	4500	{}	decreasing	A0-P1	SCS	2	10	31
3059	InFan2SrvComPwSpeed_0_path1_T_H_OP140B	5000	4500	{}	decreasing	A0-P1	X	2	12	31
3060	InFan2SrvComPwSpeed_1_path1_T_H_OP140B	5000	4500	{}	decreasing	A1-P1	Z	2	12	31
3061	InFan2SrvComPwSpeed_2_path1_T_H_OP140B	5000	4500	{}	decreasing	A2-P1	Y	2	12	31
3062	InFan2SrvComPwSpeed_3_path1_T_H_OP140B	5000	4500	{}	decreasing	A3-P1	YS	2	12	31
3064	InFan2SrvComPwSpeed_5_path1_T_H_OP140B	5000	4500	{}	decreasing	A5-P1	BMG	2	12	31
3065	InFan2SrvComPwSpeed_6_path1_T_H_OP140B	5000	4500	{}	decreasing	A6-P1	A2	2	12	31
3066	InFan2SrvComPwSpeed_7_path1_T_H_OP140B	5000	4500	{}	decreasing	A7-P1	AT	2	12	31
3067	InFan1SpdlComPwSpeed_0_path1_T_H_OP140B	5000	4500	{}	decreasing	A0-P1	SAS	2	7	31
3068	InFan1SpindleAmpSpeed_0_path1_T_H_OP140B	6200	6000	{}	decreasing	A0-P1	SCS	2	7	31
3069	ServoTemp_0_path1_T_H_OP140B	55	70	{}	increasing	A0-P1	X	13	3	31
3070	ServoTemp_1_path1_T_H_OP140B	55	70	{}	increasing	A1-P1	Z	13	3	31
3071	ServoTemp_2_path1_T_H_OP140B	55	70	{}	increasing	A2-P1	Y	13	3	31
3072	ServoTemp_3_path1_T_H_OP140B	55	70	{}	increasing	A3-P1	YS	13	3	31
3074	ServoTemp_5_path1_T_H_OP140B	55	70	{}	increasing	A5-P1	BMG	13	3	31
3075	ServoTemp_6_path1_T_H_OP140B	55	70	{}	increasing	A6-P1	A2	13	3	31
3076	ServoTemp_7_path1_T_H_OP140B	55	70	{}	increasing	A7-P1	AT	13	3	31
3077	SpindleTemp_0_path1_T_H_OP140B	80	100	{}	increasing	SP-P1	SP	13	3	31
3078	PulseCoderTemp_0_path1_T_H_OP150A	60	80	{}	increasing	A0-P1	X	13	4	32
3079	PulseCoderTemp_1_path1_T_H_OP150A	60	80	{}	increasing	A1-P1	Z	13	4	32
3080	PulseCoderTemp_2_path1_T_H_OP150A	60	80	{}	increasing	A2-P1	Y	13	4	32
3081	PulseCoderTemp_3_path1_T_H_OP150A	60	80	{}	increasing	A3-P1	YS	13	4	32
3083	PulseCoderTemp_5_path1_T_H_OP150A	60	80	{}	increasing	A5-P1	BMG	13	4	32
3084	PulseCoderTemp_6_path1_T_H_OP150A	60	80	{}	increasing	A6-P1	A2	13	4	32
3085	PulseCoderTemp_7_path1_T_H_OP150A	60	80	{}	increasing	A7-P1	AT	13	4	32
3086	CncFan1Speed_path1_T_H_OP150A	4500	4000	{}	decreasing	A1-P1	F1	16	6	32
3087	CncFan2Speed_path1_T_H_OP150A	9600	8600	{}	decreasing	A2-P1	F3	16	6	32
3090	InFan1SrvAmpSpeed_0_path1_T_H_OP150A	9500	9000	{}	decreasing	A0-P1	X	2	8	32
3091	InFan1SrvAmpSpeed_1_path1_T_H_OP150A	9500	9000	{}	decreasing	A1-P1	Z	2	8	32
3092	InFan1SrvAmpSpeed_2_path1_T_H_OP150A	9500	9000	{}	decreasing	A2-P1	Y	2	8	32
3093	InFan1SrvAmpSpeed_3_path1_T_H_OP150A	9500	9000	{}	decreasing	A3-P1	YS	2	8	32
3095	InFan1SrvAmpSpeed_5_path1_T_H_OP150A	8500	7500	{}	decreasing	A5-P1	BMG	2	8	32
3096	InFan1SrvAmpSpeed_6_path1_T_H_OP150A	9500	9000	{}	decreasing	A6-P1	A2	2	8	32
3097	InFan1SrvAmpSpeed_7_path1_T_H_OP150A	8500	7500	{}	decreasing	A7-P1	AT	2	8	32
3098	ServoLoad_0_path1_T_H_OP150A	NaN	NaN	{}	increasing	A0-P1	X	17	17	32
3099	ServoLoad_1_path1_T_H_OP150A	NaN	NaN	{}	increasing	A1-P1	Z	17	17	32
3100	ServoLoad_2_path1_T_H_OP150A	NaN	NaN	{}	increasing	A2-P1	Y	17	17	32
3101	ServoLoad_3_path1_T_H_OP150A	NaN	NaN	{}	increasing	A3-P1	YS	17	17	32
3103	ServoLoad_5_path1_T_H_OP150A	NaN	NaN	{}	increasing	A5-P1	BMG	17	17	32
3104	ServoLoad_6_path1_T_H_OP150A	NaN	NaN	{}	increasing	A6-P1	A2	17	17	32
3105	ServoLoad_7_path1_T_H_OP150A	NaN	NaN	{}	increasing	A7-P1	AT	17	17	32
3106	SpindleLoad_0_path1_T_H_OP150A	NaN	NaN	{}	increasing	SP-P1	SP	17	17	32
3107	SpdBatZero_0_path1_T_H_OP150A	NaN	NaN	{}	bool	A0-P1	X	6	13	32
3108	SpdBatZero_1_path1_T_H_OP150A	NaN	NaN	{}	bool	A1-P1	Z	6	13	32
3109	SpdBatZero_2_path1_T_H_OP150A	NaN	NaN	{}	bool	A2-P1	Y	6	13	32
3110	SpdBatZero_3_path1_T_H_OP150A	NaN	NaN	{}	bool	A3-P1	YS	6	13	32
3112	SpdBatZero_5_path1_T_H_OP150A	NaN	NaN	{}	bool	A5-P1	BMG	6	13	32
3113	SpdBatZero_6_path1_T_H_OP150A	NaN	NaN	{}	bool	A6-P1	A2	6	13	32
3114	SpdBatZero_7_path1_T_H_OP150A	NaN	NaN	{}	bool	A7-P1	AT	6	13	32
3115	SSpdBatZero_0_path1_T_H_OP150A	NaN	NaN	{}	bool	A0-P1	X	6	14	32
3116	SSpdBatZero_1_path1_T_H_OP150A	NaN	NaN	{}	bool	A1-P1	Z	6	14	32
3117	SSpdBatZero_2_path1_T_H_OP150A	NaN	NaN	{}	bool	A2-P1	Y	6	14	32
3118	SSpdBatZero_3_path1_T_H_OP150A	NaN	NaN	{}	bool	A3-P1	YS	6	14	32
3120	SSpdBatZero_5_path1_T_H_OP150A	NaN	NaN	{}	bool	A5-P1	BMG	6	14	32
3121	SSpdBatZero_6_path1_T_H_OP150A	NaN	NaN	{}	bool	A6-P1	A2	6	14	32
3122	SSpdBatZero_7_path1_T_H_OP150A	NaN	NaN	{}	bool	A7-P1	AT	6	14	32
3123	RadFan2SpindleAmpSpeed_0_path1_T_H_OP150A	5000	4500	{}	decreasing	SP-P1	SP	2	16	32
3124	RadFan2SrvAmpSpeed_0_path1_T_H_OP150A	5000	4500	{}	decreasing	A0-P1	X	2	16	32
3125	RadFan2SrvAmpSpeed_1_path1_T_H_OP150A	5000	4500	{}	decreasing	A1-P1	Z	2	16	32
3126	RadFan2SrvAmpSpeed_2_path1_T_H_OP150A	5000	4500	{}	decreasing	A2-P1	Y	2	16	32
3127	RadFan2SrvAmpSpeed_3_path1_T_H_OP150A	5000	4500	{}	decreasing	A3-P1	YS	2	16	32
3129	RadFan2SrvAmpSpeed_5_path1_T_H_OP150A	5000	4500	{}	decreasing	A5-P1	BMG	2	16	32
3130	RadFan2SrvAmpSpeed_6_path1_T_H_OP150A	5000	4500	{}	decreasing	A6-P1	A2	2	16	32
3131	RadFan2SrvAmpSpeed_7_path1_T_H_OP150A	5000	4500	{}	decreasing	A7-P1	AT	2	16	32
3132	ApcBatLow_0_path1_T_H_OP150A	NaN	NaN	{}	bool	A0-P1	X	6	1	32
3133	ApcBatLow_1_path1_T_H_OP150A	NaN	NaN	{}	bool	A1-P1	Z	6	1	32
3134	ApcBatLow_2_path1_T_H_OP150A	NaN	NaN	{}	bool	A2-P1	Y	6	1	32
3135	ApcBatLow_3_path1_T_H_OP150A	NaN	NaN	{}	bool	A3-P1	YS	6	1	32
3137	ApcBatLow_5_path1_T_H_OP150A	NaN	NaN	{}	bool	A5-P1	BMG	6	1	32
3138	ApcBatLow_6_path1_T_H_OP150A	NaN	NaN	{}	bool	A6-P1	A2	6	1	32
3139	ApcBatLow_7_path1_T_H_OP150A	NaN	NaN	{}	bool	A7-P1	AT	6	1	32
3140	CncBatLow_0_path1_T_H_OP150A	NaN	NaN	{}	bool	A0-P1	X	6	2	32
3141	CncBatLow_1_path1_T_H_OP150A	NaN	NaN	{}	bool	A1-P1	Z	6	2	32
3142	CncBatLow_2_path1_T_H_OP150A	NaN	NaN	{}	bool	A2-P1	Y	6	2	32
3143	CncBatLow_3_path1_T_H_OP150A	NaN	NaN	{}	bool	A3-P1	YS	6	2	32
3145	CncBatLow_5_path1_T_H_OP150A	NaN	NaN	{}	bool	A5-P1	BMG	6	2	32
3146	CncBatLow_6_path1_T_H_OP150A	NaN	NaN	{}	bool	A6-P1	A2	6	2	32
3147	CncBatLow_7_path1_T_H_OP150A	NaN	NaN	{}	bool	A7-P1	AT	6	2	32
3148	ServoLeakResistData_0_path1_T_H_OP150A	50	30	{}	decreasing	A0-P1	X	15	5	32
3149	ServoLeakResistData_1_path1_T_H_OP150A	50	30	{}	decreasing	A1-P1	Z	15	5	32
3150	ServoLeakResistData_2_path1_T_H_OP150A	50	30	{}	decreasing	A2-P1	Y	15	5	32
3151	ServoLeakResistData_3_path1_T_H_OP150A	50	30	{}	decreasing	A3-P1	YS	15	5	32
3153	ServoLeakResistData_5_path1_T_H_OP150A	50	30	{}	decreasing	A5-P1	BMG	15	5	32
3154	ServoLeakResistData_6_path1_T_H_OP150A	50	30	{}	decreasing	A6-P1	A2	15	5	32
3155	ServoLeakResistData_7_path1_T_H_OP150A	50	30	{}	decreasing	A7-P1	AT	15	5	32
3156	SpindleLeakResistData_0_path1_T_H_OP150A	50	30	{}	decreasing	SP-P1	SP	15	5	32
3157	InFan1SrvComPwSpeed_0_path1_T_H_OP150A	6200	6000	{}	decreasing	A0-P1	X	2	9	32
3158	InFan1SrvComPwSpeed_1_path1_T_H_OP150A	6200	6000	{}	decreasing	A1-P1	Z	2	9	32
3159	InFan1SrvComPwSpeed_2_path1_T_H_OP150A	6200	6000	{}	decreasing	A2-P1	Y	2	9	32
3160	InFan1SrvComPwSpeed_3_path1_T_H_OP150A	6200	6000	{}	decreasing	A3-P1	YS	2	9	32
3162	InFan1SrvComPwSpeed_5_path1_T_H_OP150A	6200	6000	{}	decreasing	A5-P1	BMG	2	9	32
3163	InFan1SrvComPwSpeed_6_path1_T_H_OP150A	6200	6000	{}	decreasing	A6-P1	A2	2	9	32
3164	InFan1SrvComPwSpeed_7_path1_T_H_OP150A	6200	6000	{}	decreasing	A7-P1	AT	2	9	32
3165	InFan2SrvAmpSpeed_0_path1_T_H_OP150A	5000	4500	{}	decreasing	A0-P1	X	2	11	32
3166	InFan2SrvAmpSpeed_1_path1_T_H_OP150A	5000	4500	{}	decreasing	A1-P1	Z	2	11	32
3167	InFan2SrvAmpSpeed_2_path1_T_H_OP150A	5000	4500	{}	decreasing	A2-P1	Y	2	11	32
3168	InFan2SrvAmpSpeed_3_path1_T_H_OP150A	5000	4500	{}	decreasing	A3-P1	YS	2	11	32
3170	InFan2SrvAmpSpeed_5_path1_T_H_OP150A	5000	4500	{}	decreasing	A5-P1	BMG	2	11	32
3171	InFan2SrvAmpSpeed_6_path1_T_H_OP150A	5000	4500	{}	decreasing	A6-P1	A2	2	11	32
3172	InFan2SrvAmpSpeed_7_path1_T_H_OP150A	5000	4500	{}	decreasing	A7-P1	AT	2	11	32
3173	RadFan1SpindleAmpSpeed_0_path1_T_H_OP150A	5000	4500	{}	decreasing	SP-P1	SP	2	15	32
3174	RadFan1SrvAmpSpeed_0_path1_T_H_OP150A	5000	4500	{}	decreasing	A0-P1	X	2	15	32
3175	RadFan1SrvAmpSpeed_1_path1_T_H_OP150A	5000	4500	{}	decreasing	A1-P1	Z	2	15	32
3176	RadFan1SrvAmpSpeed_2_path1_T_H_OP150A	5000	4500	{}	decreasing	A2-P1	Y	2	15	32
3177	RadFan1SrvAmpSpeed_3_path1_T_H_OP150A	5000	4500	{}	decreasing	A3-P1	YS	2	15	32
3179	RadFan1SrvAmpSpeed_5_path1_T_H_OP150A	5000	4500	{}	decreasing	A5-P1	BMG	2	15	32
3180	RadFan1SrvAmpSpeed_6_path1_T_H_OP150A	5000	4500	{}	decreasing	A6-P1	A2	2	15	32
3181	RadFan1SrvAmpSpeed_7_path1_T_H_OP150A	5000	4500	{}	decreasing	A7-P1	AT	2	15	32
3182	InFan2SpdlComPwSpeed_0_path1_T_H_OP150A	5000	4500	{}	decreasing	A0-P1	SAS	2	10	32
3183	InFan2SpindleAmpSpeed_0_path1_T_H_OP150A	5000	4500	{}	decreasing	A0-P1	SCS	2	10	32
3184	InFan2SrvComPwSpeed_0_path1_T_H_OP150A	5000	4500	{}	decreasing	A0-P1	X	2	12	32
3185	InFan2SrvComPwSpeed_1_path1_T_H_OP150A	5000	4500	{}	decreasing	A1-P1	Z	2	12	32
3186	InFan2SrvComPwSpeed_2_path1_T_H_OP150A	5000	4500	{}	decreasing	A2-P1	Y	2	12	32
3187	InFan2SrvComPwSpeed_3_path1_T_H_OP150A	5000	4500	{}	decreasing	A3-P1	YS	2	12	32
3189	InFan2SrvComPwSpeed_5_path1_T_H_OP150A	5000	4500	{}	decreasing	A5-P1	BMG	2	12	32
3190	InFan2SrvComPwSpeed_6_path1_T_H_OP150A	5000	4500	{}	decreasing	A6-P1	A2	2	12	32
3262	ApcBatLow_5_path1_T_H_OP150B	NaN	NaN	{}	bool	A5-P1	BMG	6	1	33
3191	InFan2SrvComPwSpeed_7_path1_T_H_OP150A	5000	4500	{}	decreasing	A7-P1	AT	2	12	32
3192	InFan1SpdlComPwSpeed_0_path1_T_H_OP150A	5000	4500	{}	decreasing	A0-P1	SAS	2	7	32
3193	InFan1SpindleAmpSpeed_0_path1_T_H_OP150A	6200	6000	{}	decreasing	A0-P1	SCS	2	7	32
3194	ServoTemp_0_path1_T_H_OP150A	55	70	{}	increasing	A0-P1	X	13	3	32
3195	ServoTemp_1_path1_T_H_OP150A	55	70	{}	increasing	A1-P1	Z	13	3	32
3196	ServoTemp_2_path1_T_H_OP150A	55	70	{}	increasing	A2-P1	Y	13	3	32
3197	ServoTemp_3_path1_T_H_OP150A	55	70	{}	increasing	A3-P1	YS	13	3	32
3199	ServoTemp_5_path1_T_H_OP150A	55	70	{}	increasing	A5-P1	BMG	13	3	32
3200	ServoTemp_6_path1_T_H_OP150A	55	70	{}	increasing	A6-P1	A2	13	3	32
3201	ServoTemp_7_path1_T_H_OP150A	55	70	{}	increasing	A7-P1	AT	13	3	32
3202	SpindleTemp_0_path1_T_H_OP150A	80	100	{}	increasing	SP-P1	SP	13	3	32
3203	PulseCoderTemp_0_path1_T_H_OP150B	60	80	{}	increasing	A0-P1	X	13	4	33
3204	PulseCoderTemp_1_path1_T_H_OP150B	60	80	{}	increasing	A1-P1	Z	13	4	33
3205	PulseCoderTemp_2_path1_T_H_OP150B	60	80	{}	increasing	A2-P1	Y	13	4	33
3206	PulseCoderTemp_3_path1_T_H_OP150B	70	80	{}	increasing	A3-P1	YS	13	4	33
3208	PulseCoderTemp_5_path1_T_H_OP150B	60	80	{}	increasing	A5-P1	BMG	13	4	33
3209	PulseCoderTemp_6_path1_T_H_OP150B	60	80	{}	increasing	A6-P1	A2	13	4	33
3210	PulseCoderTemp_7_path1_T_H_OP150B	60	80	{}	increasing	A7-P1	AT	13	4	33
3211	CncFan1Speed_path1_T_H_OP150B	4500	4000	{}	decreasing	A1-P1	F1	16	6	33
3212	CncFan2Speed_path1_T_H_OP150B	9600	8600	{}	decreasing	A2-P1	F3	16	6	33
3215	InFan1SrvAmpSpeed_0_path1_T_H_OP150B	9500	9000	{}	decreasing	A0-P1	X	2	8	33
3216	InFan1SrvAmpSpeed_1_path1_T_H_OP150B	9500	9000	{}	decreasing	A1-P1	Z	2	8	33
3217	InFan1SrvAmpSpeed_2_path1_T_H_OP150B	9500	9000	{}	decreasing	A2-P1	Y	2	8	33
3218	InFan1SrvAmpSpeed_3_path1_T_H_OP150B	9500	9000	{}	decreasing	A3-P1	YS	2	8	33
3220	InFan1SrvAmpSpeed_5_path1_T_H_OP150B	8500	7500	{}	decreasing	A5-P1	BMG	2	8	33
3221	InFan1SrvAmpSpeed_6_path1_T_H_OP150B	9500	9000	{}	decreasing	A6-P1	A2	2	8	33
3222	InFan1SrvAmpSpeed_7_path1_T_H_OP150B	8500	7500	{}	decreasing	A7-P1	AT	2	8	33
3223	ServoLoad_0_path1_T_H_OP150B	NaN	NaN	{}	increasing	A0-P1	X	17	17	33
3224	ServoLoad_1_path1_T_H_OP150B	NaN	NaN	{}	increasing	A1-P1	Z	17	17	33
3225	ServoLoad_2_path1_T_H_OP150B	NaN	NaN	{}	increasing	A2-P1	Y	17	17	33
3226	ServoLoad_3_path1_T_H_OP150B	NaN	NaN	{}	increasing	A3-P1	YS	17	17	33
3228	ServoLoad_5_path1_T_H_OP150B	NaN	NaN	{}	increasing	A5-P1	BMG	17	17	33
3229	ServoLoad_6_path1_T_H_OP150B	NaN	NaN	{}	increasing	A6-P1	A2	17	17	33
3230	ServoLoad_7_path1_T_H_OP150B	NaN	NaN	{}	increasing	A7-P1	AT	17	17	33
3231	SpindleLoad_0_path1_T_H_OP150B	NaN	NaN	{}	increasing	SP-P1	SP	17	17	33
3232	SpdBatZero_0_path1_T_H_OP150B	NaN	NaN	{}	bool	A0-P1	X	6	13	33
3233	SpdBatZero_1_path1_T_H_OP150B	NaN	NaN	{}	bool	A1-P1	Z	6	13	33
3234	SpdBatZero_2_path1_T_H_OP150B	NaN	NaN	{}	bool	A2-P1	Y	6	13	33
3235	SpdBatZero_3_path1_T_H_OP150B	NaN	NaN	{}	bool	A3-P1	YS	6	13	33
3237	SpdBatZero_5_path1_T_H_OP150B	NaN	NaN	{}	bool	A5-P1	BMG	6	13	33
3238	SpdBatZero_6_path1_T_H_OP150B	NaN	NaN	{}	bool	A6-P1	A2	6	13	33
3239	SpdBatZero_7_path1_T_H_OP150B	NaN	NaN	{}	bool	A7-P1	AT	6	13	33
3240	SSpdBatZero_0_path1_T_H_OP150B	NaN	NaN	{}	bool	A0-P1	X	6	14	33
3241	SSpdBatZero_1_path1_T_H_OP150B	NaN	NaN	{}	bool	A1-P1	Z	6	14	33
3242	SSpdBatZero_2_path1_T_H_OP150B	NaN	NaN	{}	bool	A2-P1	Y	6	14	33
3243	SSpdBatZero_3_path1_T_H_OP150B	NaN	NaN	{}	bool	A3-P1	YS	6	14	33
3245	SSpdBatZero_5_path1_T_H_OP150B	NaN	NaN	{}	bool	A5-P1	BMG	6	14	33
3246	SSpdBatZero_6_path1_T_H_OP150B	NaN	NaN	{}	bool	A6-P1	A2	6	14	33
3247	SSpdBatZero_7_path1_T_H_OP150B	NaN	NaN	{}	bool	A7-P1	AT	6	14	33
3248	RadFan2SpindleAmpSpeed_0_path1_T_H_OP150B	5000	4500	{}	decreasing	SP-P1	SP	2	16	33
3249	RadFan2SrvAmpSpeed_0_path1_T_H_OP150B	5000	4500	{}	decreasing	A0-P1	X	2	16	33
3250	RadFan2SrvAmpSpeed_1_path1_T_H_OP150B	5000	4500	{}	decreasing	A1-P1	Z	2	16	33
3251	RadFan2SrvAmpSpeed_2_path1_T_H_OP150B	5000	4500	{}	decreasing	A2-P1	Y	2	16	33
3252	RadFan2SrvAmpSpeed_3_path1_T_H_OP150B	5000	4500	{}	decreasing	A3-P1	YS	2	16	33
3254	RadFan2SrvAmpSpeed_5_path1_T_H_OP150B	5000	4500	{}	decreasing	A5-P1	BMG	2	16	33
3255	RadFan2SrvAmpSpeed_6_path1_T_H_OP150B	5000	4500	{}	decreasing	A6-P1	A2	2	16	33
3256	RadFan2SrvAmpSpeed_7_path1_T_H_OP150B	5000	4500	{}	decreasing	A7-P1	AT	2	16	33
3257	ApcBatLow_0_path1_T_H_OP150B	NaN	NaN	{}	bool	A0-P1	X	6	1	33
3258	ApcBatLow_1_path1_T_H_OP150B	NaN	NaN	{}	bool	A1-P1	Z	6	1	33
3259	ApcBatLow_2_path1_T_H_OP150B	NaN	NaN	{}	bool	A2-P1	Y	6	1	33
3260	ApcBatLow_3_path1_T_H_OP150B	NaN	NaN	{}	bool	A3-P1	YS	6	1	33
3263	ApcBatLow_6_path1_T_H_OP150B	NaN	NaN	{}	bool	A6-P1	A2	6	1	33
3264	ApcBatLow_7_path1_T_H_OP150B	NaN	NaN	{}	bool	A7-P1	AT	6	1	33
3265	CncBatLow_0_path1_T_H_OP150B	NaN	NaN	{}	bool	A0-P1	X	6	2	33
3266	CncBatLow_1_path1_T_H_OP150B	NaN	NaN	{}	bool	A1-P1	Z	6	2	33
3267	CncBatLow_2_path1_T_H_OP150B	NaN	NaN	{}	bool	A2-P1	Y	6	2	33
3268	CncBatLow_3_path1_T_H_OP150B	NaN	NaN	{}	bool	A3-P1	YS	6	2	33
3270	CncBatLow_5_path1_T_H_OP150B	NaN	NaN	{}	bool	A5-P1	BMG	6	2	33
3271	CncBatLow_6_path1_T_H_OP150B	NaN	NaN	{}	bool	A6-P1	A2	6	2	33
3272	CncBatLow_7_path1_T_H_OP150B	NaN	NaN	{}	bool	A7-P1	AT	6	2	33
3273	ServoLeakResistData_0_path1_T_H_OP150B	50	30	{}	decreasing	A0-P1	X	15	5	33
3274	ServoLeakResistData_1_path1_T_H_OP150B	50	30	{}	decreasing	A1-P1	Z	15	5	33
3275	ServoLeakResistData_2_path1_T_H_OP150B	50	30	{}	decreasing	A2-P1	Y	15	5	33
3276	ServoLeakResistData_3_path1_T_H_OP150B	50	30	{}	decreasing	A3-P1	YS	15	5	33
3278	ServoLeakResistData_5_path1_T_H_OP150B	50	30	{}	decreasing	A5-P1	BMG	15	5	33
3279	ServoLeakResistData_6_path1_T_H_OP150B	50	30	{}	decreasing	A6-P1	A2	15	5	33
3280	ServoLeakResistData_7_path1_T_H_OP150B	50	30	{}	decreasing	A7-P1	AT	15	5	33
3281	SpindleLeakResistData_0_path1_T_H_OP150B	50	30	{}	decreasing	SP-P1	SP	15	5	33
3282	InFan1SrvComPwSpeed_0_path1_T_H_OP150B	6200	6000	{}	decreasing	A0-P1	X	2	9	33
3283	InFan1SrvComPwSpeed_1_path1_T_H_OP150B	6200	6000	{}	decreasing	A1-P1	Z	2	9	33
3284	InFan1SrvComPwSpeed_2_path1_T_H_OP150B	6200	6000	{}	decreasing	A2-P1	Y	2	9	33
3285	InFan1SrvComPwSpeed_3_path1_T_H_OP150B	6200	6000	{}	decreasing	A3-P1	YS	2	9	33
3287	InFan1SrvComPwSpeed_5_path1_T_H_OP150B	6200	6000	{}	decreasing	A5-P1	BMG	2	9	33
3288	InFan1SrvComPwSpeed_6_path1_T_H_OP150B	6200	6000	{}	decreasing	A6-P1	A2	2	9	33
3289	InFan1SrvComPwSpeed_7_path1_T_H_OP150B	6200	6000	{}	decreasing	A7-P1	AT	2	9	33
3290	InFan2SrvAmpSpeed_0_path1_T_H_OP150B	5000	4500	{}	decreasing	A0-P1	X	2	11	33
3291	InFan2SrvAmpSpeed_1_path1_T_H_OP150B	5000	4500	{}	decreasing	A1-P1	Z	2	11	33
3292	InFan2SrvAmpSpeed_2_path1_T_H_OP150B	5000	4500	{}	decreasing	A2-P1	Y	2	11	33
3293	InFan2SrvAmpSpeed_3_path1_T_H_OP150B	5000	4500	{}	decreasing	A3-P1	YS	2	11	33
3295	InFan2SrvAmpSpeed_5_path1_T_H_OP150B	5000	4500	{}	decreasing	A5-P1	BMG	2	11	33
3296	InFan2SrvAmpSpeed_6_path1_T_H_OP150B	5000	4500	{}	decreasing	A6-P1	A2	2	11	33
3297	InFan2SrvAmpSpeed_7_path1_T_H_OP150B	5000	4500	{}	decreasing	A7-P1	AT	2	11	33
3298	RadFan1SpindleAmpSpeed_0_path1_T_H_OP150B	5000	4500	{}	decreasing	SP-P1	SP	2	15	33
3299	RadFan1SrvAmpSpeed_0_path1_T_H_OP150B	5000	4500	{}	decreasing	A0-P1	X	2	15	33
3300	RadFan1SrvAmpSpeed_1_path1_T_H_OP150B	5000	4500	{}	decreasing	A1-P1	Z	2	15	33
3301	RadFan1SrvAmpSpeed_2_path1_T_H_OP150B	5000	4500	{}	decreasing	A2-P1	Y	2	15	33
3302	RadFan1SrvAmpSpeed_3_path1_T_H_OP150B	5000	4500	{}	decreasing	A3-P1	YS	2	15	33
3304	RadFan1SrvAmpSpeed_5_path1_T_H_OP150B	5000	4500	{}	decreasing	A5-P1	BMG	2	15	33
3305	RadFan1SrvAmpSpeed_6_path1_T_H_OP150B	5000	4500	{}	decreasing	A6-P1	A2	2	15	33
3306	RadFan1SrvAmpSpeed_7_path1_T_H_OP150B	5000	4500	{}	decreasing	A7-P1	AT	2	15	33
3307	InFan2SpdlComPwSpeed_0_path1_T_H_OP150B	5000	4500	{}	decreasing	A0-P1	SAS	2	10	33
3308	InFan2SpindleAmpSpeed_0_path1_T_H_OP150B	5000	4500	{}	decreasing	A0-P1	SCS	2	10	33
3309	InFan2SrvComPwSpeed_0_path1_T_H_OP150B	5000	4500	{}	decreasing	A0-P1	X	2	12	33
3310	InFan2SrvComPwSpeed_1_path1_T_H_OP150B	5000	4500	{}	decreasing	A1-P1	Z	2	12	33
3311	InFan2SrvComPwSpeed_2_path1_T_H_OP150B	5000	4500	{}	decreasing	A2-P1	Y	2	12	33
3312	InFan2SrvComPwSpeed_3_path1_T_H_OP150B	5000	4500	{}	decreasing	A3-P1	YS	2	12	33
3314	InFan2SrvComPwSpeed_5_path1_T_H_OP150B	5000	4500	{}	decreasing	A5-P1	BMG	2	12	33
3315	InFan2SrvComPwSpeed_6_path1_T_H_OP150B	5000	4500	{}	decreasing	A6-P1	A2	2	12	33
3316	InFan2SrvComPwSpeed_7_path1_T_H_OP150B	5000	4500	{}	decreasing	A7-P1	AT	2	12	33
3317	InFan1SpdlComPwSpeed_0_path1_T_H_OP150B	5000	4500	{}	decreasing	A0-P1	SAS	2	7	33
3318	InFan1SpindleAmpSpeed_0_path1_T_H_OP150B	6200	6000	{}	decreasing	A0-P1	SCS	2	7	33
3319	ServoTemp_0_path1_T_H_OP150B	55	70	{}	increasing	A0-P1	X	13	3	33
3320	ServoTemp_1_path1_T_H_OP150B	55	70	{}	increasing	A1-P1	Z	13	3	33
3321	ServoTemp_2_path1_T_H_OP150B	55	70	{}	increasing	A2-P1	Y	13	3	33
3322	ServoTemp_3_path1_T_H_OP150B	55	70	{}	increasing	A3-P1	YS	13	3	33
3324	ServoTemp_5_path1_T_H_OP150B	55	70	{}	increasing	A5-P1	BMG	13	3	33
3325	ServoTemp_6_path1_T_H_OP150B	55	70	{}	increasing	A6-P1	A2	13	3	33
3326	ServoTemp_7_path1_T_H_OP150B	55	70	{}	increasing	A7-P1	AT	13	3	33
3327	SpindleTemp_0_path1_T_H_OP150B	80	100	{}	increasing	SP-P1	SP	13	3	33
3328	PulseCoderTemp_0_path1_T_H_OP160A	60	80	{}	increasing	A0-P1	X	13	4	34
3329	PulseCoderTemp_1_path1_T_H_OP160A	60	80	{}	increasing	A1-P1	Z	13	4	34
3330	PulseCoderTemp_2_path1_T_H_OP160A	60	80	{}	increasing	A2-P1	Y	13	4	34
3331	PulseCoderTemp_3_path1_T_H_OP160A	60	80	{}	increasing	A3-P1	YS	13	4	34
3333	PulseCoderTemp_5_path1_T_H_OP160A	60	80	{}	increasing	A5-P1	BMG	13	4	34
3334	PulseCoderTemp_6_path1_T_H_OP160A	60	80	{}	increasing	A6-P1	A2	13	4	34
3335	PulseCoderTemp_7_path1_T_H_OP160A	60	80	{}	increasing	A7-P1	AT	13	4	34
3336	CncFan1Speed_path1_T_H_OP160A	4500	4000	{}	decreasing	A1-P1	F1	16	6	34
3337	CncFan2Speed_path1_T_H_OP160A	9600	8600	{}	decreasing	A2-P1	F3	16	6	34
3340	InFan1SrvAmpSpeed_0_path1_T_H_OP160A	9500	9000	{}	decreasing	A0-P1	X	2	8	34
3341	InFan1SrvAmpSpeed_1_path1_T_H_OP160A	9500	9000	{}	decreasing	A1-P1	Z	2	8	34
3342	InFan1SrvAmpSpeed_2_path1_T_H_OP160A	9500	9000	{}	decreasing	A2-P1	Y	2	8	34
3343	InFan1SrvAmpSpeed_3_path1_T_H_OP160A	9500	9000	{}	decreasing	A3-P1	YS	2	8	34
3345	InFan1SrvAmpSpeed_5_path1_T_H_OP160A	8500	7500	{}	decreasing	A5-P1	BMG	2	8	34
3346	InFan1SrvAmpSpeed_6_path1_T_H_OP160A	9500	9000	{}	decreasing	A6-P1	A2	2	8	34
3347	InFan1SrvAmpSpeed_7_path1_T_H_OP160A	8500	7500	{}	decreasing	A7-P1	AT	2	8	34
3348	ServoLoad_0_path1_T_H_OP160A	NaN	NaN	{}	increasing	A0-P1	X	17	17	34
3349	ServoLoad_1_path1_T_H_OP160A	NaN	NaN	{}	increasing	A1-P1	Z	17	17	34
3350	ServoLoad_2_path1_T_H_OP160A	NaN	NaN	{}	increasing	A2-P1	Y	17	17	34
3351	ServoLoad_3_path1_T_H_OP160A	NaN	NaN	{}	increasing	A3-P1	YS	17	17	34
3353	ServoLoad_5_path1_T_H_OP160A	NaN	NaN	{}	increasing	A5-P1	BMG	17	17	34
3354	ServoLoad_6_path1_T_H_OP160A	NaN	NaN	{}	increasing	A6-P1	A2	17	17	34
3355	ServoLoad_7_path1_T_H_OP160A	NaN	NaN	{}	increasing	A7-P1	AT	17	17	34
3356	SpindleLoad_0_path1_T_H_OP160A	NaN	NaN	{}	increasing	SP-P1	SP	17	17	34
3357	SpdBatZero_0_path1_T_H_OP160A	NaN	NaN	{}	bool	A0-P1	X	6	13	34
3358	SpdBatZero_1_path1_T_H_OP160A	NaN	NaN	{}	bool	A1-P1	Z	6	13	34
3359	SpdBatZero_2_path1_T_H_OP160A	NaN	NaN	{}	bool	A2-P1	Y	6	13	34
3360	SpdBatZero_3_path1_T_H_OP160A	NaN	NaN	{}	bool	A3-P1	YS	6	13	34
3362	SpdBatZero_5_path1_T_H_OP160A	NaN	NaN	{}	bool	A5-P1	BMG	6	13	34
3363	SpdBatZero_6_path1_T_H_OP160A	NaN	NaN	{}	bool	A6-P1	A2	6	13	34
3364	SpdBatZero_7_path1_T_H_OP160A	NaN	NaN	{}	bool	A7-P1	AT	6	13	34
3365	SSpdBatZero_0_path1_T_H_OP160A	NaN	NaN	{}	bool	A0-P1	X	6	14	34
3366	SSpdBatZero_1_path1_T_H_OP160A	NaN	NaN	{}	bool	A1-P1	Z	6	14	34
3367	SSpdBatZero_2_path1_T_H_OP160A	NaN	NaN	{}	bool	A2-P1	Y	6	14	34
3368	SSpdBatZero_3_path1_T_H_OP160A	NaN	NaN	{}	bool	A3-P1	YS	6	14	34
3370	SSpdBatZero_5_path1_T_H_OP160A	NaN	NaN	{}	bool	A5-P1	BMG	6	14	34
3371	SSpdBatZero_6_path1_T_H_OP160A	NaN	NaN	{}	bool	A6-P1	A2	6	14	34
3372	SSpdBatZero_7_path1_T_H_OP160A	NaN	NaN	{}	bool	A7-P1	AT	6	14	34
3373	RadFan2SpindleAmpSpeed_0_path1_T_H_OP160A	5000	4500	{}	decreasing	SP-P1	SP	2	16	34
3374	RadFan2SrvAmpSpeed_0_path1_T_H_OP160A	5000	4500	{}	decreasing	A0-P1	X	2	16	34
3375	RadFan2SrvAmpSpeed_1_path1_T_H_OP160A	5000	4500	{}	decreasing	A1-P1	Z	2	16	34
3376	RadFan2SrvAmpSpeed_2_path1_T_H_OP160A	5000	4500	{}	decreasing	A2-P1	Y	2	16	34
3377	RadFan2SrvAmpSpeed_3_path1_T_H_OP160A	5000	4500	{}	decreasing	A3-P1	YS	2	16	34
3379	RadFan2SrvAmpSpeed_5_path1_T_H_OP160A	5000	4500	{}	decreasing	A5-P1	BMG	2	16	34
3380	RadFan2SrvAmpSpeed_6_path1_T_H_OP160A	5000	4500	{}	decreasing	A6-P1	A2	2	16	34
3381	RadFan2SrvAmpSpeed_7_path1_T_H_OP160A	5000	4500	{}	decreasing	A7-P1	AT	2	16	34
3382	ApcBatLow_0_path1_T_H_OP160A	NaN	NaN	{}	bool	A0-P1	X	6	1	34
3383	ApcBatLow_1_path1_T_H_OP160A	NaN	NaN	{}	bool	A1-P1	Z	6	1	34
3384	ApcBatLow_2_path1_T_H_OP160A	NaN	NaN	{}	bool	A2-P1	Y	6	1	34
3385	ApcBatLow_3_path1_T_H_OP160A	NaN	NaN	{}	bool	A3-P1	YS	6	1	34
3387	ApcBatLow_5_path1_T_H_OP160A	NaN	NaN	{}	bool	A5-P1	BMG	6	1	34
3388	ApcBatLow_6_path1_T_H_OP160A	NaN	NaN	{}	bool	A6-P1	A2	6	1	34
3389	ApcBatLow_7_path1_T_H_OP160A	NaN	NaN	{}	bool	A7-P1	AT	6	1	34
3390	CncBatLow_0_path1_T_H_OP160A	NaN	NaN	{}	bool	A0-P1	X	6	2	34
3391	CncBatLow_1_path1_T_H_OP160A	NaN	NaN	{}	bool	A1-P1	Z	6	2	34
3392	CncBatLow_2_path1_T_H_OP160A	NaN	NaN	{}	bool	A2-P1	Y	6	2	34
3393	CncBatLow_3_path1_T_H_OP160A	NaN	NaN	{}	bool	A3-P1	YS	6	2	34
3395	CncBatLow_5_path1_T_H_OP160A	NaN	NaN	{}	bool	A5-P1	BMG	6	2	34
3396	CncBatLow_6_path1_T_H_OP160A	NaN	NaN	{}	bool	A6-P1	A2	6	2	34
3397	CncBatLow_7_path1_T_H_OP160A	NaN	NaN	{}	bool	A7-P1	AT	6	2	34
3398	ServoLeakResistData_0_path1_T_H_OP160A	50	30	{}	decreasing	A0-P1	X	15	5	34
3399	ServoLeakResistData_1_path1_T_H_OP160A	50	30	{}	decreasing	A1-P1	Z	15	5	34
3400	ServoLeakResistData_2_path1_T_H_OP160A	50	30	{}	decreasing	A2-P1	Y	15	5	34
3401	ServoLeakResistData_3_path1_T_H_OP160A	50	30	{}	decreasing	A3-P1	YS	15	5	34
3403	ServoLeakResistData_5_path1_T_H_OP160A	50	30	{}	decreasing	A5-P1	BMG	15	5	34
3404	ServoLeakResistData_6_path1_T_H_OP160A	50	30	{}	decreasing	A6-P1	A2	15	5	34
3405	ServoLeakResistData_7_path1_T_H_OP160A	50	30	{}	decreasing	A7-P1	AT	15	5	34
3406	SpindleLeakResistData_0_path1_T_H_OP160A	50	30	{}	decreasing	SP-P1	SP	15	5	34
3407	InFan1SrvComPwSpeed_0_path1_T_H_OP160A	6200	6000	{}	decreasing	A0-P1	X	2	9	34
3408	InFan1SrvComPwSpeed_1_path1_T_H_OP160A	6200	6000	{}	decreasing	A1-P1	Z	2	9	34
3409	InFan1SrvComPwSpeed_2_path1_T_H_OP160A	6200	6000	{}	decreasing	A2-P1	Y	2	9	34
3410	InFan1SrvComPwSpeed_3_path1_T_H_OP160A	6200	6000	{}	decreasing	A3-P1	YS	2	9	34
3412	InFan1SrvComPwSpeed_5_path1_T_H_OP160A	6200	6000	{}	decreasing	A5-P1	BMG	2	9	34
3413	InFan1SrvComPwSpeed_6_path1_T_H_OP160A	6200	6000	{}	decreasing	A6-P1	A2	2	9	34
3414	InFan1SrvComPwSpeed_7_path1_T_H_OP160A	6200	6000	{}	decreasing	A7-P1	AT	2	9	34
3415	InFan2SrvAmpSpeed_0_path1_T_H_OP160A	5000	4500	{}	decreasing	A0-P1	X	2	11	34
3416	InFan2SrvAmpSpeed_1_path1_T_H_OP160A	5000	4500	{}	decreasing	A1-P1	Z	2	11	34
3417	InFan2SrvAmpSpeed_2_path1_T_H_OP160A	5000	4500	{}	decreasing	A2-P1	Y	2	11	34
3418	InFan2SrvAmpSpeed_3_path1_T_H_OP160A	5000	4500	{}	decreasing	A3-P1	YS	2	11	34
3420	InFan2SrvAmpSpeed_5_path1_T_H_OP160A	5000	4500	{}	decreasing	A5-P1	BMG	2	11	34
3421	InFan2SrvAmpSpeed_6_path1_T_H_OP160A	5000	4500	{}	decreasing	A6-P1	A2	2	11	34
3422	InFan2SrvAmpSpeed_7_path1_T_H_OP160A	5000	4500	{}	decreasing	A7-P1	AT	2	11	34
3423	RadFan1SpindleAmpSpeed_0_path1_T_H_OP160A	5000	4500	{}	decreasing	SP-P1	SP	2	15	34
3424	RadFan1SrvAmpSpeed_0_path1_T_H_OP160A	5000	4500	{}	decreasing	A0-P1	X	2	15	34
3425	RadFan1SrvAmpSpeed_1_path1_T_H_OP160A	5000	4500	{}	decreasing	A1-P1	Z	2	15	34
3426	RadFan1SrvAmpSpeed_2_path1_T_H_OP160A	5000	4500	{}	decreasing	A2-P1	Y	2	15	34
3427	RadFan1SrvAmpSpeed_3_path1_T_H_OP160A	5000	4500	{}	decreasing	A3-P1	YS	2	15	34
3429	RadFan1SrvAmpSpeed_5_path1_T_H_OP160A	5000	4500	{}	decreasing	A5-P1	BMG	2	15	34
3430	RadFan1SrvAmpSpeed_6_path1_T_H_OP160A	5000	4500	{}	decreasing	A6-P1	A2	2	15	34
3431	RadFan1SrvAmpSpeed_7_path1_T_H_OP160A	5000	4500	{}	decreasing	A7-P1	AT	2	15	34
3432	InFan2SpdlComPwSpeed_0_path1_T_H_OP160A	5000	4500	{}	decreasing	A0-P1	SAS	2	10	34
3433	InFan2SpindleAmpSpeed_0_path1_T_H_OP160A	5000	4500	{}	decreasing	A0-P1	SCS	2	10	34
3434	InFan2SrvComPwSpeed_0_path1_T_H_OP160A	5000	4500	{}	decreasing	A0-P1	X	2	12	34
3435	InFan2SrvComPwSpeed_1_path1_T_H_OP160A	5000	4500	{}	decreasing	A1-P1	Z	2	12	34
3436	InFan2SrvComPwSpeed_2_path1_T_H_OP160A	5000	4500	{}	decreasing	A2-P1	Y	2	12	34
3437	InFan2SrvComPwSpeed_3_path1_T_H_OP160A	5000	4500	{}	decreasing	A3-P1	YS	2	12	34
3439	InFan2SrvComPwSpeed_5_path1_T_H_OP160A	5000	4500	{}	decreasing	A5-P1	BMG	2	12	34
3440	InFan2SrvComPwSpeed_6_path1_T_H_OP160A	5000	4500	{}	decreasing	A6-P1	A2	2	12	34
3441	InFan2SrvComPwSpeed_7_path1_T_H_OP160A	5000	4500	{}	decreasing	A7-P1	AT	2	12	34
3442	InFan1SpdlComPwSpeed_0_path1_T_H_OP160A	5000	4500	{}	decreasing	A0-P1	SAS	2	7	34
3443	InFan1SpindleAmpSpeed_0_path1_T_H_OP160A	6200	6000	{}	decreasing	A0-P1	SCS	2	7	34
3444	ServoTemp_0_path1_T_H_OP160A	55	70	{}	increasing	A0-P1	X	13	3	34
3445	ServoTemp_1_path1_T_H_OP160A	55	70	{}	increasing	A1-P1	Z	13	3	34
3446	ServoTemp_2_path1_T_H_OP160A	55	70	{}	increasing	A2-P1	Y	13	3	34
3447	ServoTemp_3_path1_T_H_OP160A	55	70	{}	increasing	A3-P1	YS	13	3	34
3449	ServoTemp_5_path1_T_H_OP160A	55	70	{}	increasing	A5-P1	BMG	13	3	34
3450	ServoTemp_6_path1_T_H_OP160A	55	70	{}	increasing	A6-P1	A2	13	3	34
3451	ServoTemp_7_path1_T_H_OP160A	55	70	{}	increasing	A7-P1	AT	13	3	34
3452	SpindleTemp_0_path1_T_H_OP160A	80	100	{}	increasing	SP-P1	SP	13	3	34
3453	PulseCoderTemp_0_path1_T_H_OP160B	60	80	{}	increasing	A0-P1	X	13	4	35
3454	PulseCoderTemp_1_path1_T_H_OP160B	70	80	{}	increasing	A1-P1	Z	13	4	35
3455	PulseCoderTemp_2_path1_T_H_OP160B	60	80	{}	increasing	A2-P1	Y	13	4	35
3456	PulseCoderTemp_3_path1_T_H_OP160B	60	80	{}	increasing	A3-P1	YS	13	4	35
3458	PulseCoderTemp_5_path1_T_H_OP160B	60	80	{}	increasing	A5-P1	BMG	13	4	35
3459	PulseCoderTemp_6_path1_T_H_OP160B	60	80	{}	increasing	A6-P1	A2	13	4	35
3460	PulseCoderTemp_7_path1_T_H_OP160B	60	80	{}	increasing	A7-P1	AT	13	4	35
3461	CncFan1Speed_path1_T_H_OP160B	4500	4000	{}	decreasing	A1-P1	F1	16	6	35
3462	CncFan2Speed_path1_T_H_OP160B	9600	8600	{}	decreasing	A2-P1	F3	16	6	35
3465	InFan1SrvAmpSpeed_0_path1_T_H_OP160B	9500	9000	{}	decreasing	A0-P1	X	2	8	35
3466	InFan1SrvAmpSpeed_1_path1_T_H_OP160B	9500	9000	{}	decreasing	A1-P1	Z	2	8	35
3467	InFan1SrvAmpSpeed_2_path1_T_H_OP160B	9500	9000	{}	decreasing	A2-P1	Y	2	8	35
3468	InFan1SrvAmpSpeed_3_path1_T_H_OP160B	9500	9000	{}	decreasing	A3-P1	YS	2	8	35
3470	InFan1SrvAmpSpeed_5_path1_T_H_OP160B	8500	7500	{}	decreasing	A5-P1	BMG	2	8	35
3471	InFan1SrvAmpSpeed_6_path1_T_H_OP160B	9500	9000	{}	decreasing	A6-P1	A2	2	8	35
3472	InFan1SrvAmpSpeed_7_path1_T_H_OP160B	8500	7500	{}	decreasing	A7-P1	AT	2	8	35
3473	ServoLoad_0_path1_T_H_OP160B	NaN	NaN	{}	increasing	A0-P1	X	17	17	35
3474	ServoLoad_1_path1_T_H_OP160B	NaN	NaN	{}	increasing	A1-P1	Z	17	17	35
3475	ServoLoad_2_path1_T_H_OP160B	NaN	NaN	{}	increasing	A2-P1	Y	17	17	35
3476	ServoLoad_3_path1_T_H_OP160B	NaN	NaN	{}	increasing	A3-P1	YS	17	17	35
3478	ServoLoad_5_path1_T_H_OP160B	NaN	NaN	{}	increasing	A5-P1	BMG	17	17	35
3479	ServoLoad_6_path1_T_H_OP160B	NaN	NaN	{}	increasing	A6-P1	A2	17	17	35
3480	ServoLoad_7_path1_T_H_OP160B	NaN	NaN	{}	increasing	A7-P1	AT	17	17	35
3481	SpindleLoad_0_path1_T_H_OP160B	NaN	NaN	{}	increasing	SP-P1	SP	17	17	35
3482	SpdBatZero_0_path1_T_H_OP160B	NaN	NaN	{}	bool	A0-P1	X	6	13	35
3483	SpdBatZero_1_path1_T_H_OP160B	NaN	NaN	{}	bool	A1-P1	Z	6	13	35
3484	SpdBatZero_2_path1_T_H_OP160B	NaN	NaN	{}	bool	A2-P1	Y	6	13	35
3485	SpdBatZero_3_path1_T_H_OP160B	NaN	NaN	{}	bool	A3-P1	YS	6	13	35
3487	SpdBatZero_5_path1_T_H_OP160B	NaN	NaN	{}	bool	A5-P1	BMG	6	13	35
3488	SpdBatZero_6_path1_T_H_OP160B	NaN	NaN	{}	bool	A6-P1	A2	6	13	35
3489	SpdBatZero_7_path1_T_H_OP160B	NaN	NaN	{}	bool	A7-P1	AT	6	13	35
3490	SSpdBatZero_0_path1_T_H_OP160B	NaN	NaN	{}	bool	A0-P1	X	6	14	35
3491	SSpdBatZero_1_path1_T_H_OP160B	NaN	NaN	{}	bool	A1-P1	Z	6	14	35
3492	SSpdBatZero_2_path1_T_H_OP160B	NaN	NaN	{}	bool	A2-P1	Y	6	14	35
3493	SSpdBatZero_3_path1_T_H_OP160B	NaN	NaN	{}	bool	A3-P1	YS	6	14	35
3495	SSpdBatZero_5_path1_T_H_OP160B	NaN	NaN	{}	bool	A5-P1	BMG	6	14	35
3496	SSpdBatZero_6_path1_T_H_OP160B	NaN	NaN	{}	bool	A6-P1	A2	6	14	35
3497	SSpdBatZero_7_path1_T_H_OP160B	NaN	NaN	{}	bool	A7-P1	AT	6	14	35
3498	RadFan2SpindleAmpSpeed_0_path1_T_H_OP160B	5000	4500	{}	decreasing	SP-P1	SP	2	16	35
3499	RadFan2SrvAmpSpeed_0_path1_T_H_OP160B	5000	4500	{}	decreasing	A0-P1	X	2	16	35
3500	RadFan2SrvAmpSpeed_1_path1_T_H_OP160B	5000	4500	{}	decreasing	A1-P1	Z	2	16	35
3501	RadFan2SrvAmpSpeed_2_path1_T_H_OP160B	5000	4500	{}	decreasing	A2-P1	Y	2	16	35
3502	RadFan2SrvAmpSpeed_3_path1_T_H_OP160B	5000	4500	{}	decreasing	A3-P1	YS	2	16	35
3504	RadFan2SrvAmpSpeed_5_path1_T_H_OP160B	5000	4500	{}	decreasing	A5-P1	BMG	2	16	35
3505	RadFan2SrvAmpSpeed_6_path1_T_H_OP160B	5000	4500	{}	decreasing	A6-P1	A2	2	16	35
3506	RadFan2SrvAmpSpeed_7_path1_T_H_OP160B	5000	4500	{}	decreasing	A7-P1	AT	2	16	35
3507	ApcBatLow_0_path1_T_H_OP160B	NaN	NaN	{}	bool	A0-P1	X	6	1	35
3508	ApcBatLow_1_path1_T_H_OP160B	NaN	NaN	{}	bool	A1-P1	Z	6	1	35
3509	ApcBatLow_2_path1_T_H_OP160B	NaN	NaN	{}	bool	A2-P1	Y	6	1	35
3510	ApcBatLow_3_path1_T_H_OP160B	NaN	NaN	{}	bool	A3-P1	YS	6	1	35
3512	ApcBatLow_5_path1_T_H_OP160B	NaN	NaN	{}	bool	A5-P1	BMG	6	1	35
3513	ApcBatLow_6_path1_T_H_OP160B	NaN	NaN	{}	bool	A6-P1	A2	6	1	35
3514	ApcBatLow_7_path1_T_H_OP160B	NaN	NaN	{}	bool	A7-P1	AT	6	1	35
3515	CncBatLow_0_path1_T_H_OP160B	NaN	NaN	{}	bool	A0-P1	X	6	2	35
3516	CncBatLow_1_path1_T_H_OP160B	NaN	NaN	{}	bool	A1-P1	Z	6	2	35
3517	CncBatLow_2_path1_T_H_OP160B	NaN	NaN	{}	bool	A2-P1	Y	6	2	35
3518	CncBatLow_3_path1_T_H_OP160B	NaN	NaN	{}	bool	A3-P1	YS	6	2	35
3520	CncBatLow_5_path1_T_H_OP160B	NaN	NaN	{}	bool	A5-P1	BMG	6	2	35
3521	CncBatLow_6_path1_T_H_OP160B	NaN	NaN	{}	bool	A6-P1	A2	6	2	35
3522	CncBatLow_7_path1_T_H_OP160B	NaN	NaN	{}	bool	A7-P1	AT	6	2	35
3523	ServoLeakResistData_0_path1_T_H_OP160B	50	30	{}	decreasing	A0-P1	X	15	5	35
3524	ServoLeakResistData_1_path1_T_H_OP160B	50	30	{}	decreasing	A1-P1	Z	15	5	35
3525	ServoLeakResistData_2_path1_T_H_OP160B	50	30	{}	decreasing	A2-P1	Y	15	5	35
3526	ServoLeakResistData_3_path1_T_H_OP160B	50	30	{}	decreasing	A3-P1	YS	15	5	35
3528	ServoLeakResistData_5_path1_T_H_OP160B	50	30	{}	decreasing	A5-P1	BMG	15	5	35
3529	ServoLeakResistData_6_path1_T_H_OP160B	50	30	{}	decreasing	A6-P1	A2	15	5	35
3530	ServoLeakResistData_7_path1_T_H_OP160B	50	30	{}	decreasing	A7-P1	AT	15	5	35
3531	SpindleLeakResistData_0_path1_T_H_OP160B	50	30	{}	decreasing	SP-P1	SP	15	5	35
3532	InFan1SrvComPwSpeed_0_path1_T_H_OP160B	6200	6000	{}	decreasing	A0-P1	X	2	9	35
3533	InFan1SrvComPwSpeed_1_path1_T_H_OP160B	6200	6000	{}	decreasing	A1-P1	Z	2	9	35
3534	InFan1SrvComPwSpeed_2_path1_T_H_OP160B	6200	6000	{}	decreasing	A2-P1	Y	2	9	35
3535	InFan1SrvComPwSpeed_3_path1_T_H_OP160B	6200	6000	{}	decreasing	A3-P1	YS	2	9	35
3537	InFan1SrvComPwSpeed_5_path1_T_H_OP160B	6200	6000	{}	decreasing	A5-P1	BMG	2	9	35
3538	InFan1SrvComPwSpeed_6_path1_T_H_OP160B	6200	6000	{}	decreasing	A6-P1	A2	2	9	35
3539	InFan1SrvComPwSpeed_7_path1_T_H_OP160B	6200	6000	{}	decreasing	A7-P1	AT	2	9	35
3540	InFan2SrvAmpSpeed_0_path1_T_H_OP160B	5000	4500	{}	decreasing	A0-P1	X	2	11	35
3541	InFan2SrvAmpSpeed_1_path1_T_H_OP160B	5000	4500	{}	decreasing	A1-P1	Z	2	11	35
3542	InFan2SrvAmpSpeed_2_path1_T_H_OP160B	5000	4500	{}	decreasing	A2-P1	Y	2	11	35
3543	InFan2SrvAmpSpeed_3_path1_T_H_OP160B	5000	4500	{}	decreasing	A3-P1	YS	2	11	35
3545	InFan2SrvAmpSpeed_5_path1_T_H_OP160B	5000	4500	{}	decreasing	A5-P1	BMG	2	11	35
3546	InFan2SrvAmpSpeed_6_path1_T_H_OP160B	5000	4500	{}	decreasing	A6-P1	A2	2	11	35
3547	InFan2SrvAmpSpeed_7_path1_T_H_OP160B	5000	4500	{}	decreasing	A7-P1	AT	2	11	35
3548	RadFan1SpindleAmpSpeed_0_path1_T_H_OP160B	5000	4500	{}	decreasing	SP-P1	SP	2	15	35
3549	RadFan1SrvAmpSpeed_0_path1_T_H_OP160B	5000	4500	{}	decreasing	A0-P1	X	2	15	35
3550	RadFan1SrvAmpSpeed_1_path1_T_H_OP160B	5000	4500	{}	decreasing	A1-P1	Z	2	15	35
3551	RadFan1SrvAmpSpeed_2_path1_T_H_OP160B	5000	4500	{}	decreasing	A2-P1	Y	2	15	35
3552	RadFan1SrvAmpSpeed_3_path1_T_H_OP160B	5000	4500	{}	decreasing	A3-P1	YS	2	15	35
3554	RadFan1SrvAmpSpeed_5_path1_T_H_OP160B	5000	4500	{}	decreasing	A5-P1	BMG	2	15	35
3555	RadFan1SrvAmpSpeed_6_path1_T_H_OP160B	5000	4500	{}	decreasing	A6-P1	A2	2	15	35
3556	RadFan1SrvAmpSpeed_7_path1_T_H_OP160B	5000	4500	{}	decreasing	A7-P1	AT	2	15	35
3557	InFan2SpdlComPwSpeed_0_path1_T_H_OP160B	5000	4500	{}	decreasing	A0-P1	SAS	2	10	35
3558	InFan2SpindleAmpSpeed_0_path1_T_H_OP160B	5000	4500	{}	decreasing	A0-P1	SCS	2	10	35
3559	InFan2SrvComPwSpeed_0_path1_T_H_OP160B	5000	4500	{}	decreasing	A0-P1	X	2	12	35
3560	InFan2SrvComPwSpeed_1_path1_T_H_OP160B	5000	4500	{}	decreasing	A1-P1	Z	2	12	35
3561	InFan2SrvComPwSpeed_2_path1_T_H_OP160B	5000	4500	{}	decreasing	A2-P1	Y	2	12	35
3562	InFan2SrvComPwSpeed_3_path1_T_H_OP160B	5000	4500	{}	decreasing	A3-P1	YS	2	12	35
3564	InFan2SrvComPwSpeed_5_path1_T_H_OP160B	5000	4500	{}	decreasing	A5-P1	BMG	2	12	35
3565	InFan2SrvComPwSpeed_6_path1_T_H_OP160B	5000	4500	{}	decreasing	A6-P1	A2	2	12	35
3566	InFan2SrvComPwSpeed_7_path1_T_H_OP160B	5000	4500	{}	decreasing	A7-P1	AT	2	12	35
4323	ServoTemp_4_path1_T_H_OP230	55	70	{}	increasing	A4-P1	B	13	3	41
3567	InFan1SpdlComPwSpeed_0_path1_T_H_OP160B	5000	4500	{}	decreasing	A0-P1	SAS	2	7	35
3568	InFan1SpindleAmpSpeed_0_path1_T_H_OP160B	6200	6000	{}	decreasing	A0-P1	SCS	2	7	35
3569	ServoTemp_0_path1_T_H_OP160B	55	70	{}	increasing	A0-P1	X	13	3	35
3570	ServoTemp_1_path1_T_H_OP160B	55	70	{}	increasing	A1-P1	Z	13	3	35
3571	ServoTemp_2_path1_T_H_OP160B	55	70	{}	increasing	A2-P1	Y	13	3	35
3572	ServoTemp_3_path1_T_H_OP160B	55	70	{}	increasing	A3-P1	YS	13	3	35
3574	ServoTemp_5_path1_T_H_OP160B	55	70	{}	increasing	A5-P1	BMG	13	3	35
3575	ServoTemp_6_path1_T_H_OP160B	55	70	{}	increasing	A6-P1	A2	13	3	35
3576	ServoTemp_7_path1_T_H_OP160B	55	70	{}	increasing	A7-P1	AT	13	3	35
3577	SpindleTemp_0_path1_T_H_OP160B	80	100	{}	increasing	SP-P1	SP	13	3	35
3578	PulseCoderTemp_0_path1_T_H_OP170A	60	80	{}	increasing	A0-P1	X	13	4	36
3579	PulseCoderTemp_1_path1_T_H_OP170A	60	80	{}	increasing	A1-P1	Z	13	4	36
3580	PulseCoderTemp_2_path1_T_H_OP170A	60	80	{}	increasing	A2-P1	Y	13	4	36
3581	PulseCoderTemp_3_path1_T_H_OP170A	60	80	{}	increasing	A3-P1	YS	13	4	36
3583	PulseCoderTemp_5_path1_T_H_OP170A	60	80	{}	increasing	A5-P1	BMG	13	4	36
3584	PulseCoderTemp_6_path1_T_H_OP170A	60	80	{}	increasing	A6-P1	A2	13	4	36
3585	PulseCoderTemp_7_path1_T_H_OP170A	60	80	{}	increasing	A7-P1	AT	13	4	36
3586	CncFan1Speed_path1_T_H_OP170A	4500	4000	{}	decreasing	A1-P1	F1	16	6	36
3587	CncFan2Speed_path1_T_H_OP170A	9600	8600	{}	decreasing	A2-P1	F3	16	6	36
3590	InFan1SrvAmpSpeed_0_path1_T_H_OP170A	9500	9000	{}	decreasing	A0-P1	X	2	8	36
3591	InFan1SrvAmpSpeed_1_path1_T_H_OP170A	9500	9000	{}	decreasing	A1-P1	Z	2	8	36
3592	InFan1SrvAmpSpeed_2_path1_T_H_OP170A	9500	9000	{}	decreasing	A2-P1	Y	2	8	36
3593	InFan1SrvAmpSpeed_3_path1_T_H_OP170A	9500	9000	{}	decreasing	A3-P1	YS	2	8	36
3595	InFan1SrvAmpSpeed_5_path1_T_H_OP170A	8500	7500	{}	decreasing	A5-P1	BMG	2	8	36
3596	InFan1SrvAmpSpeed_6_path1_T_H_OP170A	9500	9000	{}	decreasing	A6-P1	A2	2	8	36
3597	InFan1SrvAmpSpeed_7_path1_T_H_OP170A	8500	7500	{}	decreasing	A7-P1	AT	2	8	36
3598	ServoLoad_0_path1_T_H_OP170A	NaN	NaN	{}	increasing	A0-P1	X	17	17	36
3599	ServoLoad_1_path1_T_H_OP170A	NaN	NaN	{}	increasing	A1-P1	Z	17	17	36
3600	ServoLoad_2_path1_T_H_OP170A	NaN	NaN	{}	increasing	A2-P1	Y	17	17	36
3601	ServoLoad_3_path1_T_H_OP170A	NaN	NaN	{}	increasing	A3-P1	YS	17	17	36
3603	ServoLoad_5_path1_T_H_OP170A	NaN	NaN	{}	increasing	A5-P1	BMG	17	17	36
3604	ServoLoad_6_path1_T_H_OP170A	NaN	NaN	{}	increasing	A6-P1	A2	17	17	36
3605	ServoLoad_7_path1_T_H_OP170A	NaN	NaN	{}	increasing	A7-P1	AT	17	17	36
3606	SpindleLoad_0_path1_T_H_OP170A	NaN	NaN	{}	increasing	A0-P1	X	17	17	36
3607	SpdBatZero_0_path1_T_H_OP170A	NaN	NaN	{}	bool	A0-P1	X	6	13	36
3608	SpdBatZero_1_path1_T_H_OP170A	NaN	NaN	{}	bool	A1-P1	Z	6	13	36
3609	SpdBatZero_2_path1_T_H_OP170A	NaN	NaN	{}	bool	A2-P1	Y	6	13	36
3610	SpdBatZero_3_path1_T_H_OP170A	NaN	NaN	{}	bool	A3-P1	YS	6	13	36
3612	SpdBatZero_5_path1_T_H_OP170A	NaN	NaN	{}	bool	A5-P1	BMG	6	13	36
3613	SpdBatZero_6_path1_T_H_OP170A	NaN	NaN	{}	bool	A6-P1	A2	6	13	36
3614	SpdBatZero_7_path1_T_H_OP170A	NaN	NaN	{}	bool	A7-P1	AT	6	13	36
3615	SSpdBatZero_0_path1_T_H_OP170A	NaN	NaN	{}	bool	A0-P1	X	6	14	36
3616	SSpdBatZero_1_path1_T_H_OP170A	NaN	NaN	{}	bool	A1-P1	Z	6	14	36
3617	SSpdBatZero_2_path1_T_H_OP170A	NaN	NaN	{}	bool	A2-P1	Y	6	14	36
3618	SSpdBatZero_3_path1_T_H_OP170A	NaN	NaN	{}	bool	A3-P1	YS	6	14	36
3620	SSpdBatZero_5_path1_T_H_OP170A	NaN	NaN	{}	bool	A5-P1	BMG	6	14	36
3621	SSpdBatZero_6_path1_T_H_OP170A	NaN	NaN	{}	bool	A6-P1	A2	6	14	36
3622	SSpdBatZero_7_path1_T_H_OP170A	NaN	NaN	{}	bool	A7-P1	AT	6	14	36
3623	RadFan2SpindleAmpSpeed_0_path1_T_H_OP170A	5000	4500	{}	decreasing	SP-P1	SP	2	16	36
3624	RadFan2SrvAmpSpeed_0_path1_T_H_OP170A	5000	4500	{}	decreasing	A0-P1	X	2	16	36
3625	RadFan2SrvAmpSpeed_1_path1_T_H_OP170A	5000	4500	{}	decreasing	A1-P1	Z	2	16	36
3626	RadFan2SrvAmpSpeed_2_path1_T_H_OP170A	5000	4500	{}	decreasing	A2-P1	Z	2	16	36
3627	RadFan2SrvAmpSpeed_3_path1_T_H_OP170A	5000	4500	{}	decreasing	A3-P1	YS	2	16	36
3629	RadFan2SrvAmpSpeed_5_path1_T_H_OP170A	5000	4500	{}	decreasing	A5-P1	BMG	2	16	36
3630	RadFan2SrvAmpSpeed_6_path1_T_H_OP170A	5000	4500	{}	decreasing	A6-P1	A2	2	16	36
3631	RadFan2SrvAmpSpeed_7_path1_T_H_OP170A	5000	4500	{}	decreasing	A7-P1	AT	2	16	36
3632	ApcBatLow_0_path1_T_H_OP170A	NaN	NaN	{}	bool	A0-P1	X	6	1	36
3633	ApcBatLow_1_path1_T_H_OP170A	NaN	NaN	{}	bool	A1-P1	Z	6	1	36
3634	ApcBatLow_2_path1_T_H_OP170A	NaN	NaN	{}	bool	A2-P1	Y	6	1	36
3635	ApcBatLow_3_path1_T_H_OP170A	NaN	NaN	{}	bool	A3-P1	YS	6	1	36
3637	ApcBatLow_5_path1_T_H_OP170A	NaN	NaN	{}	bool	A5-P1	BMG	6	1	36
3638	ApcBatLow_6_path1_T_H_OP170A	NaN	NaN	{}	bool	A6-P1	A2	6	1	36
3639	ApcBatLow_7_path1_T_H_OP170A	NaN	NaN	{}	bool	A7-P1	AT	6	1	36
3640	CncBatLow_0_path1_T_H_OP170A	NaN	NaN	{}	bool	A0-P1	X	6	2	36
3641	CncBatLow_1_path1_T_H_OP170A	NaN	NaN	{}	bool	A1-P1	Z	6	2	36
3642	CncBatLow_2_path1_T_H_OP170A	NaN	NaN	{}	bool	A2-P1	Y	6	2	36
3643	CncBatLow_3_path1_T_H_OP170A	NaN	NaN	{}	bool	A3-P1	YS	6	2	36
3645	CncBatLow_5_path1_T_H_OP170A	NaN	NaN	{}	bool	A5-P1	BMG	6	2	36
3646	CncBatLow_6_path1_T_H_OP170A	NaN	NaN	{}	bool	A6-P1	A2	6	2	36
3647	CncBatLow_7_path1_T_H_OP170A	NaN	NaN	{}	bool	A7-P1	AT	6	2	36
3648	ServoLeakResistData_0_path1_T_H_OP170A	50	30	{}	decreasing	A0-P1	X	15	5	36
3649	ServoLeakResistData_1_path1_T_H_OP170A	50	30	{}	decreasing	A1-P1	Z	15	5	36
3650	ServoLeakResistData_2_path1_T_H_OP170A	50	30	{}	decreasing	A2-P1	Y	15	5	36
3651	ServoLeakResistData_3_path1_T_H_OP170A	50	30	{}	decreasing	A3-P1	YS	15	5	36
3653	ServoLeakResistData_5_path1_T_H_OP170A	50	30	{}	decreasing	A5-P1	BMG	15	5	36
3654	ServoLeakResistData_6_path1_T_H_OP170A	50	30	{}	decreasing	A6-P1	A2	15	5	36
3655	ServoLeakResistData_7_path1_T_H_OP170A	50	30	{}	decreasing	A7-P1	AT	15	5	36
3656	SpindleLeakResistData_0_path1_T_H_OP170A	50	30	{}	decreasing	SP-P1	SP	15	5	36
3657	InFan1SrvComPwSpeed_0_path1_T_H_OP170A	6200	6000	{}	decreasing	A0-P1	X	2	9	36
3658	InFan1SrvComPwSpeed_1_path1_T_H_OP170A	6200	6000	{}	decreasing	A1-P1	Z	2	9	36
3659	InFan1SrvComPwSpeed_2_path1_T_H_OP170A	6200	6000	{}	decreasing	A2-P1	Y	2	9	36
3660	InFan1SrvComPwSpeed_3_path1_T_H_OP170A	6200	6000	{}	decreasing	A3-P1	YS	2	9	36
3662	InFan1SrvComPwSpeed_5_path1_T_H_OP170A	6200	6000	{}	decreasing	A5-P1	BMG	2	9	36
3663	InFan1SrvComPwSpeed_6_path1_T_H_OP170A	6200	6000	{}	decreasing	A6-P1	A2	2	9	36
3664	InFan1SrvComPwSpeed_7_path1_T_H_OP170A	6200	6000	{}	decreasing	A7-P1	AT	2	9	36
3665	InFan2SrvAmpSpeed_0_path1_T_H_OP170A	5000	4500	{}	decreasing	A0-P1	X	2	11	36
3666	InFan2SrvAmpSpeed_1_path1_T_H_OP170A	5000	4500	{}	decreasing	A1-P1	Z	2	11	36
3667	InFan2SrvAmpSpeed_2_path1_T_H_OP170A	5000	4500	{}	decreasing	A2-P1	Y	2	11	36
3668	InFan2SrvAmpSpeed_3_path1_T_H_OP170A	5000	4500	{}	decreasing	A3-P1	YS	2	11	36
3670	InFan2SrvAmpSpeed_5_path1_T_H_OP170A	5000	4500	{}	decreasing	A5-P1	BMG	2	11	36
3671	InFan2SrvAmpSpeed_6_path1_T_H_OP170A	5000	4500	{}	decreasing	A6-P1	A2	2	11	36
3672	InFan2SrvAmpSpeed_7_path1_T_H_OP170A	5000	4500	{}	decreasing	A7-P1	AT	2	11	36
3673	RadFan1SpindleAmpSpeed_0_path1_T_H_OP170A	5000	4500	{}	decreasing	SP-P1	SP	2	15	36
3674	RadFan1SrvAmpSpeed_0_path1_T_H_OP170A	5000	4500	{}	decreasing	A0-P1	X	2	15	36
3675	RadFan1SrvAmpSpeed_1_path1_T_H_OP170A	5000	4500	{}	decreasing	A1-P1	Z	2	15	36
3676	RadFan1SrvAmpSpeed_2_path1_T_H_OP170A	5000	4500	{}	decreasing	A2-P1	Y	2	15	36
3677	RadFan1SrvAmpSpeed_3_path1_T_H_OP170A	5000	4500	{}	decreasing	A3-P1	YS	2	15	36
3679	RadFan1SrvAmpSpeed_5_path1_T_H_OP170A	5000	4500	{}	decreasing	A5-P1	BMG	2	15	36
3680	RadFan1SrvAmpSpeed_6_path1_T_H_OP170A	5000	4500	{}	decreasing	A6-P1	A2	2	15	36
3681	RadFan1SrvAmpSpeed_7_path1_T_H_OP170A	5000	4500	{}	decreasing	A7-P1	AT	2	15	36
3682	InFan2SpdlComPwSpeed_0_path1_T_H_OP170A	5000	4500	{}	decreasing	A0-P1	SAS	2	10	36
3683	InFan2SpindleAmpSpeed_0_path1_T_H_OP170A	5000	4500	{}	decreasing	A0-P1	SCS	2	10	36
3684	InFan2SrvComPwSpeed_0_path1_T_H_OP170A	5000	4500	{}	decreasing	A0-P1	X	2	12	36
3685	InFan2SrvComPwSpeed_1_path1_T_H_OP170A	5000	4500	{}	decreasing	A1-P1	X	2	12	36
3686	InFan2SrvComPwSpeed_2_path1_T_H_OP170A	5000	4500	{}	decreasing	A2-P1	Y	2	12	36
3687	InFan2SrvComPwSpeed_3_path1_T_H_OP170A	5000	4500	{}	decreasing	A3-P1	YS	2	12	36
3689	InFan2SrvComPwSpeed_5_path1_T_H_OP170A	5000	4500	{}	decreasing	A5-P1	BMG	2	12	36
3690	InFan2SrvComPwSpeed_6_path1_T_H_OP170A	5000	4500	{}	decreasing	A6-P1	A2	2	12	36
3691	InFan2SrvComPwSpeed_7_path1_T_H_OP170A	5000	4500	{}	decreasing	A7-P1	AT	2	12	36
3692	InFan1SpdlComPwSpeed_0_path1_T_H_OP170A	5000	4500	{}	decreasing	A0-P1	SAS	2	7	36
3693	InFan1SpindleAmpSpeed_0_path1_T_H_OP170A	6200	6000	{}	decreasing	A0-P1	SCS	2	7	36
3694	ServoTemp_0_path1_T_H_OP170A	55	70	{}	increasing	A0-P1	X	13	3	36
3695	ServoTemp_1_path1_T_H_OP170A	55	70	{}	increasing	A1-P1	Z	13	3	36
3696	ServoTemp_2_path1_T_H_OP170A	55	70	{}	increasing	A2-P1	Y	13	3	36
3697	ServoTemp_3_path1_T_H_OP170A	55	70	{}	increasing	A3-P1	YS	13	3	36
3699	ServoTemp_5_path1_T_H_OP170A	55	70	{}	increasing	A5-P1	BMG	13	3	36
3700	ServoTemp_6_path1_T_H_OP170A	55	70	{}	increasing	A6-P1	A2	13	3	36
3701	ServoTemp_7_path1_T_H_OP170A	55	70	{}	increasing	A7-P1	AT	13	3	36
3702	SpindleTemp_0_path1_T_H_OP170A	80	100	{}	increasing	SP-P1	SP	13	3	36
3703	PulseCoderTemp_0_path1_T_H_OP170B	60	80	{}	increasing	A0-P1	X	13	4	37
3704	PulseCoderTemp_1_path1_T_H_OP170B	60	80	{}	increasing	A1-P1	Z	13	4	37
3705	PulseCoderTemp_2_path1_T_H_OP170B	60	80	{}	increasing	A2-P1	Y	13	4	37
3706	PulseCoderTemp_3_path1_T_H_OP170B	60	80	{}	increasing	A3-P1	YS	13	4	37
3708	PulseCoderTemp_5_path1_T_H_OP170B	60	80	{}	increasing	A5-P1	BMG	13	4	37
3709	PulseCoderTemp_6_path1_T_H_OP170B	60	80	{}	increasing	A6-P1	A2	13	4	37
3710	PulseCoderTemp_7_path1_T_H_OP170B	60	80	{}	increasing	A7-P1	AT	13	4	37
3711	CncFan1Speed_path1_T_H_OP170B	4500	4000	{}	decreasing	A1-P1	F1	16	6	37
3712	CncFan2Speed_path1_T_H_OP170B	9600	8600	{}	decreasing	A2-P1	F3	16	6	37
3715	InFan1SrvAmpSpeed_0_path1_T_H_OP170B	9500	9000	{}	decreasing	A0-P1	X	2	8	37
3716	InFan1SrvAmpSpeed_1_path1_T_H_OP170B	9500	9000	{}	decreasing	A1-P1	Z	2	8	37
3717	InFan1SrvAmpSpeed_2_path1_T_H_OP170B	9500	9000	{}	decreasing	A2-P1	Y	2	8	37
3718	InFan1SrvAmpSpeed_3_path1_T_H_OP170B	9500	9000	{}	decreasing	A3-P1	YS	2	8	37
3720	InFan1SrvAmpSpeed_5_path1_T_H_OP170B	8500	7500	{}	decreasing	A5-P1	BMG	2	8	37
3721	InFan1SrvAmpSpeed_6_path1_T_H_OP170B	9500	9000	{}	decreasing	A6-P1	A2	2	8	37
3722	InFan1SrvAmpSpeed_7_path1_T_H_OP170B	8500	7500	{}	decreasing	A7-P1	AT	2	8	37
3723	ServoLoad_0_path1_T_H_OP170B	NaN	NaN	{}	increasing	A0-P1	X	17	17	37
3724	ServoLoad_1_path1_T_H_OP170B	NaN	NaN	{}	increasing	A1-P1	Z	17	17	37
3725	ServoLoad_2_path1_T_H_OP170B	NaN	NaN	{}	increasing	A2-P1	Y	17	17	37
3726	ServoLoad_3_path1_T_H_OP170B	NaN	NaN	{}	increasing	A3-P1	YS	17	17	37
3728	ServoLoad_5_path1_T_H_OP170B	NaN	NaN	{}	increasing	A5-P1	BMG	17	17	37
3729	ServoLoad_6_path1_T_H_OP170B	NaN	NaN	{}	increasing	A6-P1	A2	17	17	37
3730	ServoLoad_7_path1_T_H_OP170B	NaN	NaN	{}	increasing	A7-P1	AT	17	17	37
3731	SpindleLoad_0_path1_T_H_OP170B	NaN	NaN	{}	increasing	SP-P1	SP	17	17	37
3732	SpdBatZero_0_path1_T_H_OP170B	NaN	NaN	{}	bool	A0-P1	X	6	13	37
3733	SpdBatZero_1_path1_T_H_OP170B	NaN	NaN	{}	bool	A1-P1	Z	6	13	37
3734	SpdBatZero_2_path1_T_H_OP170B	NaN	NaN	{}	bool	A2-P1	Y	6	13	37
3735	SpdBatZero_3_path1_T_H_OP170B	NaN	NaN	{}	bool	A3-P1	YS	6	13	37
3737	SpdBatZero_5_path1_T_H_OP170B	NaN	NaN	{}	bool	A5-P1	BMG	6	13	37
3738	SpdBatZero_6_path1_T_H_OP170B	NaN	NaN	{}	bool	A6-P1	A2	6	13	37
3739	SpdBatZero_7_path1_T_H_OP170B	NaN	NaN	{}	bool	A7-P1	AT	6	13	37
3740	SSpdBatZero_0_path1_T_H_OP170B	NaN	NaN	{}	bool	A0-P1	X	6	14	37
3741	SSpdBatZero_1_path1_T_H_OP170B	NaN	NaN	{}	bool	A1-P1	Z	6	14	37
3742	SSpdBatZero_2_path1_T_H_OP170B	NaN	NaN	{}	bool	A2-P1	Y	6	14	37
3743	SSpdBatZero_3_path1_T_H_OP170B	NaN	NaN	{}	bool	A3-P1	YS	6	14	37
3745	SSpdBatZero_5_path1_T_H_OP170B	NaN	NaN	{}	bool	A5-P1	BMG	6	14	37
3746	SSpdBatZero_6_path1_T_H_OP170B	NaN	NaN	{}	bool	A6-P1	A2	6	14	37
3747	SSpdBatZero_7_path1_T_H_OP170B	NaN	NaN	{}	bool	A7-P1	AT	6	14	37
3748	RadFan2SpindleAmpSpeed_0_path1_T_H_OP170B	5000	4500	{}	decreasing	SP-P1	SP	2	16	37
3749	RadFan2SrvAmpSpeed_0_path1_T_H_OP170B	5000	4500	{}	decreasing	A0-P1	X	2	16	37
3750	RadFan2SrvAmpSpeed_1_path1_T_H_OP170B	5000	4500	{}	decreasing	A1-P1	Z	2	16	37
3751	RadFan2SrvAmpSpeed_2_path1_T_H_OP170B	5000	4500	{}	decreasing	A2-P1	Y	2	16	37
3752	RadFan2SrvAmpSpeed_3_path1_T_H_OP170B	5000	4500	{}	decreasing	A3-P1	YS	2	16	37
3754	RadFan2SrvAmpSpeed_5_path1_T_H_OP170B	5000	4500	{}	decreasing	A5-P1	BMG	2	16	37
3755	RadFan2SrvAmpSpeed_6_path1_T_H_OP170B	5000	4500	{}	decreasing	A6-P1	A2	2	16	37
3756	RadFan2SrvAmpSpeed_7_path1_T_H_OP170B	5000	4500	{}	decreasing	A7-P1	AT	2	16	37
3757	ApcBatLow_0_path1_T_H_OP170B	NaN	NaN	{}	bool	A0-P1	X	6	1	37
3758	ApcBatLow_1_path1_T_H_OP170B	NaN	NaN	{}	bool	A1-P1	Z	6	1	37
3759	ApcBatLow_2_path1_T_H_OP170B	NaN	NaN	{}	bool	A2-P1	Y	6	1	37
3760	ApcBatLow_3_path1_T_H_OP170B	NaN	NaN	{}	bool	A3-P1	YS	6	1	37
3762	ApcBatLow_5_path1_T_H_OP170B	NaN	NaN	{}	bool	A5-P1	BMG	6	1	37
3763	ApcBatLow_6_path1_T_H_OP170B	NaN	NaN	{}	bool	A6-P1	A2	6	1	37
3764	ApcBatLow_7_path1_T_H_OP170B	NaN	NaN	{}	bool	A7-P1	AT	6	1	37
3765	CncBatLow_0_path1_T_H_OP170B	NaN	NaN	{}	bool	A0-P1	X	6	2	37
3766	CncBatLow_1_path1_T_H_OP170B	NaN	NaN	{}	bool	A1-P1	Z	6	2	37
3767	CncBatLow_2_path1_T_H_OP170B	NaN	NaN	{}	bool	A2-P1	Y	6	2	37
3768	CncBatLow_3_path1_T_H_OP170B	NaN	NaN	{}	bool	A3-P1	YS	6	2	37
3770	CncBatLow_5_path1_T_H_OP170B	NaN	NaN	{}	bool	A5-P1	BMG	6	2	37
3771	CncBatLow_6_path1_T_H_OP170B	NaN	NaN	{}	bool	A6-P1	A2	6	2	37
3772	CncBatLow_7_path1_T_H_OP170B	NaN	NaN	{}	bool	A7-P1	AT	6	2	37
3773	ServoLeakResistData_0_path1_T_H_OP170B	50	30	{}	decreasing	A0-P1	X	15	5	37
3774	ServoLeakResistData_1_path1_T_H_OP170B	50	30	{}	decreasing	A1-P1	Z	15	5	37
3775	ServoLeakResistData_2_path1_T_H_OP170B	50	30	{}	decreasing	A2-P1	Y	15	5	37
3776	ServoLeakResistData_3_path1_T_H_OP170B	50	30	{}	decreasing	A3-P1	YS	15	5	37
3778	ServoLeakResistData_5_path1_T_H_OP170B	50	30	{}	decreasing	A5-P1	BMG	15	5	37
3779	ServoLeakResistData_6_path1_T_H_OP170B	50	30	{}	decreasing	A6-P1	A2	15	5	37
3780	ServoLeakResistData_7_path1_T_H_OP170B	50	30	{}	decreasing	A7-P1	AT	15	5	37
3781	SpindleLeakResistData_0_path1_T_H_OP170B	50	30	{}	decreasing	SP-P1	SP	15	5	37
3782	InFan1SrvComPwSpeed_0_path1_T_H_OP170B	6200	6000	{}	decreasing	A0-P1	X	2	9	37
3783	InFan1SrvComPwSpeed_1_path1_T_H_OP170B	6200	6000	{}	decreasing	A1-P1	Z	2	9	37
3784	InFan1SrvComPwSpeed_2_path1_T_H_OP170B	6200	6000	{}	decreasing	A2-P1	Y	2	9	37
3785	InFan1SrvComPwSpeed_3_path1_T_H_OP170B	6200	6000	{}	decreasing	A3-P1	YS	2	9	37
3787	InFan1SrvComPwSpeed_5_path1_T_H_OP170B	6200	6000	{}	decreasing	A5-P1	BMG	2	9	37
3788	InFan1SrvComPwSpeed_6_path1_T_H_OP170B	6200	6000	{}	decreasing	A6-P1	A2	2	9	37
3789	InFan1SrvComPwSpeed_7_path1_T_H_OP170B	6200	6000	{}	decreasing	A7-P1	AT	2	9	37
3790	InFan2SrvAmpSpeed_0_path1_T_H_OP170B	5000	4500	{}	decreasing	A0-P1	X	2	11	37
3791	InFan2SrvAmpSpeed_1_path1_T_H_OP170B	5000	4500	{}	decreasing	A1-P1	Z	2	11	37
3792	InFan2SrvAmpSpeed_2_path1_T_H_OP170B	5000	4500	{}	decreasing	A2-P1	Y	2	11	37
3793	InFan2SrvAmpSpeed_3_path1_T_H_OP170B	5000	4500	{}	decreasing	A3-P1	YS	2	11	37
3795	InFan2SrvAmpSpeed_5_path1_T_H_OP170B	5000	4500	{}	decreasing	A5-P1	BMG	2	11	37
3796	InFan2SrvAmpSpeed_6_path1_T_H_OP170B	5000	4500	{}	decreasing	A6-P1	A2	2	11	37
3797	InFan2SrvAmpSpeed_7_path1_T_H_OP170B	5000	4500	{}	decreasing	A7-P1	AT	2	11	37
3798	RadFan1SpindleAmpSpeed_0_path1_T_H_OP170B	5000	4500	{}	decreasing	SP-P1	SP	2	15	37
3799	RadFan1SrvAmpSpeed_0_path1_T_H_OP170B	5000	4500	{}	decreasing	A0-P1	X	2	15	37
3800	RadFan1SrvAmpSpeed_1_path1_T_H_OP170B	5000	4500	{}	decreasing	A1-P1	Z	2	15	37
3801	RadFan1SrvAmpSpeed_2_path1_T_H_OP170B	5000	4500	{}	decreasing	A2-P1	Y	2	15	37
3802	RadFan1SrvAmpSpeed_3_path1_T_H_OP170B	5000	4500	{}	decreasing	A3-P1	YS	2	15	37
3804	RadFan1SrvAmpSpeed_5_path1_T_H_OP170B	5000	4500	{}	decreasing	A5-P1	BMG	2	15	37
3805	RadFan1SrvAmpSpeed_6_path1_T_H_OP170B	5000	4500	{}	decreasing	A6-P1	A2	2	15	37
3806	RadFan1SrvAmpSpeed_7_path1_T_H_OP170B	5000	4500	{}	decreasing	A7-P1	AT	2	15	37
3807	InFan2SpdlComPwSpeed_0_path1_T_H_OP170B	5000	4500	{}	decreasing	A0-P1	SAS	2	10	37
3808	InFan2SpindleAmpSpeed_0_path1_T_H_OP170B	5000	4500	{}	decreasing	A0-P1	SCS	2	10	37
3809	InFan2SrvComPwSpeed_0_path1_T_H_OP170B	5000	4500	{}	decreasing	A0-P1	X	2	12	37
3810	InFan2SrvComPwSpeed_1_path1_T_H_OP170B	5000	4500	{}	decreasing	A1-P1	Z	2	12	37
3811	InFan2SrvComPwSpeed_2_path1_T_H_OP170B	5000	4500	{}	decreasing	A2-P1	Y	2	12	37
3812	InFan2SrvComPwSpeed_3_path1_T_H_OP170B	5000	4500	{}	decreasing	A3-P1	YS	2	12	37
3814	InFan2SrvComPwSpeed_5_path1_T_H_OP170B	5000	4500	{}	decreasing	A5-P1	BMG	2	12	37
3815	InFan2SrvComPwSpeed_6_path1_T_H_OP170B	5000	4500	{}	decreasing	A6-P1	A2	2	12	37
3887	ApcBatLow_5_path1_T_H_OP180A	NaN	NaN	{}	bool	A5-P1	BMG	6	1	38
3816	InFan2SrvComPwSpeed_7_path1_T_H_OP170B	5000	4500	{}	decreasing	A7-P1	AT	2	12	37
3817	InFan1SpdlComPwSpeed_0_path1_T_H_OP170B	5000	4500	{}	decreasing	A0-P1	SAS	2	7	37
3818	InFan1SpindleAmpSpeed_0_path1_T_H_OP170B	6200	6000	{}	decreasing	A0-P1	SCS	2	7	37
3819	ServoTemp_0_path1_T_H_OP170B	55	70	{}	increasing	A0-P1	X	13	3	37
3820	ServoTemp_1_path1_T_H_OP170B	55	70	{}	increasing	A1-P1	Z	13	3	37
3821	ServoTemp_2_path1_T_H_OP170B	55	70	{}	increasing	A2-P1	Y	13	3	37
3822	ServoTemp_3_path1_T_H_OP170B	55	70	{}	increasing	A3-P1	YS	13	3	37
3824	ServoTemp_5_path1_T_H_OP170B	55	70	{}	increasing	A5-P1	BMG	13	3	37
3825	ServoTemp_6_path1_T_H_OP170B	55	70	{}	increasing	A6-P1	A2	13	3	37
3826	ServoTemp_7_path1_T_H_OP170B	55	70	{}	increasing	A7-P1	AT	13	3	37
3827	SpindleTemp_0_path1_T_H_OP170B	80	100	{}	increasing	SP-P1	P1	13	3	37
3828	PulseCoderTemp_0_path1_T_H_OP180A	60	80	{}	increasing	A0-P1	X	13	4	38
3829	PulseCoderTemp_1_path1_T_H_OP180A	60	80	{}	increasing	A1-P1	Z	13	4	38
3830	PulseCoderTemp_2_path1_T_H_OP180A	60	80	{}	increasing	A2-P1	Y	13	4	38
3831	PulseCoderTemp_3_path1_T_H_OP180A	60	80	{}	increasing	A3-P1	YS	13	4	38
3833	PulseCoderTemp_5_path1_T_H_OP180A	60	80	{}	increasing	A5-P1	BMG	13	4	38
3834	PulseCoderTemp_6_path1_T_H_OP180A	60	80	{}	increasing	A6-P1	A2	13	4	38
3835	PulseCoderTemp_7_path1_T_H_OP180A	60	80	{}	increasing	A7-P1	AT	13	4	38
3836	CncFan1Speed_path1_T_H_OP180A	4500	4000	{}	decreasing	A1-P1	F1	16	6	38
3837	CncFan2Speed_path1_T_H_OP180A	9600	8600	{}	decreasing	A2-P1	F3	16	6	38
3840	InFan1SrvAmpSpeed_0_path1_T_H_OP180A	9500	0	{}	decreasing	A0-P1	X	2	8	38
3841	InFan1SrvAmpSpeed_1_path1_T_H_OP180A	9500	9000	{}	decreasing	A1-P1	Z	2	8	38
3842	InFan1SrvAmpSpeed_2_path1_T_H_OP180A	9500	9000	{}	decreasing	A2-P1	Y	2	8	38
3843	InFan1SrvAmpSpeed_3_path1_T_H_OP180A	9500	9000	{}	decreasing	A3-P1	YS	2	8	38
3845	InFan1SrvAmpSpeed_5_path1_T_H_OP180A	8500	7500	{}	decreasing	A5-P1	BMG	2	8	38
3846	InFan1SrvAmpSpeed_6_path1_T_H_OP180A	9500	9000	{}	decreasing	A6-P1	A2	2	8	38
3847	InFan1SrvAmpSpeed_7_path1_T_H_OP180A	8500	7500	{}	decreasing	A7-P1	AT	2	8	38
3848	ServoLoad_0_path1_T_H_OP180A	NaN	NaN	{}	increasing	A0-P1	X	17	17	38
3849	ServoLoad_1_path1_T_H_OP180A	NaN	NaN	{}	increasing	A1-P1	Z	17	17	38
3850	ServoLoad_2_path1_T_H_OP180A	NaN	NaN	{}	increasing	A2-P1	Y	17	17	38
3851	ServoLoad_3_path1_T_H_OP180A	NaN	NaN	{}	increasing	A3-P1	YS	17	17	38
3853	ServoLoad_5_path1_T_H_OP180A	NaN	NaN	{}	increasing	A5-P1	BMG	17	17	38
3854	ServoLoad_6_path1_T_H_OP180A	NaN	NaN	{}	increasing	A6-P1	A2	17	17	38
3855	ServoLoad_7_path1_T_H_OP180A	NaN	NaN	{}	increasing	A7-P1	AT	17	17	38
3856	SpindleLoad_0_path1_T_H_OP180A	NaN	NaN	{}	increasing	SP-P1	SP	17	17	38
3857	SpdBatZero_0_path1_T_H_OP180A	NaN	NaN	{}	bool	A0-P1	X	6	13	38
3858	SpdBatZero_1_path1_T_H_OP180A	NaN	NaN	{}	bool	A1-P1	Z	6	13	38
3859	SpdBatZero_2_path1_T_H_OP180A	NaN	NaN	{}	bool	A2-P1	Y	6	13	38
3860	SpdBatZero_3_path1_T_H_OP180A	NaN	NaN	{}	bool	A3-P1	YS	6	13	38
3862	SpdBatZero_5_path1_T_H_OP180A	NaN	NaN	{}	bool	A5-P1	BMG	6	13	38
3863	SpdBatZero_6_path1_T_H_OP180A	NaN	NaN	{}	bool	A6-P1	A2	6	13	38
3864	SpdBatZero_7_path1_T_H_OP180A	NaN	NaN	{}	bool	A7-P1	AT	6	13	38
3865	SSpdBatZero_0_path1_T_H_OP180A	NaN	NaN	{}	bool	A0-P1	X	6	14	38
3866	SSpdBatZero_1_path1_T_H_OP180A	NaN	NaN	{}	bool	A1-P1	Z	6	14	38
3867	SSpdBatZero_2_path1_T_H_OP180A	NaN	NaN	{}	bool	A2-P1	Y	6	14	38
3868	SSpdBatZero_3_path1_T_H_OP180A	NaN	NaN	{}	bool	A3-P1	YS	6	14	38
3870	SSpdBatZero_5_path1_T_H_OP180A	NaN	NaN	{}	bool	A5-P1	BMG	6	14	38
3871	SSpdBatZero_6_path1_T_H_OP180A	NaN	NaN	{}	bool	A6-P1	A2	6	14	38
3872	SSpdBatZero_7_path1_T_H_OP180A	NaN	NaN	{}	bool	A7-P1	AT	6	14	38
3873	RadFan2SpindleAmpSpeed_0_path1_T_H_OP180A	5000	4500	{}	decreasing	SP-P1	SP	2	16	38
3874	RadFan2SrvAmpSpeed_0_path1_T_H_OP180A	5000	4500	{}	decreasing	A0-P1	X	2	16	38
3875	RadFan2SrvAmpSpeed_1_path1_T_H_OP180A	5000	4500	{}	decreasing	A1-P1	Z	2	16	38
3876	RadFan2SrvAmpSpeed_2_path1_T_H_OP180A	5000	4500	{}	decreasing	A2-P1	Y	2	16	38
3877	RadFan2SrvAmpSpeed_3_path1_T_H_OP180A	5000	4500	{}	decreasing	A3-P1	YS	2	16	38
3879	RadFan2SrvAmpSpeed_5_path1_T_H_OP180A	5000	4500	{}	decreasing	A5-P1	BMG	2	16	38
3880	RadFan2SrvAmpSpeed_6_path1_T_H_OP180A	5000	4500	{}	decreasing	A6-P1	A2	2	16	38
3881	RadFan2SrvAmpSpeed_7_path1_T_H_OP180A	5000	4500	{}	decreasing	A7-P1	AT	2	16	38
3882	ApcBatLow_0_path1_T_H_OP180A	NaN	NaN	{}	bool	A0-P1	X	6	1	38
3883	ApcBatLow_1_path1_T_H_OP180A	NaN	NaN	{}	bool	A1-P1	Z	6	1	38
3884	ApcBatLow_2_path1_T_H_OP180A	NaN	NaN	{}	bool	A2-P1	Y	6	1	38
3885	ApcBatLow_3_path1_T_H_OP180A	NaN	NaN	{}	bool	A3-P1	YS	6	1	38
6273	laser_line_t5_data_table	\N	\N	{}	\N	\N	\N	3	\N	64
3888	ApcBatLow_6_path1_T_H_OP180A	NaN	NaN	{}	bool	A6-P1	A2	6	1	38
3889	ApcBatLow_7_path1_T_H_OP180A	NaN	NaN	{}	bool	A7-P1	AT	6	1	38
3890	CncBatLow_0_path1_T_H_OP180A	NaN	NaN	{}	bool	A0-P1	X	6	2	38
3891	CncBatLow_1_path1_T_H_OP180A	NaN	NaN	{}	bool	A1-P1	Z	6	2	38
3892	CncBatLow_2_path1_T_H_OP180A	NaN	NaN	{}	bool	A2-P1	Y	6	2	38
3893	CncBatLow_3_path1_T_H_OP180A	NaN	NaN	{}	bool	A3-P1	YS	6	2	38
3895	CncBatLow_5_path1_T_H_OP180A	NaN	NaN	{}	bool	A5-P1	BMG	6	2	38
3896	CncBatLow_6_path1_T_H_OP180A	NaN	NaN	{}	bool	A6-P1	A2	6	2	38
3897	CncBatLow_7_path1_T_H_OP180A	NaN	NaN	{}	bool	A7-P1	AT	6	2	38
3898	ServoLeakResistData_0_path1_T_H_OP180A	50	30	{}	decreasing	A0-P1	X	15	5	38
3899	ServoLeakResistData_1_path1_T_H_OP180A	50	30	{}	decreasing	A1-P1	Z	15	5	38
3900	ServoLeakResistData_2_path1_T_H_OP180A	50	30	{}	decreasing	A2-P1	Y	15	5	38
3901	ServoLeakResistData_3_path1_T_H_OP180A	50	30	{}	decreasing	A3-P1	YS	15	5	38
3903	ServoLeakResistData_5_path1_T_H_OP180A	50	30	{}	decreasing	A5-P1	BMG	15	5	38
3904	ServoLeakResistData_6_path1_T_H_OP180A	50	30	{}	decreasing	A6-P1	A2	15	5	38
3905	ServoLeakResistData_7_path1_T_H_OP180A	50	30	{}	decreasing	A7-P1	AT	15	5	38
3906	SpindleLeakResistData_0_path1_T_H_OP180A	50	30	{}	decreasing	SP-P1	SP	15	5	38
3907	InFan1SrvComPwSpeed_0_path1_T_H_OP180A	6200	6000	{}	decreasing	A0-P1	X	2	9	38
3908	InFan1SrvComPwSpeed_1_path1_T_H_OP180A	6200	6000	{}	decreasing	A1-P1	Z	2	9	38
3909	InFan1SrvComPwSpeed_2_path1_T_H_OP180A	6200	6000	{}	decreasing	A2-P1	Y	2	9	38
3910	InFan1SrvComPwSpeed_3_path1_T_H_OP180A	6200	6000	{}	decreasing	A3-P1	YS	2	9	38
3912	InFan1SrvComPwSpeed_5_path1_T_H_OP180A	6200	6000	{}	decreasing	A5-P1	BMG	2	9	38
3913	InFan1SrvComPwSpeed_6_path1_T_H_OP180A	6200	6000	{}	decreasing	A6-P1	A2	2	9	38
3914	InFan1SrvComPwSpeed_7_path1_T_H_OP180A	6200	6000	{}	decreasing	A7-P1	AT	2	9	38
3915	InFan2SrvAmpSpeed_0_path1_T_H_OP180A	5000	4500	{}	decreasing	A0-P1	X	2	11	38
3916	InFan2SrvAmpSpeed_1_path1_T_H_OP180A	5000	4500	{}	decreasing	A1-P1	Z	2	11	38
3917	InFan2SrvAmpSpeed_2_path1_T_H_OP180A	5000	4500	{}	decreasing	A2-P1	Y	2	11	38
3918	InFan2SrvAmpSpeed_3_path1_T_H_OP180A	5000	4500	{}	decreasing	A3-P1	YS	2	11	38
3920	InFan2SrvAmpSpeed_5_path1_T_H_OP180A	5000	4500	{}	decreasing	A5-P1	BMG	2	11	38
3921	InFan2SrvAmpSpeed_6_path1_T_H_OP180A	5000	4500	{}	decreasing	A6-P1	A2	2	11	38
3922	InFan2SrvAmpSpeed_7_path1_T_H_OP180A	5000	4500	{}	decreasing	A7-P1	AT	2	11	38
3923	RadFan1SpindleAmpSpeed_0_path1_T_H_OP180A	5000	4500	{}	decreasing	SP-P1	SP	2	15	38
3924	RadFan1SrvAmpSpeed_0_path1_T_H_OP180A	5000	4500	{}	decreasing	A0-P1	X	2	15	38
3925	RadFan1SrvAmpSpeed_1_path1_T_H_OP180A	5000	4500	{}	decreasing	A1-P1	Z	2	15	38
3926	RadFan1SrvAmpSpeed_2_path1_T_H_OP180A	5000	4500	{}	decreasing	A2-P1	Y	2	15	38
3927	RadFan1SrvAmpSpeed_3_path1_T_H_OP180A	5000	4500	{}	decreasing	A3-P1	YS	2	15	38
3929	RadFan1SrvAmpSpeed_5_path1_T_H_OP180A	5000	4500	{}	decreasing	A5-P1	BMG	2	15	38
3930	RadFan1SrvAmpSpeed_6_path1_T_H_OP180A	5000	4500	{}	decreasing	A6-P1	A2	2	15	38
3931	RadFan1SrvAmpSpeed_7_path1_T_H_OP180A	5000	4500	{}	decreasing	A7-P1	AT	2	15	38
3932	InFan2SpdlComPwSpeed_0_path1_T_H_OP180A	5000	4500	{}	decreasing	A0-P1	SAS	2	10	38
3933	InFan2SpindleAmpSpeed_0_path1_T_H_OP180A	5000	4500	{}	decreasing	A0-P1	SCS	2	10	38
3934	InFan2SrvComPwSpeed_0_path1_T_H_OP180A	5000	4500	{}	decreasing	A0-P1	X	2	12	38
3935	InFan2SrvComPwSpeed_1_path1_T_H_OP180A	5000	4500	{}	decreasing	A1-P1	Z	2	12	38
3936	InFan2SrvComPwSpeed_2_path1_T_H_OP180A	5000	4500	{}	decreasing	A2-P1	Y	2	12	38
3937	InFan2SrvComPwSpeed_3_path1_T_H_OP180A	5000	4500	{}	decreasing	A3-P1	YS	2	12	38
3939	InFan2SrvComPwSpeed_5_path1_T_H_OP180A	5000	4500	{}	decreasing	A5-P1	BMG	2	12	38
3940	InFan2SrvComPwSpeed_6_path1_T_H_OP180A	5000	4500	{}	decreasing	A6-P1	A2	2	12	38
3941	InFan2SrvComPwSpeed_7_path1_T_H_OP180A	5000	4500	{}	decreasing	A7-P1	AT	2	12	38
3942	InFan1SpdlComPwSpeed_0_path1_T_H_OP180A	5000	4500	{}	decreasing	A0-P1	SAS	2	7	38
3943	InFan1SpindleAmpSpeed_0_path1_T_H_OP180A	6200	6000	{}	decreasing	A0-P1	SCS	2	7	38
3944	ServoTemp_0_path1_T_H_OP180A	55	70	{}	increasing	A0-P1	X	13	3	38
3945	ServoTemp_1_path1_T_H_OP180A	55	70	{}	increasing	A1-P1	Z	13	3	38
3946	ServoTemp_2_path1_T_H_OP180A	55	70	{}	increasing	A2-P1	Y	13	3	38
3947	ServoTemp_3_path1_T_H_OP180A	55	70	{}	increasing	A3-P1	YS	13	3	38
3949	ServoTemp_5_path1_T_H_OP180A	55	70	{}	increasing	A5-P1	BMG	13	3	38
3950	ServoTemp_6_path1_T_H_OP180A	55	70	{}	increasing	A6-P1	A2	13	3	38
3951	ServoTemp_7_path1_T_H_OP180A	55	70	{}	increasing	A7-P1	AT	13	3	38
3952	SpindleTemp_0_path1_T_H_OP180A	80	100	{}	increasing	SP-P1	SP	13	3	38
3953	PulseCoderTemp_0_path1_T_H_OP180B	60	80	{}	increasing	A0-P1	X	13	4	39
6274	laser_line_t6_data_table	\N	\N	{}	\N	\N	\N	3	\N	64
3954	PulseCoderTemp_1_path1_T_H_OP180B	60	80	{}	increasing	A1-P1	Z	13	4	39
3955	PulseCoderTemp_2_path1_T_H_OP180B	60	80	{}	increasing	A2-P1	Y	13	4	39
3956	PulseCoderTemp_3_path1_T_H_OP180B	60	80	{}	increasing	A3-P1	YS	13	4	39
3958	PulseCoderTemp_5_path1_T_H_OP180B	60	80	{}	increasing	A5-P1	BMG	13	4	39
3959	PulseCoderTemp_6_path1_T_H_OP180B	60	80	{}	increasing	A6-P1	A2	13	4	39
3960	PulseCoderTemp_7_path1_T_H_OP180B	60	80	{}	increasing	A7-P1	AT	13	4	39
3961	CncFan1Speed_path1_T_H_OP180B	4500	4000	{}	decreasing	A1-P1	F1	16	6	39
3962	CncFan2Speed_path1_T_H_OP180B	9600	8600	{}	decreasing	A2-P1	F2	16	6	39
3965	InFan1SrvAmpSpeed_0_path1_T_H_OP180B	9500	9000	{}	decreasing	A0-P1	X	2	8	39
3966	InFan1SrvAmpSpeed_1_path1_T_H_OP180B	9500	9000	{}	decreasing	A1-P1	Z	2	8	39
3967	InFan1SrvAmpSpeed_2_path1_T_H_OP180B	9500	9000	{}	decreasing	A2-P1	Y	2	8	39
3968	InFan1SrvAmpSpeed_3_path1_T_H_OP180B	9500	9000	{}	decreasing	A3-P1	YS	2	8	39
3970	InFan1SrvAmpSpeed_5_path1_T_H_OP180B	8500	7500	{}	decreasing	A5-P1	BMG	2	8	39
3971	InFan1SrvAmpSpeed_6_path1_T_H_OP180B	9500	9000	{}	decreasing	A6-P1	A2	2	8	39
3972	InFan1SrvAmpSpeed_7_path1_T_H_OP180B	8500	7500	{}	decreasing	A7-P1	AT	2	8	39
3973	ServoLoad_0_path1_T_H_OP180B	NaN	NaN	{}	increasing	A0-P1	X	17	17	39
3974	ServoLoad_1_path1_T_H_OP180B	NaN	NaN	{}	increasing	A1-P1	Z	17	17	39
3975	ServoLoad_2_path1_T_H_OP180B	NaN	NaN	{}	increasing	A2-P1	Y	17	17	39
3976	ServoLoad_3_path1_T_H_OP180B	NaN	NaN	{}	increasing	A3-P1	YS	17	17	39
3978	ServoLoad_5_path1_T_H_OP180B	NaN	NaN	{}	increasing	A5-P1	BMG	17	17	39
3979	ServoLoad_6_path1_T_H_OP180B	NaN	NaN	{}	increasing	A6-P1	A2	17	17	39
3980	ServoLoad_7_path1_T_H_OP180B	NaN	NaN	{}	increasing	A7-P1	AT	17	17	39
3981	SpindleLoad_0_path1_T_H_OP180B	NaN	NaN	{}	increasing	SP-P1	SP	17	17	39
3982	SpdBatZero_0_path1_T_H_OP180B	NaN	NaN	{}	bool	A0-P1	X	6	13	39
3983	SpdBatZero_1_path1_T_H_OP180B	NaN	NaN	{}	bool	A1-P1	Z	6	13	39
3984	SpdBatZero_2_path1_T_H_OP180B	NaN	NaN	{}	bool	A2-P1	Y	6	13	39
3985	SpdBatZero_3_path1_T_H_OP180B	NaN	NaN	{}	bool	A3-P1	YS	6	13	39
3987	SpdBatZero_5_path1_T_H_OP180B	NaN	NaN	{}	bool	A5-P1	BMG	6	13	39
3988	SpdBatZero_6_path1_T_H_OP180B	NaN	NaN	{}	bool	A6-P1	A2	6	13	39
3989	SpdBatZero_7_path1_T_H_OP180B	NaN	NaN	{}	bool	A7-P1	AT	6	13	39
3990	SSpdBatZero_0_path1_T_H_OP180B	NaN	NaN	{}	bool	A0-P1	X	6	14	39
3991	SSpdBatZero_1_path1_T_H_OP180B	NaN	NaN	{}	bool	A1-P1	Z	6	14	39
3992	SSpdBatZero_2_path1_T_H_OP180B	NaN	NaN	{}	bool	A2-P1	Y	6	14	39
3993	SSpdBatZero_3_path1_T_H_OP180B	NaN	NaN	{}	bool	A3-P1	YS	6	14	39
3995	SSpdBatZero_5_path1_T_H_OP180B	NaN	NaN	{}	bool	A5-P1	BMG	6	14	39
3996	SSpdBatZero_6_path1_T_H_OP180B	NaN	NaN	{}	bool	A6-P1	A2	6	14	39
3997	SSpdBatZero_7_path1_T_H_OP180B	NaN	NaN	{}	bool	A7-P1	AT	6	14	39
3998	RadFan2SpindleAmpSpeed_0_path1_T_H_OP180B	5000	4500	{}	decreasing	SP-P1	SP	2	16	39
3999	RadFan2SrvAmpSpeed_0_path1_T_H_OP180B	5000	4500	{}	decreasing	A0-P1	X	2	16	39
4000	RadFan2SrvAmpSpeed_1_path1_T_H_OP180B	5000	4500	{}	decreasing	A1-P1	Z	2	16	39
4001	RadFan2SrvAmpSpeed_2_path1_T_H_OP180B	5000	4500	{}	decreasing	A2-P1	Y	2	16	39
4002	RadFan2SrvAmpSpeed_3_path1_T_H_OP180B	5000	4500	{}	decreasing	A3-P1	YS	2	16	39
4004	RadFan2SrvAmpSpeed_5_path1_T_H_OP180B	5000	4500	{}	decreasing	A5-P1	BMG	2	16	39
4005	RadFan2SrvAmpSpeed_6_path1_T_H_OP180B	5000	4500	{}	decreasing	A6-P1	A2	2	16	39
4006	RadFan2SrvAmpSpeed_7_path1_T_H_OP180B	5000	4500	{}	decreasing	A7-P1	AT	2	16	39
4007	ApcBatLow_0_path1_T_H_OP180B	NaN	NaN	{}	bool	A0-P1	X	6	1	39
4008	ApcBatLow_1_path1_T_H_OP180B	NaN	NaN	{}	bool	A1-P1	Z	6	1	39
4009	ApcBatLow_2_path1_T_H_OP180B	NaN	NaN	{}	bool	A2-P1	Y	6	1	39
4010	ApcBatLow_3_path1_T_H_OP180B	NaN	NaN	{}	bool	A3-P1	YS	6	1	39
4012	ApcBatLow_5_path1_T_H_OP180B	NaN	NaN	{}	bool	A5-P1	BMG	6	1	39
4013	ApcBatLow_6_path1_T_H_OP180B	NaN	NaN	{}	bool	A6-P1	A2	6	1	39
4014	ApcBatLow_7_path1_T_H_OP180B	NaN	NaN	{}	bool	A7-P1	AT	6	1	39
4015	CncBatLow_0_path1_T_H_OP180B	NaN	NaN	{}	bool	A0-P1	X	6	2	39
4016	CncBatLow_1_path1_T_H_OP180B	NaN	NaN	{}	bool	A1-P1	Z	6	2	39
4017	CncBatLow_2_path1_T_H_OP180B	NaN	NaN	{}	bool	A2-P1	Y	6	2	39
4018	CncBatLow_3_path1_T_H_OP180B	NaN	NaN	{}	bool	A3-P1	YS	6	2	39
4020	CncBatLow_5_path1_T_H_OP180B	NaN	NaN	{}	bool	A5-P1	BMG	6	2	39
4021	CncBatLow_6_path1_T_H_OP180B	NaN	NaN	{}	bool	A6-P1	A2	6	2	39
4022	CncBatLow_7_path1_T_H_OP180B	NaN	NaN	{}	bool	A7-P1	AT	6	2	39
4023	ServoLeakResistData_0_path1_T_H_OP180B	50	30	{}	decreasing	A0-P1	X	15	5	39
4024	ServoLeakResistData_1_path1_T_H_OP180B	50	30	{}	decreasing	A1-P1	Z	15	5	39
4025	ServoLeakResistData_2_path1_T_H_OP180B	50	30	{}	decreasing	A2-P1	Y	15	5	39
4026	ServoLeakResistData_3_path1_T_H_OP180B	50	30	{}	decreasing	A3-P1	YS	15	5	39
4028	ServoLeakResistData_5_path1_T_H_OP180B	50	30	{}	decreasing	A5-P1	BMG	15	5	39
4029	ServoLeakResistData_6_path1_T_H_OP180B	50	30	{}	decreasing	A6-P1	A2	15	5	39
4030	ServoLeakResistData_7_path1_T_H_OP180B	50	30	{}	decreasing	A7-P1	AT	15	5	39
4031	SpindleLeakResistData_0_path1_T_H_OP180B	50	30	{}	decreasing	SP-P1	SP	15	5	39
4032	InFan1SrvComPwSpeed_0_path1_T_H_OP180B	6200	6000	{}	decreasing	A0-P1	X	2	9	39
4033	InFan1SrvComPwSpeed_1_path1_T_H_OP180B	6200	6000	{}	decreasing	A1-P1	Z	2	9	39
4034	InFan1SrvComPwSpeed_2_path1_T_H_OP180B	6200	6000	{}	decreasing	A2-P1	Y	2	9	39
4035	InFan1SrvComPwSpeed_3_path1_T_H_OP180B	6200	6000	{}	decreasing	A3-P1	YS	2	9	39
4037	InFan1SrvComPwSpeed_5_path1_T_H_OP180B	6200	6000	{}	decreasing	A5-P1	BMG	2	9	39
4038	InFan1SrvComPwSpeed_6_path1_T_H_OP180B	6200	6000	{}	decreasing	A6-P1	A2	2	9	39
4039	InFan1SrvComPwSpeed_7_path1_T_H_OP180B	6200	6000	{}	decreasing	A7-P1	AT	2	9	39
4040	InFan2SrvAmpSpeed_0_path1_T_H_OP180B	5000	4500	{}	decreasing	A0-P1	X	2	11	39
4041	InFan2SrvAmpSpeed_1_path1_T_H_OP180B	5000	4500	{}	decreasing	A1-P1	Z	2	11	39
4042	InFan2SrvAmpSpeed_2_path1_T_H_OP180B	5000	4500	{}	decreasing	A2-P1	Y	2	11	39
4043	InFan2SrvAmpSpeed_3_path1_T_H_OP180B	5000	4500	{}	decreasing	A3-P1	YS	2	11	39
4045	InFan2SrvAmpSpeed_5_path1_T_H_OP180B	5000	4500	{}	decreasing	A5-P1	BMG	2	11	39
4046	InFan2SrvAmpSpeed_6_path1_T_H_OP180B	5000	4500	{}	decreasing	A6-P1	A2	2	11	39
4047	InFan2SrvAmpSpeed_7_path1_T_H_OP180B	5000	4500	{}	decreasing	A7-P1	AT	2	11	39
4048	RadFan1SpindleAmpSpeed_0_path1_T_H_OP180B	5000	4500	{}	decreasing	SP-P1	SP	2	15	39
4049	RadFan1SrvAmpSpeed_0_path1_T_H_OP180B	5000	4500	{}	decreasing	A0-P1	X	2	15	39
4050	RadFan1SrvAmpSpeed_1_path1_T_H_OP180B	5000	4500	{}	decreasing	A1-P1	Z	2	15	39
4051	RadFan1SrvAmpSpeed_2_path1_T_H_OP180B	5000	4500	{}	decreasing	A2-P1	Y	2	15	39
4052	RadFan1SrvAmpSpeed_3_path1_T_H_OP180B	5000	4500	{}	decreasing	A3-P1	YS	2	15	39
4054	RadFan1SrvAmpSpeed_5_path1_T_H_OP180B	5000	4500	{}	decreasing	A5-P1	BMG	2	15	39
4055	RadFan1SrvAmpSpeed_6_path1_T_H_OP180B	5000	4500	{}	decreasing	A6-P1	A2	2	15	39
4056	RadFan1SrvAmpSpeed_7_path1_T_H_OP180B	5000	4500	{}	decreasing	A7-P1	AT	2	15	39
4057	InFan2SpdlComPwSpeed_0_path1_T_H_OP180B	5000	4500	{}	decreasing	A0-P1	SAS	2	10	39
4058	InFan2SpindleAmpSpeed_0_path1_T_H_OP180B	5000	4500	{}	decreasing	A0-P1	SCS	2	10	39
4059	InFan2SrvComPwSpeed_0_path1_T_H_OP180B	5000	4500	{}	decreasing	A0-P1	X	2	12	39
4060	InFan2SrvComPwSpeed_1_path1_T_H_OP180B	5000	4500	{}	decreasing	A1-P1	Z	2	12	39
4061	InFan2SrvComPwSpeed_2_path1_T_H_OP180B	5000	4500	{}	decreasing	A2-P1	Y	2	12	39
4062	InFan2SrvComPwSpeed_3_path1_T_H_OP180B	5000	4500	{}	decreasing	A3-P1	YS	2	12	39
4064	InFan2SrvComPwSpeed_5_path1_T_H_OP180B	5000	4500	{}	decreasing	A5-P1	BMG	2	12	39
4065	InFan2SrvComPwSpeed_6_path1_T_H_OP180B	5000	4500	{}	decreasing	A6-P1	A2	2	12	39
4066	InFan2SrvComPwSpeed_7_path1_T_H_OP180B	5000	4500	{}	decreasing	A7-P1	AT	2	12	39
4067	InFan1SpdlComPwSpeed_0_path1_T_H_OP180B	5000	4500	{}	decreasing	A0-P1	SAS	2	7	39
4068	InFan1SpindleAmpSpeed_0_path1_T_H_OP180B	6200	6000	{}	decreasing	A0-P1	SCS	2	7	39
4069	ServoTemp_0_path1_T_H_OP180B	55	70	{}	increasing	A0-P1	X	13	3	39
4070	ServoTemp_1_path1_T_H_OP180B	55	70	{}	increasing	A1-P1	Z	13	3	39
4071	ServoTemp_2_path1_T_H_OP180B	55	70	{}	increasing	A2-P1	Y	13	3	39
4072	ServoTemp_3_path1_T_H_OP180B	55	70	{}	increasing	A3-P1	YS	13	3	39
4074	ServoTemp_5_path1_T_H_OP180B	55	70	{}	increasing	A5-P1	BMG	13	3	39
4075	ServoTemp_6_path1_T_H_OP180B	55	70	{}	increasing	A6-P1	A2	13	3	39
4076	ServoTemp_7_path1_T_H_OP180B	55	70	{}	increasing	A7-P1	AT	13	3	39
4077	SpindleTemp_0_path1_T_H_OP180B	80	100	{}	increasing	SP-P1	SP	13	3	39
4078	PulseCoderTemp_0_path1_T_H_OP20	60	80	{}	increasing	A0-P1	X	13	4	40
4079	PulseCoderTemp_1_path1_T_H_OP20	60	80	{}	increasing	A1-P1	Z	13	4	40
4080	PulseCoderTemp_2_path1_T_H_OP20	60	80	{}	increasing	A2-P1	Y	13	4	40
4081	PulseCoderTemp_3_path1_T_H_OP20	70	80	{}	increasing	A3-P1	YS	13	4	40
4083	PulseCoderTemp_5_path1_T_H_OP20	60	80	{}	increasing	A5-P1	BMG	13	4	40
4084	PulseCoderTemp_6_path1_T_H_OP20	60	80	{}	increasing	A6-P1	A2	13	4	40
4085	PulseCoderTemp_7_path1_T_H_OP20	60	80	{}	increasing	A7-P1	AT	13	4	40
4086	CncFan1Speed_path1_T_H_OP20	4500	4000	{}	decreasing	A1-P1	F1	16	6	40
4087	CncFan2Speed_path1_T_H_OP20	9600	8600	{}	decreasing	A2-P1	F2	16	6	40
4088	CncFan3Speed_path1_T_H_OP20	5000	4500	{}	decreasing	A3-P1	F3	16	6	40
4089	CncFan4Speed_path1_T_H_OP20	5000	4500	{}	decreasing	A4-P1	F4	16	6	40
4090	InFan1SrvAmpSpeed_0_path1_T_H_OP20	9500	9000	{}	decreasing	A0-P1	X	2	8	40
4091	InFan1SrvAmpSpeed_1_path1_T_H_OP20	9500	9000	{}	decreasing	A1-P1	Z	2	8	40
6275	laser_line_v0_data_table	\N	\N	{}	\N	\N	\N	2	\N	64
4092	InFan1SrvAmpSpeed_2_path1_T_H_OP20	9500	9000	{}	decreasing	A2-P1	Y	2	8	40
4093	InFan1SrvAmpSpeed_3_path1_T_H_OP20	9500	9000	{}	decreasing	A3-P1	YS	2	8	40
4095	InFan1SrvAmpSpeed_5_path1_T_H_OP20	8500	7500	{}	decreasing	A5-P1	BMG	2	8	40
4096	InFan1SrvAmpSpeed_6_path1_T_H_OP20	9500	9000	{}	decreasing	A6-P1	A2	2	8	40
4097	InFan1SrvAmpSpeed_7_path1_T_H_OP20	8500	7500	{}	decreasing	A7-P1	AT	2	8	40
4098	ServoLoad_0_path1_T_H_OP20	NaN	NaN	{}	increasing	A0-P1	X	17	17	40
4099	ServoLoad_1_path1_T_H_OP20	NaN	NaN	{}	increasing	A1-P1	Z	17	17	40
4100	ServoLoad_2_path1_T_H_OP20	NaN	NaN	{}	increasing	A2-P1	Y	17	17	40
4101	ServoLoad_3_path1_T_H_OP20	NaN	NaN	{}	increasing	A3-P1	YS	17	17	40
4103	ServoLoad_5_path1_T_H_OP20	NaN	NaN	{}	increasing	A5-P1	BMG	17	17	40
4104	ServoLoad_6_path1_T_H_OP20	NaN	NaN	{}	increasing	A6-P1	A2	17	17	40
4105	ServoLoad_7_path1_T_H_OP20	NaN	NaN	{}	increasing	A7-P1	AT	17	17	40
4106	SpindleLoad_0_path1_T_H_OP20	NaN	NaN	{}	increasing	SP-P1	SP	17	17	40
4107	SpdBatZero_0_path1_T_H_OP20	NaN	NaN	{}	bool	A0-P1	X	6	13	40
4108	SpdBatZero_1_path1_T_H_OP20	NaN	NaN	{}	bool	A1-P1	Z	6	13	40
4109	SpdBatZero_2_path1_T_H_OP20	NaN	NaN	{}	bool	A2-P1	Y	6	13	40
4110	SpdBatZero_3_path1_T_H_OP20	NaN	NaN	{}	bool	A3-P1	YS	6	13	40
4112	SpdBatZero_5_path1_T_H_OP20	NaN	NaN	{}	bool	A5-P1	BMG	6	13	40
4113	SpdBatZero_6_path1_T_H_OP20	NaN	NaN	{}	bool	A6-P1	A2	6	13	40
4114	SpdBatZero_7_path1_T_H_OP20	NaN	NaN	{}	bool	A7-P1	AT	6	13	40
4115	SSpdBatZero_0_path1_T_H_OP20	NaN	NaN	{}	bool	A0-P1	X	6	14	40
4116	SSpdBatZero_1_path1_T_H_OP20	NaN	NaN	{}	bool	A1-P1	Z	6	14	40
4117	SSpdBatZero_2_path1_T_H_OP20	NaN	NaN	{}	bool	A2-P1	Y	6	14	40
4118	SSpdBatZero_3_path1_T_H_OP20	NaN	NaN	{}	bool	A3-P1	YS	6	14	40
4120	SSpdBatZero_5_path1_T_H_OP20	NaN	NaN	{}	bool	A5-P1	BMG	6	14	40
4121	SSpdBatZero_6_path1_T_H_OP20	NaN	NaN	{}	bool	A6-P1	A2	6	14	40
4122	SSpdBatZero_7_path1_T_H_OP20	NaN	NaN	{}	bool	A7-P1	AT	6	14	40
4123	RadFan2SpindleAmpSpeed_0_path1_T_H_OP20	5000	4500	{}	decreasing	SP-P1	SP	2	16	40
4124	RadFan2SrvAmpSpeed_0_path1_T_H_OP20	5000	4500	{}	decreasing	A0-P1	X	2	16	40
4125	RadFan2SrvAmpSpeed_1_path1_T_H_OP20	5000	4500	{}	decreasing	A1-P1	Z	2	16	40
4126	RadFan2SrvAmpSpeed_2_path1_T_H_OP20	5000	4500	{}	decreasing	A2-P1	Y	2	16	40
4127	RadFan2SrvAmpSpeed_3_path1_T_H_OP20	5000	4500	{}	decreasing	A3-P1	YS	2	16	40
4129	RadFan2SrvAmpSpeed_5_path1_T_H_OP20	5000	4500	{}	decreasing	A5-P1	BMG	2	16	40
4130	RadFan2SrvAmpSpeed_6_path1_T_H_OP20	5000	4500	{}	decreasing	A6-P1	A2	2	16	40
4131	RadFan2SrvAmpSpeed_7_path1_T_H_OP20	5000	4500	{}	decreasing	A7-P1	AT	2	16	40
4132	ApcBatLow_0_path1_T_H_OP20	NaN	NaN	{}	bool	A0-P1	X	6	1	40
4133	ApcBatLow_1_path1_T_H_OP20	NaN	NaN	{}	bool	A1-P1	Z	6	1	40
4134	ApcBatLow_2_path1_T_H_OP20	NaN	NaN	{}	bool	A2-P1	Y	6	1	40
4135	ApcBatLow_3_path1_T_H_OP20	NaN	NaN	{}	bool	A3-P1	YS	6	1	40
4137	ApcBatLow_5_path1_T_H_OP20	NaN	NaN	{}	bool	A5-P1	BMG	6	1	40
4138	ApcBatLow_6_path1_T_H_OP20	NaN	NaN	{}	bool	A6-P1	A2	6	1	40
4139	ApcBatLow_7_path1_T_H_OP20	NaN	NaN	{}	bool	A7-P1	AT	6	1	40
4140	CncBatLow_0_path1_T_H_OP20	NaN	NaN	{}	bool	A0-P1	X	6	2	40
4141	CncBatLow_1_path1_T_H_OP20	NaN	NaN	{}	bool	A1-P1	Z	6	2	40
4142	CncBatLow_2_path1_T_H_OP20	NaN	NaN	{}	bool	A2-P1	Y	6	2	40
4143	CncBatLow_3_path1_T_H_OP20	NaN	NaN	{}	bool	A3-P1	YS	6	2	40
4145	CncBatLow_5_path1_T_H_OP20	NaN	NaN	{}	bool	A5-P1	BMG	6	2	40
4146	CncBatLow_6_path1_T_H_OP20	NaN	NaN	{}	bool	A6-P1	A2	6	2	40
4147	CncBatLow_7_path1_T_H_OP20	NaN	NaN	{}	bool	A7-P1	AT	6	2	40
4148	ServoLeakResistData_0_path1_T_H_OP20	50	30	{}	decreasing	A0-P1	X	15	5	40
4149	ServoLeakResistData_1_path1_T_H_OP20	50	30	{}	decreasing	A1-P1	Z	15	5	40
4150	ServoLeakResistData_2_path1_T_H_OP20	50	30	{}	decreasing	A2-P1	Y	15	5	40
4151	ServoLeakResistData_3_path1_T_H_OP20	50	30	{}	decreasing	A3-P1	YS	15	5	40
4153	ServoLeakResistData_5_path1_T_H_OP20	50	30	{}	decreasing	A5-P1	BMG	15	5	40
4154	ServoLeakResistData_6_path1_T_H_OP20	50	30	{}	decreasing	A6-P1	A2	15	5	40
4155	ServoLeakResistData_7_path1_T_H_OP20	50	30	{}	decreasing	A7-P1	AT	15	5	40
4156	SpindleLeakResistData_0_path1_T_H_OP20	50	30	{}	decreasing	SP-P1	SP	15	5	40
4157	InFan1SrvComPwSpeed_0_path1_T_H_OP20	6200	6000	{}	decreasing	A0-P1	X	2	9	40
4158	InFan1SrvComPwSpeed_1_path1_T_H_OP20	6200	6000	{}	decreasing	A1-P1	Z	2	9	40
4159	InFan1SrvComPwSpeed_2_path1_T_H_OP20	6200	6000	{}	decreasing	A2-P1	Y	2	9	40
4160	InFan1SrvComPwSpeed_3_path1_T_H_OP20	6200	6000	{}	decreasing	A3-P1	YS	2	9	40
4162	InFan1SrvComPwSpeed_5_path1_T_H_OP20	6200	6000	{}	decreasing	A5-P1	BMG	2	9	40
4163	InFan1SrvComPwSpeed_6_path1_T_H_OP20	6200	6000	{}	decreasing	A6-P1	A2	2	9	40
4164	InFan1SrvComPwSpeed_7_path1_T_H_OP20	6200	6000	{}	decreasing	A7-P1	AT	2	9	40
4165	InFan2SrvAmpSpeed_0_path1_T_H_OP20	5000	4500	{}	decreasing	A0-P1	X	2	11	40
4166	InFan2SrvAmpSpeed_1_path1_T_H_OP20	5000	4500	{}	decreasing	A1-P1	Z	2	11	40
4167	InFan2SrvAmpSpeed_2_path1_T_H_OP20	5000	4500	{}	decreasing	A2-P1	Y	2	11	40
4168	InFan2SrvAmpSpeed_3_path1_T_H_OP20	5000	4500	{}	decreasing	A3-P1	YS	2	11	40
4170	InFan2SrvAmpSpeed_5_path1_T_H_OP20	5000	4500	{}	decreasing	A5-P1	BMG	2	11	40
4171	InFan2SrvAmpSpeed_6_path1_T_H_OP20	5000	4500	{}	decreasing	A6-P1	A2	2	11	40
4172	InFan2SrvAmpSpeed_7_path1_T_H_OP20	5000	4500	{}	decreasing	A7-P1	AT	2	11	40
4173	RadFan1SpindleAmpSpeed_0_path1_T_H_OP20	5000	4500	{}	decreasing	SP-P1	SP	2	15	40
4174	RadFan1SrvAmpSpeed_0_path1_T_H_OP20	5000	4500	{}	decreasing	A0-P1	X	2	15	40
4175	RadFan1SrvAmpSpeed_1_path1_T_H_OP20	5000	4500	{}	decreasing	A1-P1	Z	2	15	40
4176	RadFan1SrvAmpSpeed_2_path1_T_H_OP20	5000	4500	{}	decreasing	A2-P1	Y	2	15	40
4177	RadFan1SrvAmpSpeed_3_path1_T_H_OP20	5000	4500	{}	decreasing	A3-P1	YS	2	15	40
4179	RadFan1SrvAmpSpeed_5_path1_T_H_OP20	5000	4500	{}	decreasing	A5-P1	BMG	2	15	40
4180	RadFan1SrvAmpSpeed_6_path1_T_H_OP20	5000	4500	{}	decreasing	A6-P1	A2	2	15	40
4181	RadFan1SrvAmpSpeed_7_path1_T_H_OP20	5000	4500	{}	decreasing	A7-P1	AT	2	15	40
4182	InFan2SpdlComPwSpeed_0_path1_T_H_OP20	5000	4500	{}	decreasing	A0-P1	SAS	2	10	40
4183	InFan2SpindleAmpSpeed_0_path1_T_H_OP20	5000	4500	{}	decreasing	A0-P1	SCS	2	10	40
4184	InFan2SrvComPwSpeed_0_path1_T_H_OP20	5000	4500	{}	decreasing	A0-P1	X	2	12	40
4185	InFan2SrvComPwSpeed_1_path1_T_H_OP20	5000	4500	{}	decreasing	A1-P1	Z	2	12	40
4186	InFan2SrvComPwSpeed_2_path1_T_H_OP20	5000	4500	{}	decreasing	A2-P1	Y	2	12	40
4187	InFan2SrvComPwSpeed_3_path1_T_H_OP20	5000	4500	{}	decreasing	A3-P1	YS	2	12	40
4189	InFan2SrvComPwSpeed_5_path1_T_H_OP20	5000	4500	{}	decreasing	A5-P1	BMG	2	12	40
4190	InFan2SrvComPwSpeed_6_path1_T_H_OP20	5000	4500	{}	decreasing	A6-P1	A2	2	12	40
4191	InFan2SrvComPwSpeed_7_path1_T_H_OP20	5000	4500	{}	decreasing	A7-P1	AT	2	12	40
4192	InFan1SpdlComPwSpeed_0_path1_T_H_OP20	5000	4500	{}	decreasing	A0-P1	SAS	2	7	40
4193	InFan1SpindleAmpSpeed_0_path1_T_H_OP20	6200	6000	{}	decreasing	A0-P1	SCS	2	7	40
4194	ServoTemp_0_path1_T_H_OP20	55	70	{}	increasing	A0-P1	X	13	3	40
4195	ServoTemp_1_path1_T_H_OP20	55	70	{}	increasing	A1-P1	Z	13	3	40
4196	ServoTemp_2_path1_T_H_OP20	55	70	{}	increasing	A2-P1	Y	13	3	40
4197	ServoTemp_3_path1_T_H_OP20	55	70	{}	increasing	A3-P1	YS	13	3	40
4199	ServoTemp_5_path1_T_H_OP20	55	70	{}	increasing	A5-P1	BMG	13	3	40
4200	ServoTemp_6_path1_T_H_OP20	55	70	{}	increasing	A6-P1	A2	13	3	40
4201	ServoTemp_7_path1_T_H_OP20	55	70	{}	increasing	A7-P1	AT	13	3	40
4202	SpindleTemp_0_path1_T_H_OP20	80	100	{}	increasing	SP-P1	SP	13	3	40
4203	PulseCoderTemp_0_path1_T_H_OP230	60	80	{}	increasing	A0-P1	X	13	4	41
4204	PulseCoderTemp_1_path1_T_H_OP230	60	80	{}	increasing	A1-P1	Z	13	4	41
4205	PulseCoderTemp_2_path1_T_H_OP230	60	80	{}	increasing	A2-P1	Y	13	4	41
4206	PulseCoderTemp_3_path1_T_H_OP230	60	80	{}	increasing	A3-P1	YS	13	4	41
4207	PulseCoderTemp_4_path1_T_H_OP230	60	80	{}	increasing	A4-P1	B	13	4	41
4208	PulseCoderTemp_5_path1_T_H_OP230	60	80	{}	increasing	A5-P1	C	13	4	41
4209	PulseCoderTemp_6_path1_T_H_OP230	60	80	{}	increasing	A6-P1	WMG	13	4	41
4210	PulseCoderTemp_7_path1_T_H_OP230	60	80	{}	increasing	A7-P1	A2	13	4	41
4211	CncFan1Speed_path1_T_H_OP230	4500	4000	{}	decreasing	A1-P1	F1	16	6	41
4212	CncFan2Speed_path1_T_H_OP230	9600	8600	{}	decreasing	A1-P1	F2	16	6	41
4215	InFan1SrvAmpSpeed_0_path1_T_H_OP230	9500	9000	{}	decreasing	A0-P1	X	2	8	41
4216	InFan1SrvAmpSpeed_1_path1_T_H_OP230	9500	9000	{}	decreasing	A1-P1	Z	2	8	41
4217	InFan1SrvAmpSpeed_2_path1_T_H_OP230	9500	9000	{}	decreasing	A2-P1	Y	2	8	41
4218	InFan1SrvAmpSpeed_3_path1_T_H_OP230	9500	9000	{}	decreasing	A3-P1	YS	2	8	41
4219	InFan1SrvAmpSpeed_4_path1_T_H_OP230	8500	7500	{}	decreasing	A4-P1	B	2	8	41
4220	InFan1SrvAmpSpeed_5_path1_T_H_OP230	8500	7500	{}	decreasing	A5-P1	C	2	8	41
4221	InFan1SrvAmpSpeed_6_path1_T_H_OP230	8000	7000	{}	decreasing	A6-P1	WMG	2	8	41
4222	InFan1SrvAmpSpeed_7_path1_T_H_OP230	8500	7500	{}	decreasing	A7-P1	A2	2	8	41
4223	ServoLoad_0_path1_T_H_OP230	NaN	NaN	{}	increasing	A0-P1	X	17	17	41
4224	ServoLoad_1_path1_T_H_OP230	NaN	NaN	{}	increasing	A1-P1	Z	17	17	41
4225	ServoLoad_2_path1_T_H_OP230	NaN	NaN	{}	increasing	A2-P1	Y	17	17	41
4226	ServoLoad_3_path1_T_H_OP230	NaN	NaN	{}	increasing	A3-P1	YS	17	17	41
4227	ServoLoad_4_path1_T_H_OP230	NaN	NaN	{}	increasing	A4-P1	B	17	17	41
4228	ServoLoad_5_path1_T_H_OP230	NaN	NaN	{}	increasing	A5-P1	C	17	17	41
4229	ServoLoad_6_path1_T_H_OP230	NaN	NaN	{}	increasing	A6-P1	WMG	17	17	41
4230	ServoLoad_7_path1_T_H_OP230	NaN	NaN	{}	increasing	A7-P1	A2	17	17	41
4231	SpindleLoad_0_path1_T_H_OP230	NaN	NaN	{}	increasing	SP-P1	SP	17	17	41
4232	SpdBatZero_0_path1_T_H_OP230	NaN	NaN	{}	bool	A0-P1	X	6	13	41
4233	SpdBatZero_1_path1_T_H_OP230	NaN	NaN	{}	bool	A1-P1	Z	6	13	41
4234	SpdBatZero_2_path1_T_H_OP230	NaN	NaN	{}	bool	A2-P1	Y	6	13	41
4235	SpdBatZero_3_path1_T_H_OP230	NaN	NaN	{}	bool	A3-P1	YS	6	13	41
4236	SpdBatZero_4_path1_T_H_OP230	NaN	NaN	{}	bool	A4-P1	B	6	13	41
4237	SpdBatZero_5_path1_T_H_OP230	NaN	NaN	{}	bool	A5-P1	C	6	13	41
4238	SpdBatZero_6_path1_T_H_OP230	NaN	NaN	{}	bool	A6-P1	WMG	6	13	41
4239	SpdBatZero_7_path1_T_H_OP230	NaN	NaN	{}	bool	A7-P1	A2	6	13	41
4240	SSpdBatZero_0_path1_T_H_OP230	NaN	NaN	{}	bool	A0-P1	X	6	14	41
4241	SSpdBatZero_1_path1_T_H_OP230	NaN	NaN	{}	bool	A1-P1	Z	6	14	41
4242	SSpdBatZero_2_path1_T_H_OP230	NaN	NaN	{}	bool	A2-P1	Y	6	14	41
4243	SSpdBatZero_3_path1_T_H_OP230	NaN	NaN	{}	bool	A3-P1	YS	6	14	41
4244	SSpdBatZero_4_path1_T_H_OP230	NaN	NaN	{}	bool	A4-P1	B	6	14	41
4245	SSpdBatZero_5_path1_T_H_OP230	NaN	NaN	{}	bool	A5-P1	C	6	14	41
4246	SSpdBatZero_6_path1_T_H_OP230	NaN	NaN	{}	bool	A6-P1	WMG	6	14	41
4247	SSpdBatZero_7_path1_T_H_OP230	NaN	NaN	{}	bool	A7-P1	A2	6	14	41
4248	RadFan2SpindleAmpSpeed_0_path1_T_H_OP230	5000	4500	{}	decreasing	SP-P1	SP	2	16	41
4249	RadFan2SrvAmpSpeed_0_path1_T_H_OP230	5000	4500	{}	decreasing	A0-P1	X	2	16	41
4250	RadFan2SrvAmpSpeed_1_path1_T_H_OP230	5000	4500	{}	decreasing	A1-P1	Z	2	16	41
4251	RadFan2SrvAmpSpeed_2_path1_T_H_OP230	5000	4500	{}	decreasing	A2-P1	Y	2	16	41
4252	RadFan2SrvAmpSpeed_3_path1_T_H_OP230	5000	4500	{}	decreasing	A3-P1	YS	2	16	41
4253	RadFan2SrvAmpSpeed_4_path1_T_H_OP230	5000	4500	{}	decreasing	A4-P1	B	2	16	41
4254	RadFan2SrvAmpSpeed_5_path1_T_H_OP230	5000	4500	{}	decreasing	A5-P1	C	2	16	41
4255	RadFan2SrvAmpSpeed_6_path1_T_H_OP230	5000	4500	{}	decreasing	A6-P1	WMG	2	16	41
4256	RadFan2SrvAmpSpeed_7_path1_T_H_OP230	5000	4500	{}	decreasing	A7-P1	A2	2	16	41
4257	ApcBatLow_0_path1_T_H_OP230	NaN	NaN	{}	bool	A0-P1	X	6	1	41
4258	ApcBatLow_1_path1_T_H_OP230	NaN	NaN	{}	bool	A1-P1	Z	6	1	41
4259	ApcBatLow_2_path1_T_H_OP230	NaN	NaN	{}	bool	A2-P1	Y	6	1	41
4260	ApcBatLow_3_path1_T_H_OP230	NaN	NaN	{}	bool	A3-P1	YS	6	1	41
4261	ApcBatLow_4_path1_T_H_OP230	NaN	NaN	{}	bool	A4-P1	B	6	1	41
4262	ApcBatLow_5_path1_T_H_OP230	NaN	NaN	{}	bool	A5-P1	C	6	1	41
4263	ApcBatLow_6_path1_T_H_OP230	NaN	NaN	{}	bool	A6-P1	WMG	6	1	41
4264	ApcBatLow_7_path1_T_H_OP230	NaN	NaN	{}	bool	A7-P1	A2	6	1	41
4265	CncBatLow_0_path1_T_H_OP230	NaN	NaN	{}	bool	A0-P1	X	6	2	41
4266	CncBatLow_1_path1_T_H_OP230	NaN	NaN	{}	bool	A1-P1	Z	6	2	41
4267	CncBatLow_2_path1_T_H_OP230	NaN	NaN	{}	bool	A2-P1	Y	6	2	41
4268	CncBatLow_3_path1_T_H_OP230	NaN	NaN	{}	bool	A3-P1	YS	6	2	41
4269	CncBatLow_4_path1_T_H_OP230	NaN	NaN	{}	bool	A4-P1	B	6	2	41
4270	CncBatLow_5_path1_T_H_OP230	NaN	NaN	{}	bool	A5-P1	C	6	2	41
4271	CncBatLow_6_path1_T_H_OP230	NaN	NaN	{}	bool	A6-P1	WMG	6	2	41
4272	CncBatLow_7_path1_T_H_OP230	NaN	NaN	{}	bool	A7-P1	A2	6	2	41
4273	ServoLeakResistData_0_path1_T_H_OP230	50	30	{}	decreasing	A0-P1	X	15	5	41
4274	ServoLeakResistData_1_path1_T_H_OP230	50	30	{}	decreasing	A1-P1	Z	15	5	41
4275	ServoLeakResistData_2_path1_T_H_OP230	50	30	{}	decreasing	A2-P1	Y	15	5	41
4276	ServoLeakResistData_3_path1_T_H_OP230	50	30	{}	decreasing	A3-P1	YS	15	5	41
4277	ServoLeakResistData_4_path1_T_H_OP230	50	30	{}	decreasing	A4-P1	B	15	5	41
4278	ServoLeakResistData_5_path1_T_H_OP230	50	30	{}	decreasing	A5-P1	C	15	5	41
4279	ServoLeakResistData_6_path1_T_H_OP230	50	30	{}	decreasing	A6-P1	WMG	15	5	41
4280	ServoLeakResistData_7_path1_T_H_OP230	50	30	{}	decreasing	A7-P1	A2	15	5	41
4281	SpindleLeakResistData_0_path1_T_H_OP230	50	30	{}	decreasing	SP-P1	SP	15	5	41
4282	InFan1SrvComPwSpeed_0_path1_T_H_OP230	6200	6000	{}	decreasing	A0-P1	X	2	9	41
4283	InFan1SrvComPwSpeed_1_path1_T_H_OP230	6200	6000	{}	decreasing	A1-P1	Z	2	9	41
4284	InFan1SrvComPwSpeed_2_path1_T_H_OP230	6200	6000	{}	decreasing	A2-P1	Y	2	9	41
4285	InFan1SrvComPwSpeed_3_path1_T_H_OP230	6200	6000	{}	decreasing	A3-P1	YS	2	9	41
4286	InFan1SrvComPwSpeed_4_path1_T_H_OP230	6200	6000	{}	decreasing	A4-P1	B	2	9	41
4287	InFan1SrvComPwSpeed_5_path1_T_H_OP230	6200	6000	{}	decreasing	A5-P1	C	2	9	41
4288	InFan1SrvComPwSpeed_6_path1_T_H_OP230	6200	6000	{}	decreasing	A6-P1	WMG	2	9	41
4289	InFan1SrvComPwSpeed_7_path1_T_H_OP230	6200	6000	{}	decreasing	A7-P1	A2	2	9	41
4290	InFan2SrvAmpSpeed_0_path1_T_H_OP230	5000	4500	{}	decreasing	A0-P1	X	2	11	41
4291	InFan2SrvAmpSpeed_1_path1_T_H_OP230	5000	4500	{}	decreasing	A1-P1	Z	2	11	41
4292	InFan2SrvAmpSpeed_2_path1_T_H_OP230	5000	4500	{}	decreasing	A2-P1	Y	2	11	41
4293	InFan2SrvAmpSpeed_3_path1_T_H_OP230	5000	4500	{}	decreasing	A3-P1	YS	2	11	41
4294	InFan2SrvAmpSpeed_4_path1_T_H_OP230	5000	4500	{}	decreasing	A4-P1	B	2	11	41
4295	InFan2SrvAmpSpeed_5_path1_T_H_OP230	5000	4500	{}	decreasing	A5-P1	C	2	11	41
4296	InFan2SrvAmpSpeed_6_path1_T_H_OP230	5000	4500	{}	decreasing	A6-P1	WMG	2	11	41
4297	InFan2SrvAmpSpeed_7_path1_T_H_OP230	5000	4500	{}	decreasing	A7-P1	A2	2	11	41
4298	RadFan1SpindleAmpSpeed_0_path1_T_H_OP230	5000	4500	{}	decreasing	SP-P1	SP	2	15	41
4299	RadFan1SrvAmpSpeed_0_path1_T_H_OP230	5000	4500	{}	decreasing	A0-P1	X	2	15	41
4300	RadFan1SrvAmpSpeed_1_path1_T_H_OP230	5000	4500	{}	decreasing	A1-P1	Z	2	15	41
4301	RadFan1SrvAmpSpeed_2_path1_T_H_OP230	5000	4500	{}	decreasing	A2-P1	Y	2	15	41
4302	RadFan1SrvAmpSpeed_3_path1_T_H_OP230	5000	4500	{}	decreasing	A3-P1	YS	2	15	41
4303	RadFan1SrvAmpSpeed_4_path1_T_H_OP230	5000	4500	{}	decreasing	A4-P1	B	2	15	41
4304	RadFan1SrvAmpSpeed_5_path1_T_H_OP230	5000	4500	{}	decreasing	A5-P1	C	2	15	41
4305	RadFan1SrvAmpSpeed_6_path1_T_H_OP230	5000	4500	{}	decreasing	A6-P1	WMG	2	15	41
4306	RadFan1SrvAmpSpeed_7_path1_T_H_OP230	5000	4500	{}	decreasing	A7-P1	A2	2	15	41
4307	InFan2SpdlComPwSpeed_0_path1_T_H_OP230	5000	4500	{}	decreasing	A0-P1	SAS	2	10	41
4308	InFan2SpindleAmpSpeed_0_path1_T_H_OP230	5000	4500	{}	decreasing	A0-P1	SCS	2	10	41
4309	InFan2SrvComPwSpeed_0_path1_T_H_OP230	5000	4500	{}	decreasing	A0-P1	X	2	12	41
4310	InFan2SrvComPwSpeed_1_path1_T_H_OP230	5000	4500	{}	decreasing	A1-P1	Z	2	12	41
4311	InFan2SrvComPwSpeed_2_path1_T_H_OP230	5000	4500	{}	decreasing	A2-P1	Y	2	12	41
4312	InFan2SrvComPwSpeed_3_path1_T_H_OP230	5000	4500	{}	decreasing	A3-P1	YS	2	12	41
4313	InFan2SrvComPwSpeed_4_path1_T_H_OP230	5000	4500	{}	decreasing	A4-P1	B	2	12	41
4314	InFan2SrvComPwSpeed_5_path1_T_H_OP230	5000	4500	{}	decreasing	A5-P1	C	2	12	41
4315	InFan2SrvComPwSpeed_6_path1_T_H_OP230	5000	4500	{}	decreasing	A6-P1	WMG	2	12	41
4316	InFan2SrvComPwSpeed_7_path1_T_H_OP230	5000	4500	{}	decreasing	A7-P1	A2	2	12	41
4317	InFan1SpdlComPwSpeed_0_path1_T_H_OP230	5000	4500	{}	decreasing	A0-P1	SAS	2	7	41
4318	InFan1SpindleAmpSpeed_0_path1_T_H_OP230	6200	6000	{}	decreasing	A0-P1	SCS	2	7	41
4324	ServoTemp_5_path1_T_H_OP230	55	70	{}	increasing	A5-P1	C	13	3	41
4325	ServoTemp_6_path1_T_H_OP230	55	70	{}	increasing	A6-P1	WMG	13	3	41
4326	ServoTemp_7_path1_T_H_OP230	55	70	{}	increasing	A7-P1	A2	13	3	41
4327	SpindleTemp_0_path1_T_H_OP230	80	100	{}	increasing	SP-P1	SP	13	3	41
4328	PulseCoderTemp_0_path1_T_H_OP240	60	80	{}	increasing	A0-P1	X	13	4	42
4329	PulseCoderTemp_1_path1_T_H_OP240	60	80	{}	increasing	A1-P1	Z	13	4	42
4330	PulseCoderTemp_2_path1_T_H_OP240	60	80	{}	increasing	A2-P1	Y	13	4	42
4331	PulseCoderTemp_3_path1_T_H_OP240	60	80	{}	increasing	A3-P1	YS	13	4	42
4332	PulseCoderTemp_4_path1_T_H_OP240	60	80	{}	increasing	A4-P1	B	13	4	42
4333	PulseCoderTemp_5_path1_T_H_OP240	60	80	{}	increasing	A5-P1	C	13	4	42
4334	PulseCoderTemp_6_path1_T_H_OP240	60	80	{}	increasing	A6-P1	WMG	13	4	42
4335	PulseCoderTemp_7_path1_T_H_OP240	60	80	{}	increasing	A7-P1	A2	13	4	42
4336	CncFan1Speed_path1_T_H_OP240	4500	4000	{}	decreasing	A1-P1	F1	16	6	42
4337	CncFan2Speed_path1_T_H_OP240	9600	8600	{}	decreasing	A2-P1	F2	16	6	42
4340	InFan1SrvAmpSpeed_0_path1_T_H_OP240	9500	9000	{}	decreasing	A0-P1	X	2	8	42
4341	InFan1SrvAmpSpeed_1_path1_T_H_OP240	9500	9000	{}	decreasing	A1-P1	Z	2	8	42
4342	InFan1SrvAmpSpeed_2_path1_T_H_OP240	9500	9000	{}	decreasing	A2-P1	Y	2	8	42
4343	InFan1SrvAmpSpeed_3_path1_T_H_OP240	9500	9000	{}	decreasing	A3-P1	YS	2	8	42
4344	InFan1SrvAmpSpeed_4_path1_T_H_OP240	8500	7500	{}	decreasing	A4-P1	B	2	8	42
4345	InFan1SrvAmpSpeed_5_path1_T_H_OP240	8500	7500	{}	decreasing	A5-P1	C	2	8	42
4346	InFan1SrvAmpSpeed_6_path1_T_H_OP240	9500	9000	{}	decreasing	A6-P1	WMG	2	8	42
4347	InFan1SrvAmpSpeed_7_path1_T_H_OP240	8500	7500	{}	decreasing	A7-P1	A2	2	8	42
4348	ServoLoad_0_path1_T_H_OP240	NaN	NaN	{}	increasing	A0-P1	X	17	17	42
4349	ServoLoad_1_path1_T_H_OP240	NaN	NaN	{}	increasing	A1-P1	Z	17	17	42
4350	ServoLoad_2_path1_T_H_OP240	NaN	NaN	{}	increasing	A2-P1	Y	17	17	42
4351	ServoLoad_3_path1_T_H_OP240	NaN	NaN	{}	increasing	A3-P1	YS	17	17	42
4352	ServoLoad_4_path1_T_H_OP240	NaN	NaN	{}	increasing	A4-P1	B	17	17	42
4353	ServoLoad_5_path1_T_H_OP240	NaN	NaN	{}	increasing	A5-P1	C	17	17	42
4354	ServoLoad_6_path1_T_H_OP240	NaN	NaN	{}	increasing	A6-P1	WMG	17	17	42
4355	ServoLoad_7_path1_T_H_OP240	NaN	NaN	{}	increasing	A7-P1	A2	17	17	42
4356	SpindleLoad_0_path1_T_H_OP240	NaN	NaN	{}	increasing	SP-P1	SP	17	17	42
4357	SpdBatZero_0_path1_T_H_OP240	NaN	NaN	{}	bool	A0-P1	X	6	13	42
4358	SpdBatZero_1_path1_T_H_OP240	NaN	NaN	{}	bool	A1-P1	Z	6	13	42
4359	SpdBatZero_2_path1_T_H_OP240	NaN	NaN	{}	bool	A2-P1	Y	6	13	42
4360	SpdBatZero_3_path1_T_H_OP240	NaN	NaN	{}	bool	A3-P1	YS	6	13	42
4361	SpdBatZero_4_path1_T_H_OP240	NaN	NaN	{}	bool	A4-P1	B	6	13	42
4362	SpdBatZero_5_path1_T_H_OP240	NaN	NaN	{}	bool	A5-P1	C	6	13	42
4363	SpdBatZero_6_path1_T_H_OP240	NaN	NaN	{}	bool	A6-P1	WMG	6	13	42
4364	SpdBatZero_7_path1_T_H_OP240	NaN	NaN	{}	bool	A7-P1	A2	6	13	42
4365	SSpdBatZero_0_path1_T_H_OP240	NaN	NaN	{}	bool	A0-P1	X	6	14	42
4366	SSpdBatZero_1_path1_T_H_OP240	NaN	NaN	{}	bool	A1-P1	Z	6	14	42
4367	SSpdBatZero_2_path1_T_H_OP240	NaN	NaN	{}	bool	A2-P1	Y	6	14	42
4368	SSpdBatZero_3_path1_T_H_OP240	NaN	NaN	{}	bool	A3-P1	YS	6	14	42
4369	SSpdBatZero_4_path1_T_H_OP240	NaN	NaN	{}	bool	A4-P1	B	6	14	42
4370	SSpdBatZero_5_path1_T_H_OP240	NaN	NaN	{}	bool	A5-P1	C	6	14	42
4371	SSpdBatZero_6_path1_T_H_OP240	NaN	NaN	{}	bool	A6-P1	WMG	6	14	42
4372	SSpdBatZero_7_path1_T_H_OP240	NaN	NaN	{}	bool	A7-P1	A2	6	14	42
4373	RadFan2SpindleAmpSpeed_0_path1_T_H_OP240	5000	4500	{}	decreasing	SP-P1	SP	2	16	42
4374	RadFan2SrvAmpSpeed_0_path1_T_H_OP240	5000	4500	{}	decreasing	A0-P1	X	2	16	42
4375	RadFan2SrvAmpSpeed_1_path1_T_H_OP240	5000	4500	{}	decreasing	A1-P1	Z	2	16	42
4376	RadFan2SrvAmpSpeed_2_path1_T_H_OP240	5000	4500	{}	decreasing	A2-P1	Y	2	16	42
4377	RadFan2SrvAmpSpeed_3_path1_T_H_OP240	5000	4500	{}	decreasing	A3-P1	YS	2	16	42
4378	RadFan2SrvAmpSpeed_4_path1_T_H_OP240	5000	4500	{}	decreasing	A4-P1	B	2	16	42
4379	RadFan2SrvAmpSpeed_5_path1_T_H_OP240	5000	4500	{}	decreasing	A5-P1	C	2	16	42
4380	RadFan2SrvAmpSpeed_6_path1_T_H_OP240	5000	4500	{}	decreasing	A6-P1	WMG	2	16	42
4381	RadFan2SrvAmpSpeed_7_path1_T_H_OP240	5000	4500	{}	decreasing	A7-P1	A2	2	16	42
4382	ApcBatLow_0_path1_T_H_OP240	NaN	NaN	{}	bool	A0-P1	X	6	1	42
4383	ApcBatLow_1_path1_T_H_OP240	NaN	NaN	{}	bool	A1-P1	Z	6	1	42
4384	ApcBatLow_2_path1_T_H_OP240	NaN	NaN	{}	bool	A2-P1	Y	6	1	42
4385	ApcBatLow_3_path1_T_H_OP240	NaN	NaN	{}	bool	A3-P1	YS	6	1	42
4386	ApcBatLow_4_path1_T_H_OP240	NaN	NaN	{}	bool	A4-P1	B	6	1	42
4387	ApcBatLow_5_path1_T_H_OP240	NaN	NaN	{}	bool	A5-P1	C	6	1	42
4388	ApcBatLow_6_path1_T_H_OP240	NaN	NaN	{}	bool	A6-P1	WMG	6	1	42
4389	ApcBatLow_7_path1_T_H_OP240	NaN	NaN	{}	bool	A7-P1	A2	6	1	42
4390	CncBatLow_0_path1_T_H_OP240	NaN	NaN	{}	bool	A0-P1	X	6	2	42
4391	CncBatLow_1_path1_T_H_OP240	NaN	NaN	{}	bool	A1-P1	Z	6	2	42
4392	CncBatLow_2_path1_T_H_OP240	NaN	NaN	{}	bool	A2-P1	Y	6	2	42
4393	CncBatLow_3_path1_T_H_OP240	NaN	NaN	{}	bool	A3-P1	YS	6	2	42
4394	CncBatLow_4_path1_T_H_OP240	NaN	NaN	{}	bool	A4-P1	B	6	2	42
4395	CncBatLow_5_path1_T_H_OP240	NaN	NaN	{}	bool	A5-P1	C	6	2	42
4396	CncBatLow_6_path1_T_H_OP240	NaN	NaN	{}	bool	A6-P1	WMG	6	2	42
4397	CncBatLow_7_path1_T_H_OP240	NaN	NaN	{}	bool	A7-P1	A2	6	2	42
4398	ServoLeakResistData_0_path1_T_H_OP240	50	30	{}	decreasing	A0-P1	X	15	5	42
4399	ServoLeakResistData_1_path1_T_H_OP240	50	30	{}	decreasing	A1-P1	Z	15	5	42
4400	ServoLeakResistData_2_path1_T_H_OP240	50	30	{}	decreasing	A2-P1	Y	15	5	42
4401	ServoLeakResistData_3_path1_T_H_OP240	50	30	{}	decreasing	A3-P1	YS	15	5	42
4402	ServoLeakResistData_4_path1_T_H_OP240	50	30	{}	decreasing	A4-P1	B	15	5	42
4403	ServoLeakResistData_5_path1_T_H_OP240	50	30	{}	decreasing	A5-P1	C	15	5	42
4404	ServoLeakResistData_6_path1_T_H_OP240	50	30	{}	decreasing	A6-P1	WMG	15	5	42
4406	SpindleLeakResistData_0_path1_T_H_OP240	50	30	{}	decreasing	SP-P1	SP	15	5	42
4407	InFan1SrvComPwSpeed_0_path1_T_H_OP240	6200	6000	{}	decreasing	A0-P1	X	2	9	42
4408	InFan1SrvComPwSpeed_1_path1_T_H_OP240	6200	6000	{}	decreasing	A1-P1	Z	2	9	42
4409	InFan1SrvComPwSpeed_2_path1_T_H_OP240	6200	6000	{}	decreasing	A2-P1	Y	2	9	42
4410	InFan1SrvComPwSpeed_3_path1_T_H_OP240	6200	6000	{}	decreasing	A3-P1	YS	2	9	42
4411	InFan1SrvComPwSpeed_4_path1_T_H_OP240	6200	6000	{}	decreasing	A4-P1	B	2	9	42
4412	InFan1SrvComPwSpeed_5_path1_T_H_OP240	6200	6000	{}	decreasing	A5-P1	C	2	9	42
4413	InFan1SrvComPwSpeed_6_path1_T_H_OP240	6200	6000	{}	decreasing	A6-P1	WMG	2	9	42
4414	InFan1SrvComPwSpeed_7_path1_T_H_OP240	6200	6000	{}	decreasing	A7-P1	A2	2	9	42
4415	InFan2SrvAmpSpeed_0_path1_T_H_OP240	5000	4500	{}	decreasing	A0-P1	X	2	11	42
4416	InFan2SrvAmpSpeed_1_path1_T_H_OP240	5000	4500	{}	decreasing	A1-P1	Z	2	11	42
4417	InFan2SrvAmpSpeed_2_path1_T_H_OP240	5000	4500	{}	decreasing	A2-P1	Y	2	11	42
4418	InFan2SrvAmpSpeed_3_path1_T_H_OP240	5000	4500	{}	decreasing	A3-P1	YS	2	11	42
4419	InFan2SrvAmpSpeed_4_path1_T_H_OP240	5000	4500	{}	decreasing	A4-P1	B	2	11	42
4420	InFan2SrvAmpSpeed_5_path1_T_H_OP240	5000	4500	{}	decreasing	A5-P1	C	2	11	42
4421	InFan2SrvAmpSpeed_6_path1_T_H_OP240	5000	4500	{}	decreasing	A6-P1	WMG	2	11	42
4422	InFan2SrvAmpSpeed_7_path1_T_H_OP240	5000	4500	{}	decreasing	A7-P1	A2	2	11	42
4423	RadFan1SpindleAmpSpeed_0_path1_T_H_OP240	5000	4500	{}	decreasing	SP-P1	SP	2	15	42
4424	RadFan1SrvAmpSpeed_0_path1_T_H_OP240	5000	4500	{}	decreasing	A0-P1	X	2	15	42
4425	RadFan1SrvAmpSpeed_1_path1_T_H_OP240	5000	4500	{}	decreasing	A1-P1	Z	2	15	42
4426	RadFan1SrvAmpSpeed_2_path1_T_H_OP240	5000	4500	{}	decreasing	A2-P1	Y	2	15	42
4427	RadFan1SrvAmpSpeed_3_path1_T_H_OP240	5000	4500	{}	decreasing	A3-P1	YS	2	15	42
4428	RadFan1SrvAmpSpeed_4_path1_T_H_OP240	5000	4500	{}	decreasing	A4-P1	B	2	15	42
4429	RadFan1SrvAmpSpeed_5_path1_T_H_OP240	5000	4500	{}	decreasing	A5-P1	C	2	15	42
4430	RadFan1SrvAmpSpeed_6_path1_T_H_OP240	5000	4500	{}	decreasing	A6-P1	WMG	2	15	42
4431	RadFan1SrvAmpSpeed_7_path1_T_H_OP240	5000	4500	{}	decreasing	A7-P1	A2	2	15	42
4432	InFan2SpdlComPwSpeed_0_path1_T_H_OP240	5000	4500	{}	decreasing	A0-P1	SAS	2	10	42
4433	InFan2SpindleAmpSpeed_0_path1_T_H_OP240	5000	4500	{}	decreasing	A0-P1	SCS	2	10	42
4434	InFan2SrvComPwSpeed_0_path1_T_H_OP240	5000	4500	{}	decreasing	A0-P1	X	2	12	42
4435	InFan2SrvComPwSpeed_1_path1_T_H_OP240	5000	4500	{}	decreasing	A1-P1	Z	2	12	42
4436	InFan2SrvComPwSpeed_2_path1_T_H_OP240	5000	4500	{}	decreasing	A2-P1	Y	2	12	42
4437	InFan2SrvComPwSpeed_3_path1_T_H_OP240	5000	4500	{}	decreasing	A3-P1	YS	2	12	42
4438	InFan2SrvComPwSpeed_4_path1_T_H_OP240	5000	4500	{}	decreasing	A4-P1	B	2	12	42
4439	InFan2SrvComPwSpeed_5_path1_T_H_OP240	5000	4500	{}	decreasing	A5-P1	C	2	12	42
4440	InFan2SrvComPwSpeed_6_path1_T_H_OP240	5000	4500	{}	decreasing	A6-P1	WMG	2	12	42
4441	InFan2SrvComPwSpeed_7_path1_T_H_OP240	5000	4500	{}	decreasing	A7-P1	A2	2	12	42
4442	InFan1SpdlComPwSpeed_0_path1_T_H_OP240	5000	4500	{}	decreasing	A0-P1	SAS	2	7	42
4443	InFan1SpindleAmpSpeed_0_path1_T_H_OP240	6200	6000	{}	decreasing	A0-P1	SCS	2	7	42
4444	ServoTemp_0_path1_T_H_OP240	55	70	{}	increasing	A0-P1	X	13	3	42
4445	ServoTemp_1_path1_T_H_OP240	55	70	{}	increasing	A1-P1	Z	13	3	42
4446	ServoTemp_2_path1_T_H_OP240	55	70	{}	increasing	A2-P1	Y	13	3	42
4447	ServoTemp_3_path1_T_H_OP240	55	70	{}	increasing	A3-P1	YS	13	3	42
4448	ServoTemp_4_path1_T_H_OP240	55	70	{}	increasing	A4-P1	B	13	3	42
4449	ServoTemp_5_path1_T_H_OP240	55	70	{}	increasing	A5-P1	C	13	3	42
4450	ServoTemp_6_path1_T_H_OP240	55	70	{}	increasing	A6-P1	WMG	13	3	42
4451	ServoTemp_7_path1_T_H_OP240	55	70	{}	increasing	A7-P1	A2	13	3	42
4452	SpindleTemp_0_path1_T_H_OP240	80	100	{}	increasing	SP-P1	SP	13	3	42
4453	PulseCoderTemp_0_path1_T_H_OP250	60	80	{}	increasing	A0-P1	X	13	4	43
4454	PulseCoderTemp_1_path1_T_H_OP250	60	80	{}	increasing	A1-P1	Z	13	4	43
4455	PulseCoderTemp_2_path1_T_H_OP250	60	80	{}	increasing	A2-P1	Y	13	4	43
4456	PulseCoderTemp_3_path1_T_H_OP250	70	80	{}	increasing	A3-P1	YS	13	4	43
4457	PulseCoderTemp_4_path1_T_H_OP250	60	80	{}	increasing	A4-P1	B	13	4	43
4458	PulseCoderTemp_5_path1_T_H_OP250	60	80	{}	increasing	A5-P1	C	13	4	43
4459	PulseCoderTemp_6_path1_T_H_OP250	60	80	{}	increasing	A6-P1	WMG	13	4	43
4460	PulseCoderTemp_7_path1_T_H_OP250	60	80	{}	increasing	A7-P1	A2	13	4	43
4461	CncFan1Speed_path1_T_H_OP250	4500	4000	{}	decreasing	A1-P1	F1	16	6	43
4462	CncFan2Speed_path1_T_H_OP250	9600	8600	{}	decreasing	A2-P2	F2	16	6	43
4465	InFan1SrvAmpSpeed_0_path1_T_H_OP250	9500	9000	{}	decreasing	A0-P1	X	2	8	43
4466	InFan1SrvAmpSpeed_1_path1_T_H_OP250	9500	9000	{}	decreasing	A1-P1	Z	2	8	43
4467	InFan1SrvAmpSpeed_2_path1_T_H_OP250	9500	9000	{}	decreasing	A2-P1	Y	2	8	43
4468	InFan1SrvAmpSpeed_3_path1_T_H_OP250	9500	9000	{}	decreasing	A3-P1	YS	2	8	43
4469	InFan1SrvAmpSpeed_4_path1_T_H_OP250	8500	7500	{}	decreasing	A4-P1	B	2	8	43
4470	InFan1SrvAmpSpeed_5_path1_T_H_OP250	8500	7500	{}	decreasing	A5-P1	C	2	8	43
4471	InFan1SrvAmpSpeed_6_path1_T_H_OP250	8000	7500	{}	decreasing	A6-P1	WMG	2	8	43
4472	InFan1SrvAmpSpeed_7_path1_T_H_OP250	8500	7500	{}	decreasing	A7-P1	A2	2	8	43
4473	ServoLoad_0_path1_T_H_OP250	NaN	NaN	{}	increasing	A0-P1	X	17	17	43
4474	ServoLoad_1_path1_T_H_OP250	NaN	NaN	{}	increasing	A1-P1	Z	17	17	43
4475	ServoLoad_2_path1_T_H_OP250	NaN	NaN	{}	increasing	A2-P1	Y	17	17	43
4476	ServoLoad_3_path1_T_H_OP250	NaN	NaN	{}	increasing	A3-P1	YS	17	17	43
4477	ServoLoad_4_path1_T_H_OP250	NaN	NaN	{}	increasing	A4-P1	B	17	17	43
4478	ServoLoad_5_path1_T_H_OP250	NaN	NaN	{}	increasing	A5-P1	C	17	17	43
4479	ServoLoad_6_path1_T_H_OP250	NaN	NaN	{}	increasing	A6-P1	WMG	17	17	43
4480	ServoLoad_7_path1_T_H_OP250	NaN	NaN	{}	increasing	A7-P1	A2	17	17	43
4481	SpindleLoad_0_path1_T_H_OP250	NaN	NaN	{}	increasing	SP-P1	SP	17	17	43
4482	SpdBatZero_0_path1_T_H_OP250	NaN	NaN	{}	bool	A0-P1	X	6	13	43
4483	SpdBatZero_1_path1_T_H_OP250	NaN	NaN	{}	bool	A1-P1	Z	6	13	43
4484	SpdBatZero_2_path1_T_H_OP250	NaN	NaN	{}	bool	A2-P1	Y	6	13	43
6276	laser_line_v1_data_table	\N	\N	{}	\N	\N	\N	2	\N	64
4485	SpdBatZero_3_path1_T_H_OP250	NaN	NaN	{}	bool	A3-P1	YS	6	13	43
4486	SpdBatZero_4_path1_T_H_OP250	NaN	NaN	{}	bool	A4-P1	B	6	13	43
4487	SpdBatZero_5_path1_T_H_OP250	NaN	NaN	{}	bool	A5-P1	C	6	13	43
4488	SpdBatZero_6_path1_T_H_OP250	NaN	NaN	{}	bool	A6-P1	WMG	6	13	43
4489	SpdBatZero_7_path1_T_H_OP250	NaN	NaN	{}	bool	A7-P1	A2	6	13	43
4490	SSpdBatZero_0_path1_T_H_OP250	NaN	NaN	{}	bool	A0-P1	X	6	14	43
4491	SSpdBatZero_1_path1_T_H_OP250	NaN	NaN	{}	bool	A1-P1	Z	6	14	43
4492	SSpdBatZero_2_path1_T_H_OP250	NaN	NaN	{}	bool	A2-P1	Y	6	14	43
4493	SSpdBatZero_3_path1_T_H_OP250	NaN	NaN	{}	bool	A3-P1	YS	6	14	43
4494	SSpdBatZero_4_path1_T_H_OP250	NaN	NaN	{}	bool	A4-P1	B	6	14	43
4495	SSpdBatZero_5_path1_T_H_OP250	NaN	NaN	{}	bool	A5-P1	C	6	14	43
4496	SSpdBatZero_6_path1_T_H_OP250	NaN	NaN	{}	bool	A6-P1	WMG	6	14	43
4497	SSpdBatZero_7_path1_T_H_OP250	NaN	NaN	{}	bool	A7-P1	A2	6	14	43
4498	RadFan2SpindleAmpSpeed_0_path1_T_H_OP250	5000	4500	{}	decreasing	SP-P1	SP	2	16	43
4499	RadFan2SrvAmpSpeed_0_path1_T_H_OP250	5000	4500	{}	decreasing	A0-P1	X	2	16	43
4500	RadFan2SrvAmpSpeed_1_path1_T_H_OP250	5000	4500	{}	decreasing	A1-P1	Z	2	16	43
4501	RadFan2SrvAmpSpeed_2_path1_T_H_OP250	5000	4500	{}	decreasing	A2-P1	Y	2	16	43
4502	RadFan2SrvAmpSpeed_3_path1_T_H_OP250	5000	4500	{}	decreasing	A3-P1	YS	2	16	43
4503	RadFan2SrvAmpSpeed_4_path1_T_H_OP250	5000	4500	{}	decreasing	A4-P1	B	2	16	43
4504	RadFan2SrvAmpSpeed_5_path1_T_H_OP250	5000	4500	{}	decreasing	A5-P1	C	2	16	43
4505	RadFan2SrvAmpSpeed_6_path1_T_H_OP250	5000	4500	{}	decreasing	A6-P1	WMG	2	16	43
4506	RadFan2SrvAmpSpeed_7_path1_T_H_OP250	5000	4500	{}	decreasing	A7-P1	A2	2	16	43
4507	ApcBatLow_0_path1_T_H_OP250	NaN	NaN	{}	bool	A0-P1	X	6	1	43
4508	ApcBatLow_1_path1_T_H_OP250	NaN	NaN	{}	bool	A1-P1	Z	6	1	43
4509	ApcBatLow_2_path1_T_H_OP250	NaN	NaN	{}	bool	A2-P1	Y	6	1	43
4510	ApcBatLow_3_path1_T_H_OP250	NaN	NaN	{}	bool	A3-P1	YS	6	1	43
4511	ApcBatLow_4_path1_T_H_OP250	NaN	NaN	{}	bool	A4-P1	B	6	1	43
4512	ApcBatLow_5_path1_T_H_OP250	NaN	NaN	{}	bool	A5-P1	C	6	1	43
4513	ApcBatLow_6_path1_T_H_OP250	NaN	NaN	{}	bool	A6-P1	WMG	6	1	43
4514	ApcBatLow_7_path1_T_H_OP250	NaN	NaN	{}	bool	A7-P1	A2	6	1	43
4515	CncBatLow_0_path1_T_H_OP250	NaN	NaN	{}	bool	A0-P1	X	6	2	43
4516	CncBatLow_1_path1_T_H_OP250	NaN	NaN	{}	bool	A1-P1	Z	6	2	43
4517	CncBatLow_2_path1_T_H_OP250	NaN	NaN	{}	bool	A2-P1	Y	6	2	43
4518	CncBatLow_3_path1_T_H_OP250	NaN	NaN	{}	bool	A3-P1	YS	6	2	43
4519	CncBatLow_4_path1_T_H_OP250	NaN	NaN	{}	bool	A4-P1	B	6	2	43
4520	CncBatLow_5_path1_T_H_OP250	NaN	NaN	{}	bool	A5-P1	C	6	2	43
4521	CncBatLow_6_path1_T_H_OP250	NaN	NaN	{}	bool	A6-P1	WMG	6	2	43
4522	CncBatLow_7_path1_T_H_OP250	NaN	NaN	{}	bool	A7-P1	A2	6	2	43
4523	ServoLeakResistData_0_path1_T_H_OP250	50	30	{}	decreasing	A0-P1	X	15	5	43
4524	ServoLeakResistData_1_path1_T_H_OP250	50	30	{}	decreasing	A1-P1	Z	15	5	43
4525	ServoLeakResistData_2_path1_T_H_OP250	50	30	{}	decreasing	A2-P1	Y	15	5	43
4526	ServoLeakResistData_3_path1_T_H_OP250	50	30	{}	decreasing	A3-P1	YS	15	5	43
4527	ServoLeakResistData_4_path1_T_H_OP250	50	30	{}	decreasing	A4-P1	B	15	5	43
4528	ServoLeakResistData_5_path1_T_H_OP250	50	30	{}	decreasing	A5-P1	C	15	5	43
4529	ServoLeakResistData_6_path1_T_H_OP250	50	30	{}	decreasing	A6-P1	WMG	15	5	43
4530	ServoLeakResistData_7_path1_T_H_OP250	50	30	{}	decreasing	A7-P1	A2	15	5	43
4531	SpindleLeakResistData_0_path1_T_H_OP250	50	30	{}	decreasing	SP-P1	SP	15	5	43
4532	InFan1SrvComPwSpeed_0_path1_T_H_OP250	6200	6000	{}	decreasing	A0-P1	X	2	9	43
4533	InFan1SrvComPwSpeed_1_path1_T_H_OP250	6200	6000	{}	decreasing	A1-P1	Z	2	9	43
4534	InFan1SrvComPwSpeed_2_path1_T_H_OP250	6200	6000	{}	decreasing	A2-P1	Y	2	9	43
4535	InFan1SrvComPwSpeed_3_path1_T_H_OP250	6200	6000	{}	decreasing	A3-P1	YS	2	9	43
4536	InFan1SrvComPwSpeed_4_path1_T_H_OP250	6200	6000	{}	decreasing	A4-P1	B	2	9	43
4537	InFan1SrvComPwSpeed_5_path1_T_H_OP250	6200	6000	{}	decreasing	A5-P1	C	2	9	43
4538	InFan1SrvComPwSpeed_6_path1_T_H_OP250	6200	6000	{}	decreasing	A6-P1	WMG	2	9	43
4539	InFan1SrvComPwSpeed_7_path1_T_H_OP250	6200	6000	{}	decreasing	A7-P1	A2	2	9	43
4540	InFan2SrvAmpSpeed_0_path1_T_H_OP250	5000	4500	{}	decreasing	A0-P1	X	2	11	43
4541	InFan2SrvAmpSpeed_1_path1_T_H_OP250	5000	4500	{}	decreasing	A1-P1	Z	2	11	43
4542	InFan2SrvAmpSpeed_2_path1_T_H_OP250	5000	4500	{}	decreasing	A2-P1	Y	2	11	43
4543	InFan2SrvAmpSpeed_3_path1_T_H_OP250	5000	4500	{}	decreasing	A3-P1	YS	2	11	43
4544	InFan2SrvAmpSpeed_4_path1_T_H_OP250	5000	4500	{}	decreasing	A4-P1	B	2	11	43
4545	InFan2SrvAmpSpeed_5_path1_T_H_OP250	5000	4500	{}	decreasing	A5-P1	C	2	11	43
4546	InFan2SrvAmpSpeed_6_path1_T_H_OP250	5000	4500	{}	decreasing	A6-P1	WMG	2	11	43
4547	InFan2SrvAmpSpeed_7_path1_T_H_OP250	5000	4500	{}	decreasing	A7-P1	A2	2	11	43
4548	RadFan1SpindleAmpSpeed_0_path1_T_H_OP250	5000	4500	{}	decreasing	SP-P1	SP	2	15	43
4549	RadFan1SrvAmpSpeed_0_path1_T_H_OP250	5000	4500	{}	decreasing	A0-P1	X	2	15	43
4550	RadFan1SrvAmpSpeed_1_path1_T_H_OP250	5000	4500	{}	decreasing	A1-P1	Z	2	15	43
4551	RadFan1SrvAmpSpeed_2_path1_T_H_OP250	5000	4500	{}	decreasing	A2-P1	Y	2	15	43
4552	RadFan1SrvAmpSpeed_3_path1_T_H_OP250	5000	4500	{}	decreasing	A3-P1	YS	2	15	43
4553	RadFan1SrvAmpSpeed_4_path1_T_H_OP250	5000	4500	{}	decreasing	A4-P1	B	2	15	43
4554	RadFan1SrvAmpSpeed_5_path1_T_H_OP250	5000	4500	{}	decreasing	A5-P1	C	2	15	43
4555	RadFan1SrvAmpSpeed_6_path1_T_H_OP250	5000	4500	{}	decreasing	A6-P1	WMG	2	15	43
4556	RadFan1SrvAmpSpeed_7_path1_T_H_OP250	5000	4500	{}	decreasing	A7-P1	A2	2	15	43
4557	InFan2SpdlComPwSpeed_0_path1_T_H_OP250	5000	4500	{}	decreasing	A0-P1	SAS	2	10	43
4558	InFan2SpindleAmpSpeed_0_path1_T_H_OP250	5000	4500	{}	decreasing	A0-P1	SCS	2	10	43
4559	InFan2SrvComPwSpeed_0_path1_T_H_OP250	5000	4500	{}	decreasing	A0-P1	X	2	12	43
4560	InFan2SrvComPwSpeed_1_path1_T_H_OP250	5000	4500	{}	decreasing	A1-P1	Z	2	12	43
4561	InFan2SrvComPwSpeed_2_path1_T_H_OP250	5000	4500	{}	decreasing	A2-P1	Y	2	12	43
4562	InFan2SrvComPwSpeed_3_path1_T_H_OP250	5000	4500	{}	decreasing	A3-P1	YS	2	12	43
4563	InFan2SrvComPwSpeed_4_path1_T_H_OP250	5000	4500	{}	decreasing	A4-P1	B	2	12	43
4564	InFan2SrvComPwSpeed_5_path1_T_H_OP250	5000	4500	{}	decreasing	A5-P1	C	2	12	43
4565	InFan2SrvComPwSpeed_6_path1_T_H_OP250	5000	4500	{}	decreasing	A6-P1	WMG	2	12	43
4566	InFan2SrvComPwSpeed_7_path1_T_H_OP250	5000	4500	{}	decreasing	A7-P1	A2	2	12	43
4567	InFan1SpdlComPwSpeed_0_path1_T_H_OP250	5000	4500	{}	decreasing	A0-P1	SAS	2	7	43
4568	InFan1SpindleAmpSpeed_0_path1_T_H_OP250	6200	6000	{}	decreasing	A0-P1	SCS	2	7	43
4569	ServoTemp_0_path1_T_H_OP250	55	70	{}	increasing	A0-P1	X	13	3	43
4570	ServoTemp_1_path1_T_H_OP250	55	70	{}	increasing	A1-P1	Z	13	3	43
4571	ServoTemp_2_path1_T_H_OP250	55	70	{}	increasing	A2-P1	Y	13	3	43
4572	ServoTemp_3_path1_T_H_OP250	55	70	{}	increasing	A3-P1	YS	13	3	43
4573	ServoTemp_4_path1_T_H_OP250	55	70	{}	increasing	A4-P1	B	13	3	43
4574	ServoTemp_5_path1_T_H_OP250	55	70	{}	increasing	A5-P1	C	13	3	43
4575	ServoTemp_6_path1_T_H_OP250	55	70	{}	increasing	A6-P1	WMG	13	3	43
4576	ServoTemp_7_path1_T_H_OP250	55	70	{}	increasing	A7-P1	A2	13	3	43
4577	SpindleTemp_0_path1_T_H_OP250	80	100	{}	increasing	SP-P1	SP	13	3	43
4578	PulseCoderTemp_0_path1_T_H_OP260	60	80	{}	increasing	A0-P1	X	13	4	44
4579	PulseCoderTemp_1_path1_T_H_OP260	60	80	{}	increasing	A1-P1	Z	13	4	44
4580	PulseCoderTemp_2_path1_T_H_OP260	60	80	{}	increasing	A2-P1	Y	13	4	44
4581	PulseCoderTemp_3_path1_T_H_OP260	60	80	{}	increasing	A3-P1	YS	13	4	44
4582	PulseCoderTemp_4_path1_T_H_OP260	60	80	{}	increasing	A4-P1	B	13	4	44
4583	PulseCoderTemp_5_path1_T_H_OP260	60	80	{}	increasing	A5-P1	C	13	4	44
4584	PulseCoderTemp_6_path1_T_H_OP260	60	80	{}	increasing	A6-P1	WMG	13	4	44
4585	PulseCoderTemp_7_path1_T_H_OP260	60	80	{}	increasing	A7-P1	A2	13	4	44
4586	CncFan1Speed_path1_T_H_OP260	4500	4000	{}	decreasing	A1-P1	F1	16	6	44
4587	CncFan2Speed_path1_T_H_OP260	9600	8600	{}	decreasing	A2-P1	F2	16	6	44
4590	InFan1SrvAmpSpeed_0_path1_T_H_OP260	9500	9000	{}	decreasing	A0-P1	X	2	8	44
4591	InFan1SrvAmpSpeed_1_path1_T_H_OP260	9500	9000	{}	decreasing	A1-P1	Z	2	8	44
4592	InFan1SrvAmpSpeed_2_path1_T_H_OP260	9500	9000	{}	decreasing	A2-P1	Y	2	8	44
4593	InFan1SrvAmpSpeed_3_path1_T_H_OP260	9500	9000	{}	decreasing	A3-P1	YS	2	8	44
4594	InFan1SrvAmpSpeed_4_path1_T_H_OP260	8500	7500	{}	decreasing	A4-P1	B	2	8	44
4595	InFan1SrvAmpSpeed_5_path1_T_H_OP260	8500	7500	{}	decreasing	A5-P1	C	2	8	44
4596	InFan1SrvAmpSpeed_6_path1_T_H_OP260	8000	7500	{}	decreasing	A6-P1	WMG	2	8	44
4597	InFan1SrvAmpSpeed_7_path1_T_H_OP260	8500	7500	{}	decreasing	A7-P1	A2	2	8	44
4598	ServoLoad_0_path1_T_H_OP260	NaN	NaN	{}	increasing	A0-P1	X	17	17	44
4599	ServoLoad_1_path1_T_H_OP260	NaN	NaN	{}	increasing	A1-P1	Z	17	17	44
4600	ServoLoad_2_path1_T_H_OP260	NaN	NaN	{}	increasing	A2-P1	Y	17	17	44
4601	ServoLoad_3_path1_T_H_OP260	NaN	NaN	{}	increasing	A3-P1	YS	17	17	44
4602	ServoLoad_4_path1_T_H_OP260	NaN	NaN	{}	increasing	A4-P1	B	17	17	44
4603	ServoLoad_5_path1_T_H_OP260	NaN	NaN	{}	increasing	A5-P1	C	17	17	44
4604	ServoLoad_6_path1_T_H_OP260	NaN	NaN	{}	increasing	A6-P1	WMG	17	17	44
4605	ServoLoad_7_path1_T_H_OP260	NaN	NaN	{}	increasing	A7-P1	A2	17	17	44
4606	SpindleLoad_0_path1_T_H_OP260	NaN	NaN	{}	increasing	SP-P1	SP	17	17	44
4607	SpdBatZero_0_path1_T_H_OP260	NaN	NaN	{}	bool	A0-P1	X	6	13	44
4608	SpdBatZero_1_path1_T_H_OP260	NaN	NaN	{}	bool	A1-P1	Z	6	13	44
4609	SpdBatZero_2_path1_T_H_OP260	NaN	NaN	{}	bool	A2-P1	Y	6	13	44
4610	SpdBatZero_3_path1_T_H_OP260	NaN	NaN	{}	bool	A3-P1	YS	6	13	44
6277	laser_line_v2_data_table	\N	\N	{}	\N	\N	\N	2	\N	64
4611	SpdBatZero_4_path1_T_H_OP260	NaN	NaN	{}	bool	A4-P1	B	6	13	44
4612	SpdBatZero_5_path1_T_H_OP260	NaN	NaN	{}	bool	A5-P1	C	6	13	44
4613	SpdBatZero_6_path1_T_H_OP260	NaN	NaN	{}	bool	A6-P1	WMG	6	13	44
4614	SpdBatZero_7_path1_T_H_OP260	NaN	NaN	{}	bool	A7-P1	A2	6	13	44
4615	SSpdBatZero_0_path1_T_H_OP260	NaN	NaN	{}	bool	A0-P1	X	6	14	44
4616	SSpdBatZero_1_path1_T_H_OP260	NaN	NaN	{}	bool	A1-P1	Z	6	14	44
4617	SSpdBatZero_2_path1_T_H_OP260	NaN	NaN	{}	bool	A2-P1	Y	6	14	44
4618	SSpdBatZero_3_path1_T_H_OP260	NaN	NaN	{}	bool	A3-P1	YS	6	14	44
4619	SSpdBatZero_4_path1_T_H_OP260	NaN	NaN	{}	bool	A4-P1	B	6	14	44
4620	SSpdBatZero_5_path1_T_H_OP260	NaN	NaN	{}	bool	A5-P1	C	6	14	44
4621	SSpdBatZero_6_path1_T_H_OP260	NaN	NaN	{}	bool	A6-P1	WMG	6	14	44
4622	SSpdBatZero_7_path1_T_H_OP260	NaN	NaN	{}	bool	A7-P1	A2	6	14	44
4623	RadFan2SpindleAmpSpeed_0_path1_T_H_OP260	5000	4500	{}	decreasing	SP-P1	SP	2	16	44
4624	RadFan2SrvAmpSpeed_0_path1_T_H_OP260	5000	4500	{}	decreasing	A0-P1	X	2	16	44
4625	RadFan2SrvAmpSpeed_1_path1_T_H_OP260	5000	4500	{}	decreasing	A1-P1	Z	2	16	44
4626	RadFan2SrvAmpSpeed_2_path1_T_H_OP260	5000	4500	{}	decreasing	A2-P1	Y	2	16	44
4627	RadFan2SrvAmpSpeed_3_path1_T_H_OP260	5000	4500	{}	decreasing	A3-P1	YS	2	16	44
4628	RadFan2SrvAmpSpeed_4_path1_T_H_OP260	5000	4500	{}	decreasing	A4-P1	B	2	16	44
4629	RadFan2SrvAmpSpeed_5_path1_T_H_OP260	5000	4500	{}	decreasing	A5-P1	C	2	16	44
4630	RadFan2SrvAmpSpeed_6_path1_T_H_OP260	5000	4500	{}	decreasing	A6-P1	WMG	2	16	44
4631	RadFan2SrvAmpSpeed_7_path1_T_H_OP260	5000	4500	{}	decreasing	A7-P1	A2	2	16	44
4632	ApcBatLow_0_path1_T_H_OP260	NaN	NaN	{}	bool	A0-P1	X	6	1	44
4633	ApcBatLow_1_path1_T_H_OP260	NaN	NaN	{}	bool	A1-P1	Z	6	1	44
4634	ApcBatLow_2_path1_T_H_OP260	NaN	NaN	{}	bool	A2-P1	Y	6	1	44
4635	ApcBatLow_3_path1_T_H_OP260	NaN	NaN	{}	bool	A3-P1	YS	6	1	44
4636	ApcBatLow_4_path1_T_H_OP260	NaN	NaN	{}	bool	A4-P1	B	6	1	44
4637	ApcBatLow_5_path1_T_H_OP260	NaN	NaN	{}	bool	A5-P1	C	6	1	44
4638	ApcBatLow_6_path1_T_H_OP260	NaN	NaN	{}	bool	A6-P1	WMG	6	1	44
4639	ApcBatLow_7_path1_T_H_OP260	NaN	NaN	{}	bool	A7-P1	A2	6	1	44
4640	CncBatLow_0_path1_T_H_OP260	NaN	NaN	{}	bool	A0-P1	X	6	2	44
4641	CncBatLow_1_path1_T_H_OP260	NaN	NaN	{}	bool	A1-P1	Z	6	2	44
4642	CncBatLow_2_path1_T_H_OP260	NaN	NaN	{}	bool	A2-P1	Y	6	2	44
4643	CncBatLow_3_path1_T_H_OP260	NaN	NaN	{}	bool	A3-P1	YS	6	2	44
4644	CncBatLow_4_path1_T_H_OP260	NaN	NaN	{}	bool	A4-P1	B	6	2	44
4645	CncBatLow_5_path1_T_H_OP260	NaN	NaN	{}	bool	A5-P1	C	6	2	44
4646	CncBatLow_6_path1_T_H_OP260	NaN	NaN	{}	bool	A6-P1	WMG	6	2	44
4647	CncBatLow_7_path1_T_H_OP260	NaN	NaN	{}	bool	A7-P1	A2	6	2	44
4648	ServoLeakResistData_0_path1_T_H_OP260	50	30	{}	decreasing	A0-P1	X	15	5	44
4649	ServoLeakResistData_1_path1_T_H_OP260	50	30	{}	decreasing	A1-P1	Z	15	5	44
4650	ServoLeakResistData_2_path1_T_H_OP260	50	30	{}	decreasing	A2-P1	Y	15	5	44
4651	ServoLeakResistData_3_path1_T_H_OP260	50	30	{}	decreasing	A3-P1	YS	15	5	44
4652	ServoLeakResistData_4_path1_T_H_OP260	50	30	{}	decreasing	A4-P1	B	15	5	44
4653	ServoLeakResistData_5_path1_T_H_OP260	50	30	{}	decreasing	A5-P1	C	15	5	44
4654	ServoLeakResistData_6_path1_T_H_OP260	50	30	{}	decreasing	A6-P1	WMG	15	5	44
4655	ServoLeakResistData_7_path1_T_H_OP260	50	30	{}	decreasing	A7-P1	A2	15	5	44
4656	SpindleLeakResistData_0_path1_T_H_OP260	50	30	{}	decreasing	SP-P1	SP	15	5	44
4657	InFan1SrvComPwSpeed_0_path1_T_H_OP260	6200	6000	{}	decreasing	A0-P1	X	2	9	44
4658	InFan1SrvComPwSpeed_1_path1_T_H_OP260	6200	6000	{}	decreasing	A1-P1	Z	2	9	44
4659	InFan1SrvComPwSpeed_2_path1_T_H_OP260	6200	6000	{}	decreasing	A2-P1	Y	2	9	44
4660	InFan1SrvComPwSpeed_3_path1_T_H_OP260	6200	6000	{}	decreasing	A3-P1	YS	2	9	44
4661	InFan1SrvComPwSpeed_4_path1_T_H_OP260	6200	6000	{}	decreasing	A4-P1	B	2	9	44
4662	InFan1SrvComPwSpeed_5_path1_T_H_OP260	6200	6000	{}	decreasing	A5-P1	C	2	9	44
4663	InFan1SrvComPwSpeed_6_path1_T_H_OP260	6200	6000	{}	decreasing	A6-P1	WMG	2	9	44
4664	InFan1SrvComPwSpeed_7_path1_T_H_OP260	6200	6000	{}	decreasing	A7-P1	A2	2	9	44
4665	InFan2SrvAmpSpeed_0_path1_T_H_OP260	5000	4500	{}	decreasing	A0-P1	X	2	11	44
4666	InFan2SrvAmpSpeed_1_path1_T_H_OP260	5000	4500	{}	decreasing	A1-P1	Z	2	11	44
4667	InFan2SrvAmpSpeed_2_path1_T_H_OP260	5000	4500	{}	decreasing	A2-P1	Y	2	11	44
4668	InFan2SrvAmpSpeed_3_path1_T_H_OP260	5000	4500	{}	decreasing	A3-P1	YS	2	11	44
4669	InFan2SrvAmpSpeed_4_path1_T_H_OP260	5000	4500	{}	decreasing	A4-P1	B	2	11	44
4670	InFan2SrvAmpSpeed_5_path1_T_H_OP260	5000	4500	{}	decreasing	A5-P1	C	2	11	44
4671	InFan2SrvAmpSpeed_6_path1_T_H_OP260	5000	4500	{}	decreasing	A6-P1	WMG	2	11	44
4672	InFan2SrvAmpSpeed_7_path1_T_H_OP260	5000	4500	{}	decreasing	A7-P1	A2	2	11	44
6278	laser_line_v3_data_table	\N	\N	{}	\N	\N	\N	2	\N	64
4673	RadFan1SpindleAmpSpeed_0_path1_T_H_OP260	5000	4500	{}	decreasing	SP-P1	SP	2	15	44
4674	RadFan1SrvAmpSpeed_0_path1_T_H_OP260	5000	4500	{}	decreasing	A0-P1	X	2	15	44
4675	RadFan1SrvAmpSpeed_1_path1_T_H_OP260	5000	4500	{}	decreasing	A1-P1	Z	2	15	44
4676	RadFan1SrvAmpSpeed_2_path1_T_H_OP260	5000	4500	{}	decreasing	A2-P1	Y	2	15	44
4677	RadFan1SrvAmpSpeed_3_path1_T_H_OP260	5000	4500	{}	decreasing	A3-P1	YS	2	15	44
4678	RadFan1SrvAmpSpeed_4_path1_T_H_OP260	5000	4500	{}	decreasing	A4-P1	B	2	15	44
4679	RadFan1SrvAmpSpeed_5_path1_T_H_OP260	5000	4500	{}	decreasing	A5-P1	C	2	15	44
4680	RadFan1SrvAmpSpeed_6_path1_T_H_OP260	5000	4500	{}	decreasing	A6-P1	WMG	2	15	44
4681	RadFan1SrvAmpSpeed_7_path1_T_H_OP260	5000	4500	{}	decreasing	A7-P1	A2	2	15	44
4682	InFan2SpdlComPwSpeed_0_path1_T_H_OP260	5000	4500	{}	decreasing	A0-P1	SAS	2	10	44
4683	InFan2SpindleAmpSpeed_0_path1_T_H_OP260	5000	4500	{}	decreasing	A0-P1	SCS	2	10	44
4684	InFan2SrvComPwSpeed_0_path1_T_H_OP260	5000	4500	{}	decreasing	A0-P1	X	2	12	44
4685	InFan2SrvComPwSpeed_1_path1_T_H_OP260	5000	4500	{}	decreasing	A1-P1	Z	2	12	44
4686	InFan2SrvComPwSpeed_2_path1_T_H_OP260	5000	4500	{}	decreasing	A2-P1	Y	2	12	44
4687	InFan2SrvComPwSpeed_3_path1_T_H_OP260	5000	4500	{}	decreasing	A3-P1	YS	2	12	44
4688	InFan2SrvComPwSpeed_4_path1_T_H_OP260	5000	4500	{}	decreasing	A4-P1	B	2	12	44
4689	InFan2SrvComPwSpeed_5_path1_T_H_OP260	5000	4500	{}	decreasing	A5-P1	C	2	12	44
4690	InFan2SrvComPwSpeed_6_path1_T_H_OP260	5000	4500	{}	decreasing	A6-P1	WMG	2	12	44
4691	InFan2SrvComPwSpeed_7_path1_T_H_OP260	5000	4500	{}	decreasing	A7-P1	A2	2	12	44
4692	InFan1SpdlComPwSpeed_0_path1_T_H_OP260	5000	4500	{}	decreasing	A0-P1	SAS	2	7	44
4693	InFan1SpindleAmpSpeed_0_path1_T_H_OP260	6200	6000	{}	decreasing	A0-P1	SCS	2	7	44
4694	ServoTemp_0_path1_T_H_OP260	55	70	{}	increasing	A0-P1	X	13	3	44
4695	ServoTemp_1_path1_T_H_OP260	55	70	{}	increasing	A1-P1	Z	13	3	44
4696	ServoTemp_2_path1_T_H_OP260	55	70	{}	increasing	A2-P1	Y	13	3	44
4697	ServoTemp_3_path1_T_H_OP260	55	70	{}	increasing	A3-P1	YS	13	3	44
4698	ServoTemp_4_path1_T_H_OP260	55	70	{}	increasing	A4-P1	B	13	3	44
4699	ServoTemp_5_path1_T_H_OP260	55	70	{}	increasing	A5-P1	C	13	3	44
4700	ServoTemp_6_path1_T_H_OP260	55	70	{}	increasing	A6-P1	WMG	13	3	44
4701	ServoTemp_7_path1_T_H_OP260	55	70	{}	increasing	A7-P1	A2	13	3	44
4702	SpindleTemp_0_path1_T_H_OP260	80	100	{}	increasing	SP-P1	SP	13	3	44
4703	PulseCoderTemp_0_path1_T_H_OP270	60	80	{}	increasing	A0-P1	X	13	4	45
4704	PulseCoderTemp_1_path1_T_H_OP270	60	80	{}	increasing	A1-P1	Z	13	4	45
4705	PulseCoderTemp_2_path1_T_H_OP270	60	80	{}	increasing	A2-P1	Y	13	4	45
4706	PulseCoderTemp_3_path1_T_H_OP270	75	85	{}	increasing	A3-P1	YS	13	4	45
4708	PulseCoderTemp_5_path1_T_H_OP270	60	80	{}	increasing	A5-P1	BMG	13	4	45
4709	PulseCoderTemp_6_path1_T_H_OP270	60	80	{}	increasing	A6-P1	A2	13	4	45
4710	PulseCoderTemp_7_path1_T_H_OP270	60	80	{}	increasing	A7-P1	AT	13	4	45
4711	CncFan1Speed_path1_T_H_OP270	4500	4000	{}	decreasing	A1-P1	F1	16	6	45
4712	CncFan2Speed_path1_T_H_OP270	9600	8600	{}	decreasing	A2-P1	F3	16	6	45
4715	InFan1SrvAmpSpeed_0_path1_T_H_OP270	9500	9000	{}	decreasing	A0-P1	X	2	8	45
4716	InFan1SrvAmpSpeed_1_path1_T_H_OP270	9500	9000	{}	decreasing	A1-P1	Z	2	8	45
4717	InFan1SrvAmpSpeed_2_path1_T_H_OP270	9500	9000	{}	decreasing	A2-P1	Y	2	8	45
4718	InFan1SrvAmpSpeed_3_path1_T_H_OP270	9500	9000	{}	decreasing	A3-P1	YS	2	8	45
4720	InFan1SrvAmpSpeed_5_path1_T_H_OP270	8500	7500	{}	decreasing	A5-P1	BMG	2	8	45
4721	InFan1SrvAmpSpeed_6_path1_T_H_OP270	8000	7500	{}	decreasing	A6-P1	A2	2	8	45
4722	InFan1SrvAmpSpeed_7_path1_T_H_OP270	8500	7500	{}	decreasing	A7-P1	AT	2	8	45
4723	ServoLoad_0_path1_T_H_OP270	NaN	NaN	{}	increasing	A0-P1	X	17	17	45
4724	ServoLoad_1_path1_T_H_OP270	NaN	NaN	{}	increasing	A1-P1	Z	17	17	45
4725	ServoLoad_2_path1_T_H_OP270	NaN	NaN	{}	increasing	A2-P1	Y	17	17	45
4726	ServoLoad_3_path1_T_H_OP270	NaN	NaN	{}	increasing	A3-P1	YS	17	17	45
4728	ServoLoad_5_path1_T_H_OP270	NaN	NaN	{}	increasing	A5-P1	BMG	17	17	45
4729	ServoLoad_6_path1_T_H_OP270	NaN	NaN	{}	increasing	A6-P1	A2	17	17	45
4730	ServoLoad_7_path1_T_H_OP270	NaN	NaN	{}	increasing	A7-P1	AT	17	17	45
4731	SpindleLoad_0_path1_T_H_OP270	NaN	NaN	{}	increasing	SP-P1	SP	17	17	45
4732	SpdBatZero_0_path1_T_H_OP270	NaN	NaN	{}	bool	A0-P1	X	6	13	45
4733	SpdBatZero_1_path1_T_H_OP270	NaN	NaN	{}	bool	A1-P1	Z	6	13	45
4734	SpdBatZero_2_path1_T_H_OP270	NaN	NaN	{}	bool	A2-P1	Y	6	13	45
4735	SpdBatZero_3_path1_T_H_OP270	NaN	NaN	{}	bool	A3-P1	YS	6	13	45
4737	SpdBatZero_5_path1_T_H_OP270	NaN	NaN	{}	bool	A5-P1	BMG	6	13	45
4738	SpdBatZero_6_path1_T_H_OP270	NaN	NaN	{}	bool	A6-P1	A2	6	13	45
4739	SpdBatZero_7_path1_T_H_OP270	NaN	NaN	{}	bool	A7-P1	AT	6	13	45
4740	SSpdBatZero_0_path1_T_H_OP270	NaN	NaN	{}	bool	A0-P1	X	6	14	45
4741	SSpdBatZero_1_path1_T_H_OP270	NaN	NaN	{}	bool	A1-P1	Z	6	14	45
4742	SSpdBatZero_2_path1_T_H_OP270	NaN	NaN	{}	bool	A2-P1	Y	6	14	45
4743	SSpdBatZero_3_path1_T_H_OP270	NaN	NaN	{}	bool	A3-P1	YS	6	14	45
4745	SSpdBatZero_5_path1_T_H_OP270	NaN	NaN	{}	bool	A5-P1	BMG	6	14	45
4746	SSpdBatZero_6_path1_T_H_OP270	NaN	NaN	{}	bool	A6-P1	A2	6	14	45
4747	SSpdBatZero_7_path1_T_H_OP270	NaN	NaN	{}	bool	A7-P1	AT	6	14	45
4748	RadFan2SpindleAmpSpeed_0_path1_T_H_OP270	5000	4500	{}	decreasing	SP-P1	SP	2	16	45
4749	RadFan2SrvAmpSpeed_0_path1_T_H_OP270	5000	4500	{}	decreasing	A0-P1	X	2	16	45
4750	RadFan2SrvAmpSpeed_1_path1_T_H_OP270	5000	4500	{}	decreasing	A1-P1	Z	2	16	45
4751	RadFan2SrvAmpSpeed_2_path1_T_H_OP270	5000	4500	{}	decreasing	A2-P1	Y	2	16	45
4752	RadFan2SrvAmpSpeed_3_path1_T_H_OP270	5000	4500	{}	decreasing	A3-P1	YS	2	16	45
4754	RadFan2SrvAmpSpeed_5_path1_T_H_OP270	5000	4500	{}	decreasing	A5-P1	BMG	2	16	45
4755	RadFan2SrvAmpSpeed_6_path1_T_H_OP270	5000	4500	{}	decreasing	A6-P1	A2	2	16	45
4756	RadFan2SrvAmpSpeed_7_path1_T_H_OP270	5000	4500	{}	decreasing	A7-P1	AT	2	16	45
4757	ApcBatLow_0_path1_T_H_OP270	NaN	NaN	{}	bool	A0-P1	X	6	1	45
4758	ApcBatLow_1_path1_T_H_OP270	NaN	NaN	{}	bool	A1-P1	Z	6	1	45
4759	ApcBatLow_2_path1_T_H_OP270	NaN	NaN	{}	bool	A2-P1	Y	6	1	45
4760	ApcBatLow_3_path1_T_H_OP270	NaN	NaN	{}	bool	A3-P1	YS	6	1	45
4762	ApcBatLow_5_path1_T_H_OP270	NaN	NaN	{}	bool	A5-P1	BMG	6	1	45
4763	ApcBatLow_6_path1_T_H_OP270	NaN	NaN	{}	bool	A6-P1	A2	6	1	45
4764	ApcBatLow_7_path1_T_H_OP270	NaN	NaN	{}	bool	A7-P1	AT	6	1	45
4765	CncBatLow_0_path1_T_H_OP270	NaN	NaN	{}	bool	A0-P1	X	6	2	45
4766	CncBatLow_1_path1_T_H_OP270	NaN	NaN	{}	bool	A1-P1	Z	6	2	45
4767	CncBatLow_2_path1_T_H_OP270	NaN	NaN	{}	bool	A2-P1	Y	6	2	45
4768	CncBatLow_3_path1_T_H_OP270	NaN	NaN	{}	bool	A3-P1	YS	6	2	45
4770	CncBatLow_5_path1_T_H_OP270	NaN	NaN	{}	bool	A5-P1	BMG	6	2	45
4771	CncBatLow_6_path1_T_H_OP270	NaN	NaN	{}	bool	A6-P1	A2	6	2	45
4772	CncBatLow_7_path1_T_H_OP270	NaN	NaN	{}	bool	A7-P1	AT	6	2	45
4773	ServoLeakResistData_0_path1_T_H_OP270	50	30	{}	decreasing	A0-P1	X	15	5	45
4774	ServoLeakResistData_1_path1_T_H_OP270	50	30	{}	decreasing	A1-P1	Z	15	5	45
4775	ServoLeakResistData_2_path1_T_H_OP270	50	30	{}	decreasing	A2-P1	Y	15	5	45
4776	ServoLeakResistData_3_path1_T_H_OP270	50	30	{}	decreasing	A3-P1	YS	15	5	45
4778	ServoLeakResistData_5_path1_T_H_OP270	50	30	{}	decreasing	A5-P1	BMG	15	5	45
4779	ServoLeakResistData_6_path1_T_H_OP270	50	30	{}	decreasing	A6-P1	A2	15	5	45
4780	ServoLeakResistData_7_path1_T_H_OP270	50	30	{}	decreasing	A7-P1	AT	15	5	45
4781	SpindleLeakResistData_0_path1_T_H_OP270	50	30	{}	decreasing	SP-P1	SP	15	5	45
4782	InFan1SrvComPwSpeed_0_path1_T_H_OP270	6200	6000	{}	decreasing	A0-P1	X	2	9	45
4783	InFan1SrvComPwSpeed_1_path1_T_H_OP270	6200	6000	{}	decreasing	A1-P1	Z	2	9	45
4784	InFan1SrvComPwSpeed_2_path1_T_H_OP270	6200	6000	{}	decreasing	A2-P1	Y	2	9	45
4785	InFan1SrvComPwSpeed_3_path1_T_H_OP270	6200	6000	{}	decreasing	A3-P1	YS	2	9	45
4787	InFan1SrvComPwSpeed_5_path1_T_H_OP270	6200	6000	{}	decreasing	A5-P1	BMG	2	9	45
4788	InFan1SrvComPwSpeed_6_path1_T_H_OP270	6200	6000	{}	decreasing	A6-P1	A2	2	9	45
4789	InFan1SrvComPwSpeed_7_path1_T_H_OP270	6200	6000	{}	decreasing	A7-P1	AT	2	9	45
4790	InFan2SrvAmpSpeed_0_path1_T_H_OP270	5000	4500	{}	decreasing	A0-P1	X	2	11	45
4791	InFan2SrvAmpSpeed_1_path1_T_H_OP270	5000	4500	{}	decreasing	A1-P1	Z	2	11	45
4792	InFan2SrvAmpSpeed_2_path1_T_H_OP270	5000	4500	{}	decreasing	A2-P1	Y	2	11	45
4793	InFan2SrvAmpSpeed_3_path1_T_H_OP270	5000	4500	{}	decreasing	A3-P1	YS	2	11	45
4795	InFan2SrvAmpSpeed_5_path1_T_H_OP270	5000	4500	{}	decreasing	A5-P1	BMG	2	11	45
4796	InFan2SrvAmpSpeed_6_path1_T_H_OP270	5000	4500	{}	decreasing	A6-P1	A2	2	11	45
4797	InFan2SrvAmpSpeed_7_path1_T_H_OP270	5000	4500	{}	decreasing	A7-P1	AT	2	11	45
4798	RadFan1SpindleAmpSpeed_0_path1_T_H_OP270	5000	4500	{}	decreasing	SP-P1	SP	2	15	45
4799	RadFan1SrvAmpSpeed_0_path1_T_H_OP270	5000	4500	{}	decreasing	A0-P1	X	2	15	45
4800	RadFan1SrvAmpSpeed_1_path1_T_H_OP270	5000	4500	{}	decreasing	A1-P1	Z	2	15	45
4801	RadFan1SrvAmpSpeed_2_path1_T_H_OP270	5000	4500	{}	decreasing	A2-P1	Y	2	15	45
4802	RadFan1SrvAmpSpeed_3_path1_T_H_OP270	5000	4500	{}	decreasing	A3-P1	YS	2	15	45
4804	RadFan1SrvAmpSpeed_5_path1_T_H_OP270	5000	4500	{}	decreasing	A5-P1	BMG	2	15	45
4805	RadFan1SrvAmpSpeed_6_path1_T_H_OP270	5000	4500	{}	decreasing	A6-P1	A2	2	15	45
4806	RadFan1SrvAmpSpeed_7_path1_T_H_OP270	5000	4500	{}	decreasing	A7-P1	AT	2	15	45
4807	InFan2SpdlComPwSpeed_0_path1_T_H_OP270	5000	4500	{}	decreasing	A0-P1	SAS	2	10	45
4808	InFan2SpindleAmpSpeed_0_path1_T_H_OP270	5000	4500	{}	decreasing	A0-P1	SCS	2	10	45
4809	InFan2SrvComPwSpeed_0_path1_T_H_OP270	5000	4500	{}	decreasing	A0-P1	X	2	12	45
6279	feeder_t0_data_table	\N	\N	{}	\N	\N	\N	9	\N	64
4810	InFan2SrvComPwSpeed_1_path1_T_H_OP270	5000	4500	{}	decreasing	A1-P1	Z	2	12	45
4811	InFan2SrvComPwSpeed_2_path1_T_H_OP270	5000	4500	{}	decreasing	A2-P1	Y	2	12	45
4812	InFan2SrvComPwSpeed_3_path1_T_H_OP270	5000	4500	{}	decreasing	A3-P1	YS	2	12	45
4814	InFan2SrvComPwSpeed_5_path1_T_H_OP270	5000	4500	{}	decreasing	A5-P1	BMG	2	12	45
4815	InFan2SrvComPwSpeed_6_path1_T_H_OP270	5000	4500	{}	decreasing	A6-P1	A2	2	12	45
4816	InFan2SrvComPwSpeed_7_path1_T_H_OP270	5000	4500	{}	decreasing	A7-P1	AT	2	12	45
4817	InFan1SpdlComPwSpeed_0_path1_T_H_OP270	5000	4500	{}	decreasing	A0-P1	SAS	2	7	45
4818	InFan1SpindleAmpSpeed_0_path1_T_H_OP270	6200	6000	{}	decreasing	A0-P1	SCS	2	7	45
4819	ServoTemp_0_path1_T_H_OP270	55	70	{}	increasing	A0-P1	X	13	3	45
4820	ServoTemp_1_path1_T_H_OP270	55	70	{}	increasing	A1-P1	Z	13	3	45
4821	ServoTemp_2_path1_T_H_OP270	55	70	{}	increasing	A2-P1	Y	13	3	45
4822	ServoTemp_3_path1_T_H_OP270	70	80	{}	increasing	A3-P1	YS	13	3	45
4824	ServoTemp_5_path1_T_H_OP270	55	70	{}	increasing	A5-P1	BMG	13	3	45
4825	ServoTemp_6_path1_T_H_OP270	55	70	{}	increasing	A6-P1	A2	13	3	45
4826	ServoTemp_7_path1_T_H_OP270	55	70	{}	increasing	A7-P1	AT	13	3	45
4827	SpindleTemp_0_path1_T_H_OP270	80	100	{}	increasing	SP-P1	SP	13	3	45
4828	PulseCoderTemp_0_path1_T_H_OP280	73	83	{}	increasing	A0-P1	X	13	4	46
4829	PulseCoderTemp_1_path1_T_H_OP280	60	80	{}	increasing	A1-P1	Y	13	4	46
4830	PulseCoderTemp_2_path1_T_H_OP280	70	80	{}	increasing	A2-P1	Z	13	4	46
4831	PulseCoderTemp_3_path1_T_H_OP280	60	80	{}	increasing	A3-P1	A	13	4	46
4832	PulseCoderTemp_4_path1_T_H_OP280	60	80	{}	increasing	A4-P1	JS	13	4	46
4836	CncFan1Speed_path1_T_H_OP280	4500	4000	{}	decreasing	A1-P1	F1	16	6	46
4837	CncFan2Speed_path1_T_H_OP280	9600	8600	{}	decreasing	A2-P1	F2	16	6	46
4840	InFan1SrvAmpSpeed_0_path1_T_H_OP280	9500	9000	{}	decreasing	A0-P1	X	2	8	46
4841	InFan1SrvAmpSpeed_1_path1_T_H_OP280	9500	9000	{}	decreasing	A1-P1	Y	2	8	46
4842	InFan1SrvAmpSpeed_2_path1_T_H_OP280	9500	9000	{}	decreasing	A2-P1	Z	2	8	46
4843	InFan1SrvAmpSpeed_3_path1_T_H_OP280	9500	9000	{}	decreasing	A3-P1	A	2	8	46
4844	InFan1SrvAmpSpeed_4_path1_T_H_OP280	8500	7500	{}	decreasing	A4-P1	JS	2	8	46
4848	ServoLoad_0_path1_T_H_OP280	NaN	NaN	{}	increasing	A0-P1	X	17	17	46
4849	ServoLoad_1_path1_T_H_OP280	NaN	NaN	{}	increasing	A1-P1	Y	17	17	46
4850	ServoLoad_2_path1_T_H_OP280	NaN	NaN	{}	increasing	A2-P1	Z	17	17	46
4851	ServoLoad_3_path1_T_H_OP280	NaN	NaN	{}	increasing	A3-P1	A	17	17	46
4852	ServoLoad_4_path1_T_H_OP280	NaN	NaN	{}	increasing	A4-P1	JS	17	17	46
4856	SpindleLoad_0_path1_T_H_OP280	NaN	NaN	{}	increasing	SP-P1	SP	17	17	46
4857	SpdBatZero_0_path1_T_H_OP280	NaN	NaN	{}	bool	A0-P1	X	6	13	46
4858	SpdBatZero_1_path1_T_H_OP280	NaN	NaN	{}	bool	A1-P1	Y	6	13	46
4859	SpdBatZero_2_path1_T_H_OP280	NaN	NaN	{}	bool	A2-P1	Z	6	13	46
4860	SpdBatZero_3_path1_T_H_OP280	NaN	NaN	{}	bool	A3-P1	A	6	13	46
4861	SpdBatZero_4_path1_T_H_OP280	NaN	NaN	{}	bool	A4-P1	JS	6	13	46
4865	SSpdBatZero_0_path1_T_H_OP280	NaN	NaN	{}	bool	A0-P1	X	6	14	46
4866	SSpdBatZero_1_path1_T_H_OP280	NaN	NaN	{}	bool	A1-P1	Y	6	14	46
4867	SSpdBatZero_2_path1_T_H_OP280	NaN	NaN	{}	bool	A2-P1	Z	6	14	46
4868	SSpdBatZero_3_path1_T_H_OP280	NaN	NaN	{}	bool	A3-P1	A	6	14	46
4869	SSpdBatZero_4_path1_T_H_OP280	NaN	NaN	{}	bool	A4-P1	JS	6	14	46
4873	RadFan2SpindleAmpSpeed_0_path1_T_H_OP280	5000	4500	{}	decreasing	SP-P1	SP	2	16	46
4874	RadFan2SrvAmpSpeed_0_path1_T_H_OP280	5000	4500	{}	decreasing	A0-P1	X	2	16	46
4875	RadFan2SrvAmpSpeed_1_path1_T_H_OP280	5000	4500	{}	decreasing	A1-P1	Y	2	16	46
4876	RadFan2SrvAmpSpeed_2_path1_T_H_OP280	5000	4500	{}	decreasing	A2-P1	Z	2	16	46
4877	RadFan2SrvAmpSpeed_3_path1_T_H_OP280	5000	4500	{}	decreasing	A3-P1	A	2	16	46
4878	RadFan2SrvAmpSpeed_4_path1_T_H_OP280	5000	4500	{}	decreasing	A4-P1	JS	2	16	46
4882	ApcBatLow_0_path1_T_H_OP280	NaN	NaN	{}	bool	A0-P1	X	6	1	46
4883	ApcBatLow_1_path1_T_H_OP280	NaN	NaN	{}	bool	A1-P1	Y	6	1	46
4884	ApcBatLow_2_path1_T_H_OP280	NaN	NaN	{}	bool	A2-P1	Z	6	1	46
4885	ApcBatLow_3_path1_T_H_OP280	NaN	NaN	{}	bool	A3-P1	A	6	1	46
4886	ApcBatLow_4_path1_T_H_OP280	NaN	NaN	{}	bool	A4-P1	JS	6	1	46
4890	CncBatLow_0_path1_T_H_OP280	NaN	NaN	{}	bool	A0-P1	X	6	2	46
4891	CncBatLow_1_path1_T_H_OP280	NaN	NaN	{}	bool	A1-P1	Y	6	2	46
4892	CncBatLow_2_path1_T_H_OP280	NaN	NaN	{}	bool	A2-P1	Z	6	2	46
4893	CncBatLow_3_path1_T_H_OP280	NaN	NaN	{}	bool	A3-P1	A	6	2	46
4894	CncBatLow_4_path1_T_H_OP280	NaN	NaN	{}	bool	A4-P1	JS	6	2	46
4898	ServoLeakResistData_0_path1_T_H_OP280	50	30	{}	decreasing	A0-P1	X	15	5	46
4899	ServoLeakResistData_1_path1_T_H_OP280	50	30	{}	decreasing	A1-P1	Y	15	5	46
4900	ServoLeakResistData_2_path1_T_H_OP280	50	30	{}	decreasing	A2-P1	Z	15	5	46
4901	ServoLeakResistData_3_path1_T_H_OP280	50	30	{}	decreasing	A3-P1	A	15	5	46
4902	ServoLeakResistData_4_path1_T_H_OP280	50	30	{}	decreasing	A4-P1	JS	15	5	46
4906	SpindleLeakResistData_0_path1_T_H_OP280	50	30	{}	decreasing	SP-P1	SP	15	5	46
4907	InFan1SrvComPwSpeed_0_path1_T_H_OP280	6200	6000	{}	decreasing	A0-P1	X	2	9	46
4908	InFan1SrvComPwSpeed_1_path1_T_H_OP280	6200	6000	{}	decreasing	A1-P1	Y	2	9	46
4909	InFan1SrvComPwSpeed_2_path1_T_H_OP280	6200	6000	{}	decreasing	A2-P1	Z	2	9	46
4910	InFan1SrvComPwSpeed_3_path1_T_H_OP280	6200	6000	{}	decreasing	A3-P1	A	2	9	46
4911	InFan1SrvComPwSpeed_4_path1_T_H_OP280	6200	6000	{}	decreasing	A4-P1	JS	2	9	46
4915	InFan2SrvAmpSpeed_0_path1_T_H_OP280	5000	4500	{}	decreasing	A0-P1	X	2	11	46
4916	InFan2SrvAmpSpeed_1_path1_T_H_OP280	5000	4500	{}	decreasing	A1-P1	Y	2	11	46
4917	InFan2SrvAmpSpeed_2_path1_T_H_OP280	5000	4500	{}	decreasing	A2-P1	Z	2	11	46
4918	InFan2SrvAmpSpeed_3_path1_T_H_OP280	5000	4500	{}	decreasing	A3-P1	A	2	11	46
4919	InFan2SrvAmpSpeed_4_path1_T_H_OP280	5000	4500	{}	decreasing	A4-P1	JS	2	11	46
4923	RadFan1SpindleAmpSpeed_0_path1_T_H_OP280	5000	4500	{}	decreasing	SP-P1	SP	2	15	46
4924	RadFan1SrvAmpSpeed_0_path1_T_H_OP280	5000	4500	{}	decreasing	A0-P1	X	2	15	46
4925	RadFan1SrvAmpSpeed_1_path1_T_H_OP280	5000	4500	{}	decreasing	A1-P1	Y	2	15	46
4926	RadFan1SrvAmpSpeed_2_path1_T_H_OP280	5000	4500	{}	decreasing	A2-P1	Z	2	15	46
4927	RadFan1SrvAmpSpeed_3_path1_T_H_OP280	5000	4500	{}	decreasing	A3-P1	A	2	15	46
4928	RadFan1SrvAmpSpeed_4_path1_T_H_OP280	5000	4500	{}	decreasing	A4-P1	JS	2	15	46
4932	InFan2SpdlComPwSpeed_0_path1_T_H_OP280	5000	4500	{}	decreasing	A0-P1	SAS	2	10	46
4933	InFan2SpindleAmpSpeed_0_path1_T_H_OP280	5000	4500	{}	decreasing	A0-P1	SCS	2	10	46
4934	InFan2SrvComPwSpeed_0_path1_T_H_OP280	5000	4500	{}	decreasing	A0-P1	X	2	12	46
4935	InFan2SrvComPwSpeed_1_path1_T_H_OP280	5000	4500	{}	decreasing	A1-P1	Y	2	12	46
4936	InFan2SrvComPwSpeed_2_path1_T_H_OP280	5000	4500	{}	decreasing	A2-P1	Z	2	12	46
4937	InFan2SrvComPwSpeed_3_path1_T_H_OP280	5000	4500	{}	decreasing	A3-P1	A	2	12	46
4938	InFan2SrvComPwSpeed_4_path1_T_H_OP280	5000	4500	{}	decreasing	A4-P1	JS	2	12	46
4942	InFan1SpdlComPwSpeed_0_path1_T_H_OP280	5000	4500	{}	decreasing	A0-P1	SAS	2	7	46
4943	InFan1SpindleAmpSpeed_0_path1_T_H_OP280	5000	4500	{}	decreasing	A0-P1	SCS	2	7	46
4944	ServoTemp_0_path1_T_H_OP280	65	75	{}	increasing	A0-P1	X	13	3	46
4945	ServoTemp_1_path1_T_H_OP280	55	70	{}	increasing	A1-P1	Y	13	3	46
4946	ServoTemp_2_path1_T_H_OP280	55	70	{}	increasing	A2-P1	Z	13	3	46
4947	ServoTemp_3_path1_T_H_OP280	55	70	{}	increasing	A3-P1	A	13	3	46
4948	ServoTemp_4_path1_T_H_OP280	55	70	{}	increasing	A4-P1	JS	13	3	46
4952	SpindleTemp_0_path1_T_H_OP280	80	100	{}	increasing	SP-P1	SP	13	3	46
4953	PulseCoderTemp_0_path1_T_H_OP285	70	80	{}	increasing	A0-P1	X	13	4	47
4954	PulseCoderTemp_1_path1_T_H_OP285	60	80	{}	increasing	A1-P1	Y	13	4	47
4955	PulseCoderTemp_2_path1_T_H_OP285	70	80	{}	increasing	A2-P1	Z	13	4	47
4956	PulseCoderTemp_3_path1_T_H_OP285	60	80	{}	increasing	A3-P1	A	13	4	47
4957	PulseCoderTemp_4_path1_T_H_OP285	65	80	{}	increasing	A4-P1	JS	13	4	47
4958	CncFan1Speed_path1_T_H_OP285	4500	4000	{}	decreasing	A1-P1	F1	16	6	47
4959	CncFan2Speed_path1_T_H_OP285	9600	8600	{}	decreasing	A2-P1	F2	16	6	47
4962	InFan1SrvAmpSpeed_0_path1_T_H_OP285	9500	9000	{}	decreasing	A0-P1	X	2	8	47
4963	InFan1SrvAmpSpeed_1_path1_T_H_OP285	9500	9000	{}	decreasing	A1-P1	Y	2	8	47
4964	InFan1SrvAmpSpeed_2_path1_T_H_OP285	9500	9000	{}	decreasing	A2-P1	Z	2	8	47
4965	InFan1SrvAmpSpeed_3_path1_T_H_OP285	9500	9000	{}	decreasing	A3-P1	A	2	8	47
4966	InFan1SrvAmpSpeed_4_path1_T_H_OP285	8500	7500	{}	decreasing	A4-P1	JS	2	8	47
4967	ServoLoad_0_path1_T_H_OP285	NaN	NaN	{}	increasing	A0-P1	X	17	17	47
4968	ServoLoad_1_path1_T_H_OP285	NaN	NaN	{}	increasing	A1-P1	Y	17	17	47
4969	ServoLoad_2_path1_T_H_OP285	NaN	NaN	{}	increasing	A2-P1	Z	17	17	47
4970	ServoLoad_3_path1_T_H_OP285	NaN	NaN	{}	increasing	A3-P1	A	17	17	47
4971	ServoLoad_4_path1_T_H_OP285	NaN	NaN	{}	increasing	A4-P1	JS	17	17	47
4972	SpindleLoad_0_path1_T_H_OP285	NaN	NaN	{}	increasing	SP-P1	SP	17	17	47
4973	SpdBatZero_0_path1_T_H_OP285	NaN	NaN	{}	bool	A0-P1	X	6	13	47
4974	SpdBatZero_1_path1_T_H_OP285	NaN	NaN	{}	bool	A1-P1	Y	6	13	47
4975	SpdBatZero_2_path1_T_H_OP285	NaN	NaN	{}	bool	A2-P1	Z	6	13	47
4976	SpdBatZero_3_path1_T_H_OP285	NaN	NaN	{}	bool	A3-P1	A	6	13	47
4977	SpdBatZero_4_path1_T_H_OP285	NaN	NaN	{}	bool	A4-P1	JS	6	13	47
4978	SSpdBatZero_0_path1_T_H_OP285	NaN	NaN	{}	bool	A0-P1	X	6	14	47
4979	SSpdBatZero_1_path1_T_H_OP285	NaN	NaN	{}	bool	A1-P1	Y	6	14	47
4980	SSpdBatZero_2_path1_T_H_OP285	NaN	NaN	{}	bool	A2-P1	Z	6	14	47
4981	SSpdBatZero_3_path1_T_H_OP285	NaN	NaN	{}	bool	A3-P1	A	6	14	47
4982	SSpdBatZero_4_path1_T_H_OP285	NaN	NaN	{}	bool	A4-P1	JS	6	14	47
4983	RadFan2SpindleAmpSpeed_0_path1_T_H_OP285	5000	4500	{}	decreasing	SP-P1	SP	2	16	47
4984	RadFan2SrvAmpSpeed_0_path1_T_H_OP285	5000	4500	{}	decreasing	A0-P1	X	2	16	47
4985	RadFan2SrvAmpSpeed_1_path1_T_H_OP285	5000	4500	{}	decreasing	A1-P1	Y	2	16	47
4986	RadFan2SrvAmpSpeed_2_path1_T_H_OP285	5000	4500	{}	decreasing	A2-P1	Z	2	16	47
4987	RadFan2SrvAmpSpeed_3_path1_T_H_OP285	5000	4500	{}	decreasing	A3-P1	A	2	16	47
4988	RadFan2SrvAmpSpeed_4_path1_T_H_OP285	5000	4500	{}	decreasing	A4-P1	JS	2	16	47
4989	ApcBatLow_0_path1_T_H_OP285	NaN	NaN	{}	bool	A0-P1	X	6	1	47
4990	ApcBatLow_1_path1_T_H_OP285	NaN	NaN	{}	bool	A1-P1	Y	6	1	47
4991	ApcBatLow_2_path1_T_H_OP285	NaN	NaN	{}	bool	A2-P1	Z	6	1	47
4992	ApcBatLow_3_path1_T_H_OP285	NaN	NaN	{}	bool	A3-P1	A	6	1	47
4993	ApcBatLow_4_path1_T_H_OP285	NaN	NaN	{}	bool	A4-P1	JS	6	1	47
4994	CncBatLow_0_path1_T_H_OP285	NaN	NaN	{}	bool	A0-P1	X	6	2	47
4995	CncBatLow_1_path1_T_H_OP285	NaN	NaN	{}	bool	A1-P1	Y	6	2	47
4996	CncBatLow_2_path1_T_H_OP285	NaN	NaN	{}	bool	A2-P1	Z	6	2	47
4997	CncBatLow_3_path1_T_H_OP285	NaN	NaN	{}	bool	A3-P1	A	6	2	47
4998	CncBatLow_4_path1_T_H_OP285	NaN	NaN	{}	bool	A4-P1	JS	6	2	47
4999	ServoLeakResistData_0_path1_T_H_OP285	50	30	{}	decreasing	A0-P1	X	15	5	47
5000	ServoLeakResistData_1_path1_T_H_OP285	50	30	{}	decreasing	A1-P1		15	5	47
5001	ServoLeakResistData_2_path1_T_H_OP285	50	30	{}	decreasing	A2-P1	Z	15	5	47
5002	ServoLeakResistData_3_path1_T_H_OP285	50	30	{}	decreasing	A3-P1	A	15	5	47
5003	ServoLeakResistData_4_path1_T_H_OP285	50	30	{}	decreasing	A4-P1	JS	15	5	47
5004	SpindleLeakResistData_0_path1_T_H_OP285	50	30	{}	decreasing	SP-P1	SP	15	5	47
5005	InFan1SrvComPwSpeed_0_path1_T_H_OP285	6200	6000	{}	decreasing	A0-P1	X	2	9	47
5006	InFan1SrvComPwSpeed_1_path1_T_H_OP285	6200	6000	{}	decreasing	A1-P1	Y	2	9	47
5007	InFan1SrvComPwSpeed_2_path1_T_H_OP285	6200	6000	{}	decreasing	A2-P1	Z	2	9	47
5008	InFan1SrvComPwSpeed_3_path1_T_H_OP285	6200	6000	{}	decreasing	A3-P1	A	2	9	47
5009	InFan1SrvComPwSpeed_4_path1_T_H_OP285	6200	6000	{}	decreasing	A4-P1	JS	2	9	47
5010	InFan2SrvAmpSpeed_0_path1_T_H_OP285	5000	4500	{}	decreasing	A0-P1	X	2	11	47
5011	InFan2SrvAmpSpeed_1_path1_T_H_OP285	5000	4500	{}	decreasing	A1-P1	Y	2	11	47
5012	InFan2SrvAmpSpeed_2_path1_T_H_OP285	5000	4500	{}	decreasing	A2-P1	Z	2	11	47
5013	InFan2SrvAmpSpeed_3_path1_T_H_OP285	5000	4500	{}	decreasing	A3-P1	A	2	11	47
5014	InFan2SrvAmpSpeed_4_path1_T_H_OP285	5000	4500	{}	decreasing	A4-P1	JS	2	11	47
5015	RadFan1SpindleAmpSpeed_0_path1_T_H_OP285	5000	4500	{}	decreasing	SP-P1	P1	2	15	47
5016	RadFan1SrvAmpSpeed_0_path1_T_H_OP285	5000	4500	{}	decreasing	A0-P1	X	2	15	47
5017	RadFan1SrvAmpSpeed_1_path1_T_H_OP285	5000	4500	{}	decreasing	A1-P1	Y	2	15	47
5018	RadFan1SrvAmpSpeed_2_path1_T_H_OP285	5000	4500	{}	decreasing	A2-P1	Z	2	15	47
5019	RadFan1SrvAmpSpeed_3_path1_T_H_OP285	5000	4500	{}	decreasing	A3-P1	A	2	15	47
5020	RadFan1SrvAmpSpeed_4_path1_T_H_OP285	5000	4500	{}	decreasing	A4-P1	JS	2	15	47
5021	InFan2SpdlComPwSpeed_0_path1_T_H_OP285	5000	4500	{}	decreasing	A0-P1	SAS	2	10	47
5022	InFan2SpindleAmpSpeed_0_path1_T_H_OP285	5000	4500	{}	decreasing	A0-P1	SCS	2	10	47
5023	InFan2SrvComPwSpeed_0_path1_T_H_OP285	5000	4500	{}	decreasing	A0-P1	X	2	12	47
5024	InFan2SrvComPwSpeed_1_path1_T_H_OP285	5000	4500	{}	decreasing	A1-P1	Y	2	12	47
5025	InFan2SrvComPwSpeed_2_path1_T_H_OP285	5000	4500	{}	decreasing	A2-P1	Z	2	12	47
5026	InFan2SrvComPwSpeed_3_path1_T_H_OP285	5000	4500	{}	decreasing	A3-P1	A	2	12	47
5027	InFan2SrvComPwSpeed_4_path1_T_H_OP285	5000	4500	{}	decreasing	A4-P1	JS	2	12	47
5028	InFan1SpdlComPwSpeed_0_path1_T_H_OP285	5000	4500	{}	decreasing	A0-P1	SAS	2	7	47
5029	InFan1SpindleAmpSpeed_0_path1_T_H_OP285	5000	4500	{}	decreasing	A0-P1	SCS	2	7	47
5030	ServoTemp_0_path1_T_H_OP285	65	75	{}	increasing	A0-P1	X	13	3	47
5031	ServoTemp_1_path1_T_H_OP285	55	70	{}	increasing	A1-P1	Y	13	3	47
5032	ServoTemp_2_path1_T_H_OP285	65	75	{}	increasing	A2-P1	Z	13	3	47
5033	ServoTemp_3_path1_T_H_OP285	55	70	{}	increasing	A3-P1	A	13	3	47
5034	ServoTemp_4_path1_T_H_OP285	55	70	{}	increasing	A4-P1	JS	13	3	47
5035	SpindleTemp_0_path1_T_H_OP285	80	100	{}	increasing	SP-P1	SP	13	3	47
5036	PulseCoderTemp_0_path1_T_H_OP300	60	80	{}	increasing	A0-P1	X1	13	4	48
5037	PulseCoderTemp_1_path1_T_H_OP300	80	90	{}	increasing	A1-P1	Y1	13	4	48
5038	PulseCoderTemp_2_path1_T_H_OP300	85	90	{}	increasing	A2-P1	Y2	13	4	48
5039	PulseCoderTemp_3_path1_T_H_OP300	70	80	{}	increasing	A3-P1	Z1	13	4	48
5040	PulseCoderTemp_4_path1_T_H_OP300	60	80	{}	increasing	A4-P1	Z2	13	4	48
5041	PulseCoderTemp_5_path1_T_H_OP300	60	80	{}	increasing	A5-P1	B1	13	4	48
5042	PulseCoderTemp_6_path1_T_H_OP300	60	80	{}	increasing	A6-P1	B2	13	4	48
5045	CncFan1Speed_path1_T_H_OP300	4500	4000	{}	decreasing	A1-P1	F1	16	6	48
5046	CncFan2Speed_path1_T_H_OP300	9600	8600	{}	decreasing	A2-P1	F3	16	6	48
5049	InFan1SrvAmpSpeed_0_path1_T_H_OP300	9500	9000	{}	decreasing	A0-P1	X1	2	8	48
5050	InFan1SrvAmpSpeed_1_path1_T_H_OP300	9500	9000	{}	decreasing	A1-P1	Y1	2	8	48
5051	InFan1SrvAmpSpeed_2_path1_T_H_OP300	9500	9000	{}	decreasing	A2-P1	Y2	2	8	48
5052	InFan1SrvAmpSpeed_3_path1_T_H_OP300	9500	9000	{}	decreasing	A3-P1	Z1	2	8	48
5053	InFan1SrvAmpSpeed_4_path1_T_H_OP300	8500	7500	{}	decreasing	A4-P1	Z2	2	8	48
5054	InFan1SrvAmpSpeed_5_path1_T_H_OP300	8500	7500	{}	decreasing	A5-P1	B1	2	8	48
5055	InFan1SrvAmpSpeed_6_path1_T_H_OP300	9500	9000	{}	decreasing	A6-P1	B2	2	8	48
5058	ServoLoad_0_path1_T_H_OP300	NaN	NaN	{}	increasing	A0-P1	X1	17	17	48
5059	ServoLoad_1_path1_T_H_OP300	NaN	NaN	{}	increasing	A1-P1	Y1	17	17	48
5060	ServoLoad_2_path1_T_H_OP300	NaN	NaN	{}	increasing	A2-P1	Y2	17	17	48
5061	ServoLoad_3_path1_T_H_OP300	NaN	NaN	{}	increasing	A3-P1	Z1	17	17	48
5062	ServoLoad_4_path1_T_H_OP300	NaN	NaN	{}	increasing	A4-P1	Z2	17	17	48
5063	ServoLoad_5_path1_T_H_OP300	NaN	NaN	{}	increasing	A5-P1	B1	17	17	48
5064	ServoLoad_6_path1_T_H_OP300	NaN	NaN	{}	increasing	A6-P1	B2	17	17	48
5068	SpdBatZero_0_path1_T_H_OP300	NaN	NaN	{}	bool	A0-P1	X1	6	13	48
5069	SpdBatZero_1_path1_T_H_OP300	NaN	NaN	{}	bool	A1-P1	Y1	6	13	48
5070	SpdBatZero_2_path1_T_H_OP300	NaN	NaN	{}	bool	A2-P1	Y2	6	13	48
5071	SpdBatZero_3_path1_T_H_OP300	NaN	NaN	{}	bool	A3-P1	Z1	6	13	48
5072	SpdBatZero_4_path1_T_H_OP300	NaN	NaN	{}	bool	A4-P1	Z2	6	13	48
5073	SpdBatZero_5_path1_T_H_OP300	NaN	NaN	{}	bool	A5-P1	B1	6	13	48
5074	SpdBatZero_6_path1_T_H_OP300	NaN	NaN	{}	bool	A6-P1	B2	6	13	48
5077	SSpdBatZero_0_path1_T_H_OP300	NaN	NaN	{}	bool	A0-P1	X1	6	14	48
5078	SSpdBatZero_1_path1_T_H_OP300	NaN	NaN	{}	bool	A1-P1	Y1	6	14	48
5079	SSpdBatZero_2_path1_T_H_OP300	NaN	NaN	{}	bool	A2-P1	Y2	6	14	48
5080	SSpdBatZero_3_path1_T_H_OP300	NaN	NaN	{}	bool	A3-P1	Z1	6	14	48
5081	SSpdBatZero_4_path1_T_H_OP300	NaN	NaN	{}	bool	A4-P1	Z2	6	14	48
5082	SSpdBatZero_5_path1_T_H_OP300	NaN	NaN	{}	bool	A5-P1	B1	6	14	48
5083	SSpdBatZero_6_path1_T_H_OP300	NaN	NaN	{}	bool	A6-P1	B2	6	14	48
5087	RadFan2SrvAmpSpeed_0_path1_T_H_OP300	5000	4500	{}	decreasing	A0-P1	X1	2	16	48
5088	RadFan2SrvAmpSpeed_1_path1_T_H_OP300	5000	4500	{}	decreasing	A1-P1	Y1	2	16	48
5089	RadFan2SrvAmpSpeed_2_path1_T_H_OP300	5000	4500	{}	decreasing	A2-P1	Y2	2	16	48
5090	RadFan2SrvAmpSpeed_3_path1_T_H_OP300	5000	4500	{}	decreasing	A3-P1	Z1	2	16	48
5091	RadFan2SrvAmpSpeed_4_path1_T_H_OP300	5000	4500	{}	decreasing	A4-P1	Z2	2	16	48
5092	RadFan2SrvAmpSpeed_5_path1_T_H_OP300	5000	4500	{}	decreasing	A5-P1	B1	2	16	48
5093	RadFan2SrvAmpSpeed_6_path1_T_H_OP300	5000	4500	{}	decreasing	A6-P1	B2	2	16	48
5096	ApcBatLow_0_path1_T_H_OP300	NaN	NaN	{}	bool	A0-P1	X1	6	1	48
5097	ApcBatLow_1_path1_T_H_OP300	NaN	NaN	{}	bool	A1-P1	Y1	6	1	48
5098	ApcBatLow_2_path1_T_H_OP300	NaN	NaN	{}	bool	A2-P1	Y2	6	1	48
5099	ApcBatLow_3_path1_T_H_OP300	NaN	NaN	{}	bool	A3-P1	Z1	6	1	48
5100	ApcBatLow_4_path1_T_H_OP300	NaN	NaN	{}	bool	A4-P1	Z2	6	1	48
5101	ApcBatLow_5_path1_T_H_OP300	NaN	NaN	{}	bool	A5-P1	B1	6	1	48
5102	ApcBatLow_6_path1_T_H_OP300	NaN	NaN	{}	bool	A6-P1	B2	6	1	48
5105	CncBatLow_0_path1_T_H_OP300	NaN	NaN	{}	bool	A0-P1	X1	6	2	48
5106	CncBatLow_1_path1_T_H_OP300	NaN	NaN	{}	bool	A1-P1	Y1	6	2	48
5107	CncBatLow_2_path1_T_H_OP300	NaN	NaN	{}	bool	A2-P1	Y2	6	2	48
5108	CncBatLow_3_path1_T_H_OP300	NaN	NaN	{}	bool	A3-P1	Z1	6	2	48
5109	CncBatLow_4_path1_T_H_OP300	NaN	NaN	{}	bool	A4-P1	Z2	6	2	48
5110	CncBatLow_5_path1_T_H_OP300	NaN	NaN	{}	bool	A5-P1	B1	6	2	48
5111	CncBatLow_6_path1_T_H_OP300	NaN	NaN	{}	bool	A6-P1	B2	6	2	48
5114	ServoLeakResistData_0_path1_T_H_OP300	50	30	{}	decreasing	A0-P1	X1	15	5	48
5115	ServoLeakResistData_1_path1_T_H_OP300	50	30	{}	decreasing	A1-P1	Y1	15	5	48
5116	ServoLeakResistData_2_path1_T_H_OP300	50	30	{}	decreasing	A2-P1	Y2	15	5	48
5117	ServoLeakResistData_3_path1_T_H_OP300	50	30	{}	decreasing	A3-P1	Z1	15	5	48
5118	ServoLeakResistData_4_path1_T_H_OP300	50	30	{}	decreasing	A4-P1	Z2	15	5	48
5119	ServoLeakResistData_5_path1_T_H_OP300	50	30	{}	decreasing	A5-P1	B1	15	5	48
5120	ServoLeakResistData_6_path1_T_H_OP300	50	30	{}	decreasing	A6-P1	B2	15	5	48
5124	InFan1SrvComPwSpeed_0_path1_T_H_OP300	6200	6000	{}	decreasing	A0-P1	X1	2	9	48
5125	InFan1SrvComPwSpeed_1_path1_T_H_OP300	6200	6000	{}	decreasing	A1-P1	Y1	2	9	48
5126	InFan1SrvComPwSpeed_2_path1_T_H_OP300	6200	6000	{}	decreasing	A2-P1	Y2	2	9	48
5127	InFan1SrvComPwSpeed_3_path1_T_H_OP300	6200	6000	{}	decreasing	A3-P1	Z1	2	9	48
5128	InFan1SrvComPwSpeed_4_path1_T_H_OP300	6200	6000	{}	decreasing	A4-P1	Z2	2	9	48
5129	InFan1SrvComPwSpeed_5_path1_T_H_OP300	6200	6000	{}	decreasing	A5-P1	B1	2	9	48
5130	InFan1SrvComPwSpeed_6_path1_T_H_OP300	6200	6000	{}	decreasing	A6-P1	B2	2	9	48
5133	InFan2SrvAmpSpeed_0_path1_T_H_OP300	5000	4500	{}	decreasing	A0-P1	X1	2	11	48
5134	InFan2SrvAmpSpeed_1_path1_T_H_OP300	5000	4500	{}	decreasing	A1-P1	Y1	2	11	48
5135	InFan2SrvAmpSpeed_2_path1_T_H_OP300	5000	4500	{}	decreasing	A2-P1	Y2	2	11	48
5136	InFan2SrvAmpSpeed_3_path1_T_H_OP300	5000	4500	{}	decreasing	A3-P1	Z1	2	11	48
5137	InFan2SrvAmpSpeed_4_path1_T_H_OP300	5000	4500	{}	decreasing	A4-P1	Z2	2	11	48
5138	InFan2SrvAmpSpeed_5_path1_T_H_OP300	5000	4500	{}	decreasing	A5-P1	B1	2	11	48
5139	InFan2SrvAmpSpeed_6_path1_T_H_OP300	5000	4500	{}	decreasing	A6-P1	B2	2	11	48
5143	RadFan1SrvAmpSpeed_0_path1_T_H_OP300	5000	4500	{}	decreasing	A0-P1	X1	2	15	48
5144	RadFan1SrvAmpSpeed_1_path1_T_H_OP300	5000	4500	{}	decreasing	A1-P1	Y1	2	15	48
5145	RadFan1SrvAmpSpeed_2_path1_T_H_OP300	5000	4500	{}	decreasing	A2-P1	Y2	2	15	48
5146	RadFan1SrvAmpSpeed_3_path1_T_H_OP300	5000	4500	{}	decreasing	A3-P1	Z1	2	15	48
5147	RadFan1SrvAmpSpeed_4_path1_T_H_OP300	5000	4500	{}	decreasing	A4-P1	Z2	2	15	48
5148	RadFan1SrvAmpSpeed_5_path1_T_H_OP300	5000	4500	{}	decreasing	A5-P1	B1	2	15	48
5149	RadFan1SrvAmpSpeed_6_path1_T_H_OP300	5000	4500	{}	decreasing	A6-P1	B2	2	15	48
5152	InFan2SpdlComPwSpeed_0_path1_T_H_OP300	5000	4500	{}	decreasing	A0-P1	SAS	2	10	48
5153	InFan2SpindleAmpSpeed_0_path1_T_H_OP300	5000	4500	{}	decreasing	A0-P1	SCS	2	10	48
5154	InFan2SrvComPwSpeed_0_path1_T_H_OP300	5000	4500	{}	decreasing	A0-P1	X1	2	12	48
5155	InFan2SrvComPwSpeed_1_path1_T_H_OP300	5000	4500	{}	decreasing	A1-P1	Y1	2	12	48
5156	InFan2SrvComPwSpeed_2_path1_T_H_OP300	5000	4500	{}	decreasing	A2-P1	Y2	2	12	48
5157	InFan2SrvComPwSpeed_3_path1_T_H_OP300	5000	4500	{}	decreasing	A3-P1	Z1	2	12	48
5158	InFan2SrvComPwSpeed_4_path1_T_H_OP300	5000	4500	{}	decreasing	A4-P1	Z2	2	12	48
5159	InFan2SrvComPwSpeed_5_path1_T_H_OP300	5000	4500	{}	decreasing	A5-P1	B1	2	12	48
5160	InFan2SrvComPwSpeed_6_path1_T_H_OP300	5000	4500	{}	decreasing	A6-P1	B2	2	12	48
5163	InFan1SpdlComPwSpeed_0_path1_T_H_OP300	5000	4500	{}	decreasing	A0-P1	SAS	2	7	48
5164	InFan1SpindleAmpSpeed_0_path1_T_H_OP300	5000	4500	{}	decreasing	A0-P1	SCS	2	7	48
5165	ServoTemp_0_path1_T_H_OP300	55	70	{}	increasing	A0-P1	X1	13	3	48
5166	ServoTemp_1_path1_T_H_OP300	55	70	{}	increasing	A1-P1	Y1	13	3	48
5167	ServoTemp_2_path1_T_H_OP300	55	70	{}	increasing	A2-P1	Y2	13	3	48
5168	ServoTemp_3_path1_T_H_OP300	70	80	{}	increasing	A3-P1	Z1	13	3	48
5169	ServoTemp_4_path1_T_H_OP300	55	70	{}	increasing	A4-P1	Z2	13	3	48
5170	ServoTemp_5_path1_T_H_OP300	55	70	{}	increasing	A5-P1	B1	13	3	48
5171	ServoTemp_6_path1_T_H_OP300	55	70	{}	increasing	A6-P1	B2	13	3	48
5175	PulseCoderTemp_0_path1_T_H_OP50	60	80	{}	increasing	A0-P1	X	13	4	49
5176	PulseCoderTemp_1_path1_T_H_OP50	60	80	{}	increasing	A1-P1	Y	13	4	49
5177	PulseCoderTemp_2_path1_T_H_OP50	60	80	{}	increasing	A2-P1	Z	13	4	49
5178	PulseCoderTemp_3_path1_T_H_OP50	60	80	{}	increasing	A3-P1	A	13	4	49
5179	PulseCoderTemp_4_path1_T_H_OP50	60	80	{}	increasing	A4-P1	V	13	4	49
5180	PulseCoderTemp_5_path1_T_H_OP50	70	80	{}	increasing	A5-P1	C	13	4	49
5181	CncFan1Speed_path1_T_H_OP50	4500	4000	{}	decreasing	A1-P1	F1	16	6	49
5182	CncFan2Speed_path1_T_H_OP50	9600	8600	{}	decreasing	A2-P1	F3	16	6	49
5185	InFan1SrvAmpSpeed_0_path1_T_H_OP50	9500	9000	{}	decreasing	A0-P1	X	2	8	49
5186	InFan1SrvAmpSpeed_1_path1_T_H_OP50	9500	9000	{}	decreasing	A1-P1	Y	2	8	49
5187	InFan1SrvAmpSpeed_2_path1_T_H_OP50	9500	9000	{}	decreasing	A2-P1	Z	2	8	49
5188	InFan1SrvAmpSpeed_3_path1_T_H_OP50	9500	9000	{}	decreasing	A3-P1	A	2	8	49
5189	InFan1SrvAmpSpeed_4_path1_T_H_OP50	8500	7500	{}	decreasing	A4-P1	V	2	8	49
5190	InFan1SrvAmpSpeed_5_path1_T_H_OP50	8500	7500	{}	decreasing	A5-P1	C	2	8	49
5191	ServoLoad_0_path1_T_H_OP50	NaN	NaN	{}	increasing	A0-P1	X	17	17	49
5192	ServoLoad_1_path1_T_H_OP50	NaN	NaN	{}	increasing	A1-P1	Y	17	17	49
5193	ServoLoad_2_path1_T_H_OP50	NaN	NaN	{}	increasing	A2-P1	Z	17	17	49
5194	ServoLoad_3_path1_T_H_OP50	NaN	NaN	{}	increasing	A3-P1	A	17	17	49
5195	ServoLoad_4_path1_T_H_OP50	NaN	NaN	{}	increasing	A4-P1	V	17	17	49
5196	ServoLoad_5_path1_T_H_OP50	NaN	NaN	{}	increasing	A5-P1	C	17	17	49
5198	SpdBatZero_0_path1_T_H_OP50	NaN	NaN	{}	bool	A0-P1	X	6	13	49
5199	SpdBatZero_1_path1_T_H_OP50	NaN	NaN	{}	bool	A1-P1	Y	6	13	49
5200	SpdBatZero_2_path1_T_H_OP50	NaN	NaN	{}	bool	A2-P1	Z	6	13	49
5201	SpdBatZero_3_path1_T_H_OP50	NaN	NaN	{}	bool	A3-P1	A	6	13	49
5202	SpdBatZero_4_path1_T_H_OP50	NaN	NaN	{}	bool	A4-P1	V	6	13	49
5203	SpdBatZero_5_path1_T_H_OP50	NaN	NaN	{}	bool	A5-P1	C	6	13	49
5204	SSpdBatZero_0_path1_T_H_OP50	NaN	NaN	{}	bool	A0-P1	X	6	14	49
5205	SSpdBatZero_1_path1_T_H_OP50	NaN	NaN	{}	bool	A1-P1	Y	6	14	49
5206	SSpdBatZero_2_path1_T_H_OP50	NaN	NaN	{}	bool	A2-P1	Z	6	14	49
5207	SSpdBatZero_3_path1_T_H_OP50	NaN	NaN	{}	bool	A3-P1	A	6	14	49
5208	SSpdBatZero_4_path1_T_H_OP50	NaN	NaN	{}	bool	A4-P1	V	6	14	49
5209	SSpdBatZero_5_path1_T_H_OP50	NaN	NaN	{}	bool	A5-P1	C	6	14	49
5211	RadFan2SrvAmpSpeed_0_path1_T_H_OP50	5000	4500	{}	decreasing	A0-P1	X	2	16	49
5212	RadFan2SrvAmpSpeed_1_path1_T_H_OP50	5000	4500	{}	decreasing	A1-P1	Y	2	16	49
5213	RadFan2SrvAmpSpeed_2_path1_T_H_OP50	5000	4500	{}	decreasing	A2-P1	Z	2	16	49
5214	RadFan2SrvAmpSpeed_3_path1_T_H_OP50	5000	4500	{}	decreasing	A3-P1	A	2	16	49
5215	RadFan2SrvAmpSpeed_4_path1_T_H_OP50	5000	4500	{}	decreasing	A4-P1	V	2	16	49
5216	RadFan2SrvAmpSpeed_5_path1_T_H_OP50	5000	4500	{}	decreasing	A5-P1	C	2	16	49
5217	ApcBatLow_0_path1_T_H_OP50	NaN	NaN	{}	bool	A0-P1	X	6	1	49
5218	ApcBatLow_1_path1_T_H_OP50	NaN	NaN	{}	bool	A1-P1	Y	6	1	49
5219	ApcBatLow_2_path1_T_H_OP50	NaN	NaN	{}	bool	A2-P1	Z	6	1	49
5220	ApcBatLow_3_path1_T_H_OP50	NaN	NaN	{}	bool	A3-P1	A	6	1	49
5221	ApcBatLow_4_path1_T_H_OP50	NaN	NaN	{}	bool	A4-P1	V	6	1	49
5222	ApcBatLow_5_path1_T_H_OP50	NaN	NaN	{}	bool	A5-P1	C	6	1	49
5223	CncBatLow_0_path1_T_H_OP50	NaN	NaN	{}	bool	A0-P1	X	6	2	49
5224	CncBatLow_1_path1_T_H_OP50	NaN	NaN	{}	bool	A1-P1	Y	6	2	49
5225	CncBatLow_2_path1_T_H_OP50	NaN	NaN	{}	bool	A2-P1	Z	6	2	49
5226	CncBatLow_3_path1_T_H_OP50	NaN	NaN	{}	bool	A3-P1	A	6	2	49
5227	CncBatLow_4_path1_T_H_OP50	NaN	NaN	{}	bool	A4-P1	V	6	2	49
5228	CncBatLow_5_path1_T_H_OP50	NaN	NaN	{}	bool	A5-P1	C	6	2	49
5229	ServoLeakResistData_0_path1_T_H_OP50	50	30	{}	decreasing	A0-P1	X	15	5	49
5230	ServoLeakResistData_1_path1_T_H_OP50	50	30	{}	decreasing	A1-P1	Y	15	5	49
5231	ServoLeakResistData_2_path1_T_H_OP50	50	30	{}	decreasing	A2-P1	Z	15	5	49
5232	ServoLeakResistData_3_path1_T_H_OP50	50	30	{}	decreasing	A3-P1	A	15	5	49
5233	ServoLeakResistData_4_path1_T_H_OP50	50	30	{}	decreasing	A4-P1	V	15	5	49
5234	ServoLeakResistData_5_path1_T_H_OP50	50	30	{}	decreasing	A5-P1	C	15	5	49
5236	InFan1SrvComPwSpeed_0_path1_T_H_OP50	6200	6000	{}	decreasing	A0-P1	X	2	9	49
5237	InFan1SrvComPwSpeed_1_path1_T_H_OP50	6200	6000	{}	decreasing	A1-P1	Y	2	9	49
5238	InFan1SrvComPwSpeed_2_path1_T_H_OP50	6200	6000	{}	decreasing	A2-P1	Z	2	9	49
5239	InFan1SrvComPwSpeed_3_path1_T_H_OP50	6200	6000	{}	decreasing	A3-P1	A	2	9	49
5240	InFan1SrvComPwSpeed_4_path1_T_H_OP50	6200	6000	{}	decreasing	A4-P1	V	2	9	49
5241	InFan1SrvComPwSpeed_5_path1_T_H_OP50	6200	6000	{}	decreasing	A5-P1	C	2	9	49
5242	InFan2SrvAmpSpeed_0_path1_T_H_OP50	5000	4500	{}	decreasing	A0-P1	X	2	11	49
5243	InFan2SrvAmpSpeed_1_path1_T_H_OP50	5000	4500	{}	decreasing	A1-P1	Y	2	11	49
5244	InFan2SrvAmpSpeed_2_path1_T_H_OP50	5000	4500	{}	decreasing	A2-P1	Z	2	11	49
5245	InFan2SrvAmpSpeed_3_path1_T_H_OP50	5000	4500	{}	decreasing	A3-P1	A	2	11	49
5246	InFan2SrvAmpSpeed_4_path1_T_H_OP50	5000	4500	{}	decreasing	A4-P1	V	2	11	49
5247	InFan2SrvAmpSpeed_5_path1_T_H_OP50	5000	4500	{}	decreasing	A5-P1	C	2	11	49
5249	RadFan1SrvAmpSpeed_0_path1_T_H_OP50	5000	4500	{}	decreasing	A0-P1	X	2	15	49
5250	RadFan1SrvAmpSpeed_1_path1_T_H_OP50	5000	4500	{}	decreasing	A1-P1	Y	2	15	49
5251	RadFan1SrvAmpSpeed_2_path1_T_H_OP50	5000	4500	{}	decreasing	A2-P1	Z	2	15	49
5252	RadFan1SrvAmpSpeed_3_path1_T_H_OP50	5000	4500	{}	decreasing	A3-P1	A	2	15	49
5253	RadFan1SrvAmpSpeed_4_path1_T_H_OP50	5000	4500	{}	decreasing	A4-P1	V	2	15	49
5254	RadFan1SrvAmpSpeed_5_path1_T_H_OP50	5000	4500	{}	decreasing	A5-P1	C	2	15	49
5255	InFan2SpdlComPwSpeed_0_path1_T_H_OP50	5000	4500	{}	decreasing	A0-P1	SAS	2	10	49
5256	InFan2SpindleAmpSpeed_0_path1_T_H_OP50	5000	4500	{}	decreasing	A0-P1	SCS	2	10	49
5257	InFan2SrvComPwSpeed_0_path1_T_H_OP50	5000	4500	{}	decreasing	A0-P1	X	2	12	49
5258	InFan2SrvComPwSpeed_1_path1_T_H_OP50	5000	4500	{}	decreasing	A1-P1	Y	2	12	49
5259	InFan2SrvComPwSpeed_2_path1_T_H_OP50	5000	4500	{}	decreasing	A2-P1	Z	2	12	49
5260	InFan2SrvComPwSpeed_3_path1_T_H_OP50	5000	4500	{}	decreasing	A3-P1	A	2	12	49
5261	InFan2SrvComPwSpeed_4_path1_T_H_OP50	5000	4500	{}	decreasing	A4-P1	V	2	12	49
5262	InFan2SrvComPwSpeed_5_path1_T_H_OP50	5000	4500	{}	decreasing	A5-P1	C	2	12	49
5263	InFan1SpdlComPwSpeed_0_path1_T_H_OP50	5000	4500	{}	decreasing	A0-P1	SAS	2	7	49
5264	InFan1SpindleAmpSpeed_0_path1_T_H_OP50	5000	4500	{}	decreasing	A0-P1	SCS	2	7	49
5265	ServoTemp_0_path1_T_H_OP50	55	70	{}	increasing	A0-P1	X	13	3	49
5266	ServoTemp_1_path1_T_H_OP50	55	70	{}	increasing	A1-P1	Y	13	3	49
5267	ServoTemp_2_path1_T_H_OP50	55	70	{}	increasing	A2-P1	Z	13	3	49
5268	ServoTemp_3_path1_T_H_OP50	55	70	{}	increasing	A3-P1	A	13	3	49
5269	ServoTemp_4_path1_T_H_OP50	55	70	{}	increasing	A4-P1	V	13	3	49
5270	ServoTemp_5_path1_T_H_OP50	55	70	{}	increasing	A5-P1	C	13	3	49
5272	PulseCoderTemp_0_path1_T_H_OP500	70	80	{}	increasing	A0-P1	X	13	4	50
5273	PulseCoderTemp_1_path1_T_H_OP500	70	80	{}	increasing	A1-P1	Y1	13	4	50
5274	PulseCoderTemp_2_path1_T_H_OP500	70	80	{}	increasing	A2-P1	Y2	13	4	50
5275	CncFan1Speed_path1_T_H_OP500	4500	4000	{}	decreasing	A1-P1	F1	16	6	50
5276	CncFan2Speed_path1_T_H_OP500	9600	8600	{}	decreasing	A2-P1	F2	16	6	50
5279	InFan1SrvAmpSpeed_0_path1_T_H_OP500	9500	9000	{}	decreasing	A0-P1	X	2	8	50
5280	InFan1SrvAmpSpeed_1_path1_T_H_OP500	9500	9000	{}	decreasing	A1-P1	Y1	2	8	50
5281	InFan1SrvAmpSpeed_2_path1_T_H_OP500	9500	9000	{}	decreasing	A2-P1	Y2	2	8	50
5282	ServoLoad_0_path1_T_H_OP500	NaN	NaN	{}	increasing	A0-P1	X	17	17	50
5283	ServoLoad_1_path1_T_H_OP500	NaN	NaN	{}	increasing	A1-P1	Y1	17	17	50
5284	ServoLoad_2_path1_T_H_OP500	NaN	NaN	{}	increasing	A2-P1	Y2	17	17	50
5285	SpdBatZero_0_path1_T_H_OP500	NaN	NaN	{}	bool	A0-P1	X	6	13	50
5286	SpdBatZero_1_path1_T_H_OP500	NaN	NaN	{}	bool	A1-P1	Y1	6	13	50
5287	SpdBatZero_2_path1_T_H_OP500	NaN	NaN	{}	bool	A2-P1	Y2	6	13	50
5288	SSpdBatZero_0_path1_T_H_OP500	NaN	NaN	{}	bool	A0-P1	X	6	14	50
5289	SSpdBatZero_1_path1_T_H_OP500	NaN	NaN	{}	bool	A1-P1	Y1	6	14	50
5290	SSpdBatZero_2_path1_T_H_OP500	NaN	NaN	{}	bool	A2-P1	Y2	6	14	50
5291	RadFan2SrvAmpSpeed_0_path1_T_H_OP500	5000	4500	{}	decreasing	A0-P1	X	2	16	50
5292	RadFan2SrvAmpSpeed_1_path1_T_H_OP500	5000	4500	{}	decreasing	A1-P1	Y1	2	16	50
5293	RadFan2SrvAmpSpeed_2_path1_T_H_OP500	5000	4500	{}	decreasing	A2-P1	Y2	2	16	50
5294	ApcBatLow_0_path1_T_H_OP500	NaN	NaN	{}	bool	A0-P1	X	6	1	50
5295	ApcBatLow_1_path1_T_H_OP500	NaN	NaN	{}	bool	A1-P1	Y1	6	1	50
5296	ApcBatLow_2_path1_T_H_OP500	NaN	NaN	{}	bool	A2-P1	Y2	6	1	50
5297	CncBatLow_0_path1_T_H_OP500	NaN	NaN	{}	bool	A0-P1	X	6	2	50
5298	CncBatLow_1_path1_T_H_OP500	NaN	NaN	{}	bool	A1-P1	Y1	6	2	50
5299	CncBatLow_2_path1_T_H_OP500	NaN	NaN	{}	bool	A2-P1	Y2	6	2	50
5300	ServoLeakResistData_0_path1_T_H_OP500	50	30	{}	decreasing	A0-P1	X	15	5	50
5301	ServoLeakResistData_1_path1_T_H_OP500	50	30	{}	decreasing	A1-P1	Y1	15	5	50
5302	ServoLeakResistData_2_path1_T_H_OP500	50	30	{}	decreasing	A2-P1	Y2	15	5	50
5303	InFan1SrvComPwSpeed_0_path1_T_H_OP500	6200	6000	{}	decreasing	A0-P1	X	2	9	50
5304	InFan1SrvComPwSpeed_1_path1_T_H_OP500	6200	6000	{}	decreasing	A1-P1	Y1	2	9	50
5305	InFan1SrvComPwSpeed_2_path1_T_H_OP500	6200	6000	{}	decreasing	A2-P1	Y2	2	9	50
5306	InFan2SrvAmpSpeed_0_path1_T_H_OP500	5000	4500	{}	decreasing	A0-P1	X	2	11	50
5307	InFan2SrvAmpSpeed_1_path1_T_H_OP500	5000	4500	{}	decreasing	A1-P1	Y1	2	11	50
5308	InFan2SrvAmpSpeed_2_path1_T_H_OP500	5000	4500	{}	decreasing	A2-P1	Y2	2	11	50
5309	RadFan1SrvAmpSpeed_0_path1_T_H_OP500	5000	4500	{}	decreasing	A0-P1	X	2	15	50
5310	RadFan1SrvAmpSpeed_1_path1_T_H_OP500	5000	4500	{}	decreasing	A1-P1	Y1	2	15	50
5311	RadFan1SrvAmpSpeed_2_path1_T_H_OP500	5000	4500	{}	decreasing	A2-P1	Y2	2	15	50
5312	InFan2SrvComPwSpeed_0_path1_T_H_OP500	5000	4500	{}	decreasing	A0-P1	X	2	12	50
5313	InFan2SrvComPwSpeed_1_path1_T_H_OP500	5000	4500	{}	decreasing	A1-P1	Y1	2	12	50
5314	InFan2SrvComPwSpeed_2_path1_T_H_OP500	5000	4500	{}	decreasing	A2-P1	Y2	2	12	50
5315	ServoTemp_0_path1_T_H_OP500	65	75	{}	increasing	A0-P1	X	13	3	50
5316	ServoTemp_1_path1_T_H_OP500	55	70	{}	increasing	A1-P1	Y1	13	3	50
5317	ServoTemp_2_path1_T_H_OP500	55	70	{}	increasing	A2-P1	Y2	13	3	50
5318	PulseCoderTemp_0_path1_T_H_OP510	75	85	{}	increasing	A0-P1	X	13	4	51
5319	PulseCoderTemp_1_path1_T_H_OP510	70	80	{}	increasing	A1-P1	Y1	13	4	51
5320	PulseCoderTemp_2_path1_T_H_OP510	70	80	{}	increasing	A2-P1	Y2	13	4	51
5321	CncFan1Speed_path1_T_H_OP510	4500	4000	{}	decreasing	A1-P1	F1	16	6	51
5322	CncFan2Speed_path1_T_H_OP510	9600	8600	{}	decreasing	A2-P1	F2	16	6	51
5325	InFan1SrvAmpSpeed_0_path1_T_H_OP510	9500	9000	{}	decreasing	A0-P1	X	2	8	51
5326	InFan1SrvAmpSpeed_1_path1_T_H_OP510	9500	9000	{}	decreasing	A1-P1	Y1	2	8	51
5327	InFan1SrvAmpSpeed_2_path1_T_H_OP510	9500	9000	{}	decreasing	A2-P1	Y2	2	8	51
5328	ServoLoad_0_path1_T_H_OP510	NaN	NaN	{}	increasing	A0-P1	X	17	17	51
5329	ServoLoad_1_path1_T_H_OP510	NaN	NaN	{}	increasing	A1-P1	Y1	17	17	51
5330	ServoLoad_2_path1_T_H_OP510	NaN	NaN	{}	increasing	A2-P1	Y2	17	17	51
5331	SpdBatZero_0_path1_T_H_OP510	NaN	NaN	{}	bool	A0-P1	X	6	13	51
5332	SpdBatZero_1_path1_T_H_OP510	NaN	NaN	{}	bool	A1-P1	Y1	6	13	51
5333	SpdBatZero_2_path1_T_H_OP510	NaN	NaN	{}	bool	A2-P1	Y2	6	13	51
5334	SSpdBatZero_0_path1_T_H_OP510	NaN	NaN	{}	bool	A0-P1	X	6	14	51
5335	SSpdBatZero_1_path1_T_H_OP510	NaN	NaN	{}	bool	A1-P1	Y1	6	14	51
5336	SSpdBatZero_2_path1_T_H_OP510	NaN	NaN	{}	bool	A2-P1	Y2	6	14	51
5337	RadFan2SrvAmpSpeed_0_path1_T_H_OP510	5000	4500	{}	decreasing	A0-P1	X	2	16	51
6280	feeder_t1_data_table	\N	\N	{}	\N	\N	\N	9	\N	64
5338	RadFan2SrvAmpSpeed_1_path1_T_H_OP510	5000	4500	{}	decreasing	A1-P1	Y1	2	16	51
5339	RadFan2SrvAmpSpeed_2_path1_T_H_OP510	5000	4500	{}	decreasing	A2-P1	Y2	2	16	51
5340	ApcBatLow_0_path1_T_H_OP510	NaN	NaN	{}	bool	A0-P1	X	6	1	51
5341	ApcBatLow_1_path1_T_H_OP510	NaN	NaN	{}	bool	A1-P1	Y1	6	1	51
5342	ApcBatLow_2_path1_T_H_OP510	NaN	NaN	{}	bool	A2-P1	Y2	6	1	51
5343	CncBatLow_0_path1_T_H_OP510	NaN	NaN	{}	bool	A0-P1	X	6	2	51
5344	CncBatLow_1_path1_T_H_OP510	NaN	NaN	{}	bool	A1-P1	Y1	6	2	51
5345	CncBatLow_2_path1_T_H_OP510	NaN	NaN	{}	bool	A2-P1	Y2	6	2	51
5346	ServoLeakResistData_0_path1_T_H_OP510	50	30	{}	decreasing	A0-P1	X	15	5	51
5347	ServoLeakResistData_1_path1_T_H_OP510	50	30	{}	decreasing	A1-P1	Y1	15	5	51
5348	ServoLeakResistData_2_path1_T_H_OP510	50	30	{}	decreasing	A2-P1	Y2	15	5	51
5349	InFan1SrvComPwSpeed_0_path1_T_H_OP510	6200	6000	{}	decreasing	A0-P1	X	2	9	51
5350	InFan1SrvComPwSpeed_1_path1_T_H_OP510	6200	6000	{}	decreasing	A1-P1	Y1	2	9	51
5351	InFan1SrvComPwSpeed_2_path1_T_H_OP510	6200	6000	{}	decreasing	A2-P1	Y2	2	9	51
5352	InFan2SrvAmpSpeed_0_path1_T_H_OP510	5000	4500	{}	decreasing	A0-P1	X	2	11	51
5353	InFan2SrvAmpSpeed_1_path1_T_H_OP510	5000	4500	{}	decreasing	A1-P1	Y1	2	11	51
5354	InFan2SrvAmpSpeed_2_path1_T_H_OP510	5000	4500	{}	decreasing	A2-P1	Y2	2	11	51
5355	RadFan1SrvAmpSpeed_0_path1_T_H_OP510	5000	4500	{}	decreasing	A0-P1	X	2	15	51
5356	RadFan1SrvAmpSpeed_1_path1_T_H_OP510	5000	4500	{}	decreasing	A1-P1	Y1	2	15	51
5357	RadFan1SrvAmpSpeed_2_path1_T_H_OP510	5000	4500	{}	decreasing	A2-P1	Y2	2	15	51
5358	InFan2SrvComPwSpeed_0_path1_T_H_OP510	5000	4500	{}	decreasing	A0-P1	X	2	12	51
5359	InFan2SrvComPwSpeed_1_path1_T_H_OP510	5000	4500	{}	decreasing	A1-P1	Y1	2	12	51
5360	InFan2SrvComPwSpeed_2_path1_T_H_OP510	5000	4500	{}	decreasing	A2-P1	Y2	2	12	51
5361	ServoTemp_0_path1_T_H_OP510	70	80	{}	increasing	A0-P1	X	13	3	51
5362	ServoTemp_1_path1_T_H_OP510	60	70	{}	increasing	A1-P1	Y1	13	3	51
5363	ServoTemp_2_path1_T_H_OP510	55	70	{}	increasing	A2-P1	Y2	13	3	51
5364	PulseCoderTemp_0_path1_T_H_OP520	70	80	{}	increasing	A0-P1	X	13	4	52
5365	PulseCoderTemp_1_path1_T_H_OP520	70	80	{}	increasing	A1-P1	Y1	13	4	52
5366	PulseCoderTemp_2_path1_T_H_OP520	70	80	{}	increasing	A2-P1	Y2	13	4	52
5367	CncFan1Speed_path1_T_H_OP520	4500	4000	{}	decreasing	A1-P1	F1	16	6	52
5368	CncFan2Speed_path1_T_H_OP520	9600	8600	{}	decreasing	A2-P1	F2	16	6	52
5371	InFan1SrvAmpSpeed_0_path1_T_H_OP520	9500	9000	{}	decreasing	A0-P1	X	2	8	52
5372	InFan1SrvAmpSpeed_1_path1_T_H_OP520	9500	9000	{}	decreasing	A1-P1	Y1	2	8	52
5373	InFan1SrvAmpSpeed_2_path1_T_H_OP520	9500	9000	{}	decreasing	A2-P1	Y2	2	8	52
5374	ServoLoad_0_path1_T_H_OP520	NaN	NaN	{}	increasing	A0-P1	X	17	17	52
5375	ServoLoad_1_path1_T_H_OP520	NaN	NaN	{}	increasing	A1-P1	Y1	17	17	52
5376	ServoLoad_2_path1_T_H_OP520	NaN	NaN	{}	increasing	A2-P1	Y2	17	17	52
5377	SpdBatZero_0_path1_T_H_OP520	NaN	NaN	{}	bool	A0-P1	X	6	13	52
5378	SpdBatZero_1_path1_T_H_OP520	NaN	NaN	{}	bool	A1-P1	Y1	6	13	52
5379	SpdBatZero_2_path1_T_H_OP520	NaN	NaN	{}	bool	A2-P1	Y2	6	13	52
5380	SSpdBatZero_0_path1_T_H_OP520	NaN	NaN	{}	bool	A0-P1	X	6	14	52
5381	SSpdBatZero_1_path1_T_H_OP520	NaN	NaN	{}	bool	A1-P1	Y1	6	14	52
5382	SSpdBatZero_2_path1_T_H_OP520	NaN	NaN	{}	bool	A2-P1	Y2	6	14	52
5383	RadFan2SrvAmpSpeed_0_path1_T_H_OP520	5000	4500	{}	decreasing	A0-P1	X	2	16	52
5384	RadFan2SrvAmpSpeed_1_path1_T_H_OP520	5000	4500	{}	decreasing	A1-P1	Y1	2	16	52
5385	RadFan2SrvAmpSpeed_2_path1_T_H_OP520	5000	4500	{}	decreasing	A2-P1	Y2	2	16	52
5386	ApcBatLow_0_path1_T_H_OP520	NaN	NaN	{}	bool	A0-P1	X	6	1	52
5387	ApcBatLow_1_path1_T_H_OP520	NaN	NaN	{}	bool	A1-P1	Y1	6	1	52
5388	ApcBatLow_2_path1_T_H_OP520	NaN	NaN	{}	bool	A2-P1	Y2	6	1	52
5389	CncBatLow_0_path1_T_H_OP520	NaN	NaN	{}	bool	A0-P1	X	6	2	52
5390	CncBatLow_1_path1_T_H_OP520	NaN	NaN	{}	bool	A1-P1	Y1	6	2	52
5391	CncBatLow_2_path1_T_H_OP520	NaN	NaN	{}	bool	A2-P1	Y2	6	2	52
5392	ServoLeakResistData_0_path1_T_H_OP520	50	30	{}	decreasing	A0-P1	X	15	5	52
5393	ServoLeakResistData_1_path1_T_H_OP520	50	30	{}	decreasing	A1-P1	Y1	15	5	52
5394	ServoLeakResistData_2_path1_T_H_OP520	50	30	{}	decreasing	A2-P1	Y2	15	5	52
5395	InFan1SrvComPwSpeed_0_path1_T_H_OP520	6200	6000	{}	decreasing	A0-P1	X	2	9	52
5396	InFan1SrvComPwSpeed_1_path1_T_H_OP520	6200	6000	{}	decreasing	A1-P1	Y1	2	9	52
5397	InFan1SrvComPwSpeed_2_path1_T_H_OP520	6200	6000	{}	decreasing	A2-P1	Y2	2	9	52
5398	InFan2SrvAmpSpeed_0_path1_T_H_OP520	5000	4500	{}	decreasing	A0-P1	X	2	11	52
5399	InFan2SrvAmpSpeed_1_path1_T_H_OP520	5000	4500	{}	decreasing	A1-P1	Y1	2	11	52
5400	InFan2SrvAmpSpeed_2_path1_T_H_OP520	5000	4500	{}	decreasing	A2-P1	Y2	2	11	52
5401	RadFan1SrvAmpSpeed_0_path1_T_H_OP520	5000	4500	{}	decreasing	A0-P1	X	2	15	52
5402	RadFan1SrvAmpSpeed_1_path1_T_H_OP520	5000	4500	{}	decreasing	A1-P1	Y1	2	15	52
5403	RadFan1SrvAmpSpeed_2_path1_T_H_OP520	5000	4500	{}	decreasing	A2-P1	Y2	2	15	52
5404	InFan2SrvComPwSpeed_0_path1_T_H_OP520	5000	4500	{}	decreasing	A0-P1	X	2	12	52
5405	InFan2SrvComPwSpeed_1_path1_T_H_OP520	5000	4500	{}	decreasing	A1-P1	Y1	2	12	52
5406	InFan2SrvComPwSpeed_2_path1_T_H_OP520	5000	4500	{}	decreasing	A2-P1	Y2	2	12	52
5407	ServoTemp_0_path1_T_H_OP520	60	70	{}	increasing	A0-P1	X	13	3	52
5408	ServoTemp_1_path1_T_H_OP520	55	70	{}	increasing	A1-P1	Y1	13	3	52
5409	ServoTemp_2_path1_T_H_OP520	55	70	{}	increasing	A2-P1	Y2	13	3	52
5410	PulseCoderTemp_0_path1_T_H_OP530	70	80	{}	increasing	A0-P1	X	13	4	53
5411	PulseCoderTemp_1_path1_T_H_OP530	65	80	{}	increasing	A1-P1	Y1	13	4	53
5412	PulseCoderTemp_2_path1_T_H_OP530	60	80	{}	increasing	A2-P1	Y2	13	4	53
5413	CncFan1Speed_path1_T_H_OP530	4500	4000	{}	decreasing	A1-P1	F1	16	6	53
5414	CncFan2Speed_path1_T_H_OP530	9600	8600	{}	decreasing	A2-P1	F2	16	6	53
5417	InFan1SrvAmpSpeed_0_path1_T_H_OP530	9500	9000	{}	decreasing	A0-P1	X	2	8	53
5418	InFan1SrvAmpSpeed_1_path1_T_H_OP530	9500	9000	{}	decreasing	A1-P1	Y1	2	8	53
5419	InFan1SrvAmpSpeed_2_path1_T_H_OP530	9500	9000	{}	decreasing	A2-P1	Y2	2	8	53
5420	ServoLoad_0_path1_T_H_OP530	NaN	NaN	{}	increasing	A0-P1	X	17	17	53
5421	ServoLoad_1_path1_T_H_OP530	NaN	NaN	{}	increasing	A1-P1	Y1	17	17	53
5422	ServoLoad_2_path1_T_H_OP530	NaN	NaN	{}	increasing	A2-P1	Y2	17	17	53
5423	SpdBatZero_0_path1_T_H_OP530	NaN	NaN	{}	bool	A0-P1	X	6	13	53
5424	SpdBatZero_1_path1_T_H_OP530	NaN	NaN	{}	bool	A1-P1	Y1	6	13	53
5425	SpdBatZero_2_path1_T_H_OP530	NaN	NaN	{}	bool	A2-P1	Y2	6	13	53
5426	SSpdBatZero_0_path1_T_H_OP530	NaN	NaN	{}	bool	A0-P1	X	6	14	53
5427	SSpdBatZero_1_path1_T_H_OP530	NaN	NaN	{}	bool	A1-P1	Y1	6	14	53
5428	SSpdBatZero_2_path1_T_H_OP530	NaN	NaN	{}	bool	A2-P1	Y2	6	14	53
5429	RadFan2SrvAmpSpeed_0_path1_T_H_OP530	5000	4500	{}	decreasing	A0-P1	X	2	16	53
5430	RadFan2SrvAmpSpeed_1_path1_T_H_OP530	5000	4500	{}	decreasing	A1-P1	Y1	2	16	53
5431	RadFan2SrvAmpSpeed_2_path1_T_H_OP530	5000	4500	{}	decreasing	A2-P1	Y2	2	16	53
5432	ApcBatLow_0_path1_T_H_OP530	NaN	NaN	{}	bool	A0-P1	X	6	1	53
5433	ApcBatLow_1_path1_T_H_OP530	NaN	NaN	{}	bool	A1-P1	Y1	6	1	53
5434	ApcBatLow_2_path1_T_H_OP530	NaN	NaN	{}	bool	A2-P1	Y2	6	1	53
5435	CncBatLow_0_path1_T_H_OP530	NaN	NaN	{}	bool	A0-P1	X	6	2	53
5436	CncBatLow_1_path1_T_H_OP530	NaN	NaN	{}	bool	A1-P1	Y1	6	2	53
5437	CncBatLow_2_path1_T_H_OP530	NaN	NaN	{}	bool	A2-P1	Y2	6	2	53
5438	ServoLeakResistData_0_path1_T_H_OP530	50	30	{}	decreasing	A0-P1	X	15	5	53
5439	ServoLeakResistData_1_path1_T_H_OP530	50	30	{}	decreasing	A1-P1	Y1	15	5	53
5440	ServoLeakResistData_2_path1_T_H_OP530	50	30	{}	decreasing	A2-P1	Y2	15	5	53
5441	InFan1SrvComPwSpeed_0_path1_T_H_OP530	6200	6000	{}	decreasing	A0-P1	X	2	9	53
5442	InFan1SrvComPwSpeed_1_path1_T_H_OP530	6200	6000	{}	decreasing	A1-P1	Y1	2	9	53
5443	InFan1SrvComPwSpeed_2_path1_T_H_OP530	6200	6000	{}	decreasing	A2-P1	Y2	2	9	53
5444	InFan2SrvAmpSpeed_0_path1_T_H_OP530	5000	4500	{}	decreasing	A0-P1	X	2	11	53
5445	InFan2SrvAmpSpeed_1_path1_T_H_OP530	5000	4500	{}	decreasing	A1-P1	Y1	2	11	53
5446	InFan2SrvAmpSpeed_2_path1_T_H_OP530	5000	4500	{}	decreasing	A2-P1	Y2	2	11	53
5447	RadFan1SrvAmpSpeed_0_path1_T_H_OP530	5000	4500	{}	decreasing	A0-P1	X	2	15	53
5448	RadFan1SrvAmpSpeed_1_path1_T_H_OP530	5000	4500	{}	decreasing	A1-P1	Y1	2	15	53
5449	RadFan1SrvAmpSpeed_2_path1_T_H_OP530	5000	4500	{}	decreasing	A2-P1	Y2	2	15	53
5450	InFan2SrvComPwSpeed_0_path1_T_H_OP530	5000	4500	{}	decreasing	A0-P1	X	2	12	53
5451	InFan2SrvComPwSpeed_1_path1_T_H_OP530	5000	4500	{}	decreasing	A1-P1	Y1	2	12	53
5452	InFan2SrvComPwSpeed_2_path1_T_H_OP530	5000	4500	{}	decreasing	A2-P1	Y2	2	12	53
5453	ServoTemp_0_path1_T_H_OP530	65	75	{}	increasing	A0-P1	X	13	3	53
5454	ServoTemp_1_path1_T_H_OP530	60	70	{}	increasing	A1-P1	Y1	13	3	53
5455	ServoTemp_2_path1_T_H_OP530	55	70	{}	increasing	A2-P1	Y2	13	3	53
5456	PulseCoderTemp_0_path1_T_H_OP540	75	85	{}	increasing	A0-P1	X	13	4	54
5457	PulseCoderTemp_1_path1_T_H_OP540	70	80	{}	increasing	A1-P1	Y1	13	4	54
5458	PulseCoderTemp_2_path1_T_H_OP540	70	80	{}	increasing	A2-P1	Y2	13	4	54
5459	CncFan1Speed_path1_T_H_OP540	4500	4000	{}	decreasing	A1-P1	F1	16	6	54
5460	CncFan2Speed_path1_T_H_OP540	9600	8600	{}	decreasing	A2-P1	F2	16	6	54
5463	InFan1SrvAmpSpeed_0_path1_T_H_OP540	9500	9000	{}	decreasing	A0-P1	X	2	8	54
5464	InFan1SrvAmpSpeed_1_path1_T_H_OP540	9500	9000	{}	decreasing	A1-P1	Y1	2	8	54
5465	InFan1SrvAmpSpeed_2_path1_T_H_OP540	9500	9000	{}	decreasing	A2-P1	Y2	2	8	54
5466	ServoLoad_0_path1_T_H_OP540	NaN	NaN	{}	increasing	A0-P1	X	17	17	54
5467	ServoLoad_1_path1_T_H_OP540	NaN	NaN	{}	increasing	A1-P1	Y1	17	17	54
5468	ServoLoad_2_path1_T_H_OP540	NaN	NaN	{}	increasing	A2-P1	Y2	17	17	54
5469	SpdBatZero_0_path1_T_H_OP540	NaN	NaN	{}	bool	A0-P1	X	6	13	54
5470	SpdBatZero_1_path1_T_H_OP540	NaN	NaN	{}	bool	A1-P1	Y1	6	13	54
5471	SpdBatZero_2_path1_T_H_OP540	NaN	NaN	{}	bool	A2-P1	Y2	6	13	54
5472	SSpdBatZero_0_path1_T_H_OP540	NaN	NaN	{}	bool	A0-P1	X	6	14	54
5473	SSpdBatZero_1_path1_T_H_OP540	NaN	NaN	{}	bool	A1-P1	Y1	6	14	54
5474	SSpdBatZero_2_path1_T_H_OP540	NaN	NaN	{}	bool	A2-P1	Y2	6	14	54
5475	RadFan2SrvAmpSpeed_0_path1_T_H_OP540	5000	4500	{}	decreasing	A0-P1	X	2	16	54
5476	RadFan2SrvAmpSpeed_1_path1_T_H_OP540	5000	4500	{}	decreasing	A1-P1	Y1	2	16	54
5477	RadFan2SrvAmpSpeed_2_path1_T_H_OP540	5000	4500	{}	decreasing	A2-P1	Y2	2	16	54
5478	ApcBatLow_0_path1_T_H_OP540	NaN	NaN	{}	bool	A0-P1	X	6	1	54
5479	ApcBatLow_1_path1_T_H_OP540	NaN	NaN	{}	bool	A1-P1	Y1	6	1	54
5480	ApcBatLow_2_path1_T_H_OP540	NaN	NaN	{}	bool	A2-P1	Y2	6	1	54
5481	CncBatLow_0_path1_T_H_OP540	NaN	NaN	{}	bool	A0-P1	X	6	2	54
5482	CncBatLow_1_path1_T_H_OP540	NaN	NaN	{}	bool	A1-P1	Y1	6	2	54
5483	CncBatLow_2_path1_T_H_OP540	NaN	NaN	{}	bool	A2-P1	Y2	6	2	54
5484	ServoLeakResistData_0_path1_T_H_OP540	50	30	{}	decreasing	A0-P1	X	15	5	54
5485	ServoLeakResistData_1_path1_T_H_OP540	50	30	{}	decreasing	A1-P1	Y1	15	5	54
5486	ServoLeakResistData_2_path1_T_H_OP540	50	30	{}	decreasing	A2-P1	Y2	15	5	54
5487	InFan1SrvComPwSpeed_0_path1_T_H_OP540	6200	6000	{}	decreasing	A0-P1	X	2	9	54
5488	InFan1SrvComPwSpeed_1_path1_T_H_OP540	6200	6000	{}	decreasing	A1-P1	Y1	2	9	54
5489	InFan1SrvComPwSpeed_2_path1_T_H_OP540	6200	6000	{}	decreasing	A2-P1	Y2	2	9	54
5490	InFan2SrvAmpSpeed_0_path1_T_H_OP540	5000	4500	{}	decreasing	A0-P1	X	2	11	54
5491	InFan2SrvAmpSpeed_1_path1_T_H_OP540	5000	4500	{}	decreasing	A1-P1	Y1	2	11	54
5492	InFan2SrvAmpSpeed_2_path1_T_H_OP540	5000	4500	{}	decreasing	A2-P1	Y2	2	11	54
5493	RadFan1SrvAmpSpeed_0_path1_T_H_OP540	5000	4500	{}	decreasing	A0-P1	X	2	15	54
5494	RadFan1SrvAmpSpeed_1_path1_T_H_OP540	5000	4500	{}	decreasing	A1-P1	Y1	2	15	54
5495	RadFan1SrvAmpSpeed_2_path1_T_H_OP540	5000	4500	{}	decreasing	A2-P1	Y2	2	15	54
5496	InFan2SrvComPwSpeed_0_path1_T_H_OP540	5000	4500	{}	decreasing	A0-P1	X	2	12	54
5497	InFan2SrvComPwSpeed_1_path1_T_H_OP540	5000	4500	{}	decreasing	A1-P1	Y1	2	12	54
5498	InFan2SrvComPwSpeed_2_path1_T_H_OP540	5000	4500	{}	decreasing	A2-P1	Y2	2	12	54
5499	ServoTemp_0_path1_T_H_OP540	70	80	{}	increasing	A0-P1	X	13	3	54
5500	ServoTemp_1_path1_T_H_OP540	55	70	{}	increasing	A1-P1	Y1	13	3	54
5501	ServoTemp_2_path1_T_H_OP540	55	70	{}	increasing	A2-P1	Y2	13	3	54
5502	PulseCoderTemp_0_path1_T_H_OP55	60	80	{}	increasing	A0-P1	X	13	4	55
5503	PulseCoderTemp_1_path1_T_H_OP55	60	80	{}	increasing	A1-P1	Y	13	4	55
5504	PulseCoderTemp_2_path1_T_H_OP55	60	80	{}	increasing	A2-P1	Z	13	4	55
5505	PulseCoderTemp_3_path1_T_H_OP55	60	80	{}	increasing	A3-P1	A	13	4	55
5506	PulseCoderTemp_4_path1_T_H_OP55	60	80	{}	increasing	A4-P1	V	13	4	55
5507	PulseCoderTemp_5_path1_T_H_OP55	70	80	{}	increasing	A5-P1	C	13	4	55
5510	CncFan1Speed_path1_T_H_OP55	4500	4000	{}	decreasing	A1-P1	F1	16	6	55
5511	CncFan2Speed_path1_T_H_OP55	9600	8600	{}	decreasing	A2-P1	F3	16	6	55
5514	InFan1SrvAmpSpeed_0_path1_T_H_OP55	9500	9000	{}	decreasing	A0-P1	X	2	8	55
5515	InFan1SrvAmpSpeed_1_path1_T_H_OP55	9500	9000	{}	decreasing	A1-P1	Y	2	8	55
5516	InFan1SrvAmpSpeed_2_path1_T_H_OP55	9500	9000	{}	decreasing	A2-P1	Z	2	8	55
5517	InFan1SrvAmpSpeed_3_path1_T_H_OP55	9500	9000	{}	decreasing	A3-P1	A	2	8	55
5518	InFan1SrvAmpSpeed_4_path1_T_H_OP55	8500	7500	{}	decreasing	A4-P1	V	2	8	55
5519	InFan1SrvAmpSpeed_5_path1_T_H_OP55	8500	7500	{}	decreasing	A5-P1	C	2	8	55
5522	ServoLoad_0_path1_T_H_OP55	NaN	NaN	{}	increasing	A0-P1	X	17	17	55
5523	ServoLoad_1_path1_T_H_OP55	NaN	NaN	{}	increasing	A1-P1	Y	17	17	55
5524	ServoLoad_2_path1_T_H_OP55	NaN	NaN	{}	increasing	A2-P1	Z	17	17	55
5525	ServoLoad_3_path1_T_H_OP55	NaN	NaN	{}	increasing	A3-P1	A	17	17	55
5526	ServoLoad_4_path1_T_H_OP55	NaN	NaN	{}	increasing	A4-P1	V	17	17	55
5527	ServoLoad_5_path1_T_H_OP55	NaN	NaN	{}	increasing	A5-P1	C	17	17	55
5531	SpdBatZero_0_path1_T_H_OP55	NaN	NaN	{}	bool	A0-P1	X	6	13	55
5532	SpdBatZero_1_path1_T_H_OP55	NaN	NaN	{}	bool	A1-P1	Y	6	13	55
5533	SpdBatZero_2_path1_T_H_OP55	NaN	NaN	{}	bool	A2-P1	Z	6	13	55
5534	SpdBatZero_3_path1_T_H_OP55	NaN	NaN	{}	bool	A3-P1	A	6	13	55
5535	SpdBatZero_4_path1_T_H_OP55	NaN	NaN	{}	bool	A4-P1	V	6	13	55
5536	SpdBatZero_5_path1_T_H_OP55	NaN	NaN	{}	bool	A5-P1	C	6	13	55
5539	SSpdBatZero_0_path1_T_H_OP55	NaN	NaN	{}	bool	A0-P1	X	6	14	55
5540	SSpdBatZero_1_path1_T_H_OP55	NaN	NaN	{}	bool	A1-P1	Y	6	14	55
5541	SSpdBatZero_2_path1_T_H_OP55	NaN	NaN	{}	bool	A2-P1	Z	6	14	55
5542	SSpdBatZero_3_path1_T_H_OP55	NaN	NaN	{}	bool	A3-P1	A	6	14	55
5543	SSpdBatZero_4_path1_T_H_OP55	NaN	NaN	{}	bool	A4-P1	V	6	14	55
5544	SSpdBatZero_5_path1_T_H_OP55	NaN	NaN	{}	bool	A5-P1	C	6	14	55
5548	RadFan2SrvAmpSpeed_0_path1_T_H_OP55	5000	4500	{}	decreasing	A0-P1	X	2	16	55
5549	RadFan2SrvAmpSpeed_1_path1_T_H_OP55	5000	4500	{}	decreasing	A1-P1	Y	2	16	55
5550	RadFan2SrvAmpSpeed_2_path1_T_H_OP55	5000	4500	{}	decreasing	A2-P1	Z	2	16	55
5551	RadFan2SrvAmpSpeed_3_path1_T_H_OP55	5000	4500	{}	decreasing	A3-P1	A	2	16	55
5552	RadFan2SrvAmpSpeed_4_path1_T_H_OP55	5000	4500	{}	decreasing	A4-P1	V	2	16	55
5553	RadFan2SrvAmpSpeed_5_path1_T_H_OP55	5000	4500	{}	decreasing	A5-P1	C	2	16	55
5556	ApcBatLow_0_path1_T_H_OP55	NaN	NaN	{}	bool	A0-P1	X	6	1	55
5557	ApcBatLow_1_path1_T_H_OP55	NaN	NaN	{}	bool	A1-P1	Y	6	1	55
5558	ApcBatLow_2_path1_T_H_OP55	NaN	NaN	{}	bool	A2-P1	Z	6	1	55
5559	ApcBatLow_3_path1_T_H_OP55	NaN	NaN	{}	bool	A3-P1	A	6	1	55
5560	ApcBatLow_4_path1_T_H_OP55	NaN	NaN	{}	bool	A4-P1	V	6	1	55
5561	ApcBatLow_5_path1_T_H_OP55	NaN	NaN	{}	bool	A5-P1	C	6	1	55
5564	CncBatLow_0_path1_T_H_OP55	NaN	NaN	{}	bool	A0-P1	X	6	2	55
5565	CncBatLow_1_path1_T_H_OP55	NaN	NaN	{}	bool	A1-P1	Y	6	2	55
5566	CncBatLow_2_path1_T_H_OP55	NaN	NaN	{}	bool	A2-P1	Z	6	2	55
5567	CncBatLow_3_path1_T_H_OP55	NaN	NaN	{}	bool	A3-P1	A	6	2	55
5568	CncBatLow_4_path1_T_H_OP55	NaN	NaN	{}	bool	A4-P1	V	6	2	55
5569	CncBatLow_5_path1_T_H_OP55	NaN	NaN	{}	bool	A5-P1	C	6	2	55
5572	ServoLeakResistData_0_path1_T_H_OP55	50	30	{}	decreasing	A0-P1	X	15	5	55
5573	ServoLeakResistData_1_path1_T_H_OP55	50	30	{}	decreasing	A1-P1	Y	15	5	55
5574	ServoLeakResistData_2_path1_T_H_OP55	50	30	{}	decreasing	A2-P1	Z	15	5	55
5575	ServoLeakResistData_3_path1_T_H_OP55	50	30	{}	decreasing	A3-P1	A	15	5	55
5576	ServoLeakResistData_4_path1_T_H_OP55	50	30	{}	decreasing	A4-P1	V	15	5	55
5577	ServoLeakResistData_5_path1_T_H_OP55	50	30	{}	decreasing	A5-P1	C	15	5	55
5581	InFan1SrvComPwSpeed_0_path1_T_H_OP55	6200	6000	{}	decreasing	A0-P1	X	2	9	55
5582	InFan1SrvComPwSpeed_1_path1_T_H_OP55	6200	6000	{}	decreasing	A1-P1	Y	2	9	55
5583	InFan1SrvComPwSpeed_2_path1_T_H_OP55	6200	6000	{}	decreasing	A2-P1	Z	2	9	55
5584	InFan1SrvComPwSpeed_3_path1_T_H_OP55	6200	6000	{}	decreasing	A3-P1	A	2	9	55
5585	InFan1SrvComPwSpeed_4_path1_T_H_OP55	6200	6000	{}	decreasing	A4-P1	V	2	9	55
5586	InFan1SrvComPwSpeed_5_path1_T_H_OP55	6200	6000	{}	decreasing	A5-P1	C	2	9	55
5589	InFan2SrvAmpSpeed_0_path1_T_H_OP55	5000	4500	{}	decreasing	A0-P1	X	2	11	55
5590	InFan2SrvAmpSpeed_1_path1_T_H_OP55	5000	4500	{}	decreasing	A1-P1	Y	2	11	55
5591	InFan2SrvAmpSpeed_2_path1_T_H_OP55	5000	4500	{}	decreasing	A2-P1	Z	2	11	55
5592	InFan2SrvAmpSpeed_3_path1_T_H_OP55	5000	4500	{}	decreasing	A3-P1	A	2	11	55
5593	InFan2SrvAmpSpeed_4_path1_T_H_OP55	5000	4500	{}	decreasing	A4-P1	V	2	11	55
5594	InFan2SrvAmpSpeed_5_path1_T_H_OP55	5000	4500	{}	decreasing	A5-P1	C	2	11	55
5598	RadFan1SrvAmpSpeed_0_path1_T_H_OP55	5000	4500	{}	decreasing	A0-P1	X	2	15	55
5599	RadFan1SrvAmpSpeed_1_path1_T_H_OP55	5000	4500	{}	decreasing	A1-P1	Y	2	15	55
5600	RadFan1SrvAmpSpeed_2_path1_T_H_OP55	5000	4500	{}	decreasing	A2-P1	Z	2	15	55
5601	RadFan1SrvAmpSpeed_3_path1_T_H_OP55	5000	4500	{}	decreasing	A3-P1	A	2	15	55
5602	RadFan1SrvAmpSpeed_4_path1_T_H_OP55	5000	4500	{}	decreasing	A4-P1	V	2	15	55
5603	RadFan1SrvAmpSpeed_5_path1_T_H_OP55	5000	4500	{}	decreasing	A5-P1	C	2	15	55
5606	InFan2SpdlComPwSpeed_0_path1_T_H_OP55	5000	4500	{}	decreasing	A0-P1	SAS	2	10	55
5607	InFan2SpindleAmpSpeed_0_path1_T_H_OP55	5000	4500	{}	decreasing	A0-P1	SCS	2	10	55
5608	InFan2SrvComPwSpeed_0_path1_T_H_OP55	5000	4500	{}	decreasing	A0-P1	X	2	12	55
5609	InFan2SrvComPwSpeed_1_path1_T_H_OP55	5000	4500	{}	decreasing	A1-P1	Y	2	12	55
5610	InFan2SrvComPwSpeed_2_path1_T_H_OP55	5000	4500	{}	decreasing	A2-P1	Z	2	12	55
5611	InFan2SrvComPwSpeed_3_path1_T_H_OP55	5000	4500	{}	decreasing	A3-P1	A	2	12	55
5612	InFan2SrvComPwSpeed_4_path1_T_H_OP55	5000	4500	{}	decreasing	A4-P1	V	2	12	55
5613	InFan2SrvComPwSpeed_5_path1_T_H_OP55	5000	4500	{}	decreasing	A5-P1	C	2	12	55
5616	InFan1SpdlComPwSpeed_0_path1_T_H_OP55	5000	4500	{}	decreasing	A0-P1	SAS	2	7	55
5617	InFan1SpindleAmpSpeed_0_path1_T_H_OP55	5000	4500	{}	decreasing	A0-P1	SCS	2	7	55
5618	ServoTemp_0_path1_T_H_OP55	55	70	{}	increasing	A0-P1	X	13	3	55
5619	ServoTemp_1_path1_T_H_OP55	55	70	{}	increasing	A1-P1	Y	13	3	55
5620	ServoTemp_2_path1_T_H_OP55	55	70	{}	increasing	A2-P1	Z	13	3	55
5621	ServoTemp_3_path1_T_H_OP55	55	70	{}	increasing	A3-P1	A	13	3	55
5622	ServoTemp_4_path1_T_H_OP55	55	70	{}	increasing	A4-P1	V	13	3	55
5623	ServoTemp_5_path1_T_H_OP55	55	70	{}	increasing	A5-P1	C	13	3	55
5627	PulseCoderTemp_0_path1_T_H_OP550	85	90	{}	increasing	A0-P1	X	13	4	56
5628	PulseCoderTemp_1_path1_T_H_OP550	70	80	{}	increasing	A1-P1	Y1	13	4	56
5629	PulseCoderTemp_2_path1_T_H_OP550	70	80	{}	increasing	A2-P1	Y2	13	4	56
5630	CncFan1Speed_path1_T_H_OP550	4500	4000	{}	decreasing	A1-P1	F1	16	6	56
5631	CncFan2Speed_path1_T_H_OP550	9600	8600	{}	decreasing	A2-P1	F3	16	6	56
5634	InFan1SrvAmpSpeed_0_path1_T_H_OP550	9500	9000	{}	decreasing	A0-P1	X	2	8	56
5635	InFan1SrvAmpSpeed_1_path1_T_H_OP550	7500	7000	{}	decreasing	A1-P1	Y1	2	8	56
5636	InFan1SrvAmpSpeed_2_path1_T_H_OP550	7500	7000	{}	decreasing	A2-P1	Y2	2	8	56
5637	ServoLoad_0_path1_T_H_OP550	NaN	NaN	{}	increasing	A0-P1	X	17	17	56
5638	ServoLoad_1_path1_T_H_OP550	NaN	NaN	{}	increasing	A1-P1	Y1	17	17	56
5639	ServoLoad_2_path1_T_H_OP550	NaN	NaN	{}	increasing	A2-P1	Y2	17	17	56
5641	SpdBatZero_0_path1_T_H_OP550	NaN	NaN	{}	bool	A0-P1	X	6	13	56
5642	SpdBatZero_1_path1_T_H_OP550	NaN	NaN	{}	bool	A1-P1	Y1	6	13	56
5643	SpdBatZero_2_path1_T_H_OP550	NaN	NaN	{}	bool	A2-P1	Y2	6	13	56
5644	SSpdBatZero_0_path1_T_H_OP550	NaN	NaN	{}	bool	A0-P1	X	6	14	56
5645	SSpdBatZero_1_path1_T_H_OP550	NaN	NaN	{}	bool	A1-P1	Y1	6	14	56
5646	SSpdBatZero_2_path1_T_H_OP550	NaN	NaN	{}	bool	A2-P1	Y2	6	14	56
5648	RadFan2SrvAmpSpeed_0_path1_T_H_OP550	5000	4500	{}	decreasing	A0-P1	X	2	16	56
5649	RadFan2SrvAmpSpeed_1_path1_T_H_OP550	5000	4500	{}	decreasing	A1-P1	Y1	2	16	56
5650	RadFan2SrvAmpSpeed_2_path1_T_H_OP550	5000	4500	{}	decreasing	A2-P1	Y2	2	16	56
5651	ApcBatLow_0_path1_T_H_OP550	NaN	NaN	{}	bool	A0-P1	X	6	1	56
5652	ApcBatLow_1_path1_T_H_OP550	NaN	NaN	{}	bool	A1-P1	Y1	6	1	56
5653	ApcBatLow_2_path1_T_H_OP550	NaN	NaN	{}	bool	A2-P1	Y2	6	1	56
5654	CncBatLow_0_path1_T_H_OP550	NaN	NaN	{}	bool	A0-P1	X	6	2	56
5655	CncBatLow_1_path1_T_H_OP550	NaN	NaN	{}	bool	A1-P1	Y1	6	2	56
5656	CncBatLow_2_path1_T_H_OP550	NaN	NaN	{}	bool	A2-P1	Y2	6	2	56
5657	ServoLeakResistData_0_path1_T_H_OP550	50	30	{}	decreasing	A0-P1	X	15	5	56
5658	ServoLeakResistData_1_path1_T_H_OP550	50	30	{}	decreasing	A1-P1	Y1	15	5	56
5659	ServoLeakResistData_2_path1_T_H_OP550	50	30	{}	decreasing	A2-P1	Y2	15	5	56
5661	InFan1SrvComPwSpeed_0_path1_T_H_OP550	6200	6000	{}	decreasing	A0-P1	X	2	9	56
5662	InFan1SrvComPwSpeed_1_path1_T_H_OP550	6200	6000	{}	decreasing	A1-P1	Y1	2	9	56
5663	InFan2SrvAmpSpeed_0_path1_T_H_OP550	5000	4500	{}	decreasing	A0-P1	X	2	11	56
5664	InFan2SrvAmpSpeed_1_path1_T_H_OP550	5000	4500	{}	decreasing	A1-P1	Y1	2	11	56
5665	InFan2SrvAmpSpeed_2_path1_T_H_OP550	5000	4500	{}	decreasing	A2-P1	Y2	2	11	56
5667	RadFan1SrvAmpSpeed_0_path1_T_H_OP550	5000	4500	{}	decreasing	A0-P1	X	2	15	56
5668	RadFan1SrvAmpSpeed_1_path1_T_H_OP550	5000	4500	{}	decreasing	A1-P1	Y1	2	15	56
5669	RadFan1SrvAmpSpeed_2_path1_T_H_OP550	5000	4500	{}	decreasing	A2-P1	Y2	2	15	56
5670	InFan2SpdlComPwSpeed_0_path1_T_H_OP550	5000	4500	{}	decreasing	A0-P1	SAS	2	10	56
5671	InFan2SpindleAmpSpeed_0_path1_T_H_OP550	5000	4500	{}	decreasing	A0-P1	SCS	2	10	56
5672	InFan2SrvComPwSpeed_0_path1_T_H_OP550	5000	4500	{}	decreasing	A0-P1	X	2	12	56
5673	InFan2SrvComPwSpeed_1_path1_T_H_OP550	5000	4500	{}	decreasing	A1-P1	Y1	2	12	56
5674	InFan1SpdlComPwSpeed_0_path1_T_H_OP550	5000	4500	{}	decreasing	A0-P1	SAS	2	7	56
5675	InFan1SpindleAmpSpeed_0_path1_T_H_OP550	5000	4500	{}	decreasing	A0-P1	SCS	2	7	56
5676	ServoTemp_0_path1_T_H_OP550	85	90	{}	increasing	A0-P1	X	13	3	56
5677	ServoTemp_1_path1_T_H_OP550	65	75	{}	increasing	A1-P1	Y1	13	3	56
5678	ServoTemp_2_path1_T_H_OP550	60	70	{}	increasing	A2-P1	Y2	13	3	56
5680	PulseCoderTemp_0_path1_T_H_OP80A	60	80	{}	increasing	A0-P1	X	13	4	57
5681	PulseCoderTemp_1_path1_T_H_OP80A	60	80	{}	increasing	A1-P1	Z	13	4	57
5682	PulseCoderTemp_2_path1_T_H_OP80A	60	80	{}	increasing	A2-P1	Y	13	4	57
5683	PulseCoderTemp_3_path1_T_H_OP80A	60	80	{}	increasing	A3-P1	YS	13	4	57
5684	PulseCoderTemp_4_path1_T_H_OP80A	60	80	{}	increasing	A4-P1	B1	13	4	57
5685	PulseCoderTemp_5_path1_T_H_OP80A	60	80	{}	increasing	A5-P1	BMG	13	4	57
5686	PulseCoderTemp_6_path1_T_H_OP80A	60	80	{}	increasing	A6-P1	A2	13	4	57
5687	PulseCoderTemp_7_path1_T_H_OP80A	60	80	{}	increasing	A7-P1	AT	13	4	57
5688	CncFan1Speed_path1_T_H_OP80A	4500	4000	{}	decreasing	A1-P1	F1	16	6	57
5689	CncFan2Speed_path1_T_H_OP80A	9600	8600	{}	decreasing	A2-P1	F2	16	6	57
5690	CncFan3Speed_path1_T_H_OP80A	5000	4500	{}	decreasing	A3-P1	F3	16	6	57
5691	CncFan4Speed_path1_T_H_OP80A	5000	4500	{}	decreasing	A4-P1	F4	16	6	57
5692	InFan1SrvAmpSpeed_0_path1_T_H_OP80A	9500	9000	{}	decreasing	A0-P1	X	2	8	57
5693	InFan1SrvAmpSpeed_1_path1_T_H_OP80A	9500	9000	{}	decreasing	A1-P1	Z	2	8	57
5694	InFan1SrvAmpSpeed_2_path1_T_H_OP80A	9500	9000	{}	decreasing	A2-P1	Y	2	8	57
5695	InFan1SrvAmpSpeed_3_path1_T_H_OP80A	9500	9000	{}	decreasing	A3-P1	YS	2	8	57
5696	InFan1SrvAmpSpeed_4_path1_T_H_OP80A	8500	7500	{}	decreasing	A4-P1	B1	2	8	57
5697	InFan1SrvAmpSpeed_5_path1_T_H_OP80A	8500	7500	{}	decreasing	A5-P1	BMG	2	8	57
5698	InFan1SrvAmpSpeed_6_path1_T_H_OP80A	9500	9000	{}	decreasing	A6-P1	A2	2	8	57
5699	InFan1SrvAmpSpeed_7_path1_T_H_OP80A	8500	7500	{}	decreasing	A7-P1	AT	2	8	57
5700	ServoLoad_0_path1_T_H_OP80A	NaN	NaN	{}	increasing	A0-P1	X	17	17	57
5701	ServoLoad_1_path1_T_H_OP80A	NaN	NaN	{}	increasing	A1-P1	Z	17	17	57
5702	ServoLoad_2_path1_T_H_OP80A	NaN	NaN	{}	increasing	A2-P1	Y	17	17	57
5703	ServoLoad_3_path1_T_H_OP80A	NaN	NaN	{}	increasing	A3-P1	YS	17	17	57
5704	ServoLoad_4_path1_T_H_OP80A	NaN	NaN	{}	increasing	A4-P1	B1	17	17	57
5705	ServoLoad_5_path1_T_H_OP80A	NaN	NaN	{}	increasing	A5-P1	BMG	17	17	57
5706	ServoLoad_6_path1_T_H_OP80A	NaN	NaN	{}	increasing	A6-P1	A2	17	17	57
5707	ServoLoad_7_path1_T_H_OP80A	NaN	NaN	{}	increasing	A7-P1	AT	17	17	57
5708	SpindleLoad_0_path1_T_H_OP80A	NaN	NaN	{}	increasing	SP-P1	SP	17	17	57
5709	SpdBatZero_0_path1_T_H_OP80A	NaN	NaN	{}	bool	A0-P1	X	6	13	57
5710	SpdBatZero_1_path1_T_H_OP80A	NaN	NaN	{}	bool	A1-P1	Z	6	13	57
5711	SpdBatZero_2_path1_T_H_OP80A	NaN	NaN	{}	bool	A2-P1	Y	6	13	57
5712	SpdBatZero_3_path1_T_H_OP80A	NaN	NaN	{}	bool	A3-P1	YS	6	13	57
5713	SpdBatZero_4_path1_T_H_OP80A	NaN	NaN	{}	bool	A4-P1	B1	6	13	57
5714	SpdBatZero_5_path1_T_H_OP80A	NaN	NaN	{}	bool	A5-P1	BMG	6	13	57
5715	SpdBatZero_6_path1_T_H_OP80A	NaN	NaN	{}	bool	A6-P1	A2	6	13	57
5716	SpdBatZero_7_path1_T_H_OP80A	NaN	NaN	{}	bool	A7-P1	AT	6	13	57
5717	SSpdBatZero_0_path1_T_H_OP80A	NaN	NaN	{}	bool	A0-P1	X	6	14	57
5718	SSpdBatZero_1_path1_T_H_OP80A	NaN	NaN	{}	bool	A1-P1	Z	6	14	57
5719	SSpdBatZero_2_path1_T_H_OP80A	NaN	NaN	{}	bool	A2-P1	Y	6	14	57
5720	SSpdBatZero_3_path1_T_H_OP80A	NaN	NaN	{}	bool	A3-P1	YS	6	14	57
5721	SSpdBatZero_4_path1_T_H_OP80A	NaN	NaN	{}	bool	A4-P1	B1	6	14	57
5722	SSpdBatZero_5_path1_T_H_OP80A	NaN	NaN	{}	bool	A5-P1	BMG	6	14	57
5723	SSpdBatZero_6_path1_T_H_OP80A	NaN	NaN	{}	bool	A6-P1	A2	6	14	57
5724	SSpdBatZero_7_path1_T_H_OP80A	NaN	NaN	{}	bool	A7-P1	AT	6	14	57
5725	RadFan2SpindleAmpSpeed_0_path1_T_H_OP80A	5000	4500	{}	decreasing	SP-P1	SP	2	16	57
5726	RadFan2SrvAmpSpeed_0_path1_T_H_OP80A	5000	4500	{}	decreasing	A0-P1	X	2	16	57
5727	RadFan2SrvAmpSpeed_1_path1_T_H_OP80A	5000	4500	{}	decreasing	A1-P1	Z	2	16	57
5728	RadFan2SrvAmpSpeed_2_path1_T_H_OP80A	5000	4500	{}	decreasing	A2-P1	Y	2	16	57
5729	RadFan2SrvAmpSpeed_3_path1_T_H_OP80A	5000	4500	{}	decreasing	A3-P1	YS	2	16	57
5730	RadFan2SrvAmpSpeed_4_path1_T_H_OP80A	5000	4500	{}	decreasing	A4-P1	B1	2	16	57
5731	RadFan2SrvAmpSpeed_5_path1_T_H_OP80A	5000	4500	{}	decreasing	A5-P1	BMG	2	16	57
5732	RadFan2SrvAmpSpeed_6_path1_T_H_OP80A	5000	4500	{}	decreasing	A6-P1	A2	2	16	57
5733	RadFan2SrvAmpSpeed_7_path1_T_H_OP80A	5000	4500	{}	decreasing	A7-P1	AT	2	16	57
5734	ApcBatLow_0_path1_T_H_OP80A	NaN	NaN	{}	bool	A0-P1	X	6	1	57
5735	ApcBatLow_1_path1_T_H_OP80A	NaN	NaN	{}	bool	A1-P1	Z	6	1	57
5736	ApcBatLow_2_path1_T_H_OP80A	NaN	NaN	{}	bool	A2-P1	Y	6	1	57
5737	ApcBatLow_3_path1_T_H_OP80A	NaN	NaN	{}	bool	A3-P1	YS	6	1	57
5738	ApcBatLow_4_path1_T_H_OP80A	NaN	NaN	{}	bool	A4-P1	B1	6	1	57
5739	ApcBatLow_5_path1_T_H_OP80A	NaN	NaN	{}	bool	A5-P1	BMG	6	1	57
5740	ApcBatLow_6_path1_T_H_OP80A	NaN	NaN	{}	bool	A6-P1	A2	6	1	57
5741	ApcBatLow_7_path1_T_H_OP80A	NaN	NaN	{}	bool	A7-P1	AT	6	1	57
5742	CncBatLow_0_path1_T_H_OP80A	NaN	NaN	{}	bool	A0-P1	X	6	2	57
5743	CncBatLow_1_path1_T_H_OP80A	NaN	NaN	{}	bool	A1-P1	Z	6	2	57
5744	CncBatLow_2_path1_T_H_OP80A	NaN	NaN	{}	bool	A2-P1	Y	6	2	57
5745	CncBatLow_3_path1_T_H_OP80A	NaN	NaN	{}	bool	A3-P1	YS	6	2	57
5746	CncBatLow_4_path1_T_H_OP80A	NaN	NaN	{}	bool	A4-P1	B1	6	2	57
5747	CncBatLow_5_path1_T_H_OP80A	NaN	NaN	{}	bool	A5-P1	BMG	6	2	57
5748	CncBatLow_6_path1_T_H_OP80A	NaN	NaN	{}	bool	A6-P1	A2	6	2	57
5749	CncBatLow_7_path1_T_H_OP80A	NaN	NaN	{}	bool	A7-P1	AT	6	2	57
5750	ServoLeakResistData_0_path1_T_H_OP80A	50	30	{}	decreasing	A0-P1	X	15	5	57
5751	ServoLeakResistData_1_path1_T_H_OP80A	50	30	{}	decreasing	A1-P1	Z	15	5	57
5752	ServoLeakResistData_2_path1_T_H_OP80A	50	30	{}	decreasing	A2-P1	Y	15	5	57
5753	ServoLeakResistData_3_path1_T_H_OP80A	50	30	{}	decreasing	A3-P1	YS	15	5	57
5754	ServoLeakResistData_4_path1_T_H_OP80A	50	30	{}	decreasing	A4-P1	B1	15	5	57
5755	ServoLeakResistData_5_path1_T_H_OP80A	50	30	{}	decreasing	A5-P1	BMG	15	5	57
5756	ServoLeakResistData_6_path1_T_H_OP80A	50	30	{}	decreasing	A6-P1	A2	15	5	57
5757	ServoLeakResistData_7_path1_T_H_OP80A	50	30	{}	decreasing	A7-P1	AT	15	5	57
5758	SpindleLeakResistData_0_path1_T_H_OP80A	50	30	{}	decreasing	SP-P1	SP	15	5	57
5759	InFan1SrvComPwSpeed_0_path1_T_H_OP80A	6200	6000	{}	decreasing	A0-P1	X	2	9	57
5760	InFan1SrvComPwSpeed_1_path1_T_H_OP80A	6200	6000	{}	decreasing	A1-P1	Z	2	9	57
5761	InFan1SrvComPwSpeed_2_path1_T_H_OP80A	6200	6000	{}	decreasing	A2-P1	Y	2	9	57
5762	InFan1SrvComPwSpeed_3_path1_T_H_OP80A	6200	6000	{}	decreasing	A3-P1	YS	2	9	57
5763	InFan1SrvComPwSpeed_4_path1_T_H_OP80A	6200	6000	{}	decreasing	A4-P1	B1	2	9	57
5764	InFan1SrvComPwSpeed_5_path1_T_H_OP80A	6200	6000	{}	decreasing	A5-P1	BMG	2	9	57
5765	InFan1SrvComPwSpeed_6_path1_T_H_OP80A	6200	6000	{}	decreasing	A6-P1	A2	2	9	57
5766	InFan1SrvComPwSpeed_7_path1_T_H_OP80A	6200	6000	{}	decreasing	A7-P1	AT	2	9	57
5767	InFan2SrvAmpSpeed_0_path1_T_H_OP80A	5000	4500	{}	decreasing	A0-P1	X	2	11	57
5768	InFan2SrvAmpSpeed_1_path1_T_H_OP80A	5000	4500	{}	decreasing	A1-P1	Z	2	11	57
5769	InFan2SrvAmpSpeed_2_path1_T_H_OP80A	5000	4500	{}	decreasing	A2-P1	Y	2	11	57
5770	InFan2SrvAmpSpeed_3_path1_T_H_OP80A	5000	4500	{}	decreasing	A3-P1	YS	2	11	57
5771	InFan2SrvAmpSpeed_4_path1_T_H_OP80A	5000	4500	{}	decreasing	A4-P1	B1	2	11	57
5772	InFan2SrvAmpSpeed_5_path1_T_H_OP80A	5000	4500	{}	decreasing	A5-P1	BMG	2	11	57
5773	InFan2SrvAmpSpeed_6_path1_T_H_OP80A	5000	4500	{}	decreasing	A6-P1	A2	2	11	57
5774	InFan2SrvAmpSpeed_7_path1_T_H_OP80A	5000	4500	{}	decreasing	A7-P1	AT	2	11	57
5775	RadFan1SpindleAmpSpeed_0_path1_T_H_OP80A	5000	4500	{}	decreasing	SP-P1	SP	2	15	57
5776	RadFan1SrvAmpSpeed_0_path1_T_H_OP80A	5000	4500	{}	decreasing	A0-P1	X	2	15	57
5777	RadFan1SrvAmpSpeed_1_path1_T_H_OP80A	5000	4500	{}	decreasing	A1-P1	Z	2	15	57
5778	RadFan1SrvAmpSpeed_2_path1_T_H_OP80A	5000	4500	{}	decreasing	A2-P1	Y	2	15	57
5779	RadFan1SrvAmpSpeed_3_path1_T_H_OP80A	5000	4500	{}	decreasing	A3-P1	YS	2	15	57
5780	RadFan1SrvAmpSpeed_4_path1_T_H_OP80A	5000	4500	{}	decreasing	A4-P1	B1	2	15	57
5781	RadFan1SrvAmpSpeed_5_path1_T_H_OP80A	5000	4500	{}	decreasing	A5-P1	BMG	2	15	57
5782	RadFan1SrvAmpSpeed_6_path1_T_H_OP80A	5000	4500	{}	decreasing	A6-P1	A2	2	15	57
5783	RadFan1SrvAmpSpeed_7_path1_T_H_OP80A	5000	4500	{}	decreasing	A7-P1	AT	2	15	57
5784	InFan2SpdlComPwSpeed_0_path1_T_H_OP80A	5000	4500	{}	decreasing	A0-P1	SAS	2	10	57
5785	InFan2SpindleAmpSpeed_0_path1_T_H_OP80A	5000	4500	{}	decreasing	A0-P1	SCS	2	10	57
5786	InFan2SrvComPwSpeed_0_path1_T_H_OP80A	5000	4500	{}	decreasing	A0-P1	X	2	12	57
5787	InFan2SrvComPwSpeed_1_path1_T_H_OP80A	5000	4500	{}	decreasing	A1-P1	Z	2	12	57
5788	InFan2SrvComPwSpeed_2_path1_T_H_OP80A	5000	4500	{}	decreasing	A2-P1	Y	2	12	57
5789	InFan2SrvComPwSpeed_3_path1_T_H_OP80A	5000	4500	{}	decreasing	A3-P1	YS	2	12	57
5790	InFan2SrvComPwSpeed_4_path1_T_H_OP80A	5000	4500	{}	decreasing	A4-P1	B1	2	12	57
5791	InFan2SrvComPwSpeed_5_path1_T_H_OP80A	5000	4500	{}	decreasing	A5-P1	BMG	2	12	57
5792	InFan2SrvComPwSpeed_6_path1_T_H_OP80A	5000	4500	{}	decreasing	A6-P1	A2	2	12	57
5793	InFan2SrvComPwSpeed_7_path1_T_H_OP80A	5000	4500	{}	decreasing	A7-P1	AT	2	12	57
5794	InFan1SpdlComPwSpeed_0_path1_T_H_OP80A	5000	4500	{}	decreasing	A0-P1	SAS	2	7	57
5795	InFan1SpindleAmpSpeed_0_path1_T_H_OP80A	6200	6000	{}	decreasing	A0-P1	SCS	2	7	57
5796	ServoTemp_0_path1_T_H_OP80A	55	70	{}	increasing	A0-P1	X	13	3	57
5797	ServoTemp_1_path1_T_H_OP80A	55	70	{}	increasing	A1-P1	Z	13	3	57
5798	ServoTemp_2_path1_T_H_OP80A	55	70	{}	increasing	A2-P1	Y	13	3	57
5799	ServoTemp_3_path1_T_H_OP80A	55	70	{}	increasing	A3-P1	YS	13	3	57
5800	ServoTemp_4_path1_T_H_OP80A	55	70	{}	increasing	A4-P1	B1	13	3	57
5801	ServoTemp_5_path1_T_H_OP80A	55	70	{}	increasing	A5-P1	BMG	13	3	57
5802	ServoTemp_6_path1_T_H_OP80A	55	70	{}	increasing	A6-P1	A2	13	3	57
5803	ServoTemp_7_path1_T_H_OP80A	55	70	{}	increasing	A7-P1	AT	13	3	57
5804	SpindleTemp_0_path1_T_H_OP80A	80	100	{}	increasing	SP-P1	SP	13	3	57
5805	PulseCoderTemp_0_path1_T_H_OP80B	60	80	{}	increasing	A0-P1	X	13	4	58
5806	PulseCoderTemp_1_path1_T_H_OP80B	60	80	{}	increasing	A1-P1	Z	13	4	58
5807	PulseCoderTemp_2_path1_T_H_OP80B	60	80	{}	increasing	A2-P1	Y	13	4	58
5808	PulseCoderTemp_3_path1_T_H_OP80B	60	80	{}	increasing	A3-P1	YS	13	4	58
5809	PulseCoderTemp_4_path1_T_H_OP80B	60	80	{}	increasing	A4-P1	B1	13	4	58
5810	PulseCoderTemp_5_path1_T_H_OP80B	60	80	{}	increasing	A5-P1	BMG	13	4	58
5811	PulseCoderTemp_6_path1_T_H_OP80B	60	80	{}	increasing	A6-P1	A2	13	4	58
5812	PulseCoderTemp_7_path1_T_H_OP80B	60	80	{}	increasing	A7-P1	AT	13	4	58
5813	CncFan1Speed_path1_T_H_OP80B	4500	4000	{}	decreasing	A1-P1	F1	16	6	58
5814	CncFan2Speed_path1_T_H_OP80B	9600	8600	{}	decreasing	A2-P1	F3	16	6	58
5817	InFan1SrvAmpSpeed_0_path1_T_H_OP80B	9500	9000	{}	decreasing	A0-P1	X	2	8	58
5818	InFan1SrvAmpSpeed_1_path1_T_H_OP80B	9500	9000	{}	decreasing	A1-P1	Z	2	8	58
5819	InFan1SrvAmpSpeed_2_path1_T_H_OP80B	9500	9000	{}	decreasing	A2-P1	Y	2	8	58
5820	InFan1SrvAmpSpeed_3_path1_T_H_OP80B	9500	9000	{}	decreasing	A3-P1	YS	2	8	58
5821	InFan1SrvAmpSpeed_4_path1_T_H_OP80B	8500	7500	{}	decreasing	A4-P1	B1	2	8	58
5822	InFan1SrvAmpSpeed_5_path1_T_H_OP80B	8500	7500	{}	decreasing	A5-P1	BMG	2	8	58
5823	InFan1SrvAmpSpeed_6_path1_T_H_OP80B	9500	9000	{}	decreasing	A6-P1	A2	2	8	58
5824	InFan1SrvAmpSpeed_7_path1_T_H_OP80B	8500	7500	{}	decreasing	A7-P1	AT	2	8	58
5825	ServoLoad_0_path1_T_H_OP80B	NaN	NaN	{}	increasing	A0-P1	X	17	17	58
5826	ServoLoad_1_path1_T_H_OP80B	NaN	NaN	{}	increasing	A1-P1	Z	17	17	58
5827	ServoLoad_2_path1_T_H_OP80B	NaN	NaN	{}	increasing	A2-P1	Y	17	17	58
5828	ServoLoad_3_path1_T_H_OP80B	NaN	NaN	{}	increasing	A3-P1	YS	17	17	58
5829	ServoLoad_4_path1_T_H_OP80B	NaN	NaN	{}	increasing	A4-P1	B1	17	17	58
5830	ServoLoad_5_path1_T_H_OP80B	NaN	NaN	{}	increasing	A5-P1	BMG	17	17	58
5831	ServoLoad_6_path1_T_H_OP80B	NaN	NaN	{}	increasing	A6-P1	A2	17	17	58
5832	ServoLoad_7_path1_T_H_OP80B	NaN	NaN	{}	increasing	A7-P1	AT	17	17	58
5833	SpindleLoad_0_path1_T_H_OP80B	NaN	NaN	{}	increasing	SP-P1	SP	17	17	58
5834	SpdBatZero_0_path1_T_H_OP80B	NaN	NaN	{}	bool	A0-P1	X	6	13	58
5835	SpdBatZero_1_path1_T_H_OP80B	NaN	NaN	{}	bool	A1-P1	Z	6	13	58
5836	SpdBatZero_2_path1_T_H_OP80B	NaN	NaN	{}	bool	A2-P1	Y	6	13	58
5837	SpdBatZero_3_path1_T_H_OP80B	NaN	NaN	{}	bool	A3-P1	YS	6	13	58
5838	SpdBatZero_4_path1_T_H_OP80B	NaN	NaN	{}	bool	A4-P1	B1	6	13	58
5839	SpdBatZero_5_path1_T_H_OP80B	NaN	NaN	{}	bool	A5-P1	BMG	6	13	58
5840	SpdBatZero_6_path1_T_H_OP80B	NaN	NaN	{}	bool	A6-P1	A2	6	13	58
5841	SpdBatZero_7_path1_T_H_OP80B	NaN	NaN	{}	bool	A7-P1	AT	6	13	58
5842	SSpdBatZero_0_path1_T_H_OP80B	NaN	NaN	{}	bool	A0-P1	X	6	14	58
5843	SSpdBatZero_1_path1_T_H_OP80B	NaN	NaN	{}	bool	A1-P1	Z	6	14	58
5844	SSpdBatZero_2_path1_T_H_OP80B	NaN	NaN	{}	bool	A2-P1	Y	6	14	58
5845	SSpdBatZero_3_path1_T_H_OP80B	NaN	NaN	{}	bool	A3-P1	YS	6	14	58
5846	SSpdBatZero_4_path1_T_H_OP80B	NaN	NaN	{}	bool	A4-P1	B1	6	14	58
5847	SSpdBatZero_5_path1_T_H_OP80B	NaN	NaN	{}	bool	A5-P1	BMG	6	14	58
5848	SSpdBatZero_6_path1_T_H_OP80B	NaN	NaN	{}	bool	A6-P1	A2	6	14	58
5849	SSpdBatZero_7_path1_T_H_OP80B	NaN	NaN	{}	bool	A7-P1	AT	6	14	58
5850	RadFan2SpindleAmpSpeed_0_path1_T_H_OP80B	5000	4500	{}	decreasing	SP-P1	SP	2	16	58
5851	RadFan2SrvAmpSpeed_0_path1_T_H_OP80B	5000	4500	{}	decreasing	A0-P1	X	2	16	58
5852	RadFan2SrvAmpSpeed_1_path1_T_H_OP80B	5000	4500	{}	decreasing	A1-P1	Z	2	16	58
5853	RadFan2SrvAmpSpeed_2_path1_T_H_OP80B	5000	4500	{}	decreasing	A2-P1	Y	2	16	58
5854	RadFan2SrvAmpSpeed_3_path1_T_H_OP80B	5000	4500	{}	decreasing	A3-P1	YS	2	16	58
5855	RadFan2SrvAmpSpeed_4_path1_T_H_OP80B	5000	4500	{}	decreasing	A4-P1	B1	2	16	58
5856	RadFan2SrvAmpSpeed_5_path1_T_H_OP80B	5000	4500	{}	decreasing	A5-P1	BMG	2	16	58
5857	RadFan2SrvAmpSpeed_6_path1_T_H_OP80B	5000	4500	{}	decreasing	A6-P1	A2	2	16	58
5858	RadFan2SrvAmpSpeed_7_path1_T_H_OP80B	5000	4500	{}	decreasing	A7-P1	AT	2	16	58
5859	ApcBatLow_0_path1_T_H_OP80B	NaN	NaN	{}	bool	A0-P1	X	6	1	58
5860	ApcBatLow_1_path1_T_H_OP80B	NaN	NaN	{}	bool	A1-P1	Z	6	1	58
5861	ApcBatLow_2_path1_T_H_OP80B	NaN	NaN	{}	bool	A2-P1	Y	6	1	58
5862	ApcBatLow_3_path1_T_H_OP80B	NaN	NaN	{}	bool	A3-P1	YS	6	1	58
5863	ApcBatLow_4_path1_T_H_OP80B	NaN	NaN	{}	bool	A4-P1	B1	6	1	58
5864	ApcBatLow_5_path1_T_H_OP80B	NaN	NaN	{}	bool	A5-P1	BMG	6	1	58
5865	ApcBatLow_6_path1_T_H_OP80B	NaN	NaN	{}	bool	A6-P1	A2	6	1	58
5866	ApcBatLow_7_path1_T_H_OP80B	NaN	NaN	{}	bool	A7-P1	AT	6	1	58
5867	CncBatLow_0_path1_T_H_OP80B	NaN	NaN	{}	bool	A0-P1	X	6	2	58
5868	CncBatLow_1_path1_T_H_OP80B	NaN	NaN	{}	bool	A1-P1	Z	6	2	58
5869	CncBatLow_2_path1_T_H_OP80B	NaN	NaN	{}	bool	A2-P1	Y	6	2	58
5870	CncBatLow_3_path1_T_H_OP80B	NaN	NaN	{}	bool	A3-P1	YS	6	2	58
5871	CncBatLow_4_path1_T_H_OP80B	NaN	NaN	{}	bool	A4-P1	B1	6	2	58
5872	CncBatLow_5_path1_T_H_OP80B	NaN	NaN	{}	bool	A5-P1	BMG	6	2	58
5873	CncBatLow_6_path1_T_H_OP80B	NaN	NaN	{}	bool	A6-P1	A2	6	2	58
5874	CncBatLow_7_path1_T_H_OP80B	NaN	NaN	{}	bool	A7-P1	AT	6	2	58
5875	ServoLeakResistData_0_path1_T_H_OP80B	50	30	{}	decreasing	A0-P1	X	15	5	58
5876	ServoLeakResistData_1_path1_T_H_OP80B	50	30	{}	decreasing	A1-P1	Z	15	5	58
5877	ServoLeakResistData_2_path1_T_H_OP80B	50	30	{}	decreasing	A2-P1	Y	15	5	58
5878	ServoLeakResistData_3_path1_T_H_OP80B	50	30	{}	decreasing	A3-P1	YS	15	5	58
5879	ServoLeakResistData_4_path1_T_H_OP80B	50	30	{}	decreasing	A4-P1	B1	15	5	58
5880	ServoLeakResistData_5_path1_T_H_OP80B	50	30	{}	decreasing	A5-P1	BMG	15	5	58
5881	ServoLeakResistData_6_path1_T_H_OP80B	50	30	{}	decreasing	A6-P1	A2	15	5	58
5882	ServoLeakResistData_7_path1_T_H_OP80B	50	30	{}	decreasing	A7-P1	AT	15	5	58
5883	SpindleLeakResistData_0_path1_T_H_OP80B	50	30	{}	decreasing	SP-P1	SP	15	5	58
5884	InFan1SrvComPwSpeed_0_path1_T_H_OP80B	6200	6000	{}	decreasing	A0-P1	X	2	9	58
5885	InFan1SrvComPwSpeed_1_path1_T_H_OP80B	6200	6000	{}	decreasing	A1-P1	Z	2	9	58
5886	InFan1SrvComPwSpeed_2_path1_T_H_OP80B	6200	6000	{}	decreasing	A2-P1	Y	2	9	58
5887	InFan1SrvComPwSpeed_3_path1_T_H_OP80B	6200	6000	{}	decreasing	A3-P1	YS	2	9	58
5888	InFan1SrvComPwSpeed_4_path1_T_H_OP80B	6200	6000	{}	decreasing	A4-P1	B1	2	9	58
5889	InFan1SrvComPwSpeed_5_path1_T_H_OP80B	6200	6000	{}	decreasing	A5-P1	BMG	2	9	58
5890	InFan1SrvComPwSpeed_6_path1_T_H_OP80B	6200	6000	{}	decreasing	A6-P1	A2	2	9	58
5891	InFan1SrvComPwSpeed_7_path1_T_H_OP80B	6200	6000	{}	decreasing	A7-P1	AT	2	9	58
5892	InFan2SrvAmpSpeed_0_path1_T_H_OP80B	5000	4500	{}	decreasing	A0-P1	X	2	11	58
5893	InFan2SrvAmpSpeed_1_path1_T_H_OP80B	5000	4500	{}	decreasing	A1-P1	Z	2	11	58
5894	InFan2SrvAmpSpeed_2_path1_T_H_OP80B	5000	4500	{}	decreasing	A2-P1	Y	2	11	58
5895	InFan2SrvAmpSpeed_3_path1_T_H_OP80B	5000	4500	{}	decreasing	A3-P1	YS	2	11	58
5896	InFan2SrvAmpSpeed_4_path1_T_H_OP80B	5000	4500	{}	decreasing	A4-P1	B1	2	11	58
5897	InFan2SrvAmpSpeed_5_path1_T_H_OP80B	5000	4500	{}	decreasing	A5-P1	BMG	2	11	58
5898	InFan2SrvAmpSpeed_6_path1_T_H_OP80B	5000	4500	{}	decreasing	A6-P1	A2	2	11	58
5899	InFan2SrvAmpSpeed_7_path1_T_H_OP80B	5000	4500	{}	decreasing	A7-P1	AT	2	11	58
5900	RadFan1SpindleAmpSpeed_0_path1_T_H_OP80B	5000	4500	{}	decreasing	SP-P1	SP	2	15	58
5901	RadFan1SrvAmpSpeed_0_path1_T_H_OP80B	5000	4500	{}	decreasing	A0-P1	X	2	15	58
5902	RadFan1SrvAmpSpeed_1_path1_T_H_OP80B	5000	4500	{}	decreasing	A1-P1	Z	2	15	58
5903	RadFan1SrvAmpSpeed_2_path1_T_H_OP80B	5000	4500	{}	decreasing	A2-P1	Y	2	15	58
5904	RadFan1SrvAmpSpeed_3_path1_T_H_OP80B	5000	4500	{}	decreasing	A3-P1	YS	2	15	58
5905	RadFan1SrvAmpSpeed_4_path1_T_H_OP80B	5000	4500	{}	decreasing	A4-P1	B1	2	15	58
5906	RadFan1SrvAmpSpeed_5_path1_T_H_OP80B	5000	4500	{}	decreasing	A5-P1	BMG	2	15	58
5907	RadFan1SrvAmpSpeed_6_path1_T_H_OP80B	5000	4500	{}	decreasing	A6-P1	A2	2	15	58
5908	RadFan1SrvAmpSpeed_7_path1_T_H_OP80B	5000	4500	{}	decreasing	A7-P1	AT	2	15	58
5909	InFan2SpdlComPwSpeed_0_path1_T_H_OP80B	5000	4500	{}	decreasing	A0-P1	SAS	2	10	58
5910	InFan2SpindleAmpSpeed_0_path1_T_H_OP80B	5000	4500	{}	decreasing	A0-P1	SCS	2	10	58
5911	InFan2SrvComPwSpeed_0_path1_T_H_OP80B	5000	4500	{}	decreasing	A0-P1	X	2	12	58
5912	InFan2SrvComPwSpeed_1_path1_T_H_OP80B	5000	4500	{}	decreasing	A1-P1	Z	2	12	58
5913	InFan2SrvComPwSpeed_2_path1_T_H_OP80B	5000	4500	{}	decreasing	A2-P1	Y	2	12	58
5914	InFan2SrvComPwSpeed_3_path1_T_H_OP80B	5000	4500	{}	decreasing	A3-P1	YS	2	12	58
5915	InFan2SrvComPwSpeed_4_path1_T_H_OP80B	5000	4500	{}	decreasing	A4-P1	B1	2	12	58
5916	InFan2SrvComPwSpeed_5_path1_T_H_OP80B	5000	4500	{}	decreasing	A5-P1	BMG	2	12	58
5917	InFan2SrvComPwSpeed_6_path1_T_H_OP80B	5000	4500	{}	decreasing	A6-P1	A2	2	12	58
5918	InFan2SrvComPwSpeed_7_path1_T_H_OP80B	5000	4500	{}	decreasing	A7-P1	AT	2	12	58
5919	InFan1SpdlComPwSpeed_0_path1_T_H_OP80B	5000	4500	{}	decreasing	A0-P1	SAS	2	7	58
5920	InFan1SpindleAmpSpeed_0_path1_T_H_OP80B	6200	6000	{}	decreasing	A0-P1	SCS	2	7	58
5921	ServoTemp_0_path1_T_H_OP80B	55	70	{}	increasing	A0-P1	X	13	3	58
5922	ServoTemp_1_path1_T_H_OP80B	55	70	{}	increasing	A1-P1	Z	13	3	58
5923	ServoTemp_2_path1_T_H_OP80B	55	70	{}	increasing	A2-P1	Y	13	3	58
5924	ServoTemp_3_path1_T_H_OP80B	55	70	{}	increasing	A3-P1	YS	13	3	58
5925	ServoTemp_4_path1_T_H_OP80B	55	70	{}	increasing	A4-P1	B1	13	3	58
5926	ServoTemp_5_path1_T_H_OP80B	55	70	{}	increasing	A5-P1	BMG	13	3	58
5927	ServoTemp_6_path1_T_H_OP80B	55	70	{}	increasing	A6-P1	A2	13	3	58
5928	ServoTemp_7_path1_T_H_OP80B	55	70	{}	increasing	A7-P1	AT	13	3	58
5929	SpindleTemp_0_path1_T_H_OP80B	80	100	{}	increasing	SP-P1	SP	13	3	58
5930	PulseCoderTemp_0_path1_T_H_OP90A	60	80	{}	increasing	A0-P1	X	13	4	59
5931	PulseCoderTemp_1_path1_T_H_OP90A	60	80	{}	increasing	A1-P1	Z	13	4	59
5932	PulseCoderTemp_2_path1_T_H_OP90A	60	80	{}	increasing	A2-P1	Y	13	4	59
5933	PulseCoderTemp_3_path1_T_H_OP90A	60	80	{}	increasing	A3-P1	YS	13	4	59
5935	PulseCoderTemp_5_path1_T_H_OP90A	60	80	{}	increasing	A5-P1	BMG	13	4	59
5936	PulseCoderTemp_6_path1_T_H_OP90A	60	80	{}	increasing	A6-P1	A2	13	4	59
5937	PulseCoderTemp_7_path1_T_H_OP90A	60	80	{}	increasing	A7-P1	AT	13	4	59
5938	CncFan1Speed_path1_T_H_OP90A	4500	4000	{}	decreasing	A1-P1	F1	16	6	59
5939	CncFan2Speed_path1_T_H_OP90A	9600	8600	{}	decreasing	A2-P1	F3	16	6	59
5942	InFan1SrvAmpSpeed_0_path1_T_H_OP90A	9500	9000	{}	decreasing	A0-P1	X	2	8	59
5943	InFan1SrvAmpSpeed_1_path1_T_H_OP90A	9500	9000	{}	decreasing	A1-P1	Z	2	8	59
5944	InFan1SrvAmpSpeed_2_path1_T_H_OP90A	9500	9000	{}	decreasing	A2-P1	Y	2	8	59
5945	InFan1SrvAmpSpeed_3_path1_T_H_OP90A	9500	9000	{}	decreasing	A3-P1	YS	2	8	59
5947	InFan1SrvAmpSpeed_5_path1_T_H_OP90A	8500	7500	{}	decreasing	A5-P1	BMG	2	8	59
5948	InFan1SrvAmpSpeed_6_path1_T_H_OP90A	9500	9000	{}	decreasing	A6-P1	A2	2	8	59
5949	InFan1SrvAmpSpeed_7_path1_T_H_OP90A	8500	7500	{}	decreasing	A7-P1	AT	2	8	59
5950	ServoLoad_0_path1_T_H_OP90A	NaN	NaN	{}	increasing	A0-P1	X	17	17	59
6281	feeder_t2_data_table	\N	\N	{}	\N	\N	\N	9	\N	64
5951	ServoLoad_1_path1_T_H_OP90A	NaN	NaN	{}	increasing	A1-P1	Z	17	17	59
5952	ServoLoad_2_path1_T_H_OP90A	NaN	NaN	{}	increasing	A2-P1	Y	17	17	59
5953	ServoLoad_3_path1_T_H_OP90A	NaN	NaN	{}	increasing	A3-P1	YS	17	17	59
5955	ServoLoad_5_path1_T_H_OP90A	NaN	NaN	{}	increasing	A5-P1	BMG	17	17	59
5956	ServoLoad_6_path1_T_H_OP90A	NaN	NaN	{}	increasing	A6-P1	A2	17	17	59
5957	ServoLoad_7_path1_T_H_OP90A	NaN	NaN	{}	increasing	A7-P1	AT	17	17	59
5958	SpindleLoad_0_path1_T_H_OP90A	NaN	NaN	{}	increasing	SP-P1	SP	17	17	59
5959	SpdBatZero_0_path1_T_H_OP90A	NaN	NaN	{}	bool	A0-P1	X	6	13	59
5960	SpdBatZero_1_path1_T_H_OP90A	NaN	NaN	{}	bool	A1-P1	Z	6	13	59
5961	SpdBatZero_2_path1_T_H_OP90A	NaN	NaN	{}	bool	A2-P1	Y	6	13	59
5962	SpdBatZero_3_path1_T_H_OP90A	NaN	NaN	{}	bool	A3-P1	YS	6	13	59
5964	SpdBatZero_5_path1_T_H_OP90A	NaN	NaN	{}	bool	A5-P1	BMG	6	13	59
5965	SpdBatZero_6_path1_T_H_OP90A	NaN	NaN	{}	bool	A6-P1	A2	6	13	59
5966	SpdBatZero_7_path1_T_H_OP90A	NaN	NaN	{}	bool	A7-P1	AT	6	13	59
5967	SSpdBatZero_0_path1_T_H_OP90A	NaN	NaN	{}	bool	A0-P1	X	6	14	59
5968	SSpdBatZero_1_path1_T_H_OP90A	NaN	NaN	{}	bool	A1-P1	Z	6	14	59
5969	SSpdBatZero_2_path1_T_H_OP90A	NaN	NaN	{}	bool	A2-P1	Y	6	14	59
5970	SSpdBatZero_3_path1_T_H_OP90A	NaN	NaN	{}	bool	A3-P1	YS	6	14	59
5972	SSpdBatZero_5_path1_T_H_OP90A	NaN	NaN	{}	bool	A5-P1	BMG	6	14	59
5973	SSpdBatZero_6_path1_T_H_OP90A	NaN	NaN	{}	bool	A6-P1	A2	6	14	59
5974	SSpdBatZero_7_path1_T_H_OP90A	NaN	NaN	{}	bool	A7-P1	AT	6	14	59
5975	RadFan2SpindleAmpSpeed_0_path1_T_H_OP90A	5000	4500	{}	decreasing	SP-P1	SP	2	16	59
5976	RadFan2SrvAmpSpeed_0_path1_T_H_OP90A	5000	4500	{}	decreasing	A0-P1	X	2	16	59
5977	RadFan2SrvAmpSpeed_1_path1_T_H_OP90A	5000	4500	{}	decreasing	A1-P1	Z	2	16	59
5978	RadFan2SrvAmpSpeed_2_path1_T_H_OP90A	5000	4500	{}	decreasing	A2-P1	Y	2	16	59
5979	RadFan2SrvAmpSpeed_3_path1_T_H_OP90A	5000	4500	{}	decreasing	A3-P1	YS	2	16	59
5981	RadFan2SrvAmpSpeed_5_path1_T_H_OP90A	5000	4500	{}	decreasing	A5-P1	BMG	2	16	59
5982	RadFan2SrvAmpSpeed_6_path1_T_H_OP90A	5000	4500	{}	decreasing	A6-P1	A2	2	16	59
5983	RadFan2SrvAmpSpeed_7_path1_T_H_OP90A	5000	4500	{}	decreasing	A7-P1	AT	2	16	59
5984	ApcBatLow_0_path1_T_H_OP90A	NaN	NaN	{}	bool	A0-P1	X	6	1	59
5985	ApcBatLow_1_path1_T_H_OP90A	NaN	NaN	{}	bool	A1-P1	Z	6	1	59
5986	ApcBatLow_2_path1_T_H_OP90A	NaN	NaN	{}	bool	A2-P1	Y	6	1	59
5987	ApcBatLow_3_path1_T_H_OP90A	NaN	NaN	{}	bool	A3-P1	YS	6	1	59
5989	ApcBatLow_5_path1_T_H_OP90A	NaN	NaN	{}	bool	A5-P1	BMG	6	1	59
5990	ApcBatLow_6_path1_T_H_OP90A	NaN	NaN	{}	bool	A6-P1	A2	6	1	59
5991	ApcBatLow_7_path1_T_H_OP90A	NaN	NaN	{}	bool	A7-P1	AT	6	1	59
5992	CncBatLow_0_path1_T_H_OP90A	NaN	NaN	{}	bool	A0-P1	X	6	2	59
5993	CncBatLow_1_path1_T_H_OP90A	NaN	NaN	{}	bool	A1-P1	Z	6	2	59
5994	CncBatLow_2_path1_T_H_OP90A	NaN	NaN	{}	bool	A2-P1	Y	6	2	59
5995	CncBatLow_3_path1_T_H_OP90A	NaN	NaN	{}	bool	A3-P1	YS	6	2	59
5997	CncBatLow_5_path1_T_H_OP90A	NaN	NaN	{}	bool	A5-P1	BMG	6	2	59
5998	CncBatLow_6_path1_T_H_OP90A	NaN	NaN	{}	bool	A6-P1	A2	6	2	59
5999	CncBatLow_7_path1_T_H_OP90A	NaN	NaN	{}	bool	A7-P1	AT	6	2	59
6000	ServoLeakResistData_0_path1_T_H_OP90A	50	30	{}	decreasing	A0-P1	X	15	5	59
6001	ServoLeakResistData_1_path1_T_H_OP90A	50	30	{}	decreasing	A1-P1	Z	15	5	59
6002	ServoLeakResistData_2_path1_T_H_OP90A	50	30	{}	decreasing	A2-P1	Y	15	5	59
6003	ServoLeakResistData_3_path1_T_H_OP90A	50	30	{}	decreasing	A3-P1	YS	15	5	59
6005	ServoLeakResistData_5_path1_T_H_OP90A	50	30	{}	decreasing	A5-P1	BMG	15	5	59
6006	ServoLeakResistData_6_path1_T_H_OP90A	50	30	{}	decreasing	A6-P1	A2	15	5	59
6007	ServoLeakResistData_7_path1_T_H_OP90A	50	30	{}	decreasing	A7-P1	AT	15	5	59
6008	SpindleLeakResistData_0_path1_T_H_OP90A	50	30	{}	decreasing	SP-P1	SP	15	5	59
6009	InFan1SrvComPwSpeed_0_path1_T_H_OP90A	6200	6000	{}	decreasing	A0-P1	X	2	9	59
6010	InFan1SrvComPwSpeed_1_path1_T_H_OP90A	6200	6000	{}	decreasing	A1-P1	Z	2	9	59
6011	InFan1SrvComPwSpeed_2_path1_T_H_OP90A	6200	6000	{}	decreasing	A2-P1	Y	2	9	59
6012	InFan1SrvComPwSpeed_3_path1_T_H_OP90A	6200	6000	{}	decreasing	A3-P1	YS	2	9	59
6014	InFan1SrvComPwSpeed_5_path1_T_H_OP90A	6200	6000	{}	decreasing	A5-P1	BMG	2	9	59
6015	InFan1SrvComPwSpeed_6_path1_T_H_OP90A	6200	6000	{}	decreasing	A6-P1	A2	2	9	59
6016	InFan1SrvComPwSpeed_7_path1_T_H_OP90A	6200	6000	{}	decreasing	A7-P1	AT	2	9	59
6017	InFan2SrvAmpSpeed_0_path1_T_H_OP90A	5000	4500	{}	decreasing	A0-P1	X	2	11	59
6018	InFan2SrvAmpSpeed_1_path1_T_H_OP90A	5000	4500	{}	decreasing	A1-P1	Z	2	11	59
6019	InFan2SrvAmpSpeed_2_path1_T_H_OP90A	5000	4500	{}	decreasing	A2-P1	Y	2	11	59
6020	InFan2SrvAmpSpeed_3_path1_T_H_OP90A	5000	4500	{}	decreasing	A3-P1	YS	2	11	59
6022	InFan2SrvAmpSpeed_5_path1_T_H_OP90A	5000	4500	{}	decreasing	A5-P1	BMG	2	11	59
6023	InFan2SrvAmpSpeed_6_path1_T_H_OP90A	5000	4500	{}	decreasing	A6-P1	A2	2	11	59
6024	InFan2SrvAmpSpeed_7_path1_T_H_OP90A	5000	4500	{}	decreasing	A7-P1	AT	2	11	59
6025	RadFan1SpindleAmpSpeed_0_path1_T_H_OP90A	5000	4500	{}	decreasing	SP-P1	SP	2	15	59
6026	RadFan1SrvAmpSpeed_0_path1_T_H_OP90A	5000	4500	{}	decreasing	A0-P1	X	2	15	59
6027	RadFan1SrvAmpSpeed_1_path1_T_H_OP90A	5000	4500	{}	decreasing	A1-P1	Z	2	15	59
6028	RadFan1SrvAmpSpeed_2_path1_T_H_OP90A	5000	4500	{}	decreasing	A2-P1	Y	2	15	59
6029	RadFan1SrvAmpSpeed_3_path1_T_H_OP90A	5000	4500	{}	decreasing	A3-P1	YS	2	15	59
6031	RadFan1SrvAmpSpeed_5_path1_T_H_OP90A	5000	4500	{}	decreasing	A5-P1	BMG	2	15	59
6032	RadFan1SrvAmpSpeed_6_path1_T_H_OP90A	5000	4500	{}	decreasing	A6-P1	A2	2	15	59
6033	RadFan1SrvAmpSpeed_7_path1_T_H_OP90A	5000	4500	{}	decreasing	A7-P1	AT	2	15	59
6034	InFan2SpdlComPwSpeed_0_path1_T_H_OP90A	5000	4500	{}	decreasing	A0-P1	SAS	2	10	59
6035	InFan2SpindleAmpSpeed_0_path1_T_H_OP90A	5000	4500	{}	decreasing	A0-P1	SCS	2	10	59
6036	InFan2SrvComPwSpeed_0_path1_T_H_OP90A	5000	4500	{}	decreasing	A0-P1	X	2	12	59
6037	InFan2SrvComPwSpeed_1_path1_T_H_OP90A	5000	4500	{}	decreasing	A1-P1	Z	2	12	59
6038	InFan2SrvComPwSpeed_2_path1_T_H_OP90A	5000	4500	{}	decreasing	A2-P1	Y	2	12	59
6039	InFan2SrvComPwSpeed_3_path1_T_H_OP90A	5000	4500	{}	decreasing	A3-P1	YS	2	12	59
6041	InFan2SrvComPwSpeed_5_path1_T_H_OP90A	5000	4500	{}	decreasing	A5-P1	BMG	2	12	59
6042	InFan2SrvComPwSpeed_6_path1_T_H_OP90A	5000	4500	{}	decreasing	A6-P1	A2	2	12	59
6043	InFan2SrvComPwSpeed_7_path1_T_H_OP90A	5000	4500	{}	decreasing	A7-P1	AT	2	12	59
6044	InFan1SpdlComPwSpeed_0_path1_T_H_OP90A	5000	4500	{}	decreasing	A0-P1	SAS	2	7	59
6045	InFan1SpindleAmpSpeed_0_path1_T_H_OP90A	6200	6000	{}	decreasing	A0-P1	SCS	2	7	59
6046	ServoTemp_0_path1_T_H_OP90A	55	70	{}	increasing	A0-P1	X	13	3	59
6047	ServoTemp_1_path1_T_H_OP90A	55	70	{}	increasing	A1-P1	Z	13	3	59
6048	ServoTemp_2_path1_T_H_OP90A	55	70	{}	increasing	A2-P1	Y	13	3	59
6049	ServoTemp_3_path1_T_H_OP90A	55	70	{}	increasing	A3-P1	YS	13	3	59
6051	ServoTemp_5_path1_T_H_OP90A	55	70	{}	increasing	A5-P1	BMG	13	3	59
6052	ServoTemp_6_path1_T_H_OP90A	55	70	{}	increasing	A6-P1	A2	13	3	59
6053	ServoTemp_7_path1_T_H_OP90A	55	70	{}	increasing	A7-P1	AT	13	3	59
6054	SpindleTemp_0_path1_T_H_OP90A	80	100	{}	increasing	SP-P1	SP	13	3	59
6055	PulseCoderTemp_0_path1_T_H_OP90B	60	80	{}	increasing	A0-P1	X	13	4	60
6056	PulseCoderTemp_1_path1_T_H_OP90B	60	80	{}	increasing	A1-P1	Z	13	4	60
6057	PulseCoderTemp_2_path1_T_H_OP90B	60	80	{}	increasing	A2-P1	Y	13	4	60
6058	PulseCoderTemp_3_path1_T_H_OP90B	60	80	{}	increasing	A3-P1	YS	13	4	60
6060	PulseCoderTemp_5_path1_T_H_OP90B	60	80	{}	increasing	A5-P1	BMG	13	4	60
6061	PulseCoderTemp_6_path1_T_H_OP90B	60	80	{}	increasing	A6-P1	A2	13	4	60
6062	PulseCoderTemp_7_path1_T_H_OP90B	60	80	{}	increasing	A7-P1	AT	13	4	60
6063	CncFan1Speed_path1_T_H_OP90B	4500	4000	{}	decreasing	A1-P1	F1	16	6	60
6064	CncFan2Speed_path1_T_H_OP90B	9600	8600	{}	decreasing	A2-P1	F3	16	6	60
6067	InFan1SrvAmpSpeed_0_path1_T_H_OP90B	9500	9000	{}	decreasing	A0-P1	X	2	8	60
6068	InFan1SrvAmpSpeed_1_path1_T_H_OP90B	9500	9000	{}	decreasing	A1-P1	Z	2	8	60
6069	InFan1SrvAmpSpeed_2_path1_T_H_OP90B	9500	9000	{}	decreasing	A2-P1	Y	2	8	60
6070	InFan1SrvAmpSpeed_3_path1_T_H_OP90B	9500	9000	{}	decreasing	A3-P1	YS	2	8	60
6072	InFan1SrvAmpSpeed_5_path1_T_H_OP90B	8500	7500	{}	decreasing	A5-P1	BMG	2	8	60
6073	InFan1SrvAmpSpeed_6_path1_T_H_OP90B	9500	9000	{}	decreasing	A6-P1	A2	2	8	60
6074	InFan1SrvAmpSpeed_7_path1_T_H_OP90B	8500	7500	{}	decreasing	A7-P1	AT	2	8	60
6075	ServoLoad_0_path1_T_H_OP90B	NaN	NaN	{}	increasing	A0-P1	X	17	17	60
6076	ServoLoad_1_path1_T_H_OP90B	NaN	NaN	{}	increasing	A1-P1	Z	17	17	60
6077	ServoLoad_2_path1_T_H_OP90B	NaN	NaN	{}	increasing	A2-P1	Y	17	17	60
6078	ServoLoad_3_path1_T_H_OP90B	NaN	NaN	{}	increasing	A3-P1	YS	17	17	60
6080	ServoLoad_5_path1_T_H_OP90B	NaN	NaN	{}	increasing	A5-P1	BMG	17	17	60
6081	ServoLoad_6_path1_T_H_OP90B	NaN	NaN	{}	increasing	A6-P1	A2	17	17	60
6082	ServoLoad_7_path1_T_H_OP90B	NaN	NaN	{}	increasing	A7-P1	AT	17	17	60
6083	SpindleLoad_0_path1_T_H_OP90B	NaN	NaN	{}	increasing	SP-P1	SP	17	17	60
6084	SpdBatZero_0_path1_T_H_OP90B	NaN	NaN	{}	bool	A0-P1	X	6	13	60
6085	SpdBatZero_1_path1_T_H_OP90B	NaN	NaN	{}	bool	A1-P1	Z	6	13	60
6086	SpdBatZero_2_path1_T_H_OP90B	NaN	NaN	{}	bool	A2-P1	Y	6	13	60
6087	SpdBatZero_3_path1_T_H_OP90B	NaN	NaN	{}	bool	A3-P1	YS	6	13	60
6089	SpdBatZero_5_path1_T_H_OP90B	NaN	NaN	{}	bool	A5-P1	BMG	6	13	60
6090	SpdBatZero_6_path1_T_H_OP90B	NaN	NaN	{}	bool	A6-P1	A2	6	13	60
6091	SpdBatZero_7_path1_T_H_OP90B	NaN	NaN	{}	bool	A7-P1	AT	6	13	60
6092	SSpdBatZero_0_path1_T_H_OP90B	NaN	NaN	{}	bool	A0-P1	X	6	14	60
6093	SSpdBatZero_1_path1_T_H_OP90B	NaN	NaN	{}	bool	A1-P1	Z	6	14	60
6094	SSpdBatZero_2_path1_T_H_OP90B	NaN	NaN	{}	bool	A2-P1	Y	6	14	60
6095	SSpdBatZero_3_path1_T_H_OP90B	NaN	NaN	{}	bool	A3-P1	YS	6	14	60
6097	SSpdBatZero_5_path1_T_H_OP90B	NaN	NaN	{}	bool	A5-P1	BMG	6	14	60
6098	SSpdBatZero_6_path1_T_H_OP90B	NaN	NaN	{}	bool	A6-P1	A2	6	14	60
6099	SSpdBatZero_7_path1_T_H_OP90B	NaN	NaN	{}	bool	A7-P1	AT	6	14	60
6100	RadFan2SpindleAmpSpeed_0_path1_T_H_OP90B	5000	4500	{}	decreasing	SP-P1	SP	2	16	60
6101	RadFan2SrvAmpSpeed_0_path1_T_H_OP90B	5000	4500	{}	decreasing	A0-P1	X	2	16	60
6102	RadFan2SrvAmpSpeed_1_path1_T_H_OP90B	5000	4500	{}	decreasing	A1-P1	Z	2	16	60
6103	RadFan2SrvAmpSpeed_2_path1_T_H_OP90B	5000	4500	{}	decreasing	A2-P1	Y	2	16	60
6104	RadFan2SrvAmpSpeed_3_path1_T_H_OP90B	5000	4500	{}	decreasing	A3-P1	YS	2	16	60
6106	RadFan2SrvAmpSpeed_5_path1_T_H_OP90B	5000	4500	{}	decreasing	A5-P1	BMG	2	16	60
6107	RadFan2SrvAmpSpeed_6_path1_T_H_OP90B	5000	4500	{}	decreasing	A6-P1	A2	2	16	60
6108	RadFan2SrvAmpSpeed_7_path1_T_H_OP90B	5000	4500	{}	decreasing	A7-P1	AT	2	16	60
6109	ApcBatLow_0_path1_T_H_OP90B	NaN	NaN	{}	bool	A0-P1	X	6	1	60
6110	ApcBatLow_1_path1_T_H_OP90B	NaN	NaN	{}	bool	A1-P1	Z	6	1	60
6111	ApcBatLow_2_path1_T_H_OP90B	NaN	NaN	{}	bool	A2-P1	Y	6	1	60
6112	ApcBatLow_3_path1_T_H_OP90B	NaN	NaN	{}	bool	A3-P1	YS	6	1	60
6114	ApcBatLow_5_path1_T_H_OP90B	NaN	NaN	{}	bool	A5-P1	BMG	6	1	60
6115	ApcBatLow_6_path1_T_H_OP90B	NaN	NaN	{}	bool	A6-P1	A2	6	1	60
6116	ApcBatLow_7_path1_T_H_OP90B	NaN	NaN	{}	bool	A7-P1	AT	6	1	60
6117	CncBatLow_0_path1_T_H_OP90B	NaN	NaN	{}	bool	A0-P1	X	6	2	60
6118	CncBatLow_1_path1_T_H_OP90B	NaN	NaN	{}	bool	A1-P1	Z	6	2	60
6119	CncBatLow_2_path1_T_H_OP90B	NaN	NaN	{}	bool	A2-P1	Y	6	2	60
6120	CncBatLow_3_path1_T_H_OP90B	NaN	NaN	{}	bool	A3-P1	YS	6	2	60
6122	CncBatLow_5_path1_T_H_OP90B	NaN	NaN	{}	bool	A5-P1	BMG	6	2	60
6123	CncBatLow_6_path1_T_H_OP90B	NaN	NaN	{}	bool	A6-P1	A2	6	2	60
6124	CncBatLow_7_path1_T_H_OP90B	NaN	NaN	{}	bool	A7-P1	AT	6	2	60
6125	ServoLeakResistData_0_path1_T_H_OP90B	50	30	{}	decreasing	A0-P1	X	15	5	60
6126	ServoLeakResistData_1_path1_T_H_OP90B	50	30	{}	decreasing	A1-P1	Z	15	5	60
6127	ServoLeakResistData_2_path1_T_H_OP90B	50	30	{}	decreasing	A2-P1	Y	15	5	60
6128	ServoLeakResistData_3_path1_T_H_OP90B	50	30	{}	decreasing	A3-P1	YS	15	5	60
6130	ServoLeakResistData_5_path1_T_H_OP90B	50	30	{}	decreasing	A5-P1	BMG	15	5	60
6131	ServoLeakResistData_6_path1_T_H_OP90B	50	30	{}	decreasing	A6-P1	A2	15	5	60
6132	ServoLeakResistData_7_path1_T_H_OP90B	50	30	{}	decreasing	A7-P1	AT	15	5	60
6133	SpindleLeakResistData_0_path1_T_H_OP90B	50	30	{}	decreasing	SP-P1	SP	15	5	60
6134	InFan1SrvComPwSpeed_0_path1_T_H_OP90B	6200	6000	{}	decreasing	A0-P1	X	2	9	60
6135	InFan1SrvComPwSpeed_1_path1_T_H_OP90B	6200	6000	{}	decreasing	A1-P1	Z	2	9	60
6136	InFan1SrvComPwSpeed_2_path1_T_H_OP90B	6200	6000	{}	decreasing	A2-P1	Y	2	9	60
6137	InFan1SrvComPwSpeed_3_path1_T_H_OP90B	6200	6000	{}	decreasing	A3-P1	YS	2	9	60
6139	InFan1SrvComPwSpeed_5_path1_T_H_OP90B	6200	6000	{}	decreasing	A5-P1	BMG	2	9	60
6140	InFan1SrvComPwSpeed_6_path1_T_H_OP90B	6200	6000	{}	decreasing	A6-P1	A2	2	9	60
6141	InFan1SrvComPwSpeed_7_path1_T_H_OP90B	6200	6000	{}	decreasing	A7-P1	AT	2	9	60
6142	InFan2SrvAmpSpeed_0_path1_T_H_OP90B	5000	4500	{}	decreasing	A0-P1	X	2	11	60
6143	InFan2SrvAmpSpeed_1_path1_T_H_OP90B	5000	4500	{}	decreasing	A1-P1	Z	2	11	60
6144	InFan2SrvAmpSpeed_2_path1_T_H_OP90B	5000	4500	{}	decreasing	A2-P1	Y	2	11	60
6145	InFan2SrvAmpSpeed_3_path1_T_H_OP90B	5000	4500	{}	decreasing	A3-P1	YS	2	11	60
6147	InFan2SrvAmpSpeed_5_path1_T_H_OP90B	5000	4500	{}	decreasing	A5-P1	BMG	2	11	60
6148	InFan2SrvAmpSpeed_6_path1_T_H_OP90B	5000	4500	{}	decreasing	A6-P1	A2	2	11	60
6149	InFan2SrvAmpSpeed_7_path1_T_H_OP90B	5000	4500	{}	decreasing	A7-P1	AT	2	11	60
6150	RadFan1SpindleAmpSpeed_0_path1_T_H_OP90B	5000	4500	{}	decreasing	SP-P1	SP	2	15	60
6151	RadFan1SrvAmpSpeed_0_path1_T_H_OP90B	5000	4500	{}	decreasing	A0-P1	X	2	15	60
6152	RadFan1SrvAmpSpeed_1_path1_T_H_OP90B	5000	4500	{}	decreasing	A1-P1	Z	2	15	60
6153	RadFan1SrvAmpSpeed_2_path1_T_H_OP90B	5000	4500	{}	decreasing	A2-P1	Y	2	15	60
6154	RadFan1SrvAmpSpeed_3_path1_T_H_OP90B	5000	4500	{}	decreasing	A3-P1	YS	2	15	60
6156	RadFan1SrvAmpSpeed_5_path1_T_H_OP90B	5000	4500	{}	decreasing	A5-P1	BMG	2	15	60
6157	RadFan1SrvAmpSpeed_6_path1_T_H_OP90B	5000	4500	{}	decreasing	A6-P1	A2	2	15	60
6158	RadFan1SrvAmpSpeed_7_path1_T_H_OP90B	5000	4500	{}	decreasing	A7-P1	AT	2	15	60
6159	InFan2SpdlComPwSpeed_0_path1_T_H_OP90B	5000	4500	{}	decreasing	A0-P1	SAS	2	10	60
6160	InFan2SpindleAmpSpeed_0_path1_T_H_OP90B	5000	4500	{}	decreasing	A0-P1	SCS	2	10	60
6161	InFan2SrvComPwSpeed_0_path1_T_H_OP90B	5000	4500	{}	decreasing	A0-P1	X	2	12	60
6162	InFan2SrvComPwSpeed_1_path1_T_H_OP90B	5000	4500	{}	decreasing	A1-P1	Z	2	12	60
6282	feeder_t3_data_table	\N	\N	{}	\N	\N	\N	9	\N	64
6163	InFan2SrvComPwSpeed_2_path1_T_H_OP90B	5000	4500	{}	decreasing	A2-P1	Y	2	12	60
6164	InFan2SrvComPwSpeed_3_path1_T_H_OP90B	5000	4500	{}	decreasing	A3-P1	YS	2	12	60
6166	InFan2SrvComPwSpeed_5_path1_T_H_OP90B	5000	4500	{}	decreasing	A5-P1	BMG	2	12	60
6167	InFan2SrvComPwSpeed_6_path1_T_H_OP90B	5000	4500	{}	decreasing	A6-P1	A2	2	12	60
6168	InFan2SrvComPwSpeed_7_path1_T_H_OP90B	5000	4500	{}	decreasing	A7-P1	AT	2	12	60
6169	InFan1SpdlComPwSpeed_0_path1_T_H_OP90B	5000	4500	{}	decreasing	A0-P1	SAS	2	7	60
6170	InFan1SpindleAmpSpeed_0_path1_T_H_OP90B	6200	6000	{}	decreasing	A0-P1	SCS	2	7	60
6171	ServoTemp_0_path1_T_H_OP90B	55	70	{}	increasing	A0-P1	X	13	3	60
6172	ServoTemp_1_path1_T_H_OP90B	55	70	{}	increasing	A1-P1	Z	13	3	60
6173	ServoTemp_2_path1_T_H_OP90B	55	70	{}	increasing	A2-P1	Y	13	3	60
6174	ServoTemp_3_path1_T_H_OP90B	55	70	{}	increasing	A3-P1	YS	13	3	60
6176	ServoTemp_5_path1_T_H_OP90B	55	70	{}	increasing	A5-P1	BMG	13	3	60
6177	ServoTemp_6_path1_T_H_OP90B	55	70	{}	increasing	A6-P1	A2	13	3	60
6178	ServoTemp_7_path1_T_H_OP90B	55	70	{}	increasing	A7-P1	AT	13	3	60
6179	SpindleTemp_0_path1_T_H_OP90B	80	100	{}	increasing	SP-P1	SP	13	3	60
6222	MeasurementData(WHL_SPINDLE_LOAD)_JOURNAL_GRINDING_JOP105	0	0	{}	0	0	0	6	\N	61
6223	MeasurementData(MEASURING_UNIT)_JOURNAL_GRINDING_JOP105	0	0	{}	0	0	0	6	\N	61
6224	EffectivePosition(X:WHEEL_HEAD)_JOURNAL_GRINDING_JOP105	\N	\N	{}	spm_dynamic	\N	\N	6	\N	61
6225	EffectivePosition(Z:WHEL_HD_TRVRS)_JOURNAL_GRINDING_JOP105	\N	\N	{}	spm_dynamic	\N	\N	6	\N	61
6226	EffectivePosition(C:WORK_SPINDLE)_JOURNAL_GRINDING_JOP105	\N	\N	{}	spm_dynamic	\N	\N	6	\N	61
6227	EffectivePosition(WF:FTSTK_SPINDL)_JOURNAL_GRINDING_JOP105	\N	\N	{}	spm_dynamic	\N	\N	6	\N	61
6228	EffectivePosition(WW:WK_SPNDL_POS)_JOURNAL_GRINDING_JOP105	\N	\N	{}	spm_dynamic	\N	\N	6	\N	61
6229	LinkRegister(100F)_JOURNAL_GRINDING_JOP105	\N	\N	{}	spm_static	\N	\N	6	\N	61
6230	LinkIO(46C)_JOURNAL_GRINDING_JOP105	\N	\N	{}	spm_static	\N	\N	6	\N	61
6231	MeasurementData(AE_GRAPH_SCAL_DP)_JOURNAL_GRINDING_JOP105	\N	\N	{}	spm_dynamic	\N	\N	6	\N	61
6232	LinkIO(13C)_JOURNAL_GRINDING_JOP105	\N	\N	{}	spm_static	\N	\N	6	\N	61
6233	LinkIO(114)_JOURNAL_GRINDING_JOP105	\N	\N	{}	spm_static	\N	\N	6	\N	61
6234	MeasurementData(WHL_SPINDLE_LOAD)_JOURNAL_GRINDING_JOP130	\N	\N	{}	spm_dynamic	\N	\N	6	\N	62
6235	MeasurementData(AUTO_SIZER)_JOURNAL_GRINDING_JOP130	\N	\N	{}	spm_dynamic	\N	\N	6	\N	62
6236	EffectivePosition(X:WHEEL_HEAD)_JOURNAL_GRINDING_JOP130	\N	\N	{}	spm_dynamic	\N	\N	6	\N	62
6237	EffectivePosition(Z:WHEL_HD_TRVRS)_JOURNAL_GRINDING_JOP130	\N	\N	{}	spm_dynamic	\N	\N	6	\N	62
6238	EffectivePosition(C:WORK_SPINDLE)_JOURNAL_GRINDING_JOP130	\N	\N	{}	spm_dynamic	\N	\N	6	\N	62
6239	EffectivePosition(WF:FTSTK_SPINDL)_JOURNAL_GRINDING_JOP130	\N	\N	{}	spm_dynamic	\N	\N	6	\N	62
6240	EffectivePosition(WW:WK_SPNDL_POS)_JOURNAL_GRINDING_JOP130	\N	\N	{}	spm_dynamic	\N	\N	6	\N	62
6241	MoveCommand(U:WHL_HD_INFEED)_JOURNAL_GRINDING_JOP130	\N	\N	{}	spm_static	\N	\N	6	\N	62
6242	PositionDeviation(C:WORK_SPINDLE)_JOURNAL_GRINDING_JOP130	\N	\N	{}	spm_static	\N	\N	6	\N	62
6243	LinkRegister(100F)_JOURNAL_GRINDING_JOP130	\N	\N	{}	spm_static	\N	\N	6	\N	62
6244	LinkIO(46C)_JOURNAL_GRINDING_JOP130	\N	\N	{}	spm_static	\N	\N	6	\N	62
6245	LinkIO(155)_JOURNAL_GRINDING_JOP130	\N	\N	{}	spm_static	\N	\N	6	\N	62
6246	LinkIO(11C)_JOURNAL_GRINDING_JOP130	\N	\N	{}	spm_static	\N	\N	6	\N	62
6247	LinkIO(134)_JOURNAL_GRINDING_JOP130	\N	\N	{}	spm_static	\N	\N	6	\N	62
6248	LinkIO(136)_JOURNAL_GRINDING_JOP130	\N	\N	{}	spm_static	\N	\N	6	\N	62
6249	LinkIO(13C)_JOURNAL_GRINDING_JOP130	\N	\N	{}	spm_static	\N	\N	6	\N	62
6250	MeasurementData(AE_GRAPH_SCALE)_JOURNAL_GRINDING_JOP130	\N	\N	{}	spm_dynamic	\N	\N	6	\N	62
6251	LinkIO(114)_JOURNAL_GRINDING_JOP130	\N	\N	{}	spm_static	\N	\N	6	\N	62
6252	MeasurementData(WHL_SPINDLE_LOAD)_JOURNAL_GRINDING_JOP140	0	0	{}	0	0	0	6	\N	63
6253	MeasurementData(AUTO_SIZER)_JOURNAL_GRINDING_JOP140	0	0	{}	0	0	0	6	\N	63
6254	EffectivePosition(X:WHEEL_HEAD)_JOURNAL_GRINDING_JOP140	\N	\N	{}	spm_dynamic	\N	\N	6	\N	63
6255	EffectivePosition(Z:WHEL_HD_TRVRS)_JOURNAL_GRINDING_JOP140	\N	\N	{}	spm_dynamic	\N	\N	6	\N	63
6256	EffectivePosition(C:WORK_SPINDLE)_JOURNAL_GRINDING_JOP140	\N	\N	{}	spm_dynamic	\N	\N	6	\N	63
6257	EffectivePosition(WF:FTSTK_SPINDL)_JOURNAL_GRINDING_JOP140	\N	\N	{}	spm_dynamic	\N	\N	6	\N	63
6258	EffectivePosition(WW:WK_SPNDL_POS)_JOURNAL_GRINDING_JOP140	\N	\N	{}	spm_dynamic	\N	\N	6	\N	63
6259	EffectivePosition(UT:UPPER_REST)_JOURNAL_GRINDING_JOP140	\N	\N	{}	spm_static	\N	\N	6	\N	63
6260	EffectivePosition(YT:LOWER_REST)_JOURNAL_GRINDING_JOP140	\N	\N	{}	spm_static	\N	\N	6	\N	63
6261	LinkRegister(100F)_JOURNAL_GRINDING_JOP140	\N	\N	{}	spm_static	\N	\N	6	\N	63
6262	LinkIO(46C)_JOURNAL_GRINDING_JOP140	\N	\N	{}	spm_static	\N	\N	6	\N	63
6263	MeasurementData(AE_GRAPH_SCAL_DP)_JOURNAL_GRINDING_JOP140	0	0	{}	0	0	0	6	\N	63
6264	LinkIO(13C)_JOURNAL_GRINDING_JOP140	\N	\N	{}	spm_static	\N	\N	6	\N	63
6265	LinkIO(114)_JOURNAL_GRINDING_JOP140	\N	\N	{}	spm_static	\N	\N	6	\N	63
6266	seat_diameter	\N	\N	{}	\N	\N	\N	12	\N	64
6267	fan_speed	\N	\N	{}	\N	\N	\N	1	\N	64
6268	powder_wait_time	\N	\N	{}	\N	\N	\N	3	\N	64
6269	laser_line_t1_data_table	\N	\N	{}	\N	\N	\N	3	\N	64
6270	laser_line_t2_data_table	\N	\N	{}	\N	\N	\N	3	\N	64
6271	laser_line_t3_data_table	\N	\N	{}	\N	\N	\N	3	\N	64
6272	laser_line_t4_data_table	\N	\N	{}	\N	\N	\N	3	\N	64
6288	process_cycle_running_seat_number	\N	\N	{}	spm_static	\N	\N	6	\N	64
6289	c_axis_machine_position	\N	\N	{}	spm_static	\N	\N	5	\N	64
6290	laser_output_monitor_value	\N	\N	{}	spm_dynamic	\N	\N	11	\N	64
6291	feeder_powder_flow	\N	\N	{}	spm_dynamic	\N	\N	4	\N	64
6292	feeder_internal_pressure	\N	\N	{}	spm_dynamic	\N	\N	7	\N	64
6293	carrier_gas_flow	\N	\N	{}	spm_dynamic	\N	\N	8	\N	64
6294	center_gas_flow	\N	\N	{}	spm_dynamic	\N	\N	8	\N	64
6295	ApcBatLow_0_path2_T_H_OP10	\N	\N	{}	bool	A0-P2	WTC	6	1	23
6296	CncBatLow_0_path2_T_H_OP10	NaN	NaN	{}	bool	A0-P2	WTC	6	2	23
6297	ServoTemp_0_path2_T_H_OP10	55	70	{}	increasing	A0-P2	WTC	13	3	23
6298	PulseCoderTemp_0_path2_T_H_OP10	60	80	{}	increasing	A0-P2	WTC	13	4	23
6299	ServoLeakResistData_0_path2_T_H_OP10	50	30	{}	decreasing	A0-P2	WTC	15	5	23
6300	InFan1SrvAmpSpeed_0_path2_T_H_OP10	9500	9000	{}	decreasing	A0-P2	WTC	2	8	23
6301	InFan1SrvComPwSpeed_0_path2_T_H_OP10	6200	6000	{}	\N	A0-P2	WTC	2	9	23
6302	InFan2SrvAmpSpeed_0_path2_T_H_OP10	5000	4500	{}	decreasing	A0-P2	WTC	2	11	23
6303	InFan2SrvComPwSpeed_0_path2_T_H_OP10	5000	4500	{}	decreasing	A0-P2	WTC	2	12	23
6304	SpdBatZero_0_path2_T_H_OP10	NaN	NaN	{}	bool	A0-P2	WTC	6	13	23
6305	SSpdBatZero_0_path2_T_H_OP10	NaN	NaN	{}	bool	A0-P2	WTC	6	14	23
6306	InFan2SrvComPwSpeed_1_path2_T_B_OP230	5000	4500	{}	decreasing	A1-P2	B0	2	12	6
6307	InFan2SrvComPwSpeed_0_path2_T_B_OP230	5000	4500	{}	decreasing	A0-P2	A0	2	12	6
6308	RadFan2SrvAmpSpeed_0_path2_T_B_OP230	5000	4500	{}	decreasing	A0-P2	A0	2	16	6
6309	RadFan2SrvAmpSpeed_1_path2_T_B_OP230	5000	4500	{}	decreasing	A1-P2	B0	2	16	6
6310	InFan1SrvComPwSpeed_1_path2_T_B_OP230	6200	6000	{}	decreasing	A1-P2	B0	2	9	6
6311	InFan1SrvComPwSpeed_0_path2_T_B_OP230	6200	6000	{}	decreasing	A0-P2	A0	2	9	6
6312	ServoLeakResistData_1_path2_T_B_OP230	50	30	{}	decreasing	A1-P2	B0	15	5	6
6313	ServoLeakResistData_0_path2_T_B_OP230	50	30	{}	decreasing	A0-P2	A0	15	5	6
6314	ApcBatLow_0_path2_T_B_OP230	NaN	NaN	{}	bool	A0-P2	A0	6	1	6
6315	ApcBatLow_1_path2_T_B_OP230	NaN	NaN	{}	bool	A1-P2	B0	6	1	6
6316	CncBatLow_0_path2_T_B_OP230	NaN	NaN	{}	bool	A0-P2	A0	6	2	6
6317	CncBatLow_1_path2_T_B_OP230	NaN	NaN	{}	bool	A1-P2	B0	6	2	6
6318	InFan2SrvAmpSpeed_1_path2_T_B_OP230	5000	4500	{}	decreasing	A1-P2	B0	2	11	6
6319	InFan2SrvAmpSpeed_0_path2_T_B_OP230	5000	4500	{}	decreasing	A0-P2	A0	2	11	6
6320	SpdBatZero_0_path2_T_B_OP230	NaN	NaN	{}	bool	A0-P2	A0	6	13	6
6321	SpdBatZero_1_path2_T_B_OP230	NaN	NaN	{}	bool	A1-P2	B0	6	13	6
6322	SSpdBatZero_0_path2_T_B_OP230	NaN	NaN	{}	bool	A0-P2	A0	6	14	6
6323	SSpdBatZero_1_path2_T_B_OP230	NaN	NaN	{}	bool	A1-P2	B0	6	14	6
6324	ServoLoad_0_path2_T_B_OP230	NaN	NaN	{}	increasing	A0-P2	A0	17	17	6
6325	ServoLoad_1_path2_T_B_OP230	NaN	NaN	{}	increasing	A1-P2	B0	17	17	6
6326	RadFan1SrvAmpSpeed_1_path2_T_B_OP230	5000	4500	{}	decreasing	A1-P2	B0	2	15	6
6327	RadFan1SrvAmpSpeed_0_path2_T_B_OP230	5000	4500	{}	decreasing	A0-P2	A0	2	15	6
6328	ServoTemp_1_path2_T_B_OP230	40	50	{}	increasing	A1-P2	B0	13	3	6
6329	ServoTemp_0_path2_T_B_OP230	40	50	{}	increasing	A0-P2	A0	13	3	6
6330	CncFan1Speed_path2_T_B_OP230	4500	4000	{}	decreasing	A0-P2	F2	16	6	6
6331	CncFan2Speed_path2_T_B_OP230	4500	4000	{}	decreasing	A1-P2	F4	16	6	6
6332	PulseCoderTemp_1_path2_T_B_OP230	90	100	{}	increasing	A1-P2	B0	13	4	6
6333	PulseCoderTemp_0_path2_T_B_OP230	65	80	{}	increasing	A0-P2	A0	13	4	6
6334	InFan1SrvAmpSpeed_0_path2_T_B_OP230	9500	9000	{}	decreasing	A0-P2	A0	2	8	6
6335	InFan1SrvAmpSpeed_1_path2_T_B_OP230	9500	9000	{}	decreasing	A1-P2	B0	2	8	6
6336	InFan2SrvComPwSpeed_0_path2_T_B_OP235	5000	4500	{}	decreasing	A0-P2	A0	2	12	7
6337	InFan2SrvComPwSpeed_1_path2_T_B_OP235	5000	4500	{}	decreasing	A1-P2	B0	2	12	7
6338	RadFan2SrvAmpSpeed_0_path2_T_B_OP235	5000	4500	{}	decreasing	A0-P2	A0	2	16	7
6339	RadFan2SrvAmpSpeed_1_path2_T_B_OP235	5000	4500	{}	decreasing	A1-P2	B0	2	16	7
6340	InFan1SrvComPwSpeed_0_path2_T_B_OP235	6200	6000	{}	decreasing	A0-P2	A0	2	9	7
6341	InFan1SrvComPwSpeed_1_path2_T_B_OP235	6200	6000	{}	decreasing	A1-P2	B0	2	9	7
6342	ServoLeakResistData_1_path2_T_B_OP235	50	30	{}	decreasing	A1-P2	B0	15	5	7
6343	ServoLeakResistData_0_path2_T_B_OP235	50	30	{}	decreasing	A0-P2	A0	15	5	7
6344	ApcBatLow_0_path2_T_B_OP235	NaN	NaN	{}	bool	A0-P2	A0	6	1	7
6345	ApcBatLow_1_path2_T_B_OP235	NaN	NaN	{}	bool	A1-P2	B0	6	1	7
6346	CncBatLow_0_path2_T_B_OP235	NaN	NaN	{}	bool	A0-P2	A0	6	2	7
6347	CncBatLow_1_path2_T_B_OP235	NaN	NaN	{}	bool	A1-P2	B0	6	2	7
6348	InFan2SrvAmpSpeed_1_path2_T_B_OP235	5000	4500	{}	decreasing	A1-P2	B0	2	11	7
6349	InFan2SrvAmpSpeed_0_path2_T_B_OP235	5000	4500	{}	decreasing	A0-P2	A0	2	11	7
6350	SpdBatZero_1_path2_T_B_OP235	NaN	NaN	{}	bool	A1-P2	B0	6	13	7
6351	SpdBatZero_0_path2_T_B_OP235	NaN	NaN	{}	bool	A0-P2	A0	6	13	7
6352	SSpdBatZero_1_path2_T_B_OP235	NaN	NaN	{}	bool	A1-P2	B0	6	14	7
6353	SSpdBatZero_0_path2_T_B_OP235	NaN	NaN	{}	bool	A0-P2	A0	6	14	7
6354	ServoLoad_1_path2_T_B_OP235	NaN	NaN	{}	increasing	A1-P2	B0	17	17	7
6355	ServoLoad_0_path2_T_B_OP235	NaN	NaN	{}	increasing	A0-P2	A0	17	17	7
6356	RadFan1SrvAmpSpeed_1_path2_T_B_OP235	5000	4500	{}	decreasing	A1-P2	B0	2	15	7
6357	RadFan1SrvAmpSpeed_0_path2_T_B_OP235	5000	4500	{}	decreasing	A0-P2	A0	2	15	7
6358	ServoTemp_1_path2_T_B_OP235	40	50	{}	increasing	A1-P2	B0	13	3	7
6359	ServoTemp_0_path2_T_B_OP235	40	50	{}	increasing	A0-P2	A0	13	3	7
6360	CncFan2Speed_path2_T_B_OP235	4500	4000	{}	decreasing	A2-P2	F4	16	6	7
6361	CncFan1Speed_path2_T_B_OP235	4500	4000	{}	decreasing	A1-P2	F2	16	6	7
6362	PulseCoderTemp_0_path2_T_B_OP235	55	65	{}	increasing	A0-P2	A0	13	4	7
6363	PulseCoderTemp_1_path2_T_B_OP235	100	110	{}	increasing	A1-P2	B0	13	4	7
6364	InFan1SrvAmpSpeed_1_path2_T_B_OP235	9500	9000	{}	decreasing	A1-P2	B0	2	8	7
6365	InFan1SrvAmpSpeed_0_path2_T_B_OP235	9500	9000	{}	decreasing	A0-P2	A0	2	8	7
6366	InFan2SrvComPwSpeed_1_path2_T_B_OP540	5000	4500	{}	decreasing	A1-P2	Z2	2	12	8
6367	InFan2SrvComPwSpeed_0_path2_T_B_OP540	5000	4500	{}	decreasing	A0-P2	Y2	2	12	8
6368	InFan2SrvComPwSpeed_3_path2_T_B_OP540	5000	4500	{}	decreasing	A3-P2	B2	2	12	8
6369	InFan2SrvComPwSpeed_4_path2_T_B_OP540	5000	4500	{}	decreasing	A4-P2	B3	2	12	8
6370	InFan2SrvComPwSpeed_5_path1_T_B_OP540	5000	4500	{}	decreasing	A5-P1	A3	2	12	8
6371	InFan2SrvComPwSpeed_2_path2_T_B_OP540	5000	4500	{}	decreasing	A2-P2	B1	2	12	8
6372	RadFan2SrvAmpSpeed_1_path2_T_B_OP540	5000	4500	{}	decreasing	A1-P2	Z2	2	16	8
6373	RadFan2SrvAmpSpeed_4_path2_T_B_OP540	5000	4500	{}	decreasing	A4-P2	B3	2	16	8
6374	RadFan2SrvAmpSpeed_5_path1_T_B_OP540	5000	4500	{}	decreasing	A5-P1	A3	2	16	8
6375	RadFan2SrvAmpSpeed_0_path2_T_B_OP540	5000	4500	{}	decreasing	A0-P2	Y2	2	16	8
6376	RadFan2SrvAmpSpeed_2_path2_T_B_OP540	5000	4500	{}	decreasing	A2-P2	B1	2	16	8
6377	RadFan2SrvAmpSpeed_3_path2_T_B_OP540	5000	4500	{}	decreasing	A3-P2	B2	2	16	8
6378	InFan1SrvComPwSpeed_5_path1_T_B_OP540	6200	6000	{}	decreasing	A5-P1	A3	2	9	8
6379	InFan1SrvComPwSpeed_2_path2_T_B_OP540	6200	6000	{}	decreasing	A2-P2	B1	2	9	8
6380	InFan1SrvComPwSpeed_1_path2_T_B_OP540	6200	6000	{}	decreasing	A1-P2	Z2	2	9	8
6381	InFan1SrvComPwSpeed_4_path2_T_B_OP540	6200	6000	{}	decreasing	A4-P2	B3	2	9	8
6382	InFan1SrvComPwSpeed_3_path2_T_B_OP540	6200	6000	{}	decreasing	A3-P2	B2	2	9	8
6383	InFan1SrvComPwSpeed_0_path2_T_B_OP540	6200	6000	{}	decreasing	A0-P2	Y2	2	9	8
6384	ServoLeakResistData_1_path2_T_B_OP540	50	30	{}	decreasing	A1-P2	Z2	15	5	8
6385	ServoLeakResistData_5_path1_T_B_OP540	50	30	{}	decreasing	A5-P1	A3	15	5	8
6386	ServoLeakResistData_2_path2_T_B_OP540	50	30	{}	decreasing	A2-P2	B1	15	5	8
6387	ServoLeakResistData_3_path2_T_B_OP540	50	30	{}	decreasing	A3-P2	B2	15	5	8
6388	ServoLeakResistData_0_path2_T_B_OP540	50	30	{}	decreasing	A0-P2	Y2	15	5	8
6389	ServoLeakResistData_4_path2_T_B_OP540	50	30	{}	decreasing	A4-P2	B3	15	5	8
6390	ApcBatLow_2_path2_T_B_OP540	NaN	NaN	{}	bool	A2-P2	B1	6	1	8
6391	ApcBatLow_3_path2_T_B_OP540	NaN	NaN	{}	bool	A3-P2	B2	6	1	8
6392	ApcBatLow_0_path2_T_B_OP540	NaN	NaN	{}	bool	A0-P2	Y2	6	1	8
6393	ApcBatLow_1_path2_T_B_OP540	NaN	NaN	{}	bool	A1-P2	Z2	6	1	8
6394	ApcBatLow_4_path2_T_B_OP540	NaN	NaN	{}	bool	A4-P2	B3	6	1	8
6395	ApcBatLow_5_path1_T_B_OP540	NaN	NaN	{}	bool	A5-P1	A3	6	1	8
6396	CncBatLow_2_path2_T_B_OP540	NaN	NaN	{}	bool	A2-P2	B1	6	2	8
6397	CncBatLow_5_path1_T_B_OP540	NaN	NaN	{}	bool	A5-P1	A3	6	2	8
6398	CncBatLow_0_path2_T_B_OP540	NaN	NaN	{}	bool	A0-P2	Y2	6	2	8
6399	CncBatLow_1_path2_T_B_OP540	NaN	NaN	{}	bool	A1-P2	Z2	6	2	8
6400	CncBatLow_3_path2_T_B_OP540	NaN	NaN	{}	bool	A3-P2	B2	6	2	8
6401	CncBatLow_4_path2_T_B_OP540	NaN	NaN	{}	bool	A4-P2	B3	6	2	8
6402	InFan2SrvAmpSpeed_4_path2_T_B_OP540	5000	4500	{}	decreasing	A4-P2	B3	2	11	8
6403	InFan2SrvAmpSpeed_0_path2_T_B_OP540	5000	4500	{}	decreasing	A0-P2	Y2	2	11	8
6404	InFan2SrvAmpSpeed_1_path2_T_B_OP540	5000	4500	{}	decreasing	A1-P2	Z2	2	11	8
6405	InFan2SrvAmpSpeed_2_path2_T_B_OP540	5000	4500	{}	decreasing	A2-P2	B1	2	11	8
6406	InFan2SrvAmpSpeed_5_path1_T_B_OP540	5000	4500	{}	decreasing	A5-P1	A3	2	11	8
6407	InFan2SrvAmpSpeed_3_path2_T_B_OP540	5000	4500	{}	decreasing	A3-P2	B2	2	11	8
6408	SpdBatZero_4_path2_T_B_OP540	NaN	NaN	{}	bool	A4-P2	B3	6	13	8
6409	SpdBatZero_3_path2_T_B_OP540	NaN	NaN	{}	bool	A3-P2	B2	6	13	8
6410	SpdBatZero_0_path2_T_B_OP540	NaN	NaN	{}	bool	A0-P2	Y2	6	13	8
6411	SpdBatZero_2_path2_T_B_OP540	NaN	NaN	{}	bool	A2-P2	B1	6	13	8
6412	SpdBatZero_1_path2_T_B_OP540	NaN	NaN	{}	bool	A1-P2	Z2	6	13	8
6413	SpdBatZero_5_path1_T_B_OP540	NaN	NaN	{}	bool	A5-P1	A3	6	13	8
6414	SSpdBatZero_1_path2_T_B_OP540	NaN	NaN	{}	bool	A1-P2	Z2	6	14	8
6415	SSpdBatZero_5_path1_T_B_OP540	NaN	NaN	{}	bool	A5-P1	A3	6	14	8
6416	SSpdBatZero_4_path2_T_B_OP540	NaN	NaN	{}	bool	A4-P2	B3	6	14	8
6417	SSpdBatZero_0_path2_T_B_OP540	NaN	NaN	{}	bool	A0-P2	Y2	6	14	8
6418	SSpdBatZero_3_path2_T_B_OP540	NaN	NaN	{}	bool	A3-P2	B2	6	14	8
6419	SSpdBatZero_2_path2_T_B_OP540	NaN	NaN	{}	bool	A2-P2	B1	6	14	8
6420	ServoLoad_5_path1_T_B_OP540	NaN	NaN	{}	increasing	A5-P1	A3	17	17	8
6421	ServoLoad_4_path2_T_B_OP540	NaN	NaN	{}	increasing	A4-P2	B3	17	17	8
6422	ServoLoad_2_path2_T_B_OP540	NaN	NaN	{}	increasing	A2-P2	B1	17	17	8
6423	ServoLoad_1_path2_T_B_OP540	NaN	NaN	{}	increasing	A1-P2	Z2	17	17	8
6424	ServoLoad_0_path2_T_B_OP540	NaN	NaN	{}	increasing	A0-P2	Y2	17	17	8
6425	ServoLoad_3_path2_T_B_OP540	NaN	NaN	{}	increasing	A3-P2	B2	17	17	8
6426	RadFan1SrvAmpSpeed_1_path2_T_B_OP540	5000	4500	{}	decreasing	A1-P2	Z2	2	15	8
6427	RadFan1SrvAmpSpeed_0_path2_T_B_OP540	5000	4500	{}	decreasing	A0-P2	Y2	2	15	8
6428	RadFan1SrvAmpSpeed_2_path2_T_B_OP540	5000	4500	{}	decreasing	A2-P2	B1	2	15	8
6429	RadFan1SrvAmpSpeed_5_path1_T_B_OP540	5000	4500	{}	decreasing	A5-P1	A3	2	15	8
6430	RadFan1SrvAmpSpeed_4_path2_T_B_OP540	5000	4500	{}	decreasing	A4-P2	B3	2	15	8
6431	RadFan1SrvAmpSpeed_3_path2_T_B_OP540	5000	4500	{}	decreasing	A3-P2	B2	2	15	8
6432	ServoTemp_1_path2_T_B_OP540	70	80	{}	increasing	A1-P2	Z2	13	3	8
6433	ServoTemp_5_path1_T_B_OP540	70	80	{}	increasing	A5-P1	A3	13	3	8
6434	ServoTemp_0_path2_T_B_OP540	70	80	{}	increasing	A0-P2	Y2	13	3	8
6435	ServoTemp_3_path2_T_B_OP540	70	80	{}	increasing	A3-P2	B2	13	3	8
6436	ServoTemp_4_path2_T_B_OP540	70	80	{}	increasing	A4-P2	B3	13	3	8
6437	ServoTemp_2_path2_T_B_OP540	70	80	{}	increasing	A2-P2	B1	13	3	8
6438	CncFan2Speed_path2_T_B_OP540	4500	4000	{}	decreasing	A2-P2	F4	16	6	8
6439	CncFan1Speed_path2_T_B_OP540	4500	4000	{}	decreasing	A1-P2	F2	16	6	8
6440	PulseCoderTemp_1_path2_T_B_OP540	75	85	{}	increasing	A1-P2	Z2	13	4	8
6441	PulseCoderTemp_0_path2_T_B_OP540	75	85	{}	increasing	A0-P2	Y2	13	4	8
6442	PulseCoderTemp_2_path2_T_B_OP540	75	85	{}	increasing	A2-P2	B1	13	4	8
6443	PulseCoderTemp_5_path1_T_B_OP540	75	85	{}	increasing	A5-P1	A3	13	4	8
6444	PulseCoderTemp_3_path2_T_B_OP540	75	85	{}	increasing	A3-P2	B2	13	4	8
6445	PulseCoderTemp_4_path2_T_B_OP540	75	85	{}	increasing	A4-P2	B3	13	4	8
6446	InFan1SrvAmpSpeed_3_path2_T_B_OP540	9500	9000	{}	decreasing	A3-P2	B2	2	8	8
6447	InFan1SrvAmpSpeed_2_path2_T_B_OP540	9500	9000	{}	decreasing	A2-P2	B1	2	8	8
6448	InFan1SrvAmpSpeed_1_path2_T_B_OP540	9500	9000	{}	decreasing	A1-P2	Z2	2	8	8
6449	InFan1SrvAmpSpeed_5_path1_T_B_OP540	8200	8000	{}	decreasing	A5-P1	A3	2	8	8
6450	InFan1SrvAmpSpeed_0_path2_T_B_OP540	9500	9000	{}	decreasing	A0-P2	Y2	2	8	8
6451	InFan1SrvAmpSpeed_4_path2_T_B_OP540	9500	9000	{}	decreasing	A4-P2	B3	2	8	8
6452	RadFan2SrvAmpSpeed_0_path2_T_H_OP10	5000	4500	{}	decreasing	A0-P2	WTC	2	16	23
6453	ServoLoad_0_path2_T_H_OP10	NaN	NaN	{}	increasing	A0-P2	WTC	17	17	23
6454	RadFan1SrvAmpSpeed_0_path2_T_H_OP10	5000	4500	{}	decreasing	A0-P2	WTC	2	15	23
6455	InFan2SrvComPwSpeed_0_path2_T_H_OP100A	5000	4500	{}	decreasing	A0-P2	WTC	2	12	24
6456	RadFan2SrvAmpSpeed_0_path2_T_H_OP100A	5000	4500	{}	decreasing	A0-P2	WTC	2	16	24
6457	InFan1SrvComPwSpeed_0_path2_T_H_OP100A	6200	6000	{}	decreasing	A0-P2	WTC	2	9	24
6458	ServoLeakResistData_0_path2_T_H_OP100A	50	30	{}	decreasing	A0-P2	WTC	15	5	24
6459	ApcBatLow_0_path2_T_H_OP100A	NaN	NaN	{}	bool	A0-P2	WTC	6	1	24
6460	CncBatLow_0_path2_T_H_OP100A	NaN	NaN	{}	bool	A0-P2	WTC	6	2	24
6461	InFan2SrvAmpSpeed_0_path2_T_H_OP100A	5000	4500	{}	decreasing	A0-P2	WTC	2	11	24
6462	SpdBatZero_0_path2_T_H_OP100A	NaN	NaN	{}	bool	A0-P2	WTC	6	13	24
6463	SSpdBatZero_0_path2_T_H_OP100A	NaN	NaN	{}	bool	A0-P2	WTC	6	14	24
6464	ServoLoad_0_path2_T_H_OP100A	NaN	NaN	{}	increasing	A0-P2	WTC	17	17	24
6465	RadFan1SrvAmpSpeed_0_path2_T_H_OP100A	5000	4500	{}	decreasing	A0-P2	WTC	2	15	24
6466	ServoTemp_0_path2_T_H_OP100A	55	70	{}	increasing	A0-P2	WTC	13	3	24
6467	PulseCoderTemp_0_path2_T_H_OP100A	60	80	{}	increasing	A0-P2	WTC	13	4	24
6468	InFan1SrvAmpSpeed_0_path2_T_H_OP100A	8000	7500	{}	decreasing	A0-P2	WTC	2	8	24
6469	InFan2SrvComPwSpeed_0_path2_T_H_OP100B	5000	4500	{}	decreasing	A0-P2	WTC	2	12	25
6470	RadFan2SrvAmpSpeed_0_path2_T_H_OP100B	5000	4500	{}	decreasing	A0-P2	WTC	2	16	25
6471	InFan1SrvComPwSpeed_0_path2_T_H_OP100B	6200	6000	{}	decreasing	A0-P2	WTC	2	9	25
6472	ServoLeakResistData_0_path2_T_H_OP100B	50	30	{}	decreasing	A0-P2	WTC	15	5	25
6473	ApcBatLow_0_path2_T_H_OP100B	NaN	NaN	{}	bool	A0-P2	WTC	6	1	25
6474	CncBatLow_0_path2_T_H_OP100B	NaN	NaN	{}	bool	A0-P2	WTC	6	2	25
6475	InFan2SrvAmpSpeed_0_path2_T_H_OP100B	5000	4500	{}	decreasing	A0-P2	WTC	2	11	25
6476	SpdBatZero_0_path2_T_H_OP100B	NaN	NaN	{}	bool	A0-P2	WTC	6	13	25
6477	SSpdBatZero_0_path2_T_H_OP100B	NaN	NaN	{}	bool	A0-P2	WTC	6	14	25
6478	ServoLoad_0_path2_T_H_OP100B	NaN	NaN	{}	increasing	A0-P2	WTC	17	17	25
6479	RadFan1SrvAmpSpeed_0_path2_T_H_OP100B	5000	4500	{}	decreasing	A0-P2	WTC	2	15	25
6480	ServoTemp_0_path2_T_H_OP100B	55	70	{}	increasing	A0-P2	WTC	13	3	25
6481	CncFan1Speed_path2_T_H_OP100B	4500	4000	{}	decreasing	A1-P2	F2	16	6	25
6482	CncFan2Speed_path2_T_H_OP100B	4500	4000	{}	decreasing	A2-P2	F4	16	6	25
6483	PulseCoderTemp_0_path2_T_H_OP100B	60	80	{}	increasing	A0-P2	WTC	13	4	25
6484	InFan1SrvAmpSpeed_0_path2_T_H_OP100B	7500	7000	{}	decreasing	A0-P2	WTC	2	8	25
6485	InFan2SrvComPwSpeed_0_path2_T_H_OP110A	5000	4500	{}	decreasing	A0-P2	WTC	2	12	26
6486	RadFan2SrvAmpSpeed_0_path2_T_H_OP110A	5000	4500	{}	decreasing	A0-P2	WTC	2	16	26
6487	InFan1SrvComPwSpeed_0_path2_T_H_OP110A	6200	6000	{}	decreasing	A0-P2	WTC	2	9	26
6488	ServoLeakResistData_0_path2_T_H_OP110A	50	30	{}	decreasing	A0-P2	WTC	15	5	26
6489	ApcBatLow_0_path2_T_H_OP110A	NaN	NaN	{}	bool	A0-P2	WTC	6	1	26
6490	CncBatLow_0_path2_T_H_OP110A	NaN	NaN	{}	bool	A0-P2	WTC	6	2	26
6491	InFan2SrvAmpSpeed_0_path2_T_H_OP110A	5000	4500	{}	decreasing	A0-P2	WTC	2	11	26
6492	SpdBatZero_0_path2_T_H_OP110A	NaN	NaN	{}	bool	A0-P2	WTC	6	13	26
6493	SSpdBatZero_0_path2_T_H_OP110A	NaN	NaN	{}	bool	A0-P2	WTC	6	14	26
6494	ServoLoad_0_path2_T_H_OP110A	NaN	NaN	{}	increasing	A0-P2	WTC	17	17	26
6495	RadFan1SrvAmpSpeed_0_path2_T_H_OP110A	5000	4500	{}	decreasing	A0-P2	WTC	2	15	26
6496	ServoTemp_0_path2_T_H_OP110A	55	70	{}	increasing	A0-P2	WTC	13	3	26
6497	CncFan1Speed_path2_T_H_OP110A	4500	4000	{}	decreasing	A1-P2	F2	16	6	26
6498	CncFan2Speed_path2_T_H_OP110A	4500	4000	{}	decreasing	A2-P2	F4	16	6	26
6499	PulseCoderTemp_0_path2_T_H_OP110A	60	80	{}	increasing	A0-P2	WTC	13	4	26
6500	InFan1SrvAmpSpeed_0_path2_T_H_OP110A	7500	7000	{}	decreasing	A0-P2	WTC	2	8	26
6501	InFan2SrvComPwSpeed_0_path2_T_H_OP110B	5000	4500	{}	decreasing	A0-P2	WTC	2	12	27
6502	RadFan2SrvAmpSpeed_0_path2_T_H_OP110B	5000	4500	{}	decreasing	A0-P2	WTC	2	16	27
6503	InFan1SrvComPwSpeed_0_path2_T_H_OP110B	6200	6000	{}	decreasing	A0-P2	WTC	2	9	27
6504	ServoLeakResistData_0_path2_T_H_OP110B	50	30	{}	decreasing	A0-P2	WTC	15	5	27
6505	ApcBatLow_0_path2_T_H_OP110B	NaN	NaN	{}	bool	A0-P2	WTC	6	1	27
6506	CncBatLow_0_path2_T_H_OP110B	NaN	NaN	{}	bool	A0-P2	WTC	6	2	27
6507	InFan2SrvAmpSpeed_0_path2_T_H_OP110B	5000	4500	{}	decreasing	A0-P2	WTC	2	11	27
6508	SpdBatZero_0_path2_T_H_OP110B	NaN	NaN	{}	bool	A0-P2	WTC	6	13	27
6509	SSpdBatZero_0_path2_T_H_OP110B	NaN	NaN	{}	bool	A0-P2	WTC	6	14	27
6510	ServoLoad_0_path2_T_H_OP110B	NaN	NaN	{}	increasing	A0-P2	WTC	17	17	27
6511	RadFan1SrvAmpSpeed_0_path2_T_H_OP110B	5000	4500	{}	decreasing	A0-P2	WTC	2	15	27
6512	ServoTemp_0_path2_T_H_OP110B	55	70	{}	increasing	A0-P2	WTC	13	3	27
6513	CncFan2Speed_path2_T_H_OP110B	4500	4000	{}	decreasing	A2-P2	F4	16	6	27
6514	CncFan1Speed_path2_T_H_OP110B	4500	4000	{}	decreasing	A1-P2	F2	16	6	27
6515	PulseCoderTemp_0_path2_T_H_OP110B	60	80	{}	increasing	A0-P2	WTC	13	4	27
6516	InFan1SrvAmpSpeed_0_path2_T_H_OP110B	8000	7500	{}	decreasing	A0-P2	WTC	2	8	27
6517	InFan2SrvComPwSpeed_0_path2_T_H_OP120A	5000	4500	{}	decreasing	A0-P2	WTC	2	12	28
6518	RadFan2SrvAmpSpeed_0_path2_T_H_OP120A	5000	4500	{}	decreasing	A0-P2	WTC	2	16	28
6519	InFan1SrvComPwSpeed_0_path2_T_H_OP120A	6200	6000	{}	decreasing	A0-P2	WTC	2	9	28
6520	ServoLeakResistData_0_path2_T_H_OP120A	50	30	{}	decreasing	A0-P2	WTC	15	5	28
6521	ApcBatLow_0_path2_T_H_OP120A	NaN	NaN	{}	bool	A0-P2	WTC	6	1	28
6522	CncBatLow_0_path2_T_H_OP120A	NaN	NaN	{}	bool	A0-P2	WTC	6	2	28
6523	InFan2SrvAmpSpeed_0_path2_T_H_OP120A	5000	4500	{}	decreasing	A0-P2	WTC	2	11	28
6524	SpdBatZero_0_path2_T_H_OP120A	NaN	NaN	{}	bool	A0-P2	WTC	6	13	28
6525	SSpdBatZero_0_path2_T_H_OP120A	NaN	NaN	{}	bool	A0-P2	WTC	6	14	28
6526	ServoLoad_0_path2_T_H_OP120A	NaN	NaN	{}	increasing	A0-P2	WTC	17	17	28
6527	RadFan1SrvAmpSpeed_0_path2_T_H_OP120A	5000	4500	{}	decreasing	A0-P2	WTC	2	15	28
6528	ServoTemp_0_path2_T_H_OP120A	55	70	{}	increasing	A0-P2	WTC	13	3	28
6529	CncFan1Speed_path2_T_H_OP120A	4500	4000	{}	decreasing	A1-P2	F2	16	6	28
6530	CncFan2Speed_path2_T_H_OP120A	4500	4000	{}	decreasing	A2-P2	F4	16	6	28
6531	PulseCoderTemp_0_path2_T_H_OP120A	60	80	{}	increasing	A0-P2	WTC	13	4	28
6532	InFan1SrvAmpSpeed_0_path2_T_H_OP120A	7500	7000	{}	decreasing	A0-P2	WTC	2	8	28
6533	InFan2SrvComPwSpeed_0_path2_T_H_OP120B	5000	4500	{}	decreasing	A0-P2	WTC	2	12	29
6534	RadFan2SrvAmpSpeed_0_path2_T_H_OP120B	5000	4500	{}	decreasing	A0-P2	WTC	2	16	29
6535	InFan1SrvComPwSpeed_0_path2_T_H_OP120B	6200	6000	{}	decreasing	A0-P2	WTC	2	9	29
6536	ServoLeakResistData_0_path2_T_H_OP120B	50	30	{}	decreasing	A0-P2	WTC	15	5	29
6537	ApcBatLow_0_path2_T_H_OP120B	NaN	NaN	{}	bool	A0-P2	WTC	6	1	29
6538	CncBatLow_0_path2_T_H_OP120B	NaN	NaN	{}	bool	A0-P2	WTC	6	2	29
6539	InFan2SrvAmpSpeed_0_path2_T_H_OP120B	5000	4500	{}	decreasing	A0-P2	WTC	2	11	29
6540	SpdBatZero_0_path2_T_H_OP120B	NaN	NaN	{}	bool	A0-P2	WTC	6	13	29
6541	SSpdBatZero_0_path2_T_H_OP120B	NaN	NaN	{}	bool	A0-P2	WTC	6	14	29
6542	ServoLoad_0_path2_T_H_OP120B	NaN	NaN	{}	increasing	A0-P2	WTC	17	17	29
6543	RadFan1SrvAmpSpeed_0_path2_T_H_OP120B	5000	4500	{}	decreasing	A0-P2	WTC	2	15	29
6544	ServoTemp_0_path2_T_H_OP120B	55	70	{}	increasing	A0-P2	WTC	13	3	29
6545	CncFan1Speed_path2_T_H_OP120B	4500	4000	{}	decreasing	A1-P2	F2	16	6	29
6546	CncFan2Speed_path2_T_H_OP120B	4500	4000	{}	decreasing	A2-P2	F4	16	6	29
6547	PulseCoderTemp_0_path2_T_H_OP120B	60	80	{}	increasing	A0-P2	WTC	13	4	29
6548	InFan1SrvAmpSpeed_0_path2_T_H_OP120B	7500	7000	{}	decreasing	A0-P2	WTC	2	8	29
6549	InFan2SrvComPwSpeed_0_path2_T_H_OP140A	5000	4500	{}	decreasing	A0-P2	WTC	2	12	30
6550	RadFan2SrvAmpSpeed_0_path2_T_H_OP140A	5000	4500	{}	decreasing	A0-P2	WTC	2	16	30
6551	InFan1SrvComPwSpeed_0_path2_T_H_OP140A	6200	6000	{}	decreasing	A0-P2	WTC	2	9	30
6552	ServoLeakResistData_0_path2_T_H_OP140A	50	30	{}	decreasing	A0-P2	WTC	15	5	30
6553	ApcBatLow_0_path2_T_H_OP140A	NaN	NaN	{}	bool	A0-P2	WTC	6	1	30
6554	CncBatLow_0_path2_T_H_OP140A	NaN	NaN	{}	bool	A0-P2	WTC	6	2	30
6555	InFan2SrvAmpSpeed_0_path2_T_H_OP140A	5000	4500	{}	decreasing	A0-P2	WTC	2	11	30
6556	SpdBatZero_0_path2_T_H_OP140A	NaN	NaN	{}	bool	A0-P2	WTC	6	13	30
6557	SSpdBatZero_0_path2_T_H_OP140A	NaN	NaN	{}	bool	A0-P2	WTC	6	14	30
6558	ServoLoad_0_path2_T_H_OP140A	NaN	NaN	{}	increasing	A0-P2	WTC	17	17	30
6559	RadFan1SrvAmpSpeed_0_path2_T_H_OP140A	5000	4500	{}	decreasing	A0-P2	WTC	2	15	30
6560	ServoTemp_0_path2_T_H_OP140A	55	70	{}	increasing	A0-P2	WTC	13	3	30
6561	CncFan2Speed_path2_T_H_OP140A	4500	4000	{}	decreasing	A2-P2	F4	16	6	30
6562	CncFan1Speed_path2_T_H_OP140A	4500	4000	{}	decreasing	A1-P2	F2	16	6	30
6563	PulseCoderTemp_0_path2_T_H_OP140A	60	80	{}	increasing	A0-P2	WTC	13	4	30
6564	InFan1SrvAmpSpeed_0_path2_T_H_OP140A	9500	9000	{}	decreasing	A0-P2	WTC	2	8	30
6565	InFan2SrvComPwSpeed_0_path2_T_H_OP140B	5000	4500	{}	decreasing	A0-P2	WTC	2	12	31
6566	RadFan2SrvAmpSpeed_0_path2_T_H_OP140B	5000	4500	{}	decreasing	A0-P2	WTC	2	16	31
6567	InFan1SrvComPwSpeed_0_path2_T_H_OP140B	6200	6000	{}	decreasing	A0-P2	WTC	2	9	31
6568	ServoLeakResistData_0_path2_T_H_OP140B	50	30	{}	decreasing	A0-P2	WTC	15	5	31
6569	ApcBatLow_0_path2_T_H_OP140B	NaN	NaN	{}	bool	A0-P2	WTC	6	1	31
6570	CncBatLow_0_path2_T_H_OP140B	NaN	NaN	{}	bool	A0-P2	WTC	6	2	31
6571	InFan2SrvAmpSpeed_0_path2_T_H_OP140B	5000	4500	{}	decreasing	A0-P2	WTC	2	11	31
6572	SpdBatZero_0_path2_T_H_OP140B	NaN	NaN	{}	bool	A0-P2	WTC	6	13	31
6573	SSpdBatZero_0_path2_T_H_OP140B	NaN	NaN	{}	bool	A0-P2	WTC	6	14	31
6574	ServoLoad_0_path2_T_H_OP140B	NaN	NaN	{}	increasing	A0-P2	WTC	17	17	31
6575	RadFan1SrvAmpSpeed_0_path2_T_H_OP140B	5000	4500	{}	decreasing	A0-P2	WTC	2	15	31
6576	ServoTemp_0_path2_T_H_OP140B	55	70	{}	increasing	A0-P2	WTC	13	3	31
6577	CncFan1Speed_path2_T_H_OP140B	4500	4000	{}	decreasing	A1-P2	F2	16	6	31
6578	CncFan2Speed_path2_T_H_OP140B	4500	4000	{}	decreasing	A2-P2	F4	16	6	31
6579	PulseCoderTemp_0_path2_T_H_OP140B	60	80	{}	increasing	A0-P2	WTC	13	4	31
6580	InFan1SrvAmpSpeed_0_path2_T_H_OP140B	7500	7000	{}	decreasing	A0-P2	WTC	2	8	31
6581	InFan2SrvComPwSpeed_0_path2_T_H_OP150A	5000	4500	{}	decreasing	A0-P2	WTC	2	12	32
6582	RadFan2SrvAmpSpeed_0_path2_T_H_OP150A	5000	4500	{}	decreasing	A0-P2	WTC	2	16	32
6583	InFan1SrvComPwSpeed_0_path2_T_H_OP150A	6200	6000	{}	decreasing	A0-P2	WTC	2	9	32
6584	ServoLeakResistData_0_path2_T_H_OP150A	50	30	{}	decreasing	A0-P2	WTC	15	5	32
6585	ApcBatLow_0_path2_T_H_OP150A	NaN	NaN	{}	bool	A0-P2	WTC	6	1	32
6586	CncBatLow_0_path2_T_H_OP150A	NaN	NaN	{}	bool	A0-P2	WTC	6	2	32
6587	InFan2SrvAmpSpeed_0_path2_T_H_OP150A	5000	4500	{}	decreasing	A0-P2	WTC	2	11	32
6588	SpdBatZero_0_path2_T_H_OP150A	NaN	NaN	{}	bool	A0-P2	WTC	6	13	32
6589	SSpdBatZero_0_path2_T_H_OP150A	NaN	NaN	{}	bool	A0-P2	WTC	6	14	32
6590	ServoLoad_0_path2_T_H_OP150A	NaN	NaN	{}	increasing	A0-P2	WTC	17	17	32
6591	RadFan1SrvAmpSpeed_0_path2_T_H_OP150A	5000	4500	{}	decreasing	A0-P2	WTC	2	15	32
6592	ServoTemp_0_path2_T_H_OP150A	55	70	{}	increasing	A0-P2	WTC	13	3	32
6593	CncFan1Speed_path2_T_H_OP150A	4500	4000	{}	decreasing	A1-P2	F2	16	6	32
6594	CncFan2Speed_path2_T_H_OP150A	4500	4000	{}	decreasing	A2-P2	F4	16	6	32
6595	PulseCoderTemp_0_path2_T_H_OP150A	60	80	{}	increasing	A0-P2	WTC	13	4	32
6596	InFan1SrvAmpSpeed_0_path2_T_H_OP150A	7500	7000	{}	decreasing	A0-P2	WTC	2	8	32
6597	InFan2SrvComPwSpeed_0_path2_T_H_OP150B	5000	4500	{}	decreasing	A0-P2	WTC	2	12	33
6598	RadFan2SrvAmpSpeed_0_path2_T_H_OP150B	5000	4500	{}	decreasing	A0-P2	WTC	2	16	33
6599	InFan1SrvComPwSpeed_0_path2_T_H_OP150B	6200	6000	{}	decreasing	A0-P2	WTC	2	9	33
6600	ServoLeakResistData_0_path2_T_H_OP150B	50	30	{}	decreasing	A0-P2	WTC	15	5	33
6601	ApcBatLow_0_path2_T_H_OP150B	NaN	NaN	{}	bool	A0-P2	WTC	6	1	33
6602	CncBatLow_0_path2_T_H_OP150B	NaN	NaN	{}	bool	A0-P2	WTC	6	2	33
6603	InFan2SrvAmpSpeed_0_path2_T_H_OP150B	5000	4500	{}	decreasing	A0-P2	WTC	2	11	33
6604	SpdBatZero_0_path2_T_H_OP150B	NaN	NaN	{}	bool	A0-P2	WTC	6	13	33
6605	SSpdBatZero_0_path2_T_H_OP150B	NaN	NaN	{}	bool	A0-P2	WTC	6	14	33
6606	ServoLoad_0_path2_T_H_OP150B	NaN	NaN	{}	increasing	A0-P2	WTC	17	17	33
6607	RadFan1SrvAmpSpeed_0_path2_T_H_OP150B	5000	4500	{}	decreasing	A0-P2	WTC	2	15	33
6608	ServoTemp_0_path2_T_H_OP150B	55	70	{}	increasing	A0-P2	WTC	13	3	33
6609	CncFan2Speed_path2_T_H_OP150B	4500	4000	{}	decreasing	A2-P2	F4	16	6	33
6610	CncFan1Speed_path2_T_H_OP150B	4500	4000	{}	decreasing	A1-P2	F2	16	6	33
6611	PulseCoderTemp_0_path2_T_H_OP150B	60	80	{}	increasing	A0-P2	WTC	13	4	33
6612	InFan1SrvAmpSpeed_0_path2_T_H_OP150B	8500	8200	{}	decreasing	A0-P2	WTC	2	8	33
6613	InFan2SrvComPwSpeed_0_path2_T_H_OP160A	5000	4500	{}	decreasing	A0-P2	WTC	2	12	34
6614	RadFan2SrvAmpSpeed_0_path2_T_H_OP160A	5000	4500	{}	decreasing	A0-P2	WTC	2	16	34
6615	InFan1SrvComPwSpeed_0_path2_T_H_OP160A	6200	6000	{}	decreasing	A0-P2	WTC	2	9	34
6616	ServoLeakResistData_0_path2_T_H_OP160A	50	30	{}	decreasing	A0-P2	WTC	15	5	34
6617	ApcBatLow_0_path2_T_H_OP160A	NaN	NaN	{}	bool	A0-P2	WTC	6	1	34
6618	CncBatLow_0_path2_T_H_OP160A	NaN	NaN	{}	bool	A0-P2	WTC	6	2	34
6619	InFan2SrvAmpSpeed_0_path2_T_H_OP160A	5000	4500	{}	decreasing	A0-P2	WTC	2	11	34
6620	SpdBatZero_0_path2_T_H_OP160A	NaN	NaN	{}	bool	A0-P2	WTC	6	13	34
6621	SSpdBatZero_0_path2_T_H_OP160A	NaN	NaN	{}	bool	A0-P2	WTC	6	14	34
6622	ServoLoad_0_path2_T_H_OP160A	NaN	NaN	{}	increasing	A0-P2	WTC	17	17	34
6623	RadFan1SrvAmpSpeed_0_path2_T_H_OP160A	5000	4500	{}	decreasing	A0-P2	WTC	2	15	34
6624	ServoTemp_0_path2_T_H_OP160A	55	70	{}	increasing	A0-P2	WTC	13	3	34
6625	CncFan1Speed_path2_T_H_OP160A	4500	4000	{}	decreasing	A1-P2	F2	16	6	34
6626	CncFan2Speed_path2_T_H_OP160A	4500	4000	{}	decreasing	A2-P2	F4	16	6	34
6627	PulseCoderTemp_0_path2_T_H_OP160A	60	80	{}	increasing	A0-P2	WTC	13	4	34
6628	InFan1SrvAmpSpeed_0_path2_T_H_OP160A	7500	7000	{}	decreasing	A0-P2	WTC	2	8	34
6629	InFan2SrvComPwSpeed_0_path2_T_H_OP160B	5000	4500	{}	decreasing	A0-P2	WTC	2	12	35
6630	RadFan2SrvAmpSpeed_0_path2_T_H_OP160B	5000	4500	{}	decreasing	A0-P2	WTC	2	16	35
6631	InFan1SrvComPwSpeed_0_path2_T_H_OP160B	6200	6000	{}	decreasing	A0-P2	WTC	2	9	35
6632	ServoLeakResistData_0_path2_T_H_OP160B	50	30	{}	decreasing	A0-P2	WTC	15	5	35
6633	ApcBatLow_0_path2_T_H_OP160B	NaN	NaN	{}	bool	A0-P2	WTC	6	1	35
6634	CncBatLow_0_path2_T_H_OP160B	NaN	NaN	{}	bool	A0-P2	WTC	6	2	35
6635	InFan2SrvAmpSpeed_0_path2_T_H_OP160B	5000	4500	{}	decreasing	A0-P2	WTC	2	11	35
6636	SpdBatZero_0_path2_T_H_OP160B	NaN	NaN	{}	bool	A0-P2	WTC	6	13	35
6637	SSpdBatZero_0_path2_T_H_OP160B	NaN	NaN	{}	bool	A0-P2	WTC	6	14	35
6638	ServoLoad_0_path2_T_H_OP160B	NaN	NaN	{}	increasing	A0-P2	WTC	17	17	35
6639	RadFan1SrvAmpSpeed_0_path2_T_H_OP160B	5000	4500	{}	decreasing	A0-P2	WTC	2	15	35
6640	ServoTemp_0_path2_T_H_OP160B	55	70	{}	increasing	A0-P2	WTC	13	3	35
6641	CncFan1Speed_path2_T_H_OP160B	4500	4000	{}	decreasing	A1-P2	F2	16	6	35
6642	CncFan2Speed_path2_T_H_OP160B	4500	4000	{}	decreasing	A2-P2	F4	16	6	35
6643	PulseCoderTemp_0_path2_T_H_OP160B	60	80	{}	increasing	A0-P2	WTC	13	4	35
6644	InFan1SrvAmpSpeed_0_path2_T_H_OP160B	8500	8200	{}	decreasing	A0-P2	WTC	2	8	35
6645	InFan2SrvComPwSpeed_0_path2_T_H_OP170A	5000	4500	{}	decreasing	A0-P2	WTC	2	12	36
6646	RadFan2SrvAmpSpeed_0_path2_T_H_OP170A	5000	4500	{}	decreasing	A0-P2	WTC	2	16	36
6647	InFan1SrvComPwSpeed_0_path2_T_H_OP170A	6200	6000	{}	decreasing	A0-P2	WTC	2	9	36
6648	ServoLeakResistData_0_path2_T_H_OP170A	50	30	{}	decreasing	A0-P2	WTC	15	5	36
6649	ApcBatLow_0_path2_T_H_OP170A	NaN	NaN	{}	bool	A0-P2	WTC	6	1	36
6650	CncBatLow_0_path2_T_H_OP170A	NaN	NaN	{}	bool	A0-P2	WTC	6	2	36
6651	InFan2SrvAmpSpeed_0_path2_T_H_OP170A	5000	4500	{}	decreasing	A0-P2	WTC	2	11	36
6652	SpdBatZero_0_path2_T_H_OP170A	NaN	NaN	{}	bool	A0-P2	WTC	6	13	36
6653	SSpdBatZero_0_path2_T_H_OP170A	NaN	NaN	{}	bool	A0-P2	WTC	6	14	36
6654	ServoLoad_0_path2_T_H_OP170A	NaN	NaN	{}	increasing	A0-P2	WTC	17	17	36
6655	RadFan1SrvAmpSpeed_0_path2_T_H_OP170A	5000	4500	{}	decreasing	A0-P2	WTC	2	15	36
6656	ServoTemp_0_path2_T_H_OP170A	55	70	{}	increasing	A0-P2	WTC	13	3	36
6657	CncFan1Speed_path2_T_H_OP170A	4500	4000	{}	decreasing	A1-P2	F2	16	6	36
6658	CncFan2Speed_path2_T_H_OP170A	4500	4000	{}	decreasing	A2-P2	F4	16	6	36
6659	PulseCoderTemp_0_path2_T_H_OP170A	60	80	{}	increasing	A0-P2	WTC	13	4	36
6660	InFan1SrvAmpSpeed_0_path2_T_H_OP170A	8500	8200	{}	decreasing	A0-P2	WTC	2	8	36
6661	InFan2SrvComPwSpeed_0_path2_T_H_OP170B	5000	4500	{}	decreasing	A0-P2	WTC	2	12	37
6662	RadFan2SrvAmpSpeed_0_path2_T_H_OP170B	5000	4500	{}	decreasing	A0-P2	WTC	2	16	37
6663	InFan1SrvComPwSpeed_0_path2_T_H_OP170B	6200	6000	{}	decreasing	A0-P2	WTC	2	9	37
6664	ServoLeakResistData_0_path2_T_H_OP170B	50	30	{}	decreasing	A0-P2	WTC	15	5	37
6665	ApcBatLow_0_path2_T_H_OP170B	NaN	NaN	{}	bool	A0-P2	WTC	6	1	37
6666	CncBatLow_0_path2_T_H_OP170B	NaN	NaN	{}	bool	A0-P2	WTC	6	2	37
6667	InFan2SrvAmpSpeed_0_path2_T_H_OP170B	5000	4500	{}	decreasing	A0-P2	WTC	2	11	37
6668	SpdBatZero_0_path2_T_H_OP170B	NaN	NaN	{}	bool	A0-P2	WTC	6	13	37
6669	SSpdBatZero_0_path2_T_H_OP170B	NaN	NaN	{}	bool	A0-P2	WTC	6	14	37
6670	ServoLoad_0_path2_T_H_OP170B	NaN	NaN	{}	increasing	A0-P2	WTC	17	17	37
6671	RadFan1SrvAmpSpeed_0_path2_T_H_OP170B	5000	4500	{}	decreasing	A0-P2	WTC	2	15	37
6672	ServoTemp_0_path2_T_H_OP170B	55	70	{}	increasing	A0-P2	WTC	13	3	37
6673	CncFan2Speed_path2_T_H_OP170B	4500	4000	{}	decreasing	A2-P1	F4	16	6	37
6674	CncFan1Speed_path2_T_H_OP170B	4500	4000	{}	decreasing	A1-P2	F2	16	6	37
6675	PulseCoderTemp_0_path2_T_H_OP170B	60	80	{}	increasing	A0-P2	WTC	13	4	37
6676	InFan1SrvAmpSpeed_0_path2_T_H_OP170B	7500	7000	{}	decreasing	A0-P2	WTC	2	8	37
6677	InFan2SrvComPwSpeed_0_path2_T_H_OP180A	5000	4500	{}	decreasing	A0-P2	WTC	2	12	38
6678	RadFan2SrvAmpSpeed_0_path2_T_H_OP180A	5000	4500	{}	decreasing	A0-P2	WTC	2	16	38
6679	InFan1SrvComPwSpeed_0_path2_T_H_OP180A	6200	6000	{}	decreasing	A0-P2	WTC	2	9	38
6680	ServoLeakResistData_0_path2_T_H_OP180A	50	30	{}	decreasing	A0-P2	WTC	15	5	38
6681	ApcBatLow_0_path2_T_H_OP180A	NaN	NaN	{}	bool	A0-P2	WTC	6	1	38
6682	CncBatLow_0_path2_T_H_OP180A	NaN	NaN	{}	bool	A0-P2	WTC	6	2	38
6683	InFan2SrvAmpSpeed_0_path2_T_H_OP180A	5000	4500	{}	decreasing	A0-P2	WTC	2	11	38
6684	SpdBatZero_0_path2_T_H_OP180A	NaN	NaN	{}	bool	A0-P2	WTC	6	13	38
6685	SSpdBatZero_0_path2_T_H_OP180A	NaN	NaN	{}	bool	A0-P2	WTC	6	14	38
6686	ServoLoad_0_path2_T_H_OP180A	NaN	NaN	{}	increasing	A0-P2	WTC	17	17	38
6687	RadFan1SrvAmpSpeed_0_path2_T_H_OP180A	5000	4500	{}	decreasing	A0-P2	WTC	2	15	38
6688	ServoTemp_0_path2_T_H_OP180A	55	70	{}	increasing	A0-P2	WTC	13	3	38
6689	CncFan2Speed_path2_T_H_OP180A	4500	4000	{}	decreasing	A2-P2	F4	16	6	38
6690	CncFan1Speed_path2_T_H_OP180A	4500	4000	{}	decreasing	A1-P2	F2	16	6	38
6691	PulseCoderTemp_0_path2_T_H_OP180A	60	80	{}	increasing	A0-P2	WTC	13	4	38
6692	InFan1SrvAmpSpeed_0_path2_T_H_OP180A	7500	7000	{}	decreasing	A0-P2	WTC	2	8	38
6693	InFan2SrvComPwSpeed_0_path2_T_H_OP180B	5000	4500	{}	decreasing	A0-P2	WTC	2	12	39
6694	RadFan2SrvAmpSpeed_0_path2_T_H_OP180B	5000	4500	{}	decreasing	A0-P2	WTC	2	16	39
6695	InFan1SrvComPwSpeed_0_path2_T_H_OP180B	6200	6000	{}	decreasing	A0-P2	WTC	2	9	39
6696	ServoLeakResistData_0_path2_T_H_OP180B	50	30	{}	decreasing	A0-P2	WTC	15	5	39
6697	ApcBatLow_0_path2_T_H_OP180B	NaN	NaN	{}	bool	A0-P2	WTC	6	1	39
6698	CncBatLow_0_path2_T_H_OP180B	NaN	NaN	{}	bool	A0-P2	WTC	6	2	39
6699	InFan2SrvAmpSpeed_0_path2_T_H_OP180B	5000	4500	{}	decreasing	A0-P2	WTC	2	11	39
6700	SpdBatZero_0_path2_T_H_OP180B	NaN	NaN	{}	bool	A0-P2	WTC	6	13	39
6701	SSpdBatZero_0_path2_T_H_OP180B	NaN	NaN	{}	bool	A0-P2	WTC	6	14	39
6702	ServoLoad_0_path2_T_H_OP180B	NaN	NaN	{}	increasing	A0-P2	WTC	17	17	39
6703	RadFan1SrvAmpSpeed_0_path2_T_H_OP180B	5000	4500	{}	decreasing	A0-P2	WTC	2	15	39
6704	ServoTemp_0_path2_T_H_OP180B	55	70	{}	increasing	A0-P2	WTC	13	3	39
6705	PulseCoderTemp_0_path2_T_H_OP180B	60	80	{}	increasing	A0-P2	WTC	13	4	39
6706	InFan1SrvAmpSpeed_0_path2_T_H_OP180B	8000	7500	{}	decreasing	A0-P2	WTC	2	8	39
6707	InFan2SrvComPwSpeed_0_path2_T_H_OP20	5000	4500	{}	decreasing	A0-P2	WTC	2	12	40
6708	RadFan2SrvAmpSpeed_0_path2_T_H_OP20	5000	4500	{}	decreasing	A0-P2	WTC	2	16	40
6709	InFan1SrvComPwSpeed_0_path2_T_H_OP20	6200	6000	{}	decreasing	A0-P2	WTC	2	9	40
6710	ServoLeakResistData_0_path2_T_H_OP20	50	30	{}	decreasing	A0-P2	WTC	15	5	40
6711	ApcBatLow_0_path2_T_H_OP20	NaN	NaN	{}	bool	A0-P2	WTC	6	1	40
6712	CncBatLow_0_path2_T_H_OP20	NaN	NaN	{}	bool	A0-P2	WTC	6	2	40
6713	InFan2SrvAmpSpeed_0_path2_T_H_OP20	5000	4500	{}	decreasing	A0-P2	WTC	2	11	40
6714	SpdBatZero_0_path2_T_H_OP20	NaN	NaN	{}	bool	A0-P2	WTC	6	13	40
6715	SSpdBatZero_0_path2_T_H_OP20	NaN	NaN	{}	bool	A0-P2	WTC	6	14	40
6716	ServoLoad_0_path2_T_H_OP20	NaN	NaN	{}	increasing	A0-P2	WTC	17	17	40
6717	RadFan1SrvAmpSpeed_0_path2_T_H_OP20	5000	4500	{}	decreasing	A0-P2	WTC	2	15	40
6718	ServoTemp_0_path2_T_H_OP20	55	70	{}	increasing	A0-P2	WTC	13	3	40
6719	PulseCoderTemp_0_path2_T_H_OP20	60	80	{}	increasing	A0-P2	WTC	13	4	40
6720	InFan1SrvAmpSpeed_0_path2_T_H_OP20	9500	9000	{}	decreasing	A0-P2	WTC	2	8	40
6721	InFan2SrvComPwSpeed_0_path2_T_H_OP270	5000	4500	{}	decreasing	A0-P2	WTC	2	12	45
6722	RadFan2SrvAmpSpeed_0_path2_T_H_OP270	5000	4500	{}	decreasing	A0-P2	WTC	2	16	45
6723	InFan1SrvComPwSpeed_0_path2_T_H_OP270	6200	6000	{}	decreasing	A0-P2	WTC	2	9	45
6724	ServoLeakResistData_0_path2_T_H_OP270	50	30	{}	decreasing	A0-P2	WTC	15	5	45
6725	ApcBatLow_0_path2_T_H_OP270	NaN	NaN	{}	bool	A0-P2	WTC	6	1	45
6726	CncBatLow_0_path2_T_H_OP270	NaN	NaN	{}	bool	A0-P2	WTC	6	2	45
6727	InFan2SrvAmpSpeed_0_path2_T_H_OP270	5000	4500	{}	decreasing	A0-P2	WTC	2	11	45
6728	SpdBatZero_0_path2_T_H_OP270	NaN	NaN	{}	bool	A0-P2	WTC	6	13	45
6729	SSpdBatZero_0_path2_T_H_OP270	NaN	NaN	{}	bool	A0-P2	WTC	6	14	45
6730	ServoLoad_0_path2_T_H_OP270	NaN	NaN	{}	increasing	A0-P2	WTC	17	17	45
6731	RadFan1SrvAmpSpeed_0_path2_T_H_OP270	5000	4500	{}	decreasing	A0-P2	WTC	2	15	45
6732	ServoTemp_0_path2_T_H_OP270	55	70	{}	increasing	A0-P2	WTC	13	3	45
6733	CncFan1Speed_path2_T_H_OP270	4500	4000	{}	decreasing	A1-P2	F2	16	6	45
6734	CncFan2Speed_path2_T_H_OP270	4500	4000	{}	decreasing	A2-P2	F4	16	6	45
6735	PulseCoderTemp_0_path2_T_H_OP270	60	80	{}	increasing	A0-P2	WTC	13	4	45
6736	InFan1SrvAmpSpeed_0_path2_T_H_OP270	7500	7000	{}	decreasing	A0-P2	WTC	2	8	45
6737	InFan2SrvComPwSpeed_2_path2_T_H_OP300	5000	4500	{}	decreasing	A2-P2	Z3	2	12	48
6738	InFan2SrvComPwSpeed_3_path2_T_H_OP300	5000	4500	{}	decreasing	A3-P2	B0	2	12	48
6739	InFan2SrvComPwSpeed_1_path2_T_H_OP300	5000	4500	{}	decreasing	A1-P2	Y3	2	12	48
6740	InFan2SrvComPwSpeed_0_path2_T_H_OP300	5000	4500	{}	decreasing	A0-P2	X3	2	12	48
6741	InFan2SrvComPwSpeed_4_path2_T_H_OP300	5000	4500	{}	decreasing	A4-P2	A0	2	12	48
6742	RadFan2SrvAmpSpeed_0_path2_T_H_OP300	5000	4500	{}	decreasing	A0-P2	X3	2	16	48
6743	RadFan2SrvAmpSpeed_3_path2_T_H_OP300	5000	4500	{}	decreasing	A3-P2	B0	2	16	48
6744	RadFan2SrvAmpSpeed_1_path2_T_H_OP300	5000	4500	{}	decreasing	A1-P2	Y3	2	16	48
6745	RadFan2SrvAmpSpeed_2_path2_T_H_OP300	5000	4500	{}	decreasing	A2-P2	Z3	2	16	48
6746	RadFan2SrvAmpSpeed_4_path2_T_H_OP300	5000	4500	{}	decreasing	A4-P2	A0	2	16	48
6747	InFan1SrvComPwSpeed_0_path2_T_H_OP300	6200	6000	{}	decreasing	A0-P2	X3	2	9	48
6748	InFan1SrvComPwSpeed_2_path2_T_H_OP300	6200	6000	{}	decreasing	A2-P2	Z3	2	9	48
6749	InFan1SrvComPwSpeed_3_path2_T_H_OP300	6200	6000	{}	decreasing	A3-P2	B0	2	9	48
6750	InFan1SrvComPwSpeed_4_path2_T_H_OP300	6200	6000	{}	decreasing	A4-P2	A0	2	9	48
6751	InFan1SrvComPwSpeed_1_path2_T_H_OP300	6200	6000	{}	decreasing	A1-P2	Y3	2	9	48
6752	ServoLeakResistData_4_path2_T_H_OP300	50	30	{}	decreasing	A4-P2	A0	15	5	48
6753	ServoLeakResistData_0_path2_T_H_OP300	50	30	{}	decreasing	A0-P2	X3	15	5	48
6754	ServoLeakResistData_1_path2_T_H_OP300	50	30	{}	decreasing	A1-P2	Y3	15	5	48
6755	ServoLeakResistData_2_path2_T_H_OP300	50	30	{}	decreasing	A2-P2	Z3	15	5	48
6756	ServoLeakResistData_3_path2_T_H_OP300	50	30	{}	decreasing	A3-P2	B0	15	5	48
6757	ApcBatLow_4_path2_T_H_OP300	NaN	NaN	{}	bool	A4-P2	A0	6	1	48
6758	ApcBatLow_1_path2_T_H_OP300	NaN	NaN	{}	bool	A1-P2	Y3	6	1	48
6759	ApcBatLow_0_path2_T_H_OP300	NaN	NaN	{}	bool	A0-P2	X3	6	1	48
6760	ApcBatLow_3_path2_T_H_OP300	NaN	NaN	{}	bool	A3-P2	B0	6	1	48
6761	ApcBatLow_2_path2_T_H_OP300	NaN	NaN	{}	bool	A2-P2	Z3	6	1	48
6762	CncBatLow_3_path2_T_H_OP300	NaN	NaN	{}	bool	A3-P2	B0	6	2	48
6763	CncBatLow_0_path2_T_H_OP300	NaN	NaN	{}	bool	A0-P2	X3	6	2	48
6764	CncBatLow_1_path2_T_H_OP300	NaN	NaN	{}	bool	A1-P2	Y3	6	2	48
6765	CncBatLow_2_path2_T_H_OP300	NaN	NaN	{}	bool	A2-P2	Z3	6	2	48
6766	CncBatLow_4_path2_T_H_OP300	NaN	NaN	{}	bool	A4-P2	A0	6	2	48
6767	InFan2SrvAmpSpeed_3_path2_T_H_OP300	5000	4500	{}	decreasing	A3-P2	B0	2	11	48
6768	InFan2SrvAmpSpeed_0_path2_T_H_OP300	5000	4500	{}	decreasing	A0-P2	X3	2	11	48
6769	InFan2SrvAmpSpeed_2_path2_T_H_OP300	5000	4500	{}	decreasing	A2-P2	Z3	2	11	48
6770	InFan2SrvAmpSpeed_1_path2_T_H_OP300	5000	4500	{}	decreasing	A1-P2	Y3	2	11	48
6771	InFan2SrvAmpSpeed_4_path2_T_H_OP300	5000	4500	{}	decreasing	A4-P2	A0	2	11	48
6772	SpdBatZero_0_path2_T_H_OP300	NaN	NaN	{}	bool	A0-P2	X3	6	13	48
6773	SpdBatZero_1_path2_T_H_OP300	NaN	NaN	{}	bool	A1-P2	Y3	6	13	48
6774	SpdBatZero_2_path2_T_H_OP300	NaN	NaN	{}	bool	A2-P2	Z3	6	13	48
6775	SpdBatZero_4_path2_T_H_OP300	NaN	NaN	{}	bool	A4-P2	A0	6	13	48
6776	SpdBatZero_3_path2_T_H_OP300	NaN	NaN	{}	bool	A3-P2	B0	6	13	48
6777	SSpdBatZero_1_path2_T_H_OP300	NaN	NaN	{}	bool	A1-P2	Y3	6	14	48
6778	SSpdBatZero_3_path2_T_H_OP300	NaN	NaN	{}	bool	A3-P2	B0	6	14	48
6779	SSpdBatZero_2_path2_T_H_OP300	NaN	NaN	{}	bool	A2-P2	Z3	6	14	48
6780	SSpdBatZero_4_path2_T_H_OP300	NaN	NaN	{}	bool	A4-P2	A0	6	14	48
6781	SSpdBatZero_0_path2_T_H_OP300	NaN	NaN	{}	bool	A0-P2	X3	6	14	48
6782	ServoLoad_3_path2_T_H_OP300	NaN	NaN	{}	increasing	A3-P2	B0	17	17	48
6783	ServoLoad_4_path2_T_H_OP300	NaN	NaN	{}	increasing	A4-P2	A0	17	17	48
6784	ServoLoad_0_path2_T_H_OP300	NaN	NaN	{}	increasing	A0-P2	X3	17	17	48
6785	ServoLoad_1_path2_T_H_OP300	NaN	NaN	{}	increasing	A1-P2	Y3	17	17	48
6786	ServoLoad_2_path2_T_H_OP300	NaN	NaN	{}	increasing	A2-P2	Z3	17	17	48
6787	RadFan1SrvAmpSpeed_4_path2_T_H_OP300	5000	4500	{}	decreasing	A4-P2	A0	2	15	48
6788	RadFan1SrvAmpSpeed_1_path2_T_H_OP300	5000	4500	{}	decreasing	A1-P2	Y3	2	15	48
6789	RadFan1SrvAmpSpeed_3_path2_T_H_OP300	5000	4500	{}	decreasing	A3-P2	B0	2	15	48
6790	RadFan1SrvAmpSpeed_2_path2_T_H_OP300	5000	4500	{}	decreasing	A2-P2	Z3	2	15	48
6791	RadFan1SrvAmpSpeed_0_path2_T_H_OP300	5000	4500	{}	decreasing	A0-P2	X3	2	15	48
6792	ServoTemp_2_path2_T_H_OP300	55	70	{}	increasing	A2-P2	Z3	13	3	48
6793	ServoTemp_1_path2_T_H_OP300	55	70	{}	increasing	A1-P2	Y3	13	3	48
6794	ServoTemp_4_path2_T_H_OP300	55	70	{}	increasing	A4-P2	A0	13	3	48
6795	ServoTemp_0_path2_T_H_OP300	55	70	{}	increasing	A0-P2	X3	13	3	48
6796	ServoTemp_3_path2_T_H_OP300	55	70	{}	increasing	A3-P2	B0	13	3	48
6797	CncFan2Speed_path2_T_H_OP300	4500	4000	{}	decreasing	A2-P2	F4	16	6	48
6798	CncFan1Speed_path2_T_H_OP300	4500	4000	{}	decreasing	A1-P2	F2	16	6	48
6799	PulseCoderTemp_1_path2_T_H_OP300	60	80	{}	increasing	A1-P2	Y3	13	4	48
6800	PulseCoderTemp_4_path2_T_H_OP300	90	100	{}	increasing	A4-P2	A0	13	4	48
6801	PulseCoderTemp_0_path2_T_H_OP300	60	80	{}	increasing	A0-P2	X3	13	4	48
6802	PulseCoderTemp_2_path2_T_H_OP300	60	80	{}	increasing	A2-P2	Z3	13	4	48
6803	PulseCoderTemp_3_path2_T_H_OP300	60	80	{}	increasing	A3-P2	B0	13	4	48
6804	InFan1SrvAmpSpeed_2_path2_T_H_OP300	9500	9000	{}	decreasing	A2-P2	Z3	2	8	48
6805	InFan1SrvAmpSpeed_0_path2_T_H_OP300	9500	9000	{}	decreasing	A0-P2	X3	2	8	48
6806	InFan1SrvAmpSpeed_1_path2_T_H_OP300	9500	9000	{}	decreasing	A1-P2	Y3	2	8	48
6807	InFan1SrvAmpSpeed_4_path2_T_H_OP300	9500	9000	{}	decreasing	A4-P2	A0	2	8	48
6808	InFan1SrvAmpSpeed_3_path2_T_H_OP300	9500	9000	{}	decreasing	A3-P2	B0	2	8	48
6809	InFan2SrvComPwSpeed_0_path2_T_H_OP50	5000	4500	{}	decreasing	A0-P2	XF	2	12	49
6810	InFan2SrvComPwSpeed_1_path2_T_H_OP50	5000	4500	{}	decreasing	A1-P2	CSS	2	12	49
6811	InFan2SrvComPwSpeed_2_path2_T_H_OP50	5000	4500	{}	decreasing	A2-P2	CSR	2	12	49
6812	RadFan2SrvAmpSpeed_2_path2_T_H_OP50	5000	4500	{}	decreasing	A2-P2	CSR	2	16	49
6813	RadFan2SrvAmpSpeed_1_path2_T_H_OP50	5000	4500	{}	decreasing	A1-P2	CSS	2	16	49
6814	RadFan2SrvAmpSpeed_0_path2_T_H_OP50	5000	4500	{}	decreasing	A0-P2	XF	2	16	49
6815	InFan1SrvComPwSpeed_2_path2_T_H_OP50	6200	6000	{}	decreasing	A2-P2	CSR	2	9	49
6816	InFan1SrvComPwSpeed_0_path2_T_H_OP50	6200	6000	{}	decreasing	A0-P2	XF	2	9	49
6817	InFan1SrvComPwSpeed_1_path2_T_H_OP50	6200	6000	{}	decreasing	A1-P2	CSS	2	9	49
6818	ServoLeakResistData_0_path2_T_H_OP50	50	30	{}	decreasing	A0-P2	XF	15	5	49
6819	ServoLeakResistData_1_path2_T_H_OP50	50	30	{}	decreasing	A1-P2	CSS	15	5	49
6820	ServoLeakResistData_2_path2_T_H_OP50	50	30	{}	decreasing	A2-P2	CSR	15	5	49
6821	ApcBatLow_2_path2_T_H_OP50	NaN	NaN	{}	bool	A2-P2	CSR	6	1	49
6822	ApcBatLow_1_path2_T_H_OP50	NaN	NaN	{}	bool	A1-P2	CSS	6	1	49
6823	ApcBatLow_0_path2_T_H_OP50	NaN	NaN	{}	bool	A0-P2	XF	6	1	49
6824	CncBatLow_0_path2_T_H_OP50	NaN	NaN	{}	bool	A0-P2	XF	6	2	49
6825	CncBatLow_2_path2_T_H_OP50	NaN	NaN	{}	bool	A2-P2	CSR	6	2	49
6826	CncBatLow_1_path2_T_H_OP50	NaN	NaN	{}	bool	A1-P2	CSS	6	2	49
6827	InFan2SrvAmpSpeed_2_path2_T_H_OP50	5000	4500	{}	decreasing	A2-P2	CSR	2	11	49
6828	InFan2SrvAmpSpeed_0_path2_T_H_OP50	5000	4500	{}	decreasing	A0-P2	XF	2	11	49
6829	InFan2SrvAmpSpeed_1_path2_T_H_OP50	5000	4500	{}	decreasing	A1-P2	CSS	2	11	49
6830	SpdBatZero_0_path2_T_H_OP50	NaN	NaN	{}	bool	A0-P2	XF	6	13	49
6831	SpdBatZero_2_path2_T_H_OP50	NaN	NaN	{}	bool	A2-P2	CSR	6	13	49
6832	SpdBatZero_1_path2_T_H_OP50	NaN	NaN	{}	bool	A1-P2	CSS	6	13	49
6833	SSpdBatZero_1_path2_T_H_OP50	NaN	NaN	{}	bool	A1-P2	CSS	6	14	49
6834	SSpdBatZero_2_path2_T_H_OP50	NaN	NaN	{}	bool	A2-P2	CSR	6	14	49
6835	SSpdBatZero_0_path2_T_H_OP50	NaN	NaN	{}	bool	A0-P2	XF	6	14	49
6836	ServoLoad_0_path2_T_H_OP50	NaN	NaN	{}	increasing	A0-P2	XF	17	17	49
6837	ServoLoad_1_path2_T_H_OP50	NaN	NaN	{}	increasing	A1-P2	CSS	17	17	49
6838	ServoLoad_2_path2_T_H_OP50	NaN	NaN	{}	increasing	A2-P2	CSR	17	17	49
6839	RadFan1SrvAmpSpeed_1_path2_T_H_OP50	5000	4500	{}	decreasing	A1-P2	CSS	2	15	49
6840	RadFan1SrvAmpSpeed_0_path2_T_H_OP50	5000	4500	{}	decreasing	A0-P2	XF	2	15	49
6841	RadFan1SrvAmpSpeed_2_path2_T_H_OP50	5000	4500	{}	decreasing	A2-P2	CSR	2	15	49
6842	ServoTemp_0_path2_T_H_OP50	55	70	{}	increasing	A0-P2	XF	13	3	49
6843	ServoTemp_2_path2_T_H_OP50	55	70	{}	increasing	A2-P2	CSR	13	3	49
6844	ServoTemp_1_path2_T_H_OP50	55	70	{}	increasing	A1-P2	CSS	13	3	49
6845	CncFan1Speed_path2_T_H_OP50	4500	4000	{}	decreasing	A1-P2	F2	16	6	49
6846	CncFan2Speed_path2_T_H_OP50	4500	4000	{}	decreasing	A2-P2	F4	16	6	49
6847	PulseCoderTemp_0_path2_T_H_OP50	60	80	{}	increasing	A0-P2	XF	13	4	49
6848	PulseCoderTemp_2_path2_T_H_OP50	60	80	{}	increasing	A2-P2	CSR	13	4	49
6849	PulseCoderTemp_1_path2_T_H_OP50	60	80	{}	increasing	A1-P2	CSS	13	4	49
6850	InFan1SrvAmpSpeed_1_path2_T_H_OP50	9500	9000	{}	decreasing	A1-P2	CSS	2	8	49
6851	InFan1SrvAmpSpeed_2_path2_T_H_OP50	9500	9000	{}	decreasing	A2-P2	CSR	2	8	49
6852	InFan1SrvAmpSpeed_0_path2_T_H_OP50	9500	9000	{}	decreasing	A0-P2	XF	2	8	49
6853	InFan2SrvComPwSpeed_0_path2_T_H_OP55	5000	4500	{}	decreasing	A0-P2	XF	2	12	55
6854	InFan2SrvComPwSpeed_1_path2_T_H_OP55	5000	4500	{}	decreasing	A1-P2	CSS	2	12	55
6855	InFan2SrvComPwSpeed_2_path2_T_H_OP55	5000	4500	{}	decreasing	A2-P2	CSR	2	12	55
6856	RadFan2SrvAmpSpeed_1_path2_T_H_OP55	5000	4500	{}	decreasing	A1-P2	CSS	2	16	55
6857	RadFan2SrvAmpSpeed_0_path2_T_H_OP55	5000	4500	{}	decreasing	A0-P2	XF	2	16	55
6858	RadFan2SrvAmpSpeed_2_path2_T_H_OP55	5000	4500	{}	decreasing	A2-P2	CSR	2	16	55
6859	InFan1SrvComPwSpeed_0_path2_T_H_OP55	6200	6000	{}	decreasing	A0-P2	XF	2	9	55
6860	InFan1SrvComPwSpeed_2_path2_T_H_OP55	6200	6000	{}	decreasing	A2-P2	CSR	2	9	55
6861	InFan1SrvComPwSpeed_1_path2_T_H_OP55	6200	6000	{}	decreasing	A1-P2	CSS	2	9	55
6862	ServoLeakResistData_2_path2_T_H_OP55	50	30	{}	decreasing	A2-P2	CSR	15	5	55
6863	ServoLeakResistData_1_path2_T_H_OP55	50	30	{}	decreasing	A1-P2	CSS	15	5	55
6864	ServoLeakResistData_0_path2_T_H_OP55	50	30	{}	decreasing	A0-P2	XF	15	5	55
6865	ApcBatLow_0_path2_T_H_OP55	NaN	NaN	{}	bool	A0-P2	XF	6	1	55
6866	ApcBatLow_2_path2_T_H_OP55	NaN	NaN	{}	bool	A2-P2	CSR	6	1	55
6867	ApcBatLow_1_path2_T_H_OP55	NaN	NaN	{}	bool	A1-P2	CSS	6	1	55
6868	CncBatLow_2_path2_T_H_OP55	NaN	NaN	{}	bool	A2-P2	CSR	6	2	55
6869	CncBatLow_1_path2_T_H_OP55	NaN	NaN	{}	bool	A1-P2	CSS	6	2	55
6870	CncBatLow_0_path2_T_H_OP55	NaN	NaN	{}	bool	A0-P2	XF	6	2	55
6871	InFan2SrvAmpSpeed_2_path2_T_H_OP55	5000	4500	{}	decreasing	A2-P2	CSR	2	11	55
6872	InFan2SrvAmpSpeed_1_path2_T_H_OP55	5000	4500	{}	decreasing	A1-P2	CSS	2	11	55
6873	InFan2SrvAmpSpeed_0_path2_T_H_OP55	5000	4500	{}	decreasing	A0-P2	XF	2	11	55
6874	SpdBatZero_2_path2_T_H_OP55	NaN	NaN	{}	bool	A2-P2	CSR	6	13	55
6875	SpdBatZero_0_path2_T_H_OP55	NaN	NaN	{}	bool	A0-P2	XF	6	13	55
6876	SpdBatZero_1_path2_T_H_OP55	NaN	NaN	{}	bool	A1-P2	CSS	6	13	55
6877	SSpdBatZero_2_path2_T_H_OP55	NaN	NaN	{}	bool	A2-P2	CSR	6	14	55
6878	SSpdBatZero_0_path2_T_H_OP55	NaN	NaN	{}	bool	A0-P2	XF	6	14	55
6879	SSpdBatZero_1_path2_T_H_OP55	NaN	NaN	{}	bool	A1-P2	CSS	6	14	55
6880	ServoLoad_2_path2_T_H_OP55	NaN	NaN	{}	increasing	A2-P2	CSR	17	17	55
6881	ServoLoad_1_path2_T_H_OP55	NaN	NaN	{}	increasing	A1-P2	CSS	17	17	55
6882	ServoLoad_0_path2_T_H_OP55	NaN	NaN	{}	increasing	A0-P2	XF	17	17	55
6883	RadFan1SrvAmpSpeed_1_path2_T_H_OP55	5000	4500	{}	decreasing	A1-P2	CSS	2	15	55
6884	RadFan1SrvAmpSpeed_0_path2_T_H_OP55	5000	4500	{}	decreasing	A0-P2	XF	2	15	55
6885	RadFan1SrvAmpSpeed_2_path2_T_H_OP55	5000	4500	{}	decreasing	A2-P2	CSR	2	15	55
6886	ServoTemp_0_path2_T_H_OP55	55	70	{}	increasing	A0-P2	XF	13	3	55
6887	ServoTemp_1_path2_T_H_OP55	55	70	{}	increasing	A1-P2	CSS	13	3	55
6888	ServoTemp_2_path2_T_H_OP55	55	70	{}	increasing	A2-P2	CSR	13	3	55
6889	CncFan1Speed_path2_T_H_OP55	4500	4000	{}	decreasing	A1-P2	F2	16	6	55
6890	CncFan2Speed_path2_T_H_OP55	4500	4000	{}	decreasing	A2-P2	F4	16	6	55
6891	PulseCoderTemp_2_path2_T_H_OP55	60	80	{}	increasing	A2-P2	CSR	13	4	55
6892	PulseCoderTemp_0_path2_T_H_OP55	60	80	{}	increasing	A0-P2	XF	13	4	55
6893	PulseCoderTemp_1_path2_T_H_OP55	60	80	{}	increasing	A1-P2	CSS	13	4	55
6894	InFan1SrvAmpSpeed_2_path2_T_H_OP55	9500	9000	{}	decreasing	A2-P2	CSR	2	8	55
6895	InFan1SrvAmpSpeed_0_path2_T_H_OP55	9500	9000	{}	decreasing	A0-P2	XF	2	8	55
6896	InFan1SrvAmpSpeed_1_path2_T_H_OP55	9500	9000	{}	decreasing	A1-P2	CSS	2	8	55
6897	InFan2SrvComPwSpeed_1_path2_T_H_OP550	5000	4500	{}	decreasing	A1-P2	Y3	2	12	56
6898	InFan2SrvComPwSpeed_2_path1_T_H_OP550	5000	4500	{}	decreasing	A2-P1	Y2	2	12	56
6899	InFan2SrvComPwSpeed_0_path2_T_H_OP550	5000	4500	{}	decreasing	A0-P2	X2	2	12	56
6900	RadFan2SrvAmpSpeed_1_path2_T_H_OP550	5000	4500	{}	decreasing	A1-P2	Y3	2	16	56
6901	RadFan2SrvAmpSpeed_0_path2_T_H_OP550	5000	4500	{}	decreasing	A0-P2	X2	2	16	56
6902	InFan1SrvComPwSpeed_1_path2_T_H_OP550	6200	6000	{}	decreasing	A1-P2	Y3	2	9	56
6903	InFan1SrvComPwSpeed_0_path2_T_H_OP550	6200	6000	{}	decreasing	A0-P2	X2	2	9	56
6904	InFan1SrvComPwSpeed_2_path1_T_H_OP550	6200	6000	{}	decreasing	A2-P1	Y2	2	9	56
6905	ServoLeakResistData_0_path2_T_H_OP550	50	30	{}	decreasing	A0-P2	X2	15	5	56
6906	ServoLeakResistData_1_path2_T_H_OP550	50	30	{}	decreasing	A1-P2	Y3	15	5	56
6907	ApcBatLow_0_path2_T_H_OP550	NaN	NaN	{}	bool	A0-P1	X2	6	1	56
6908	ApcBatLow_1_path2_T_H_OP550	NaN	NaN	{}	bool	A1-P2	Y3	6	1	56
6909	CncBatLow_1_path2_T_H_OP550	NaN	NaN	{}	bool	A1-P2	Y3	6	2	56
6910	CncBatLow_0_path2_T_H_OP550	NaN	NaN	{}	bool	A0-P2	X2	6	2	56
6911	InFan2SrvAmpSpeed_1_path2_T_H_OP550	5000	4500	{}	decreasing	A1-P2	Y3	2	11	56
6912	InFan2SrvAmpSpeed_0_path2_T_H_OP550	5000	4500	{}	decreasing	A0-P2	X2	2	11	56
6913	SpdBatZero_0_path2_T_H_OP550	NaN	NaN	{}	bool	A0-P2	X2	6	13	56
6914	SpdBatZero_1_path2_T_H_OP550	NaN	NaN	{}	bool	A1-P2	Y3	6	13	56
6915	SSpdBatZero_0_path2_T_H_OP550	NaN	NaN	{}	bool	A0-P2	X2	6	14	56
6916	SSpdBatZero_1_path2_T_H_OP550	NaN	NaN	{}	bool	A1-P2	Y3	6	14	56
6917	ServoLoad_1_path2_T_H_OP550	NaN	NaN	{}	increasing	A1-P2	Y3	17	17	56
6918	ServoLoad_0_path2_T_H_OP550	NaN	NaN	{}	increasing	A0-P2	X2	17	17	56
6919	RadFan1SrvAmpSpeed_0_path2_T_H_OP550	5000	4500	{}	decreasing	A0-P2	X2	2	15	56
6920	RadFan1SrvAmpSpeed_1_path2_T_H_OP550	5000	4500	{}	decreasing	A1-P2	Y3	2	15	56
6921	ServoTemp_0_path2_T_H_OP550	85	90	{}	increasing	A0-P2	X2	13	3	56
6922	ServoTemp_1_path2_T_H_OP550	85	90	{}	increasing	A1-P2	Y3	13	3	56
6923	CncFan2Speed_path2_T_H_OP550	4500	4000	{}	decreasing	A2-P2	F4	16	6	56
6924	CncFan1Speed_path2_T_H_OP550	4500	4000	{}	decreasing	A1-P2	F2	16	6	56
6925	PulseCoderTemp_0_path2_T_H_OP550	85	90	{}	increasing	A0-P2	X2	13	4	56
6926	PulseCoderTemp_1_path2_T_H_OP550	85	90	{}	increasing	A1-P2	Y3	13	4	56
6927	InFan1SrvAmpSpeed_0_path2_T_H_OP550	9500	9000	{}	decreasing	A0-P2	X2	2	8	56
6928	InFan1SrvAmpSpeed_1_path2_T_H_OP550	7500	7000	{}	decreasing	A1-P2	Y3	2	8	56
6929	InFan2SrvComPwSpeed_0_path2_T_H_OP80A	5000	4500	{}	decreasing	A0-P2	WTC	2	12	57
6930	RadFan2SrvAmpSpeed_0_path2_T_H_OP80A	5000	4500	{}	decreasing	A0-P2	WTC	2	16	57
6931	InFan1SrvComPwSpeed_0_path2_T_H_OP80A	6200	6000	{}	decreasing	A0-P2	WTC	2	9	57
6932	ServoLeakResistData_0_path2_T_H_OP80A	50	30	{}	decreasing	A0-P2	WTC	15	5	57
6933	ApcBatLow_0_path2_T_H_OP80A	NaN	NaN	{}	bool	A0-P2	WTC	6	1	57
6934	CncBatLow_0_path2_T_H_OP80A	NaN	NaN	{}	bool	A0-P2	WTC	6	2	57
6935	InFan2SrvAmpSpeed_0_path2_T_H_OP80A	5000	4500	{}	decreasing	A0-P2	WTC	2	11	57
6936	SpdBatZero_0_path2_T_H_OP80A	NaN	NaN	{}	bool	A0-P2	WTC	6	13	57
6937	SSpdBatZero_0_path2_T_H_OP80A	NaN	NaN	{}	bool	A0-P2	WTC	6	14	57
6938	ServoLoad_0_path2_T_H_OP80A	NaN	NaN	{}	increasing	A0-P2	WTC	17	17	57
6939	RadFan1SrvAmpSpeed_0_path2_T_H_OP80A	5000	4500	{}	decreasing	A0-P2	WTC	2	15	57
6940	ServoTemp_0_path2_T_H_OP80A	55	70	{}	increasing	A0-P2	WTC	13	3	57
6941	PulseCoderTemp_0_path2_T_H_OP80A	60	80	{}	increasing	A0-P2	WTC	13	4	57
6942	InFan1SrvAmpSpeed_0_path2_T_H_OP80A	7500	7000	{}	decreasing	A0-P2	WTC	2	8	57
6943	InFan2SrvComPwSpeed_0_path2_T_H_OP80B	5000	4500	{}	decreasing	A0-P2	WTC	2	12	58
6944	RadFan2SrvAmpSpeed_0_path2_T_H_OP80B	5000	4500	{}	decreasing	A0-P2	WTC	2	16	58
6945	InFan1SrvComPwSpeed_0_path2_T_H_OP80B	6200	6000	{}	decreasing	A0-P2	WTC	2	9	58
6946	ServoLeakResistData_0_path2_T_H_OP80B	50	30	{}	decreasing	A0-P2	WTC	15	5	58
6947	ApcBatLow_0_path2_T_H_OP80B	NaN	NaN	{}	bool	A0-P2	WTC	6	1	58
6948	CncBatLow_0_path2_T_H_OP80B	NaN	NaN	{}	bool	A0-P2	WTC	6	2	58
6949	InFan2SrvAmpSpeed_0_path2_T_H_OP80B	5000	4500	{}	decreasing	A0-P2	WTC	2	11	58
6950	SpdBatZero_0_path2_T_H_OP80B	NaN	NaN	{}	bool	A0-P2	WTC	6	13	58
6951	SSpdBatZero_0_path2_T_H_OP80B	NaN	NaN	{}	bool	A0-P2	WTC	6	14	58
6952	ServoLoad_0_path2_T_H_OP80B	NaN	NaN	{}	increasing	A0-P2	WTC	17	17	58
6953	RadFan1SrvAmpSpeed_0_path2_T_H_OP80B	5000	4500	{}	decreasing	A0-P2	WTC	2	15	58
6954	ServoTemp_0_path2_T_H_OP80B	55	70	{}	increasing	A0-P2	WTC	13	3	58
6955	CncFan2Speed_path2_T_H_OP80B	4500	4000	{}	decreasing	A2-P2	F4	16	6	58
6956	CncFan1Speed_path2_T_H_OP80B	4500	4000	{}	decreasing	A1-P2	F2	16	6	58
6957	PulseCoderTemp_0_path2_T_H_OP80B	60	80	{}	increasing	A0-P2	WTC	13	4	58
6958	InFan1SrvAmpSpeed_0_path2_T_H_OP80B	7500	7000	{}	decreasing	A0-P2	WTC	2	8	58
6959	InFan2SrvComPwSpeed_0_path2_T_H_OP90A	5000	4500	{}	decreasing	A0-P2	WTC	2	12	59
6960	RadFan2SrvAmpSpeed_0_path2_T_H_OP90A	5000	4500	{}	decreasing	A0-P2	WTC	2	16	59
6961	InFan1SrvComPwSpeed_0_path2_T_H_OP90A	6200	6000	{}	decreasing	A0-P2	WTC	2	9	59
6962	ServoLeakResistData_0_path2_T_H_OP90A	50	30	{}	decreasing	A0-P2	WTC	15	5	59
6963	ApcBatLow_0_path2_T_H_OP90A	NaN	NaN	{}	bool	A0-P2	WTC	6	1	59
6964	CncBatLow_0_path2_T_H_OP90A	NaN	NaN	{}	bool	A0-P2	WTC	6	2	59
6965	InFan2SrvAmpSpeed_0_path2_T_H_OP90A	5000	4500	{}	decreasing	A0-P2	WTC	2	11	59
6966	SpdBatZero_0_path2_T_H_OP90A	NaN	NaN	{}	bool	A0-P2	WTC	6	13	59
6967	SSpdBatZero_0_path2_T_H_OP90A	NaN	NaN	{}	bool	A0-P2	WTC	6	14	59
6968	ServoLoad_0_path2_T_H_OP90A	NaN	NaN	{}	increasing	A0-P2	WTC	17	17	59
6969	RadFan1SrvAmpSpeed_0_path2_T_H_OP90A	5000	4500	{}	decreasing	A0-P2	WTC	2	15	59
6970	ServoTemp_0_path2_T_H_OP90A	55	70	{}	increasing	A0-P2	WTC	13	3	59
6971	CncFan1Speed_path2_T_H_OP90A	4500	4000	{}	decreasing	A1-P2	F2	16	6	59
6972	CncFan2Speed_path2_T_H_OP90A	4500	4000	{}	decreasing	A2-P2	F4	16	6	59
6973	PulseCoderTemp_0_path2_T_H_OP90A	60	80	{}	increasing	A0-P2	WTC	13	4	59
6974	InFan1SrvAmpSpeed_0_path2_T_H_OP90A	7500	7000	{}	decreasing	A0-P2	WTC	2	8	59
6975	InFan2SrvComPwSpeed_0_path2_T_H_OP90B	5000	4500	{}	decreasing	A0-P2	WTC	2	12	60
6976	RadFan2SrvAmpSpeed_0_path2_T_H_OP90B	5000	4500	{}	decreasing	A0-P2	WTC	2	16	60
6977	InFan1SrvComPwSpeed_0_path2_T_H_OP90B	6200	6000	{}	decreasing	A0-P2	WTC	2	9	60
6978	ServoLeakResistData_0_path2_T_H_OP90B	50	30	{}	decreasing	A0-P2	WTC	15	5	60
6979	ApcBatLow_0_path2_T_H_OP90B	NaN	NaN	{}	bool	A0-P2	WTC	6	1	60
6980	CncBatLow_0_path2_T_H_OP90B	NaN	NaN	{}	bool	A0-P2	WTC	6	2	60
6981	InFan2SrvAmpSpeed_0_path2_T_H_OP90B	5000	4500	{}	decreasing	A0-P2	WTC	2	11	60
6982	SpdBatZero_0_path2_T_H_OP90B	NaN	NaN	{}	bool	A0-P2	WTC	6	13	60
6983	SSpdBatZero_0_path2_T_H_OP90B	NaN	NaN	{}	bool	A0-P2	WTC	6	14	60
6984	ServoLoad_0_path2_T_H_OP90B	NaN	NaN	{}	increasing	A0-P2	WTC	17	17	60
6985	RadFan1SrvAmpSpeed_0_path2_T_H_OP90B	5000	4500	{}	decreasing	A0-P2	WTC	2	15	60
6986	ServoTemp_0_path2_T_H_OP90B	55	70	{}	increasing	A0-P2	WTC	13	3	60
6987	CncFan2Speed_path2_T_H_OP90B	4500	4000	{}	decreasing	A2-P2	F4	16	6	60
6988	CncFan1Speed_path2_T_H_OP90B	4500	4000	{}	decreasing	A1-P2	F2	16	6	60
6989	PulseCoderTemp_0_path2_T_H_OP90B	60	80	{}	increasing	A0-P2	WTC	13	4	60
6990	InFan1SrvAmpSpeed_0_path2_T_H_OP90B	7500	7000	{}	decreasing	A0-P2	WTC	2	8	60
6991	CncFan1Speed_path2_T_H_OP100A	4500	4000	{}	decreasing	A1-P2	F1	16	6	24
6992	CncFan2Speed_path2_T_H_OP100A	4500	4000	{}	decreasing	A2-P2	F2	16	6	24
476	ServoLeakResistData_1_path1_T_B_OP195B	50	30	{}	decreasing	A1-P1	Y	15	5	5
407	PulseCoderTemp_2_path1_T_B_OP195B	60	65	{}	increasing	A2-P1	Z	13	4	5
605	ServoLeakResistData_5_path1_T_B_OP230	108	30	{}	decreasing	A5-P1	B1	15	5	6
1077	ServoLeakResistData_3_path1_T_C_OP160	70	35	{}	decreasing	A3-P1	W	15	5	11
1244	PulseCoderTemp_2_path1_T_C_OP30	60	80	{}	increasing	A3-P1	A	13	4	13
1255	InFan1SrvAmpSpeed_2_path1_T_C_OP30	8000	7500	{}	decreasing	A3-P1	A	2	8	13
1262	ServoLoad_2_path1_T_C_OP30	NaN	NaN	{}	increasing	A3-P1	A	17	17	13
1270	SpdBatZero_2_path1_T_C_OP30	NaN	NaN	{}	bool	A3-P1	A	6	13	13
1277	SSpdBatZero_2_path1_T_C_OP30	NaN	NaN	{}	bool	A3-P1	A	6	14	13
1285	RadFan2SrvAmpSpeed_2_path1_T_C_OP30	5000	4500	{}	decreasing	A3-P1	A	2	16	13
1292	ApcBatLow_2_path1_T_C_OP30	NaN	NaN	{}	bool	A3-P1	A	6	1	13
1299	CncBatLow_2_path1_T_C_OP30	NaN	NaN	{}	bool	A3-P1	A	6	2	13
1245	PulseCoderTemp_3_path1_T_C_OP30	60	80	{}	increasing	A2-P1	W	13	4	13
1256	InFan1SrvAmpSpeed_3_path1_T_C_OP30	8500	8000	{}	decreasing	A2-P1	W	2	8	13
1263	ServoLoad_3_path1_T_C_OP30	NaN	NaN	{}	increasing	A2-P1	W	17	17	13
1271	SpdBatZero_3_path1_T_C_OP30	NaN	NaN	{}	bool	A2-P1	W	6	13	13
1278	SSpdBatZero_3_path1_T_C_OP30	NaN	NaN	{}	bool	A2-P1	W	6	14	13
1286	RadFan2SrvAmpSpeed_3_path1_T_C_OP30	5000	4500	{}	decreasing	A2-P1	W	2	16	13
1293	ApcBatLow_3_path1_T_C_OP30	NaN	NaN	{}	bool	A2-P1	W	6	1	13
1300	CncBatLow_3_path1_T_C_OP30	NaN	NaN	{}	bool	A2-P1	W	6	2	13
1307	ServoLeakResistData_3_path1_T_C_OP30	50	30	{}	decreasing	A2-P1	W	15	5	13
1315	InFan1SrvComPwSpeed_3_path1_T_C_OP30	6200	6000	{}	decreasing	A2-P1	W	2	9	13
1322	InFan2SrvAmpSpeed_3_path1_T_C_OP30	5000	4500	{}	decreasing	A2-P1	W	2	11	13
1330	RadFan1SrvAmpSpeed_3_path1_T_C_OP30	5000	4500	{}	decreasing	A2-P1	W	2	15	13
1339	InFan2SrvComPwSpeed_3_path1_T_C_OP30	5000	4500	{}	decreasing	A2-P1	W	2	12	13
1348	ServoTemp_3_path1_T_C_OP30	55	70	{}	increasing	A2-P1	W	13	3	13
1306	ServoLeakResistData_2_path1_T_C_OP30	50	30	{}	decreasing	A3-P1	A	15	5	13
1314	InFan1SrvComPwSpeed_2_path1_T_C_OP30	6200	6000	{}	decreasing	A3-P1	A	2	9	13
1321	InFan2SrvAmpSpeed_2_path1_T_C_OP30	5000	4500	{}	decreasing	A3-P1	A	2	11	13
1329	RadFan1SrvAmpSpeed_2_path1_T_C_OP30	5000	4500	{}	decreasing	A3-P1	A	2	15	13
1338	InFan2SrvComPwSpeed_2_path1_T_C_OP30	5000	4500	{}	decreasing	A3-P1	A	2	12	13
1347	ServoTemp_2_path1_T_C_OP30	55	70	{}	increasing	A3-P1	A	13	3	13
353	ServoLeakResistData_3_path1_T_B_OP195A	555	30	{}	decreasing	A3-P1	BA5	15	5	4
4405	ServoLeakResistData_7_path1_T_H_OP240	50	30	{}	decreasing	A7-P1	A2	15	5	42
649	ServoTemp_3_path1_T_B_OP230	45	46	{}	increasing	A3-P1	Z1	13	3	6
\.


--
-- TOC entry 3656 (class 0 OID 16844)
-- Dependencies: 234
-- Data for Name: machine_production_timeline; Type: TABLE DATA; Schema: tiei_sample_5; Owner: postgres
--

COPY tiei_sample_5.machine_production_timeline (id, start_time, end_time, part_number, duration, machine_id, machine_event_timeline_id) FROM stdin;
\.


--
-- TOC entry 3658 (class 0 OID 16848)
-- Dependencies: 236
-- Data for Name: machinepartcount; Type: TABLE DATA; Schema: tiei_sample_5; Owner: postgres
--

COPY tiei_sample_5.machinepartcount (id, part_signal_name, current_part_count, last_reset_count, latest_update_time, machine_id) FROM stdin;
\.


--
-- TOC entry 3660 (class 0 OID 16854)
-- Dependencies: 238
-- Data for Name: machines; Type: TABLE DATA; Schema: tiei_sample_5; Owner: postgres
--

COPY tiei_sample_5.machines (id, name, location, machine_number, short_name, description, enabled, parameters) FROM stdin;
1	Laser Cladding A	Head Line	TIZZ303	Laser Clad	In the laser cladding process, \n\t\t\t\t\t\t\t\t\t\t\t\t\ta thin layer of a material is deposited on a moving substrate \n\t\t\t\t\t\t\t\t\t\t\t\t\tusing a laser (as a heat source) and powder injection or wire \n\t\t\t\t\t\t\t\t\t\t\t\t\tfeeding (as source material for thin film).	t	29
2	T_B_OP160	BLOCK	\N	\N	\N	t	382
3	T_B_OP180	BLOCK	\N	\N	\N	t	382
4	T_B_OP195A	BLOCK	\N	\N	\N	t	382
5	T_B_OP195B	BLOCK	\N	\N	\N	t	382
6	T_B_OP230	BLOCK	\N	\N	\N	t	382
7	T_B_OP235	BLOCK	\N	\N	\N	t	382
8	T_B_OP540	BLOCK	\N	\N	\N	t	225
9	T_C_OP10	CRANK	\N	\N	\N	t	280
10	T_C_OP100	CRANK	\N	\N	\N	t	280
11	T_C_OP160	CRANK	\N	\N	\N	t	314
12	T_C_OP190	CRANK	\N	\N	\N	t	382
13	T_C_OP30	CRANK	\N	\N	\N	t	348
14	T_C_OP40	CRANK	\N	\N	\N	t	314
15	T_C_OP90	CRANK	\N	\N	\N	t	280
16	T_C_OP910	CRANK	\N	\N	\N	t	191
17	T_C_OP911	CRANK	\N	\N	\N	t	191
18	T_C_OP912	CRANK	\N	\N	\N	t	191
19	T_C_OP913	CRANK	\N	\N	\N	t	191
20	T_C_OP914	CRANK	\N	\N	\N	t	191
21	T_C_OP915	CRANK	\N	\N	\N	t	191
22	T_C_OP916	CRANK	\N	\N	\N	t	191
23	T_H_OP10	HEAD	\N	\N	\N	t	533
24	T_H_OP100A	HEAD	\N	\N	\N	t	533
25	T_H_OP100B	HEAD	\N	\N	\N	t	533
26	T_H_OP110A	HEAD	\N	\N	\N	t	532
27	T_H_OP110B	HEAD	\N	\N	\N	t	533
28	T_H_OP120A	HEAD	\N	\N	\N	t	533
29	T_H_OP120B	HEAD	\N	\N	\N	t	533
30	T_H_OP140A	HEAD	\N	\N	\N	t	533
31	T_H_OP140B	HEAD	\N	\N	\N	t	533
32	T_H_OP150A	HEAD	\N	\N	\N	t	533
33	T_H_OP150B	HEAD	\N	\N	\N	t	533
34	T_H_OP160A	HEAD	\N	\N	\N	t	534
35	T_H_OP160B	HEAD	\N	\N	\N	t	533
36	T_H_OP170A	HEAD	\N	\N	\N	t	533
37	T_H_OP170B	HEAD	\N	\N	\N	t	533
38	T_H_OP180A	HEAD	\N	\N	\N	t	533
39	T_H_OP180B	HEAD	\N	\N	\N	t	533
40	T_H_OP20	HEAD	\N	\N	\N	t	382
41	T_H_OP230	HEAD	\N	\N	\N	t	528
42	T_H_OP240	HEAD	\N	\N	\N	t	528
43	T_H_OP250	HEAD	\N	\N	\N	t	533
44	T_H_OP260	HEAD	\N	\N	\N	t	533
45	T_H_OP270	HEAD	\N	\N	\N	t	507
46	T_H_OP280	HEAD	\N	\N	\N	t	533
47	T_H_OP285	HEAD	\N	\N	\N	t	233
48	T_H_OP300	HEAD	\N	\N	\N	t	384
49	T_H_OP50	HEAD	\N	\N	\N	t	465
50	T_H_OP500	HEAD	\N	\N	\N	t	340
51	T_H_OP510	HEAD	\N	\N	\N	t	157
52	T_H_OP520	HEAD	\N	\N	\N	t	157
53	T_H_OP530	HEAD	\N	\N	\N	t	157
54	T_H_OP540	HEAD	\N	\N	\N	t	157
55	T_H_OP55	HEAD	\N	\N	\N	t	533
56	T_H_OP550	HEAD	\N	\N	\N	t	361
57	T_H_OP80A	HEAD	\N	\N	\N	t	533
58	T_H_OP80B	HEAD	\N	\N	\N	t	533
59	T_H_OP90A	HEAD	\N	\N	\N	t	382
60	T_H_OP90B	HEAD	\N	\N	\N	t	533
61	JOURNAL FINISH-GRINDING_JOP_105	CRANK	\N	\N	Special Purpose machine, journal finish grinder	t	14
62	JOURNAL FINISH-GRINDING_JOP_130	CRANK	\N	\N	Special Purpose machine, journal finish grinder for JOP 130	t	14
63	JOURNAL FINISH-GRINDING_JOP_140	CRANK	\N	\N	Special Purpose machine, journal finish grinder for JOP 140	t	14
64	Laser Cladding B	Head Line	TIZZ303	Laser Clad B	In the laser cladding process,a thin layer of a material is deposited on a moving substrate using a laser (as a heat source) and powder injection or wire ing (as source material for thin film).	t	29
\.


--
-- TOC entry 3662 (class 0 OID 16860)
-- Dependencies: 240
-- Data for Name: parameter_comparison; Type: TABLE DATA; Schema: tiei_sample_5; Owner: postgres
--

COPY tiei_sample_5.parameter_comparison (id, "time", line, machine_id, parameter_group_id, machine_parameter1_id, machine_parameter2_id, warning_limit, critical_limit, time_1, time_2, value_1, value_2, difference, condition_id) FROM stdin;
13	2024-10-15 11:19:48.076084	CRANK	10	17	951	952	54444	908	\N	\N	0	0	0	1
12	2024-10-16 10:12:52.566545	HEAD	57	4	6941	5682	506	6000	\N	\N	0	0	0	1
16	2026-01-29 11:05:44.970853	BLOCK	4	17	304	303	800	606	\N	\N	0	0	0	1
14	2026-01-29 11:05:45.838259	CRANK	15	4	1452	1450	255	53555	\N	\N	0	0	0	1
17	2026-04-02 05:51:26.308011	CRANK	13	4	1243	1245	50	60	\N	\N	0	0	0	1
\.


--
-- TOC entry 3664 (class 0 OID 16864)
-- Dependencies: 242
-- Data for Name: parameter_conditions; Type: TABLE DATA; Schema: tiei_sample_5; Owner: postgres
--

COPY tiei_sample_5.parameter_conditions (id, name) FROM stdin;
1	OK
2	WARNING
3	CRITICAL
\.


--
-- TOC entry 3666 (class 0 OID 16868)
-- Dependencies: 244
-- Data for Name: parameters_group; Type: TABLE DATA; Schema: tiei_sample_5; Owner: postgres
--

COPY tiei_sample_5.parameters_group (id, group_name, mongodb_query, latest_update_time, warning_limit, critical_limit, parameter_type) FROM stdin;
1	APC_BATTERY	apcbatlow(?i)	2024-05-31 05:02:00	NaN	NaN	bool
2	CNC_BATTERY	cncbat(?i)	2024-05-31 05:02:00	NaN	NaN	bool
3	SERVO_SPINDLE_MOTOR_TEMPERATURE	\\b[s].*temp(?i)	2024-05-31 05:08:32.5	50	60	increasing
4	ENCODER_TEMPERATURE	pulse(?i)	2024-05-31 05:08:32.5	50	60	increasing
5	SERVO_SPINDLE_INSULATION_RESISTANCE	resis(?i)	2024-05-31 05:06:28	50	30	decreasing
6	CNC_FANS	.*cncfan.speed.*(?i)	2024-05-31 05:08:34.5	5000	4500	decreasing
7	INTERNAL_FAN1_POWER_SUPPLY_SPDN_MOTOR_AMP	infan1sp.*dl.*speed.*(?i)	2024-05-31 05:08:28	5000	4500	decreasing
8	INTERNAL_FAN1_SERVO_AMPLIFIER	infan1srvampspeed.*(?i)	2024-05-31 05:08:28.5	5000	4500	decreasing
9	INTERNAL_FAN1_POWER_SUPPLY_SERVO_MOTOR	infan1srvcompwspeed.*(?i)	2024-05-31 05:02:00	5000	4500	decreasing
10	INTERNAL_FAN2_POWER_SUPPLY_SPDN_MOTOR_AMP	infan2sp.*dl.*speed.*(?i)	2024-05-31 05:08:28	5000	4500	decreasing
11	INTERNAL_FAN2_SERVO_AMPLIFIER	infan2srvampspeed.*(?i)	2024-05-31 05:02:00	5000	4500	decreasing
12	INTERNAL_FAN2_POWER_SUPPLY_SERVO_MOTOR	infan2srvcompwspeed.*(?i)	2024-05-31 05:08:28	5000	4500	decreasing
13	BATTERY_ZERO_SEPERATE_DETECTOR	\\bspdbatzero.*(?i)	2024-05-31 05:02:00	NaN	NaN	bool
14	BATTERY_ZERO_SERIAL_SEPERATE_DETECTOR	\\bsspdbatzero.*(?i)	2024-05-31 05:02:00	NaN	NaN	bool
15	RADIATOR_FAN1_SERVO_SPINDLE_AMPLIFIER	radfan1s.*ampspeed.*(?i)	2024-05-31 05:08:32.5	5000	4500	decreasing
16	RADIATOR_FAN2_SERVO_SPINDLE_AMPLIFIER	radfan2s.*ampspeed.*(?i)	2024-05-31 05:07:27.5	5000	4500	decreasing
17	DYNAMIC_PARAMETERS	load(?i)	2024-05-31 05:07:56.5	NaN	NaN	increasing
\.


--
-- TOC entry 3668 (class 0 OID 16874)
-- Dependencies: 246
-- Data for Name: real_time_machine_parameters; Type: TABLE DATA; Schema: tiei_sample_5; Owner: postgres
--

COPY tiei_sample_5.real_time_machine_parameters ("time", value, condition_id, machine_parameters_id) FROM stdin;
2000-08-28 10:54:09	0	1	6288
2000-08-28 10:54:09	-22000	1	6289
2000-08-28 10:54:09	0	\N	6290
2000-08-28 10:54:09	10	\N	6291
2000-08-28 10:54:09	183	\N	6292
2000-08-28 10:54:09	10	\N	6293
2000-08-28 10:54:09	20	\N	6294
2000-08-28 10:54:09.04	0	1	6288
2000-08-28 10:54:09.04	-22000	1	6289
2000-08-28 10:54:09.04	0	\N	6290
2000-08-28 10:54:09.04	10	\N	6291
2000-08-28 10:54:09.04	183	\N	6292
2000-08-28 10:54:09.04	10	\N	6293
2000-08-28 10:54:09.04	20	\N	6294
2000-08-28 10:54:09.08	0	1	6288
2000-08-28 10:54:09.08	-22000	1	6289
2000-08-28 10:54:09.08	0	\N	6290
2000-08-28 10:54:09.08	10	\N	6291
2000-08-28 10:54:09.08	183	\N	6292
2000-08-28 10:54:09.08	10	\N	6293
2000-08-28 10:54:09.08	20	\N	6294
2000-08-28 10:54:09.12	0	1	6288
2000-08-28 10:54:09.12	-22000	1	6289
2000-08-28 10:54:09.12	0	\N	6290
2000-08-28 10:54:09.12	0	\N	6291
2000-08-28 10:54:09.12	183	\N	6292
2000-08-28 10:54:09.12	10	\N	6293
2000-08-28 10:54:09.12	20	\N	6294
2000-08-28 10:54:09.16	0	1	6288
2000-08-28 10:54:09.16	-22000	1	6289
2000-08-28 10:54:09.16	0	\N	6290
2000-08-28 10:54:09.16	0	\N	6291
2000-08-28 10:54:09.16	183	\N	6292
2000-08-28 10:54:09.16	10	\N	6293
2000-08-28 10:54:09.16	20	\N	6294
2000-08-28 10:54:09.2	0	1	6288
2000-08-28 10:54:09.2	-22000	1	6289
2000-08-28 10:54:09.2	0	\N	6290
2000-08-28 10:54:09.2	0	\N	6291
2000-08-28 10:54:09.2	183	\N	6292
2000-08-28 10:54:09.2	10	\N	6293
2000-08-28 10:54:09.2	20	\N	6294
2000-08-28 10:54:09.24	0	1	6288
2000-08-28 10:54:09.24	-22000	1	6289
2000-08-28 10:54:09.24	0	\N	6290
2000-08-28 10:54:09.24	0	\N	6291
2000-08-28 10:54:09.24	183	\N	6292
2000-08-28 10:54:09.24	10	\N	6293
2000-08-28 10:54:09.24	20	\N	6294
2000-08-28 10:54:09.28	0	1	6288
2000-08-28 10:54:09.28	-22000	1	6289
2000-08-28 10:54:09.28	0	\N	6290
2000-08-28 10:54:09.28	0	\N	6291
2000-08-28 10:54:09.28	183	\N	6292
2000-08-28 10:54:09.28	10	\N	6293
2000-08-28 10:54:09.28	20	\N	6294
2000-08-28 10:54:09.32	0	1	6288
2000-08-28 10:54:09.32	-22000	1	6289
2000-08-28 10:54:09.32	0	\N	6290
2000-08-28 10:54:09.32	0	\N	6291
2000-08-28 10:54:09.32	183	\N	6292
2000-08-28 10:54:09.32	10	\N	6293
2000-08-28 10:54:09.32	20	\N	6294
2000-08-28 10:54:09.36	0	1	6288
2000-08-28 10:54:09.36	-22000	1	6289
2000-08-28 10:54:09.36	0	\N	6290
2000-08-28 10:54:09.36	0	\N	6291
2000-08-28 10:54:09.36	183	\N	6292
2000-08-28 10:54:09.36	10	\N	6293
2000-08-28 10:54:09.36	20	\N	6294
2000-08-28 10:54:09.4	0	1	6288
2000-08-28 10:54:09.4	-22000	1	6289
2000-08-28 10:54:09.4	0	\N	6290
2000-08-28 10:54:09.4	30	\N	6291
2000-08-28 10:54:09.4	183	\N	6292
2000-08-28 10:54:09.4	10	\N	6293
2000-08-28 10:54:09.4	20	\N	6294
2000-08-28 10:54:09.44	0	1	6288
2000-08-28 10:54:09.44	-22000	1	6289
2000-08-28 10:54:09.44	0	\N	6290
2000-08-28 10:54:09.44	0	\N	6291
2000-08-28 10:54:09.44	183	\N	6292
2000-08-28 10:54:09.44	10	\N	6293
2000-08-28 10:54:09.44	20	\N	6294
2000-08-28 10:54:09.48	0	1	6288
2000-08-28 10:54:09.48	-22000	1	6289
2000-08-28 10:54:09.48	0	\N	6290
2000-08-28 10:54:09.48	0	\N	6291
2000-08-28 10:54:09.48	183	\N	6292
2000-08-28 10:54:09.48	10	\N	6293
2000-08-28 10:54:09.48	20	\N	6294
2000-08-28 10:54:09.52	0	1	6288
2000-08-28 10:54:09.52	-22000	1	6289
2000-08-28 10:54:09.52	0	\N	6290
2000-08-28 10:54:09.52	10	\N	6291
2000-08-28 10:54:09.52	183	\N	6292
2000-08-28 10:54:09.52	10	\N	6293
2000-08-28 10:54:09.52	20	\N	6294
2000-08-28 10:54:09.56	0	1	6288
2000-08-28 10:54:09.56	-22000	1	6289
2000-08-28 10:54:09.56	0	\N	6290
2000-08-28 10:54:09.56	0	\N	6291
2000-08-28 10:54:09.56	183	\N	6292
2000-08-28 10:54:09.56	10	\N	6293
2000-08-28 10:54:09.56	20	\N	6294
2000-08-28 10:54:09.6	0	1	6288
2000-08-28 10:54:09.6	-22000	1	6289
2000-08-28 10:54:09.6	0	\N	6290
2000-08-28 10:54:09.6	0	\N	6291
2000-08-28 10:54:09.6	183	\N	6292
2000-08-28 10:54:09.6	10	\N	6293
2000-08-28 10:54:09.6	20	\N	6294
2000-08-28 10:54:09.64	0	1	6288
2000-08-28 10:54:09.64	-22000	1	6289
2000-08-28 10:54:09.64	0	\N	6290
2000-08-28 10:54:09.64	0	\N	6291
2000-08-28 10:54:09.64	183	\N	6292
2000-08-28 10:54:09.64	10	\N	6293
2000-08-28 10:54:09.64	20	\N	6294
2000-08-28 10:54:09.68	0	1	6288
2000-08-28 10:54:09.68	-22000	1	6289
2000-08-28 10:54:09.68	0	\N	6290
2000-08-28 10:54:09.68	0	\N	6291
2000-08-28 10:54:09.68	183	\N	6292
2000-08-28 10:54:09.68	10	\N	6293
2000-08-28 10:54:09.68	20	\N	6294
2000-08-28 10:54:09.72	0	1	6288
2000-08-28 10:54:09.72	-22000	1	6289
2000-08-28 10:54:09.72	0	\N	6290
2000-08-28 10:54:09.72	10	\N	6291
2000-08-28 10:54:09.72	183	\N	6292
2000-08-28 10:54:09.72	10	\N	6293
2000-08-28 10:54:09.72	20	\N	6294
2000-08-28 10:54:09.76	0	1	6288
2000-08-28 10:54:09.76	-22000	1	6289
2000-08-28 10:54:09.76	0	\N	6290
2000-08-28 10:54:09.76	10	\N	6291
2000-08-28 10:54:09.76	183	\N	6292
2000-08-28 10:54:09.76	10	\N	6293
2000-08-28 10:54:09.76	20	\N	6294
2000-08-28 10:54:09.8	0	1	6288
2000-08-28 10:54:09.8	-22000	1	6289
2000-08-28 10:54:09.8	0	\N	6290
2000-08-28 10:54:09.8	0	\N	6291
2000-08-28 10:54:09.8	183	\N	6292
2000-08-28 10:54:09.8	10	\N	6293
2000-08-28 10:54:09.8	20	\N	6294
2000-08-28 10:54:09.84	0	1	6288
2000-08-28 10:54:09.84	-22000	1	6289
2000-08-28 10:54:09.84	0	\N	6290
2000-08-28 10:54:09.84	10	\N	6291
2000-08-28 10:54:09.84	183	\N	6292
2000-08-28 10:54:09.84	10	\N	6293
2000-08-28 10:54:09.84	20	\N	6294
2000-08-28 10:54:09.88	5	1	6288
2000-08-28 10:54:09.88	-22000	1	6289
2000-08-28 10:54:09.88	0	\N	6290
2000-08-28 10:54:09.88	10	\N	6291
2000-08-28 10:54:09.88	183	\N	6292
2000-08-28 10:54:09.88	10	\N	6293
2000-08-28 10:54:09.88	20	\N	6294
2000-08-28 10:54:09.92	5	1	6288
2000-08-28 10:54:09.92	-22000	1	6289
2000-08-28 10:54:09.92	0	\N	6290
2000-08-28 10:54:09.92	10	\N	6291
2000-08-28 10:54:09.92	183	\N	6292
2000-08-28 10:54:09.92	10	\N	6293
2000-08-28 10:54:09.92	20	\N	6294
2000-08-28 10:54:09.96	5	1	6288
2000-08-28 10:54:09.96	-22000	1	6289
2000-08-28 10:54:09.96	0	\N	6290
2000-08-28 10:54:09.96	0	\N	6291
2000-08-28 10:54:09.96	183	\N	6292
2000-08-28 10:54:09.96	10	\N	6293
2000-08-28 10:54:09.96	20	\N	6294
2000-08-28 10:54:10	5	1	6288
2000-08-28 10:54:10	-22000	1	6289
2000-08-28 10:54:10	0	\N	6290
2000-08-28 10:54:10	0	\N	6291
2000-08-28 10:54:10	183	\N	6292
2000-08-28 10:54:10	10	\N	6293
2000-08-28 10:54:10	20	\N	6294
2000-08-28 10:54:10.04	5	1	6288
2000-08-28 10:54:10.04	-22000	1	6289
2000-08-28 10:54:10.04	0	\N	6290
2000-08-28 10:54:10.04	140	\N	6291
2000-08-28 10:54:10.04	183	\N	6292
2000-08-28 10:54:10.04	10	\N	6293
2000-08-28 10:54:10.04	20	\N	6294
2000-08-28 10:54:10.08	5	1	6288
2000-08-28 10:54:10.08	-22000	1	6289
2000-08-28 10:54:10.08	0	\N	6290
2000-08-28 10:54:10.08	270	\N	6291
2000-08-28 10:54:10.08	183	\N	6292
2000-08-28 10:54:10.08	10	\N	6293
2000-08-28 10:54:10.08	20	\N	6294
2000-08-28 10:54:10.12	5	1	6288
2000-08-28 10:54:10.12	-22000	1	6289
2000-08-28 10:54:10.12	0	\N	6290
2000-08-28 10:54:10.12	270	\N	6291
2000-08-28 10:54:10.12	183	\N	6292
2000-08-28 10:54:10.12	10	\N	6293
2000-08-28 10:54:10.12	20	\N	6294
2000-08-28 10:54:10.16	5	1	6288
2000-08-28 10:54:10.16	-22000	1	6289
2000-08-28 10:54:10.16	0	\N	6290
2000-08-28 10:54:10.16	340	\N	6291
2000-08-28 10:54:10.16	183	\N	6292
2000-08-28 10:54:10.16	10	\N	6293
2000-08-28 10:54:10.16	20	\N	6294
2000-08-28 10:54:10.2	5	1	6288
2000-08-28 10:54:10.2	-22000	1	6289
2000-08-28 10:54:10.2	0	\N	6290
2000-08-28 10:54:10.2	410	\N	6291
2000-08-28 10:54:10.2	185	\N	6292
2000-08-28 10:54:10.2	10	\N	6293
2000-08-28 10:54:10.2	20	\N	6294
2000-08-28 10:54:10.24	5	1	6288
2000-08-28 10:54:10.24	-22000	1	6289
2000-08-28 10:54:10.24	0	\N	6290
2000-08-28 10:54:10.24	470	\N	6291
2000-08-28 10:54:10.24	186	\N	6292
2000-08-28 10:54:10.24	10	\N	6293
2000-08-28 10:54:10.24	20	\N	6294
2000-08-28 10:54:10.28	5	1	6288
2000-08-28 10:54:10.28	-22000	1	6289
2000-08-28 10:54:10.28	0	\N	6290
2000-08-28 10:54:10.28	470	\N	6291
2000-08-28 10:54:10.28	186	\N	6292
2000-08-28 10:54:10.28	10	\N	6293
2000-08-28 10:54:10.28	20	\N	6294
2000-08-28 10:54:10.32	5	1	6288
2000-08-28 10:54:10.32	-22000	1	6289
2000-08-28 10:54:10.32	0	\N	6290
2000-08-28 10:54:10.32	540	\N	6291
2000-08-28 10:54:10.32	192	\N	6292
2000-08-28 10:54:10.32	10	\N	6293
2000-08-28 10:54:10.32	20	\N	6294
2000-08-28 10:54:10.36	5	1	6288
2000-08-28 10:54:10.36	-22000	1	6289
2000-08-28 10:54:10.36	0	\N	6290
2000-08-28 10:54:10.36	620	\N	6291
2000-08-28 10:54:10.36	195	\N	6292
2000-08-28 10:54:10.36	10	\N	6293
2000-08-28 10:54:10.36	20	\N	6294
2000-08-28 10:54:10.4	5	1	6288
2000-08-28 10:54:10.4	-22000	1	6289
2000-08-28 10:54:10.4	0	\N	6290
2000-08-28 10:54:10.4	620	\N	6291
2000-08-28 10:54:10.4	195	\N	6292
2000-08-28 10:54:10.4	10	\N	6293
2000-08-28 10:54:10.4	20	\N	6294
2000-08-28 10:54:10.44	5	1	6288
2000-08-28 10:54:10.44	-22000	1	6289
2000-08-28 10:54:10.44	0	\N	6290
2000-08-28 10:54:10.44	670	\N	6291
2000-08-28 10:54:10.44	201	\N	6292
2000-08-28 10:54:10.44	10	\N	6293
2000-08-28 10:54:10.44	20	\N	6294
2000-08-28 10:54:10.48	5	1	6288
2000-08-28 10:54:10.48	-22000	1	6289
2000-08-28 10:54:10.48	0	\N	6290
2000-08-28 10:54:10.48	720	\N	6291
2000-08-28 10:54:10.48	210	\N	6292
2000-08-28 10:54:10.48	10	\N	6293
2000-08-28 10:54:10.48	20	\N	6294
2000-08-28 10:54:10.52	5	1	6288
2000-08-28 10:54:10.52	-22000	1	6289
2000-08-28 10:54:10.52	0	\N	6290
2000-08-28 10:54:10.52	720	\N	6291
2000-08-28 10:54:10.52	210	\N	6292
2000-08-28 10:54:10.52	10	\N	6293
2000-08-28 10:54:10.52	20	\N	6294
2000-08-28 10:54:10.56	5	1	6288
2000-08-28 10:54:10.56	-22000	1	6289
2000-08-28 10:54:10.56	0	\N	6290
2000-08-28 10:54:10.56	760	\N	6291
2000-08-28 10:54:10.56	217	\N	6292
2000-08-28 10:54:10.56	10	\N	6293
2000-08-28 10:54:10.56	20	\N	6294
2000-08-28 10:54:10.6	5	1	6288
2000-08-28 10:54:10.6	-22000	1	6289
2000-08-28 10:54:10.6	0	\N	6290
2000-08-28 10:54:10.6	790	\N	6291
2000-08-28 10:54:10.6	226	\N	6292
2000-08-28 10:54:10.6	10	\N	6293
2000-08-28 10:54:10.6	20	\N	6294
2000-08-28 10:54:10.64	5	1	6288
2000-08-28 10:54:10.64	-22000	1	6289
2000-08-28 10:54:10.64	0	\N	6290
2000-08-28 10:54:10.64	810	\N	6291
2000-08-28 10:54:10.64	238	\N	6292
2000-08-28 10:54:10.64	10	\N	6293
2000-08-28 10:54:10.64	20	\N	6294
2000-08-28 10:54:10.68	5	1	6288
2000-08-28 10:54:10.68	-22000	1	6289
2000-08-28 10:54:10.68	0	\N	6290
2000-08-28 10:54:10.68	810	\N	6291
2000-08-28 10:54:10.68	238	\N	6292
2000-08-28 10:54:10.68	10	\N	6293
2000-08-28 10:54:10.68	20	\N	6294
2000-08-28 10:54:10.72	5	1	6288
2000-08-28 10:54:10.72	-21851	1	6289
2000-08-28 10:54:10.72	0	\N	6290
2000-08-28 10:54:10.72	840	\N	6291
2000-08-28 10:54:10.72	247	\N	6292
2000-08-28 10:54:10.72	10	\N	6293
2000-08-28 10:54:10.72	20	\N	6294
2000-08-28 10:54:10.76	5	1	6288
2000-08-28 10:54:10.76	-21682	1	6289
2000-08-28 10:54:10.76	0	\N	6290
2000-08-28 10:54:10.76	840	\N	6291
2000-08-28 10:54:10.76	256	\N	6292
2000-08-28 10:54:10.76	10	\N	6293
2000-08-28 10:54:10.76	20	\N	6294
2000-08-28 10:54:10.8	5	1	6288
2000-08-28 10:54:10.8	-21344	1	6289
2000-08-28 10:54:10.8	0	\N	6290
2000-08-28 10:54:10.8	840	\N	6291
2000-08-28 10:54:10.8	256	\N	6292
2000-08-28 10:54:10.8	10	\N	6293
2000-08-28 10:54:10.8	20	\N	6294
2000-08-28 10:54:10.84	5	1	6288
2000-08-28 10:54:10.84	-21005	1	6289
2000-08-28 10:54:10.84	0	\N	6290
2000-08-28 10:54:10.84	860	\N	6291
2000-08-28 10:54:10.84	268	\N	6292
2000-08-28 10:54:10.84	10	\N	6293
2000-08-28 10:54:10.84	20	\N	6294
2000-08-28 10:54:10.88	5	1	6288
2000-08-28 10:54:10.88	-20836	1	6289
2000-08-28 10:54:10.88	0	\N	6290
2000-08-28 10:54:10.88	860	\N	6291
2000-08-28 10:54:10.88	280	\N	6292
2000-08-28 10:54:10.88	10	\N	6293
2000-08-28 10:54:10.88	20	\N	6294
2000-08-28 10:54:10.92	5	1	6288
2000-08-28 10:54:10.92	-20498	1	6289
2000-08-28 10:54:10.92	0	\N	6290
2000-08-28 10:54:10.92	860	\N	6291
2000-08-28 10:54:10.92	280	\N	6292
2000-08-28 10:54:10.92	10	\N	6293
2000-08-28 10:54:10.92	20	\N	6294
2000-08-28 10:54:10.96	5	1	6288
2000-08-28 10:54:10.96	-20328	1	6289
2000-08-28 10:54:10.96	108	\N	6290
2000-08-28 10:54:10.96	840	\N	6291
2000-08-28 10:54:10.96	292	\N	6292
2000-08-28 10:54:10.96	10	\N	6293
2000-08-28 10:54:10.96	20	\N	6294
2000-08-28 10:54:11	5	1	6288
2000-08-28 10:54:11	-19990	1	6289
2000-08-28 10:54:11	121	\N	6290
2000-08-28 10:54:11	850	\N	6291
2000-08-28 10:54:11	304	\N	6292
2000-08-28 10:54:11	10	\N	6293
2000-08-28 10:54:11	20	\N	6294
2000-08-28 10:54:11.04	5	1	6288
2000-08-28 10:54:11.04	-19821	1	6289
2000-08-28 10:54:11.04	121	\N	6290
2000-08-28 10:54:11.04	850	\N	6291
2000-08-28 10:54:11.04	304	\N	6292
2000-08-28 10:54:11.04	10	\N	6293
2000-08-28 10:54:11.04	20	\N	6294
2000-08-28 10:54:11.08	5	1	6288
2000-08-28 10:54:11.08	-19482	1	6289
2000-08-28 10:54:11.08	134	\N	6290
2000-08-28 10:54:11.08	870	\N	6291
2000-08-28 10:54:11.08	315	\N	6292
2000-08-28 10:54:11.08	10	\N	6293
2000-08-28 10:54:11.08	20	\N	6294
2000-08-28 10:54:11.12	5	1	6288
2000-08-28 10:54:11.12	-19144	1	6289
2000-08-28 10:54:11.12	147	\N	6290
2000-08-28 10:54:11.12	870	\N	6291
2000-08-28 10:54:11.12	325	\N	6292
2000-08-28 10:54:11.12	10	\N	6293
2000-08-28 10:54:11.12	20	\N	6294
2000-08-28 10:54:11.16	5	1	6288
2000-08-28 10:54:11.16	-18974	1	6289
2000-08-28 10:54:11.16	161	\N	6290
2000-08-28 10:54:11.16	870	\N	6291
2000-08-28 10:54:11.16	334	\N	6292
2000-08-28 10:54:11.16	10	\N	6293
2000-08-28 10:54:11.16	20	\N	6294
2000-08-28 10:54:11.2	5	1	6288
2000-08-28 10:54:11.2	-18636	1	6289
2000-08-28 10:54:11.2	161	\N	6290
2000-08-28 10:54:11.2	870	\N	6291
2000-08-28 10:54:11.2	334	\N	6292
2000-08-28 10:54:11.2	10	\N	6293
2000-08-28 10:54:11.2	20	\N	6294
2000-08-28 10:54:11.24	5	1	6288
2000-08-28 10:54:11.24	-18467	1	6289
2000-08-28 10:54:11.24	174	\N	6290
2000-08-28 10:54:11.24	880	\N	6291
2000-08-28 10:54:11.24	345	\N	6292
2000-08-28 10:54:11.24	10	\N	6293
2000-08-28 10:54:11.24	20	\N	6294
2000-08-28 10:54:11.28	5	1	6288
2000-08-28 10:54:11.28	-18128	1	6289
2000-08-28 10:54:11.28	187	\N	6290
2000-08-28 10:54:11.28	860	\N	6291
2000-08-28 10:54:11.28	352	\N	6292
2000-08-28 10:54:11.28	10	\N	6293
2000-08-28 10:54:11.28	20	\N	6294
2000-08-28 10:54:11.32	5	1	6288
2000-08-28 10:54:11.32	-17959	1	6289
2000-08-28 10:54:11.32	187	\N	6290
2000-08-28 10:54:11.32	860	\N	6291
2000-08-28 10:54:11.32	352	\N	6292
2000-08-28 10:54:11.32	10	\N	6293
2000-08-28 10:54:11.32	20	\N	6294
2000-08-28 10:54:11.36	5	1	6288
2000-08-28 10:54:11.36	-17620	1	6289
2000-08-28 10:54:11.36	200	\N	6290
2000-08-28 10:54:11.36	870	\N	6291
2000-08-28 10:54:11.36	362	\N	6292
2000-08-28 10:54:11.36	10	\N	6293
2000-08-28 10:54:11.36	20	\N	6294
2000-08-28 10:54:11.4	5	1	6288
2000-08-28 10:54:11.4	-17282	1	6289
2000-08-28 10:54:11.4	213	\N	6290
2000-08-28 10:54:11.4	870	\N	6291
2000-08-28 10:54:11.4	369	\N	6292
2000-08-28 10:54:11.4	10	\N	6293
2000-08-28 10:54:11.4	20	\N	6294
2000-08-28 10:54:11.44	5	1	6288
2000-08-28 10:54:11.44	-17113	1	6289
2000-08-28 10:54:11.44	213	\N	6290
2000-08-28 10:54:11.44	870	\N	6291
2000-08-28 10:54:11.44	369	\N	6292
2000-08-28 10:54:11.44	10	\N	6293
2000-08-28 10:54:11.44	20	\N	6294
2000-08-28 10:54:11.48	5	1	6288
2000-08-28 10:54:11.48	-16774	1	6289
2000-08-28 10:54:11.48	226	\N	6290
2000-08-28 10:54:11.48	860	\N	6291
2000-08-28 10:54:11.48	378	\N	6292
2000-08-28 10:54:11.48	10	\N	6293
2000-08-28 10:54:11.48	20	\N	6294
2000-08-28 10:54:11.52	5	1	6288
2000-08-28 10:54:11.52	-16605	1	6289
2000-08-28 10:54:11.52	239	\N	6290
2000-08-28 10:54:11.52	870	\N	6291
2000-08-28 10:54:11.52	383	\N	6292
2000-08-28 10:54:11.52	10	\N	6293
2000-08-28 10:54:11.52	20	\N	6294
2000-08-28 10:54:11.56	5	1	6288
2000-08-28 10:54:11.56	-16266	1	6289
2000-08-28 10:54:11.56	239	\N	6290
2000-08-28 10:54:11.56	870	\N	6291
2000-08-28 10:54:11.56	383	\N	6292
2000-08-28 10:54:11.56	10	\N	6293
2000-08-28 10:54:11.56	20	\N	6294
2000-08-28 10:54:11.6	5	1	6288
2000-08-28 10:54:11.6	-16097	1	6289
2000-08-28 10:54:11.6	252	\N	6290
2000-08-28 10:54:11.6	870	\N	6291
2000-08-28 10:54:11.6	389	\N	6292
2000-08-28 10:54:11.6	10	\N	6293
2000-08-28 10:54:11.6	20	\N	6294
2000-08-28 10:54:11.64	5	1	6288
2000-08-28 10:54:11.64	-15759	1	6289
2000-08-28 10:54:11.64	265	\N	6290
2000-08-28 10:54:11.64	870	\N	6291
2000-08-28 10:54:11.64	395	\N	6292
2000-08-28 10:54:11.64	10	\N	6293
2000-08-28 10:54:11.64	20	\N	6294
2000-08-28 10:54:11.68	5	1	6288
2000-08-28 10:54:11.68	-15589	1	6289
2000-08-28 10:54:11.68	278	\N	6290
2000-08-28 10:54:11.68	870	\N	6291
2000-08-28 10:54:11.68	400	\N	6292
2000-08-28 10:54:11.68	10	\N	6293
2000-08-28 10:54:11.68	20	\N	6294
2000-08-28 10:54:11.72	5	1	6288
2000-08-28 10:54:11.72	-15251	1	6289
2000-08-28 10:54:11.72	278	\N	6290
2000-08-28 10:54:11.72	870	\N	6291
2000-08-28 10:54:11.72	400	\N	6292
2000-08-28 10:54:11.72	10	\N	6293
2000-08-28 10:54:11.72	20	\N	6294
2000-08-28 10:54:11.76	5	1	6288
2000-08-28 10:54:11.76	-14913	1	6289
2000-08-28 10:54:11.76	291	\N	6290
2000-08-28 10:54:11.76	870	\N	6291
2000-08-28 10:54:11.76	404	\N	6292
2000-08-28 10:54:11.76	10	\N	6293
2000-08-28 10:54:11.76	20	\N	6294
2000-08-28 10:54:11.8	5	1	6288
2000-08-28 10:54:11.8	-14743	1	6289
2000-08-28 10:54:11.8	300	\N	6290
2000-08-28 10:54:11.8	870	\N	6291
2000-08-28 10:54:11.8	407	\N	6292
2000-08-28 10:54:11.8	10	\N	6293
2000-08-28 10:54:11.8	20	\N	6294
2000-08-28 10:54:11.84	5	1	6288
2000-08-28 10:54:11.84	-14405	1	6289
2000-08-28 10:54:11.84	300	\N	6290
2000-08-28 10:54:11.84	870	\N	6291
2000-08-28 10:54:11.84	407	\N	6292
2000-08-28 10:54:11.84	10	\N	6293
2000-08-28 10:54:11.84	20	\N	6294
2000-08-28 10:54:11.88	5	1	6288
2000-08-28 10:54:11.88	-14236	1	6289
2000-08-28 10:54:11.88	300	\N	6290
2000-08-28 10:54:11.88	870	\N	6291
2000-08-28 10:54:11.88	411	\N	6292
2000-08-28 10:54:11.88	10	\N	6293
2000-08-28 10:54:11.88	20	\N	6294
2000-08-28 10:54:11.92	5	1	6288
2000-08-28 10:54:11.92	-13897	1	6289
2000-08-28 10:54:11.92	300	\N	6290
2000-08-28 10:54:11.92	870	\N	6291
2000-08-28 10:54:11.92	413	\N	6292
2000-08-28 10:54:11.92	10	\N	6293
2000-08-28 10:54:11.92	20	\N	6294
2000-08-28 10:54:11.96	5	1	6288
2000-08-28 10:54:11.96	-13728	1	6289
2000-08-28 10:54:11.96	300	\N	6290
2000-08-28 10:54:11.96	870	\N	6291
2000-08-28 10:54:11.96	413	\N	6292
2000-08-28 10:54:11.96	10	\N	6293
2000-08-28 10:54:11.96	20	\N	6294
2000-08-28 10:54:12	5	1	6288
2000-08-28 10:54:12	-13389	1	6289
2000-08-28 10:54:12	300	\N	6290
2000-08-28 10:54:12	870	\N	6291
2000-08-28 10:54:12	416	\N	6292
2000-08-28 10:54:12	10	\N	6293
2000-08-28 10:54:12	20	\N	6294
2000-08-28 10:54:12.04	5	1	6288
2000-08-28 10:54:12.04	-13051	1	6289
2000-08-28 10:54:12.04	300	\N	6290
2000-08-28 10:54:12.04	870	\N	6291
2000-08-28 10:54:12.04	416	\N	6292
2000-08-28 10:54:12.04	10	\N	6293
2000-08-28 10:54:12.04	20	\N	6294
2000-08-28 10:54:12.08	5	1	6288
2000-08-28 10:54:12.08	-12882	1	6289
2000-08-28 10:54:12.08	300	\N	6290
2000-08-28 10:54:12.08	880	\N	6291
2000-08-28 10:54:12.08	419	\N	6292
2000-08-28 10:54:12.08	10	\N	6293
2000-08-28 10:54:12.08	20	\N	6294
2000-08-28 10:54:12.12	5	1	6288
2000-08-28 10:54:12.12	-12543	1	6289
2000-08-28 10:54:12.12	300	\N	6290
2000-08-28 10:54:12.12	880	\N	6291
2000-08-28 10:54:12.12	419	\N	6292
2000-08-28 10:54:12.12	10	\N	6293
2000-08-28 10:54:12.12	20	\N	6294
2000-08-28 10:54:12.16	5	1	6288
2000-08-28 10:54:12.16	-12374	1	6289
2000-08-28 10:54:12.16	300	\N	6290
2000-08-28 10:54:12.16	870	\N	6291
2000-08-28 10:54:12.16	419	\N	6292
2000-08-28 10:54:12.16	10	\N	6293
2000-08-28 10:54:12.16	20	\N	6294
2000-08-28 10:54:12.2	5	1	6288
2000-08-28 10:54:12.2	-12035	1	6289
2000-08-28 10:54:12.2	300	\N	6290
2000-08-28 10:54:12.2	870	\N	6291
2000-08-28 10:54:12.2	422	\N	6292
2000-08-28 10:54:12.2	10	\N	6293
2000-08-28 10:54:12.2	20	\N	6294
2000-08-28 10:54:12.24	5	1	6288
2000-08-28 10:54:12.24	-11866	1	6289
2000-08-28 10:54:12.24	300	\N	6290
2000-08-28 10:54:12.24	870	\N	6291
2000-08-28 10:54:12.24	422	\N	6292
2000-08-28 10:54:12.24	10	\N	6293
2000-08-28 10:54:12.24	20	\N	6294
2000-08-28 10:54:12.28	5	1	6288
2000-08-28 10:54:12.28	-11528	1	6289
2000-08-28 10:54:12.28	300	\N	6290
2000-08-28 10:54:12.28	870	\N	6291
2000-08-28 10:54:12.28	422	\N	6292
2000-08-28 10:54:12.28	10	\N	6293
2000-08-28 10:54:12.28	20	\N	6294
2000-08-28 10:54:12.32	5	1	6288
2000-08-28 10:54:12.32	-11358	1	6289
2000-08-28 10:54:12.32	300	\N	6290
2000-08-28 10:54:12.32	870	\N	6291
2000-08-28 10:54:12.32	425	\N	6292
2000-08-28 10:54:12.32	10	\N	6293
2000-08-28 10:54:12.32	20	\N	6294
2000-08-28 10:54:12.36	5	1	6288
2000-08-28 10:54:12.36	-11020	1	6289
2000-08-28 10:54:12.36	300	\N	6290
2000-08-28 10:54:12.36	870	\N	6291
2000-08-28 10:54:12.36	425	\N	6292
2000-08-28 10:54:12.36	10	\N	6293
2000-08-28 10:54:12.36	20	\N	6294
2000-08-28 10:54:12.4	5	1	6288
2000-08-28 10:54:12.4	-10681	1	6289
2000-08-28 10:54:12.4	300	\N	6290
2000-08-28 10:54:12.4	880	\N	6291
2000-08-28 10:54:12.4	425	\N	6292
2000-08-28 10:54:12.4	10	\N	6293
2000-08-28 10:54:12.4	20	\N	6294
2000-08-28 10:54:12.44	5	1	6288
2000-08-28 10:54:12.44	-10512	1	6289
2000-08-28 10:54:12.44	300	\N	6290
2000-08-28 10:54:12.44	880	\N	6291
2000-08-28 10:54:12.44	425	\N	6292
2000-08-28 10:54:12.44	10	\N	6293
2000-08-28 10:54:12.44	20	\N	6294
2000-08-28 10:54:12.48	5	1	6288
2000-08-28 10:54:12.48	-10174	1	6289
2000-08-28 10:54:12.48	300	\N	6290
2000-08-28 10:54:12.48	880	\N	6291
2000-08-28 10:54:12.48	425	\N	6292
2000-08-28 10:54:12.48	10	\N	6293
2000-08-28 10:54:12.48	20	\N	6294
2000-08-28 10:54:12.52	5	1	6288
2000-08-28 10:54:12.52	-10004	1	6289
2000-08-28 10:54:12.52	300	\N	6290
2000-08-28 10:54:12.52	880	\N	6291
2000-08-28 10:54:12.52	425	\N	6292
2000-08-28 10:54:12.52	10	\N	6293
2000-08-28 10:54:12.52	20	\N	6294
2000-08-28 10:54:12.56	5	1	6288
2000-08-28 10:54:12.56	-9666	1	6289
2000-08-28 10:54:12.56	300	\N	6290
2000-08-28 10:54:12.56	880	\N	6291
2000-08-28 10:54:12.56	425	\N	6292
2000-08-28 10:54:12.56	10	\N	6293
2000-08-28 10:54:12.56	20	\N	6294
2000-08-28 10:54:12.6	5	1	6288
2000-08-28 10:54:12.6	-9497	1	6289
2000-08-28 10:54:12.6	300	\N	6290
2000-08-28 10:54:12.6	870	\N	6291
2000-08-28 10:54:12.6	425	\N	6292
2000-08-28 10:54:12.6	10	\N	6293
2000-08-28 10:54:12.6	20	\N	6294
2000-08-28 10:54:12.64	5	1	6288
2000-08-28 10:54:12.64	-9158	1	6289
2000-08-28 10:54:12.64	300	\N	6290
2000-08-28 10:54:12.64	870	\N	6291
2000-08-28 10:54:12.64	425	\N	6292
2000-08-28 10:54:12.64	10	\N	6293
2000-08-28 10:54:12.64	20	\N	6294
2000-08-28 10:54:12.68	5	1	6288
2000-08-28 10:54:12.68	-8820	1	6289
2000-08-28 10:54:12.68	300	\N	6290
2000-08-28 10:54:12.68	870	\N	6291
2000-08-28 10:54:12.68	425	\N	6292
2000-08-28 10:54:12.68	10	\N	6293
2000-08-28 10:54:12.68	20	\N	6294
2000-08-28 10:54:12.72	5	1	6288
2000-08-28 10:54:12.72	-8651	1	6289
2000-08-28 10:54:12.72	300	\N	6290
2000-08-28 10:54:12.72	870	\N	6291
2000-08-28 10:54:12.72	426	\N	6292
2000-08-28 10:54:12.72	10	\N	6293
2000-08-28 10:54:12.72	20	\N	6294
2000-08-28 10:54:12.76	5	1	6288
2000-08-28 10:54:12.76	-8312	1	6289
2000-08-28 10:54:12.76	300	\N	6290
2000-08-28 10:54:12.76	870	\N	6291
2000-08-28 10:54:12.76	426	\N	6292
2000-08-28 10:54:12.76	10	\N	6293
2000-08-28 10:54:12.76	20	\N	6294
2000-08-28 10:54:12.8	5	1	6288
2000-08-28 10:54:12.8	-8143	1	6289
2000-08-28 10:54:12.8	300	\N	6290
2000-08-28 10:54:12.8	870	\N	6291
2000-08-28 10:54:12.8	425	\N	6292
2000-08-28 10:54:12.8	10	\N	6293
2000-08-28 10:54:12.8	20	\N	6294
2000-08-28 10:54:12.84	5	1	6288
2000-08-28 10:54:12.84	-7804	1	6289
2000-08-28 10:54:12.84	300	\N	6290
2000-08-28 10:54:12.84	870	\N	6291
2000-08-28 10:54:12.84	425	\N	6292
2000-08-28 10:54:12.84	10	\N	6293
2000-08-28 10:54:12.84	20	\N	6294
2000-08-28 10:54:12.88	5	1	6288
2000-08-28 10:54:12.88	-7635	1	6289
2000-08-28 10:54:12.88	300	\N	6290
2000-08-28 10:54:12.88	870	\N	6291
2000-08-28 10:54:12.88	425	\N	6292
2000-08-28 10:54:12.88	10	\N	6293
2000-08-28 10:54:12.88	20	\N	6294
2000-08-28 10:54:12.92	5	1	6288
2000-08-28 10:54:12.92	-7297	1	6289
2000-08-28 10:54:12.92	300	\N	6290
2000-08-28 10:54:12.92	880	\N	6291
2000-08-28 10:54:12.92	426	\N	6292
2000-08-28 10:54:12.92	10	\N	6293
2000-08-28 10:54:12.92	20	\N	6294
2000-08-28 10:54:12.96	5	1	6288
2000-08-28 10:54:12.96	-7127	1	6289
2000-08-28 10:54:12.96	300	\N	6290
2000-08-28 10:54:12.96	870	\N	6291
2000-08-28 10:54:12.96	425	\N	6292
2000-08-28 10:54:12.96	10	\N	6293
2000-08-28 10:54:12.96	20	\N	6294
2000-08-28 10:54:13	5	1	6288
2000-08-28 10:54:13	-6789	1	6289
2000-08-28 10:54:13	300	\N	6290
2000-08-28 10:54:13	870	\N	6291
2000-08-28 10:54:13	425	\N	6292
2000-08-28 10:54:13	10	\N	6293
2000-08-28 10:54:13	20	\N	6294
2000-08-28 10:54:13.04	5	1	6288
2000-08-28 10:54:13.04	-6450	1	6289
2000-08-28 10:54:13.04	300	\N	6290
2000-08-28 10:54:13.04	870	\N	6291
2000-08-28 10:54:13.04	426	\N	6292
2000-08-28 10:54:13.04	10	\N	6293
2000-08-28 10:54:13.04	20	\N	6294
2000-08-28 10:54:13.08	5	1	6288
2000-08-28 10:54:13.08	-6281	1	6289
2000-08-28 10:54:13.08	300	\N	6290
2000-08-28 10:54:13.08	880	\N	6291
2000-08-28 10:54:13.08	426	\N	6292
2000-08-28 10:54:13.08	10	\N	6293
2000-08-28 10:54:13.08	20	\N	6294
2000-08-28 10:54:13.12	5	1	6288
2000-08-28 10:54:13.12	-5943	1	6289
2000-08-28 10:54:13.12	300	\N	6290
2000-08-28 10:54:13.12	870	\N	6291
2000-08-28 10:54:13.12	425	\N	6292
2000-08-28 10:54:13.12	10	\N	6293
2000-08-28 10:54:13.12	20	\N	6294
2000-08-28 10:54:13.16	5	1	6288
2000-08-28 10:54:13.16	-5773	1	6289
2000-08-28 10:54:13.16	300	\N	6290
2000-08-28 10:54:13.16	870	\N	6291
2000-08-28 10:54:13.16	425	\N	6292
2000-08-28 10:54:13.16	10	\N	6293
2000-08-28 10:54:13.16	20	\N	6294
2000-08-28 10:54:13.2	5	1	6288
2000-08-28 10:54:13.2	-5435	1	6289
2000-08-28 10:54:13.2	300	\N	6290
2000-08-28 10:54:13.2	880	\N	6291
2000-08-28 10:54:13.2	425	\N	6292
2000-08-28 10:54:13.2	10	\N	6293
2000-08-28 10:54:13.2	20	\N	6294
2000-08-28 10:54:13.24	5	1	6288
2000-08-28 10:54:13.24	-5266	1	6289
2000-08-28 10:54:13.24	300	\N	6290
2000-08-28 10:54:13.24	880	\N	6291
2000-08-28 10:54:13.24	426	\N	6292
2000-08-28 10:54:13.24	10	\N	6293
2000-08-28 10:54:13.24	20	\N	6294
2000-08-28 10:54:13.28	5	1	6288
2000-08-28 10:54:13.28	-4927	1	6289
2000-08-28 10:54:13.28	300	\N	6290
2000-08-28 10:54:13.28	880	\N	6291
2000-08-28 10:54:13.28	426	\N	6292
2000-08-28 10:54:13.28	10	\N	6293
2000-08-28 10:54:13.28	20	\N	6294
2000-08-28 10:54:13.32	5	1	6288
2000-08-28 10:54:13.32	-4589	1	6289
2000-08-28 10:54:13.32	300	\N	6290
2000-08-28 10:54:13.32	870	\N	6291
2000-08-28 10:54:13.32	425	\N	6292
2000-08-28 10:54:13.32	10	\N	6293
2000-08-28 10:54:13.32	20	\N	6294
2000-08-28 10:54:13.36	5	1	6288
2000-08-28 10:54:13.36	-4419	1	6289
2000-08-28 10:54:13.36	300	\N	6290
2000-08-28 10:54:13.36	880	\N	6291
2000-08-28 10:54:13.36	425	\N	6292
2000-08-28 10:54:13.36	10	\N	6293
2000-08-28 10:54:13.36	20	\N	6294
2000-08-28 10:54:13.4	5	1	6288
2000-08-28 10:54:13.4	-4081	1	6289
2000-08-28 10:54:13.4	300	\N	6290
2000-08-28 10:54:13.4	880	\N	6291
2000-08-28 10:54:13.4	425	\N	6292
2000-08-28 10:54:13.4	10	\N	6293
2000-08-28 10:54:13.4	20	\N	6294
2000-08-28 10:54:13.44	5	1	6288
2000-08-28 10:54:13.44	-3912	1	6289
2000-08-28 10:54:13.44	300	\N	6290
2000-08-28 10:54:13.44	870	\N	6291
2000-08-28 10:54:13.44	426	\N	6292
2000-08-28 10:54:13.44	10	\N	6293
2000-08-28 10:54:13.44	20	\N	6294
2000-08-28 10:54:13.48	5	1	6288
2000-08-28 10:54:13.48	-3573	1	6289
2000-08-28 10:54:13.48	300	\N	6290
2000-08-28 10:54:13.48	870	\N	6291
2000-08-28 10:54:13.48	425	\N	6292
2000-08-28 10:54:13.48	10	\N	6293
2000-08-28 10:54:13.48	20	\N	6294
2000-08-28 10:54:13.52	5	1	6288
2000-08-28 10:54:13.52	-3404	1	6289
2000-08-28 10:54:13.52	300	\N	6290
2000-08-28 10:54:13.52	870	\N	6291
2000-08-28 10:54:13.52	428	\N	6292
2000-08-28 10:54:13.52	10	\N	6293
2000-08-28 10:54:13.52	20	\N	6294
2000-08-28 10:54:13.56	5	1	6288
2000-08-28 10:54:13.56	-3065	1	6289
2000-08-28 10:54:13.56	300	\N	6290
2000-08-28 10:54:13.56	870	\N	6291
2000-08-28 10:54:13.56	428	\N	6292
2000-08-28 10:54:13.56	10	\N	6293
2000-08-28 10:54:13.56	20	\N	6294
2000-08-28 10:54:13.6	5	1	6288
2000-08-28 10:54:13.6	-2896	1	6289
2000-08-28 10:54:13.6	300	\N	6290
2000-08-28 10:54:13.6	870	\N	6291
2000-08-28 10:54:13.6	429	\N	6292
2000-08-28 10:54:13.6	10	\N	6293
2000-08-28 10:54:13.6	20	\N	6294
2000-08-28 10:54:13.64	5	1	6288
2000-08-28 10:54:13.64	-2558	1	6289
2000-08-28 10:54:13.64	300	\N	6290
2000-08-28 10:54:13.64	880	\N	6291
2000-08-28 10:54:13.64	429	\N	6292
2000-08-28 10:54:13.64	10	\N	6293
2000-08-28 10:54:13.64	20	\N	6294
2000-08-28 10:54:13.68	5	1	6288
2000-08-28 10:54:13.68	-2219	1	6289
2000-08-28 10:54:13.68	300	\N	6290
2000-08-28 10:54:13.68	880	\N	6291
2000-08-28 10:54:13.68	429	\N	6292
2000-08-28 10:54:13.68	10	\N	6293
2000-08-28 10:54:13.68	20	\N	6294
2000-08-28 10:54:13.72	5	1	6288
2000-08-28 10:54:13.72	-2050	1	6289
2000-08-28 10:54:13.72	300	\N	6290
2000-08-28 10:54:13.72	870	\N	6291
2000-08-28 10:54:13.72	429	\N	6292
2000-08-28 10:54:13.72	10	\N	6293
2000-08-28 10:54:13.72	20	\N	6294
2000-08-28 10:54:13.76	5	1	6288
2000-08-28 10:54:13.76	-1712	1	6289
2000-08-28 10:54:13.76	300	\N	6290
2000-08-28 10:54:13.76	880	\N	6291
2000-08-28 10:54:13.76	429	\N	6292
2000-08-28 10:54:13.76	10	\N	6293
2000-08-28 10:54:13.76	20	\N	6294
2000-08-28 10:54:13.8	5	1	6288
2000-08-28 10:54:13.8	-1542	1	6289
2000-08-28 10:54:13.8	300	\N	6290
2000-08-28 10:54:13.8	880	\N	6291
2000-08-28 10:54:13.8	429	\N	6292
2000-08-28 10:54:13.8	10	\N	6293
2000-08-28 10:54:13.8	20	\N	6294
2000-08-28 10:54:13.84	5	1	6288
2000-08-28 10:54:13.84	-1204	1	6289
2000-08-28 10:54:13.84	300	\N	6290
2000-08-28 10:54:13.84	880	\N	6291
2000-08-28 10:54:13.84	429	\N	6292
2000-08-28 10:54:13.84	10	\N	6293
2000-08-28 10:54:13.84	20	\N	6294
2000-08-28 10:54:13.88	5	1	6288
2000-08-28 10:54:13.88	-1035	1	6289
2000-08-28 10:54:13.88	300	\N	6290
2000-08-28 10:54:13.88	880	\N	6291
2000-08-28 10:54:13.88	429	\N	6292
2000-08-28 10:54:13.88	10	\N	6293
2000-08-28 10:54:13.88	20	\N	6294
2000-08-28 10:54:13.92	5	1	6288
2000-08-28 10:54:13.92	-696	1	6289
2000-08-28 10:54:13.92	300	\N	6290
2000-08-28 10:54:13.92	880	\N	6291
2000-08-28 10:54:13.92	429	\N	6292
2000-08-28 10:54:13.92	10	\N	6293
2000-08-28 10:54:13.92	20	\N	6294
2000-08-28 10:54:13.96	5	1	6288
2000-08-28 10:54:13.96	-358	1	6289
2000-08-28 10:54:13.96	300	\N	6290
2000-08-28 10:54:13.96	880	\N	6291
2000-08-28 10:54:13.96	429	\N	6292
2000-08-28 10:54:13.96	10	\N	6293
2000-08-28 10:54:13.96	20	\N	6294
2000-08-28 10:54:14	5	1	6288
2000-08-28 10:54:14	-188	1	6289
2000-08-28 10:54:14	300	\N	6290
2000-08-28 10:54:14	870	\N	6291
2000-08-28 10:54:14	429	\N	6292
2000-08-28 10:54:14	10	\N	6293
2000-08-28 10:54:14	20	\N	6294
2000-08-28 10:54:14.04	5	1	6288
2000-08-28 10:54:14.04	149	1	6289
2000-08-28 10:54:14.04	300	\N	6290
2000-08-28 10:54:14.04	870	\N	6291
2000-08-28 10:54:14.04	428	\N	6292
2000-08-28 10:54:14.04	10	\N	6293
2000-08-28 10:54:14.04	20	\N	6294
2000-08-28 10:54:14.08	5	1	6288
2000-08-28 10:54:14.08	318	1	6289
2000-08-28 10:54:14.08	300	\N	6290
2000-08-28 10:54:14.08	870	\N	6291
2000-08-28 10:54:14.08	428	\N	6292
2000-08-28 10:54:14.08	10	\N	6293
2000-08-28 10:54:14.08	20	\N	6294
2000-08-28 10:54:14.12	5	1	6288
2000-08-28 10:54:14.12	657	1	6289
2000-08-28 10:54:14.12	300	\N	6290
2000-08-28 10:54:14.12	870	\N	6291
2000-08-28 10:54:14.12	429	\N	6292
2000-08-28 10:54:14.12	10	\N	6293
2000-08-28 10:54:14.12	20	\N	6294
2000-08-28 10:54:14.16	5	1	6288
2000-08-28 10:54:14.16	826	1	6289
2000-08-28 10:54:14.16	300	\N	6290
2000-08-28 10:54:14.16	870	\N	6291
2000-08-28 10:54:14.16	429	\N	6292
2000-08-28 10:54:14.16	10	\N	6293
2000-08-28 10:54:14.16	20	\N	6294
2000-08-28 10:54:14.2	5	1	6288
2000-08-28 10:54:14.2	1165	1	6289
2000-08-28 10:54:14.2	300	\N	6290
2000-08-28 10:54:14.2	870	\N	6291
2000-08-28 10:54:14.2	429	\N	6292
2000-08-28 10:54:14.2	10	\N	6293
2000-08-28 10:54:14.2	20	\N	6294
2000-08-28 10:54:14.24	5	1	6288
2000-08-28 10:54:14.24	1334	1	6289
2000-08-28 10:54:14.24	300	\N	6290
2000-08-28 10:54:14.24	880	\N	6291
2000-08-28 10:54:14.24	429	\N	6292
2000-08-28 10:54:14.24	10	\N	6293
2000-08-28 10:54:14.24	20	\N	6294
2000-08-28 10:54:14.28	5	1	6288
2000-08-28 10:54:14.28	1672	1	6289
2000-08-28 10:54:14.28	300	\N	6290
2000-08-28 10:54:14.28	870	\N	6291
2000-08-28 10:54:14.28	428	\N	6292
2000-08-28 10:54:14.28	10	\N	6293
2000-08-28 10:54:14.28	20	\N	6294
2000-08-28 10:54:14.32	5	1	6288
2000-08-28 10:54:14.32	2011	1	6289
2000-08-28 10:54:14.32	300	\N	6290
2000-08-28 10:54:14.32	870	\N	6291
2000-08-28 10:54:14.32	428	\N	6292
2000-08-28 10:54:14.32	10	\N	6293
2000-08-28 10:54:14.32	20	\N	6294
2000-08-28 10:54:14.36	5	1	6288
2000-08-28 10:54:14.36	2180	1	6289
2000-08-28 10:54:14.36	300	\N	6290
2000-08-28 10:54:14.36	870	\N	6291
2000-08-28 10:54:14.36	429	\N	6292
2000-08-28 10:54:14.36	10	\N	6293
2000-08-28 10:54:14.36	20	\N	6294
2000-08-28 10:54:14.4	5	1	6288
2000-08-28 10:54:14.4	2519	1	6289
2000-08-28 10:54:14.4	300	\N	6290
2000-08-28 10:54:14.4	870	\N	6291
2000-08-28 10:54:14.4	429	\N	6292
2000-08-28 10:54:14.4	10	\N	6293
2000-08-28 10:54:14.4	20	\N	6294
2000-08-28 10:54:14.44	5	1	6288
2000-08-28 10:54:14.44	2688	1	6289
2000-08-28 10:54:14.44	300	\N	6290
2000-08-28 10:54:14.44	870	\N	6291
2000-08-28 10:54:14.44	428	\N	6292
2000-08-28 10:54:14.44	10	\N	6293
2000-08-28 10:54:14.44	20	\N	6294
2000-08-28 10:54:14.48	5	1	6288
2000-08-28 10:54:14.48	3026	1	6289
2000-08-28 10:54:14.48	300	\N	6290
2000-08-28 10:54:14.48	870	\N	6291
2000-08-28 10:54:14.48	428	\N	6292
2000-08-28 10:54:14.48	10	\N	6293
2000-08-28 10:54:14.48	20	\N	6294
2000-08-28 10:54:14.52	5	1	6288
2000-08-28 10:54:14.52	3196	1	6289
2000-08-28 10:54:14.52	300	\N	6290
2000-08-28 10:54:14.52	870	\N	6291
2000-08-28 10:54:14.52	429	\N	6292
2000-08-28 10:54:14.52	10	\N	6293
2000-08-28 10:54:14.52	20	\N	6294
2000-08-28 10:54:14.56	5	1	6288
2000-08-28 10:54:14.56	3534	1	6289
2000-08-28 10:54:14.56	300	\N	6290
2000-08-28 10:54:14.56	870	\N	6291
2000-08-28 10:54:14.56	428	\N	6292
2000-08-28 10:54:14.56	10	\N	6293
2000-08-28 10:54:14.56	20	\N	6294
2000-08-28 10:54:14.6	5	1	6288
2000-08-28 10:54:14.6	3873	1	6289
2000-08-28 10:54:14.6	300	\N	6290
2000-08-28 10:54:14.6	870	\N	6291
2000-08-28 10:54:14.6	428	\N	6292
2000-08-28 10:54:14.6	10	\N	6293
2000-08-28 10:54:14.6	20	\N	6294
2000-08-28 10:54:14.64	5	1	6288
2000-08-28 10:54:14.64	4042	1	6289
2000-08-28 10:54:14.64	300	\N	6290
2000-08-28 10:54:14.64	880	\N	6291
2000-08-28 10:54:14.64	429	\N	6292
2000-08-28 10:54:14.64	10	\N	6293
2000-08-28 10:54:14.64	20	\N	6294
2000-08-28 10:54:14.68	5	1	6288
2000-08-28 10:54:14.68	4380	1	6289
2000-08-28 10:54:14.68	300	\N	6290
2000-08-28 10:54:14.68	870	\N	6291
2000-08-28 10:54:14.68	429	\N	6292
2000-08-28 10:54:14.68	10	\N	6293
2000-08-28 10:54:14.68	20	\N	6294
2000-08-28 10:54:14.72	5	1	6288
2000-08-28 10:54:14.72	4550	1	6289
2000-08-28 10:54:14.72	300	\N	6290
2000-08-28 10:54:14.72	870	\N	6291
2000-08-28 10:54:14.72	429	\N	6292
2000-08-28 10:54:14.72	10	\N	6293
2000-08-28 10:54:14.72	20	\N	6294
2000-08-28 10:54:14.76	5	1	6288
2000-08-28 10:54:14.76	4888	1	6289
2000-08-28 10:54:14.76	300	\N	6290
2000-08-28 10:54:14.76	870	\N	6291
2000-08-28 10:54:14.76	429	\N	6292
2000-08-28 10:54:14.76	10	\N	6293
2000-08-28 10:54:14.76	20	\N	6294
2000-08-28 10:54:14.8	5	1	6288
2000-08-28 10:54:14.8	5057	1	6289
2000-08-28 10:54:14.8	300	\N	6290
2000-08-28 10:54:14.8	870	\N	6291
2000-08-28 10:54:14.8	429	\N	6292
2000-08-28 10:54:14.8	10	\N	6293
2000-08-28 10:54:14.8	20	\N	6294
2000-08-28 10:54:14.84	5	1	6288
2000-08-28 10:54:14.84	5396	1	6289
2000-08-28 10:54:14.84	300	\N	6290
2000-08-28 10:54:14.84	870	\N	6291
2000-08-28 10:54:14.84	429	\N	6292
2000-08-28 10:54:14.84	10	\N	6293
2000-08-28 10:54:14.84	20	\N	6294
2000-08-28 10:54:14.88	5	1	6288
2000-08-28 10:54:14.88	5565	1	6289
2000-08-28 10:54:14.88	300	\N	6290
2000-08-28 10:54:14.88	870	\N	6291
2000-08-28 10:54:14.88	428	\N	6292
2000-08-28 10:54:14.88	10	\N	6293
2000-08-28 10:54:14.88	20	\N	6294
2000-08-28 10:54:14.92	5	1	6288
2000-08-28 10:54:14.92	5903	1	6289
2000-08-28 10:54:14.92	300	\N	6290
2000-08-28 10:54:14.92	870	\N	6291
2000-08-28 10:54:14.92	428	\N	6292
2000-08-28 10:54:14.92	10	\N	6293
2000-08-28 10:54:14.92	20	\N	6294
2000-08-28 10:54:14.96	5	1	6288
2000-08-28 10:54:14.96	6242	1	6289
2000-08-28 10:54:14.96	300	\N	6290
2000-08-28 10:54:14.96	870	\N	6291
2000-08-28 10:54:14.96	428	\N	6292
2000-08-28 10:54:14.96	10	\N	6293
2000-08-28 10:54:14.96	20	\N	6294
2000-08-28 10:54:15	5	1	6288
2000-08-28 10:54:15	6411	1	6289
2000-08-28 10:54:15	300	\N	6290
2000-08-28 10:54:15	870	\N	6291
2000-08-28 10:54:15	428	\N	6292
2000-08-28 10:54:15	10	\N	6293
2000-08-28 10:54:15	20	\N	6294
2000-08-28 10:54:15.04	5	1	6288
2000-08-28 10:54:15.04	6750	1	6289
2000-08-28 10:54:15.04	300	\N	6290
2000-08-28 10:54:15.04	870	\N	6291
2000-08-28 10:54:15.04	428	\N	6292
2000-08-28 10:54:15.04	10	\N	6293
2000-08-28 10:54:15.04	20	\N	6294
2000-08-28 10:54:15.08	5	1	6288
2000-08-28 10:54:15.08	6919	1	6289
2000-08-28 10:54:15.08	300	\N	6290
2000-08-28 10:54:15.08	870	\N	6291
2000-08-28 10:54:15.08	429	\N	6292
2000-08-28 10:54:15.08	10	\N	6293
2000-08-28 10:54:15.08	20	\N	6294
2000-08-28 10:54:15.12	5	1	6288
2000-08-28 10:54:15.12	7257	1	6289
2000-08-28 10:54:15.12	300	\N	6290
2000-08-28 10:54:15.12	870	\N	6291
2000-08-28 10:54:15.12	429	\N	6292
2000-08-28 10:54:15.12	10	\N	6293
2000-08-28 10:54:15.12	20	\N	6294
2000-08-28 10:54:15.16	5	1	6288
2000-08-28 10:54:15.16	7427	1	6289
2000-08-28 10:54:15.16	300	\N	6290
2000-08-28 10:54:15.16	870	\N	6291
2000-08-28 10:54:15.16	428	\N	6292
2000-08-28 10:54:15.16	10	\N	6293
2000-08-28 10:54:15.16	20	\N	6294
2000-08-28 10:54:15.2	5	1	6288
2000-08-28 10:54:15.2	7765	1	6289
2000-08-28 10:54:15.2	300	\N	6290
2000-08-28 10:54:15.2	870	\N	6291
2000-08-28 10:54:15.2	429	\N	6292
2000-08-28 10:54:15.2	10	\N	6293
2000-08-28 10:54:15.2	20	\N	6294
2000-08-28 10:54:15.24	5	1	6288
2000-08-28 10:54:15.24	8104	1	6289
2000-08-28 10:54:15.24	300	\N	6290
2000-08-28 10:54:15.24	870	\N	6291
2000-08-28 10:54:15.24	429	\N	6292
2000-08-28 10:54:15.24	10	\N	6293
2000-08-28 10:54:15.24	20	\N	6294
2000-08-28 10:54:15.28	5	1	6288
2000-08-28 10:54:15.28	8273	1	6289
2000-08-28 10:54:15.28	300	\N	6290
2000-08-28 10:54:15.28	860	\N	6291
2000-08-28 10:54:15.28	429	\N	6292
2000-08-28 10:54:15.28	10	\N	6293
2000-08-28 10:54:15.28	20	\N	6294
2000-08-28 10:54:15.32	5	1	6288
2000-08-28 10:54:15.32	8611	1	6289
2000-08-28 10:54:15.32	300	\N	6290
2000-08-28 10:54:15.32	860	\N	6291
2000-08-28 10:54:15.32	429	\N	6292
2000-08-28 10:54:15.32	10	\N	6293
2000-08-28 10:54:15.32	20	\N	6294
2000-08-28 10:54:15.36	5	1	6288
2000-08-28 10:54:15.36	8781	1	6289
2000-08-28 10:54:15.36	300	\N	6290
2000-08-28 10:54:15.36	860	\N	6291
2000-08-28 10:54:15.36	429	\N	6292
2000-08-28 10:54:15.36	10	\N	6293
2000-08-28 10:54:15.36	20	\N	6294
2000-08-28 10:54:15.4	5	1	6288
2000-08-28 10:54:15.4	9119	1	6289
2000-08-28 10:54:15.4	300	\N	6290
2000-08-28 10:54:15.4	860	\N	6291
2000-08-28 10:54:15.4	429	\N	6292
2000-08-28 10:54:15.4	10	\N	6293
2000-08-28 10:54:15.4	20	\N	6294
2000-08-28 10:54:15.44	5	1	6288
2000-08-28 10:54:15.44	9288	1	6289
2000-08-28 10:54:15.44	300	\N	6290
2000-08-28 10:54:15.44	850	\N	6291
2000-08-28 10:54:15.44	428	\N	6292
2000-08-28 10:54:15.44	10	\N	6293
2000-08-28 10:54:15.44	20	\N	6294
2000-08-28 10:54:15.48	5	1	6288
2000-08-28 10:54:15.48	9627	1	6289
2000-08-28 10:54:15.48	300	\N	6290
2000-08-28 10:54:15.48	840	\N	6291
2000-08-28 10:54:15.48	429	\N	6292
2000-08-28 10:54:15.48	10	\N	6293
2000-08-28 10:54:15.48	20	\N	6294
2000-08-28 10:54:15.52	5	1	6288
2000-08-28 10:54:15.52	9796	1	6289
2000-08-28 10:54:15.52	300	\N	6290
2000-08-28 10:54:15.52	840	\N	6291
2000-08-28 10:54:15.52	429	\N	6292
2000-08-28 10:54:15.52	10	\N	6293
2000-08-28 10:54:15.52	20	\N	6294
2000-08-28 10:54:15.56	5	1	6288
2000-08-28 10:54:15.56	10135	1	6289
2000-08-28 10:54:15.56	300	\N	6290
2000-08-28 10:54:15.56	820	\N	6291
2000-08-28 10:54:15.56	429	\N	6292
2000-08-28 10:54:15.56	10	\N	6293
2000-08-28 10:54:15.56	20	\N	6294
2000-08-28 10:54:15.6	5	1	6288
2000-08-28 10:54:15.6	10473	1	6289
2000-08-28 10:54:15.6	300	\N	6290
2000-08-28 10:54:15.6	790	\N	6291
2000-08-28 10:54:15.6	428	\N	6292
2000-08-28 10:54:15.6	10	\N	6293
2000-08-28 10:54:15.6	20	\N	6294
2000-08-28 10:54:15.64	5	1	6288
2000-08-28 10:54:15.64	10642	1	6289
2000-08-28 10:54:15.64	300	\N	6290
2000-08-28 10:54:15.64	790	\N	6291
2000-08-28 10:54:15.64	428	\N	6292
2000-08-28 10:54:15.64	10	\N	6293
2000-08-28 10:54:15.64	20	\N	6294
2000-08-28 10:54:15.68	5	1	6288
2000-08-28 10:54:15.68	10981	1	6289
2000-08-28 10:54:15.68	300	\N	6290
2000-08-28 10:54:15.68	770	\N	6291
2000-08-28 10:54:15.68	429	\N	6292
2000-08-28 10:54:15.68	10	\N	6293
2000-08-28 10:54:15.68	20	\N	6294
2000-08-28 10:54:15.72	5	1	6288
2000-08-28 10:54:15.72	11150	1	6289
2000-08-28 10:54:15.72	300	\N	6290
2000-08-28 10:54:15.72	740	\N	6291
2000-08-28 10:54:15.72	428	\N	6292
2000-08-28 10:54:15.72	10	\N	6293
2000-08-28 10:54:15.72	20	\N	6294
2000-08-28 10:54:15.76	5	1	6288
2000-08-28 10:54:15.76	11488	1	6289
2000-08-28 10:54:15.76	300	\N	6290
2000-08-28 10:54:15.76	740	\N	6291
2000-08-28 10:54:15.76	428	\N	6292
2000-08-28 10:54:15.76	10	\N	6293
2000-08-28 10:54:15.76	20	\N	6294
2000-08-28 10:54:15.8	5	1	6288
2000-08-28 10:54:15.8	11658	1	6289
2000-08-28 10:54:15.8	300	\N	6290
2000-08-28 10:54:15.8	710	\N	6291
2000-08-28 10:54:15.8	426	\N	6292
2000-08-28 10:54:15.8	10	\N	6293
2000-08-28 10:54:15.8	20	\N	6294
2000-08-28 10:54:15.84	5	1	6288
2000-08-28 10:54:15.84	11996	1	6289
2000-08-28 10:54:15.84	300	\N	6290
2000-08-28 10:54:15.84	680	\N	6291
2000-08-28 10:54:15.84	425	\N	6292
2000-08-28 10:54:15.84	10	\N	6293
2000-08-28 10:54:15.84	20	\N	6294
2000-08-28 10:54:15.88	5	1	6288
2000-08-28 10:54:15.88	12165	1	6289
2000-08-28 10:54:15.88	300	\N	6290
2000-08-28 10:54:15.88	680	\N	6291
2000-08-28 10:54:15.88	425	\N	6292
2000-08-28 10:54:15.88	10	\N	6293
2000-08-28 10:54:15.88	20	\N	6294
2000-08-28 10:54:15.92	5	1	6288
2000-08-28 10:54:15.92	12504	1	6289
2000-08-28 10:54:15.92	300	\N	6290
2000-08-28 10:54:15.92	650	\N	6291
2000-08-28 10:54:15.92	423	\N	6292
2000-08-28 10:54:15.92	10	\N	6293
2000-08-28 10:54:15.92	20	\N	6294
2000-08-28 10:54:15.96	5	1	6288
2000-08-28 10:54:15.96	12842	1	6289
2000-08-28 10:54:15.96	300	\N	6290
2000-08-28 10:54:15.96	620	\N	6291
2000-08-28 10:54:15.96	421	\N	6292
2000-08-28 10:54:15.96	10	\N	6293
2000-08-28 10:54:15.96	20	\N	6294
2000-08-28 10:54:16	5	1	6288
2000-08-28 10:54:16	13012	1	6289
2000-08-28 10:54:16	300	\N	6290
2000-08-28 10:54:16	590	\N	6291
2000-08-28 10:54:16	419	\N	6292
2000-08-28 10:54:16	10	\N	6293
2000-08-28 10:54:16	20	\N	6294
2000-08-28 10:54:16.04	5	1	6288
2000-08-28 10:54:16.04	13350	1	6289
2000-08-28 10:54:16.04	300	\N	6290
2000-08-28 10:54:16.04	590	\N	6291
2000-08-28 10:54:16.04	419	\N	6292
2000-08-28 10:54:16.04	10	\N	6293
2000-08-28 10:54:16.04	20	\N	6294
2000-08-28 10:54:16.08	5	1	6288
2000-08-28 10:54:16.08	13519	1	6289
2000-08-28 10:54:16.08	300	\N	6290
2000-08-28 10:54:16.08	560	\N	6291
2000-08-28 10:54:16.08	416	\N	6292
2000-08-28 10:54:16.08	10	\N	6293
2000-08-28 10:54:16.08	20	\N	6294
2000-08-28 10:54:16.12	5	1	6288
2000-08-28 10:54:16.12	13858	1	6289
2000-08-28 10:54:16.12	300	\N	6290
2000-08-28 10:54:16.12	530	\N	6291
2000-08-28 10:54:16.12	413	\N	6292
2000-08-28 10:54:16.12	10	\N	6293
2000-08-28 10:54:16.12	20	\N	6294
2000-08-28 10:54:16.16	5	1	6288
2000-08-28 10:54:16.16	14196	1	6289
2000-08-28 10:54:16.16	300	\N	6290
2000-08-28 10:54:16.16	530	\N	6291
2000-08-28 10:54:16.16	413	\N	6292
2000-08-28 10:54:16.16	10	\N	6293
2000-08-28 10:54:16.16	20	\N	6294
2000-08-28 10:54:16.2	5	1	6288
2000-08-28 10:54:16.2	14366	1	6289
2000-08-28 10:54:16.2	300	\N	6290
2000-08-28 10:54:16.2	500	\N	6291
2000-08-28 10:54:16.2	408	\N	6292
2000-08-28 10:54:16.2	10	\N	6293
2000-08-28 10:54:16.2	20	\N	6294
2000-08-28 10:54:16.24	5	1	6288
2000-08-28 10:54:16.24	14704	1	6289
2000-08-28 10:54:16.24	300	\N	6290
2000-08-28 10:54:16.24	460	\N	6291
2000-08-28 10:54:16.24	404	\N	6292
2000-08-28 10:54:16.24	10	\N	6293
2000-08-28 10:54:16.24	20	\N	6294
2000-08-28 10:54:16.28	5	1	6288
2000-08-28 10:54:16.28	14873	1	6289
2000-08-28 10:54:16.28	300	\N	6290
2000-08-28 10:54:16.28	460	\N	6291
2000-08-28 10:54:16.28	404	\N	6292
2000-08-28 10:54:16.28	10	\N	6293
2000-08-28 10:54:16.28	20	\N	6294
2000-08-28 10:54:16.32	5	1	6288
2000-08-28 10:54:16.32	15212	1	6289
2000-08-28 10:54:16.32	300	\N	6290
2000-08-28 10:54:16.32	440	\N	6291
2000-08-28 10:54:16.32	398	\N	6292
2000-08-28 10:54:16.32	10	\N	6293
2000-08-28 10:54:16.32	20	\N	6294
2000-08-28 10:54:16.36	5	1	6288
2000-08-28 10:54:16.36	15381	1	6289
2000-08-28 10:54:16.36	300	\N	6290
2000-08-28 10:54:16.36	410	\N	6291
2000-08-28 10:54:16.36	394	\N	6292
2000-08-28 10:54:16.36	10	\N	6293
2000-08-28 10:54:16.36	20	\N	6294
2000-08-28 10:54:16.4	5	1	6288
2000-08-28 10:54:16.4	15720	1	6289
2000-08-28 10:54:16.4	300	\N	6290
2000-08-28 10:54:16.4	390	\N	6291
2000-08-28 10:54:16.4	388	\N	6292
2000-08-28 10:54:16.4	10	\N	6293
2000-08-28 10:54:16.4	20	\N	6294
2000-08-28 10:54:16.44	5	1	6288
2000-08-28 10:54:16.44	15889	1	6289
2000-08-28 10:54:16.44	300	\N	6290
2000-08-28 10:54:16.44	390	\N	6291
2000-08-28 10:54:16.44	388	\N	6292
2000-08-28 10:54:16.44	10	\N	6293
2000-08-28 10:54:16.44	20	\N	6294
2000-08-28 10:54:16.48	5	1	6288
2000-08-28 10:54:16.48	16227	1	6289
2000-08-28 10:54:16.48	300	\N	6290
2000-08-28 10:54:16.48	340	\N	6291
2000-08-28 10:54:16.48	382	\N	6292
2000-08-28 10:54:16.48	10	\N	6293
2000-08-28 10:54:16.48	20	\N	6294
2000-08-28 10:54:16.52	5	1	6288
2000-08-28 10:54:16.52	16566	1	6289
2000-08-28 10:54:16.52	300	\N	6290
2000-08-28 10:54:16.52	240	\N	6291
2000-08-28 10:54:16.52	377	\N	6292
2000-08-28 10:54:16.52	10	\N	6293
2000-08-28 10:54:16.52	20	\N	6294
2000-08-28 10:54:16.56	5	1	6288
2000-08-28 10:54:16.56	16735	1	6289
2000-08-28 10:54:16.56	300	\N	6290
2000-08-28 10:54:16.56	240	\N	6291
2000-08-28 10:54:16.56	377	\N	6292
2000-08-28 10:54:16.56	10	\N	6293
2000-08-28 10:54:16.56	20	\N	6294
2000-08-28 10:54:16.6	5	1	6288
2000-08-28 10:54:16.6	17074	1	6289
2000-08-28 10:54:16.6	300	\N	6290
2000-08-28 10:54:16.6	120	\N	6291
2000-08-28 10:54:16.6	371	\N	6292
2000-08-28 10:54:16.6	10	\N	6293
2000-08-28 10:54:16.6	20	\N	6294
2000-08-28 10:54:16.64	5	1	6288
2000-08-28 10:54:16.64	17243	1	6289
2000-08-28 10:54:16.64	300	\N	6290
2000-08-28 10:54:16.64	30	\N	6291
2000-08-28 10:54:16.64	362	\N	6292
2000-08-28 10:54:16.64	10	\N	6293
2000-08-28 10:54:16.64	20	\N	6294
2000-08-28 10:54:16.68	5	1	6288
2000-08-28 10:54:16.68	17581	1	6289
2000-08-28 10:54:16.68	300	\N	6290
2000-08-28 10:54:16.68	30	\N	6291
2000-08-28 10:54:16.68	362	\N	6292
2000-08-28 10:54:16.68	10	\N	6293
2000-08-28 10:54:16.68	20	\N	6294
2000-08-28 10:54:16.72	5	1	6288
2000-08-28 10:54:16.72	17750	1	6289
2000-08-28 10:54:16.72	300	\N	6290
2000-08-28 10:54:16.72	0	\N	6291
2000-08-28 10:54:16.72	356	\N	6292
2000-08-28 10:54:16.72	10	\N	6293
2000-08-28 10:54:16.72	20	\N	6294
2000-08-28 10:54:16.76	5	1	6288
2000-08-28 10:54:16.76	18089	1	6289
2000-08-28 10:54:16.76	300	\N	6290
2000-08-28 10:54:16.76	0	\N	6291
2000-08-28 10:54:16.76	347	\N	6292
2000-08-28 10:54:16.76	10	\N	6293
2000-08-28 10:54:16.76	20	\N	6294
2000-08-28 10:54:16.8	5	1	6288
2000-08-28 10:54:16.8	18258	1	6289
2000-08-28 10:54:16.8	300	\N	6290
2000-08-28 10:54:16.8	0	\N	6291
2000-08-28 10:54:16.8	347	\N	6292
2000-08-28 10:54:16.8	10	\N	6293
2000-08-28 10:54:16.8	20	\N	6294
2000-08-28 10:54:16.84	5	1	6288
2000-08-28 10:54:16.84	18597	1	6289
2000-08-28 10:54:16.84	300	\N	6290
2000-08-28 10:54:16.84	0	\N	6291
2000-08-28 10:54:16.84	339	\N	6292
2000-08-28 10:54:16.84	10	\N	6293
2000-08-28 10:54:16.84	20	\N	6294
2000-08-28 10:54:16.88	5	1	6288
2000-08-28 10:54:16.88	18935	1	6289
2000-08-28 10:54:16.88	300	\N	6290
2000-08-28 10:54:16.88	0	\N	6291
2000-08-28 10:54:16.88	328	\N	6292
2000-08-28 10:54:16.88	10	\N	6293
2000-08-28 10:54:16.88	20	\N	6294
2000-08-28 10:54:16.92	5	1	6288
2000-08-28 10:54:16.92	19104	1	6289
2000-08-28 10:54:16.92	293	\N	6290
2000-08-28 10:54:16.92	0	\N	6291
2000-08-28 10:54:16.92	321	\N	6292
2000-08-28 10:54:16.92	10	\N	6293
2000-08-28 10:54:16.92	20	\N	6294
2000-08-28 10:54:16.96	5	1	6288
2000-08-28 10:54:16.96	19443	1	6289
2000-08-28 10:54:16.96	293	\N	6290
2000-08-28 10:54:16.96	0	\N	6291
2000-08-28 10:54:16.96	321	\N	6292
2000-08-28 10:54:16.96	10	\N	6293
2000-08-28 10:54:16.96	20	\N	6294
2000-08-28 10:54:17	5	1	6288
2000-08-28 10:54:17	19612	1	6289
2000-08-28 10:54:17	281	\N	6290
2000-08-28 10:54:17	0	\N	6291
2000-08-28 10:54:17	310	\N	6292
2000-08-28 10:54:17	10	\N	6293
2000-08-28 10:54:17	20	\N	6294
2000-08-28 10:54:17.04	5	1	6288
2000-08-28 10:54:17.04	19951	1	6289
2000-08-28 10:54:17.04	269	\N	6290
2000-08-28 10:54:17.04	0	\N	6291
2000-08-28 10:54:17.04	301	\N	6292
2000-08-28 10:54:17.04	10	\N	6293
2000-08-28 10:54:17.04	20	\N	6294
2000-08-28 10:54:17.08	5	1	6288
2000-08-28 10:54:17.08	20120	1	6289
2000-08-28 10:54:17.08	269	\N	6290
2000-08-28 10:54:17.08	0	\N	6291
2000-08-28 10:54:17.08	301	\N	6292
2000-08-28 10:54:17.08	10	\N	6293
2000-08-28 10:54:17.08	20	\N	6294
2000-08-28 10:54:17.12	5	1	6288
2000-08-28 10:54:17.12	20458	1	6289
2000-08-28 10:54:17.12	257	\N	6290
2000-08-28 10:54:17.12	0	\N	6291
2000-08-28 10:54:17.12	289	\N	6292
2000-08-28 10:54:17.12	10	\N	6293
2000-08-28 10:54:17.12	20	\N	6294
2000-08-28 10:54:17.16	5	1	6288
2000-08-28 10:54:17.16	20797	1	6289
2000-08-28 10:54:17.16	245	\N	6290
2000-08-28 10:54:17.16	0	\N	6291
2000-08-28 10:54:17.16	280	\N	6292
2000-08-28 10:54:17.16	10	\N	6293
2000-08-28 10:54:17.16	20	\N	6294
2000-08-28 10:54:17.2	5	1	6288
2000-08-28 10:54:17.2	20966	1	6289
2000-08-28 10:54:17.2	245	\N	6290
2000-08-28 10:54:17.2	0	\N	6291
2000-08-28 10:54:17.2	280	\N	6292
2000-08-28 10:54:17.2	10	\N	6293
2000-08-28 10:54:17.2	20	\N	6294
2000-08-28 10:54:17.24	5	1	6288
2000-08-28 10:54:17.24	21305	1	6289
2000-08-28 10:54:17.24	233	\N	6290
2000-08-28 10:54:17.24	0	\N	6291
2000-08-28 10:54:17.24	271	\N	6292
2000-08-28 10:54:17.24	10	\N	6293
2000-08-28 10:54:17.24	20	\N	6294
2000-08-28 10:54:17.28	5	1	6288
2000-08-28 10:54:17.28	21474	1	6289
2000-08-28 10:54:17.28	221	\N	6290
2000-08-28 10:54:17.28	0	\N	6291
2000-08-28 10:54:17.28	262	\N	6292
2000-08-28 10:54:17.28	10	\N	6293
2000-08-28 10:54:17.28	20	\N	6294
2000-08-28 10:54:17.32	5	1	6288
2000-08-28 10:54:17.32	21812	1	6289
2000-08-28 10:54:17.32	221	\N	6290
2000-08-28 10:54:17.32	0	\N	6291
2000-08-28 10:54:17.32	262	\N	6292
2000-08-28 10:54:17.32	10	\N	6293
2000-08-28 10:54:17.32	20	\N	6294
2000-08-28 10:54:17.36	5	1	6288
2000-08-28 10:54:17.36	21982	1	6289
2000-08-28 10:54:17.36	209	\N	6290
2000-08-28 10:54:17.36	0	\N	6291
2000-08-28 10:54:17.36	251	\N	6292
2000-08-28 10:54:17.36	10	\N	6293
2000-08-28 10:54:17.36	20	\N	6294
2000-08-28 10:54:17.4	5	1	6288
2000-08-28 10:54:17.4	22320	1	6289
2000-08-28 10:54:17.4	0	\N	6290
2000-08-28 10:54:17.4	10	\N	6291
2000-08-28 10:54:17.4	245	\N	6292
2000-08-28 10:54:17.4	10	\N	6293
2000-08-28 10:54:17.4	20	\N	6294
2000-08-28 10:54:17.44	5	1	6288
2000-08-28 10:54:17.44	22489	1	6289
2000-08-28 10:54:17.44	0	\N	6290
2000-08-28 10:54:17.44	10	\N	6291
2000-08-28 10:54:17.44	237	\N	6292
2000-08-28 10:54:17.44	10	\N	6293
2000-08-28 10:54:17.44	20	\N	6294
2000-08-28 10:54:17.48	5	1	6288
2000-08-28 10:54:17.48	22828	1	6289
2000-08-28 10:54:17.48	0	\N	6290
2000-08-28 10:54:17.48	10	\N	6291
2000-08-28 10:54:17.48	237	\N	6292
2000-08-28 10:54:17.48	10	\N	6293
2000-08-28 10:54:17.48	20	\N	6294
2000-08-28 10:54:17.52	5	1	6288
2000-08-28 10:54:17.52	23000	1	6289
2000-08-28 10:54:17.52	0	\N	6290
2000-08-28 10:54:17.52	10	\N	6291
2000-08-28 10:54:17.52	230	\N	6292
2000-08-28 10:54:17.52	10	\N	6293
2000-08-28 10:54:17.52	20	\N	6294
2000-08-28 10:54:17.56	5	1	6288
2000-08-28 10:54:17.56	23000	1	6289
2000-08-28 10:54:17.56	0	\N	6290
2000-08-28 10:54:17.56	10	\N	6291
2000-08-28 10:54:17.56	225	\N	6292
2000-08-28 10:54:17.56	10	\N	6293
2000-08-28 10:54:17.56	20	\N	6294
2000-08-28 10:54:17.6	5	1	6288
2000-08-28 10:54:17.6	23000	1	6289
2000-08-28 10:54:17.6	0	\N	6290
2000-08-28 10:54:17.6	10	\N	6291
2000-08-28 10:54:17.6	225	\N	6292
2000-08-28 10:54:17.6	10	\N	6293
2000-08-28 10:54:17.6	20	\N	6294
2000-08-28 10:54:17.64	5	1	6288
2000-08-28 10:54:17.64	23000	1	6289
2000-08-28 10:54:17.64	0	\N	6290
2000-08-28 10:54:17.64	0	\N	6291
2000-08-28 10:54:17.64	220	\N	6292
2000-08-28 10:54:17.64	10	\N	6293
2000-08-28 10:54:17.64	20	\N	6294
2000-08-28 10:54:17.68	5	1	6288
2000-08-28 10:54:17.68	23000	1	6289
2000-08-28 10:54:17.68	0	\N	6290
2000-08-28 10:54:17.68	0	\N	6291
2000-08-28 10:54:17.68	217	\N	6292
2000-08-28 10:54:17.68	10	\N	6293
2000-08-28 10:54:17.68	20	\N	6294
2000-08-28 10:54:17.72	5	1	6288
2000-08-28 10:54:17.72	23000	1	6289
2000-08-28 10:54:17.72	0	\N	6290
2000-08-28 10:54:17.72	0	\N	6291
2000-08-28 10:54:17.72	217	\N	6292
2000-08-28 10:54:17.72	10	\N	6293
2000-08-28 10:54:17.72	20	\N	6294
2000-08-28 10:54:17.76	5	1	6288
2000-08-28 10:54:17.76	23000	1	6289
2000-08-28 10:54:17.76	0	\N	6290
2000-08-28 10:54:17.76	20	\N	6291
2000-08-28 10:54:17.76	211	\N	6292
2000-08-28 10:54:17.76	10	\N	6293
2000-08-28 10:54:17.76	20	\N	6294
2000-08-28 10:54:17.8	0	1	6288
2000-08-28 10:54:17.8	23000	1	6289
2000-08-28 10:54:17.8	0	\N	6290
2000-08-28 10:54:17.8	20	\N	6291
2000-08-28 10:54:17.8	208	\N	6292
2000-08-28 10:54:17.8	10	\N	6293
2000-08-28 10:54:17.8	20	\N	6294
2000-08-28 10:54:17.84	0	1	6288
2000-08-28 10:54:17.84	23000	1	6289
2000-08-28 10:54:17.84	0	\N	6290
2000-08-28 10:54:17.84	10	\N	6291
2000-08-28 10:54:17.84	205	\N	6292
2000-08-28 10:54:17.84	10	\N	6293
2000-08-28 10:54:17.84	20	\N	6294
2000-08-28 10:54:17.88	0	1	6288
2000-08-28 10:54:17.88	23000	1	6289
2000-08-28 10:54:17.88	0	\N	6290
2000-08-28 10:54:17.88	10	\N	6291
2000-08-28 10:54:17.88	205	\N	6292
2000-08-28 10:54:17.88	10	\N	6293
2000-08-28 10:54:17.88	20	\N	6294
2000-08-28 10:54:17.92	0	1	6288
2000-08-28 10:54:17.92	23000	1	6289
2000-08-28 10:54:17.92	0	\N	6290
2000-08-28 10:54:17.92	0	\N	6291
2000-08-28 10:54:17.92	202	\N	6292
2000-08-28 10:54:17.92	10	\N	6293
2000-08-28 10:54:17.92	20	\N	6294
2000-08-28 10:54:17.96	0	1	6288
2000-08-28 10:54:17.96	23000	1	6289
2000-08-28 10:54:17.96	0	\N	6290
2000-08-28 10:54:17.96	0	\N	6291
2000-08-28 10:54:17.96	200	\N	6292
2000-08-28 10:54:17.96	10	\N	6293
2000-08-28 10:54:17.96	20	\N	6294
2000-08-28 10:54:18	0	1	6288
2000-08-28 10:54:18	23000	1	6289
2000-08-28 10:54:18	0	\N	6290
2000-08-28 10:54:18	0	\N	6291
2000-08-28 10:54:18	200	\N	6292
2000-08-28 10:54:18	10	\N	6293
2000-08-28 10:54:18	20	\N	6294
2000-08-28 10:54:18.04	0	1	6288
2000-08-28 10:54:18.04	23000	1	6289
2000-08-28 10:54:18.04	0	\N	6290
2000-08-28 10:54:18.04	0	\N	6291
2000-08-28 10:54:18.04	199	\N	6292
2000-08-28 10:54:18.04	10	\N	6293
2000-08-28 10:54:18.04	20	\N	6294
2000-08-28 10:54:18.08	0	1	6288
2000-08-28 10:54:18.08	22961	1	6289
2000-08-28 10:54:18.08	0	\N	6290
2000-08-28 10:54:18.08	0	\N	6291
2000-08-28 10:54:18.08	196	\N	6292
2000-08-28 10:54:18.08	10	\N	6293
2000-08-28 10:54:18.08	20	\N	6294
2000-08-28 10:54:18.12	0	1	6288
2000-08-28 10:54:18.12	22347	1	6289
2000-08-28 10:54:18.12	0	\N	6290
2000-08-28 10:54:18.12	0	\N	6291
2000-08-28 10:54:18.12	196	\N	6292
2000-08-28 10:54:18.12	10	\N	6293
2000-08-28 10:54:18.12	20	\N	6294
2000-08-28 10:54:18.16	0	1	6288
2000-08-28 10:54:18.16	22000	1	6289
2000-08-28 10:54:18.16	0	\N	6290
2000-08-28 10:54:18.16	10	\N	6291
2000-08-28 10:54:18.16	196	\N	6292
2000-08-28 10:54:18.16	10	\N	6293
2000-08-28 10:54:18.16	20	\N	6294
2000-08-28 10:54:18.2	0	1	6288
2000-08-28 10:54:18.2	22000	1	6289
2000-08-28 10:54:18.2	0	\N	6290
2000-08-28 10:54:18.2	0	\N	6291
2000-08-28 10:54:18.2	195	\N	6292
2000-08-28 10:54:18.2	10	\N	6293
2000-08-28 10:54:18.2	20	\N	6294
2000-08-28 10:54:18.24	0	1	6288
2000-08-28 10:54:18.24	22000	1	6289
2000-08-28 10:54:18.24	0	\N	6290
2000-08-28 10:54:18.24	20	\N	6291
2000-08-28 10:54:18.24	192	\N	6292
2000-08-28 10:54:18.24	10	\N	6293
2000-08-28 10:54:18.24	20	\N	6294
2000-08-28 10:54:18.28	0	1	6288
2000-08-28 10:54:18.28	22000	1	6289
2000-08-28 10:54:18.28	0	\N	6290
2000-08-28 10:54:18.28	20	\N	6291
2000-08-28 10:54:18.28	192	\N	6292
2000-08-28 10:54:18.28	10	\N	6293
2000-08-28 10:54:18.28	20	\N	6294
2000-08-28 10:54:18.32	0	1	6288
2000-08-28 10:54:18.32	22000	1	6289
2000-08-28 10:54:18.32	0	\N	6290
2000-08-28 10:54:18.32	10	\N	6291
2000-08-28 10:54:18.32	192	\N	6292
2000-08-28 10:54:18.32	10	\N	6293
2000-08-28 10:54:18.32	20	\N	6294
2000-08-28 10:54:18.36	0	1	6288
2000-08-28 10:54:18.36	22000	1	6289
2000-08-28 10:54:18.36	0	\N	6290
2000-08-28 10:54:18.36	10	\N	6291
2000-08-28 10:54:18.36	192	\N	6292
2000-08-28 10:54:18.36	10	\N	6293
2000-08-28 10:54:18.36	20	\N	6294
2000-08-28 10:54:18.4	0	1	6288
2000-08-28 10:54:18.4	22000	1	6289
2000-08-28 10:54:18.4	0	\N	6290
2000-08-28 10:54:18.4	10	\N	6291
2000-08-28 10:54:18.4	192	\N	6292
2000-08-28 10:54:18.4	10	\N	6293
2000-08-28 10:54:18.4	20	\N	6294
2000-08-28 10:54:18.44	0	1	6288
2000-08-28 10:54:18.44	22000	1	6289
2000-08-28 10:54:18.44	0	\N	6290
2000-08-28 10:54:18.44	0	\N	6291
2000-08-28 10:54:18.44	192	\N	6292
2000-08-28 10:54:18.44	10	\N	6293
2000-08-28 10:54:18.44	20	\N	6294
2000-08-28 10:54:18.48	0	1	6288
2000-08-28 10:54:18.48	22000	1	6289
2000-08-28 10:54:18.48	0	\N	6290
2000-08-28 10:54:18.48	0	\N	6291
2000-08-28 10:54:18.48	192	\N	6292
2000-08-28 10:54:18.48	10	\N	6293
2000-08-28 10:54:18.48	20	\N	6294
2000-08-28 10:54:18.52	0	1	6288
2000-08-28 10:54:18.52	22000	1	6289
2000-08-28 10:54:18.52	0	\N	6290
2000-08-28 10:54:18.52	0	\N	6291
2000-08-28 10:54:18.52	192	\N	6292
2000-08-28 10:54:18.52	10	\N	6293
2000-08-28 10:54:18.52	20	\N	6294
2000-08-28 10:54:18.56	0	1	6288
2000-08-28 10:54:18.56	22000	1	6289
2000-08-28 10:54:18.56	0	\N	6290
2000-08-28 10:54:18.56	0	\N	6291
2000-08-28 10:54:18.56	189	\N	6292
2000-08-28 10:54:18.56	10	\N	6293
2000-08-28 10:54:18.56	20	\N	6294
2000-08-28 10:54:18.6	0	1	6288
2000-08-28 10:54:18.6	22000	1	6289
2000-08-28 10:54:18.6	0	\N	6290
2000-08-28 10:54:18.6	40	\N	6291
2000-08-28 10:54:18.6	189	\N	6292
2000-08-28 10:54:18.6	10	\N	6293
2000-08-28 10:54:18.6	20	\N	6294
2000-08-28 10:54:18.64	0	1	6288
2000-08-28 10:54:18.64	22000	1	6289
2000-08-28 10:54:18.64	0	\N	6290
2000-08-28 10:54:18.64	40	\N	6291
2000-08-28 10:54:18.64	189	\N	6292
2000-08-28 10:54:18.64	10	\N	6293
2000-08-28 10:54:18.64	20	\N	6294
2000-08-28 10:54:18.68	6	1	6288
2000-08-28 10:54:18.68	22000	1	6289
2000-08-28 10:54:18.68	0	\N	6290
2000-08-28 10:54:18.68	20	\N	6291
2000-08-28 10:54:18.68	189	\N	6292
2000-08-28 10:54:18.68	10	\N	6293
2000-08-28 10:54:18.68	20	\N	6294
2000-08-28 10:54:18.72	6	1	6288
2000-08-28 10:54:18.72	22000	1	6289
2000-08-28 10:54:18.72	0	\N	6290
2000-08-28 10:54:18.72	10	\N	6291
2000-08-28 10:54:18.72	189	\N	6292
2000-08-28 10:54:18.72	10	\N	6293
2000-08-28 10:54:18.72	20	\N	6294
2000-08-28 10:54:18.76	6	1	6288
2000-08-28 10:54:18.76	22000	1	6289
2000-08-28 10:54:18.76	0	\N	6290
2000-08-28 10:54:18.76	80	\N	6291
2000-08-28 10:54:18.76	189	\N	6292
2000-08-28 10:54:18.76	10	\N	6293
2000-08-28 10:54:18.76	20	\N	6294
2000-08-28 10:54:18.8	6	1	6288
2000-08-28 10:54:18.8	22000	1	6289
2000-08-28 10:54:18.8	0	\N	6290
2000-08-28 10:54:18.8	80	\N	6291
2000-08-28 10:54:18.8	189	\N	6292
2000-08-28 10:54:18.8	10	\N	6293
2000-08-28 10:54:18.8	20	\N	6294
2000-08-28 10:54:18.84	6	1	6288
2000-08-28 10:54:18.84	22000	1	6289
2000-08-28 10:54:18.84	0	\N	6290
2000-08-28 10:54:18.84	210	\N	6291
2000-08-28 10:54:18.84	189	\N	6292
2000-08-28 10:54:18.84	10	\N	6293
2000-08-28 10:54:18.84	20	\N	6294
2000-08-28 10:54:18.88	6	1	6288
2000-08-28 10:54:18.88	22000	1	6289
2000-08-28 10:54:18.88	0	\N	6290
2000-08-28 10:54:18.88	320	\N	6291
2000-08-28 10:54:18.88	190	\N	6292
2000-08-28 10:54:18.88	10	\N	6293
2000-08-28 10:54:18.88	20	\N	6294
2000-08-28 10:54:18.92	6	1	6288
2000-08-28 10:54:18.92	22000	1	6289
2000-08-28 10:54:18.92	0	\N	6290
2000-08-28 10:54:18.92	320	\N	6291
2000-08-28 10:54:18.92	190	\N	6292
2000-08-28 10:54:18.92	10	\N	6293
2000-08-28 10:54:18.92	20	\N	6294
2000-08-28 10:54:18.96	6	1	6288
2000-08-28 10:54:18.96	22000	1	6289
2000-08-28 10:54:18.96	0	\N	6290
2000-08-28 10:54:18.96	380	\N	6291
2000-08-28 10:54:18.96	189	\N	6292
2000-08-28 10:54:18.96	10	\N	6293
2000-08-28 10:54:18.96	20	\N	6294
2000-08-28 10:54:19	6	1	6288
2000-08-28 10:54:19	22000	1	6289
2000-08-28 10:54:19	0	\N	6290
2000-08-28 10:54:19	420	\N	6291
2000-08-28 10:54:19	189	\N	6292
2000-08-28 10:54:19	10	\N	6293
2000-08-28 10:54:19	20	\N	6294
2000-08-28 10:54:19.04	6	1	6288
2000-08-28 10:54:19.04	22000	1	6289
2000-08-28 10:54:19.04	0	\N	6290
2000-08-28 10:54:19.04	420	\N	6291
2000-08-28 10:54:19.04	189	\N	6292
2000-08-28 10:54:19.04	10	\N	6293
2000-08-28 10:54:19.04	20	\N	6294
2000-08-28 10:54:19.08	6	1	6288
2000-08-28 10:54:19.08	22000	1	6289
2000-08-28 10:54:19.08	0	\N	6290
2000-08-28 10:54:19.08	480	\N	6291
2000-08-28 10:54:19.08	192	\N	6292
2000-08-28 10:54:19.08	10	\N	6293
2000-08-28 10:54:19.08	20	\N	6294
2000-08-28 10:54:19.12	6	1	6288
2000-08-28 10:54:19.12	22000	1	6289
2000-08-28 10:54:19.12	0	\N	6290
2000-08-28 10:54:19.12	550	\N	6291
2000-08-28 10:54:19.12	197	\N	6292
2000-08-28 10:54:19.12	10	\N	6293
2000-08-28 10:54:19.12	20	\N	6294
2000-08-28 10:54:19.16	6	1	6288
2000-08-28 10:54:19.16	22000	1	6289
2000-08-28 10:54:19.16	0	\N	6290
2000-08-28 10:54:19.16	550	\N	6291
2000-08-28 10:54:19.16	197	\N	6292
2000-08-28 10:54:19.16	10	\N	6293
2000-08-28 10:54:19.16	20	\N	6294
2000-08-28 10:54:19.2	6	1	6288
2000-08-28 10:54:19.2	22000	1	6289
2000-08-28 10:54:19.2	0	\N	6290
2000-08-28 10:54:19.2	600	\N	6291
2000-08-28 10:54:19.2	202	\N	6292
2000-08-28 10:54:19.2	10	\N	6293
2000-08-28 10:54:19.2	20	\N	6294
2000-08-28 10:54:19.24	6	1	6288
2000-08-28 10:54:19.24	22000	1	6289
2000-08-28 10:54:19.24	0	\N	6290
2000-08-28 10:54:19.24	670	\N	6291
2000-08-28 10:54:19.24	209	\N	6292
2000-08-28 10:54:19.24	10	\N	6293
2000-08-28 10:54:19.24	20	\N	6294
2000-08-28 10:54:19.28	6	1	6288
2000-08-28 10:54:19.28	22000	1	6289
2000-08-28 10:54:19.28	0	\N	6290
2000-08-28 10:54:19.28	710	\N	6291
2000-08-28 10:54:19.28	216	\N	6292
2000-08-28 10:54:19.28	10	\N	6293
2000-08-28 10:54:19.28	20	\N	6294
2000-08-28 10:54:19.32	6	1	6288
2000-08-28 10:54:19.32	22000	1	6289
2000-08-28 10:54:19.32	0	\N	6290
2000-08-28 10:54:19.32	710	\N	6291
2000-08-28 10:54:19.32	216	\N	6292
2000-08-28 10:54:19.32	10	\N	6293
2000-08-28 10:54:19.32	20	\N	6294
2000-08-28 10:54:19.36	6	1	6288
2000-08-28 10:54:19.36	22000	1	6289
2000-08-28 10:54:19.36	0	\N	6290
2000-08-28 10:54:19.36	740	\N	6291
2000-08-28 10:54:19.36	223	\N	6292
2000-08-28 10:54:19.36	10	\N	6293
2000-08-28 10:54:19.36	20	\N	6294
2000-08-28 10:54:19.4	6	1	6288
2000-08-28 10:54:19.4	22000	1	6289
2000-08-28 10:54:19.4	0	\N	6290
2000-08-28 10:54:19.4	770	\N	6291
2000-08-28 10:54:19.4	232	\N	6292
2000-08-28 10:54:19.4	10	\N	6293
2000-08-28 10:54:19.4	20	\N	6294
2000-08-28 10:54:19.44	6	1	6288
2000-08-28 10:54:19.44	22000	1	6289
2000-08-28 10:54:19.44	0	\N	6290
2000-08-28 10:54:19.44	770	\N	6291
2000-08-28 10:54:19.44	232	\N	6292
2000-08-28 10:54:19.44	10	\N	6293
2000-08-28 10:54:19.44	20	\N	6294
2000-08-28 10:54:19.48	6	1	6288
2000-08-28 10:54:19.48	21978	1	6289
2000-08-28 10:54:19.48	0	\N	6290
2000-08-28 10:54:19.48	790	\N	6291
2000-08-28 10:54:19.48	241	\N	6292
2000-08-28 10:54:19.48	10	\N	6293
2000-08-28 10:54:19.48	20	\N	6294
2000-08-28 10:54:19.52	6	1	6288
2000-08-28 10:54:19.52	21640	1	6289
2000-08-28 10:54:19.52	0	\N	6290
2000-08-28 10:54:19.52	810	\N	6291
2000-08-28 10:54:19.52	253	\N	6292
2000-08-28 10:54:19.52	10	\N	6293
2000-08-28 10:54:19.52	20	\N	6294
2000-08-28 10:54:19.56	6	1	6288
2000-08-28 10:54:19.56	21471	1	6289
2000-08-28 10:54:19.56	0	\N	6290
2000-08-28 10:54:19.56	810	\N	6291
2000-08-28 10:54:19.56	253	\N	6292
2000-08-28 10:54:19.56	10	\N	6293
2000-08-28 10:54:19.56	20	\N	6294
2000-08-28 10:54:19.6	6	1	6288
2000-08-28 10:54:19.6	21132	1	6289
2000-08-28 10:54:19.6	0	\N	6290
2000-08-28 10:54:19.6	820	\N	6291
2000-08-28 10:54:19.6	264	\N	6292
2000-08-28 10:54:19.6	10	\N	6293
2000-08-28 10:54:19.6	20	\N	6294
2000-08-28 10:54:19.64	6	1	6288
2000-08-28 10:54:19.64	20963	1	6289
2000-08-28 10:54:19.64	0	\N	6290
2000-08-28 10:54:19.64	830	\N	6291
2000-08-28 10:54:19.64	276	\N	6292
2000-08-28 10:54:19.64	10	\N	6293
2000-08-28 10:54:19.64	20	\N	6294
2000-08-28 10:54:19.68	6	1	6288
2000-08-28 10:54:19.68	20624	1	6289
2000-08-28 10:54:19.68	0	\N	6290
2000-08-28 10:54:19.68	830	\N	6291
2000-08-28 10:54:19.68	276	\N	6292
2000-08-28 10:54:19.68	10	\N	6293
2000-08-28 10:54:19.68	20	\N	6294
2000-08-28 10:54:19.72	6	1	6288
2000-08-28 10:54:19.72	20286	1	6289
2000-08-28 10:54:19.72	104	\N	6290
2000-08-28 10:54:19.72	860	\N	6291
2000-08-28 10:54:19.72	284	\N	6292
2000-08-28 10:54:19.72	10	\N	6293
2000-08-28 10:54:19.72	20	\N	6294
2000-08-28 10:54:19.76	6	1	6288
2000-08-28 10:54:19.76	20117	1	6289
2000-08-28 10:54:19.76	117	\N	6290
2000-08-28 10:54:19.76	860	\N	6291
2000-08-28 10:54:19.76	296	\N	6292
2000-08-28 10:54:19.76	10	\N	6293
2000-08-28 10:54:19.76	20	\N	6294
2000-08-28 10:54:19.8	6	1	6288
2000-08-28 10:54:19.8	19778	1	6289
2000-08-28 10:54:19.8	130	\N	6290
2000-08-28 10:54:19.8	850	\N	6291
2000-08-28 10:54:19.8	308	\N	6292
2000-08-28 10:54:19.8	10	\N	6293
2000-08-28 10:54:19.8	20	\N	6294
2000-08-28 10:54:19.84	6	1	6288
2000-08-28 10:54:19.84	19609	1	6289
2000-08-28 10:54:19.84	130	\N	6290
2000-08-28 10:54:19.84	850	\N	6291
2000-08-28 10:54:19.84	308	\N	6292
2000-08-28 10:54:19.84	10	\N	6293
2000-08-28 10:54:19.84	20	\N	6294
2000-08-28 10:54:19.88	6	1	6288
2000-08-28 10:54:19.88	19271	1	6289
2000-08-28 10:54:19.88	143	\N	6290
2000-08-28 10:54:19.88	850	\N	6291
2000-08-28 10:54:19.88	318	\N	6292
2000-08-28 10:54:19.88	10	\N	6293
2000-08-28 10:54:19.88	20	\N	6294
2000-08-28 10:54:19.92	6	1	6288
2000-08-28 10:54:19.92	19101	1	6289
2000-08-28 10:54:19.92	156	\N	6290
2000-08-28 10:54:19.92	860	\N	6291
2000-08-28 10:54:19.92	329	\N	6292
2000-08-28 10:54:19.92	10	\N	6293
2000-08-28 10:54:19.92	20	\N	6294
2000-08-28 10:54:19.96	6	1	6288
2000-08-28 10:54:19.96	18763	1	6289
2000-08-28 10:54:19.96	156	\N	6290
2000-08-28 10:54:19.96	860	\N	6291
2000-08-28 10:54:19.96	329	\N	6292
2000-08-28 10:54:19.96	10	\N	6293
2000-08-28 10:54:19.96	20	\N	6294
2000-08-28 10:54:20	6	1	6288
2000-08-28 10:54:20	18594	1	6289
2000-08-28 10:54:20	169	\N	6290
2000-08-28 10:54:20	860	\N	6291
2000-08-28 10:54:20	340	\N	6292
2000-08-28 10:54:20	10	\N	6293
2000-08-28 10:54:20	20	\N	6294
2000-08-28 10:54:20.04	6	1	6288
2000-08-28 10:54:20.04	18255	1	6289
2000-08-28 10:54:20.04	182	\N	6290
2000-08-28 10:54:20.04	860	\N	6291
2000-08-28 10:54:20.04	351	\N	6292
2000-08-28 10:54:20.04	10	\N	6293
2000-08-28 10:54:20.04	20	\N	6294
2000-08-28 10:54:20.08	6	1	6288
2000-08-28 10:54:20.08	17917	1	6289
2000-08-28 10:54:20.08	182	\N	6290
2000-08-28 10:54:20.08	860	\N	6291
2000-08-28 10:54:20.08	351	\N	6292
2000-08-28 10:54:20.08	10	\N	6293
2000-08-28 10:54:20.08	20	\N	6294
2000-08-28 10:54:20.12	6	1	6288
2000-08-28 10:54:20.12	17747	1	6289
2000-08-28 10:54:20.12	195	\N	6290
2000-08-28 10:54:20.12	860	\N	6291
2000-08-28 10:54:20.12	358	\N	6292
2000-08-28 10:54:20.12	10	\N	6293
2000-08-28 10:54:20.12	20	\N	6294
2000-08-28 10:54:20.16	6	1	6288
2000-08-28 10:54:20.16	17409	1	6289
2000-08-28 10:54:20.16	209	\N	6290
2000-08-28 10:54:20.16	870	\N	6291
2000-08-28 10:54:20.16	365	\N	6292
2000-08-28 10:54:20.16	10	\N	6293
2000-08-28 10:54:20.16	20	\N	6294
2000-08-28 10:54:20.2	6	1	6288
2000-08-28 10:54:20.2	17240	1	6289
2000-08-28 10:54:20.2	222	\N	6290
2000-08-28 10:54:20.2	870	\N	6291
2000-08-28 10:54:20.2	373	\N	6292
2000-08-28 10:54:20.2	10	\N	6293
2000-08-28 10:54:20.2	20	\N	6294
2000-08-28 10:54:20.24	6	1	6288
2000-08-28 10:54:20.24	16901	1	6289
2000-08-28 10:54:20.24	222	\N	6290
2000-08-28 10:54:20.24	870	\N	6291
2000-08-28 10:54:20.24	373	\N	6292
2000-08-28 10:54:20.24	10	\N	6293
2000-08-28 10:54:20.24	20	\N	6294
2000-08-28 10:54:20.28	6	1	6288
2000-08-28 10:54:20.28	16732	1	6289
2000-08-28 10:54:20.28	235	\N	6290
2000-08-28 10:54:20.28	870	\N	6291
2000-08-28 10:54:20.28	383	\N	6292
2000-08-28 10:54:20.28	10	\N	6293
2000-08-28 10:54:20.28	20	\N	6294
2000-08-28 10:54:20.32	6	1	6288
2000-08-28 10:54:20.32	16393	1	6289
2000-08-28 10:54:20.32	248	\N	6290
2000-08-28 10:54:20.32	870	\N	6291
2000-08-28 10:54:20.32	389	\N	6292
2000-08-28 10:54:20.32	10	\N	6293
2000-08-28 10:54:20.32	20	\N	6294
2000-08-28 10:54:20.36	6	1	6288
2000-08-28 10:54:20.36	16055	1	6289
2000-08-28 10:54:20.36	248	\N	6290
2000-08-28 10:54:20.36	870	\N	6291
2000-08-28 10:54:20.36	389	\N	6292
2000-08-28 10:54:20.36	10	\N	6293
2000-08-28 10:54:20.36	20	\N	6294
2000-08-28 10:54:20.4	6	1	6288
2000-08-28 10:54:20.4	15886	1	6289
2000-08-28 10:54:20.4	261	\N	6290
2000-08-28 10:54:20.4	880	\N	6291
2000-08-28 10:54:20.4	395	\N	6292
2000-08-28 10:54:20.4	10	\N	6293
2000-08-28 10:54:20.4	20	\N	6294
2000-08-28 10:54:20.44	6	1	6288
2000-08-28 10:54:20.44	15547	1	6289
2000-08-28 10:54:20.44	274	\N	6290
2000-08-28 10:54:20.44	880	\N	6291
2000-08-28 10:54:20.44	401	\N	6292
2000-08-28 10:54:20.44	10	\N	6293
2000-08-28 10:54:20.44	20	\N	6294
2000-08-28 10:54:20.48	6	1	6288
2000-08-28 10:54:20.48	15378	1	6289
2000-08-28 10:54:20.48	274	\N	6290
2000-08-28 10:54:20.48	880	\N	6291
2000-08-28 10:54:20.48	401	\N	6292
2000-08-28 10:54:20.48	10	\N	6293
2000-08-28 10:54:20.48	20	\N	6294
2000-08-28 10:54:20.52	6	1	6288
2000-08-28 10:54:20.52	15039	1	6289
2000-08-28 10:54:20.52	287	\N	6290
2000-08-28 10:54:20.52	870	\N	6291
2000-08-28 10:54:20.52	405	\N	6292
2000-08-28 10:54:20.52	10	\N	6293
2000-08-28 10:54:20.52	20	\N	6294
2000-08-28 10:54:20.56	6	1	6288
2000-08-28 10:54:20.56	14870	1	6289
2000-08-28 10:54:20.56	300	\N	6290
2000-08-28 10:54:20.56	880	\N	6291
2000-08-28 10:54:20.56	410	\N	6292
2000-08-28 10:54:20.56	10	\N	6293
2000-08-28 10:54:20.56	20	\N	6294
2000-08-28 10:54:20.6	6	1	6288
2000-08-28 10:54:20.6	14532	1	6289
2000-08-28 10:54:20.6	300	\N	6290
2000-08-28 10:54:20.6	880	\N	6291
2000-08-28 10:54:20.6	410	\N	6292
2000-08-28 10:54:20.6	10	\N	6293
2000-08-28 10:54:20.6	20	\N	6294
2000-08-28 10:54:20.64	6	1	6288
2000-08-28 10:54:20.64	14362	1	6289
2000-08-28 10:54:20.64	300	\N	6290
2000-08-28 10:54:20.64	880	\N	6291
2000-08-28 10:54:20.64	413	\N	6292
2000-08-28 10:54:20.64	10	\N	6293
2000-08-28 10:54:20.64	20	\N	6294
2000-08-28 10:54:20.68	6	1	6288
2000-08-28 10:54:20.68	14024	1	6289
2000-08-28 10:54:20.68	300	\N	6290
2000-08-28 10:54:20.68	880	\N	6291
2000-08-28 10:54:20.68	416	\N	6292
2000-08-28 10:54:20.68	10	\N	6293
2000-08-28 10:54:20.68	20	\N	6294
2000-08-28 10:54:20.72	6	1	6288
2000-08-28 10:54:20.72	13685	1	6289
2000-08-28 10:54:20.72	300	\N	6290
2000-08-28 10:54:20.72	880	\N	6291
2000-08-28 10:54:20.72	419	\N	6292
2000-08-28 10:54:20.72	10	\N	6293
2000-08-28 10:54:20.72	20	\N	6294
2000-08-28 10:54:20.76	6	1	6288
2000-08-28 10:54:20.76	13516	1	6289
2000-08-28 10:54:20.76	300	\N	6290
2000-08-28 10:54:20.76	880	\N	6291
2000-08-28 10:54:20.76	419	\N	6292
2000-08-28 10:54:20.76	10	\N	6293
2000-08-28 10:54:20.76	20	\N	6294
2000-08-28 10:54:20.8	6	1	6288
2000-08-28 10:54:20.8	13178	1	6289
2000-08-28 10:54:20.8	300	\N	6290
2000-08-28 10:54:20.8	880	\N	6291
2000-08-28 10:54:20.8	422	\N	6292
2000-08-28 10:54:20.8	10	\N	6293
2000-08-28 10:54:20.8	20	\N	6294
2000-08-28 10:54:20.84	6	1	6288
2000-08-28 10:54:20.84	13009	1	6289
2000-08-28 10:54:20.84	300	\N	6290
2000-08-28 10:54:20.84	880	\N	6291
2000-08-28 10:54:20.84	425	\N	6292
2000-08-28 10:54:20.84	10	\N	6293
2000-08-28 10:54:20.84	20	\N	6294
2000-08-28 10:54:20.88	6	1	6288
2000-08-28 10:54:20.88	12670	1	6289
2000-08-28 10:54:20.88	300	\N	6290
2000-08-28 10:54:20.88	880	\N	6291
2000-08-28 10:54:20.88	425	\N	6292
2000-08-28 10:54:20.88	10	\N	6293
2000-08-28 10:54:20.88	20	\N	6294
2000-08-28 10:54:20.92	6	1	6288
2000-08-28 10:54:20.92	12501	1	6289
2000-08-28 10:54:20.92	300	\N	6290
2000-08-28 10:54:20.92	880	\N	6291
2000-08-28 10:54:20.92	425	\N	6292
2000-08-28 10:54:20.92	10	\N	6293
2000-08-28 10:54:20.92	20	\N	6294
2000-08-28 10:54:20.96	6	1	6288
2000-08-28 10:54:20.96	12162	1	6289
2000-08-28 10:54:20.96	300	\N	6290
2000-08-28 10:54:20.96	880	\N	6291
2000-08-28 10:54:20.96	429	\N	6292
2000-08-28 10:54:20.96	10	\N	6293
2000-08-28 10:54:20.96	20	\N	6294
2000-08-28 10:54:21	6	1	6288
2000-08-28 10:54:21	11824	1	6289
2000-08-28 10:54:21	300	\N	6290
2000-08-28 10:54:21	880	\N	6291
2000-08-28 10:54:21	429	\N	6292
2000-08-28 10:54:21	10	\N	6293
2000-08-28 10:54:21	20	\N	6294
2000-08-28 10:54:21.04	6	1	6288
2000-08-28 10:54:21.04	11655	1	6289
2000-08-28 10:54:21.04	300	\N	6290
2000-08-28 10:54:21.04	880	\N	6291
2000-08-28 10:54:21.04	429	\N	6292
2000-08-28 10:54:21.04	10	\N	6293
2000-08-28 10:54:21.04	20	\N	6294
2000-08-28 10:54:21.08	6	1	6288
2000-08-28 10:54:21.08	11316	1	6289
2000-08-28 10:54:21.08	300	\N	6290
2000-08-28 10:54:21.08	890	\N	6291
2000-08-28 10:54:21.08	432	\N	6292
2000-08-28 10:54:21.08	10	\N	6293
2000-08-28 10:54:21.08	20	\N	6294
2000-08-28 10:54:21.12	6	1	6288
2000-08-28 10:54:21.12	11147	1	6289
2000-08-28 10:54:21.12	300	\N	6290
2000-08-28 10:54:21.12	890	\N	6291
2000-08-28 10:54:21.12	432	\N	6292
2000-08-28 10:54:21.12	10	\N	6293
2000-08-28 10:54:21.12	20	\N	6294
2000-08-28 10:54:21.16	6	1	6288
2000-08-28 10:54:21.16	10808	1	6289
2000-08-28 10:54:21.16	300	\N	6290
2000-08-28 10:54:21.16	880	\N	6291
2000-08-28 10:54:21.16	432	\N	6292
2000-08-28 10:54:21.16	10	\N	6293
2000-08-28 10:54:21.16	20	\N	6294
2000-08-28 10:54:21.2	6	1	6288
2000-08-28 10:54:21.2	10639	1	6289
2000-08-28 10:54:21.2	300	\N	6290
2000-08-28 10:54:21.2	880	\N	6291
2000-08-28 10:54:21.2	432	\N	6292
2000-08-28 10:54:21.2	10	\N	6293
2000-08-28 10:54:21.2	20	\N	6294
2000-08-28 10:54:21.24	6	1	6288
2000-08-28 10:54:21.24	10301	1	6289
2000-08-28 10:54:21.24	300	\N	6290
2000-08-28 10:54:21.24	880	\N	6291
2000-08-28 10:54:21.24	433	\N	6292
2000-08-28 10:54:21.24	10	\N	6293
2000-08-28 10:54:21.24	20	\N	6294
2000-08-28 10:54:21.28	6	1	6288
2000-08-28 10:54:21.28	10131	1	6289
2000-08-28 10:54:21.28	300	\N	6290
2000-08-28 10:54:21.28	880	\N	6291
2000-08-28 10:54:21.28	433	\N	6292
2000-08-28 10:54:21.28	10	\N	6293
2000-08-28 10:54:21.28	20	\N	6294
2000-08-28 10:54:21.32	6	1	6288
2000-08-28 10:54:21.32	9793	1	6289
2000-08-28 10:54:21.32	300	\N	6290
2000-08-28 10:54:21.32	880	\N	6291
2000-08-28 10:54:21.32	435	\N	6292
2000-08-28 10:54:21.32	10	\N	6293
2000-08-28 10:54:21.32	20	\N	6294
2000-08-28 10:54:21.36	6	1	6288
2000-08-28 10:54:21.36	9454	1	6289
2000-08-28 10:54:21.36	300	\N	6290
2000-08-28 10:54:21.36	870	\N	6291
2000-08-28 10:54:21.36	435	\N	6292
2000-08-28 10:54:21.36	10	\N	6293
2000-08-28 10:54:21.36	20	\N	6294
2000-08-28 10:54:21.4	6	1	6288
2000-08-28 10:54:21.4	9285	1	6289
2000-08-28 10:54:21.4	300	\N	6290
2000-08-28 10:54:21.4	870	\N	6291
2000-08-28 10:54:21.4	435	\N	6292
2000-08-28 10:54:21.4	10	\N	6293
2000-08-28 10:54:21.4	20	\N	6294
2000-08-28 10:54:21.44	6	1	6288
2000-08-28 10:54:21.44	8947	1	6289
2000-08-28 10:54:21.44	300	\N	6290
2000-08-28 10:54:21.44	870	\N	6291
2000-08-28 10:54:21.44	434	\N	6292
2000-08-28 10:54:21.44	10	\N	6293
2000-08-28 10:54:21.44	20	\N	6294
2000-08-28 10:54:21.48	6	1	6288
2000-08-28 10:54:21.48	8777	1	6289
2000-08-28 10:54:21.48	300	\N	6290
2000-08-28 10:54:21.48	870	\N	6291
2000-08-28 10:54:21.48	435	\N	6292
2000-08-28 10:54:21.48	10	\N	6293
2000-08-28 10:54:21.48	20	\N	6294
2000-08-28 10:54:21.52	6	1	6288
2000-08-28 10:54:21.52	8439	1	6289
2000-08-28 10:54:21.52	300	\N	6290
2000-08-28 10:54:21.52	870	\N	6291
2000-08-28 10:54:21.52	435	\N	6292
2000-08-28 10:54:21.52	10	\N	6293
2000-08-28 10:54:21.52	20	\N	6294
2000-08-28 10:54:21.56	6	1	6288
2000-08-28 10:54:21.56	8270	1	6289
2000-08-28 10:54:21.56	300	\N	6290
2000-08-28 10:54:21.56	870	\N	6291
2000-08-28 10:54:21.56	435	\N	6292
2000-08-28 10:54:21.56	10	\N	6293
2000-08-28 10:54:21.56	20	\N	6294
2000-08-28 10:54:21.6	6	1	6288
2000-08-28 10:54:21.6	7931	1	6289
2000-08-28 10:54:21.6	300	\N	6290
2000-08-28 10:54:21.6	870	\N	6291
2000-08-28 10:54:21.6	435	\N	6292
2000-08-28 10:54:21.6	10	\N	6293
2000-08-28 10:54:21.6	20	\N	6294
2000-08-28 10:54:21.64	6	1	6288
2000-08-28 10:54:21.64	7593	1	6289
2000-08-28 10:54:21.64	300	\N	6290
2000-08-28 10:54:21.64	870	\N	6291
2000-08-28 10:54:21.64	435	\N	6292
2000-08-28 10:54:21.64	10	\N	6293
2000-08-28 10:54:21.64	20	\N	6294
2000-08-28 10:54:21.68	6	1	6288
2000-08-28 10:54:21.68	7424	1	6289
2000-08-28 10:54:21.68	300	\N	6290
2000-08-28 10:54:21.68	870	\N	6291
2000-08-28 10:54:21.68	435	\N	6292
2000-08-28 10:54:21.68	10	\N	6293
2000-08-28 10:54:21.68	20	\N	6294
2000-08-28 10:54:21.72	6	1	6288
2000-08-28 10:54:21.72	7085	1	6289
2000-08-28 10:54:21.72	300	\N	6290
2000-08-28 10:54:21.72	870	\N	6291
2000-08-28 10:54:21.72	435	\N	6292
2000-08-28 10:54:21.72	10	\N	6293
2000-08-28 10:54:21.72	20	\N	6294
2000-08-28 10:54:21.76	6	1	6288
2000-08-28 10:54:21.76	6916	1	6289
2000-08-28 10:54:21.76	300	\N	6290
2000-08-28 10:54:21.76	870	\N	6291
2000-08-28 10:54:21.76	435	\N	6292
2000-08-28 10:54:21.76	10	\N	6293
2000-08-28 10:54:21.76	20	\N	6294
2000-08-28 10:54:21.8	6	1	6288
2000-08-28 10:54:21.8	6577	1	6289
2000-08-28 10:54:21.8	300	\N	6290
2000-08-28 10:54:21.8	870	\N	6291
2000-08-28 10:54:21.8	435	\N	6292
2000-08-28 10:54:21.8	10	\N	6293
2000-08-28 10:54:21.8	20	\N	6294
2000-08-28 10:54:21.84	6	1	6288
2000-08-28 10:54:21.84	6408	1	6289
2000-08-28 10:54:21.84	300	\N	6290
2000-08-28 10:54:21.84	870	\N	6291
2000-08-28 10:54:21.84	432	\N	6292
2000-08-28 10:54:21.84	10	\N	6293
2000-08-28 10:54:21.84	20	\N	6294
2000-08-28 10:54:21.88	6	1	6288
2000-08-28 10:54:21.88	6070	1	6289
2000-08-28 10:54:21.88	300	\N	6290
2000-08-28 10:54:21.88	870	\N	6291
2000-08-28 10:54:21.88	432	\N	6292
2000-08-28 10:54:21.88	10	\N	6293
2000-08-28 10:54:21.88	20	\N	6294
2000-08-28 10:54:21.92	6	1	6288
2000-08-28 10:54:21.92	5900	1	6289
2000-08-28 10:54:21.92	300	\N	6290
2000-08-28 10:54:21.92	870	\N	6291
2000-08-28 10:54:21.92	432	\N	6292
2000-08-28 10:54:21.92	10	\N	6293
2000-08-28 10:54:21.92	20	\N	6294
2000-08-28 10:54:21.96	6	1	6288
2000-08-28 10:54:21.96	5562	1	6289
2000-08-28 10:54:21.96	300	\N	6290
2000-08-28 10:54:21.96	860	\N	6291
2000-08-28 10:54:21.96	432	\N	6292
2000-08-28 10:54:21.96	10	\N	6293
2000-08-28 10:54:21.96	20	\N	6294
2000-08-28 10:54:22	6	1	6288
2000-08-28 10:54:22	5223	1	6289
2000-08-28 10:54:22	300	\N	6290
2000-08-28 10:54:22	870	\N	6291
2000-08-28 10:54:22	432	\N	6292
2000-08-28 10:54:22	10	\N	6293
2000-08-28 10:54:22	20	\N	6294
2000-08-28 10:54:22.04	6	1	6288
2000-08-28 10:54:22.04	5054	1	6289
2000-08-28 10:54:22.04	300	\N	6290
2000-08-28 10:54:22.04	870	\N	6291
2000-08-28 10:54:22.04	432	\N	6292
2000-08-28 10:54:22.04	10	\N	6293
2000-08-28 10:54:22.04	20	\N	6294
2000-08-28 10:54:22.08	6	1	6288
2000-08-28 10:54:22.08	4716	1	6289
2000-08-28 10:54:22.08	300	\N	6290
2000-08-28 10:54:22.08	870	\N	6291
2000-08-28 10:54:22.08	432	\N	6292
2000-08-28 10:54:22.08	10	\N	6293
2000-08-28 10:54:22.08	20	\N	6294
2000-08-28 10:54:22.12	6	1	6288
2000-08-28 10:54:22.12	4546	1	6289
2000-08-28 10:54:22.12	300	\N	6290
2000-08-28 10:54:22.12	870	\N	6291
2000-08-28 10:54:22.12	431	\N	6292
2000-08-28 10:54:22.12	10	\N	6293
2000-08-28 10:54:22.12	20	\N	6294
2000-08-28 10:54:22.16	6	1	6288
2000-08-28 10:54:22.16	4208	1	6289
2000-08-28 10:54:22.16	300	\N	6290
2000-08-28 10:54:22.16	870	\N	6291
2000-08-28 10:54:22.16	432	\N	6292
2000-08-28 10:54:22.16	10	\N	6293
2000-08-28 10:54:22.16	20	\N	6294
2000-08-28 10:54:22.2	6	1	6288
2000-08-28 10:54:22.2	4039	1	6289
2000-08-28 10:54:22.2	300	\N	6290
2000-08-28 10:54:22.2	870	\N	6291
2000-08-28 10:54:22.2	432	\N	6292
2000-08-28 10:54:22.2	10	\N	6293
2000-08-28 10:54:22.2	20	\N	6294
2000-08-28 10:54:22.24	6	1	6288
2000-08-28 10:54:22.24	3700	1	6289
2000-08-28 10:54:22.24	300	\N	6290
2000-08-28 10:54:22.24	870	\N	6291
2000-08-28 10:54:22.24	432	\N	6292
2000-08-28 10:54:22.24	10	\N	6293
2000-08-28 10:54:22.24	20	\N	6294
2000-08-28 10:54:22.28	6	1	6288
2000-08-28 10:54:22.28	3362	1	6289
2000-08-28 10:54:22.28	300	\N	6290
2000-08-28 10:54:22.28	870	\N	6291
2000-08-28 10:54:22.28	432	\N	6292
2000-08-28 10:54:22.28	10	\N	6293
2000-08-28 10:54:22.28	20	\N	6294
2000-08-28 10:54:22.32	6	1	6288
2000-08-28 10:54:22.32	3192	1	6289
2000-08-28 10:54:22.32	300	\N	6290
2000-08-28 10:54:22.32	870	\N	6291
2000-08-28 10:54:22.32	432	\N	6292
2000-08-28 10:54:22.32	10	\N	6293
2000-08-28 10:54:22.32	20	\N	6294
2000-08-28 10:54:22.36	6	1	6288
2000-08-28 10:54:22.36	2854	1	6289
2000-08-28 10:54:22.36	300	\N	6290
2000-08-28 10:54:22.36	870	\N	6291
2000-08-28 10:54:22.36	429	\N	6292
2000-08-28 10:54:22.36	10	\N	6293
2000-08-28 10:54:22.36	20	\N	6294
2000-08-28 10:54:22.4	6	1	6288
2000-08-28 10:54:22.4	2685	1	6289
2000-08-28 10:54:22.4	300	\N	6290
2000-08-28 10:54:22.4	880	\N	6291
2000-08-28 10:54:22.4	429	\N	6292
2000-08-28 10:54:22.4	10	\N	6293
2000-08-28 10:54:22.4	20	\N	6294
2000-08-28 10:54:22.44	6	1	6288
2000-08-28 10:54:22.44	2346	1	6289
2000-08-28 10:54:22.44	300	\N	6290
2000-08-28 10:54:22.44	880	\N	6291
2000-08-28 10:54:22.44	429	\N	6292
2000-08-28 10:54:22.44	10	\N	6293
2000-08-28 10:54:22.44	20	\N	6294
2000-08-28 10:54:22.48	6	1	6288
2000-08-28 10:54:22.48	2177	1	6289
2000-08-28 10:54:22.48	300	\N	6290
2000-08-28 10:54:22.48	880	\N	6291
2000-08-28 10:54:22.48	429	\N	6292
2000-08-28 10:54:22.48	10	\N	6293
2000-08-28 10:54:22.48	20	\N	6294
2000-08-28 10:54:22.52	6	1	6288
2000-08-28 10:54:22.52	1838	1	6289
2000-08-28 10:54:22.52	300	\N	6290
2000-08-28 10:54:22.52	880	\N	6291
2000-08-28 10:54:22.52	428	\N	6292
2000-08-28 10:54:22.52	10	\N	6293
2000-08-28 10:54:22.52	20	\N	6294
2000-08-28 10:54:22.56	6	1	6288
2000-08-28 10:54:22.56	1500	1	6289
2000-08-28 10:54:22.56	300	\N	6290
2000-08-28 10:54:22.56	880	\N	6291
2000-08-28 10:54:22.56	429	\N	6292
2000-08-28 10:54:22.56	10	\N	6293
2000-08-28 10:54:22.56	20	\N	6294
2000-08-28 10:54:22.6	6	1	6288
2000-08-28 10:54:22.6	1331	1	6289
2000-08-28 10:54:22.6	300	\N	6290
2000-08-28 10:54:22.6	880	\N	6291
2000-08-28 10:54:22.6	429	\N	6292
2000-08-28 10:54:22.6	10	\N	6293
2000-08-28 10:54:22.6	20	\N	6294
2000-08-28 10:54:22.64	6	1	6288
2000-08-28 10:54:22.64	992	1	6289
2000-08-28 10:54:22.64	300	\N	6290
2000-08-28 10:54:22.64	880	\N	6291
2000-08-28 10:54:22.64	429	\N	6292
2000-08-28 10:54:22.64	10	\N	6293
2000-08-28 10:54:22.64	20	\N	6294
2000-08-28 10:54:22.68	6	1	6288
2000-08-28 10:54:22.68	823	1	6289
2000-08-28 10:54:22.68	300	\N	6290
2000-08-28 10:54:22.68	870	\N	6291
2000-08-28 10:54:22.68	429	\N	6292
2000-08-28 10:54:22.68	10	\N	6293
2000-08-28 10:54:22.68	20	\N	6294
2000-08-28 10:54:22.72	6	1	6288
2000-08-28 10:54:22.72	485	1	6289
2000-08-28 10:54:22.72	300	\N	6290
2000-08-28 10:54:22.72	870	\N	6291
2000-08-28 10:54:22.72	429	\N	6292
2000-08-28 10:54:22.72	10	\N	6293
2000-08-28 10:54:22.72	20	\N	6294
2000-08-28 10:54:22.76	6	1	6288
2000-08-28 10:54:22.76	315	1	6289
2000-08-28 10:54:22.76	300	\N	6290
2000-08-28 10:54:22.76	870	\N	6291
2000-08-28 10:54:22.76	429	\N	6292
2000-08-28 10:54:22.76	10	\N	6293
2000-08-28 10:54:22.76	20	\N	6294
2000-08-28 10:54:22.8	6	1	6288
2000-08-28 10:54:22.8	-22	1	6289
2000-08-28 10:54:22.8	300	\N	6290
2000-08-28 10:54:22.8	870	\N	6291
2000-08-28 10:54:22.8	432	\N	6292
2000-08-28 10:54:22.8	10	\N	6293
2000-08-28 10:54:22.8	20	\N	6294
2000-08-28 10:54:22.84	6	1	6288
2000-08-28 10:54:22.84	-192	1	6289
2000-08-28 10:54:22.84	300	\N	6290
2000-08-28 10:54:22.84	870	\N	6291
2000-08-28 10:54:22.84	432	\N	6292
2000-08-28 10:54:22.84	10	\N	6293
2000-08-28 10:54:22.84	20	\N	6294
2000-08-28 10:54:22.88	6	1	6288
2000-08-28 10:54:22.88	-530	1	6289
2000-08-28 10:54:22.88	300	\N	6290
2000-08-28 10:54:22.88	870	\N	6291
2000-08-28 10:54:22.88	432	\N	6292
2000-08-28 10:54:22.88	10	\N	6293
2000-08-28 10:54:22.88	20	\N	6294
2000-08-28 10:54:22.92	6	1	6288
2000-08-28 10:54:22.92	-869	1	6289
2000-08-28 10:54:22.92	300	\N	6290
2000-08-28 10:54:22.92	870	\N	6291
2000-08-28 10:54:22.92	432	\N	6292
2000-08-28 10:54:22.92	10	\N	6293
2000-08-28 10:54:22.92	20	\N	6294
2000-08-28 10:54:22.96	6	1	6288
2000-08-28 10:54:22.96	-1038	1	6289
2000-08-28 10:54:22.96	300	\N	6290
2000-08-28 10:54:22.96	870	\N	6291
2000-08-28 10:54:22.96	432	\N	6292
2000-08-28 10:54:22.96	10	\N	6293
2000-08-28 10:54:22.96	20	\N	6294
2000-08-28 10:54:23	6	1	6288
2000-08-28 10:54:23	-1376	1	6289
2000-08-28 10:54:23	300	\N	6290
2000-08-28 10:54:23	870	\N	6291
2000-08-28 10:54:23	431	\N	6292
2000-08-28 10:54:23	10	\N	6293
2000-08-28 10:54:23	20	\N	6294
2000-08-28 10:54:23.04	6	1	6288
2000-08-28 10:54:23.04	-1545	1	6289
2000-08-28 10:54:23.04	300	\N	6290
2000-08-28 10:54:23.04	870	\N	6291
2000-08-28 10:54:23.04	432	\N	6292
2000-08-28 10:54:23.04	10	\N	6293
2000-08-28 10:54:23.04	20	\N	6294
2000-08-28 10:54:23.08	6	1	6288
2000-08-28 10:54:23.08	-1884	1	6289
2000-08-28 10:54:23.08	300	\N	6290
2000-08-28 10:54:23.08	870	\N	6291
2000-08-28 10:54:23.08	432	\N	6292
2000-08-28 10:54:23.08	10	\N	6293
2000-08-28 10:54:23.08	20	\N	6294
2000-08-28 10:54:23.12	6	1	6288
2000-08-28 10:54:23.12	-2053	1	6289
2000-08-28 10:54:23.12	300	\N	6290
2000-08-28 10:54:23.12	870	\N	6291
2000-08-28 10:54:23.12	432	\N	6292
2000-08-28 10:54:23.12	10	\N	6293
2000-08-28 10:54:23.12	20	\N	6294
2000-08-28 10:54:23.16	6	1	6288
2000-08-28 10:54:23.16	-2392	1	6289
2000-08-28 10:54:23.16	300	\N	6290
2000-08-28 10:54:23.16	870	\N	6291
2000-08-28 10:54:23.16	432	\N	6292
2000-08-28 10:54:23.16	10	\N	6293
2000-08-28 10:54:23.16	20	\N	6294
2000-08-28 10:54:23.2	6	1	6288
2000-08-28 10:54:23.2	-2730	1	6289
2000-08-28 10:54:23.2	300	\N	6290
2000-08-28 10:54:23.2	870	\N	6291
2000-08-28 10:54:23.2	432	\N	6292
2000-08-28 10:54:23.2	10	\N	6293
2000-08-28 10:54:23.2	20	\N	6294
2000-08-28 10:54:23.24	6	1	6288
2000-08-28 10:54:23.24	-2899	1	6289
2000-08-28 10:54:23.24	300	\N	6290
2000-08-28 10:54:23.24	870	\N	6291
2000-08-28 10:54:23.24	432	\N	6292
2000-08-28 10:54:23.24	10	\N	6293
2000-08-28 10:54:23.24	20	\N	6294
2000-08-28 10:54:23.28	6	1	6288
2000-08-28 10:54:23.28	-3238	1	6289
2000-08-28 10:54:23.28	300	\N	6290
2000-08-28 10:54:23.28	870	\N	6291
2000-08-28 10:54:23.28	432	\N	6292
2000-08-28 10:54:23.28	10	\N	6293
2000-08-28 10:54:23.28	20	\N	6294
2000-08-28 10:54:23.32	6	1	6288
2000-08-28 10:54:23.32	-3407	1	6289
2000-08-28 10:54:23.32	300	\N	6290
2000-08-28 10:54:23.32	870	\N	6291
2000-08-28 10:54:23.32	431	\N	6292
2000-08-28 10:54:23.32	10	\N	6293
2000-08-28 10:54:23.32	20	\N	6294
2000-08-28 10:54:23.36	6	1	6288
2000-08-28 10:54:23.36	-3746	1	6289
2000-08-28 10:54:23.36	300	\N	6290
2000-08-28 10:54:23.36	870	\N	6291
2000-08-28 10:54:23.36	431	\N	6292
2000-08-28 10:54:23.36	10	\N	6293
2000-08-28 10:54:23.36	20	\N	6294
2000-08-28 10:54:23.4	6	1	6288
2000-08-28 10:54:23.4	-3915	1	6289
2000-08-28 10:54:23.4	300	\N	6290
2000-08-28 10:54:23.4	870	\N	6291
2000-08-28 10:54:23.4	432	\N	6292
2000-08-28 10:54:23.4	10	\N	6293
2000-08-28 10:54:23.4	20	\N	6294
2000-08-28 10:54:23.44	6	1	6288
2000-08-28 10:54:23.44	-4253	1	6289
2000-08-28 10:54:23.44	300	\N	6290
2000-08-28 10:54:23.44	870	\N	6291
2000-08-28 10:54:23.44	432	\N	6292
2000-08-28 10:54:23.44	10	\N	6293
2000-08-28 10:54:23.44	20	\N	6294
2000-08-28 10:54:23.48	6	1	6288
2000-08-28 10:54:23.48	-4423	1	6289
2000-08-28 10:54:23.48	300	\N	6290
2000-08-28 10:54:23.48	870	\N	6291
2000-08-28 10:54:23.48	432	\N	6292
2000-08-28 10:54:23.48	10	\N	6293
2000-08-28 10:54:23.48	20	\N	6294
2000-08-28 10:54:23.52	6	1	6288
2000-08-28 10:54:23.52	-4761	1	6289
2000-08-28 10:54:23.52	300	\N	6290
2000-08-28 10:54:23.52	870	\N	6291
2000-08-28 10:54:23.52	432	\N	6292
2000-08-28 10:54:23.52	10	\N	6293
2000-08-28 10:54:23.52	20	\N	6294
2000-08-28 10:54:23.56	6	1	6288
2000-08-28 10:54:23.56	-5100	1	6289
2000-08-28 10:54:23.56	300	\N	6290
2000-08-28 10:54:23.56	870	\N	6291
2000-08-28 10:54:23.56	432	\N	6292
2000-08-28 10:54:23.56	10	\N	6293
2000-08-28 10:54:23.56	20	\N	6294
2000-08-28 10:54:23.6	6	1	6288
2000-08-28 10:54:23.6	-5269	1	6289
2000-08-28 10:54:23.6	300	\N	6290
2000-08-28 10:54:23.6	870	\N	6291
2000-08-28 10:54:23.6	432	\N	6292
2000-08-28 10:54:23.6	10	\N	6293
2000-08-28 10:54:23.6	20	\N	6294
2000-08-28 10:54:23.64	6	1	6288
2000-08-28 10:54:23.64	-5607	1	6289
2000-08-28 10:54:23.64	300	\N	6290
2000-08-28 10:54:23.64	870	\N	6291
2000-08-28 10:54:23.64	432	\N	6292
2000-08-28 10:54:23.64	10	\N	6293
2000-08-28 10:54:23.64	20	\N	6294
2000-08-28 10:54:23.68	6	1	6288
2000-08-28 10:54:23.68	-5777	1	6289
2000-08-28 10:54:23.68	300	\N	6290
2000-08-28 10:54:23.68	880	\N	6291
2000-08-28 10:54:23.68	432	\N	6292
2000-08-28 10:54:23.68	10	\N	6293
2000-08-28 10:54:23.68	20	\N	6294
2000-08-28 10:54:23.72	6	1	6288
2000-08-28 10:54:23.72	-6115	1	6289
2000-08-28 10:54:23.72	300	\N	6290
2000-08-28 10:54:23.72	870	\N	6291
2000-08-28 10:54:23.72	432	\N	6292
2000-08-28 10:54:23.72	10	\N	6293
2000-08-28 10:54:23.72	20	\N	6294
2000-08-28 10:54:23.76	6	1	6288
2000-08-28 10:54:23.76	-6284	1	6289
2000-08-28 10:54:23.76	300	\N	6290
2000-08-28 10:54:23.76	870	\N	6291
2000-08-28 10:54:23.76	432	\N	6292
2000-08-28 10:54:23.76	10	\N	6293
2000-08-28 10:54:23.76	20	\N	6294
2000-08-28 10:54:23.8	6	1	6288
2000-08-28 10:54:23.8	-6623	1	6289
2000-08-28 10:54:23.8	300	\N	6290
2000-08-28 10:54:23.8	870	\N	6291
2000-08-28 10:54:23.8	432	\N	6292
2000-08-28 10:54:23.8	10	\N	6293
2000-08-28 10:54:23.8	20	\N	6294
2000-08-28 10:54:23.84	6	1	6288
2000-08-28 10:54:23.84	-6792	1	6289
2000-08-28 10:54:23.84	300	\N	6290
2000-08-28 10:54:23.84	880	\N	6291
2000-08-28 10:54:23.84	432	\N	6292
2000-08-28 10:54:23.84	10	\N	6293
2000-08-28 10:54:23.84	20	\N	6294
2000-08-28 10:54:23.88	6	1	6288
2000-08-28 10:54:23.88	-7130	1	6289
2000-08-28 10:54:23.88	300	\N	6290
2000-08-28 10:54:23.88	880	\N	6291
2000-08-28 10:54:23.88	432	\N	6292
2000-08-28 10:54:23.88	10	\N	6293
2000-08-28 10:54:23.88	20	\N	6294
2000-08-28 10:54:23.92	6	1	6288
2000-08-28 10:54:23.92	-7469	1	6289
2000-08-28 10:54:23.92	300	\N	6290
2000-08-28 10:54:23.92	880	\N	6291
2000-08-28 10:54:23.92	432	\N	6292
2000-08-28 10:54:23.92	10	\N	6293
2000-08-28 10:54:23.92	20	\N	6294
2000-08-28 10:54:23.96	6	1	6288
2000-08-28 10:54:23.96	-7638	1	6289
2000-08-28 10:54:23.96	300	\N	6290
2000-08-28 10:54:23.96	880	\N	6291
2000-08-28 10:54:23.96	432	\N	6292
2000-08-28 10:54:23.96	10	\N	6293
2000-08-28 10:54:23.96	20	\N	6294
2000-08-28 10:54:24	6	1	6288
2000-08-28 10:54:24	-7977	1	6289
2000-08-28 10:54:24	300	\N	6290
2000-08-28 10:54:24	880	\N	6291
2000-08-28 10:54:24	432	\N	6292
2000-08-28 10:54:24	10	\N	6293
2000-08-28 10:54:24	20	\N	6294
2000-08-28 10:54:24.04	6	1	6288
2000-08-28 10:54:24.04	-8146	1	6289
2000-08-28 10:54:24.04	300	\N	6290
2000-08-28 10:54:24.04	880	\N	6291
2000-08-28 10:54:24.04	432	\N	6292
2000-08-28 10:54:24.04	10	\N	6293
2000-08-28 10:54:24.04	20	\N	6294
2000-08-28 10:54:24.08	6	1	6288
2000-08-28 10:54:24.08	-8484	1	6289
2000-08-28 10:54:24.08	300	\N	6290
2000-08-28 10:54:24.08	870	\N	6291
2000-08-28 10:54:24.08	432	\N	6292
2000-08-28 10:54:24.08	10	\N	6293
2000-08-28 10:54:24.08	20	\N	6294
2000-08-28 10:54:24.12	6	1	6288
2000-08-28 10:54:24.12	-8654	1	6289
2000-08-28 10:54:24.12	300	\N	6290
2000-08-28 10:54:24.12	870	\N	6291
2000-08-28 10:54:24.12	432	\N	6292
2000-08-28 10:54:24.12	10	\N	6293
2000-08-28 10:54:24.12	20	\N	6294
2000-08-28 10:54:24.16	6	1	6288
2000-08-28 10:54:24.16	-8992	1	6289
2000-08-28 10:54:24.16	300	\N	6290
2000-08-28 10:54:24.16	870	\N	6291
2000-08-28 10:54:24.16	432	\N	6292
2000-08-28 10:54:24.16	10	\N	6293
2000-08-28 10:54:24.16	20	\N	6294
2000-08-28 10:54:24.2	6	1	6288
2000-08-28 10:54:24.2	-9331	1	6289
2000-08-28 10:54:24.2	300	\N	6290
2000-08-28 10:54:24.2	860	\N	6291
2000-08-28 10:54:24.2	432	\N	6292
2000-08-28 10:54:24.2	10	\N	6293
2000-08-28 10:54:24.2	20	\N	6294
2000-08-28 10:54:24.24	6	1	6288
2000-08-28 10:54:24.24	-9500	1	6289
2000-08-28 10:54:24.24	300	\N	6290
2000-08-28 10:54:24.24	840	\N	6291
2000-08-28 10:54:24.24	432	\N	6292
2000-08-28 10:54:24.24	10	\N	6293
2000-08-28 10:54:24.24	20	\N	6294
2000-08-28 10:54:24.28	6	1	6288
2000-08-28 10:54:24.28	-9838	1	6289
2000-08-28 10:54:24.28	300	\N	6290
2000-08-28 10:54:24.28	840	\N	6291
2000-08-28 10:54:24.28	432	\N	6292
2000-08-28 10:54:24.28	10	\N	6293
2000-08-28 10:54:24.28	20	\N	6294
2000-08-28 10:54:24.32	6	1	6288
2000-08-28 10:54:24.32	-10008	1	6289
2000-08-28 10:54:24.32	300	\N	6290
2000-08-28 10:54:24.32	830	\N	6291
2000-08-28 10:54:24.32	432	\N	6292
2000-08-28 10:54:24.32	10	\N	6293
2000-08-28 10:54:24.32	20	\N	6294
2000-08-28 10:54:24.36	6	1	6288
2000-08-28 10:54:24.36	-10346	1	6289
2000-08-28 10:54:24.36	300	\N	6290
2000-08-28 10:54:24.36	800	\N	6291
2000-08-28 10:54:24.36	432	\N	6292
2000-08-28 10:54:24.36	10	\N	6293
2000-08-28 10:54:24.36	20	\N	6294
2000-08-28 10:54:24.4	6	1	6288
2000-08-28 10:54:24.4	-10515	1	6289
2000-08-28 10:54:24.4	300	\N	6290
2000-08-28 10:54:24.4	800	\N	6291
2000-08-28 10:54:24.4	432	\N	6292
2000-08-28 10:54:24.4	10	\N	6293
2000-08-28 10:54:24.4	20	\N	6294
2000-08-28 10:54:24.44	6	1	6288
2000-08-28 10:54:24.44	-10854	1	6289
2000-08-28 10:54:24.44	300	\N	6290
2000-08-28 10:54:24.44	780	\N	6291
2000-08-28 10:54:24.44	432	\N	6292
2000-08-28 10:54:24.44	10	\N	6293
2000-08-28 10:54:24.44	20	\N	6294
2000-08-28 10:54:24.48	6	1	6288
2000-08-28 10:54:24.48	-11023	1	6289
2000-08-28 10:54:24.48	300	\N	6290
2000-08-28 10:54:24.48	750	\N	6291
2000-08-28 10:54:24.48	429	\N	6292
2000-08-28 10:54:24.48	10	\N	6293
2000-08-28 10:54:24.48	20	\N	6294
2000-08-28 10:54:24.52	6	1	6288
2000-08-28 10:54:24.52	-11362	1	6289
2000-08-28 10:54:24.52	300	\N	6290
2000-08-28 10:54:24.52	720	\N	6291
2000-08-28 10:54:24.52	429	\N	6292
2000-08-28 10:54:24.52	10	\N	6293
2000-08-28 10:54:24.52	20	\N	6294
2000-08-28 10:54:24.56	6	1	6288
2000-08-28 10:54:24.56	-11700	1	6289
2000-08-28 10:54:24.56	300	\N	6290
2000-08-28 10:54:24.56	720	\N	6291
2000-08-28 10:54:24.56	429	\N	6292
2000-08-28 10:54:24.56	10	\N	6293
2000-08-28 10:54:24.56	20	\N	6294
2000-08-28 10:54:24.6	6	1	6288
2000-08-28 10:54:24.6	-11869	1	6289
2000-08-28 10:54:24.6	300	\N	6290
2000-08-28 10:54:24.6	690	\N	6291
2000-08-28 10:54:24.6	427	\N	6292
2000-08-28 10:54:24.6	10	\N	6293
2000-08-28 10:54:24.6	20	\N	6294
2000-08-28 10:54:24.64	6	1	6288
2000-08-28 10:54:24.64	-12208	1	6289
2000-08-28 10:54:24.64	300	\N	6290
2000-08-28 10:54:24.64	660	\N	6291
2000-08-28 10:54:24.64	425	\N	6292
2000-08-28 10:54:24.64	10	\N	6293
2000-08-28 10:54:24.64	20	\N	6294
2000-08-28 10:54:24.68	6	1	6288
2000-08-28 10:54:24.68	-12377	1	6289
2000-08-28 10:54:24.68	300	\N	6290
2000-08-28 10:54:24.68	660	\N	6291
2000-08-28 10:54:24.68	425	\N	6292
2000-08-28 10:54:24.68	10	\N	6293
2000-08-28 10:54:24.68	20	\N	6294
2000-08-28 10:54:24.72	6	1	6288
2000-08-28 10:54:24.72	-12716	1	6289
2000-08-28 10:54:24.72	300	\N	6290
2000-08-28 10:54:24.72	630	\N	6291
2000-08-28 10:54:24.72	422	\N	6292
2000-08-28 10:54:24.72	10	\N	6293
2000-08-28 10:54:24.72	20	\N	6294
2000-08-28 10:54:24.76	6	1	6288
2000-08-28 10:54:24.76	-12885	1	6289
2000-08-28 10:54:24.76	300	\N	6290
2000-08-28 10:54:24.76	600	\N	6291
2000-08-28 10:54:24.76	419	\N	6292
2000-08-28 10:54:24.76	10	\N	6293
2000-08-28 10:54:24.76	20	\N	6294
2000-08-28 10:54:24.8	6	1	6288
2000-08-28 10:54:24.8	-13223	1	6289
2000-08-28 10:54:24.8	300	\N	6290
2000-08-28 10:54:24.8	600	\N	6291
2000-08-28 10:54:24.8	419	\N	6292
2000-08-28 10:54:24.8	10	\N	6293
2000-08-28 10:54:24.8	20	\N	6294
2000-08-28 10:54:24.84	6	1	6288
2000-08-28 10:54:24.84	-13562	1	6289
2000-08-28 10:54:24.84	300	\N	6290
2000-08-28 10:54:24.84	570	\N	6291
2000-08-28 10:54:24.84	417	\N	6292
2000-08-28 10:54:24.84	10	\N	6293
2000-08-28 10:54:24.84	20	\N	6294
2000-08-28 10:54:24.88	6	1	6288
2000-08-28 10:54:24.88	-13731	1	6289
2000-08-28 10:54:24.88	300	\N	6290
2000-08-28 10:54:24.88	540	\N	6291
2000-08-28 10:54:24.88	413	\N	6292
2000-08-28 10:54:24.88	10	\N	6293
2000-08-28 10:54:24.88	20	\N	6294
2000-08-28 10:54:24.92	6	1	6288
2000-08-28 10:54:24.92	-14069	1	6289
2000-08-28 10:54:24.92	300	\N	6290
2000-08-28 10:54:24.92	540	\N	6291
2000-08-28 10:54:24.92	413	\N	6292
2000-08-28 10:54:24.92	10	\N	6293
2000-08-28 10:54:24.92	20	\N	6294
2000-08-28 10:54:24.96	6	1	6288
2000-08-28 10:54:24.96	-14239	1	6289
2000-08-28 10:54:24.96	300	\N	6290
2000-08-28 10:54:24.96	500	\N	6291
2000-08-28 10:54:24.96	411	\N	6292
2000-08-28 10:54:24.96	10	\N	6293
2000-08-28 10:54:24.96	20	\N	6294
2000-08-28 10:54:25	6	1	6288
2000-08-28 10:54:25	-14577	1	6289
2000-08-28 10:54:25	300	\N	6290
2000-08-28 10:54:25	480	\N	6291
2000-08-28 10:54:25	406	\N	6292
2000-08-28 10:54:25	10	\N	6293
2000-08-28 10:54:25	20	\N	6294
2000-08-28 10:54:25.04	6	1	6288
2000-08-28 10:54:25.04	-14746	1	6289
2000-08-28 10:54:25.04	300	\N	6290
2000-08-28 10:54:25.04	440	\N	6291
2000-08-28 10:54:25.04	401	\N	6292
2000-08-28 10:54:25.04	10	\N	6293
2000-08-28 10:54:25.04	20	\N	6294
2000-08-28 10:54:25.08	6	1	6288
2000-08-28 10:54:25.08	-15085	1	6289
2000-08-28 10:54:25.08	300	\N	6290
2000-08-28 10:54:25.08	440	\N	6291
2000-08-28 10:54:25.08	401	\N	6292
2000-08-28 10:54:25.08	10	\N	6293
2000-08-28 10:54:25.08	20	\N	6294
2000-08-28 10:54:25.12	6	1	6288
2000-08-28 10:54:25.12	-15254	1	6289
2000-08-28 10:54:25.12	300	\N	6290
2000-08-28 10:54:25.12	420	\N	6291
2000-08-28 10:54:25.12	396	\N	6292
2000-08-28 10:54:25.12	10	\N	6293
2000-08-28 10:54:25.12	20	\N	6294
2000-08-28 10:54:25.16	6	1	6288
2000-08-28 10:54:25.16	-15593	1	6289
2000-08-28 10:54:25.16	300	\N	6290
2000-08-28 10:54:25.16	390	\N	6291
2000-08-28 10:54:25.16	390	\N	6292
2000-08-28 10:54:25.16	10	\N	6293
2000-08-28 10:54:25.16	20	\N	6294
2000-08-28 10:54:25.2	6	1	6288
2000-08-28 10:54:25.2	-15931	1	6289
2000-08-28 10:54:25.2	300	\N	6290
2000-08-28 10:54:25.2	390	\N	6291
2000-08-28 10:54:25.2	390	\N	6292
2000-08-28 10:54:25.2	10	\N	6293
2000-08-28 10:54:25.2	20	\N	6294
2000-08-28 10:54:25.24	6	1	6288
2000-08-28 10:54:25.24	-16100	1	6289
2000-08-28 10:54:25.24	300	\N	6290
2000-08-28 10:54:25.24	360	\N	6291
2000-08-28 10:54:25.24	384	\N	6292
2000-08-28 10:54:25.24	10	\N	6293
2000-08-28 10:54:25.24	20	\N	6294
2000-08-28 10:54:25.28	6	1	6288
2000-08-28 10:54:25.28	-16439	1	6289
2000-08-28 10:54:25.28	300	\N	6290
2000-08-28 10:54:25.28	280	\N	6291
2000-08-28 10:54:25.28	377	\N	6292
2000-08-28 10:54:25.28	10	\N	6293
2000-08-28 10:54:25.28	20	\N	6294
2000-08-28 10:54:25.32	6	1	6288
2000-08-28 10:54:25.32	-16608	1	6289
2000-08-28 10:54:25.32	300	\N	6290
2000-08-28 10:54:25.32	280	\N	6291
2000-08-28 10:54:25.32	377	\N	6292
2000-08-28 10:54:25.32	10	\N	6293
2000-08-28 10:54:25.32	20	\N	6294
2000-08-28 10:54:25.36	6	1	6288
2000-08-28 10:54:25.36	-16947	1	6289
2000-08-28 10:54:25.36	300	\N	6290
2000-08-28 10:54:25.36	150	\N	6291
2000-08-28 10:54:25.36	371	\N	6292
2000-08-28 10:54:25.36	10	\N	6293
2000-08-28 10:54:25.36	20	\N	6294
2000-08-28 10:54:25.4	6	1	6288
2000-08-28 10:54:25.4	-17116	1	6289
2000-08-28 10:54:25.4	300	\N	6290
2000-08-28 10:54:25.4	50	\N	6291
2000-08-28 10:54:25.4	362	\N	6292
2000-08-28 10:54:25.4	10	\N	6293
2000-08-28 10:54:25.4	20	\N	6294
2000-08-28 10:54:25.44	6	1	6288
2000-08-28 10:54:25.44	-17454	1	6289
2000-08-28 10:54:25.44	300	\N	6290
2000-08-28 10:54:25.44	50	\N	6291
2000-08-28 10:54:25.44	362	\N	6292
2000-08-28 10:54:25.44	10	\N	6293
2000-08-28 10:54:25.44	20	\N	6294
2000-08-28 10:54:25.48	6	1	6288
2000-08-28 10:54:25.48	-17793	1	6289
2000-08-28 10:54:25.48	300	\N	6290
2000-08-28 10:54:25.48	0	\N	6291
2000-08-28 10:54:25.48	356	\N	6292
2000-08-28 10:54:25.48	10	\N	6293
2000-08-28 10:54:25.48	20	\N	6294
2000-08-28 10:54:25.52	6	1	6288
2000-08-28 10:54:25.52	-17962	1	6289
2000-08-28 10:54:25.52	300	\N	6290
2000-08-28 10:54:25.52	0	\N	6291
2000-08-28 10:54:25.52	347	\N	6292
2000-08-28 10:54:25.52	10	\N	6293
2000-08-28 10:54:25.52	20	\N	6294
2000-08-28 10:54:25.56	6	1	6288
2000-08-28 10:54:25.56	-18301	1	6289
2000-08-28 10:54:25.56	300	\N	6290
2000-08-28 10:54:25.56	0	\N	6291
2000-08-28 10:54:25.56	340	\N	6292
2000-08-28 10:54:25.56	10	\N	6293
2000-08-28 10:54:25.56	20	\N	6294
2000-08-28 10:54:25.6	6	1	6288
2000-08-28 10:54:25.6	-18470	1	6289
2000-08-28 10:54:25.6	300	\N	6290
2000-08-28 10:54:25.6	0	\N	6291
2000-08-28 10:54:25.6	340	\N	6292
2000-08-28 10:54:25.6	10	\N	6293
2000-08-28 10:54:25.6	20	\N	6294
2000-08-28 10:54:25.64	6	1	6288
2000-08-28 10:54:25.64	-18808	1	6289
2000-08-28 10:54:25.64	300	\N	6290
2000-08-28 10:54:25.64	0	\N	6291
2000-08-28 10:54:25.64	329	\N	6292
2000-08-28 10:54:25.64	10	\N	6293
2000-08-28 10:54:25.64	20	\N	6294
2000-08-28 10:54:25.68	6	1	6288
2000-08-28 10:54:25.68	-18978	1	6289
2000-08-28 10:54:25.68	297	\N	6290
2000-08-28 10:54:25.68	0	\N	6291
2000-08-28 10:54:25.68	320	\N	6292
2000-08-28 10:54:25.68	10	\N	6293
2000-08-28 10:54:25.68	20	\N	6294
2000-08-28 10:54:25.72	6	1	6288
2000-08-28 10:54:25.72	-19316	1	6289
2000-08-28 10:54:25.72	297	\N	6290
2000-08-28 10:54:25.72	0	\N	6291
2000-08-28 10:54:25.72	320	\N	6292
2000-08-28 10:54:25.72	10	\N	6293
2000-08-28 10:54:25.72	20	\N	6294
2000-08-28 10:54:25.76	6	1	6288
2000-08-28 10:54:25.76	-19485	1	6289
2000-08-28 10:54:25.76	285	\N	6290
2000-08-28 10:54:25.76	0	\N	6291
2000-08-28 10:54:25.76	311	\N	6292
2000-08-28 10:54:25.76	10	\N	6293
2000-08-28 10:54:25.76	20	\N	6294
2000-08-28 10:54:25.8	6	1	6288
2000-08-28 10:54:25.8	-19824	1	6289
2000-08-28 10:54:25.8	273	\N	6290
2000-08-28 10:54:25.8	0	\N	6291
2000-08-28 10:54:25.8	302	\N	6292
2000-08-28 10:54:25.8	10	\N	6293
2000-08-28 10:54:25.8	20	\N	6294
2000-08-28 10:54:25.84	6	1	6288
2000-08-28 10:54:25.84	-20162	1	6289
2000-08-28 10:54:25.84	273	\N	6290
2000-08-28 10:54:25.84	0	\N	6291
2000-08-28 10:54:25.84	302	\N	6292
2000-08-28 10:54:25.84	10	\N	6293
2000-08-28 10:54:25.84	20	\N	6294
2000-08-28 10:54:25.88	6	1	6288
2000-08-28 10:54:25.88	-20331	1	6289
2000-08-28 10:54:25.88	261	\N	6290
2000-08-28 10:54:25.88	0	\N	6291
2000-08-28 10:54:25.88	291	\N	6292
2000-08-28 10:54:25.88	10	\N	6293
2000-08-28 10:54:25.88	20	\N	6294
2000-08-28 10:54:25.92	6	1	6288
2000-08-28 10:54:25.92	-20670	1	6289
2000-08-28 10:54:25.92	249	\N	6290
2000-08-28 10:54:25.92	0	\N	6291
2000-08-28 10:54:25.92	282	\N	6292
2000-08-28 10:54:25.92	10	\N	6293
2000-08-28 10:54:25.92	20	\N	6294
2000-08-28 10:54:25.96	6	1	6288
2000-08-28 10:54:25.96	-20839	1	6289
2000-08-28 10:54:25.96	237	\N	6290
2000-08-28 10:54:25.96	0	\N	6291
2000-08-28 10:54:25.96	272	\N	6292
2000-08-28 10:54:25.96	10	\N	6293
2000-08-28 10:54:25.96	20	\N	6294
2000-08-28 10:54:26	6	1	6288
2000-08-28 10:54:26	-21178	1	6289
2000-08-28 10:54:26	237	\N	6290
2000-08-28 10:54:26	0	\N	6291
2000-08-28 10:54:26	272	\N	6292
2000-08-28 10:54:26	10	\N	6293
2000-08-28 10:54:26	20	\N	6294
2000-08-28 10:54:26.04	6	1	6288
2000-08-28 10:54:26.04	-21347	1	6289
2000-08-28 10:54:26.04	225	\N	6290
2000-08-28 10:54:26.04	0	\N	6291
2000-08-28 10:54:26.04	261	\N	6292
2000-08-28 10:54:26.04	10	\N	6293
2000-08-28 10:54:26.04	20	\N	6294
2000-08-28 10:54:26.08	6	1	6288
2000-08-28 10:54:26.08	-21685	1	6289
2000-08-28 10:54:26.08	213	\N	6290
2000-08-28 10:54:26.08	0	\N	6291
2000-08-28 10:54:26.08	252	\N	6292
2000-08-28 10:54:26.08	10	\N	6293
2000-08-28 10:54:26.08	20	\N	6294
2000-08-28 10:54:26.12	6	1	6288
2000-08-28 10:54:26.12	-22024	1	6289
2000-08-28 10:54:26.12	213	\N	6290
2000-08-28 10:54:26.12	0	\N	6291
2000-08-28 10:54:26.12	252	\N	6292
2000-08-28 10:54:26.12	10	\N	6293
2000-08-28 10:54:26.12	20	\N	6294
2000-08-28 10:54:26.16	6	1	6288
2000-08-28 10:54:26.16	-22193	1	6289
2000-08-28 10:54:26.16	201	\N	6290
2000-08-28 10:54:26.16	0	\N	6291
2000-08-28 10:54:26.16	245	\N	6292
2000-08-28 10:54:26.16	10	\N	6293
2000-08-28 10:54:26.16	20	\N	6294
2000-08-28 10:54:26.2	6	1	6288
2000-08-28 10:54:26.2	-22532	1	6289
2000-08-28 10:54:26.2	0	\N	6290
2000-08-28 10:54:26.2	0	\N	6291
2000-08-28 10:54:26.2	237	\N	6292
2000-08-28 10:54:26.2	10	\N	6293
2000-08-28 10:54:26.2	20	\N	6294
2000-08-28 10:54:26.24	6	1	6288
2000-08-28 10:54:26.24	-22701	1	6289
2000-08-28 10:54:26.24	0	\N	6290
2000-08-28 10:54:26.24	0	\N	6291
2000-08-28 10:54:26.24	237	\N	6292
2000-08-28 10:54:26.24	10	\N	6293
2000-08-28 10:54:26.24	20	\N	6294
2000-08-28 10:54:26.28	6	1	6288
2000-08-28 10:54:26.28	-23000	1	6289
2000-08-28 10:54:26.28	0	\N	6290
2000-08-28 10:54:26.28	10	\N	6291
2000-08-28 10:54:26.28	232	\N	6292
2000-08-28 10:54:26.28	10	\N	6293
2000-08-28 10:54:26.28	20	\N	6294
2000-08-28 10:54:26.32	6	1	6288
2000-08-28 10:54:26.32	-23000	1	6289
2000-08-28 10:54:26.32	0	\N	6290
2000-08-28 10:54:26.32	10	\N	6291
2000-08-28 10:54:26.32	224	\N	6292
2000-08-28 10:54:26.32	10	\N	6293
2000-08-28 10:54:26.32	20	\N	6294
2000-08-28 10:54:26.36	6	1	6288
2000-08-28 10:54:26.36	-23000	1	6289
2000-08-28 10:54:26.36	0	\N	6290
2000-08-28 10:54:26.36	10	\N	6291
2000-08-28 10:54:26.36	224	\N	6292
2000-08-28 10:54:26.36	10	\N	6293
2000-08-28 10:54:26.36	20	\N	6294
2000-08-28 10:54:26.4	6	1	6288
2000-08-28 10:54:26.4	-23000	1	6289
2000-08-28 10:54:26.4	0	\N	6290
2000-08-28 10:54:26.4	10	\N	6291
2000-08-28 10:54:26.4	220	\N	6292
2000-08-28 10:54:26.4	10	\N	6293
2000-08-28 10:54:26.4	20	\N	6294
2000-08-28 10:54:26.44	6	1	6288
2000-08-28 10:54:26.44	-23000	1	6289
2000-08-28 10:54:26.44	0	\N	6290
2000-08-28 10:54:26.44	20	\N	6291
2000-08-28 10:54:26.44	214	\N	6292
2000-08-28 10:54:26.44	10	\N	6293
2000-08-28 10:54:26.44	20	\N	6294
2000-08-28 10:54:26.48	6	1	6288
2000-08-28 10:54:26.48	-23000	1	6289
2000-08-28 10:54:26.48	0	\N	6290
2000-08-28 10:54:26.48	10	\N	6291
2000-08-28 10:54:26.48	211	\N	6292
2000-08-28 10:54:26.48	10	\N	6293
2000-08-28 10:54:26.48	20	\N	6294
2000-08-28 10:54:26.52	6	1	6288
2000-08-28 10:54:26.52	-23000	1	6289
2000-08-28 10:54:26.52	0	\N	6290
2000-08-28 10:54:26.52	10	\N	6291
2000-08-28 10:54:26.52	211	\N	6292
2000-08-28 10:54:26.52	10	\N	6293
2000-08-28 10:54:26.52	20	\N	6294
2000-08-28 10:54:26.56	6	1	6288
2000-08-28 10:54:26.56	-23000	1	6289
2000-08-28 10:54:26.56	0	\N	6290
2000-08-28 10:54:26.56	0	\N	6291
2000-08-28 10:54:26.56	208	\N	6292
2000-08-28 10:54:26.56	10	\N	6293
2000-08-28 10:54:26.56	20	\N	6294
2000-08-28 10:54:26.6	0	1	6288
2000-08-28 10:54:26.6	-23000	1	6289
2000-08-28 10:54:26.6	0	\N	6290
2000-08-28 10:54:26.6	20	\N	6291
2000-08-28 10:54:26.6	205	\N	6292
2000-08-28 10:54:26.6	10	\N	6293
2000-08-28 10:54:26.6	20	\N	6294
2000-08-28 10:54:26.64	0	1	6288
2000-08-28 10:54:26.64	-23000	1	6289
2000-08-28 10:54:26.64	0	\N	6290
2000-08-28 10:54:26.64	20	\N	6291
2000-08-28 10:54:26.64	205	\N	6292
2000-08-28 10:54:26.64	10	\N	6293
2000-08-28 10:54:26.64	20	\N	6294
2000-08-28 10:54:26.68	0	1	6288
2000-08-28 10:54:26.68	-23000	1	6289
2000-08-28 10:54:26.68	0	\N	6290
2000-08-28 10:54:26.68	10	\N	6291
2000-08-28 10:54:26.68	202	\N	6292
2000-08-28 10:54:26.68	10	\N	6293
2000-08-28 10:54:26.68	20	\N	6294
2000-08-28 10:54:26.72	0	1	6288
2000-08-28 10:54:26.72	-23000	1	6289
2000-08-28 10:54:26.72	0	\N	6290
2000-08-28 10:54:26.72	0	\N	6291
2000-08-28 10:54:26.72	199	\N	6292
2000-08-28 10:54:26.72	10	\N	6293
2000-08-28 10:54:26.72	20	\N	6294
2000-08-28 10:54:26.76	0	1	6288
2000-08-28 10:54:26.76	-23000	1	6289
2000-08-28 10:54:26.76	0	\N	6290
2000-08-28 10:54:26.76	0	\N	6291
2000-08-28 10:54:26.76	199	\N	6292
2000-08-28 10:54:26.76	10	\N	6293
2000-08-28 10:54:26.76	20	\N	6294
2000-08-28 10:54:26.8	0	1	6288
2000-08-28 10:54:26.8	-23000	1	6289
2000-08-28 10:54:26.8	0	\N	6290
2000-08-28 10:54:26.8	10	\N	6291
2000-08-28 10:54:26.8	198	\N	6292
2000-08-28 10:54:26.8	10	\N	6293
2000-08-28 10:54:26.8	20	\N	6294
2000-08-28 10:54:26.84	0	1	6288
2000-08-28 10:54:26.84	-23000	1	6289
2000-08-28 10:54:26.84	0	\N	6290
2000-08-28 10:54:26.84	0	\N	6291
2000-08-28 10:54:26.84	195	\N	6292
2000-08-28 10:54:26.84	10	\N	6293
2000-08-28 10:54:26.84	20	\N	6294
2000-08-28 10:54:26.88	0	1	6288
2000-08-28 10:54:26.88	-23000	1	6289
2000-08-28 10:54:26.88	0	\N	6290
2000-08-28 10:54:26.88	0	\N	6291
2000-08-28 10:54:26.88	195	\N	6292
2000-08-28 10:54:26.88	10	\N	6293
2000-08-28 10:54:26.88	20	\N	6294
2000-08-28 10:54:26.92	0	1	6288
2000-08-28 10:54:26.92	-23000	1	6289
2000-08-28 10:54:26.92	0	\N	6290
2000-08-28 10:54:26.92	0	\N	6291
2000-08-28 10:54:26.92	195	\N	6292
2000-08-28 10:54:26.92	10	\N	6293
2000-08-28 10:54:26.92	20	\N	6294
2000-08-28 10:54:26.96	0	1	6288
2000-08-28 10:54:26.96	-23000	1	6289
2000-08-28 10:54:26.96	0	\N	6290
2000-08-28 10:54:26.96	0	\N	6291
2000-08-28 10:54:26.96	194	\N	6292
2000-08-28 10:54:26.96	10	\N	6293
2000-08-28 10:54:26.96	20	\N	6294
2000-08-28 10:54:27	0	1	6288
2000-08-28 10:54:27	-23000	1	6289
2000-08-28 10:54:27	0	\N	6290
2000-08-28 10:54:27	0	\N	6291
2000-08-28 10:54:27	192	\N	6292
2000-08-28 10:54:27	10	\N	6293
2000-08-28 10:54:27	20	\N	6294
2000-08-28 10:54:27.04	0	1	6288
2000-08-28 10:54:27.04	-23000	1	6289
2000-08-28 10:54:27.04	0	\N	6290
2000-08-28 10:54:27.04	0	\N	6291
2000-08-28 10:54:27.04	192	\N	6292
2000-08-28 10:54:27.04	10	\N	6293
2000-08-28 10:54:27.04	20	\N	6294
2000-08-28 10:54:27.08	0	1	6288
2000-08-28 10:54:27.08	-23000	1	6289
2000-08-28 10:54:27.08	0	\N	6290
2000-08-28 10:54:27.08	0	\N	6291
2000-08-28 10:54:27.08	192	\N	6292
2000-08-28 10:54:27.08	10	\N	6293
2000-08-28 10:54:27.08	20	\N	6294
2000-08-28 10:54:27.12	0	1	6288
2000-08-28 10:54:27.12	-23000	1	6289
2000-08-28 10:54:27.12	0	\N	6290
2000-08-28 10:54:27.12	0	\N	6291
2000-08-28 10:54:27.12	192	\N	6292
2000-08-28 10:54:27.12	10	\N	6293
2000-08-28 10:54:27.12	20	\N	6294
2000-08-28 10:54:27.16	0	1	6288
2000-08-28 10:54:27.16	-23000	1	6289
2000-08-28 10:54:27.16	0	\N	6290
2000-08-28 10:54:27.16	0	\N	6291
2000-08-28 10:54:27.16	192	\N	6292
2000-08-28 10:54:27.16	10	\N	6293
2000-08-28 10:54:27.16	20	\N	6294
2000-08-28 10:54:27.2	0	1	6288
2000-08-28 10:54:27.2	-23000	1	6289
2000-08-28 10:54:27.2	0	\N	6290
2000-08-28 10:54:27.2	10	\N	6291
2000-08-28 10:54:27.2	192	\N	6292
2000-08-28 10:54:27.2	10	\N	6293
2000-08-28 10:54:27.2	20	\N	6294
2000-08-28 10:54:27.24	0	1	6288
2000-08-28 10:54:27.24	-23000	1	6289
2000-08-28 10:54:27.24	0	\N	6290
2000-08-28 10:54:27.24	10	\N	6291
2000-08-28 10:54:27.24	189	\N	6292
2000-08-28 10:54:27.24	10	\N	6293
2000-08-28 10:54:27.24	20	\N	6294
2000-08-28 10:54:27.28	0	1	6288
2000-08-28 10:54:27.28	-23000	1	6289
2000-08-28 10:54:27.28	0	\N	6290
2000-08-28 10:54:27.28	10	\N	6291
2000-08-28 10:54:27.28	189	\N	6292
2000-08-28 10:54:27.28	10	\N	6293
2000-08-28 10:54:27.28	20	\N	6294
2000-08-28 10:54:27.32	0	1	6288
2000-08-28 10:54:27.32	-23000	1	6289
2000-08-28 10:54:27.32	0	\N	6290
2000-08-28 10:54:27.32	10	\N	6291
2000-08-28 10:54:27.32	189	\N	6292
2000-08-28 10:54:27.32	10	\N	6293
2000-08-28 10:54:27.32	20	\N	6294
2000-08-28 10:54:27.36	0	1	6288
2000-08-28 10:54:27.36	-23000	1	6289
2000-08-28 10:54:27.36	0	\N	6290
2000-08-28 10:54:27.36	10	\N	6291
2000-08-28 10:54:27.36	189	\N	6292
2000-08-28 10:54:27.36	10	\N	6293
2000-08-28 10:54:27.36	20	\N	6294
2000-08-28 10:54:27.4	0	1	6288
2000-08-28 10:54:27.4	-23000	1	6289
2000-08-28 10:54:27.4	0	\N	6290
2000-08-28 10:54:27.4	10	\N	6291
2000-08-28 10:54:27.4	189	\N	6292
2000-08-28 10:54:27.4	10	\N	6293
2000-08-28 10:54:27.4	20	\N	6294
2000-08-28 10:54:27.44	0	1	6288
2000-08-28 10:54:27.44	-23000	1	6289
2000-08-28 10:54:27.44	0	\N	6290
2000-08-28 10:54:27.44	10	\N	6291
2000-08-28 10:54:27.44	189	\N	6292
2000-08-28 10:54:27.44	10	\N	6293
2000-08-28 10:54:27.44	20	\N	6294
2000-08-28 10:54:27.48	0	1	6288
2000-08-28 10:54:27.48	-23000	1	6289
2000-08-28 10:54:27.48	0	\N	6290
2000-08-28 10:54:27.48	10	\N	6291
2000-08-28 10:54:27.48	189	\N	6292
2000-08-28 10:54:27.48	10	\N	6293
2000-08-28 10:54:27.48	20	\N	6294
2000-08-28 10:54:27.52	0	1	6288
2000-08-28 10:54:27.52	-23000	1	6289
2000-08-28 10:54:27.52	0	\N	6290
2000-08-28 10:54:27.52	0	\N	6291
2000-08-28 10:54:27.52	190	\N	6292
2000-08-28 10:54:27.52	10	\N	6293
2000-08-28 10:54:27.52	20	\N	6294
2000-08-28 10:54:27.56	0	1	6288
2000-08-28 10:54:27.56	-23000	1	6289
2000-08-28 10:54:27.56	0	\N	6290
2000-08-28 10:54:27.56	0	\N	6291
2000-08-28 10:54:27.56	190	\N	6292
2000-08-28 10:54:27.56	10	\N	6293
2000-08-28 10:54:27.56	20	\N	6294
2000-08-28 10:54:27.6	0	1	6288
2000-08-28 10:54:27.6	-22808	1	6289
2000-08-28 10:54:27.6	0	\N	6290
2000-08-28 10:54:27.6	0	\N	6291
2000-08-28 10:54:27.6	189	\N	6292
2000-08-28 10:54:27.6	10	\N	6293
2000-08-28 10:54:27.6	20	\N	6294
2000-08-28 10:54:27.64	0	1	6288
2000-08-28 10:54:27.64	-22193	1	6289
2000-08-28 10:54:27.64	0	\N	6290
2000-08-28 10:54:27.64	10	\N	6291
2000-08-28 10:54:27.64	190	\N	6292
2000-08-28 10:54:27.64	10	\N	6293
2000-08-28 10:54:27.64	20	\N	6294
2000-08-28 10:54:27.68	0	1	6288
2000-08-28 10:54:27.68	-21886	1	6289
2000-08-28 10:54:27.68	0	\N	6290
2000-08-28 10:54:27.68	10	\N	6291
2000-08-28 10:54:27.68	190	\N	6292
2000-08-28 10:54:27.68	10	\N	6293
2000-08-28 10:54:27.68	20	\N	6294
2000-08-28 10:54:27.72	0	1	6288
2000-08-28 10:54:27.72	-21272	1	6289
2000-08-28 10:54:27.72	0	\N	6290
2000-08-28 10:54:27.72	20	\N	6291
2000-08-28 10:54:27.72	189	\N	6292
2000-08-28 10:54:27.72	10	\N	6293
2000-08-28 10:54:27.72	20	\N	6294
2000-08-28 10:54:27.76	0	1	6288
2000-08-28 10:54:27.76	-20657	1	6289
2000-08-28 10:54:27.76	0	\N	6290
2000-08-28 10:54:27.76	10	\N	6291
2000-08-28 10:54:27.76	189	\N	6292
2000-08-28 10:54:27.76	10	\N	6293
2000-08-28 10:54:27.76	20	\N	6294
2000-08-28 10:54:27.8	0	1	6288
2000-08-28 10:54:27.8	-20350	1	6289
2000-08-28 10:54:27.8	0	\N	6290
2000-08-28 10:54:27.8	10	\N	6291
2000-08-28 10:54:27.8	189	\N	6292
2000-08-28 10:54:27.8	10	\N	6293
2000-08-28 10:54:27.8	20	\N	6294
2000-08-28 10:54:27.84	0	1	6288
2000-08-28 10:54:27.84	-19736	1	6289
2000-08-28 10:54:27.84	0	\N	6290
2000-08-28 10:54:27.84	0	\N	6291
2000-08-28 10:54:27.84	189	\N	6292
2000-08-28 10:54:27.84	10	\N	6293
2000-08-28 10:54:27.84	20	\N	6294
2000-08-28 10:54:27.88	0	1	6288
2000-08-28 10:54:27.88	-19428	1	6289
2000-08-28 10:54:27.88	0	\N	6290
2000-08-28 10:54:27.88	0	\N	6291
2000-08-28 10:54:27.88	189	\N	6292
2000-08-28 10:54:27.88	10	\N	6293
2000-08-28 10:54:27.88	20	\N	6294
2000-08-28 10:54:27.92	0	1	6288
2000-08-28 10:54:27.92	-18814	1	6289
2000-08-28 10:54:27.92	0	\N	6290
2000-08-28 10:54:27.92	40	\N	6291
2000-08-28 10:54:27.92	189	\N	6292
2000-08-28 10:54:27.92	10	\N	6293
2000-08-28 10:54:27.92	20	\N	6294
2000-08-28 10:54:27.96	0	1	6288
2000-08-28 10:54:27.96	-18507	1	6289
2000-08-28 10:54:27.96	0	\N	6290
2000-08-28 10:54:27.96	40	\N	6291
2000-08-28 10:54:27.96	189	\N	6292
2000-08-28 10:54:27.96	10	\N	6293
2000-08-28 10:54:27.96	20	\N	6294
2000-08-28 10:54:28	0	1	6288
2000-08-28 10:54:28	-17892	1	6289
2000-08-28 10:54:28	0	\N	6290
2000-08-28 10:54:28	0	\N	6291
2000-08-28 10:54:28	189	\N	6292
2000-08-28 10:54:28	10	\N	6293
2000-08-28 10:54:28	20	\N	6294
2000-08-28 10:54:28.04	0	1	6288
2000-08-28 10:54:28.04	-17278	1	6289
2000-08-28 10:54:28.04	0	\N	6290
2000-08-28 10:54:28.04	0	\N	6291
2000-08-28 10:54:28.04	190	\N	6292
2000-08-28 10:54:28.04	10	\N	6293
2000-08-28 10:54:28.04	20	\N	6294
2000-08-28 10:54:28.08	0	1	6288
2000-08-28 10:54:28.08	-16971	1	6289
2000-08-28 10:54:28.08	0	\N	6290
2000-08-28 10:54:28.08	0	\N	6291
2000-08-28 10:54:28.08	190	\N	6292
2000-08-28 10:54:28.08	10	\N	6293
2000-08-28 10:54:28.08	20	\N	6294
2000-08-28 10:54:28.12	0	1	6288
2000-08-28 10:54:28.12	-16356	1	6289
2000-08-28 10:54:28.12	0	\N	6290
2000-08-28 10:54:28.12	40	\N	6291
2000-08-28 10:54:28.12	189	\N	6292
2000-08-28 10:54:28.12	10	\N	6293
2000-08-28 10:54:28.12	20	\N	6294
2000-08-28 10:54:28.16	0	1	6288
2000-08-28 10:54:28.16	-16049	1	6289
2000-08-28 10:54:28.16	0	\N	6290
2000-08-28 10:54:28.16	0	\N	6291
2000-08-28 10:54:28.16	189	\N	6292
2000-08-28 10:54:28.16	10	\N	6293
2000-08-28 10:54:28.16	20	\N	6294
2000-08-28 10:54:28.2	0	1	6288
2000-08-28 10:54:28.2	-15435	1	6289
2000-08-28 10:54:28.2	0	\N	6290
2000-08-28 10:54:28.2	0	\N	6291
2000-08-28 10:54:28.2	189	\N	6292
2000-08-28 10:54:28.2	10	\N	6293
2000-08-28 10:54:28.2	20	\N	6294
2000-08-28 10:54:28.24	0	1	6288
2000-08-28 10:54:28.24	-15128	1	6289
2000-08-28 10:54:28.24	0	\N	6290
2000-08-28 10:54:28.24	0	\N	6291
2000-08-28 10:54:28.24	190	\N	6292
2000-08-28 10:54:28.24	10	\N	6293
2000-08-28 10:54:28.24	20	\N	6294
2000-08-28 10:54:28.28	0	1	6288
2000-08-28 10:54:28.28	-14513	1	6289
2000-08-28 10:54:28.28	0	\N	6290
2000-08-28 10:54:28.28	20	\N	6291
2000-08-28 10:54:28.28	189	\N	6292
2000-08-28 10:54:28.28	10	\N	6293
2000-08-28 10:54:28.28	20	\N	6294
2000-08-28 10:54:28.32	0	1	6288
2000-08-28 10:54:28.32	-14206	1	6289
2000-08-28 10:54:28.32	0	\N	6290
2000-08-28 10:54:28.32	20	\N	6291
2000-08-28 10:54:28.32	189	\N	6292
2000-08-28 10:54:28.32	10	\N	6293
2000-08-28 10:54:28.32	20	\N	6294
2000-08-28 10:54:28.36	0	1	6288
2000-08-28 10:54:28.36	-13592	1	6289
2000-08-28 10:54:28.36	0	\N	6290
2000-08-28 10:54:28.36	0	\N	6291
2000-08-28 10:54:28.36	189	\N	6292
2000-08-28 10:54:28.36	10	\N	6293
2000-08-28 10:54:28.36	20	\N	6294
2000-08-28 10:54:28.4	0	1	6288
2000-08-28 10:54:28.4	-12977	1	6289
2000-08-28 10:54:28.4	0	\N	6290
2000-08-28 10:54:28.4	0	\N	6291
2000-08-28 10:54:28.4	190	\N	6292
2000-08-28 10:54:28.4	10	\N	6293
2000-08-28 10:54:28.4	20	\N	6294
2000-08-28 10:54:28.44	0	1	6288
2000-08-28 10:54:28.44	-12670	1	6289
2000-08-28 10:54:28.44	0	\N	6290
2000-08-28 10:54:28.44	20	\N	6291
2000-08-28 10:54:28.44	189	\N	6292
2000-08-28 10:54:28.44	10	\N	6293
2000-08-28 10:54:28.44	20	\N	6294
2000-08-28 10:54:28.48	0	1	6288
2000-08-28 10:54:28.48	-12056	1	6289
2000-08-28 10:54:28.48	0	\N	6290
2000-08-28 10:54:28.48	20	\N	6291
2000-08-28 10:54:28.48	189	\N	6292
2000-08-28 10:54:28.48	10	\N	6293
2000-08-28 10:54:28.48	20	\N	6294
2000-08-28 10:54:28.52	0	1	6288
2000-08-28 10:54:28.52	-11748	1	6289
2000-08-28 10:54:28.52	0	\N	6290
2000-08-28 10:54:28.52	0	\N	6291
2000-08-28 10:54:28.52	189	\N	6292
2000-08-28 10:54:28.52	10	\N	6293
2000-08-28 10:54:28.52	20	\N	6294
2000-08-28 10:54:28.56	0	1	6288
2000-08-28 10:54:28.56	-11134	1	6289
2000-08-28 10:54:28.56	0	\N	6290
2000-08-28 10:54:28.56	10	\N	6291
2000-08-28 10:54:28.56	189	\N	6292
2000-08-28 10:54:28.56	10	\N	6293
2000-08-28 10:54:28.56	20	\N	6294
2000-08-28 10:54:28.6	0	1	6288
2000-08-28 10:54:28.6	-10827	1	6289
2000-08-28 10:54:28.6	0	\N	6290
2000-08-28 10:54:28.6	10	\N	6291
2000-08-28 10:54:28.6	189	\N	6292
2000-08-28 10:54:28.6	10	\N	6293
2000-08-28 10:54:28.6	20	\N	6294
2000-08-28 10:54:28.64	0	1	6288
2000-08-28 10:54:28.64	-10212	1	6289
2000-08-28 10:54:28.64	0	\N	6290
2000-08-28 10:54:28.64	10	\N	6291
2000-08-28 10:54:28.64	189	\N	6292
2000-08-28 10:54:28.64	10	\N	6293
2000-08-28 10:54:28.64	20	\N	6294
2000-08-28 10:54:28.68	0	1	6288
2000-08-28 10:54:28.68	-9598	1	6289
2000-08-28 10:54:28.68	0	\N	6290
2000-08-28 10:54:28.68	0	\N	6291
2000-08-28 10:54:28.68	189	\N	6292
2000-08-28 10:54:28.68	10	\N	6293
2000-08-28 10:54:28.68	20	\N	6294
2000-08-28 10:54:28.72	0	1	6288
2000-08-28 10:54:28.72	-9291	1	6289
2000-08-28 10:54:28.72	0	\N	6290
2000-08-28 10:54:28.72	0	\N	6291
2000-08-28 10:54:28.72	189	\N	6292
2000-08-28 10:54:28.72	10	\N	6293
2000-08-28 10:54:28.72	20	\N	6294
2000-08-28 10:54:28.76	0	1	6288
2000-08-28 10:54:28.76	-8676	1	6289
2000-08-28 10:54:28.76	0	\N	6290
2000-08-28 10:54:28.76	10	\N	6291
2000-08-28 10:54:28.76	189	\N	6292
2000-08-28 10:54:28.76	10	\N	6293
2000-08-28 10:54:28.76	20	\N	6294
2000-08-28 10:54:28.8	0	1	6288
2000-08-28 10:54:28.8	-8369	1	6289
2000-08-28 10:54:28.8	0	\N	6290
2000-08-28 10:54:28.8	10	\N	6291
2000-08-28 10:54:28.8	189	\N	6292
2000-08-28 10:54:28.8	10	\N	6293
2000-08-28 10:54:28.8	20	\N	6294
2000-08-28 10:54:28.84	0	1	6288
2000-08-28 10:54:28.84	-7755	1	6289
2000-08-28 10:54:28.84	0	\N	6290
2000-08-28 10:54:28.84	0	\N	6291
2000-08-28 10:54:28.84	189	\N	6292
2000-08-28 10:54:28.84	10	\N	6293
2000-08-28 10:54:28.84	20	\N	6294
2000-08-28 10:54:28.88	0	1	6288
2000-08-28 10:54:28.88	-7448	1	6289
2000-08-28 10:54:28.88	0	\N	6290
2000-08-28 10:54:28.88	0	\N	6291
2000-08-28 10:54:28.88	189	\N	6292
2000-08-28 10:54:28.88	10	\N	6293
2000-08-28 10:54:28.88	20	\N	6294
2000-08-28 10:54:28.92	0	1	6288
2000-08-28 10:54:28.92	-6833	1	6289
2000-08-28 10:54:28.92	0	\N	6290
2000-08-28 10:54:28.92	10	\N	6291
2000-08-28 10:54:28.92	189	\N	6292
2000-08-28 10:54:28.92	10	\N	6293
2000-08-28 10:54:28.92	20	\N	6294
2000-08-28 10:54:28.96	0	1	6288
2000-08-28 10:54:28.96	-6526	1	6289
2000-08-28 10:54:28.96	0	\N	6290
2000-08-28 10:54:28.96	0	\N	6291
2000-08-28 10:54:28.96	189	\N	6292
2000-08-28 10:54:28.96	10	\N	6293
2000-08-28 10:54:28.96	20	\N	6294
2000-08-28 10:54:29	0	1	6288
2000-08-28 10:54:29	-5912	1	6289
2000-08-28 10:54:29	0	\N	6290
2000-08-28 10:54:29	0	\N	6291
2000-08-28 10:54:29	189	\N	6292
2000-08-28 10:54:29	10	\N	6293
2000-08-28 10:54:29	20	\N	6294
2000-08-28 10:54:29.04	0	1	6288
2000-08-28 10:54:29.04	-5297	1	6289
2000-08-28 10:54:29.04	0	\N	6290
2000-08-28 10:54:29.04	0	\N	6291
2000-08-28 10:54:29.04	189	\N	6292
2000-08-28 10:54:29.04	10	\N	6293
2000-08-28 10:54:29.04	20	\N	6294
2000-08-28 10:54:29.08	0	1	6288
2000-08-28 10:54:29.08	-4990	1	6289
2000-08-28 10:54:29.08	0	\N	6290
2000-08-28 10:54:29.08	10	\N	6291
2000-08-28 10:54:29.08	189	\N	6292
2000-08-28 10:54:29.08	10	\N	6293
2000-08-28 10:54:29.08	20	\N	6294
2000-08-28 10:54:29.12	0	1	6288
2000-08-28 10:54:29.12	-4376	1	6289
2000-08-28 10:54:29.12	0	\N	6290
2000-08-28 10:54:29.12	10	\N	6291
2000-08-28 10:54:29.12	189	\N	6292
2000-08-28 10:54:29.12	10	\N	6293
2000-08-28 10:54:29.12	20	\N	6294
2000-08-28 10:54:29.16	0	1	6288
2000-08-28 10:54:29.16	-4068	1	6289
2000-08-28 10:54:29.16	0	\N	6290
2000-08-28 10:54:29.16	0	\N	6291
2000-08-28 10:54:29.16	189	\N	6292
2000-08-28 10:54:29.16	10	\N	6293
2000-08-28 10:54:29.16	20	\N	6294
2000-08-28 10:54:29.2	0	1	6288
2000-08-28 10:54:29.2	-3454	1	6289
2000-08-28 10:54:29.2	0	\N	6290
2000-08-28 10:54:29.2	10	\N	6291
2000-08-28 10:54:29.2	189	\N	6292
2000-08-28 10:54:29.2	10	\N	6293
2000-08-28 10:54:29.2	20	\N	6294
2000-08-28 10:54:29.24	0	1	6288
2000-08-28 10:54:29.24	-3147	1	6289
2000-08-28 10:54:29.24	0	\N	6290
2000-08-28 10:54:29.24	10	\N	6291
2000-08-28 10:54:29.24	189	\N	6292
2000-08-28 10:54:29.24	10	\N	6293
2000-08-28 10:54:29.24	20	\N	6294
2000-08-28 10:54:29.28	0	1	6288
2000-08-28 10:54:29.28	-2532	1	6289
2000-08-28 10:54:29.28	0	\N	6290
2000-08-28 10:54:29.28	10	\N	6291
2000-08-28 10:54:29.28	189	\N	6292
2000-08-28 10:54:29.28	10	\N	6293
2000-08-28 10:54:29.28	20	\N	6294
2000-08-28 10:54:29.32	0	1	6288
2000-08-28 10:54:29.32	-2225	1	6289
2000-08-28 10:54:29.32	0	\N	6290
2000-08-28 10:54:29.32	0	\N	6291
2000-08-28 10:54:29.32	189	\N	6292
2000-08-28 10:54:29.32	10	\N	6293
2000-08-28 10:54:29.32	20	\N	6294
2000-08-28 10:54:29.36	0	1	6288
2000-08-28 10:54:29.36	-1611	1	6289
2000-08-28 10:54:29.36	0	\N	6290
2000-08-28 10:54:29.36	0	\N	6291
2000-08-28 10:54:29.36	190	\N	6292
2000-08-28 10:54:29.36	10	\N	6293
2000-08-28 10:54:29.36	20	\N	6294
2000-08-28 10:54:29.4	0	1	6288
2000-08-28 10:54:29.4	-996	1	6289
2000-08-28 10:54:29.4	0	\N	6290
2000-08-28 10:54:29.4	0	\N	6291
2000-08-28 10:54:29.4	190	\N	6292
2000-08-28 10:54:29.4	10	\N	6293
2000-08-28 10:54:29.4	20	\N	6294
2000-08-28 10:54:29.44	0	1	6288
2000-08-28 10:54:29.44	-689	1	6289
2000-08-28 10:54:29.44	0	\N	6290
2000-08-28 10:54:29.44	10	\N	6291
2000-08-28 10:54:29.44	189	\N	6292
2000-08-28 10:54:29.44	10	\N	6293
2000-08-28 10:54:29.44	20	\N	6294
2000-08-28 10:54:29.48	0	1	6288
2000-08-28 10:54:29.48	-75	1	6289
2000-08-28 10:54:29.48	0	\N	6290
2000-08-28 10:54:29.48	0	\N	6291
2000-08-28 10:54:29.48	189	\N	6292
2000-08-28 10:54:29.48	10	\N	6293
2000-08-28 10:54:29.48	20	\N	6294
2000-08-28 10:54:29.52	0	1	6288
2000-08-28 10:54:29.52	0	1	6289
2000-08-28 10:54:29.52	0	\N	6290
2000-08-28 10:54:29.52	0	\N	6291
2000-08-28 10:54:29.52	189	\N	6292
2000-08-28 10:54:29.52	10	\N	6293
2000-08-28 10:54:29.52	20	\N	6294
2000-08-28 10:54:29.56	0	1	6288
2000-08-28 10:54:29.56	0	1	6289
2000-08-28 10:54:29.56	0	\N	6290
2000-08-28 10:54:29.56	10	\N	6291
2000-08-28 10:54:29.56	189	\N	6292
2000-08-28 10:54:29.56	10	\N	6293
2000-08-28 10:54:29.56	20	\N	6294
2000-08-28 10:54:29.6	0	1	6288
2000-08-28 10:54:29.6	0	1	6289
2000-08-28 10:54:29.6	0	\N	6290
2000-08-28 10:54:29.6	20	\N	6291
2000-08-28 10:54:29.6	189	\N	6292
2000-08-28 10:54:29.6	10	\N	6293
2000-08-28 10:54:29.6	20	\N	6294
2000-08-28 10:54:29.64	0	1	6288
2000-08-28 10:54:29.64	0	1	6289
2000-08-28 10:54:29.64	0	\N	6290
2000-08-28 10:54:29.64	20	\N	6291
2000-08-28 10:54:29.64	189	\N	6292
2000-08-28 10:54:29.64	10	\N	6293
2000-08-28 10:54:29.64	20	\N	6294
2000-08-28 10:54:29.68	0	1	6288
2000-08-28 10:54:29.68	0	1	6289
2000-08-28 10:54:29.68	0	\N	6290
2000-08-28 10:54:29.68	0	\N	6291
2000-08-28 10:54:29.68	189	\N	6292
2000-08-28 10:54:29.68	10	\N	6293
2000-08-28 10:54:29.68	20	\N	6294
2000-08-28 10:54:29.72	0	1	6288
2000-08-28 10:54:29.72	0	1	6289
2000-08-28 10:54:29.72	0	\N	6290
2000-08-28 10:54:29.72	0	\N	6291
2000-08-28 10:54:29.72	189	\N	6292
2000-08-28 10:54:29.72	10	\N	6293
2000-08-28 10:54:29.72	20	\N	6294
2000-08-28 10:54:29.76	0	1	6288
2000-08-28 10:54:29.76	0	1	6289
2000-08-28 10:54:29.76	0	\N	6290
2000-08-28 10:54:29.76	0	\N	6291
2000-08-28 10:54:29.76	189	\N	6292
2000-08-28 10:54:29.76	10	\N	6293
2000-08-28 10:54:29.76	20	\N	6294
2000-08-28 10:54:29.8	0	1	6288
2000-08-28 10:54:29.8	0	1	6289
2000-08-28 10:54:29.8	0	\N	6290
2000-08-28 10:54:29.8	0	\N	6291
2000-08-28 10:54:29.8	189	\N	6292
2000-08-28 10:54:29.8	10	\N	6293
2000-08-28 10:54:29.8	20	\N	6294
2000-08-28 10:54:29.84	0	1	6288
2000-08-28 10:54:29.84	0	1	6289
2000-08-28 10:54:29.84	0	\N	6290
2000-08-28 10:54:29.84	0	\N	6291
2000-08-28 10:54:29.84	189	\N	6292
2000-08-28 10:54:29.84	10	\N	6293
2000-08-28 10:54:29.84	20	\N	6294
2000-08-28 10:54:29.88	0	1	6288
2000-08-28 10:54:29.88	0	1	6289
2000-08-28 10:54:29.88	0	\N	6290
2000-08-28 10:54:29.88	10	\N	6291
2000-08-28 10:54:29.88	189	\N	6292
2000-08-28 10:54:29.88	10	\N	6293
2000-08-28 10:54:29.88	20	\N	6294
2000-08-28 10:54:29.92	0	1	6288
2000-08-28 10:54:29.92	0	1	6289
2000-08-28 10:54:29.92	0	\N	6290
2000-08-28 10:54:29.92	10	\N	6291
2000-08-28 10:54:29.92	189	\N	6292
2000-08-28 10:54:29.92	10	\N	6293
2000-08-28 10:54:29.92	20	\N	6294
2000-08-28 10:54:29.96	0	1	6288
2000-08-28 10:54:29.96	0	1	6289
2000-08-28 10:54:29.96	0	\N	6290
2000-08-28 10:54:29.96	10	\N	6291
2000-08-28 10:54:29.96	189	\N	6292
2000-08-28 10:54:29.96	10	\N	6293
2000-08-28 10:54:29.96	20	\N	6294
2000-08-28 10:54:30	0	1	6288
2000-08-28 10:54:30	0	1	6289
2000-08-28 10:54:30	0	\N	6290
2000-08-28 10:54:30	0	\N	6291
2000-08-28 10:54:30	189	\N	6292
2000-08-28 10:54:30	10	\N	6293
2000-08-28 10:54:30	20	\N	6294
2000-08-28 10:54:30.04	0	1	6288
2000-08-28 10:54:30.04	0	1	6289
2000-08-28 10:54:30.04	0	\N	6290
2000-08-28 10:54:30.04	0	\N	6291
2000-08-28 10:54:30.04	189	\N	6292
2000-08-28 10:54:30.04	10	\N	6293
2000-08-28 10:54:30.04	20	\N	6294
2000-08-28 10:54:30.08	0	1	6288
2000-08-28 10:54:30.08	0	1	6289
2000-08-28 10:54:30.08	0	\N	6290
2000-08-28 10:54:30.08	0	\N	6291
2000-08-28 10:54:30.08	189	\N	6292
2000-08-28 10:54:30.08	10	\N	6293
2000-08-28 10:54:30.08	20	\N	6294
2000-08-28 10:54:30.12	0	1	6288
2000-08-28 10:54:30.12	0	1	6289
2000-08-28 10:54:30.12	0	\N	6290
2000-08-28 10:54:30.12	0	\N	6291
2000-08-28 10:54:30.12	189	\N	6292
2000-08-28 10:54:30.12	10	\N	6293
2000-08-28 10:54:30.12	20	\N	6294
2000-08-28 10:54:30.16	0	1	6288
2000-08-28 10:54:30.16	0	1	6289
2000-08-28 10:54:30.16	0	\N	6290
2000-08-28 10:54:30.16	0	\N	6291
2000-08-28 10:54:30.16	189	\N	6292
2000-08-28 10:54:30.16	10	\N	6293
2000-08-28 10:54:30.16	20	\N	6294
2000-08-28 10:54:30.2	0	1	6288
2000-08-28 10:54:30.2	0	1	6289
2000-08-28 10:54:30.2	0	\N	6290
2000-08-28 10:54:30.2	0	\N	6291
2000-08-28 10:54:30.2	189	\N	6292
2000-08-28 10:54:30.2	10	\N	6293
2000-08-28 10:54:30.2	20	\N	6294
2000-08-28 10:54:30.24	0	1	6288
2000-08-28 10:54:30.24	0	1	6289
2000-08-28 10:54:30.24	0	\N	6290
2000-08-28 10:54:30.24	40	\N	6291
2000-08-28 10:54:30.24	189	\N	6292
2000-08-28 10:54:30.24	10	\N	6293
2000-08-28 10:54:30.24	20	\N	6294
2000-08-28 10:54:30.28	0	1	6288
2000-08-28 10:54:30.28	0	1	6289
2000-08-28 10:54:30.28	0	\N	6290
2000-08-28 10:54:30.28	30	\N	6291
2000-08-28 10:54:30.28	189	\N	6292
2000-08-28 10:54:30.28	10	\N	6293
2000-08-28 10:54:30.28	20	\N	6294
2000-08-28 10:54:30.32	0	1	6288
2000-08-28 10:54:30.32	0	1	6289
2000-08-28 10:54:30.32	0	\N	6290
2000-08-28 10:54:30.32	30	\N	6291
2000-08-28 10:54:30.32	189	\N	6292
2000-08-28 10:54:30.32	10	\N	6293
2000-08-28 10:54:30.32	20	\N	6294
2000-08-28 10:54:30.36	0	1	6288
2000-08-28 10:54:30.36	0	1	6289
2000-08-28 10:54:30.36	0	\N	6290
2000-08-28 10:54:30.36	0	\N	6291
2000-08-28 10:54:30.36	189	\N	6292
2000-08-28 10:54:30.36	10	\N	6293
2000-08-28 10:54:30.36	20	\N	6294
2000-08-28 10:54:30.4	0	1	6288
2000-08-28 10:54:30.4	0	1	6289
2000-08-28 10:54:30.4	0	\N	6290
2000-08-28 10:54:30.4	10	\N	6291
2000-08-28 10:54:30.4	189	\N	6292
2000-08-28 10:54:30.4	10	\N	6293
2000-08-28 10:54:30.4	20	\N	6294
2000-08-28 10:54:30.44	0	1	6288
2000-08-28 10:54:30.44	0	1	6289
2000-08-28 10:54:30.44	0	\N	6290
2000-08-28 10:54:30.44	10	\N	6291
2000-08-28 10:54:30.44	189	\N	6292
2000-08-28 10:54:30.44	10	\N	6293
2000-08-28 10:54:30.44	20	\N	6294
2000-08-28 10:54:30.48	0	1	6288
2000-08-28 10:54:30.48	0	1	6289
2000-08-28 10:54:30.48	0	\N	6290
2000-08-28 10:54:30.48	20	\N	6291
2000-08-28 10:54:30.48	182	\N	6292
2000-08-28 10:54:30.48	0	\N	6293
2000-08-28 10:54:30.48	0	\N	6294
2000-08-28 10:54:30.52	0	1	6288
2000-08-28 10:54:30.52	0	1	6289
2000-08-28 10:54:30.52	0	1	6290
2000-08-28 10:54:30.52	0	1	6291
2000-08-28 10:54:30.52	183	1	6292
2000-08-28 10:54:30.52	0	1	6293
2000-08-28 10:54:30.52	0	1	6294
2000-08-28 11:16:05	0	1	6288
2000-08-28 11:16:05	-22000	1	6289
2000-08-28 11:16:05	0	\N	6290
2000-08-28 11:16:05	10	\N	6291
2000-08-28 11:16:05	183	\N	6292
2000-08-28 11:16:05	10	\N	6293
2000-08-28 11:16:05	20	\N	6294
2000-08-28 11:16:05.04	0	1	6288
2000-08-28 11:16:05.04	-22000	1	6289
2000-08-28 11:16:05.04	0	\N	6290
2000-08-28 11:16:05.04	10	\N	6291
2000-08-28 11:16:05.04	183	\N	6292
2000-08-28 11:16:05.04	10	\N	6293
2000-08-28 11:16:05.04	20	\N	6294
2000-08-28 11:16:05.08	0	1	6288
2000-08-28 11:16:05.08	-22000	1	6289
2000-08-28 11:16:05.08	0	\N	6290
2000-08-28 11:16:05.08	10	\N	6291
2000-08-28 11:16:05.08	183	\N	6292
2000-08-28 11:16:05.08	10	\N	6293
2000-08-28 11:16:05.08	20	\N	6294
2000-08-28 11:16:05.12	0	1	6288
2000-08-28 11:16:05.12	-22000	1	6289
2000-08-28 11:16:05.12	0	\N	6290
2000-08-28 11:16:05.12	0	\N	6291
2000-08-28 11:16:05.12	183	\N	6292
2000-08-28 11:16:05.12	10	\N	6293
2000-08-28 11:16:05.12	20	\N	6294
2000-08-28 11:16:05.16	0	1	6288
2000-08-28 11:16:05.16	-22000	1	6289
2000-08-28 11:16:05.16	0	\N	6290
2000-08-28 11:16:05.16	0	\N	6291
2000-08-28 11:16:05.16	183	\N	6292
2000-08-28 11:16:05.16	10	\N	6293
2000-08-28 11:16:05.16	20	\N	6294
2000-08-28 11:16:05.2	0	1	6288
2000-08-28 11:16:05.2	-22000	1	6289
2000-08-28 11:16:05.2	0	\N	6290
2000-08-28 11:16:05.2	0	\N	6291
2000-08-28 11:16:05.2	183	\N	6292
2000-08-28 11:16:05.2	10	\N	6293
2000-08-28 11:16:05.2	20	\N	6294
2000-08-28 11:16:05.24	0	1	6288
2000-08-28 11:16:05.24	-22000	1	6289
2000-08-28 11:16:05.24	0	\N	6290
2000-08-28 11:16:05.24	0	\N	6291
2000-08-28 11:16:05.24	183	\N	6292
2000-08-28 11:16:05.24	10	\N	6293
2000-08-28 11:16:05.24	20	\N	6294
2000-08-28 11:16:05.28	0	1	6288
2000-08-28 11:16:05.28	-22000	1	6289
2000-08-28 11:16:05.28	0	\N	6290
2000-08-28 11:16:05.28	0	\N	6291
2000-08-28 11:16:05.28	183	\N	6292
2000-08-28 11:16:05.28	10	\N	6293
2000-08-28 11:16:05.28	20	\N	6294
2000-08-28 11:16:05.32	0	1	6288
2000-08-28 11:16:05.32	-22000	1	6289
2000-08-28 11:16:05.32	0	\N	6290
2000-08-28 11:16:05.32	0	\N	6291
2000-08-28 11:16:05.32	183	\N	6292
2000-08-28 11:16:05.32	10	\N	6293
2000-08-28 11:16:05.32	20	\N	6294
2000-08-28 11:16:05.36	0	1	6288
2000-08-28 11:16:05.36	-22000	1	6289
2000-08-28 11:16:05.36	0	\N	6290
2000-08-28 11:16:05.36	0	\N	6291
2000-08-28 11:16:05.36	183	\N	6292
2000-08-28 11:16:05.36	10	\N	6293
2000-08-28 11:16:05.36	20	\N	6294
2000-08-28 11:16:05.4	0	1	6288
2000-08-28 11:16:05.4	-22000	1	6289
2000-08-28 11:16:05.4	0	\N	6290
2000-08-28 11:16:05.4	30	\N	6291
2000-08-28 11:16:05.4	183	\N	6292
2000-08-28 11:16:05.4	10	\N	6293
2000-08-28 11:16:05.4	20	\N	6294
2000-08-28 11:16:05.44	0	1	6288
2000-08-28 11:16:05.44	-22000	1	6289
2000-08-28 11:16:05.44	0	\N	6290
2000-08-28 11:16:05.44	0	\N	6291
2000-08-28 11:16:05.44	183	\N	6292
2000-08-28 11:16:05.44	10	\N	6293
2000-08-28 11:16:05.44	20	\N	6294
2000-08-28 11:16:05.48	0	1	6288
2000-08-28 11:16:05.48	-22000	1	6289
2000-08-28 11:16:05.48	0	\N	6290
2000-08-28 11:16:05.48	0	\N	6291
2000-08-28 11:16:05.48	183	\N	6292
2000-08-28 11:16:05.48	10	\N	6293
2000-08-28 11:16:05.48	20	\N	6294
2000-08-28 11:16:05.52	0	1	6288
2000-08-28 11:16:05.52	-22000	1	6289
2000-08-28 11:16:05.52	0	\N	6290
2000-08-28 11:16:05.52	10	\N	6291
2000-08-28 11:16:05.52	183	\N	6292
2000-08-28 11:16:05.52	10	\N	6293
2000-08-28 11:16:05.52	20	\N	6294
2000-08-28 11:16:05.56	0	1	6288
2000-08-28 11:16:05.56	-22000	1	6289
2000-08-28 11:16:05.56	0	\N	6290
2000-08-28 11:16:05.56	0	\N	6291
2000-08-28 11:16:05.56	183	\N	6292
2000-08-28 11:16:05.56	10	\N	6293
2000-08-28 11:16:05.56	20	\N	6294
2000-08-28 11:16:05.6	0	1	6288
2000-08-28 11:16:05.6	-22000	1	6289
2000-08-28 11:16:05.6	0	\N	6290
2000-08-28 11:16:05.6	0	\N	6291
2000-08-28 11:16:05.6	183	\N	6292
2000-08-28 11:16:05.6	10	\N	6293
2000-08-28 11:16:05.6	20	\N	6294
2000-08-28 11:16:05.64	0	1	6288
2000-08-28 11:16:05.64	-22000	1	6289
2000-08-28 11:16:05.64	0	\N	6290
2000-08-28 11:16:05.64	0	\N	6291
2000-08-28 11:16:05.64	183	\N	6292
2000-08-28 11:16:05.64	10	\N	6293
2000-08-28 11:16:05.64	20	\N	6294
2000-08-28 11:16:05.68	0	1	6288
2000-08-28 11:16:05.68	-22000	1	6289
2000-08-28 11:16:05.68	0	\N	6290
2000-08-28 11:16:05.68	0	\N	6291
2000-08-28 11:16:05.68	183	\N	6292
2000-08-28 11:16:05.68	10	\N	6293
2000-08-28 11:16:05.68	20	\N	6294
2000-08-28 11:16:05.72	0	1	6288
2000-08-28 11:16:05.72	-22000	1	6289
2000-08-28 11:16:05.72	0	\N	6290
2000-08-28 11:16:05.72	0	\N	6291
2000-08-28 11:16:05.72	183	\N	6292
2000-08-28 11:16:05.72	10	\N	6293
2000-08-28 11:16:05.72	20	\N	6294
2000-08-28 11:16:05.76	0	1	6288
2000-08-28 11:16:05.76	-22000	1	6289
2000-08-28 11:16:05.76	0	\N	6290
2000-08-28 11:16:05.76	20	\N	6291
2000-08-28 11:16:05.76	183	\N	6292
2000-08-28 11:16:05.76	10	\N	6293
2000-08-28 11:16:05.76	20	\N	6294
2000-08-28 11:16:05.8	0	1	6288
2000-08-28 11:16:05.8	-22000	1	6289
2000-08-28 11:16:05.8	0	\N	6290
2000-08-28 11:16:05.8	10	\N	6291
2000-08-28 11:16:05.8	183	\N	6292
2000-08-28 11:16:05.8	10	\N	6293
2000-08-28 11:16:05.8	20	\N	6294
2000-08-28 11:16:05.84	0	1	6288
2000-08-28 11:16:05.84	-22000	1	6289
2000-08-28 11:16:05.84	0	\N	6290
2000-08-28 11:16:05.84	10	\N	6291
2000-08-28 11:16:05.84	183	\N	6292
2000-08-28 11:16:05.84	10	\N	6293
2000-08-28 11:16:05.84	20	\N	6294
2000-08-28 11:16:05.88	5	1	6288
2000-08-28 11:16:05.88	-22000	1	6289
2000-08-28 11:16:05.88	0	\N	6290
2000-08-28 11:16:05.88	10	\N	6291
2000-08-28 11:16:05.88	183	\N	6292
2000-08-28 11:16:05.88	10	\N	6293
2000-08-28 11:16:05.88	20	\N	6294
2000-08-28 11:16:05.92	5	1	6288
2000-08-28 11:16:05.92	-22000	1	6289
2000-08-28 11:16:05.92	0	\N	6290
2000-08-28 11:16:05.92	20	\N	6291
2000-08-28 11:16:05.92	183	\N	6292
2000-08-28 11:16:05.92	10	\N	6293
2000-08-28 11:16:05.92	20	\N	6294
2000-08-28 11:16:05.96	5	1	6288
2000-08-28 11:16:05.96	-22000	1	6289
2000-08-28 11:16:05.96	0	\N	6290
2000-08-28 11:16:05.96	20	\N	6291
2000-08-28 11:16:05.96	183	\N	6292
2000-08-28 11:16:05.96	10	\N	6293
2000-08-28 11:16:05.96	20	\N	6294
2000-08-28 11:16:06	5	1	6288
2000-08-28 11:16:06	-22000	1	6289
2000-08-28 11:16:06	0	\N	6290
2000-08-28 11:16:06	20	\N	6291
2000-08-28 11:16:06	183	\N	6292
2000-08-28 11:16:06	10	\N	6293
2000-08-28 11:16:06	20	\N	6294
2000-08-28 11:16:06.04	5	1	6288
2000-08-28 11:16:06.04	-22000	1	6289
2000-08-28 11:16:06.04	0	\N	6290
2000-08-28 11:16:06.04	170	\N	6291
2000-08-28 11:16:06.04	183	\N	6292
2000-08-28 11:16:06.04	10	\N	6293
2000-08-28 11:16:06.04	20	\N	6294
2000-08-28 11:16:06.08	5	1	6288
2000-08-28 11:16:06.08	-22000	1	6289
2000-08-28 11:16:06.08	0	\N	6290
2000-08-28 11:16:06.08	300	\N	6291
2000-08-28 11:16:06.08	183	\N	6292
2000-08-28 11:16:06.08	10	\N	6293
2000-08-28 11:16:06.08	20	\N	6294
2000-08-28 11:16:06.12	5	1	6288
2000-08-28 11:16:06.12	-22000	1	6289
2000-08-28 11:16:06.12	0	\N	6290
2000-08-28 11:16:06.12	300	\N	6291
2000-08-28 11:16:06.12	183	\N	6292
2000-08-28 11:16:06.12	10	\N	6293
2000-08-28 11:16:06.12	20	\N	6294
2000-08-28 11:16:06.16	5	1	6288
2000-08-28 11:16:06.16	-22000	1	6289
2000-08-28 11:16:06.16	0	\N	6290
2000-08-28 11:16:06.16	350	\N	6291
2000-08-28 11:16:06.16	183	\N	6292
2000-08-28 11:16:06.16	10	\N	6293
2000-08-28 11:16:06.16	20	\N	6294
2000-08-28 11:16:06.2	5	1	6288
2000-08-28 11:16:06.2	-22000	1	6289
2000-08-28 11:16:06.2	0	\N	6290
2000-08-28 11:16:06.2	420	\N	6291
2000-08-28 11:16:06.2	185	\N	6292
2000-08-28 11:16:06.2	10	\N	6293
2000-08-28 11:16:06.2	20	\N	6294
2000-08-28 11:16:06.24	5	1	6288
2000-08-28 11:16:06.24	-22000	1	6289
2000-08-28 11:16:06.24	0	\N	6290
2000-08-28 11:16:06.24	420	\N	6291
2000-08-28 11:16:06.24	185	\N	6292
2000-08-28 11:16:06.24	10	\N	6293
2000-08-28 11:16:06.24	20	\N	6294
2000-08-28 11:16:06.28	5	1	6288
2000-08-28 11:16:06.28	-22000	1	6289
2000-08-28 11:16:06.28	0	\N	6290
2000-08-28 11:16:06.28	500	\N	6291
2000-08-28 11:16:06.28	188	\N	6292
2000-08-28 11:16:06.28	10	\N	6293
2000-08-28 11:16:06.28	20	\N	6294
2000-08-28 11:16:06.32	5	1	6288
2000-08-28 11:16:06.32	-22000	1	6289
2000-08-28 11:16:06.32	0	\N	6290
2000-08-28 11:16:06.32	550	\N	6291
2000-08-28 11:16:06.32	192	\N	6292
2000-08-28 11:16:06.32	10	\N	6293
2000-08-28 11:16:06.32	20	\N	6294
2000-08-28 11:16:06.36	5	1	6288
2000-08-28 11:16:06.36	-22000	1	6289
2000-08-28 11:16:06.36	0	\N	6290
2000-08-28 11:16:06.36	630	\N	6291
2000-08-28 11:16:06.36	197	\N	6292
2000-08-28 11:16:06.36	10	\N	6293
2000-08-28 11:16:06.36	20	\N	6294
2000-08-28 11:16:06.4	5	1	6288
2000-08-28 11:16:06.4	-22000	1	6289
2000-08-28 11:16:06.4	0	\N	6290
2000-08-28 11:16:06.4	630	\N	6291
2000-08-28 11:16:06.4	197	\N	6292
2000-08-28 11:16:06.4	10	\N	6293
2000-08-28 11:16:06.4	20	\N	6294
2000-08-28 11:16:06.44	5	1	6288
2000-08-28 11:16:06.44	-22000	1	6289
2000-08-28 11:16:06.44	0	\N	6290
2000-08-28 11:16:06.44	680	\N	6291
2000-08-28 11:16:06.44	204	\N	6292
2000-08-28 11:16:06.44	10	\N	6293
2000-08-28 11:16:06.44	20	\N	6294
2000-08-28 11:16:06.48	5	1	6288
2000-08-28 11:16:06.48	-22000	1	6289
2000-08-28 11:16:06.48	0	\N	6290
2000-08-28 11:16:06.48	720	\N	6291
2000-08-28 11:16:06.48	212	\N	6292
2000-08-28 11:16:06.48	10	\N	6293
2000-08-28 11:16:06.48	20	\N	6294
2000-08-28 11:16:06.52	5	1	6288
2000-08-28 11:16:06.52	-22000	1	6289
2000-08-28 11:16:06.52	0	\N	6290
2000-08-28 11:16:06.52	720	\N	6291
2000-08-28 11:16:06.52	212	\N	6292
2000-08-28 11:16:06.52	10	\N	6293
2000-08-28 11:16:06.52	20	\N	6294
2000-08-28 11:16:06.56	5	1	6288
2000-08-28 11:16:06.56	-22000	1	6289
2000-08-28 11:16:06.56	0	\N	6290
2000-08-28 11:16:06.56	780	\N	6291
2000-08-28 11:16:06.56	220	\N	6292
2000-08-28 11:16:06.56	10	\N	6293
2000-08-28 11:16:06.56	20	\N	6294
2000-08-28 11:16:06.6	5	1	6288
2000-08-28 11:16:06.6	-22000	1	6289
2000-08-28 11:16:06.6	0	\N	6290
2000-08-28 11:16:06.6	790	\N	6291
2000-08-28 11:16:06.6	228	\N	6292
2000-08-28 11:16:06.6	10	\N	6293
2000-08-28 11:16:06.6	20	\N	6294
2000-08-28 11:16:06.64	5	1	6288
2000-08-28 11:16:06.64	-22000	1	6289
2000-08-28 11:16:06.64	0	\N	6290
2000-08-28 11:16:06.64	790	\N	6291
2000-08-28 11:16:06.64	228	\N	6292
2000-08-28 11:16:06.64	10	\N	6293
2000-08-28 11:16:06.64	20	\N	6294
2000-08-28 11:16:06.68	5	1	6288
2000-08-28 11:16:06.68	-22000	1	6289
2000-08-28 11:16:06.68	0	\N	6290
2000-08-28 11:16:06.68	810	\N	6291
2000-08-28 11:16:06.68	240	\N	6292
2000-08-28 11:16:06.68	10	\N	6293
2000-08-28 11:16:06.68	20	\N	6294
2000-08-28 11:16:06.72	5	1	6288
2000-08-28 11:16:06.72	-21894	1	6289
2000-08-28 11:16:06.72	0	\N	6290
2000-08-28 11:16:06.72	830	\N	6291
2000-08-28 11:16:06.72	249	\N	6292
2000-08-28 11:16:06.72	10	\N	6293
2000-08-28 11:16:06.72	20	\N	6294
2000-08-28 11:16:06.76	5	1	6288
2000-08-28 11:16:06.76	-21555	1	6289
2000-08-28 11:16:06.76	0	\N	6290
2000-08-28 11:16:06.76	830	\N	6291
2000-08-28 11:16:06.76	249	\N	6292
2000-08-28 11:16:06.76	10	\N	6293
2000-08-28 11:16:06.76	20	\N	6294
2000-08-28 11:16:06.8	5	1	6288
2000-08-28 11:16:06.8	-21217	1	6289
2000-08-28 11:16:06.8	0	\N	6290
2000-08-28 11:16:06.8	840	\N	6291
2000-08-28 11:16:06.8	259	\N	6292
2000-08-28 11:16:06.8	10	\N	6293
2000-08-28 11:16:06.8	20	\N	6294
2000-08-28 11:16:06.84	5	1	6288
2000-08-28 11:16:06.84	-21048	1	6289
2000-08-28 11:16:06.84	0	\N	6290
2000-08-28 11:16:06.84	850	\N	6291
2000-08-28 11:16:06.84	269	\N	6292
2000-08-28 11:16:06.84	10	\N	6293
2000-08-28 11:16:06.84	20	\N	6294
2000-08-28 11:16:06.88	5	1	6288
2000-08-28 11:16:06.88	-20709	1	6289
2000-08-28 11:16:06.88	0	\N	6290
2000-08-28 11:16:06.88	860	\N	6291
2000-08-28 11:16:06.88	281	\N	6292
2000-08-28 11:16:06.88	10	\N	6293
2000-08-28 11:16:06.88	20	\N	6294
2000-08-28 11:16:06.92	5	1	6288
2000-08-28 11:16:06.92	-20540	1	6289
2000-08-28 11:16:06.92	0	\N	6290
2000-08-28 11:16:06.92	860	\N	6291
2000-08-28 11:16:06.92	281	\N	6292
2000-08-28 11:16:06.92	10	\N	6293
2000-08-28 11:16:06.92	20	\N	6294
2000-08-28 11:16:06.96	5	1	6288
2000-08-28 11:16:06.96	-20201	1	6289
2000-08-28 11:16:06.96	111	\N	6290
2000-08-28 11:16:06.96	840	\N	6291
2000-08-28 11:16:06.96	296	\N	6292
2000-08-28 11:16:06.96	10	\N	6293
2000-08-28 11:16:06.96	20	\N	6294
2000-08-28 11:16:07	5	1	6288
2000-08-28 11:16:07	-20032	1	6289
2000-08-28 11:16:07	124	\N	6290
2000-08-28 11:16:07	840	\N	6291
2000-08-28 11:16:07	305	\N	6292
2000-08-28 11:16:07	10	\N	6293
2000-08-28 11:16:07	20	\N	6294
2000-08-28 11:16:07.04	5	1	6288
2000-08-28 11:16:07.04	-19694	1	6289
2000-08-28 11:16:07.04	124	\N	6290
2000-08-28 11:16:07.04	840	\N	6291
2000-08-28 11:16:07.04	305	\N	6292
2000-08-28 11:16:07.04	10	\N	6293
2000-08-28 11:16:07.04	20	\N	6294
2000-08-28 11:16:07.08	5	1	6288
2000-08-28 11:16:07.08	-19355	1	6289
2000-08-28 11:16:07.08	137	\N	6290
2000-08-28 11:16:07.08	870	\N	6291
2000-08-28 11:16:07.08	317	\N	6292
2000-08-28 11:16:07.08	10	\N	6293
2000-08-28 11:16:07.08	20	\N	6294
2000-08-28 11:16:07.12	5	1	6288
2000-08-28 11:16:07.12	-19186	1	6289
2000-08-28 11:16:07.12	150	\N	6290
2000-08-28 11:16:07.12	860	\N	6291
2000-08-28 11:16:07.12	324	\N	6292
2000-08-28 11:16:07.12	10	\N	6293
2000-08-28 11:16:07.12	20	\N	6294
2000-08-28 11:16:07.16	5	1	6288
2000-08-28 11:16:07.16	-18847	1	6289
2000-08-28 11:16:07.16	150	\N	6290
2000-08-28 11:16:07.16	860	\N	6291
2000-08-28 11:16:07.16	324	\N	6292
2000-08-28 11:16:07.16	10	\N	6293
2000-08-28 11:16:07.16	20	\N	6294
2000-08-28 11:16:07.2	5	1	6288
2000-08-28 11:16:07.2	-18678	1	6289
2000-08-28 11:16:07.2	163	\N	6290
2000-08-28 11:16:07.2	870	\N	6291
2000-08-28 11:16:07.2	338	\N	6292
2000-08-28 11:16:07.2	10	\N	6293
2000-08-28 11:16:07.2	20	\N	6294
2000-08-28 11:16:07.24	5	1	6288
2000-08-28 11:16:07.24	-18340	1	6289
2000-08-28 11:16:07.24	177	\N	6290
2000-08-28 11:16:07.24	870	\N	6291
2000-08-28 11:16:07.24	347	\N	6292
2000-08-28 11:16:07.24	10	\N	6293
2000-08-28 11:16:07.24	20	\N	6294
2000-08-28 11:16:07.28	5	1	6288
2000-08-28 11:16:07.28	-18170	1	6289
2000-08-28 11:16:07.28	190	\N	6290
2000-08-28 11:16:07.28	860	\N	6291
2000-08-28 11:16:07.28	356	\N	6292
2000-08-28 11:16:07.28	10	\N	6293
2000-08-28 11:16:07.28	20	\N	6294
2000-08-28 11:16:07.32	5	1	6288
2000-08-28 11:16:07.32	-17832	1	6289
2000-08-28 11:16:07.32	190	\N	6290
2000-08-28 11:16:07.32	860	\N	6291
2000-08-28 11:16:07.32	356	\N	6292
2000-08-28 11:16:07.32	10	\N	6293
2000-08-28 11:16:07.32	20	\N	6294
2000-08-28 11:16:07.36	5	1	6288
2000-08-28 11:16:07.36	-17663	1	6289
2000-08-28 11:16:07.36	203	\N	6290
2000-08-28 11:16:07.36	860	\N	6291
2000-08-28 11:16:07.36	364	\N	6292
2000-08-28 11:16:07.36	10	\N	6293
2000-08-28 11:16:07.36	20	\N	6294
2000-08-28 11:16:07.4	5	1	6288
2000-08-28 11:16:07.4	-17324	1	6289
2000-08-28 11:16:07.4	216	\N	6290
2000-08-28 11:16:07.4	870	\N	6291
2000-08-28 11:16:07.4	370	\N	6292
2000-08-28 11:16:07.4	10	\N	6293
2000-08-28 11:16:07.4	20	\N	6294
2000-08-28 11:16:07.44	5	1	6288
2000-08-28 11:16:07.44	-16986	1	6289
2000-08-28 11:16:07.44	216	\N	6290
2000-08-28 11:16:07.44	870	\N	6291
2000-08-28 11:16:07.44	370	\N	6292
2000-08-28 11:16:07.44	10	\N	6293
2000-08-28 11:16:07.44	20	\N	6294
2000-08-28 11:16:07.48	5	1	6288
2000-08-28 11:16:07.48	-16816	1	6289
2000-08-28 11:16:07.48	229	\N	6290
2000-08-28 11:16:07.48	860	\N	6291
2000-08-28 11:16:07.48	379	\N	6292
2000-08-28 11:16:07.48	10	\N	6293
2000-08-28 11:16:07.48	20	\N	6294
2000-08-28 11:16:07.52	5	1	6288
2000-08-28 11:16:07.52	-16478	1	6289
2000-08-28 11:16:07.52	242	\N	6290
2000-08-28 11:16:07.52	860	\N	6291
2000-08-28 11:16:07.52	384	\N	6292
2000-08-28 11:16:07.52	10	\N	6293
2000-08-28 11:16:07.52	20	\N	6294
2000-08-28 11:16:07.56	5	1	6288
2000-08-28 11:16:07.56	-16309	1	6289
2000-08-28 11:16:07.56	242	\N	6290
2000-08-28 11:16:07.56	860	\N	6291
2000-08-28 11:16:07.56	384	\N	6292
2000-08-28 11:16:07.56	10	\N	6293
2000-08-28 11:16:07.56	20	\N	6294
2000-08-28 11:16:07.6	5	1	6288
2000-08-28 11:16:07.6	-15970	1	6289
2000-08-28 11:16:07.6	255	\N	6290
2000-08-28 11:16:07.6	860	\N	6291
2000-08-28 11:16:07.6	390	\N	6292
2000-08-28 11:16:07.6	10	\N	6293
2000-08-28 11:16:07.6	20	\N	6294
2000-08-28 11:16:07.64	5	1	6288
2000-08-28 11:16:07.64	-15801	1	6289
2000-08-28 11:16:07.64	268	\N	6290
2000-08-28 11:16:07.64	860	\N	6291
2000-08-28 11:16:07.64	396	\N	6292
2000-08-28 11:16:07.64	10	\N	6293
2000-08-28 11:16:07.64	20	\N	6294
2000-08-28 11:16:07.68	5	1	6288
2000-08-28 11:16:07.68	-15463	1	6289
2000-08-28 11:16:07.68	268	\N	6290
2000-08-28 11:16:07.68	860	\N	6291
2000-08-28 11:16:07.68	396	\N	6292
2000-08-28 11:16:07.68	10	\N	6293
2000-08-28 11:16:07.68	20	\N	6294
2000-08-28 11:16:07.72	5	1	6288
2000-08-28 11:16:07.72	-15293	1	6289
2000-08-28 11:16:07.72	281	\N	6290
2000-08-28 11:16:07.72	860	\N	6291
2000-08-28 11:16:07.72	401	\N	6292
2000-08-28 11:16:07.72	10	\N	6293
2000-08-28 11:16:07.72	20	\N	6294
2000-08-28 11:16:07.76	5	1	6288
2000-08-28 11:16:07.76	-14955	1	6289
2000-08-28 11:16:07.76	294	\N	6290
2000-08-28 11:16:07.76	870	\N	6291
2000-08-28 11:16:07.76	404	\N	6292
2000-08-28 11:16:07.76	10	\N	6293
2000-08-28 11:16:07.76	20	\N	6294
2000-08-28 11:16:07.8	5	1	6288
2000-08-28 11:16:07.8	-14616	1	6289
2000-08-28 11:16:07.8	300	\N	6290
2000-08-28 11:16:07.8	870	\N	6291
2000-08-28 11:16:07.8	410	\N	6292
2000-08-28 11:16:07.8	10	\N	6293
2000-08-28 11:16:07.8	20	\N	6294
2000-08-28 11:16:07.84	5	1	6288
2000-08-28 11:16:07.84	-14447	1	6289
2000-08-28 11:16:07.84	300	\N	6290
2000-08-28 11:16:07.84	870	\N	6291
2000-08-28 11:16:07.84	410	\N	6292
2000-08-28 11:16:07.84	10	\N	6293
2000-08-28 11:16:07.84	20	\N	6294
2000-08-28 11:16:07.88	5	1	6288
2000-08-28 11:16:07.88	-14109	1	6289
2000-08-28 11:16:07.88	300	\N	6290
2000-08-28 11:16:07.88	880	\N	6291
2000-08-28 11:16:07.88	412	\N	6292
2000-08-28 11:16:07.88	10	\N	6293
2000-08-28 11:16:07.88	20	\N	6294
2000-08-28 11:16:07.92	5	1	6288
2000-08-28 11:16:07.92	-13939	1	6289
2000-08-28 11:16:07.92	300	\N	6290
2000-08-28 11:16:07.92	880	\N	6291
2000-08-28 11:16:07.92	413	\N	6292
2000-08-28 11:16:07.92	10	\N	6293
2000-08-28 11:16:07.92	20	\N	6294
2000-08-28 11:16:07.96	5	1	6288
2000-08-28 11:16:07.96	-13601	1	6289
2000-08-28 11:16:07.96	300	\N	6290
2000-08-28 11:16:07.96	880	\N	6291
2000-08-28 11:16:07.96	413	\N	6292
2000-08-28 11:16:07.96	10	\N	6293
2000-08-28 11:16:07.96	20	\N	6294
2000-08-28 11:16:08	5	1	6288
2000-08-28 11:16:08	-13432	1	6289
2000-08-28 11:16:08	300	\N	6290
2000-08-28 11:16:08	870	\N	6291
2000-08-28 11:16:08	416	\N	6292
2000-08-28 11:16:08	10	\N	6293
2000-08-28 11:16:08	20	\N	6294
2000-08-28 11:16:08.04	5	1	6288
2000-08-28 11:16:08.04	-13093	1	6289
2000-08-28 11:16:08.04	300	\N	6290
2000-08-28 11:16:08.04	880	\N	6291
2000-08-28 11:16:08.04	419	\N	6292
2000-08-28 11:16:08.04	10	\N	6293
2000-08-28 11:16:08.04	20	\N	6294
2000-08-28 11:16:08.08	5	1	6288
2000-08-28 11:16:08.08	-12755	1	6289
2000-08-28 11:16:08.08	300	\N	6290
2000-08-28 11:16:08.08	880	\N	6291
2000-08-28 11:16:08.08	419	\N	6292
2000-08-28 11:16:08.08	10	\N	6293
2000-08-28 11:16:08.08	20	\N	6294
2000-08-28 11:16:08.12	5	1	6288
2000-08-28 11:16:08.12	-12585	1	6289
2000-08-28 11:16:08.12	300	\N	6290
2000-08-28 11:16:08.12	870	\N	6291
2000-08-28 11:16:08.12	419	\N	6292
2000-08-28 11:16:08.12	10	\N	6293
2000-08-28 11:16:08.12	20	\N	6294
2000-08-28 11:16:08.16	5	1	6288
2000-08-28 11:16:08.16	-12247	1	6289
2000-08-28 11:16:08.16	300	\N	6290
2000-08-28 11:16:08.16	880	\N	6291
2000-08-28 11:16:08.16	422	\N	6292
2000-08-28 11:16:08.16	10	\N	6293
2000-08-28 11:16:08.16	20	\N	6294
2000-08-28 11:16:08.2	5	1	6288
2000-08-28 11:16:08.2	-12078	1	6289
2000-08-28 11:16:08.2	300	\N	6290
2000-08-28 11:16:08.2	880	\N	6291
2000-08-28 11:16:08.2	422	\N	6292
2000-08-28 11:16:08.2	10	\N	6293
2000-08-28 11:16:08.2	20	\N	6294
2000-08-28 11:16:08.24	5	1	6288
2000-08-28 11:16:08.24	-11739	1	6289
2000-08-28 11:16:08.24	300	\N	6290
2000-08-28 11:16:08.24	880	\N	6291
2000-08-28 11:16:08.24	422	\N	6292
2000-08-28 11:16:08.24	10	\N	6293
2000-08-28 11:16:08.24	20	\N	6294
2000-08-28 11:16:08.28	5	1	6288
2000-08-28 11:16:08.28	-11570	1	6289
2000-08-28 11:16:08.28	300	\N	6290
2000-08-28 11:16:08.28	870	\N	6291
2000-08-28 11:16:08.28	425	\N	6292
2000-08-28 11:16:08.28	10	\N	6293
2000-08-28 11:16:08.28	20	\N	6294
2000-08-28 11:16:08.32	5	1	6288
2000-08-28 11:16:08.32	-11231	1	6289
2000-08-28 11:16:08.32	300	\N	6290
2000-08-28 11:16:08.32	880	\N	6291
2000-08-28 11:16:08.32	425	\N	6292
2000-08-28 11:16:08.32	10	\N	6293
2000-08-28 11:16:08.32	20	\N	6294
2000-08-28 11:16:08.36	5	1	6288
2000-08-28 11:16:08.36	-11062	1	6289
2000-08-28 11:16:08.36	300	\N	6290
2000-08-28 11:16:08.36	880	\N	6291
2000-08-28 11:16:08.36	425	\N	6292
2000-08-28 11:16:08.36	10	\N	6293
2000-08-28 11:16:08.36	20	\N	6294
2000-08-28 11:16:08.4	5	1	6288
2000-08-28 11:16:08.4	-10724	1	6289
2000-08-28 11:16:08.4	300	\N	6290
2000-08-28 11:16:08.4	880	\N	6291
2000-08-28 11:16:08.4	425	\N	6292
2000-08-28 11:16:08.4	10	\N	6293
2000-08-28 11:16:08.4	20	\N	6294
2000-08-28 11:16:08.44	5	1	6288
2000-08-28 11:16:08.44	-10385	1	6289
2000-08-28 11:16:08.44	300	\N	6290
2000-08-28 11:16:08.44	880	\N	6291
2000-08-28 11:16:08.44	425	\N	6292
2000-08-28 11:16:08.44	10	\N	6293
2000-08-28 11:16:08.44	20	\N	6294
2000-08-28 11:16:08.48	5	1	6288
2000-08-28 11:16:08.48	-10216	1	6289
2000-08-28 11:16:08.48	300	\N	6290
2000-08-28 11:16:08.48	880	\N	6291
2000-08-28 11:16:08.48	425	\N	6292
2000-08-28 11:16:08.48	10	\N	6293
2000-08-28 11:16:08.48	20	\N	6294
2000-08-28 11:16:08.52	5	1	6288
2000-08-28 11:16:08.52	-9878	1	6289
2000-08-28 11:16:08.52	300	\N	6290
2000-08-28 11:16:08.52	870	\N	6291
2000-08-28 11:16:08.52	426	\N	6292
2000-08-28 11:16:08.52	10	\N	6293
2000-08-28 11:16:08.52	20	\N	6294
2000-08-28 11:16:08.56	5	1	6288
2000-08-28 11:16:08.56	-9708	1	6289
2000-08-28 11:16:08.56	300	\N	6290
2000-08-28 11:16:08.56	880	\N	6291
2000-08-28 11:16:08.56	428	\N	6292
2000-08-28 11:16:08.56	10	\N	6293
2000-08-28 11:16:08.56	20	\N	6294
2000-08-28 11:16:08.6	5	1	6288
2000-08-28 11:16:08.6	-9370	1	6289
2000-08-28 11:16:08.6	300	\N	6290
2000-08-28 11:16:08.6	880	\N	6291
2000-08-28 11:16:08.6	428	\N	6292
2000-08-28 11:16:08.6	10	\N	6293
2000-08-28 11:16:08.6	20	\N	6294
2000-08-28 11:16:08.64	5	1	6288
2000-08-28 11:16:08.64	-9201	1	6289
2000-08-28 11:16:08.64	300	\N	6290
2000-08-28 11:16:08.64	880	\N	6291
2000-08-28 11:16:08.64	428	\N	6292
2000-08-28 11:16:08.64	10	\N	6293
2000-08-28 11:16:08.64	20	\N	6294
2000-08-28 11:16:08.68	5	1	6288
2000-08-28 11:16:08.68	-8862	1	6289
2000-08-28 11:16:08.68	300	\N	6290
2000-08-28 11:16:08.68	870	\N	6291
2000-08-28 11:16:08.68	428	\N	6292
2000-08-28 11:16:08.68	10	\N	6293
2000-08-28 11:16:08.68	20	\N	6294
2000-08-28 11:16:08.72	5	1	6288
2000-08-28 11:16:08.72	-8524	1	6289
2000-08-28 11:16:08.72	300	\N	6290
2000-08-28 11:16:08.72	880	\N	6291
2000-08-28 11:16:08.72	428	\N	6292
2000-08-28 11:16:08.72	10	\N	6293
2000-08-28 11:16:08.72	20	\N	6294
2000-08-28 11:16:08.76	5	1	6288
2000-08-28 11:16:08.76	-8354	1	6289
2000-08-28 11:16:08.76	300	\N	6290
2000-08-28 11:16:08.76	880	\N	6291
2000-08-28 11:16:08.76	428	\N	6292
2000-08-28 11:16:08.76	10	\N	6293
2000-08-28 11:16:08.76	20	\N	6294
2000-08-28 11:16:08.8	5	1	6288
2000-08-28 11:16:08.8	-8016	1	6289
2000-08-28 11:16:08.8	300	\N	6290
2000-08-28 11:16:08.8	880	\N	6291
2000-08-28 11:16:08.8	428	\N	6292
2000-08-28 11:16:08.8	10	\N	6293
2000-08-28 11:16:08.8	20	\N	6294
2000-08-28 11:16:08.84	5	1	6288
2000-08-28 11:16:08.84	-7847	1	6289
2000-08-28 11:16:08.84	300	\N	6290
2000-08-28 11:16:08.84	880	\N	6291
2000-08-28 11:16:08.84	428	\N	6292
2000-08-28 11:16:08.84	10	\N	6293
2000-08-28 11:16:08.84	20	\N	6294
2000-08-28 11:16:08.88	5	1	6288
2000-08-28 11:16:08.88	-7508	1	6289
2000-08-28 11:16:08.88	300	\N	6290
2000-08-28 11:16:08.88	880	\N	6291
2000-08-28 11:16:08.88	428	\N	6292
2000-08-28 11:16:08.88	10	\N	6293
2000-08-28 11:16:08.88	20	\N	6294
2000-08-28 11:16:08.92	5	1	6288
2000-08-28 11:16:08.92	-7339	1	6289
2000-08-28 11:16:08.92	300	\N	6290
2000-08-28 11:16:08.92	890	\N	6291
2000-08-28 11:16:08.92	428	\N	6292
2000-08-28 11:16:08.92	10	\N	6293
2000-08-28 11:16:08.92	20	\N	6294
2000-08-28 11:16:08.96	5	1	6288
2000-08-28 11:16:08.96	-7000	1	6289
2000-08-28 11:16:08.96	300	\N	6290
2000-08-28 11:16:08.96	880	\N	6291
2000-08-28 11:16:08.96	428	\N	6292
2000-08-28 11:16:08.96	10	\N	6293
2000-08-28 11:16:08.96	20	\N	6294
2000-08-28 11:16:09	5	1	6288
2000-08-28 11:16:09	-6831	1	6289
2000-08-28 11:16:09	300	\N	6290
2000-08-28 11:16:09	880	\N	6291
2000-08-28 11:16:09	428	\N	6292
2000-08-28 11:16:09	10	\N	6293
2000-08-28 11:16:09	20	\N	6294
2000-08-28 11:16:09.04	5	1	6288
2000-08-28 11:16:09.04	-6493	1	6289
2000-08-28 11:16:09.04	300	\N	6290
2000-08-28 11:16:09.04	880	\N	6291
2000-08-28 11:16:09.04	428	\N	6292
2000-08-28 11:16:09.04	10	\N	6293
2000-08-28 11:16:09.04	20	\N	6294
2000-08-28 11:16:09.08	5	1	6288
2000-08-28 11:16:09.08	-6154	1	6289
2000-08-28 11:16:09.08	300	\N	6290
2000-08-28 11:16:09.08	890	\N	6291
2000-08-28 11:16:09.08	428	\N	6292
2000-08-28 11:16:09.08	10	\N	6293
2000-08-28 11:16:09.08	20	\N	6294
2000-08-28 11:16:09.12	5	1	6288
2000-08-28 11:16:09.12	-5985	1	6289
2000-08-28 11:16:09.12	300	\N	6290
2000-08-28 11:16:09.12	890	\N	6291
2000-08-28 11:16:09.12	428	\N	6292
2000-08-28 11:16:09.12	10	\N	6293
2000-08-28 11:16:09.12	20	\N	6294
2000-08-28 11:16:09.16	5	1	6288
2000-08-28 11:16:09.16	-5646	1	6289
2000-08-28 11:16:09.16	300	\N	6290
2000-08-28 11:16:09.16	890	\N	6291
2000-08-28 11:16:09.16	428	\N	6292
2000-08-28 11:16:09.16	10	\N	6293
2000-08-28 11:16:09.16	20	\N	6294
2000-08-28 11:16:09.2	5	1	6288
2000-08-28 11:16:09.2	-5477	1	6289
2000-08-28 11:16:09.2	300	\N	6290
2000-08-28 11:16:09.2	880	\N	6291
2000-08-28 11:16:09.2	428	\N	6292
2000-08-28 11:16:09.2	10	\N	6293
2000-08-28 11:16:09.2	20	\N	6294
2000-08-28 11:16:09.24	5	1	6288
2000-08-28 11:16:09.24	-5139	1	6289
2000-08-28 11:16:09.24	300	\N	6290
2000-08-28 11:16:09.24	880	\N	6291
2000-08-28 11:16:09.24	428	\N	6292
2000-08-28 11:16:09.24	10	\N	6293
2000-08-28 11:16:09.24	20	\N	6294
2000-08-28 11:16:09.28	5	1	6288
2000-08-28 11:16:09.28	-4969	1	6289
2000-08-28 11:16:09.28	300	\N	6290
2000-08-28 11:16:09.28	880	\N	6291
2000-08-28 11:16:09.28	428	\N	6292
2000-08-28 11:16:09.28	10	\N	6293
2000-08-28 11:16:09.28	20	\N	6294
2000-08-28 11:16:09.32	5	1	6288
2000-08-28 11:16:09.32	-4631	1	6289
2000-08-28 11:16:09.32	300	\N	6290
2000-08-28 11:16:09.32	880	\N	6291
2000-08-28 11:16:09.32	428	\N	6292
2000-08-28 11:16:09.32	10	\N	6293
2000-08-28 11:16:09.32	20	\N	6294
2000-08-28 11:16:09.36	5	1	6288
2000-08-28 11:16:09.36	-4293	1	6289
2000-08-28 11:16:09.36	300	\N	6290
2000-08-28 11:16:09.36	870	\N	6291
2000-08-28 11:16:09.36	429	\N	6292
2000-08-28 11:16:09.36	10	\N	6293
2000-08-28 11:16:09.36	20	\N	6294
2000-08-28 11:16:09.4	5	1	6288
2000-08-28 11:16:09.4	-4123	1	6289
2000-08-28 11:16:09.4	300	\N	6290
2000-08-28 11:16:09.4	870	\N	6291
2000-08-28 11:16:09.4	429	\N	6292
2000-08-28 11:16:09.4	10	\N	6293
2000-08-28 11:16:09.4	20	\N	6294
2000-08-28 11:16:09.44	5	1	6288
2000-08-28 11:16:09.44	-3785	1	6289
2000-08-28 11:16:09.44	300	\N	6290
2000-08-28 11:16:09.44	870	\N	6291
2000-08-28 11:16:09.44	428	\N	6292
2000-08-28 11:16:09.44	10	\N	6293
2000-08-28 11:16:09.44	20	\N	6294
2000-08-28 11:16:09.48	5	1	6288
2000-08-28 11:16:09.48	-3616	1	6289
2000-08-28 11:16:09.48	300	\N	6290
2000-08-28 11:16:09.48	870	\N	6291
2000-08-28 11:16:09.48	429	\N	6292
2000-08-28 11:16:09.48	10	\N	6293
2000-08-28 11:16:09.48	20	\N	6294
2000-08-28 11:16:09.52	5	1	6288
2000-08-28 11:16:09.52	-3277	1	6289
2000-08-28 11:16:09.52	300	\N	6290
2000-08-28 11:16:09.52	870	\N	6291
2000-08-28 11:16:09.52	429	\N	6292
2000-08-28 11:16:09.52	10	\N	6293
2000-08-28 11:16:09.52	20	\N	6294
2000-08-28 11:16:09.56	5	1	6288
2000-08-28 11:16:09.56	-3108	1	6289
2000-08-28 11:16:09.56	300	\N	6290
2000-08-28 11:16:09.56	870	\N	6291
2000-08-28 11:16:09.56	428	\N	6292
2000-08-28 11:16:09.56	10	\N	6293
2000-08-28 11:16:09.56	20	\N	6294
2000-08-28 11:16:09.6	5	1	6288
2000-08-28 11:16:09.6	-2769	1	6289
2000-08-28 11:16:09.6	300	\N	6290
2000-08-28 11:16:09.6	870	\N	6291
2000-08-28 11:16:09.6	432	\N	6292
2000-08-28 11:16:09.6	10	\N	6293
2000-08-28 11:16:09.6	20	\N	6294
2000-08-28 11:16:09.64	5	1	6288
2000-08-28 11:16:09.64	-2600	1	6289
2000-08-28 11:16:09.64	300	\N	6290
2000-08-28 11:16:09.64	870	\N	6291
2000-08-28 11:16:09.64	432	\N	6292
2000-08-28 11:16:09.64	10	\N	6293
2000-08-28 11:16:09.64	20	\N	6294
2000-08-28 11:16:09.68	5	1	6288
2000-08-28 11:16:09.68	-2262	1	6289
2000-08-28 11:16:09.68	300	\N	6290
2000-08-28 11:16:09.68	870	\N	6291
2000-08-28 11:16:09.68	432	\N	6292
2000-08-28 11:16:09.68	10	\N	6293
2000-08-28 11:16:09.68	20	\N	6294
2000-08-28 11:16:09.72	5	1	6288
2000-08-28 11:16:09.72	-1923	1	6289
2000-08-28 11:16:09.72	300	\N	6290
2000-08-28 11:16:09.72	870	\N	6291
2000-08-28 11:16:09.72	431	\N	6292
2000-08-28 11:16:09.72	10	\N	6293
2000-08-28 11:16:09.72	20	\N	6294
2000-08-28 11:16:09.76	5	1	6288
2000-08-28 11:16:09.76	-1754	1	6289
2000-08-28 11:16:09.76	300	\N	6290
2000-08-28 11:16:09.76	870	\N	6291
2000-08-28 11:16:09.76	431	\N	6292
2000-08-28 11:16:09.76	10	\N	6293
2000-08-28 11:16:09.76	20	\N	6294
2000-08-28 11:16:09.8	5	1	6288
2000-08-28 11:16:09.8	-1415	1	6289
2000-08-28 11:16:09.8	300	\N	6290
2000-08-28 11:16:09.8	870	\N	6291
2000-08-28 11:16:09.8	431	\N	6292
2000-08-28 11:16:09.8	10	\N	6293
2000-08-28 11:16:09.8	20	\N	6294
2000-08-28 11:16:09.84	5	1	6288
2000-08-28 11:16:09.84	-1246	1	6289
2000-08-28 11:16:09.84	300	\N	6290
2000-08-28 11:16:09.84	870	\N	6291
2000-08-28 11:16:09.84	432	\N	6292
2000-08-28 11:16:09.84	10	\N	6293
2000-08-28 11:16:09.84	20	\N	6294
2000-08-28 11:16:09.88	5	1	6288
2000-08-28 11:16:09.88	-908	1	6289
2000-08-28 11:16:09.88	300	\N	6290
2000-08-28 11:16:09.88	870	\N	6291
2000-08-28 11:16:09.88	428	\N	6292
2000-08-28 11:16:09.88	10	\N	6293
2000-08-28 11:16:09.88	20	\N	6294
2000-08-28 11:16:09.92	5	1	6288
2000-08-28 11:16:09.92	-738	1	6289
2000-08-28 11:16:09.92	300	\N	6290
2000-08-28 11:16:09.92	870	\N	6291
2000-08-28 11:16:09.92	428	\N	6292
2000-08-28 11:16:09.92	10	\N	6293
2000-08-28 11:16:09.92	20	\N	6294
2000-08-28 11:16:09.96	5	1	6288
2000-08-28 11:16:09.96	-400	1	6289
2000-08-28 11:16:09.96	300	\N	6290
2000-08-28 11:16:09.96	870	\N	6291
2000-08-28 11:16:09.96	429	\N	6292
2000-08-28 11:16:09.96	10	\N	6293
2000-08-28 11:16:09.96	20	\N	6294
2000-08-28 11:16:10	5	1	6288
2000-08-28 11:16:10	-61	1	6289
2000-08-28 11:16:10	300	\N	6290
2000-08-28 11:16:10	870	\N	6291
2000-08-28 11:16:10	429	\N	6292
2000-08-28 11:16:10	10	\N	6293
2000-08-28 11:16:10	20	\N	6294
2000-08-28 11:16:10.04	5	1	6288
2000-08-28 11:16:10.04	107	1	6289
2000-08-28 11:16:10.04	300	\N	6290
2000-08-28 11:16:10.04	870	\N	6291
2000-08-28 11:16:10.04	429	\N	6292
2000-08-28 11:16:10.04	10	\N	6293
2000-08-28 11:16:10.04	20	\N	6294
2000-08-28 11:16:10.08	5	1	6288
2000-08-28 11:16:10.08	445	1	6289
2000-08-28 11:16:10.08	300	\N	6290
2000-08-28 11:16:10.08	870	\N	6291
2000-08-28 11:16:10.08	428	\N	6292
2000-08-28 11:16:10.08	10	\N	6293
2000-08-28 11:16:10.08	20	\N	6294
2000-08-28 11:16:10.12	5	1	6288
2000-08-28 11:16:10.12	615	1	6289
2000-08-28 11:16:10.12	300	\N	6290
2000-08-28 11:16:10.12	870	\N	6291
2000-08-28 11:16:10.12	428	\N	6292
2000-08-28 11:16:10.12	10	\N	6293
2000-08-28 11:16:10.12	20	\N	6294
2000-08-28 11:16:10.16	5	1	6288
2000-08-28 11:16:10.16	953	1	6289
2000-08-28 11:16:10.16	300	\N	6290
2000-08-28 11:16:10.16	870	\N	6291
2000-08-28 11:16:10.16	428	\N	6292
2000-08-28 11:16:10.16	10	\N	6293
2000-08-28 11:16:10.16	20	\N	6294
2000-08-28 11:16:10.2	5	1	6288
2000-08-28 11:16:10.2	1122	1	6289
2000-08-28 11:16:10.2	300	\N	6290
2000-08-28 11:16:10.2	870	\N	6291
2000-08-28 11:16:10.2	428	\N	6292
2000-08-28 11:16:10.2	10	\N	6293
2000-08-28 11:16:10.2	20	\N	6294
2000-08-28 11:16:10.24	5	1	6288
2000-08-28 11:16:10.24	1461	1	6289
2000-08-28 11:16:10.24	300	\N	6290
2000-08-28 11:16:10.24	870	\N	6291
2000-08-28 11:16:10.24	428	\N	6292
2000-08-28 11:16:10.24	10	\N	6293
2000-08-28 11:16:10.24	20	\N	6294
2000-08-28 11:16:10.28	5	1	6288
2000-08-28 11:16:10.28	1630	1	6289
2000-08-28 11:16:10.28	300	\N	6290
2000-08-28 11:16:10.28	870	\N	6291
2000-08-28 11:16:10.28	429	\N	6292
2000-08-28 11:16:10.28	10	\N	6293
2000-08-28 11:16:10.28	20	\N	6294
2000-08-28 11:16:10.32	5	1	6288
2000-08-28 11:16:10.32	1969	1	6289
2000-08-28 11:16:10.32	300	\N	6290
2000-08-28 11:16:10.32	870	\N	6291
2000-08-28 11:16:10.32	429	\N	6292
2000-08-28 11:16:10.32	10	\N	6293
2000-08-28 11:16:10.32	20	\N	6294
2000-08-28 11:16:10.36	5	1	6288
2000-08-28 11:16:10.36	2307	1	6289
2000-08-28 11:16:10.36	300	\N	6290
2000-08-28 11:16:10.36	870	\N	6291
2000-08-28 11:16:10.36	428	\N	6292
2000-08-28 11:16:10.36	10	\N	6293
2000-08-28 11:16:10.36	20	\N	6294
2000-08-28 11:16:10.4	5	1	6288
2000-08-28 11:16:10.4	2476	1	6289
2000-08-28 11:16:10.4	300	\N	6290
2000-08-28 11:16:10.4	870	\N	6291
2000-08-28 11:16:10.4	428	\N	6292
2000-08-28 11:16:10.4	10	\N	6293
2000-08-28 11:16:10.4	20	\N	6294
2000-08-28 11:16:10.44	5	1	6288
2000-08-28 11:16:10.44	2815	1	6289
2000-08-28 11:16:10.44	300	\N	6290
2000-08-28 11:16:10.44	870	\N	6291
2000-08-28 11:16:10.44	428	\N	6292
2000-08-28 11:16:10.44	10	\N	6293
2000-08-28 11:16:10.44	20	\N	6294
2000-08-28 11:16:10.48	5	1	6288
2000-08-28 11:16:10.48	2984	1	6289
2000-08-28 11:16:10.48	300	\N	6290
2000-08-28 11:16:10.48	870	\N	6291
2000-08-28 11:16:10.48	428	\N	6292
2000-08-28 11:16:10.48	10	\N	6293
2000-08-28 11:16:10.48	20	\N	6294
2000-08-28 11:16:10.52	5	1	6288
2000-08-28 11:16:10.52	3323	1	6289
2000-08-28 11:16:10.52	300	\N	6290
2000-08-28 11:16:10.52	870	\N	6291
2000-08-28 11:16:10.52	429	\N	6292
2000-08-28 11:16:10.52	10	\N	6293
2000-08-28 11:16:10.52	20	\N	6294
2000-08-28 11:16:10.56	5	1	6288
2000-08-28 11:16:10.56	3492	1	6289
2000-08-28 11:16:10.56	300	\N	6290
2000-08-28 11:16:10.56	870	\N	6291
2000-08-28 11:16:10.56	429	\N	6292
2000-08-28 11:16:10.56	10	\N	6293
2000-08-28 11:16:10.56	20	\N	6294
2000-08-28 11:16:10.6	5	1	6288
2000-08-28 11:16:10.6	3830	1	6289
2000-08-28 11:16:10.6	300	\N	6290
2000-08-28 11:16:10.6	870	\N	6291
2000-08-28 11:16:10.6	428	\N	6292
2000-08-28 11:16:10.6	10	\N	6293
2000-08-28 11:16:10.6	20	\N	6294
2000-08-28 11:16:10.64	5	1	6288
2000-08-28 11:16:10.64	4169	1	6289
2000-08-28 11:16:10.64	300	\N	6290
2000-08-28 11:16:10.64	870	\N	6291
2000-08-28 11:16:10.64	428	\N	6292
2000-08-28 11:16:10.64	10	\N	6293
2000-08-28 11:16:10.64	20	\N	6294
2000-08-28 11:16:10.68	5	1	6288
2000-08-28 11:16:10.68	4338	1	6289
2000-08-28 11:16:10.68	300	\N	6290
2000-08-28 11:16:10.68	860	\N	6291
2000-08-28 11:16:10.68	428	\N	6292
2000-08-28 11:16:10.68	10	\N	6293
2000-08-28 11:16:10.68	20	\N	6294
2000-08-28 11:16:10.72	5	1	6288
2000-08-28 11:16:10.72	4676	1	6289
2000-08-28 11:16:10.72	300	\N	6290
2000-08-28 11:16:10.72	860	\N	6291
2000-08-28 11:16:10.72	428	\N	6292
2000-08-28 11:16:10.72	10	\N	6293
2000-08-28 11:16:10.72	20	\N	6294
2000-08-28 11:16:10.76	5	1	6288
2000-08-28 11:16:10.76	4846	1	6289
2000-08-28 11:16:10.76	300	\N	6290
2000-08-28 11:16:10.76	870	\N	6291
2000-08-28 11:16:10.76	428	\N	6292
2000-08-28 11:16:10.76	10	\N	6293
2000-08-28 11:16:10.76	20	\N	6294
2000-08-28 11:16:10.8	5	1	6288
2000-08-28 11:16:10.8	5184	1	6289
2000-08-28 11:16:10.8	300	\N	6290
2000-08-28 11:16:10.8	870	\N	6291
2000-08-28 11:16:10.8	428	\N	6292
2000-08-28 11:16:10.8	10	\N	6293
2000-08-28 11:16:10.8	20	\N	6294
2000-08-28 11:16:10.84	5	1	6288
2000-08-28 11:16:10.84	5353	1	6289
2000-08-28 11:16:10.84	300	\N	6290
2000-08-28 11:16:10.84	870	\N	6291
2000-08-28 11:16:10.84	428	\N	6292
2000-08-28 11:16:10.84	10	\N	6293
2000-08-28 11:16:10.84	20	\N	6294
2000-08-28 11:16:10.88	5	1	6288
2000-08-28 11:16:10.88	5692	1	6289
2000-08-28 11:16:10.88	300	\N	6290
2000-08-28 11:16:10.88	860	\N	6291
2000-08-28 11:16:10.88	428	\N	6292
2000-08-28 11:16:10.88	10	\N	6293
2000-08-28 11:16:10.88	20	\N	6294
2000-08-28 11:16:10.92	5	1	6288
2000-08-28 11:16:10.92	6030	1	6289
2000-08-28 11:16:10.92	300	\N	6290
2000-08-28 11:16:10.92	860	\N	6291
2000-08-28 11:16:10.92	429	\N	6292
2000-08-28 11:16:10.92	10	\N	6293
2000-08-28 11:16:10.92	20	\N	6294
2000-08-28 11:16:10.96	5	1	6288
2000-08-28 11:16:10.96	6200	1	6289
2000-08-28 11:16:10.96	300	\N	6290
2000-08-28 11:16:10.96	860	\N	6291
2000-08-28 11:16:10.96	429	\N	6292
2000-08-28 11:16:10.96	10	\N	6293
2000-08-28 11:16:10.96	20	\N	6294
2000-08-28 11:16:11	5	1	6288
2000-08-28 11:16:11	6538	1	6289
2000-08-28 11:16:11	300	\N	6290
2000-08-28 11:16:11	870	\N	6291
2000-08-28 11:16:11	428	\N	6292
2000-08-28 11:16:11	10	\N	6293
2000-08-28 11:16:11	20	\N	6294
2000-08-28 11:16:11.04	5	1	6288
2000-08-28 11:16:11.04	6707	1	6289
2000-08-28 11:16:11.04	300	\N	6290
2000-08-28 11:16:11.04	860	\N	6291
2000-08-28 11:16:11.04	428	\N	6292
2000-08-28 11:16:11.04	10	\N	6293
2000-08-28 11:16:11.04	20	\N	6294
2000-08-28 11:16:11.08	5	1	6288
2000-08-28 11:16:11.08	7046	1	6289
2000-08-28 11:16:11.08	300	\N	6290
2000-08-28 11:16:11.08	860	\N	6291
2000-08-28 11:16:11.08	428	\N	6292
2000-08-28 11:16:11.08	10	\N	6293
2000-08-28 11:16:11.08	20	\N	6294
2000-08-28 11:16:11.12	5	1	6288
2000-08-28 11:16:11.12	7215	1	6289
2000-08-28 11:16:11.12	300	\N	6290
2000-08-28 11:16:11.12	860	\N	6291
2000-08-28 11:16:11.12	428	\N	6292
2000-08-28 11:16:11.12	10	\N	6293
2000-08-28 11:16:11.12	20	\N	6294
2000-08-28 11:16:11.16	5	1	6288
2000-08-28 11:16:11.16	7554	1	6289
2000-08-28 11:16:11.16	300	\N	6290
2000-08-28 11:16:11.16	870	\N	6291
2000-08-28 11:16:11.16	429	\N	6292
2000-08-28 11:16:11.16	10	\N	6293
2000-08-28 11:16:11.16	20	\N	6294
2000-08-28 11:16:11.2	5	1	6288
2000-08-28 11:16:11.2	7723	1	6289
2000-08-28 11:16:11.2	300	\N	6290
2000-08-28 11:16:11.2	860	\N	6291
2000-08-28 11:16:11.2	428	\N	6292
2000-08-28 11:16:11.2	10	\N	6293
2000-08-28 11:16:11.2	20	\N	6294
2000-08-28 11:16:11.24	5	1	6288
2000-08-28 11:16:11.24	8061	1	6289
2000-08-28 11:16:11.24	300	\N	6290
2000-08-28 11:16:11.24	860	\N	6291
2000-08-28 11:16:11.24	428	\N	6292
2000-08-28 11:16:11.24	10	\N	6293
2000-08-28 11:16:11.24	20	\N	6294
2000-08-28 11:16:11.28	5	1	6288
2000-08-28 11:16:11.28	8400	1	6289
2000-08-28 11:16:11.28	300	\N	6290
2000-08-28 11:16:11.28	860	\N	6291
2000-08-28 11:16:11.28	428	\N	6292
2000-08-28 11:16:11.28	10	\N	6293
2000-08-28 11:16:11.28	20	\N	6294
2000-08-28 11:16:11.32	5	1	6288
2000-08-28 11:16:11.32	8569	1	6289
2000-08-28 11:16:11.32	300	\N	6290
2000-08-28 11:16:11.32	870	\N	6291
2000-08-28 11:16:11.32	428	\N	6292
2000-08-28 11:16:11.32	10	\N	6293
2000-08-28 11:16:11.32	20	\N	6294
2000-08-28 11:16:11.36	5	1	6288
2000-08-28 11:16:11.36	8908	1	6289
2000-08-28 11:16:11.36	300	\N	6290
2000-08-28 11:16:11.36	870	\N	6291
2000-08-28 11:16:11.36	428	\N	6292
2000-08-28 11:16:11.36	10	\N	6293
2000-08-28 11:16:11.36	20	\N	6294
2000-08-28 11:16:11.4	5	1	6288
2000-08-28 11:16:11.4	9077	1	6289
2000-08-28 11:16:11.4	300	\N	6290
2000-08-28 11:16:11.4	870	\N	6291
2000-08-28 11:16:11.4	428	\N	6292
2000-08-28 11:16:11.4	10	\N	6293
2000-08-28 11:16:11.4	20	\N	6294
2000-08-28 11:16:11.44	5	1	6288
2000-08-28 11:16:11.44	9415	1	6289
2000-08-28 11:16:11.44	300	\N	6290
2000-08-28 11:16:11.44	850	\N	6291
2000-08-28 11:16:11.44	428	\N	6292
2000-08-28 11:16:11.44	10	\N	6293
2000-08-28 11:16:11.44	20	\N	6294
2000-08-28 11:16:11.48	5	1	6288
2000-08-28 11:16:11.48	9585	1	6289
2000-08-28 11:16:11.48	300	\N	6290
2000-08-28 11:16:11.48	850	\N	6291
2000-08-28 11:16:11.48	428	\N	6292
2000-08-28 11:16:11.48	10	\N	6293
2000-08-28 11:16:11.48	20	\N	6294
2000-08-28 11:16:11.52	5	1	6288
2000-08-28 11:16:11.52	9923	1	6289
2000-08-28 11:16:11.52	300	\N	6290
2000-08-28 11:16:11.52	840	\N	6291
2000-08-28 11:16:11.52	428	\N	6292
2000-08-28 11:16:11.52	10	\N	6293
2000-08-28 11:16:11.52	20	\N	6294
2000-08-28 11:16:11.56	5	1	6288
2000-08-28 11:16:11.56	10261	1	6289
2000-08-28 11:16:11.56	300	\N	6290
2000-08-28 11:16:11.56	820	\N	6291
2000-08-28 11:16:11.56	428	\N	6292
2000-08-28 11:16:11.56	10	\N	6293
2000-08-28 11:16:11.56	20	\N	6294
2000-08-28 11:16:11.6	5	1	6288
2000-08-28 11:16:11.6	10431	1	6289
2000-08-28 11:16:11.6	300	\N	6290
2000-08-28 11:16:11.6	790	\N	6291
2000-08-28 11:16:11.6	428	\N	6292
2000-08-28 11:16:11.6	10	\N	6293
2000-08-28 11:16:11.6	20	\N	6294
2000-08-28 11:16:11.64	5	1	6288
2000-08-28 11:16:11.64	10769	1	6289
2000-08-28 11:16:11.64	300	\N	6290
2000-08-28 11:16:11.64	790	\N	6291
2000-08-28 11:16:11.64	428	\N	6292
2000-08-28 11:16:11.64	10	\N	6293
2000-08-28 11:16:11.64	20	\N	6294
2000-08-28 11:16:11.68	5	1	6288
2000-08-28 11:16:11.68	10938	1	6289
2000-08-28 11:16:11.68	300	\N	6290
2000-08-28 11:16:11.68	760	\N	6291
2000-08-28 11:16:11.68	428	\N	6292
2000-08-28 11:16:11.68	10	\N	6293
2000-08-28 11:16:11.68	20	\N	6294
2000-08-28 11:16:11.72	5	1	6288
2000-08-28 11:16:11.72	11277	1	6289
2000-08-28 11:16:11.72	300	\N	6290
2000-08-28 11:16:11.72	740	\N	6291
2000-08-28 11:16:11.72	428	\N	6292
2000-08-28 11:16:11.72	10	\N	6293
2000-08-28 11:16:11.72	20	\N	6294
2000-08-28 11:16:11.76	5	1	6288
2000-08-28 11:16:11.76	11446	1	6289
2000-08-28 11:16:11.76	300	\N	6290
2000-08-28 11:16:11.76	740	\N	6291
2000-08-28 11:16:11.76	428	\N	6292
2000-08-28 11:16:11.76	10	\N	6293
2000-08-28 11:16:11.76	20	\N	6294
2000-08-28 11:16:11.8	5	1	6288
2000-08-28 11:16:11.8	11785	1	6289
2000-08-28 11:16:11.8	300	\N	6290
2000-08-28 11:16:11.8	710	\N	6291
2000-08-28 11:16:11.8	425	\N	6292
2000-08-28 11:16:11.8	10	\N	6293
2000-08-28 11:16:11.8	20	\N	6294
2000-08-28 11:16:11.84	5	1	6288
2000-08-28 11:16:11.84	11954	1	6289
2000-08-28 11:16:11.84	300	\N	6290
2000-08-28 11:16:11.84	680	\N	6291
2000-08-28 11:16:11.84	425	\N	6292
2000-08-28 11:16:11.84	10	\N	6293
2000-08-28 11:16:11.84	20	\N	6294
2000-08-28 11:16:11.88	5	1	6288
2000-08-28 11:16:11.88	12292	1	6289
2000-08-28 11:16:11.88	300	\N	6290
2000-08-28 11:16:11.88	680	\N	6291
2000-08-28 11:16:11.88	425	\N	6292
2000-08-28 11:16:11.88	10	\N	6293
2000-08-28 11:16:11.88	20	\N	6294
2000-08-28 11:16:11.92	5	1	6288
2000-08-28 11:16:11.92	12631	1	6289
2000-08-28 11:16:11.92	300	\N	6290
2000-08-28 11:16:11.92	640	\N	6291
2000-08-28 11:16:11.92	422	\N	6292
2000-08-28 11:16:11.92	10	\N	6293
2000-08-28 11:16:11.92	20	\N	6294
2000-08-28 11:16:11.96	5	1	6288
2000-08-28 11:16:11.96	12800	1	6289
2000-08-28 11:16:11.96	300	\N	6290
2000-08-28 11:16:11.96	610	\N	6291
2000-08-28 11:16:11.96	422	\N	6292
2000-08-28 11:16:11.96	10	\N	6293
2000-08-28 11:16:11.96	20	\N	6294
2000-08-28 11:16:12	5	1	6288
2000-08-28 11:16:12	13139	1	6289
\.


--
-- TOC entry 3669 (class 0 OID 16877)
-- Dependencies: 247
-- Data for Name: real_time_machine_parameters_active; Type: TABLE DATA; Schema: tiei_sample_5; Owner: postgres
--

COPY tiei_sample_5.real_time_machine_parameters_active (id, "time", value, condition_id, machine_parameters_id) FROM stdin;
1	2022-11-17 22:58:19.12	0	1	23
2	2022-11-17 22:58:19.12	0	1	24
3	2022-11-17 22:58:19.12	0	1	25
4	2022-11-17 22:58:19.12	10	1	26
5	2022-11-17 22:58:19.12	163	1	27
6	2022-11-17 22:58:19.12	0	3	28
7	2022-11-17 22:58:19.12	0	1	29
8	2024-05-31 04:48:26.5	82	1	31
9	2024-05-31 04:47:26.5	51	1	32
10	2024-05-31 04:19:26.5	45	1	33
11	2024-05-31 04:22:26.5	42	1	34
13	2024-05-31 04:55:26.5	10650	1	39
21	2024-05-30 16:23:26	0	1	59
22	2024-05-30 16:23:26	0	1	60
23	2024-05-30 16:23:26	0	1	61
24	2024-05-30 16:23:26	0	1	62
25	2024-05-30 16:23:26	0	1	63
26	2024-05-30 16:23:26	0	1	67
27	2024-05-30 16:23:26	0	1	68
28	2024-05-30 16:23:26	0	1	69
29	2024-05-30 16:23:26	0	1	70
30	2024-05-30 16:23:26	0	1	71
37	2024-05-30 07:41:21.5	0	1	84
38	2024-05-30 07:41:21.5	0	1	85
39	2024-05-30 07:41:21.5	0	1	86
40	2024-05-30 07:41:21.5	0	1	87
41	2024-05-30 07:41:21.5	0	1	88
42	2024-05-31 04:52:49.5	3	1	53
43	2024-05-30 16:23:26	0	1	92
44	2024-05-30 16:23:26	0	1	93
45	2024-05-30 16:23:26	0	1	94
46	2024-05-30 16:23:26	0	1	95
47	2024-05-30 16:23:26	0	1	96
48	2024-05-30 16:23:26	100	1	100
49	2024-05-30 16:23:26	100	1	101
50	2024-05-30 16:23:26	100	1	102
51	2024-05-30 16:23:26	100	1	103
52	2024-05-30 16:23:26	100	1	104
53	2024-05-30 16:23:26	100	1	108
64	2024-05-30 16:23:26	6400	1	125
65	2024-05-30 17:55:27.5	7200	1	126
66	2024-05-31 04:56:26.5	7800	1	127
67	2024-05-31 04:56:26.5	7800	1	128
68	2024-05-30 17:55:27.5	7200	1	129
70	2024-05-30 16:23:26	7000	1	134
72	2024-05-30 16:23:26	7000	1	136
73	2024-05-30 16:23:26	7000	1	137
74	2024-05-30 16:23:26	7000	1	138
75	2024-05-30 16:23:26	7000	1	139
76	2024-05-30 16:23:26	7000	1	140
78	2024-05-30 16:23:26	7200	1	145
79	2024-05-31 04:51:26.5	28	1	146
80	2024-05-31 04:56:26.5	77	1	147
81	2024-05-31 04:36:26.5	38	1	148
82	2024-05-31 03:17:26.5	32	1	149
83	2024-05-31 03:22:26.5	33	1	150
84	2024-05-31 04:56:26.5	39	1	154
85	2024-05-31 04:55:26.5	41	1	155
86	2024-05-31 04:34:26.5	40	1	156
87	2024-05-31 04:34:26.5	51	1	157
88	2024-05-31 04:55:26.5	40	1	158
89	2024-05-31 04:40:26.5	40	1	159
90	2024-05-31 04:54:26.5	5488	1	163
91	2024-05-31 04:56:26.5	10244	1	164
99	2024-05-30 16:23:26.5	0	1	184
100	2024-05-30 16:23:26.5	0	1	185
101	2024-05-30 16:23:26.5	0	1	186
102	2024-05-30 16:23:26.5	0	1	187
103	2024-05-30 16:23:26.5	0	1	188
104	2024-05-30 16:23:26.5	0	1	192
105	2024-05-30 16:23:26.5	0	1	193
106	2024-05-30 16:23:26.5	0	1	194
107	2024-05-30 16:23:26.5	0	1	195
108	2024-05-30 16:23:26.5	0	1	196
115	2024-05-30 16:23:26.5	0	1	209
116	2024-05-30 16:23:26.5	0	1	210
117	2024-05-30 16:23:26.5	0	1	211
118	2024-05-30 16:23:26.5	0	1	212
119	2024-05-30 16:23:26.5	0	1	213
120	2024-05-30 16:23:26.5	0	1	217
121	2024-05-30 16:23:26.5	0	1	218
122	2024-05-30 16:23:26.5	0	1	219
123	2024-05-30 16:23:26.5	0	1	220
124	2024-05-30 16:23:26.5	0	1	221
125	2024-05-30 16:23:26.5	100	1	225
126	2024-05-30 16:23:26.5	100	1	226
127	2024-05-30 16:23:26.5	100	1	227
128	2024-05-30 16:23:26.5	100	1	228
129	2024-05-30 16:23:26.5	100	1	229
130	2024-05-30 16:23:26.5	100	1	233
136	2024-05-31 04:27:19	1	1	178
137	2024-05-31 04:50:37.5	1	1	176
143	2024-05-31 01:02:26.5	6000	1	250
144	2024-05-30 16:23:26.5	7400	1	251
145	2024-05-30 16:23:26.5	11600	1	252
146	2024-05-30 16:23:26.5	7400	1	253
147	2024-05-30 16:23:26.5	11600	1	254
149	2024-05-31 04:47:26.5	6800	1	259
151	2024-05-31 04:47:26.5	6800	1	261
152	2024-05-31 04:47:26.5	6800	1	262
153	2024-05-31 04:47:26.5	6800	1	263
154	2024-05-31 04:47:26.5	6800	1	264
155	2024-05-31 04:47:26.5	6800	1	265
157	2024-05-30 16:23:26.5	7000	1	270
158	2024-05-31 02:49:26.5	29	1	271
159	2024-05-31 04:43:26.5	29	1	272
160	2024-05-31 04:50:26.5	40	1	273
161	2024-05-31 04:19:28	28	1	274
162	2024-05-31 04:09:26.5	31	1	275
163	2024-05-31 04:48:26.5	31	1	279
164	2024-05-31 04:49:26.5	49	1	280
165	2024-05-31 04:53:26.5	87	1	281
166	2024-05-31 04:56:26.5	57	1	282
167	2024-05-31 04:48:26.5	48	1	283
168	2024-05-31 04:26:26.5	53	1	284
169	2024-05-31 04:56:26.5	5444	1	288
170	2024-05-31 04:56:26.5	10656	1	289
178	2024-05-30 16:23:26.5	0	1	309
179	2024-05-30 16:23:26.5	0	1	310
180	2024-05-30 16:23:26.5	0	1	311
181	2024-05-30 16:23:26.5	0	1	312
182	2024-05-30 16:23:26.5	0	1	313
183	2024-05-30 16:23:26.5	0	1	317
184	2024-05-30 16:23:26.5	0	1	318
185	2024-05-30 16:23:26.5	0	1	319
186	2024-05-30 16:23:26.5	0	1	320
187	2024-05-30 16:23:26.5	0	1	321
194	2024-05-30 16:23:26.5	0	1	334
195	2024-05-30 16:23:26.5	0	1	335
196	2024-05-30 16:23:26.5	0	1	336
197	2024-05-30 16:23:26.5	0	1	337
198	2024-05-30 16:23:26.5	0	1	338
199	2024-05-30 16:23:26.5	0	1	342
200	2024-05-30 16:23:26.5	0	1	343
201	2024-05-30 16:23:26.5	0	1	344
202	2024-05-30 16:23:26.5	0	1	345
203	2024-05-30 16:23:26.5	0	1	346
204	2024-05-30 16:23:26.5	100	1	350
205	2024-05-30 16:23:26.5	100	1	351
206	2024-05-30 16:23:26.5	100	1	352
207	2024-05-30 16:23:26.5	100	1	353
208	2024-05-30 16:23:26.5	100	1	354
209	2024-05-30 16:23:26.5	100	1	358
220	2024-05-31 00:14:26.5	6400	1	375
221	2024-05-31 04:52:26.5	7200	1	376
222	2024-05-31 01:23:26.5	7800	1	377
223	2024-05-31 01:23:26.5	7800	1	378
224	2024-05-31 04:52:26.5	7200	1	379
226	2024-05-30 16:23:26.5	7200	1	384
228	2024-05-30 16:23:26.5	7200	1	386
229	2024-05-30 16:23:26.5	7200	1	387
230	2024-05-30 16:23:26.5	7200	1	388
231	2024-05-30 16:23:26.5	7200	1	389
232	2024-05-30 16:23:26.5	7200	1	390
234	2024-05-31 02:10:26.5	7400	1	395
235	2024-05-31 04:56:26.5	40	1	396
236	2024-05-31 04:53:26.5	89	1	397
237	2024-05-31 04:56:26.5	48	1	398
238	2024-05-31 04:52:26.5	41	1	399
239	2024-05-31 04:46:26.5	40	1	400
240	2024-05-31 04:56:26.5	43	1	404
241	2024-05-31 04:55:26.5	48	1	405
242	2024-05-31 04:52:26.5	90	1	406
243	2024-05-31 04:48:26.5	52	1	407
244	2024-05-31 04:49:26.5	49	1	408
245	2024-05-31 03:58:26.5	51	2	409
246	2024-05-31 04:55:26.5	5463	1	413
247	2024-05-31 04:56:26.5	10788	1	414
255	2024-05-30 16:23:26.5	0	1	434
256	2024-05-30 16:23:26.5	0	1	435
257	2024-05-30 16:23:26.5	0	1	436
258	2024-05-30 16:23:26.5	0	1	437
259	2024-05-30 16:23:26.5	0	1	438
260	2024-05-30 16:23:26.5	0	1	442
261	2024-05-30 16:23:26.5	0	1	443
262	2024-05-30 16:23:26.5	0	1	444
263	2024-05-30 16:23:26.5	0	1	445
264	2024-05-30 16:23:26.5	0	1	446
271	2024-05-30 16:23:26.5	0	1	459
272	2024-05-30 16:23:26.5	0	1	460
273	2024-05-30 16:23:26.5	0	1	461
274	2024-05-30 16:23:26.5	0	1	462
275	2024-05-30 16:23:26.5	0	1	463
276	2024-05-30 16:23:26.5	0	1	467
277	2024-05-30 16:23:26.5	0	1	468
278	2024-05-30 16:23:26.5	0	1	469
279	2024-05-30 16:23:26.5	0	1	470
280	2024-05-30 16:23:26.5	0	1	471
281	2024-05-30 16:23:26.5	100	1	475
282	2024-05-30 16:23:26.5	100	1	476
283	2024-05-30 16:23:26.5	100	1	477
284	2024-05-30 16:23:26.5	100	1	478
285	2024-05-30 16:23:26.5	100	1	479
286	2024-05-30 16:23:26.5	100	1	483
297	2024-05-31 02:30:26.5	6400	1	500
298	2024-05-30 16:23:26.5	7000	1	501
299	2024-05-30 16:23:26.5	7800	1	502
300	2024-05-30 16:23:26.5	7800	1	503
301	2024-05-30 16:23:26.5	7000	1	504
303	2024-05-30 16:23:26.5	7200	1	509
305	2024-05-30 16:23:26.5	7200	1	511
306	2024-05-30 16:23:26.5	7200	1	512
307	2024-05-30 16:23:26.5	7200	1	513
308	2024-05-30 16:23:26.5	7200	1	514
309	2024-05-30 16:23:26.5	7200	1	515
311	2024-05-30 16:23:26.5	7200	1	520
312	2024-05-31 04:50:26.5	39	1	521
313	2024-05-31 04:51:26.5	89	1	522
314	2024-05-31 04:51:26.5	46	1	523
315	2024-05-31 04:53:26.5	40	1	524
316	2024-05-31 03:19:26.5	38	1	525
317	2024-05-31 04:53:26.5	41	1	529
318	2024-05-31 04:47:31	50	1	530
319	2024-05-31 04:43:27.5	67	1	531
320	2024-05-31 04:44:28	69	1	532
321	2024-05-31 04:45:28	58	1	533
323	2024-05-31 04:44:28	47	1	535
324	2024-05-31 04:44:28	44	1	536
325	2024-05-31 04:47:31	5469	1	538
326	2024-05-31 04:56:28	10600	1	539
336	2024-05-30 16:23:27.5	0	1	559
337	2024-05-30 16:23:27.5	0	1	560
338	2024-05-30 16:23:27.5	0	1	561
339	2024-05-30 16:23:27.5	0	1	562
341	2024-05-30 16:23:27.5	0	1	564
342	2024-05-30 16:23:27.5	0	1	565
343	2024-05-30 16:23:27.5	0	1	567
344	2024-05-30 16:23:27.5	0	1	568
345	2024-05-30 16:23:27.5	0	1	569
346	2024-05-30 16:23:27.5	0	1	570
348	2024-05-30 16:23:27.5	0	1	572
349	2024-05-30 16:23:27.5	0	1	573
357	2024-05-30 16:23:27.5	0	1	584
358	2024-05-30 16:23:27.5	0	1	585
359	2024-05-30 16:23:27.5	0	1	586
360	2024-05-30 16:23:27.5	0	1	587
362	2024-05-30 16:23:27.5	0	1	589
363	2024-05-30 16:23:27.5	0	1	590
364	2024-05-30 16:23:27.5	0	1	592
365	2024-05-30 16:23:27.5	0	1	593
366	2024-05-30 16:23:27.5	0	1	594
367	2024-05-30 16:23:27.5	0	1	595
369	2024-05-30 16:23:27.5	0	1	597
370	2024-05-30 16:23:27.5	0	1	598
371	2024-05-30 16:23:27.5	100	1	600
372	2024-05-30 16:23:27.5	100	1	601
373	2024-05-30 16:23:27.5	100	1	602
374	2024-05-30 16:23:27.5	100	1	603
376	2024-05-30 16:23:27.5	100	1	605
377	2024-05-30 16:23:27.5	100	1	606
381	2024-05-31 01:12:04.5	38	1	553
400	2024-05-30 20:16:27.5	11400	1	636
401	2024-05-30 20:16:27.5	11400	1	637
402	2024-05-30 20:16:27.5	11400	1	638
403	2024-05-30 20:16:27.5	11400	1	639
405	2024-05-30 20:16:27.5	11400	1	641
406	2024-05-30 20:16:27.5	11400	1	642
407	2024-05-30 16:23:27.5	0	1	646
408	2024-05-30 16:23:27.5	0	1	647
409	2024-05-30 16:23:27.5	0	1	648
411	2024-05-31 04:51:28	37	1	651
412	2024-05-31 04:50:28.5	34	1	652
413	2024-05-31 04:15:34	51	1	655
414	2024-05-31 04:14:34	69	1	656
415	2024-05-31 04:12:34	71	1	657
416	2024-05-31 04:56:34.5	5475	1	663
417	2024-05-31 04:56:34.5	10744	1	664
423	2024-05-30 17:42:34	0	1	684
424	2024-05-30 17:42:34	0	1	685
425	2024-05-30 17:42:34	0	1	686
426	2024-05-30 17:42:34	0	1	692
427	2024-05-30 17:42:34	0	1	693
428	2024-05-30 17:42:34	0	1	694
432	2024-05-30 17:42:34	0	1	709
433	2024-05-30 17:42:34	0	1	710
434	2024-05-30 17:42:34	0	1	711
435	2024-05-30 17:42:34	0	1	717
436	2024-05-30 17:42:34	0	1	718
437	2024-05-30 17:42:34	0	1	719
438	2024-05-30 17:43:35	100	1	725
439	2024-05-30 17:43:35	100	1	726
440	2024-05-30 17:43:35	100	1	727
450	2024-05-30 16:22:53.5	0	1	1064
451	2024-05-30 20:08:34.5	11000	1	761
452	2024-05-30 20:08:34.5	11000	1	762
453	2024-05-30 20:08:34.5	11000	1	763
454	2024-05-30 17:42:34	0	1	771
455	2024-05-30 17:42:34	0	1	772
456	2024-05-30 17:42:34	0	1	773
457	2024-05-31 04:55:26	43	1	854
458	2024-05-31 04:50:26.5	50	1	855
459	2024-05-31 04:55:26	50	1	856
460	2024-05-31 04:41:26.5	46	1	857
461	2024-05-31 04:50:26.5	41	1	858
462	2024-05-31 04:53:26.5	5388	1	859
463	2024-05-31 04:55:26	10656	1	860
471	2024-05-30 16:23:26	0	1	874
472	2024-05-30 16:23:26	0	1	875
473	2024-05-30 16:23:26	0	1	876
474	2024-05-30 16:23:26	0	1	877
475	2024-05-30 16:23:26	0	1	878
476	2024-05-30 16:23:26	0	1	879
477	2024-05-30 16:23:26	0	1	880
478	2024-05-30 16:23:26	0	1	881
479	2024-05-30 16:23:26	0	1	882
480	2024-05-30 16:23:26	0	1	883
487	2024-05-30 16:22:53.5	0	1	890
488	2024-05-30 16:22:53.5	0	1	891
489	2024-05-30 16:22:53.5	0	1	892
490	2024-05-30 16:22:53.5	0	1	893
491	2024-05-30 16:22:53.5	0	1	894
492	2024-05-30 16:23:26	0	1	895
493	2024-05-30 16:23:26	0	1	896
494	2024-05-30 16:23:26	0	1	897
495	2024-05-30 16:23:26	0	1	898
496	2024-05-30 16:23:26	0	1	899
497	2024-05-30 16:23:26	100	1	900
498	2024-05-30 16:23:26	100	1	901
499	2024-05-30 16:23:26	100	1	902
500	2024-05-30 16:23:26	100	1	903
501	2024-05-31 03:54:26.5	100	1	904
502	2024-05-30 16:23:26	100	1	905
510	2024-05-31 01:46:14.5	2	1	871
514	2023-01-13 02:46:42.5	8000	1	916
515	2023-01-09 00:02:42.5	11600	1	917
516	2023-01-12 20:06:42.5	7800	1	918
517	2023-01-12 20:06:42.5	7800	1	919
518	2023-01-09 00:02:42.5	11600	1	920
520	2023-01-09 00:42:42.5	11200	1	922
522	2023-01-09 00:42:42.5	11200	1	924
523	2023-01-09 00:42:42.5	11200	1	925
524	2023-01-09 00:42:42.5	11200	1	926
525	2023-01-09 00:42:42.5	11200	1	927
526	2023-01-09 00:42:42.5	11200	1	928
528	2023-01-09 00:08:42.5	11400	1	930
529	2024-05-31 04:47:26.5	33	1	931
530	2024-05-31 04:56:26	39	1	932
531	2024-05-31 04:48:26	38	1	933
532	2024-05-31 04:52:26.5	34	1	934
533	2024-05-31 04:52:26.5	29	1	935
534	2024-05-31 04:47:26.5	34	1	936
535	2024-05-31 04:49:27	44	1	937
536	2024-05-31 04:56:27	52	1	938
537	2024-05-31 04:50:27	48	1	939
538	2024-05-31 04:39:27	44	1	940
539	2024-05-31 00:49:26.5	38	1	941
540	2024-05-31 04:55:27	5544	1	942
541	2024-05-31 04:55:27	10775	1	943
549	2024-05-30 16:23:27	0	1	957
550	2024-05-30 16:23:27	0	1	958
551	2024-05-30 16:23:27	0	1	959
552	2024-05-30 16:23:27	0	1	960
553	2024-05-30 16:23:27	0	1	961
554	2024-05-30 16:23:27	0	1	962
555	2024-05-30 16:23:27	0	1	963
556	2024-05-30 16:23:27	0	1	964
557	2024-05-30 16:23:27	0	1	965
558	2024-05-30 16:23:27	0	1	966
565	2024-05-30 16:23:27	0	1	973
566	2024-05-30 16:23:27	0	1	974
567	2024-05-30 16:23:27	0	1	975
568	2024-05-30 16:23:27	0	1	976
569	2024-05-30 16:23:27	0	1	977
570	2024-05-30 16:23:27	0	1	978
571	2024-05-30 16:23:27	0	1	979
572	2024-05-30 16:23:27	0	1	980
573	2024-05-30 16:23:27	0	1	981
574	2024-05-30 16:23:27	0	1	982
575	2024-05-30 16:23:27	100	1	983
576	2024-05-30 16:23:27	100	1	984
577	2024-05-30 16:23:27	100	1	985
578	2024-05-30 16:23:27	100	1	986
579	2024-05-31 04:09:27	92	1	987
580	2024-05-30 16:23:27	100	1	988
581	2024-05-30 22:38:14	5	1	955
592	2024-05-30 16:23:27	7800	1	999
593	2024-05-30 17:24:27	11600	1	1000
594	2024-05-31 00:41:27	7800	1	1001
595	2024-05-31 00:41:27	7800	1	1002
596	2024-05-30 17:24:27	11600	1	1003
598	2024-05-31 00:37:27	11200	1	1005
600	2024-05-31 00:38:27	11200	1	1007
601	2024-05-31 00:38:27	11200	1	1008
602	2024-05-31 00:38:27	11200	1	1009
603	2024-05-31 00:38:27	11200	1	1010
604	2024-05-31 00:38:27	11200	1	1011
606	2024-05-31 04:04:27	11400	1	1013
607	2024-05-31 04:54:27	31	1	1014
608	2024-05-31 04:51:27	41	1	1015
609	2024-05-31 04:46:27	36	1	1016
610	2024-05-31 04:54:27	32	1	1017
611	2024-05-31 04:38:27	27	1	1018
612	2024-05-31 04:54:27	34	1	1019
613	2024-05-31 04:38:26.5	40	1	1020
614	2024-05-31 04:49:26.5	50	1	1021
615	2024-05-31 04:51:26.5	45	1	1022
616	2024-05-30 16:23:26	0	1	1023
617	2024-05-31 04:35:26.5	40	1	1024
618	2024-05-31 03:16:26	39	1	1025
619	2024-05-31 04:56:26	5463	1	1026
620	2024-05-31 04:55:26	10694	1	1027
629	2024-05-30 16:23:26	0	1	1043
630	2024-05-30 16:23:26	0	1	1044
631	2024-05-30 16:23:26	0	1	1045
632	2024-05-30 16:23:26	0	1	1046
633	2024-05-30 16:23:26	0	1	1047
634	2024-05-30 16:23:26	0	1	1048
635	2024-05-30 16:23:26	0	1	1049
636	2024-05-30 16:23:26	0	1	1050
637	2024-05-30 16:23:26	0	1	1051
638	2024-05-30 16:23:26	0	1	1052
639	2024-05-30 16:23:26	0	1	1053
640	2024-05-30 16:23:26	0	1	1054
648	2024-05-30 16:22:53.5	0	1	1062
649	2024-05-30 16:22:53.5	0	1	1063
650	2024-05-31 03:56:23.5	3	1	1041
651	2024-05-31 03:56:18.5	17	1	1042
652	2024-05-30 16:22:53.5	0	1	1065
653	2024-05-30 16:22:53.5	0	1	1066
654	2024-05-30 16:22:53.5	0	1	1067
655	2024-05-30 16:23:26	0	1	1068
656	2024-05-30 16:23:26	0	1	1069
657	2024-05-30 16:23:26	0	1	1070
658	2024-05-30 16:23:26	0	1	1071
659	2024-05-30 16:23:26	0	1	1072
660	2024-05-30 16:23:26	0	1	1073
661	2024-05-30 16:23:26	100	1	1074
662	2024-05-30 16:23:26	100	1	1075
663	2024-05-30 16:23:26	100	1	1076
664	2024-05-31 03:57:26	48	2	1077
665	2024-05-30 16:23:26	100	1	1078
666	2024-05-31 03:57:26	46.7	2	1079
667	2024-05-30 16:23:26	100	1	1080
680	2023-01-09 00:04:16	7600	1	1093
681	2023-01-13 00:48:16	11800	1	1094
682	2023-01-11 19:00:16	7600	1	1095
683	2023-01-11 19:00:16	7600	1	1096
684	2023-01-09 01:12:16	12000	1	1097
686	2023-01-09 01:12:16	12000	1	1099
687	2023-01-13 02:51:16	10800	1	1100
689	2023-01-13 02:51:16	10800	1	1102
690	2023-01-13 02:51:16	10800	1	1103
691	2023-01-13 02:51:16	10800	1	1104
692	2023-01-13 02:51:16	10800	1	1105
693	2023-01-13 02:51:16	10800	1	1106
694	2023-01-13 02:51:16	10800	1	1107
696	2023-01-13 03:04:16	11400	1	1109
697	2024-05-31 04:52:26.5	30	1	1110
698	2024-05-31 04:49:26.5	36	1	1111
699	2024-05-31 04:52:26.5	33	1	1112
700	2024-05-31 04:42:26.5	30	1	1113
701	2024-05-31 04:53:26.5	31	1	1114
702	2024-05-31 03:05:26	29	1	1115
703	2024-05-31 04:51:26.5	29	1	1116
704	2024-05-31 04:30:16	43	1	1118
705	2024-05-31 04:21:16	40	1	1119
706	2024-05-31 02:42:16	0	1	1120
707	2024-05-31 04:54:16	5569	1	1125
708	2024-05-31 04:55:16	10438	1	1126
715	2024-05-31 02:42:16	0	1	1146
716	2024-05-31 02:42:16	0	1	1147
717	2024-05-31 02:42:16	0	1	1148
718	2024-05-31 02:42:16	0	1	1149
719	2024-05-31 02:42:16	0	1	1154
720	2024-05-31 02:42:16	0	1	1155
721	2024-05-31 02:42:16	0	1	1156
722	2024-05-31 02:42:16	0	1	1157
727	2024-05-31 02:42:16	0	1	1171
728	2024-05-31 02:42:16	0	1	1172
729	2024-05-31 02:42:16	0	1	1173
730	2024-05-31 02:42:16	0	1	1174
731	2024-05-31 02:42:16	0	1	1179
732	2024-05-31 02:42:16	0	1	1180
733	2024-05-31 02:42:16	0	1	1181
734	2024-05-31 02:42:16	0	1	1182
735	2024-05-31 02:44:16	100	1	1187
736	2024-05-31 02:44:16	100	1	1188
737	2024-05-31 02:44:16	100	1	1189
738	2024-05-31 02:44:16	100	1	1190
747	2024-05-31 02:42:16	12000	1	1213
749	2024-05-31 02:42:16	12000	1	1215
751	2024-05-31 04:44:16	11400	1	1223
752	2024-05-31 04:44:16	11400	1	1224
753	2024-05-31 04:44:16	11400	1	1225
754	2024-05-31 04:44:16	11400	1	1226
755	2024-05-31 04:30:16	31	1	1234
756	2024-05-31 04:54:16	29	1	1235
757	2024-05-31 02:42:16	0	1	1236
758	2024-05-31 03:55:26.5	50	1	1242
759	2024-05-31 04:44:27	50	1	1243
760	2024-05-31 03:45:27	49	1	1244
761	2024-05-31 04:28:27	46	1	1245
762	2024-05-31 04:45:26.5	54	1	1246
763	2024-05-31 04:43:27	57	1	1247
764	2024-05-31 04:30:27	48	1	1248
765	2024-05-31 04:55:26.5	5394	1	1249
766	2024-05-31 04:56:26.5	10475	1	1250
776	2024-05-30 16:23:26.5	0	1	1268
777	2024-05-30 16:23:26.5	0	1	1269
778	2024-05-30 16:23:26.5	0	1	1270
779	2024-05-30 16:23:26.5	0	1	1271
780	2024-05-30 16:23:26.5	0	1	1272
781	2024-05-30 16:23:26.5	0	1	1273
782	2024-05-30 16:23:26.5	0	1	1274
783	2024-05-30 16:23:26.5	0	1	1275
784	2024-05-30 16:23:26.5	0	1	1276
785	2024-05-30 16:23:26.5	0	1	1277
786	2024-05-30 16:23:26.5	0	1	1278
787	2024-05-30 16:23:26.5	0	1	1279
788	2024-05-30 16:23:26.5	0	1	1280
789	2024-05-30 16:23:26.5	0	1	1281
798	2024-05-30 16:23:26.5	0	1	1290
799	2024-05-31 02:44:50.5	5	1	1267
800	2024-05-30 16:23:26.5	0	1	1291
801	2024-05-30 16:23:26.5	0	1	1292
802	2024-05-30 16:23:26.5	0	1	1293
803	2024-05-30 16:23:26.5	0	1	1294
804	2024-05-30 16:23:26.5	0	1	1295
805	2024-05-30 16:23:26.5	0	1	1296
806	2024-05-30 16:23:26.5	0	1	1297
807	2024-05-30 16:23:26.5	0	1	1298
808	2024-05-30 16:23:26.5	0	1	1299
809	2024-05-30 16:23:26.5	0	1	1300
810	2024-05-30 16:23:26.5	0	1	1301
811	2024-05-30 16:23:26.5	0	1	1302
812	2024-05-30 16:23:26.5	0	1	1303
813	2024-05-30 16:23:26.5	100	1	1304
814	2024-05-30 16:23:26.5	100	1	1305
815	2024-05-30 16:23:26.5	100	1	1306
816	2024-05-30 16:23:26.5	100	1	1307
817	2024-05-30 16:23:26.5	100	1	1308
818	2024-05-30 16:23:26.5	100	1	1309
819	2024-05-30 16:23:26.5	100	1	1310
820	2024-05-30 16:23:26.5	100	1	1311
835	2023-01-12 11:05:14.5	7800	1	1326
836	2023-01-12 11:58:14.5	11800	1	1327
837	2023-01-12 11:58:14.5	11800	1	1328
838	2023-01-12 11:14:14.5	11600	1	1329
839	2023-01-12 11:14:14.5	11600	1	1330
841	2023-01-12 11:57:14.5	12000	1	1332
843	2023-01-12 23:18:14.5	7200	1	1334
845	2023-01-12 23:18:14.5	7200	1	1336
846	2023-01-12 23:18:14.5	7200	1	1337
847	2023-01-12 23:18:14.5	7200	1	1338
848	2023-01-12 23:18:14.5	7200	1	1339
849	2023-01-12 23:18:14.5	7200	1	1340
850	2023-01-12 23:18:14.5	7200	1	1341
851	2023-01-12 23:18:14.5	7200	1	1342
853	2023-01-09 00:20:14.5	11400	1	1344
854	2024-05-31 04:43:27	39	1	1345
855	2024-05-31 04:30:27	38	1	1346
856	2024-05-31 03:18:27	40	1	1347
857	2024-05-31 04:46:26.5	36	1	1348
858	2024-05-31 04:53:27	42	1	1349
859	2024-05-31 04:40:27	43	1	1350
860	2024-05-31 04:25:27	38	1	1351
861	2024-05-31 04:54:27	56	1	1352
862	2024-05-31 04:55:26.5	45	1	1353
863	2024-05-31 04:56:26.5	53	1	1354
864	2024-05-31 04:53:26.5	54	1	1355
865	2024-05-30 16:23:26.5	0	1	1356
866	2024-05-31 04:35:26.5	45	1	1357
867	2024-05-31 04:35:26.5	36	1	1358
868	2024-05-31 04:52:26.5	5500	1	1359
869	2024-05-31 04:56:26.5	10738	1	1360
878	2024-05-30 16:23:26.5	0	1	1376
879	2024-05-30 16:23:26.5	0	1	1377
880	2024-05-30 16:23:26.5	0	1	1378
881	2024-05-30 16:23:26.5	0	1	1379
882	2024-05-30 16:23:26.5	0	1	1380
883	2024-05-30 16:23:26.5	0	1	1381
884	2024-05-30 16:23:26.5	0	1	1382
885	2024-05-30 16:23:26.5	0	1	1383
886	2024-05-30 16:23:26.5	0	1	1384
887	2024-05-30 16:23:26.5	0	1	1385
888	2024-05-30 16:23:26.5	0	1	1386
889	2024-05-30 16:23:26.5	0	1	1387
897	2024-05-30 16:23:26.5	0	1	1395
898	2024-05-30 16:23:26.5	0	1	1396
899	2024-05-30 16:23:26.5	0	1	1397
900	2024-05-30 16:23:26.5	0	1	1398
901	2024-05-30 16:23:26.5	0	1	1399
902	2024-05-30 16:23:26.5	0	1	1400
903	2024-05-30 16:23:26.5	0	1	1401
904	2024-05-30 16:23:26.5	0	1	1402
905	2024-05-30 16:23:26.5	0	1	1403
906	2024-05-30 16:23:26.5	0	1	1404
907	2024-05-30 16:23:26.5	0	1	1405
908	2024-05-30 16:23:26.5	0	1	1406
909	2024-05-30 16:23:26.5	100	1	1407
910	2024-05-30 16:23:26.5	100	1	1408
911	2024-05-30 16:23:26.5	100	1	1409
912	2024-05-30 16:23:26.5	100	1	1410
913	2024-05-30 16:23:26.5	100	1	1411
914	2024-05-30 16:23:26.5	100	1	1412
915	2024-05-30 16:23:26.5	100	1	1413
928	2024-05-31 00:07:26.5	8000	1	1426
929	2023-01-13 03:08:37.5	11800	1	1427
930	2024-05-30 16:23:26.5	7800	1	1428
931	2024-05-30 16:23:26.5	7800	1	1429
932	2024-05-30 16:23:26.5	12000	1	1430
934	2024-05-30 16:23:26.5	12000	1	1432
935	2024-05-30 16:23:26.5	11400	1	1433
937	2023-01-10 06:40:37	11400	1	1435
938	2024-05-30 16:23:26.5	11400	1	1436
939	2024-05-30 16:23:26.5	11400	1	1437
940	2024-05-30 16:23:26.5	11400	1	1438
941	2024-05-30 16:23:26.5	11400	1	1439
942	2024-05-30 16:23:26.5	11400	1	1440
944	2024-05-31 02:05:23	13	1	1373
945	2024-05-30 16:23:26.5	11800	1	1442
946	2024-05-31 04:45:26.5	34	1	1443
947	2024-05-31 04:54:26.5	39	1	1444
948	2024-05-31 04:51:26.5	42	1	1445
949	2024-05-31 04:10:26.5	30	1	1446
950	2024-05-31 04:34:26.5	33	1	1447
951	2024-05-31 04:54:26.5	28	1	1448
952	2024-05-31 04:39:26.5	35	1	1449
953	2024-05-31 04:56:27	47	1	1450
954	2024-05-31 04:55:27	58	1	1451
955	2024-05-31 04:52:27	56	1	1452
956	2024-05-31 04:46:27	45	1	1453
957	2024-05-31 04:31:27	39	1	1454
958	2024-05-31 04:50:27	5488	1	1455
959	2024-05-31 04:56:27	10850	1	1456
967	2024-05-30 16:23:27	0	1	1470
968	2024-05-30 16:23:27	0	1	1471
969	2024-05-30 16:23:27	0	1	1472
970	2024-05-30 16:23:27	0	1	1473
971	2024-05-30 16:23:27	0	1	1474
972	2024-05-30 16:23:27	0	1	1475
973	2024-05-30 16:23:27	0	1	1476
974	2024-05-30 16:23:27	0	1	1477
975	2024-05-30 16:23:27	0	1	1478
976	2024-05-30 16:23:27	0	1	1479
983	2024-05-30 16:23:27	0	1	1486
984	2024-05-30 16:23:27	0	1	1487
985	2024-05-30 16:23:27	0	1	1488
986	2024-05-30 16:23:27	0	1	1489
987	2024-05-30 16:23:27	0	1	1490
988	2024-05-30 16:23:27	0	1	1491
989	2024-05-30 16:23:27	0	1	1492
990	2024-05-30 16:23:27	0	1	1493
991	2024-05-30 16:23:27	0	1	1494
992	2024-05-30 16:23:27	0	1	1495
993	2024-05-30 16:23:27	100	1	1496
994	2024-05-30 16:23:27	100	1	1497
995	2024-05-30 16:23:27	100	1	1498
996	2024-05-30 19:15:27.5	100	1	1499
997	2024-05-31 04:09:27.5	49.8	1	1500
998	2024-05-30 16:23:27	100	1	1501
1009	2024-05-31 04:02:27.5	7400	1	1512
1010	2024-05-31 04:00:27	11600	1	1513
1011	2024-05-30 18:29:27	7600	1	1514
1012	2024-05-30 18:29:27	7600	1	1515
1013	2024-05-31 04:00:27	11600	1	1516
1015	2024-05-30 16:23:27	11000	1	1518
1016	2024-05-31 02:36:48	67	1	1468
1018	2024-05-30 16:23:27	11000	1	1520
1019	2024-05-30 16:23:27	11000	1	1521
1020	2024-05-30 16:23:27	11000	1	1522
1021	2024-05-30 16:23:27	11000	1	1523
1022	2024-05-30 16:23:27	11000	1	1524
1024	2024-05-30 16:23:27	11400	1	1526
1025	2024-05-31 04:40:27	33	1	1527
1026	2024-05-31 04:55:27	43	1	1528
1027	2024-05-31 04:52:27	42	1	1529
1028	2024-05-31 04:39:27.5	35	1	1530
1029	2024-05-31 04:49:27	30	1	1531
1030	2024-05-31 04:50:27	36	1	1532
1031	2024-05-31 04:48:26	46	1	1533
1032	2024-05-31 04:56:26	58	1	1534
1033	2024-05-31 04:53:26	46	1	1535
1034	2024-05-31 04:53:26	44	1	1536
1035	2024-05-31 04:55:26	5494	1	1537
1036	2024-05-31 04:54:26	10238	1	1538
1043	2024-05-30 16:23:26	0	1	1549
1044	2024-05-30 16:23:26	0	1	1550
1045	2024-05-30 16:23:26	0	1	1551
1046	2024-05-30 16:23:26	0	1	1552
1047	2024-05-30 16:23:26	0	1	1553
1048	2024-05-30 16:23:26	0	1	1554
1049	2024-05-30 16:23:26	0	1	1555
1050	2024-05-30 16:23:26	0	1	1556
1055	2024-05-30 16:22:53.5	0	1	1561
1056	2024-05-30 16:22:53.5	0	1	1562
1057	2024-05-30 16:22:53.5	0	1	1563
1058	2024-05-30 16:22:53.5	0	1	1564
1059	2024-05-30 16:23:26	0	1	1565
1060	2024-05-30 16:23:26	0	1	1566
1061	2024-05-30 16:23:26	0	1	1567
1062	2024-05-30 16:23:26	0	1	1568
1063	2024-05-30 16:23:26	100	1	1569
1064	2024-05-30 16:23:26	100	1	1570
1065	2024-05-30 16:23:26	100	1	1571
1066	2024-05-30 16:23:26	100	1	1572
1075	2023-01-13 00:27:15	11000	1	1581
1076	2023-01-13 00:27:15	11000	1	1582
1079	2023-01-13 03:08:15	11200	1	1585
1080	2023-01-13 03:08:15	11200	1	1586
1081	2023-01-13 03:08:15	11200	1	1587
1082	2023-01-13 03:08:15	11200	1	1588
1083	2024-05-31 04:53:26	35	1	1589
1084	2024-05-31 04:51:26	45	1	1590
1085	2024-05-31 04:45:26	33	1	1591
1086	2024-05-31 04:49:26	32	1	1592
1087	2024-05-31 04:51:26	48	1	1593
1088	2024-05-31 04:53:26	55	1	1594
1089	2024-05-31 04:43:26	49	1	1595
1090	2024-05-31 04:48:26	49	1	1596
1091	2024-05-31 04:56:26	5475	1	1597
1092	2024-05-31 04:56:26	10550	1	1598
1099	2024-05-30 16:23:26	0	1	1609
1100	2024-05-30 16:23:26	0	1	1610
1101	2024-05-30 16:23:26	0	1	1611
1102	2024-05-30 16:23:26	0	1	1612
1103	2024-05-30 16:23:26	0	1	1613
1104	2024-05-30 16:23:26	0	1	1614
1105	2024-05-30 16:23:26	0	1	1615
1106	2024-05-30 16:23:26	0	1	1616
1111	2024-05-30 16:22:53.5	0	1	1621
1112	2024-05-30 16:22:53.5	0	1	1622
1113	2024-05-30 16:22:53.5	0	1	1623
1114	2024-05-30 16:22:53.5	0	1	1624
1115	2024-05-30 16:23:26	0	1	1625
1116	2024-05-30 16:23:26	0	1	1626
1117	2024-05-30 16:23:26	0	1	1627
1118	2024-05-30 16:23:26	0	1	1628
1119	2024-05-30 16:23:26	100	1	1629
1120	2024-05-30 16:23:26	100	1	1630
1121	2024-05-30 16:23:26	100	1	1631
1122	2024-05-30 16:23:26	100	1	1632
1131	2023-01-11 03:24:31.5	11800	1	1641
1135	2023-01-09 00:01:31.5	8800	1	1645
1136	2023-01-09 00:01:31.5	8800	1	1646
1137	2023-01-09 00:01:31.5	8800	1	1647
1138	2023-01-09 00:01:31.5	8800	1	1648
1139	2024-05-31 04:43:26	35	1	1649
1140	2024-05-31 04:50:26	43	1	1650
1141	2024-05-31 04:44:26	33	1	1651
1142	2024-05-31 04:54:26	33	1	1652
1143	2024-05-31 04:49:26	49	1	1653
1144	2024-05-31 04:56:26	57	1	1654
1145	2024-05-31 04:53:26	45	1	1655
1146	2024-05-31 04:42:26	43	1	1656
1147	2024-05-31 04:55:26	5500	1	1657
1148	2024-05-31 04:56:26	10356	1	1658
1155	2024-05-30 16:23:26	0	1	1669
1156	2024-05-30 16:23:26	0	1	1670
1157	2024-05-30 16:23:26	0	1	1671
1158	2024-05-30 16:23:26	0	1	1672
1159	2024-05-30 16:23:26	0	1	1673
1160	2024-05-30 16:23:26	0	1	1674
1161	2024-05-30 16:23:26	0	1	1675
1162	2024-05-30 16:23:26	0	1	1676
1167	2024-05-30 16:22:53.5	0	1	1681
1168	2024-05-30 16:22:53.5	0	1	1682
1169	2024-05-30 16:22:53.5	0	1	1683
1170	2024-05-30 16:22:53.5	0	1	1684
1171	2024-05-30 16:23:26	0	1	1685
1172	2024-05-30 16:23:26	0	1	1686
1173	2024-05-30 16:23:26	0	1	1687
1174	2024-05-30 16:23:26	0	1	1688
1175	2024-05-30 16:23:26	100	1	1689
1176	2024-05-30 16:23:26	100	1	1690
1177	2024-05-30 16:23:26	100	1	1691
1178	2024-05-30 16:23:26	100	1	1692
1187	2023-01-12 16:45:37.5	11000	1	1701
1188	2023-01-12 16:45:37.5	11000	1	1702
1191	2023-01-09 00:02:37.5	8800	1	1705
1192	2023-01-09 00:02:37.5	8800	1	1706
1193	2023-01-09 00:02:37.5	8800	1	1707
1194	2023-01-09 00:02:37.5	8800	1	1708
1195	2024-05-31 04:49:26	37	1	1709
1196	2024-05-31 04:51:26	45	1	1710
1197	2024-05-31 04:49:26	32	1	1711
1198	2024-05-31 04:45:26	27	1	1712
1199	2024-05-31 04:35:26	46	1	1713
1200	2024-05-31 04:48:26	51	1	1714
1201	2024-05-31 04:43:26	40	1	1715
1202	2024-05-31 04:49:26	43	1	1716
1203	2024-05-31 04:56:26	5469	1	1717
1204	2024-05-31 04:55:26	10650	1	1718
1211	2024-05-30 16:23:26	0	1	1729
1212	2024-05-30 16:23:26	0	1	1730
1213	2024-05-30 16:23:26	0	1	1731
1214	2024-05-30 16:23:26	0	1	1732
1215	2024-05-30 16:23:26	0	1	1733
1216	2024-05-30 16:23:26	0	1	1734
1217	2024-05-30 16:23:26	0	1	1735
1218	2024-05-30 16:23:26	0	1	1736
1223	2024-05-30 16:22:53.5	0	1	1741
1224	2024-05-30 16:22:53.5	0	1	1742
1225	2024-05-30 16:22:53.5	0	1	1743
1226	2024-05-30 16:22:53.5	0	1	1744
1227	2024-05-30 16:23:26	0	1	1745
1228	2024-05-30 16:23:26	0	1	1746
1229	2024-05-30 16:23:26	0	1	1747
1230	2024-05-30 16:23:26	0	1	1748
1231	2024-05-30 16:23:26	100	1	1749
1232	2024-05-30 16:23:26	100	1	1750
1233	2024-05-30 16:23:26	100	1	1751
1234	2024-05-30 16:23:26	100	1	1752
1247	2023-01-13 01:58:59	11000	1	1765
1248	2023-01-13 01:58:59	11000	1	1766
1249	2023-01-13 01:58:59	11000	1	1767
1250	2023-01-13 01:58:59	11000	1	1768
1251	2024-05-31 04:54:26	33	1	1769
1252	2024-05-31 04:48:26	40	1	1770
1253	2024-05-31 04:46:26	31	1	1771
1254	2024-05-31 04:37:26	30	1	1772
1255	2024-05-31 04:41:26	47	1	1773
1256	2024-05-31 04:49:26	53	1	1774
1257	2024-05-31 04:55:26	45	1	1775
1258	2024-05-31 04:42:26	46	1	1776
1259	2024-05-31 04:55:26	5525	1	1777
1260	2024-05-31 04:52:26	10538	1	1778
1267	2024-05-30 16:23:26	0	1	1789
1268	2024-05-30 16:23:26	0	1	1790
1269	2024-05-30 16:23:26	0	1	1791
1270	2024-05-30 16:23:26	0	1	1792
1271	2024-05-30 16:23:26	0	1	1793
1272	2024-05-30 16:23:26	0	1	1794
1273	2024-05-30 16:23:26	0	1	1795
1274	2024-05-30 16:23:26	0	1	1796
1279	2024-05-30 16:22:53.5	0	1	1801
1280	2024-05-30 16:22:53.5	0	1	1802
1281	2024-05-30 16:22:53.5	0	1	1803
1282	2024-05-30 16:22:53.5	0	1	1804
1283	2024-05-30 16:23:26	0	1	1805
1284	2024-05-30 16:23:26	0	1	1806
1285	2024-05-30 16:23:26	0	1	1807
1286	2024-05-30 16:23:26	0	1	1808
1287	2024-05-30 16:23:26	100	1	1809
1288	2024-05-30 16:23:26	100	1	1810
1289	2024-05-30 16:23:26	100	1	1811
1290	2024-05-30 16:23:26	100	1	1812
1299	2023-01-12 13:07:15	11400	1	1821
1300	2023-01-12 13:07:15	11400	1	1822
1303	2023-01-12 12:34:15	8800	1	1825
1304	2023-01-12 12:34:15	8800	1	1826
1305	2023-01-12 12:34:15	8800	1	1827
1306	2023-01-12 12:34:15	8800	1	1828
1307	2024-05-31 04:54:26	35	1	1829
1308	2024-05-31 04:50:26	42	1	1830
1309	2024-05-31 04:42:26	32	1	1831
1310	2024-05-31 04:41:26	31	1	1832
1311	2024-05-31 04:29:26	45	1	1833
1312	2024-05-31 04:48:26	55	1	1834
1313	2024-05-31 04:35:26	45	1	1835
1314	2024-05-31 04:52:26	46	1	1836
1315	2024-05-31 04:56:26	5475	1	1837
1316	2024-05-31 04:56:26	10619	1	1838
1323	2024-05-30 16:23:26	0	1	1849
1324	2024-05-30 16:23:26	0	1	1850
1325	2024-05-30 16:23:26	0	1	1851
1326	2024-05-30 16:23:26	0	1	1852
1327	2024-05-30 16:23:26	0	1	1853
1328	2024-05-30 16:23:26	0	1	1854
1329	2024-05-30 16:23:26	0	1	1855
1330	2024-05-30 16:23:26	0	1	1856
1335	2024-05-30 16:22:53.5	0	1	1861
1336	2024-05-30 16:22:53.5	0	1	1862
1337	2024-05-30 16:22:53.5	0	1	1863
1338	2024-05-30 16:22:53.5	0	1	1864
1339	2024-05-30 16:23:26	0	1	1865
1340	2024-05-30 16:23:26	0	1	1866
1341	2024-05-30 16:23:26	0	1	1867
1342	2024-05-30 16:23:26	0	1	1868
1343	2024-05-30 16:23:26	100	1	1869
1344	2024-05-30 16:23:26	100	1	1870
1345	2024-05-30 16:23:26	100	1	1871
1346	2024-05-30 16:23:26	100	1	1872
1355	2023-01-10 12:35:40	11800	1	1881
1356	2023-01-10 12:35:40	11800	1	1882
1359	2023-01-09 00:05:40	11200	1	1885
1360	2023-01-09 00:05:40	11200	1	1886
1361	2023-01-09 00:05:40	11200	1	1887
1362	2023-01-09 00:05:40	11200	1	1888
1363	2024-05-31 04:53:26	33	1	1889
1364	2024-05-31 04:52:26	41	1	1890
1365	2024-05-31 04:34:26	32	1	1891
1366	2024-05-31 04:46:26	30	1	1892
1367	2024-05-31 04:43:26	46	1	1893
1368	2024-05-31 04:48:26	55	1	1894
1369	2024-05-31 04:53:26	44	1	1895
1370	2024-05-31 04:47:26	47	1	1896
1371	2024-05-31 04:55:26	5450	1	1897
1372	2024-05-31 04:56:26	10644	1	1898
1379	2024-05-30 16:23:26	0	1	1909
1380	2024-05-30 16:23:26	0	1	1910
1381	2024-05-30 16:23:26	0	1	1911
1382	2024-05-30 16:23:26	0	1	1912
1383	2024-05-30 16:23:26	0	1	1913
1384	2024-05-30 16:23:26	0	1	1914
1385	2024-05-30 16:23:26	0	1	1915
1386	2024-05-30 16:23:26	0	1	1916
1391	2024-05-30 16:22:53.5	0	1	1921
1392	2024-05-30 16:22:53.5	0	1	1922
1393	2024-05-30 16:22:53.5	0	1	1923
1394	2024-05-30 16:22:53.5	0	1	1924
1395	2024-05-30 16:23:26	0	1	1925
1396	2024-05-30 16:23:26	0	1	1926
1397	2024-05-30 16:23:26	0	1	1927
1398	2024-05-30 16:23:26	0	1	1928
1399	2024-05-30 16:23:26	100	1	1929
1400	2024-05-30 16:23:26	100	1	1930
1401	2024-05-30 16:23:26	100	1	1931
1402	2024-05-30 16:23:26	100	1	1932
1411	2023-01-09 00:04:48.5	11600	1	1941
1415	2023-01-09 00:04:48.5	11600	1	1945
1416	2023-01-09 00:04:48.5	11600	1	1946
1417	2023-01-09 00:04:48.5	11600	1	1947
1418	2023-01-09 00:04:48.5	11600	1	1948
1419	2024-05-31 04:45:26	36	1	1949
1420	2024-05-31 04:53:26	43	1	1950
1421	2024-05-31 04:51:26	31	1	1951
1422	2024-05-31 04:40:26	32	1	1952
1423	2024-05-31 04:56:28	43	1	1953
1424	2024-05-31 04:56:28	44	1	1954
1425	2024-05-31 04:53:28	54	1	1955
1426	2024-05-31 04:56:28	56	1	1956
1428	2024-05-31 04:56:28	45	1	1958
1429	2024-05-31 03:51:27.5	47	1	1959
1430	2024-05-31 04:42:27.5	44	1	1960
1431	2024-05-31 04:56:28	5500	1	1961
1432	2024-05-31 04:56:28	11006	1	1962
1442	2024-05-30 16:23:27	0	1	1982
1443	2024-05-30 16:23:27	0	1	1983
1444	2024-05-30 16:23:27	0	1	1984
1445	2024-05-30 16:23:27	0	1	1985
1447	2024-05-30 16:23:27	0	1	1987
1448	2024-05-30 16:23:27	0	1	1988
1449	2024-05-30 16:23:27	0	1	1989
1450	2024-05-30 16:23:27	0	1	1990
1451	2024-05-30 16:23:27	0	1	1991
1452	2024-05-30 16:23:27	0	1	1992
1453	2024-05-30 16:23:27	0	1	1993
1455	2024-05-30 16:23:27	0	1	1995
1456	2024-05-30 16:23:27	0	1	1996
1457	2024-05-30 16:23:27	0	1	1997
1467	2024-05-30 16:23:27	0	1	2007
1468	2024-05-30 16:23:27	0	1	2008
1469	2024-05-30 16:23:27	0	1	2009
1470	2024-05-30 16:23:27	0	1	2010
1472	2024-05-30 16:23:27	0	1	2012
1473	2024-05-30 16:23:27	0	1	2013
1474	2024-05-30 16:23:27	0	1	2014
1475	2024-05-30 16:23:27	0	1	2015
1476	2024-05-30 16:23:27	0	1	2016
1477	2024-05-30 16:23:27	0	1	2017
1478	2024-05-30 16:23:27	0	1	2018
1480	2024-05-30 16:23:27	0	1	2020
1481	2024-05-30 16:23:27	0	1	2021
1482	2024-05-30 16:23:27	0	1	2022
1483	2024-05-30 16:23:27	100	1	2023
1484	2024-05-30 16:23:27	100	1	2024
1485	2024-05-30 16:23:27	100	1	2025
1486	2024-05-30 16:23:27	100	1	2026
1488	2024-05-30 16:23:27	100	1	2028
1489	2024-05-30 16:23:27	100	1	2029
1490	2024-05-30 16:23:27	100	1	2030
1491	2024-05-30 16:23:27	100	1	2031
1508	2024-05-31 03:03:27.5	6200	1	2048
1510	2024-05-31 04:37:33	27	1	1978
1511	2024-05-30 16:23:27	7800	1	2049
1512	2024-05-30 16:23:27	7800	1	2050
1513	2024-05-30 16:23:27	7600	1	2051
1514	2024-05-30 16:23:27	7600	1	2052
1516	2024-05-30 16:23:27	12000	1	2054
1518	2024-05-30 16:23:27	12000	1	2056
1519	2024-05-30 16:23:27	7400	1	2057
1521	2024-05-30 16:23:27	7400	1	2059
1522	2024-05-30 16:23:27	7400	1	2060
1523	2024-05-30 16:23:27	7400	1	2061
1524	2024-05-30 16:23:27	7400	1	2062
1526	2024-05-30 16:23:27	7400	1	2064
1527	2024-05-30 16:23:27	7400	1	2065
1528	2024-05-30 16:23:27	7400	1	2066
1530	2024-05-30 16:54:28	7200	1	2068
1531	2024-05-31 04:45:27.5	32	1	2069
1532	2024-05-31 04:44:27.5	34	1	2070
1533	2024-05-31 04:44:27.5	42	1	2071
1534	2024-05-31 04:50:28	44	1	2072
1536	2024-05-31 03:42:28	35	1	2074
1537	2024-05-31 04:56:28	35	1	2075
1538	2024-05-31 03:13:27.5	33	1	2076
1539	2024-05-31 04:49:28	44	1	2077
1540	2024-05-31 04:50:28.5	48	1	2078
1541	2024-05-31 04:56:28.5	47	1	2079
1542	2024-05-31 04:56:28.5	57	1	2080
1543	2024-05-30 16:23:28	0	1	2082
1544	2024-05-31 04:56:28.5	46	1	2083
1545	2024-05-31 04:22:28	44	1	2084
1546	2024-05-31 03:41:28	47	1	2085
1559	2024-05-30 16:23:28	0	1	2107
1560	2024-05-30 16:23:28	0	1	2108
1561	2024-05-30 16:23:28	0	1	2109
1562	2024-05-30 16:23:28	0	1	2110
1563	2024-05-30 16:23:28	0	1	2111
1564	2024-05-30 16:23:28	0	1	2112
1565	2024-05-30 16:23:28	0	1	2113
1566	2024-05-30 16:23:28	0	1	2114
1567	2024-05-30 16:23:28	0	1	2115
1568	2024-05-30 16:23:28	0	1	2116
1569	2024-05-30 16:23:28	0	1	2117
1570	2024-05-30 16:23:28	0	1	2118
1571	2024-05-30 16:23:28	0	1	2119
1572	2024-05-30 16:23:28	0	1	2120
1573	2024-05-30 16:23:28	0	1	2121
1574	2024-05-30 16:23:28	0	1	2122
1576	2024-05-31 04:56:28.5	56	1	2081
1577	2024-05-30 07:42:18.5	12	1	2102
1586	2024-05-30 16:23:28	0	1	2132
1587	2024-05-30 16:23:28	0	1	2133
1588	2024-05-30 16:23:28	0	1	2134
1589	2024-05-30 16:23:28	0	1	2135
1590	2024-05-30 16:23:28	0	1	2136
1591	2024-05-30 16:23:28	0	1	2137
1592	2024-05-30 16:23:28	0	1	2138
1593	2024-05-30 16:23:28	0	1	2139
1594	2024-05-30 16:23:28	0	1	2140
1595	2024-05-30 16:23:28	0	1	2141
1596	2024-05-30 16:23:28	0	1	2142
1597	2024-05-30 16:23:28	0	1	2143
1598	2024-05-30 16:23:28	0	1	2144
1599	2024-05-30 16:23:28	0	1	2145
1600	2024-05-30 16:23:28	0	1	2146
1601	2024-05-30 16:23:28	0	1	2147
1602	2024-05-30 16:23:28	100	1	2148
1603	2024-05-30 16:23:28	100	1	2149
1604	2024-05-30 16:23:28	100	1	2150
1605	2024-05-30 16:23:28	100	1	2151
1606	2024-05-30 16:23:28	100	1	2152
1607	2024-05-30 16:23:28	100	1	2153
1608	2024-05-30 16:23:28	100	1	2154
1609	2024-05-30 16:23:28	100	1	2155
1610	2024-05-30 16:23:28	100	1	2156
1627	2024-05-31 04:11:28.5	6200	1	2173
1628	2024-05-31 04:11:28.5	7200	1	2174
1629	2024-05-31 04:11:28.5	7200	1	2175
1630	2024-05-31 04:56:28.5	7400	1	2176
1631	2024-05-31 04:56:28.5	7400	1	2177
1633	2024-05-30 16:23:28	12000	1	2179
1635	2024-05-30 16:23:28	12000	1	2181
1636	2024-05-30 16:23:28	7400	1	2182
1638	2024-05-30 16:23:28	7400	1	2184
1639	2024-05-30 16:23:28	7400	1	2185
1640	2024-05-30 16:23:28	7400	1	2186
1641	2024-05-30 16:23:28	7400	1	2187
1643	2024-05-30 16:23:28	7400	1	2189
1644	2024-05-30 16:23:28	7400	1	2190
1645	2024-05-30 16:23:28	7400	1	2191
1647	2024-05-31 04:56:28.5	7000	1	2193
1648	2024-05-31 04:54:28.5	35	1	2194
1649	2024-05-31 04:55:28	38	1	2195
1650	2024-05-31 04:51:28	44	1	2196
1651	2024-05-31 04:51:28	47	1	2197
1652	2024-05-30 16:23:28	0	1	2198
1653	2024-05-31 03:47:28.5	35	1	2199
1654	2024-05-31 04:54:28.5	34	1	2200
1655	2024-05-31 03:26:28	33	1	2201
1656	2024-05-31 04:56:28.5	43	1	2202
1657	2024-05-31 04:53:27.5	49	1	2203
1658	2024-05-31 04:54:27.5	50	1	2204
1659	2024-05-31 04:54:27.5	59	1	2205
1660	2024-05-31 04:54:27.5	56	1	2206
1661	2024-05-30 16:23:27.5	0	1	2207
1662	2024-05-31 04:52:27.5	48	1	2208
1663	2024-05-31 04:38:28	47	1	2209
1664	2024-05-31 04:52:27.5	47	1	2210
1665	2024-05-31 04:56:27.5	5519	1	2211
1666	2024-05-31 04:56:27.5	10781	1	2212
1677	2024-05-30 16:23:27.5	0	1	2232
1678	2024-05-30 16:23:27.5	0	1	2233
1679	2024-05-30 16:23:27.5	0	1	2234
1680	2024-05-30 16:23:27.5	0	1	2235
1681	2024-05-30 16:23:27.5	0	1	2236
1682	2024-05-30 16:23:27.5	0	1	2237
1683	2024-05-30 16:23:27.5	0	1	2238
1684	2024-05-30 16:23:27.5	0	1	2239
1685	2024-05-30 16:23:27.5	0	1	2240
1686	2024-05-30 16:23:27.5	0	1	2241
1687	2024-05-30 16:23:27.5	0	1	2242
1688	2024-05-30 16:23:27.5	0	1	2243
1689	2024-05-30 16:23:27.5	0	1	2244
1690	2024-05-30 16:23:27.5	0	1	2245
1691	2024-05-30 16:23:27.5	0	1	2246
1692	2024-05-30 16:23:27.5	0	1	2247
1702	2024-05-30 16:23:27.5	0	1	2257
1703	2024-05-30 16:23:27.5	0	1	2258
1704	2024-05-30 16:23:27.5	0	1	2259
1705	2024-05-30 16:23:27.5	0	1	2260
1706	2024-05-30 16:23:27.5	0	1	2261
1707	2024-05-30 16:23:27.5	0	1	2262
1708	2024-05-30 16:23:27.5	0	1	2263
1709	2024-05-30 16:23:27.5	0	1	2264
1710	2024-05-30 16:23:27.5	0	1	2265
1711	2024-05-30 16:23:27.5	0	1	2266
1712	2024-05-30 16:23:27.5	0	1	2267
1713	2024-05-30 16:23:27.5	0	1	2268
1714	2024-05-30 16:23:27.5	0	1	2269
1715	2024-05-30 16:23:27.5	0	1	2270
1716	2024-05-30 16:23:27.5	0	1	2271
1717	2024-05-30 16:21:33	25	1	2227
1718	2024-05-30 16:23:27.5	0	1	2272
1719	2024-05-30 16:23:27.5	100	1	2273
1720	2024-05-30 16:23:27.5	100	1	2274
1721	2024-05-30 16:23:27.5	100	1	2275
1722	2024-05-30 16:23:27.5	100	1	2276
1723	2024-05-30 16:23:27.5	100	1	2277
1724	2024-05-30 16:23:27.5	100	1	2278
1725	2024-05-30 16:23:27.5	100	1	2279
1726	2024-05-30 16:23:27.5	100	1	2280
1727	2024-05-30 16:23:27.5	100	1	2281
1744	2024-05-30 16:23:27.5	6400	1	2298
1745	2024-05-30 16:23:27.5	7800	1	2299
1746	2024-05-30 16:23:27.5	7800	1	2300
1747	2024-05-30 16:23:27.5	7600	1	2301
1748	2024-05-30 16:23:27.5	7600	1	2302
1750	2024-05-31 04:48:27.5	12000	1	2304
1752	2024-05-31 04:48:27.5	12000	1	2306
1753	2024-05-30 16:22:53.5	0	1	2307
1755	2024-05-30 16:23:27.5	7400	1	2309
1756	2024-05-30 16:23:27.5	7400	1	2310
1757	2024-05-30 16:23:27.5	7400	1	2311
1758	2024-05-30 16:23:27.5	7400	1	2312
1760	2024-05-30 16:23:27.5	7400	1	2314
1761	2024-05-30 16:23:27.5	7400	1	2315
1762	2024-05-30 16:23:27.5	7400	1	2316
1764	2024-05-30 16:23:27.5	7200	1	2318
1765	2024-05-31 04:56:27.5	38	1	2319
1766	2024-05-31 04:56:27.5	41	1	2320
1767	2024-05-31 04:55:27.5	48	1	2321
1768	2024-05-31 04:55:27.5	47	1	2322
1769	2024-05-30 16:23:27.5	0	1	2323
1770	2024-05-31 04:51:27.5	36	1	2324
1771	2024-05-31 04:49:27.5	34	1	2325
1772	2024-05-31 04:39:28	34	1	2326
1773	2024-05-31 04:56:27.5	49	1	2327
1774	2024-05-31 04:55:28	47	1	2328
1775	2024-05-31 04:56:28	47	1	2329
1776	2024-05-31 04:56:28	52	1	2330
1777	2024-05-31 04:50:28	54	1	2331
1778	2024-05-30 16:23:27.5	0	1	2332
1779	2024-05-31 04:56:28	45	1	2333
1780	2024-05-31 04:54:28	45	1	2334
1781	2024-05-31 04:51:28	45	1	2335
1782	2024-05-31 04:56:28	5400	1	2336
1783	2024-05-31 04:55:28	10863	1	2337
1794	2024-05-30 16:23:27.5	0	1	2357
1795	2024-05-30 16:23:27.5	0	1	2358
1796	2024-05-30 16:23:27.5	0	1	2359
1797	2024-05-30 16:23:27.5	0	1	2360
1798	2024-05-30 16:23:27.5	0	1	2361
1799	2024-05-30 16:23:27.5	0	1	2362
1800	2024-05-30 16:23:27.5	0	1	2363
1801	2024-05-30 16:23:27.5	0	1	2364
1802	2024-05-30 16:23:27.5	0	1	2365
1803	2024-05-30 16:23:27.5	0	1	2366
1804	2024-05-30 16:23:27.5	0	1	2367
1805	2024-05-30 16:23:27.5	0	1	2368
1806	2024-05-30 16:23:27.5	0	1	2369
1807	2024-05-30 16:23:27.5	0	1	2370
1808	2024-05-30 16:23:27.5	0	1	2371
1809	2024-05-30 16:23:27.5	0	1	2372
1819	2024-05-30 16:23:27.5	0	1	2382
1820	2024-05-30 16:23:27.5	0	1	2383
1821	2024-05-30 16:23:27.5	0	1	2384
1822	2024-05-30 16:23:27.5	0	1	2385
1823	2024-05-30 16:23:27.5	0	1	2386
1824	2024-05-30 16:23:27.5	0	1	2387
1825	2024-05-30 16:23:27.5	0	1	2388
1826	2024-05-30 16:23:27.5	0	1	2389
1827	2024-05-30 16:23:27.5	0	1	2390
1828	2024-05-30 16:23:27.5	0	1	2391
1829	2024-05-30 16:23:27.5	0	1	2392
1830	2024-05-30 16:23:27.5	0	1	2393
1831	2024-05-30 16:23:27.5	0	1	2394
1832	2024-05-30 16:23:27.5	0	1	2395
1833	2024-05-30 16:23:27.5	0	1	2396
1834	2024-05-30 16:23:27.5	0	1	2397
1835	2024-05-30 16:23:27.5	100	1	2398
1836	2024-05-30 16:23:27.5	100	1	2399
1837	2024-05-30 16:23:27.5	100	1	2400
1838	2024-05-30 16:23:27.5	100	1	2401
1839	2024-05-30 16:23:27.5	100	1	2402
1840	2024-05-30 16:23:27.5	100	1	2403
1841	2024-05-30 16:23:27.5	100	1	2404
1842	2024-05-30 16:23:27.5	100	1	2405
1843	2024-05-30 16:23:27.5	100	1	2406
1860	2024-05-30 16:23:27.5	6400	1	2423
1861	2024-05-31 04:33:27.5	7600	1	2424
1862	2024-05-31 04:33:27.5	7600	1	2425
1863	2024-05-30 22:07:27.5	7600	1	2426
1864	2024-05-30 22:07:27.5	7600	1	2427
1866	2024-05-31 04:52:28	11600	1	2429
1868	2024-05-31 04:52:28	11600	1	2431
1869	2024-05-30 16:22:54	0	1	2432
1871	2024-05-30 16:23:27.5	7000	1	2434
1872	2024-05-30 16:23:27.5	7000	1	2435
1873	2024-05-30 16:23:27.5	7000	1	2436
1874	2024-05-30 16:23:27.5	7000	1	2437
1875	2024-05-30 16:23:27.5	7000	1	2438
1876	2024-05-30 16:23:27.5	7000	1	2439
1877	2024-05-30 16:23:27.5	7000	1	2440
1878	2024-05-30 16:23:27.5	7000	1	2441
1880	2024-05-30 16:23:27.5	7200	1	2443
1881	2024-05-31 04:54:28	34	1	2444
1882	2024-05-31 04:46:28	38	1	2445
1883	2024-05-31 04:55:28	40	1	2446
1884	2024-05-31 04:55:28	44	1	2447
1885	2024-05-30 16:23:27.5	0	1	2448
1886	2024-05-31 03:40:27.5	35	1	2449
1887	2024-05-31 04:42:28	33	1	2450
1888	2024-05-31 04:42:28	32	1	2451
1889	2024-05-31 04:55:28	52	1	2452
1890	2024-05-31 04:54:09.5	49	1	2453
1891	2024-05-31 04:56:09.5	51	1	2454
1892	2024-05-31 04:56:09.5	56	1	2455
1893	2024-05-31 04:55:09.5	58	1	2456
1894	2024-05-30 16:23:09	0	1	2457
1895	2024-05-31 04:54:09.5	47	1	2458
1896	2024-05-31 04:26:09.5	47	1	2459
1897	2024-05-31 04:56:09.5	46	1	2460
1898	2024-05-31 04:56:09.5	5506	1	2461
1899	2024-05-31 04:56:09.5	10463	1	2462
1910	2024-05-30 16:23:09	0	1	2482
1911	2024-05-30 16:23:09	0	1	2483
1912	2024-05-30 16:23:09	0	1	2484
1913	2024-05-30 16:23:09	0	1	2485
1914	2024-05-30 16:23:09	0	1	2486
1915	2024-05-30 16:23:09	0	1	2487
1916	2024-05-30 16:23:09	0	1	2488
1917	2024-05-30 16:23:09	0	1	2489
1918	2024-05-30 16:23:09	0	1	2490
1919	2024-05-30 16:23:09	0	1	2491
1920	2024-05-30 16:23:09	0	1	2492
1921	2024-05-31 00:01:00.5	18	1	2479
1922	2024-05-30 16:23:09	0	1	2493
1923	2024-05-30 16:23:09	0	1	2494
1924	2024-05-30 16:23:09	0	1	2495
1925	2024-05-30 16:23:09	0	1	2496
1926	2024-05-30 16:23:09	0	1	2497
1936	2024-05-30 16:23:09	0	1	2507
1937	2024-05-30 16:23:09	0	1	2508
1938	2024-05-30 16:23:09	0	1	2509
1939	2024-05-30 16:23:09	0	1	2510
1940	2024-05-30 16:23:09	0	1	2511
1941	2024-05-30 16:23:09	0	1	2512
1942	2024-05-30 16:23:09	0	1	2513
1943	2024-05-30 16:23:09	0	1	2514
1944	2024-05-30 16:23:09	0	1	2515
1945	2024-05-30 16:23:09	0	1	2516
1946	2024-05-30 16:23:09	0	1	2517
1947	2024-05-30 16:23:09	0	1	2518
1948	2024-05-30 16:23:09	0	1	2519
1949	2024-05-30 16:23:09	0	1	2520
1950	2024-05-30 16:23:09	0	1	2521
1951	2024-05-30 16:23:09	0	1	2522
1952	2024-05-30 16:23:09	100	1	2523
1953	2024-05-30 16:23:09	100	1	2524
1954	2024-05-30 16:23:09	100	1	2525
1955	2024-05-30 16:23:09	100	1	2526
1956	2024-05-30 16:23:09	100	1	2527
1957	2024-05-30 16:23:09	100	1	2528
1958	2024-05-30 16:23:09	100	1	2529
1959	2024-05-30 16:23:09	100	1	2530
1960	2024-05-30 16:23:09	100	1	2531
1977	2024-05-30 16:23:09	6400	1	2548
1978	2024-05-31 04:50:09.5	7600	1	2549
1979	2024-05-31 04:50:09.5	7600	1	2550
1980	2024-05-30 16:23:09	7600	1	2551
1981	2024-05-30 16:23:09	7600	1	2552
1983	2024-05-31 00:03:09	11600	1	2554
1985	2024-05-31 00:03:09	11600	1	2556
1986	2024-05-30 17:26:09.5	7200	1	2557
1988	2024-05-30 17:26:09.5	7200	1	2559
1989	2024-05-30 17:26:09.5	7200	1	2560
1990	2024-05-30 17:26:09.5	7200	1	2561
1991	2024-05-30 17:26:09.5	7200	1	2562
1992	2024-05-30 17:26:09.5	7200	1	2563
1993	2024-05-30 17:26:09.5	7200	1	2564
1994	2024-05-30 17:26:09.5	7200	1	2565
1995	2024-05-30 17:26:09.5	7200	1	2566
1997	2024-05-30 16:23:09	7200	1	2568
1998	2024-05-31 04:56:09.5	36	1	2569
1999	2024-05-31 04:56:09.5	40	1	2570
2000	2024-05-31 04:50:09.5	42	1	2571
2001	2024-05-31 04:55:09.5	45	1	2572
2002	2024-05-30 16:23:09	0	1	2573
2003	2024-05-31 04:37:09.5	36	1	2574
2004	2024-05-31 04:54:09.5	35	1	2575
2005	2024-05-31 04:39:09.5	34	1	2576
2006	2024-05-31 04:56:09.5	56	1	2577
2007	2024-05-31 04:50:27.5	41	1	2578
2008	2024-05-31 04:56:27.5	45	1	2579
2009	2024-05-31 04:56:27.5	47	1	2580
2010	2024-05-31 04:50:27.5	50	1	2581
2012	2024-05-31 04:50:27.5	48	1	2583
2013	2024-05-31 04:56:27.5	45	1	2584
2014	2024-05-31 03:14:28	44	1	2585
2015	2024-05-31 04:56:27.5	5494	1	2586
2016	2024-05-31 04:55:27.5	10731	1	2587
2027	2024-05-30 16:23:27.5	0	1	2607
2028	2024-05-30 16:23:27.5	0	1	2608
2029	2024-05-30 16:23:27.5	0	1	2609
2030	2024-05-30 16:23:27.5	0	1	2610
2032	2024-05-30 16:23:27.5	0	1	2612
2033	2024-05-30 16:23:27.5	0	1	2613
2034	2024-05-30 16:23:27.5	0	1	2614
2035	2024-05-30 16:23:27.5	0	1	2615
2036	2024-05-30 16:23:27.5	0	1	2616
2037	2024-05-30 16:23:27.5	0	1	2617
2038	2024-05-30 16:23:27.5	0	1	2618
2040	2024-05-30 16:23:27.5	0	1	2620
2041	2024-05-30 16:23:27.5	0	1	2621
2042	2024-05-30 16:23:27.5	0	1	2622
2052	2024-05-30 16:23:27.5	0	1	2632
2053	2024-05-30 16:23:27.5	0	1	2633
2054	2024-05-30 16:23:27.5	0	1	2634
2055	2024-05-30 16:23:27.5	0	1	2635
2057	2024-05-30 16:23:27.5	0	1	2637
2058	2024-05-30 16:23:27.5	0	1	2638
2059	2024-05-30 16:23:27.5	0	1	2639
2060	2024-05-30 16:23:27.5	0	1	2640
2061	2024-05-30 16:23:27.5	0	1	2641
2063	2024-05-30 16:23:27.5	0	1	2642
2064	2024-05-30 16:23:27.5	0	1	2643
2066	2024-05-30 16:23:27.5	0	1	2645
2067	2024-05-30 16:23:27.5	0	1	2646
2068	2024-05-30 16:23:27.5	0	1	2647
2069	2024-05-30 16:23:27.5	100	1	2648
2070	2024-05-30 16:23:27.5	100	1	2649
2071	2024-05-30 16:23:27.5	100	1	2650
2072	2024-05-30 16:23:27.5	100	1	2651
2074	2024-05-30 16:23:27.5	100	1	2653
2075	2024-05-30 16:23:27.5	100	1	2654
2076	2024-05-30 16:23:27.5	100	1	2655
2077	2024-05-30 16:23:27.5	100	1	2656
2094	2024-05-30 16:23:27.5	6400	1	2673
2095	2024-05-30 16:23:27.5	7600	1	2674
2096	2024-05-30 16:23:27.5	7600	1	2675
2097	2024-05-30 16:23:27.5	7600	1	2676
2098	2024-05-30 16:23:27.5	7600	1	2677
2100	2024-05-30 16:23:27.5	12000	1	2679
2102	2024-05-30 16:23:27.5	12000	1	2681
2103	2024-05-30 16:22:54	0	1	2682
2105	2024-05-30 16:23:27.5	7200	1	2684
2106	2024-05-30 16:23:27.5	7200	1	2685
2107	2024-05-30 16:23:27.5	7200	1	2686
2108	2024-05-30 16:23:27.5	7200	1	2687
2110	2024-05-30 16:23:27.5	7200	1	2689
2111	2024-05-30 16:23:27.5	7200	1	2690
2112	2024-05-30 16:23:27.5	7200	1	2691
2114	2024-05-30 17:57:27.5	7200	1	2693
2115	2024-05-31 04:42:27.5	32	1	2694
2116	2024-05-31 04:44:27.5	35	1	2695
2117	2024-05-31 04:39:27.5	36	1	2696
2118	2024-05-31 04:56:27.5	41	1	2697
2120	2024-05-31 04:48:27.5	34	1	2699
2121	2024-05-31 04:16:27.5	34	1	2700
2122	2024-05-31 02:26:28	33	1	2701
2123	2024-05-31 04:55:27.5	43	1	2702
2124	2024-05-31 04:41:28	44	1	2703
2125	2024-05-31 04:41:28	50	1	2704
2126	2024-05-31 04:54:28	47	1	2705
2127	2024-05-31 04:45:28	53	1	2706
2129	2024-05-31 04:56:28	45	1	2708
2130	2024-05-31 04:23:27.5	47	1	2709
2131	2024-05-31 02:45:27.5	49	1	2710
2132	2024-05-31 04:56:28	5481	1	2711
2133	2024-05-31 04:56:28	10663	1	2712
2144	2024-05-30 16:23:27.5	0	1	2732
2145	2024-05-30 16:23:27.5	0	1	2733
2146	2024-05-30 16:23:27.5	0	1	2734
2147	2024-05-30 16:23:27.5	0	1	2735
2149	2024-05-30 16:23:27.5	0	1	2737
2150	2024-05-30 16:23:27.5	0	1	2738
2151	2024-05-30 16:23:27.5	0	1	2739
2152	2024-05-30 16:23:27.5	0	1	2740
2153	2024-05-30 16:23:27.5	0	1	2741
2154	2024-05-30 16:23:27.5	0	1	2742
2155	2024-05-30 16:23:27.5	0	1	2743
2157	2024-05-30 16:23:27.5	0	1	2745
2158	2024-05-30 16:23:27.5	0	1	2746
2159	2024-05-30 16:23:27.5	0	1	2747
2169	2024-05-30 16:23:27.5	0	1	2757
2170	2024-05-30 16:23:27.5	0	1	2758
2171	2024-05-30 16:23:27.5	0	1	2759
2172	2024-05-30 16:23:27.5	0	1	2760
2174	2024-05-30 16:23:27.5	0	1	2762
2175	2024-05-30 16:23:27.5	0	1	2763
2176	2024-05-30 16:23:27.5	0	1	2764
2177	2024-05-30 16:23:27.5	0	1	2765
2178	2024-05-30 16:23:27.5	0	1	2766
2179	2024-05-30 16:23:27.5	0	1	2767
2180	2024-05-30 16:23:27.5	0	1	2768
2182	2024-05-30 16:23:27.5	0	1	2770
2183	2024-05-30 16:23:27.5	0	1	2771
2184	2024-05-30 16:23:27.5	0	1	2772
2185	2024-05-30 16:23:27.5	100	1	2773
2186	2024-05-30 16:23:27.5	100	1	2774
2187	2024-05-30 16:23:27.5	100	1	2775
2188	2024-05-30 16:23:27.5	100	1	2776
2190	2024-05-30 16:23:27.5	100	1	2778
2191	2024-05-30 16:23:27.5	100	1	2779
2192	2024-05-30 16:23:27.5	100	1	2780
2193	2024-05-30 16:23:27.5	100	1	2781
2201	2024-05-31 04:25:09.5	4	1	2728
2212	2024-05-31 04:55:28	6200	1	2798
2213	2024-05-31 04:56:28	7400	1	2799
2214	2024-05-31 04:56:28	7400	1	2800
2215	2024-05-30 16:23:27.5	7400	1	2801
2216	2024-05-30 16:23:27.5	7400	1	2802
2218	2024-05-31 04:55:28	11800	1	2804
2220	2024-05-31 04:55:28	11800	1	2806
2221	2024-05-30 16:22:54	0	1	2807
2223	2024-05-30 16:23:27.5	7200	1	2809
2224	2024-05-30 16:23:27.5	7200	1	2810
2225	2024-05-30 16:23:27.5	7200	1	2811
2226	2024-05-30 16:23:27.5	7200	1	2812
2228	2024-05-30 16:23:27.5	7200	1	2814
2229	2024-05-30 16:23:27.5	7200	1	2815
2230	2024-05-30 16:23:27.5	7200	1	2816
2232	2024-05-31 04:55:28	7200	1	2818
2233	2024-05-31 04:39:28	33	1	2819
2234	2024-05-31 04:56:28	36	1	2820
2235	2024-05-31 04:38:28	37	1	2821
2236	2024-05-31 04:50:28	40	1	2822
2238	2024-05-31 04:36:28	35	1	2824
2239	2024-05-31 04:15:27.5	35	1	2825
2240	2024-05-31 04:35:28	33	1	2826
2241	2024-05-31 04:54:28	44	1	2827
2242	2024-05-31 04:54:40	47	1	2828
2243	2024-05-31 04:56:40	50	1	2829
2244	2024-05-31 04:56:40	52	1	2830
2245	2024-05-31 04:51:39.5	56	1	2831
2247	2024-05-31 04:56:40	46	1	2833
2248	2024-05-31 04:43:39.5	44	1	2834
2249	2024-05-31 04:43:39.5	45	1	2835
2250	2024-05-31 04:46:39.5	5438	1	2836
2251	2024-05-31 04:53:39.5	10800	1	2837
2262	2024-05-31 04:43:39.5	0	1	2857
2263	2024-05-31 04:43:39.5	0	1	2858
2264	2024-05-31 04:43:39.5	0	1	2859
2265	2024-05-31 04:43:39.5	0	1	2860
2268	2024-05-31 04:43:39.5	0	1	2862
2269	2024-05-31 04:43:39.5	0	1	2863
2270	2024-05-31 04:43:39.5	0	1	2864
2271	2024-05-31 04:43:39.5	0	1	2865
2272	2024-05-31 04:43:39.5	0	1	2866
2273	2024-05-31 04:43:39.5	0	1	2867
2274	2024-05-31 04:43:39.5	0	1	2868
2276	2024-05-31 04:43:39.5	0	1	2870
2277	2024-05-31 04:43:39.5	0	1	2871
2278	2024-05-31 04:43:39.5	0	1	2872
2288	2024-05-31 04:43:39.5	0	1	2882
2289	2024-05-31 04:43:39.5	0	1	2883
2290	2024-05-31 04:43:39.5	0	1	2884
2291	2024-05-31 04:43:39.5	0	1	2885
2293	2024-05-31 04:43:39.5	0	1	2887
2294	2024-05-31 04:43:39.5	0	1	2888
2295	2024-05-31 04:43:39.5	0	1	2889
2296	2024-05-31 04:43:39.5	0	1	2890
2297	2024-05-31 04:43:39.5	0	1	2891
2298	2024-05-31 04:43:39.5	0	1	2892
2299	2024-05-31 04:43:39.5	0	1	2893
2301	2024-05-31 04:43:39.5	0	1	2895
2302	2024-05-31 04:43:39.5	0	1	2896
2303	2024-05-31 04:43:39.5	0	1	2897
2304	2024-05-31 04:43:39.5	100	1	2898
2305	2024-05-31 04:43:39.5	100	1	2899
2306	2024-05-31 04:43:39.5	100	1	2900
2307	2024-05-31 04:43:39.5	100	1	2901
2309	2024-05-31 04:43:39.5	100	1	2903
2310	2024-05-31 04:43:39.5	100	1	2904
2311	2024-05-31 04:43:39.5	100	1	2905
2312	2024-05-31 04:43:39.5	100	1	2906
2329	2024-05-31 04:43:39.5	6200	1	2923
2330	2024-05-31 04:43:39.5	7200	1	2924
2331	2024-05-31 04:43:39.5	7200	1	2925
2332	2024-05-31 04:43:39.5	7400	1	2926
2333	2024-05-31 04:43:39.5	7400	1	2927
2335	2024-05-31 04:43:39.5	12000	1	2929
2337	2024-05-31 04:43:39.5	12000	1	2931
2338	2024-05-31 04:43:39.5	7200	1	2932
2340	2024-05-31 04:43:39.5	7200	1	2934
2341	2024-05-31 04:43:39.5	7200	1	2935
2342	2024-05-31 04:43:39.5	7200	1	2936
2343	2024-05-31 04:43:39.5	7200	1	2937
2345	2024-05-31 04:43:39.5	7200	1	2939
2346	2024-05-31 04:43:39.5	7200	1	2940
2347	2024-05-31 04:43:39.5	7200	1	2941
2349	2024-05-31 04:43:39.5	7200	1	2943
2350	2024-05-31 04:56:40	35	1	2944
2351	2024-05-31 04:56:40	37	1	2945
2352	2024-05-31 04:55:40	40	1	2946
2353	2024-05-31 04:48:39.5	45	1	2947
2355	2024-05-31 04:43:39.5	35	1	2949
2356	2024-05-31 04:43:39.5	35	1	2950
2357	2024-05-31 04:46:39.5	33	1	2951
2358	2024-05-31 04:55:40	45	1	2952
2359	2024-05-31 04:56:28	45	1	2953
2360	2024-05-31 04:55:28	48	1	2954
2361	2024-05-31 04:55:28	54	1	2955
2362	2024-05-31 04:55:28	56	1	2956
2364	2024-05-31 04:55:28	48	1	2958
2365	2024-05-31 04:56:28	44	1	2959
2366	2024-05-31 04:53:28	45	1	2960
2367	2024-05-31 04:55:28	5419	1	2961
2368	2024-05-31 04:54:28	10719	1	2962
2379	2024-05-30 16:23:27.5	0	1	2982
2380	2024-05-30 16:23:27.5	0	1	2983
2381	2024-05-30 16:23:27.5	0	1	2984
2382	2024-05-30 16:23:27.5	0	1	2985
2384	2024-05-30 16:23:27.5	0	1	2987
2385	2024-05-30 16:23:27.5	0	1	2988
2386	2024-05-30 16:23:27.5	0	1	2989
2387	2024-05-30 16:23:27.5	0	1	2990
2388	2024-05-30 16:23:27.5	0	1	2991
2389	2024-05-30 16:23:27.5	0	1	2992
2390	2024-05-30 16:23:27.5	0	1	2993
2392	2024-05-30 16:23:27.5	0	1	2995
2393	2024-05-30 16:23:27.5	0	1	2996
2394	2024-05-30 16:23:27.5	0	1	2997
2404	2024-05-30 16:23:27.5	0	1	3007
2405	2024-05-30 16:23:27.5	0	1	3008
2406	2024-05-30 16:23:27.5	0	1	3009
2407	2024-05-30 16:23:27.5	0	1	3010
2410	2024-05-30 16:23:27.5	0	1	3012
2411	2024-05-30 16:23:27.5	0	1	3013
2412	2024-05-30 16:23:27.5	0	1	3014
2413	2024-05-30 16:23:27.5	0	1	3015
2414	2024-05-30 16:23:27.5	0	1	3016
2415	2024-05-30 16:23:27.5	0	1	3017
2416	2024-05-30 16:23:27.5	0	1	3018
2418	2024-05-30 16:23:27.5	0	1	3020
2419	2024-05-30 16:23:27.5	0	1	3021
2420	2024-05-30 16:23:27.5	0	1	3022
2421	2024-05-30 16:23:27.5	100	1	3023
2422	2024-05-30 16:23:27.5	100	1	3024
2423	2024-05-30 16:23:27.5	100	1	3025
2424	2024-05-30 16:23:27.5	100	1	3026
2426	2024-05-30 16:23:27.5	100	1	3028
2427	2024-05-30 16:23:27.5	100	1	3029
2428	2024-05-30 16:23:27.5	100	1	3030
2429	2024-05-30 16:23:27.5	100	1	3031
2446	2024-05-31 04:26:28	6400	1	3048
2447	2024-05-30 16:35:28	7400	1	3049
2448	2024-05-30 16:35:28	7400	1	3050
2449	2024-05-30 16:23:27.5	7600	1	3051
2450	2024-05-30 16:23:27.5	7600	1	3052
2452	2024-05-30 16:23:27.5	12000	1	3054
2454	2024-05-30 16:23:27.5	12000	1	3056
2455	2024-05-30 16:22:54	0	1	3057
2457	2024-05-30 16:23:27.5	7200	1	3059
2458	2024-05-30 16:23:27.5	7200	1	3060
2459	2024-05-30 16:23:27.5	7200	1	3061
2460	2024-05-30 16:23:27.5	7200	1	3062
2462	2024-05-30 16:23:27.5	7200	1	3064
2463	2024-05-30 16:23:27.5	7200	1	3065
2464	2024-05-30 16:23:27.5	7200	1	3066
2466	2024-05-30 16:23:27.5	7200	1	3068
2467	2024-05-31 04:50:28	36	1	3069
2468	2024-05-31 04:51:28	39	1	3070
2469	2024-05-31 04:43:28	42	1	3071
2470	2024-05-31 04:56:28	45	1	3072
2472	2024-05-31 03:34:27.5	36	1	3074
2473	2024-05-31 04:53:28	35	1	3075
2474	2024-05-31 04:19:28	34	1	3076
2475	2024-05-31 04:56:28	48	1	3077
2476	2024-05-31 04:55:28.5	46	1	3078
2477	2024-05-31 04:55:28.5	51	1	3079
2478	2024-05-31 04:49:29	50	1	3080
2479	2024-05-31 04:55:28.5	52	1	3081
2481	2024-05-31 04:45:29	46	1	3083
2482	2024-05-31 04:49:29	49	1	3084
2483	2024-05-31 01:43:28.5	47	1	3085
2484	2024-05-31 04:54:28.5	5431	1	3086
2485	2024-05-31 04:56:28.5	10894	1	3087
2496	2024-05-30 16:23:28	0	1	3107
2497	2024-05-30 16:23:28	0	1	3108
2498	2024-05-30 16:23:28	0	1	3109
2499	2024-05-30 16:23:28	0	1	3110
2501	2024-05-30 16:23:28	0	1	3112
2502	2024-05-30 16:23:28	0	1	3113
2503	2024-05-30 16:23:28	0	1	3114
2504	2024-05-30 16:23:28	0	1	3115
2505	2024-05-30 16:23:28	0	1	3116
2506	2024-05-30 16:23:28	0	1	3117
2507	2024-05-30 16:23:28	0	1	3118
2509	2024-05-30 16:23:28	0	1	3120
2510	2024-05-30 16:23:28	0	1	3121
2511	2024-05-30 16:23:28	0	1	3122
2521	2024-05-30 07:41:23	0	1	3132
2522	2024-05-30 07:41:23	0	1	3133
2523	2024-05-30 07:41:23	0	1	3134
2524	2024-05-30 07:41:23	0	1	3135
2526	2024-05-30 07:41:23	0	1	3137
2527	2024-05-30 07:41:23	0	1	3138
2528	2024-05-30 07:41:23	0	1	3139
2529	2024-05-30 16:23:28	0	1	3140
2530	2024-05-30 16:23:28	0	1	3141
2531	2024-05-30 16:23:28	0	1	3142
2532	2024-05-30 16:23:28	0	1	3143
2534	2024-05-30 16:23:28	0	1	3145
2535	2024-05-30 16:23:28	0	1	3146
2536	2024-05-30 16:23:28	0	1	3147
2537	2024-05-30 16:23:28	100	1	3148
2538	2024-05-30 16:23:28	100	1	3149
2539	2024-05-30 16:23:28	100	1	3150
2540	2024-05-30 16:23:28	100	1	3151
2542	2024-05-30 16:23:28	100	1	3153
2543	2024-05-30 16:23:28	100	1	3154
2544	2024-05-30 16:23:28	100	1	3155
2545	2024-05-30 16:23:28	100	1	3156
2548	2024-05-30 16:23:27.5	0	1	3897
2550	2024-05-29 12:18:28.5	6	1	3103
2565	2024-05-30 16:23:28	6400	1	3173
2566	2024-05-31 03:30:29	7600	1	3174
2567	2024-05-31 03:30:29	7600	1	3175
2568	2024-05-30 16:23:28	7600	1	3176
2569	2024-05-30 16:23:28	7600	1	3177
2571	2024-05-31 04:44:29	12000	1	3179
2573	2024-05-31 04:44:29	12000	1	3181
2574	2024-05-30 16:23:28	7400	1	3182
2576	2024-05-30 16:23:28	7400	1	3184
2577	2024-05-30 16:23:28	7400	1	3185
2578	2024-05-30 16:23:28	7400	1	3186
2579	2024-05-30 16:23:28	7400	1	3187
2581	2024-05-30 16:23:28	7400	1	3189
2582	2024-05-30 16:23:28	7400	1	3190
2583	2024-05-30 16:23:28	7400	1	3191
2585	2024-05-30 16:23:28	7200	1	3193
2586	2024-05-31 04:51:29	35	1	3194
2587	2024-05-31 04:54:28.5	39	1	3195
2588	2024-05-31 04:44:29	39	1	3196
2589	2024-05-31 04:51:29	43	1	3197
2591	2024-05-31 04:32:28.5	35	1	3199
2592	2024-05-31 04:31:28.5	37	1	3200
2593	2024-05-31 02:35:29	33	1	3201
2594	2024-05-31 04:56:28.5	63	1	3202
2595	2024-05-31 04:53:28	47	1	3203
2596	2024-05-31 04:53:28	53	1	3204
2597	2024-05-31 04:56:27.5	50	1	3205
2598	2024-05-31 04:55:28	58	1	3206
2600	2024-05-31 04:52:28	47	1	3208
2601	2024-05-31 04:38:28	49	1	3209
2602	2024-05-31 04:44:28	46	1	3210
2603	2024-05-31 04:51:28	5569	1	3211
2604	2024-05-31 04:55:28	10813	1	3212
2615	2024-05-26 07:24:15.5	4	1	3228
2617	2024-05-30 16:23:27.5	0	1	3232
2618	2024-05-30 16:23:27.5	0	1	3233
2619	2024-05-30 16:23:27.5	0	1	3234
2620	2024-05-30 16:23:27.5	0	1	3235
2622	2024-05-30 16:23:27.5	0	1	3237
2623	2024-05-30 16:23:27.5	0	1	3238
2624	2024-05-30 16:23:27.5	0	1	3239
2625	2024-05-30 16:23:27.5	0	1	3240
2626	2024-05-30 16:23:27.5	0	1	3241
2627	2024-05-30 16:23:27.5	0	1	3242
2628	2024-05-30 16:23:27.5	0	1	3243
2630	2024-05-30 16:23:27.5	0	1	3245
2631	2024-05-30 16:23:27.5	0	1	3246
2632	2024-05-30 16:23:27.5	0	1	3247
2642	2024-05-30 16:23:27.5	0	1	3257
2643	2024-05-30 16:23:27.5	0	1	3258
2644	2024-05-30 16:23:27.5	0	1	3259
2645	2024-05-30 16:23:27.5	0	1	3260
2647	2024-05-30 16:23:27.5	0	1	3262
2648	2024-05-30 16:23:27.5	0	1	3263
2649	2024-05-30 16:23:27.5	0	1	3264
2650	2024-05-30 16:23:27.5	0	1	3265
2651	2024-05-30 16:23:27.5	0	1	3266
2652	2024-05-30 16:23:27.5	0	1	3267
2653	2024-05-30 16:23:27.5	0	1	3268
2655	2024-05-30 16:23:27.5	0	1	3270
2656	2024-05-30 16:23:27.5	0	1	3271
2657	2024-05-30 16:23:27.5	0	1	3272
2658	2024-05-30 16:23:27.5	100	1	3273
2659	2024-05-30 16:23:27.5	100	1	3274
2660	2024-05-30 16:23:27.5	100	1	3275
2661	2024-05-30 16:23:27.5	100	1	3276
2663	2024-05-30 16:23:27.5	100	1	3278
2664	2024-05-30 16:23:27.5	100	1	3279
2665	2024-05-30 16:23:27.5	100	1	3280
2666	2024-05-30 16:23:27.5	100	1	3281
2683	2024-05-30 16:23:27.5	6200	1	3298
2684	2024-05-31 04:54:28	7600	1	3299
2685	2024-05-31 04:54:28	7600	1	3300
2686	2024-05-30 16:23:27.5	7600	1	3301
2687	2024-05-30 16:23:27.5	7600	1	3302
2689	2024-05-30 16:23:27.5	11600	1	3304
2692	2024-05-30 16:23:27.5	11600	1	3306
2693	2024-05-30 16:22:53.5	0	1	3307
2695	2024-05-30 16:23:27.5	7200	1	3309
2696	2024-05-30 16:23:27.5	7200	1	3310
2697	2024-05-30 16:23:27.5	7200	1	3311
2698	2024-05-30 16:23:27.5	7200	1	3312
2700	2024-05-30 16:23:27.5	7200	1	3314
2701	2024-05-30 16:23:27.5	7200	1	3315
2702	2024-05-30 16:23:27.5	7200	1	3316
2704	2024-05-30 16:23:27.5	7200	1	3318
2705	2024-05-31 04:54:28	36	1	3319
2706	2024-05-31 04:54:28	40	1	3320
2707	2024-05-31 04:48:28	39	1	3321
2708	2024-05-31 04:54:28	44	1	3322
2710	2024-05-31 04:47:28	35	1	3324
2711	2024-05-31 04:33:28	38	1	3325
2712	2024-05-31 02:35:27.5	34	1	3326
2713	2024-05-31 04:56:27.5	43	1	3328
2714	2024-05-31 04:55:27.5	47	1	3329
2715	2024-05-31 04:49:27.5	46	1	3330
2716	2024-05-31 04:56:27.5	49	1	3331
2718	2024-05-31 04:55:27.5	46	1	3333
2719	2024-05-31 03:28:27.5	42	1	3334
2720	2024-05-31 00:54:27.5	43	1	3335
2721	2024-05-31 04:55:27.5	5563	1	3336
2722	2024-05-31 04:56:27.5	10844	1	3337
2733	2024-05-30 16:23:27.5	0	1	3357
2734	2024-05-30 16:23:27.5	0	1	3358
2735	2024-05-30 16:23:27.5	0	1	3359
2736	2024-05-30 16:23:27.5	0	1	3360
2738	2024-05-30 16:23:27.5	0	1	3362
2739	2024-05-30 16:23:27.5	0	1	3363
2740	2024-05-30 16:23:27.5	0	1	3364
2741	2024-05-30 16:23:27.5	0	1	3365
2742	2024-05-30 16:23:27.5	0	1	3366
2743	2024-05-30 16:23:27.5	0	1	3367
2744	2024-05-30 16:23:27.5	0	1	3368
2746	2024-05-30 16:23:27.5	0	1	3370
2747	2024-05-30 16:23:27.5	0	1	3371
2748	2024-05-30 16:23:27.5	0	1	3372
2756	2024-05-25 16:44:55	2	1	3353
2760	2024-05-30 16:23:27.5	0	1	3382
2761	2024-05-30 16:23:27.5	0	1	3383
2762	2024-05-30 16:23:27.5	0	1	3384
2763	2024-05-30 16:23:27.5	0	1	3385
2765	2024-05-30 16:23:27.5	0	1	3387
2766	2024-05-30 16:23:27.5	0	1	3388
2767	2024-05-30 16:23:27.5	0	1	3389
2768	2024-05-30 16:23:27.5	0	1	3390
2769	2024-05-30 16:23:27.5	0	1	3391
2770	2024-05-30 16:23:27.5	0	1	3392
2771	2024-05-30 16:23:27.5	0	1	3393
2773	2024-05-30 16:23:27.5	0	1	3395
2774	2024-05-30 16:23:27.5	0	1	3396
2775	2024-05-30 16:23:27.5	0	1	3397
2776	2024-05-30 16:23:27.5	100	1	3398
2777	2024-05-30 16:23:27.5	100	1	3399
2778	2024-05-30 16:23:27.5	100	1	3400
2779	2024-05-30 16:23:27.5	100	1	3401
2781	2024-05-30 16:23:27.5	100	1	3403
2782	2024-05-30 16:23:27.5	100	1	3404
2783	2024-05-30 16:23:27.5	100	1	3405
2784	2024-05-30 16:23:27.5	100	1	3406
2801	2024-05-30 16:23:27.5	6400	1	3423
2802	2024-05-31 01:53:28	7400	1	3424
2803	2024-05-31 01:53:28	7400	1	3425
2804	2024-05-30 16:23:27.5	7600	1	3426
2805	2024-05-30 16:23:27.5	7600	1	3427
2807	2024-05-30 16:23:27.5	11800	1	3429
2809	2024-05-30 16:23:27.5	11800	1	3431
2810	2024-05-30 16:22:53.5	0	1	3432
2812	2024-05-30 16:23:27.5	7400	1	3434
2813	2024-05-30 16:23:27.5	7400	1	3435
2814	2024-05-30 16:23:27.5	7400	1	3436
2815	2024-05-30 16:23:27.5	7400	1	3437
2817	2024-05-30 16:23:27.5	7400	1	3439
2818	2024-05-30 16:23:27.5	7400	1	3440
2819	2024-05-30 16:23:27.5	7400	1	3441
2821	2024-05-31 04:45:27.5	7000	1	3443
2822	2024-05-31 04:32:28	30	1	3444
2823	2024-05-31 04:40:27.5	33	1	3445
2824	2024-05-31 04:41:27.5	36	1	3446
2825	2024-05-31 04:43:27.5	39	1	3447
2827	2024-05-31 03:08:27.5	34	1	3449
2828	2024-05-31 04:43:27.5	31	1	3450
2829	2024-05-31 00:57:28	31	1	3451
2830	2024-05-31 04:56:27.5	38	1	3452
2831	2024-05-31 04:56:28	43	1	3453
2832	2024-05-31 04:55:28	51	1	3454
2833	2024-05-31 04:54:28	50	1	3455
2834	2024-05-31 04:48:28	53	1	3456
2836	2024-05-31 04:53:28	45	1	3458
2837	2024-05-31 03:26:28	46	1	3459
2838	2024-05-31 02:40:28	43	1	3460
2839	2024-05-31 04:55:28	5406	1	3461
2840	2024-05-31 04:56:28	10888	1	3462
2851	2024-05-30 16:23:27.5	0	1	3482
2852	2024-05-30 16:23:27.5	0	1	3483
2853	2024-05-30 16:23:27.5	0	1	3484
2854	2024-05-30 16:23:27.5	0	1	3485
2856	2024-05-30 16:23:27.5	0	1	3487
2857	2024-05-30 16:23:27.5	0	1	3488
2858	2024-05-30 16:23:27.5	0	1	3489
2859	2024-05-30 16:23:27.5	0	1	3490
2860	2024-05-30 16:23:27.5	0	1	3491
2861	2024-05-30 16:23:27.5	0	1	3492
2862	2024-05-30 16:23:27.5	0	1	3493
2864	2024-05-30 16:23:27.5	0	1	3495
2865	2024-05-30 16:23:27.5	0	1	3496
2866	2024-05-30 16:23:27.5	0	1	3497
2876	2024-05-30 16:23:27.5	0	1	3507
2877	2024-05-30 16:23:27.5	0	1	3508
2878	2024-05-30 16:23:27.5	0	1	3509
2879	2024-05-30 16:23:27.5	0	1	3510
2881	2024-05-30 16:23:27.5	0	1	3512
2882	2024-05-30 16:23:27.5	0	1	3513
2883	2024-05-30 16:23:27.5	0	1	3514
2884	2024-05-30 16:23:27.5	0	1	3515
2885	2024-05-30 16:23:27.5	0	1	3516
2886	2024-05-30 16:23:27.5	0	1	3517
2887	2024-05-30 16:23:27.5	0	1	3518
2889	2024-05-30 16:23:27.5	0	1	3520
2890	2024-05-30 16:23:27.5	0	1	3521
2891	2024-05-30 16:23:27.5	0	1	3522
2892	2024-05-30 16:23:27.5	100	1	3523
2893	2024-05-30 16:23:27.5	100	1	3524
2894	2024-05-30 16:23:27.5	100	1	3525
2895	2024-05-30 16:23:27.5	100	1	3526
2898	2024-05-30 00:05:23.5	3	1	3478
2899	2024-05-30 16:23:27.5	100	1	3528
2900	2024-05-31 04:55:28	98.4	1	3529
2901	2024-05-30 16:23:27.5	100	1	3530
2902	2024-05-30 16:23:27.5	100	1	3531
2919	2024-05-30 16:23:27.5	6200	1	3548
2920	2024-05-31 04:35:28	7000	1	3549
2921	2024-05-31 04:35:28	7000	1	3550
2922	2024-05-30 18:22:27.5	7200	1	3551
2923	2024-05-30 18:22:27.5	7200	1	3552
2925	2024-05-31 02:40:28	11400	1	3554
2927	2024-05-31 02:40:28	11400	1	3556
2928	2024-05-30 16:22:53.5	0	1	3557
2930	2024-05-30 16:23:27.5	7200	1	3559
2931	2024-05-30 16:23:27.5	7200	1	3560
2932	2024-05-30 16:23:27.5	7200	1	3561
2933	2024-05-30 16:23:27.5	7200	1	3562
2935	2024-05-30 16:23:27.5	7200	1	3564
2936	2024-05-30 16:23:27.5	7200	1	3565
2937	2024-05-30 16:23:27.5	7200	1	3566
2939	2024-05-31 04:23:27.5	7400	1	3568
2940	2024-05-31 04:13:27.5	31	1	3569
2941	2024-05-31 04:42:28	36	1	3570
2942	2024-05-31 04:48:28	38	1	3571
2943	2024-05-31 04:39:28	39	1	3572
2945	2024-05-31 03:32:28	35	1	3574
2946	2024-05-31 04:34:28	33	1	3575
2947	2024-05-31 04:07:28	31	1	3576
2948	2024-05-31 04:47:28	38	1	3577
2949	2024-05-31 04:52:27.5	46	1	3578
2950	2024-05-31 04:52:27.5	48	1	3579
2951	2024-05-31 04:52:27.5	51	1	3580
2952	2024-05-31 04:52:27.5	52	1	3581
2954	2024-05-31 04:55:27.5	49	1	3583
2955	2024-05-31 04:55:27.5	45	1	3584
2956	2024-05-31 03:35:28	49	1	3585
2957	2024-05-31 04:56:27.5	5469	1	3586
2958	2024-05-31 04:55:27.5	10656	1	3587
2969	2024-05-30 16:23:27.5	0	1	3607
2970	2024-05-30 16:23:27.5	0	1	3608
2971	2024-05-30 16:23:27.5	0	1	3609
2972	2024-05-30 16:23:27.5	0	1	3610
2974	2024-05-30 16:23:27.5	0	1	3612
2975	2024-05-30 16:23:27.5	0	1	3613
2976	2024-05-30 16:23:27.5	0	1	3614
2977	2024-05-30 16:23:27.5	0	1	3615
2978	2024-05-30 16:23:27.5	0	1	3616
2979	2024-05-30 16:23:27.5	0	1	3617
2980	2024-05-30 16:23:27.5	0	1	3618
2982	2024-05-30 16:23:27.5	0	1	3620
2983	2024-05-30 16:23:27.5	0	1	3621
2984	2024-05-30 16:23:27.5	0	1	3622
2994	2024-05-30 16:23:27.5	0	1	3632
2995	2024-05-30 16:23:27.5	0	1	3633
2996	2024-05-30 16:23:27.5	0	1	3634
2997	2024-05-30 16:23:27.5	0	1	3635
2999	2024-05-30 16:23:27.5	0	1	3637
3000	2024-05-30 16:23:27.5	0	1	3638
3001	2024-05-30 16:23:27.5	0	1	3639
3002	2024-05-30 16:23:27.5	0	1	3640
3003	2024-05-30 16:23:27.5	0	1	3641
3004	2024-05-30 16:23:27.5	0	1	3642
3005	2024-05-30 16:23:27.5	0	1	3643
3007	2024-05-30 16:23:27.5	0	1	3645
3008	2024-05-30 16:23:27.5	0	1	3646
3009	2024-05-30 16:23:27.5	0	1	3647
3010	2024-05-30 16:23:27.5	100	1	3648
3011	2024-05-30 16:23:27.5	100	1	3649
3012	2024-05-30 16:23:27.5	100	1	3650
3013	2024-05-30 16:23:27.5	100	1	3651
3015	2024-05-30 16:23:27.5	100	1	3653
3016	2024-05-30 16:23:27.5	100	1	3654
3017	2024-05-30 16:23:27.5	100	1	3655
3018	2024-05-30 16:23:27.5	100	1	3656
3035	2024-05-30 16:23:27.5	6400	1	3673
3036	2024-05-30 16:23:27.5	7400	1	3674
3038	2024-05-30 16:23:27.5	7400	1	3675
3039	2024-05-30 18:42:27.5	7400	1	3676
3040	2024-05-30 18:42:27.5	7400	1	3677
3042	2024-05-30 16:23:27.5	12000	1	3679
3044	2024-05-30 16:23:27.5	12000	1	3681
3045	2024-05-31 04:46:28	7200	1	3682
3047	2024-05-31 04:46:28	7200	1	3684
3048	2024-05-31 04:46:28	7200	1	3685
3049	2024-05-31 04:46:28	7200	1	3686
3050	2024-05-31 04:46:28	7200	1	3687
3052	2024-05-31 04:46:28	7200	1	3689
3053	2024-05-31 04:46:28	7200	1	3690
3054	2024-05-31 04:46:28	7200	1	3691
3056	2024-05-31 04:54:27.5	7400	1	3693
3057	2024-05-31 04:56:27.5	33	1	3694
3058	2024-05-31 04:47:28	37	1	3695
3059	2024-05-31 04:54:27.5	39	1	3696
3060	2024-05-31 04:54:27.5	41	1	3697
3062	2024-05-31 03:20:28	35	1	3699
3063	2024-05-31 04:32:27.5	35	1	3700
3064	2024-05-31 03:11:28	33	1	3701
3065	2024-05-31 04:56:27.5	41	1	3702
3066	2024-05-31 04:56:33	49	1	3703
3067	2024-05-31 04:54:32.5	52	1	3704
3068	2024-05-31 04:54:32.5	52	1	3705
3069	2024-05-31 04:54:32.5	54	1	3706
3071	2024-05-31 04:56:33	45	1	3708
3072	2024-05-31 04:54:32.5	49	1	3709
3073	2024-05-31 04:54:32.5	45	1	3710
3074	2024-05-31 04:56:33	5500	1	3711
3075	2024-05-31 04:56:33	10875	1	3712
3086	2024-05-31 04:54:32.5	0	1	3732
3087	2024-05-31 04:54:32.5	0	1	3733
3088	2024-05-31 04:54:32.5	0	1	3734
3089	2024-05-31 04:54:32.5	0	1	3735
3091	2024-05-31 04:54:32.5	0	1	3737
3092	2024-05-31 04:54:32.5	0	1	3738
3093	2024-05-31 04:54:32.5	0	1	3739
3094	2024-05-31 04:54:32.5	0	1	3740
3095	2024-05-31 04:54:32.5	0	1	3741
3096	2024-05-31 04:54:32.5	0	1	3742
3097	2024-05-31 04:54:32.5	0	1	3743
3099	2024-05-31 04:54:32.5	0	1	3745
3100	2024-05-31 04:54:32.5	0	1	3746
3101	2024-05-31 04:54:32.5	0	1	3747
3112	2024-05-31 04:54:32.5	0	1	3757
3113	2024-05-31 04:54:32.5	0	1	3758
3114	2024-05-31 04:54:32.5	0	1	3759
3115	2024-05-31 04:54:32.5	0	1	3760
3117	2024-05-31 04:54:32.5	0	1	3762
3118	2024-05-31 04:54:32.5	0	1	3763
3119	2024-05-31 04:54:32.5	0	1	3764
3120	2024-05-31 04:54:32.5	0	1	3765
3121	2024-05-31 04:54:32.5	0	1	3766
3122	2024-05-31 04:54:32.5	0	1	3767
3123	2024-05-31 04:54:32.5	0	1	3768
3125	2024-05-31 04:54:32.5	0	1	3770
3126	2024-05-31 04:54:32.5	0	1	3771
3127	2024-05-31 04:54:32.5	0	1	3772
3128	2024-05-31 04:54:32.5	100	1	3773
3129	2024-05-31 04:54:32.5	100	1	3774
3130	2024-05-31 04:54:32.5	100	1	3775
3131	2024-05-31 04:54:32.5	100	1	3776
3133	2024-05-31 04:54:32.5	100	1	3778
3134	2024-05-31 04:54:32.5	100	1	3779
3135	2024-05-31 04:54:32.5	100	1	3780
3136	2024-05-31 04:54:32.5	100	1	3781
3153	2024-05-31 04:54:32.5	6400	1	3798
3154	2024-05-31 04:54:32.5	7600	1	3799
3155	2024-05-31 04:54:32.5	7600	1	3800
3156	2024-05-31 04:54:32.5	7600	1	3801
3157	2024-05-31 04:54:32.5	7600	1	3802
3159	2024-05-31 04:56:33	11600	1	3804
3161	2024-05-31 04:56:33	11600	1	3806
3162	2024-05-31 04:54:32.5	7200	1	3807
3164	2024-05-31 04:54:32.5	7200	1	3809
3165	2024-05-31 04:54:32.5	7200	1	3810
3166	2024-05-31 04:54:32.5	7200	1	3811
3167	2024-05-31 04:54:32.5	7200	1	3812
3169	2024-05-31 04:54:32.5	7200	1	3814
3170	2024-05-31 04:54:32.5	7200	1	3815
3171	2024-05-31 04:54:32.5	7200	1	3816
3173	2024-05-31 04:54:32.5	7200	1	3818
3174	2024-05-31 04:54:32.5	35	1	3819
3175	2024-05-31 04:55:32.5	39	1	3820
3176	2024-05-31 04:54:32.5	39	1	3821
3177	2024-05-31 04:55:32.5	42	1	3822
3179	2024-05-31 04:54:32.5	35	1	3824
3180	2024-05-31 04:54:32.5	36	1	3825
3181	2024-05-31 04:54:32.5	33	1	3826
3182	2024-05-31 04:54:32.5	41	1	3827
3183	2024-05-31 04:53:28	43	1	3828
3184	2024-05-31 04:55:27.5	51	1	3829
3185	2024-05-31 04:53:28	50	1	3830
3186	2024-05-31 04:56:27.5	52	1	3831
3188	2024-05-31 04:53:28	48	1	3833
3189	2024-05-31 04:45:28	42	1	3834
3190	2024-05-31 03:43:27.5	43	1	3835
3191	2024-05-31 04:56:27.5	5519	1	3836
3192	2024-05-31 04:56:27.5	10563	1	3837
3203	2024-05-30 16:23:27.5	0	1	3857
3204	2024-05-30 16:23:27.5	0	1	3858
3205	2024-05-30 16:23:27.5	0	1	3859
3206	2024-05-30 16:23:27.5	0	1	3860
3208	2024-05-30 16:23:27.5	0	1	3862
3209	2024-05-30 16:23:27.5	0	1	3863
3210	2024-05-30 16:23:27.5	0	1	3864
3211	2024-05-30 16:23:27.5	0	1	3865
3212	2024-05-30 16:23:27.5	0	1	3866
3213	2024-05-30 16:23:27.5	0	1	3867
3214	2024-05-30 16:23:27.5	0	1	3868
3216	2024-05-30 16:23:27.5	0	1	3870
3217	2024-05-30 16:23:27.5	0	1	3871
3218	2024-05-30 16:23:27.5	0	1	3872
3228	2024-05-30 16:23:27.5	0	1	3882
3229	2024-05-30 16:23:27.5	0	1	3883
3230	2024-05-30 16:23:27.5	0	1	3884
3231	2024-05-30 16:23:27.5	0	1	3885
3233	2024-05-30 16:23:27.5	0	1	3887
3234	2024-05-30 16:23:27.5	0	1	3888
3235	2024-05-30 16:23:27.5	0	1	3889
3236	2024-05-30 16:23:27.5	0	1	3890
3237	2024-05-30 16:23:27.5	0	1	3891
3238	2024-05-30 16:23:27.5	0	1	3892
3239	2024-05-30 16:23:27.5	0	1	3893
3241	2024-05-30 16:23:27.5	0	1	3895
3242	2024-05-30 16:23:27.5	0	1	3896
3244	2024-05-30 16:23:27.5	100	1	3898
3245	2024-05-30 16:23:27.5	100	1	3899
3246	2024-05-30 16:23:27.5	100	1	3900
3247	2024-05-30 16:23:27.5	100	1	3901
3249	2024-05-30 16:23:27.5	100	1	3903
3250	2024-05-30 16:23:27.5	100	1	3904
3251	2024-05-30 16:23:27.5	100	1	3905
3252	2024-05-30 16:23:27.5	100	1	3906
3269	2024-05-31 04:46:28	6200	1	3923
3270	2024-05-30 16:23:27.5	7200	1	3924
3271	2024-05-30 16:23:27.5	7200	1	3925
3272	2024-05-30 16:23:27.5	7400	1	3926
3273	2024-05-30 16:23:27.5	7400	1	3927
3275	2024-05-31 00:07:28	11600	1	3929
3277	2024-05-31 00:07:28	11600	1	3931
3278	2024-05-31 04:56:27.5	6800	1	3932
3280	2024-05-31 04:56:27.5	6800	1	3934
3281	2024-05-31 04:56:27.5	6800	1	3935
3282	2024-05-31 04:56:27.5	6800	1	3936
3283	2024-05-31 04:56:27.5	6800	1	3937
3285	2024-05-31 04:56:27.5	6800	1	3939
3286	2024-05-31 04:56:27.5	6800	1	3940
3287	2024-05-31 04:56:27.5	6800	1	3941
3289	2024-05-31 03:52:27.5	7000	1	3943
3290	2024-05-31 04:56:27.5	34	1	3944
3291	2024-05-31 04:55:27.5	36	1	3945
3292	2024-05-31 04:47:28	39	1	3946
3293	2024-05-31 04:54:28	41	1	3947
3295	2024-05-31 03:34:28	35	1	3949
3296	2024-05-31 04:13:28	35	1	3950
3297	2024-05-31 04:12:28	33	1	3951
3298	2024-05-31 04:54:28	39	1	3952
3299	2024-05-31 04:55:28	46	1	3953
3300	2024-05-31 04:54:27.5	47	1	3954
3301	2024-05-31 04:55:28	49	1	3955
3302	2024-05-31 04:53:27.5	52	1	3956
3304	2024-05-31 04:54:27.5	46	1	3958
3305	2024-05-31 04:54:27.5	48	1	3959
3306	2024-05-31 04:37:27.5	41	1	3960
3307	2024-05-31 04:56:28	5469	1	3961
3308	2024-05-31 04:54:27.5	10581	1	3962
3315	2024-05-30 16:23:27.5	0	1	4120
3320	2024-05-30 16:23:27.5	0	1	3982
3321	2024-05-30 16:23:27.5	0	1	3983
3322	2024-05-30 16:23:27.5	0	1	3984
3323	2024-05-30 16:23:27.5	0	1	3985
3325	2024-05-30 16:23:27.5	0	1	3987
3326	2024-05-30 16:23:27.5	0	1	3988
3327	2024-05-30 16:23:27.5	0	1	3989
3328	2024-05-30 16:23:27.5	0	1	3990
3329	2024-05-30 16:23:27.5	0	1	3991
3330	2024-05-30 16:23:27.5	0	1	3992
3331	2024-05-30 16:23:27.5	0	1	3993
3333	2024-05-30 16:23:27.5	0	1	3995
3334	2024-05-30 16:23:27.5	0	1	3996
3335	2024-05-30 16:23:27.5	0	1	3997
3345	2024-05-30 16:23:27.5	0	1	4007
3346	2024-05-30 16:23:27.5	0	1	4008
3347	2024-05-30 16:23:27.5	0	1	4009
3348	2024-05-30 16:23:27.5	0	1	4010
3350	2024-05-30 16:23:27.5	0	1	4012
3351	2024-05-30 16:23:27.5	0	1	4013
3352	2024-05-30 16:23:27.5	0	1	4014
3353	2024-05-30 16:23:27.5	0	1	4015
3354	2024-05-30 16:23:27.5	0	1	4016
3355	2024-05-30 16:23:27.5	0	1	4017
3356	2024-05-30 16:23:27.5	0	1	4018
3358	2024-05-30 16:23:27.5	0	1	4020
3359	2024-05-30 16:23:27.5	0	1	4021
3360	2024-05-30 16:23:27.5	0	1	4022
3361	2024-05-30 16:23:27.5	100	1	4023
3362	2024-05-30 16:23:27.5	100	1	4024
3363	2024-05-30 16:23:27.5	100	1	4025
3364	2024-05-30 16:23:27.5	100	1	4026
3366	2024-05-30 16:23:27.5	100	1	4028
3367	2024-05-30 16:23:27.5	100	1	4029
3368	2024-05-30 16:23:27.5	100	1	4030
3369	2024-05-30 16:23:27.5	100	1	4031
3387	2024-05-31 04:03:28	6400	1	4048
3388	2024-05-30 16:23:27.5	7600	1	4049
3389	2024-05-30 16:23:27.5	7600	1	4050
3390	2024-05-30 16:23:27.5	7600	1	4051
3391	2024-05-30 16:23:27.5	7600	1	4052
3393	2024-05-30 16:23:27.5	12000	1	4054
3395	2024-05-30 16:23:27.5	12000	1	4056
3396	2024-05-30 16:22:54	0	1	4057
3398	2024-05-30 16:23:27.5	7200	1	4059
3399	2024-05-30 16:23:27.5	7200	1	4060
3401	2024-05-30 16:23:27.5	7200	1	4062
3403	2024-05-30 16:23:27.5	7200	1	4064
3404	2024-05-30 16:23:27.5	7200	1	4065
3405	2024-05-30 16:23:27.5	7200	1	4066
3407	2024-05-31 04:53:27.5	7000	1	4068
3408	2024-05-31 04:50:27.5	33	1	4069
3409	2024-05-31 04:55:28	36	1	4070
3410	2024-05-31 04:48:27.5	39	1	4071
3411	2024-05-31 04:49:27.5	42	1	4072
3413	2024-05-31 03:10:27.5	35	1	4074
3414	2024-05-31 04:49:27.5	35	1	4075
3415	2024-05-31 04:37:27.5	33	1	4076
3416	2024-05-31 04:55:28	39	1	4077
3417	2024-05-31 04:56:28	42	1	4078
3418	2024-05-31 04:56:28	43	1	4079
3419	2024-05-31 04:56:28	47	1	4080
3421	2024-05-31 04:56:28	44	1	4083
3422	2024-05-31 03:41:27.5	47	1	4084
3423	2024-05-31 03:12:27.5	46	1	4085
3424	2024-05-31 04:56:28	5531	1	4086
3425	2024-05-31 04:55:28	10706	1	4087
3436	2024-05-30 16:23:27.5	0	1	4107
3437	2024-05-30 16:23:27.5	0	1	4108
3438	2024-05-30 16:23:27.5	0	1	4109
3439	2024-05-30 16:23:27.5	0	1	4110
3441	2024-05-30 16:23:27.5	0	1	4112
3442	2024-05-30 16:23:27.5	0	1	4113
3443	2024-05-30 16:23:27.5	0	1	4114
3444	2024-05-30 16:23:27.5	0	1	4115
3445	2024-05-30 16:23:27.5	0	1	4116
3446	2024-05-30 16:23:27.5	0	1	4117
3447	2024-05-30 16:23:27.5	0	1	4118
3449	2024-05-31 04:31:40	17	1	4103
3450	2024-05-30 16:23:27.5	0	1	4121
3451	2024-05-30 16:23:27.5	0	1	4122
3461	2024-05-30 16:23:27.5	0	1	4132
3462	2024-05-30 16:23:27.5	0	1	4133
3463	2024-05-30 16:23:27.5	0	1	4134
3464	2024-05-30 16:23:27.5	0	1	4135
3466	2024-05-30 16:23:27.5	0	1	4137
3467	2024-05-30 16:23:27.5	0	1	4138
3468	2024-05-30 16:23:27.5	0	1	4139
3469	2024-05-30 16:23:27.5	0	1	4140
3470	2024-05-30 16:23:27.5	0	1	4141
3471	2024-05-30 16:23:27.5	0	1	4142
3472	2024-05-30 16:23:27.5	0	1	4143
3474	2024-05-30 16:23:27.5	0	1	4145
3475	2024-05-30 16:23:27.5	0	1	4146
3476	2024-05-30 16:23:27.5	0	1	4147
3477	2024-05-30 16:23:27.5	100	1	4148
3478	2024-05-30 16:23:27.5	100	1	4149
3479	2024-05-30 16:23:27.5	100	1	4150
3480	2024-05-30 16:23:27.5	100	1	4151
3482	2024-05-30 16:23:27.5	100	1	4153
3483	2024-05-30 16:23:27.5	100	1	4154
3484	2024-05-30 16:23:27.5	100	1	4155
3485	2024-05-30 16:23:27.5	100	1	4156
3503	2024-05-31 04:51:27.5	8000	1	4174
3504	2024-05-31 04:51:27.5	8000	1	4175
3505	2024-05-31 00:06:28	8000	1	4176
3506	2024-05-31 00:06:28	8000	1	4177
3508	2024-05-30 16:23:27.5	12000	1	4179
3510	2024-05-30 16:23:27.5	12000	1	4181
3511	2024-05-30 16:22:53.5	0	1	4182
3513	2024-05-30 16:23:27.5	7200	1	4184
3514	2024-05-30 16:23:27.5	7200	1	4185
3515	2024-05-30 16:23:27.5	7200	1	4186
3516	2024-05-30 16:23:27.5	7200	1	4187
3518	2024-05-30 16:23:27.5	7200	1	4189
3519	2024-05-30 16:23:27.5	7200	1	4190
3520	2024-05-30 16:23:27.5	7200	1	4191
3522	2024-05-30 16:23:27.5	7200	1	4193
3523	2024-05-31 04:42:28	33	1	4194
3524	2024-05-31 04:50:27.5	34	1	4195
3525	2024-05-31 04:52:27.5	38	1	4196
3526	2024-05-31 04:53:27.5	46	1	4197
3528	2024-05-31 03:42:27.5	35	1	4199
3529	2024-05-31 04:50:27.5	34	1	4200
3530	2024-05-31 03:13:27.5	33	1	4201
3531	2024-05-31 04:50:27.5	51	1	4202
3532	2024-05-31 04:56:26.5	42	1	4203
3533	2024-05-31 04:56:26.5	43	1	4204
3534	2024-05-31 04:56:26.5	49	1	4205
3535	2024-05-31 04:56:26.5	56	1	4206
3536	2024-05-31 04:56:26.5	43	1	4207
3537	2024-05-31 04:53:27	42	1	4208
3538	2024-05-31 04:54:27	45	1	4209
3539	2024-05-31 03:30:26.5	48	1	4210
3540	2024-05-31 04:56:26.5	5544	1	4211
3541	2024-05-31 04:55:27	10981	1	4212
3552	2024-05-30 16:23:26.5	0	1	4232
3553	2024-05-30 16:23:26.5	0	1	4233
3554	2024-05-30 16:23:26.5	0	1	4234
3555	2024-05-30 16:23:26.5	0	1	4235
3556	2024-05-30 16:23:26.5	0	1	4236
3557	2024-05-30 16:23:26.5	0	1	4237
3558	2024-05-30 16:23:26.5	0	1	4238
3559	2024-05-30 16:23:26.5	0	1	4239
3560	2024-05-30 16:23:26.5	0	1	4240
3561	2024-05-30 16:23:26.5	0	1	4241
3562	2024-05-30 16:23:26.5	0	1	4242
3563	2024-05-30 16:23:26.5	0	1	4243
3564	2024-05-30 16:23:26.5	0	1	4244
3565	2024-05-30 16:23:26.5	0	1	4245
3566	2024-05-30 16:23:26.5	0	1	4246
3567	2024-05-30 16:23:26.5	0	1	4247
3577	2024-05-30 16:23:26.5	0	1	4257
3578	2024-05-30 16:23:26.5	0	1	4258
3579	2024-05-30 16:23:26.5	0	1	4259
3580	2024-05-30 16:23:26.5	0	1	4260
3581	2024-05-30 16:23:26.5	0	1	4261
3582	2024-05-30 16:23:26.5	0	1	4262
3583	2024-05-30 16:23:26.5	0	1	4263
3584	2024-05-30 16:23:26.5	0	1	4264
3585	2024-05-30 16:23:26.5	0	1	4265
3586	2024-05-30 16:23:26.5	0	1	4266
3587	2024-05-30 16:23:26.5	0	1	4267
3588	2024-05-30 16:23:26.5	0	1	4268
3589	2024-05-30 16:23:26.5	0	1	4269
3590	2024-05-30 16:23:26.5	0	1	4270
3591	2024-05-30 16:23:26.5	0	1	4271
3592	2024-05-30 16:23:26.5	0	1	4272
3593	2024-05-30 12:19:04	6	1	4227
3594	2024-05-30 16:23:26.5	100	1	4273
3595	2024-05-30 16:23:26.5	100	1	4274
3596	2024-05-30 16:23:26.5	100	1	4275
3597	2024-05-30 16:23:26.5	100	1	4276
3598	2024-05-30 16:23:26.5	100	1	4277
3599	2024-05-30 16:23:26.5	100	1	4278
3600	2024-05-30 16:23:26.5	100	1	4279
3601	2024-05-30 16:23:26.5	100	1	4280
3602	2024-05-30 16:23:26.5	100	1	4281
3619	2023-01-12 18:35:30	11800	1	4298
3620	2023-01-09 00:04:30	7600	1	4299
3621	2023-01-09 00:04:30	7600	1	4300
3622	2023-01-09 00:04:30	7600	1	4301
3623	2023-01-09 00:04:30	7600	1	4302
3639	2023-01-12 14:43:30	8800	1	4318
3640	2024-05-31 04:52:27	30	1	4319
3641	2024-05-31 01:18:26.5	30	1	4320
3642	2024-05-31 04:33:27	38	1	4321
3643	2024-05-31 04:53:27	46	1	4322
3644	2024-05-31 03:37:26.5	31	1	4323
3645	2024-05-31 03:40:26.5	31	1	4324
3646	2024-05-31 04:20:27	31	1	4325
3647	2024-05-31 04:56:26.5	35	1	4326
3648	2024-05-31 04:52:27	44	1	4327
3649	2024-05-31 04:55:26.5	41	1	4328
3650	2024-05-31 04:48:26.5	38	1	4329
3651	2024-05-31 04:56:26.5	50	1	4330
3652	2024-05-31 04:56:26.5	54	1	4331
3653	2024-05-31 04:30:27	45	1	4332
3654	2024-05-31 04:52:27	40	1	4333
3655	2024-05-31 04:23:26.5	42	1	4334
3656	2024-05-31 00:10:26.5	45	1	4335
3657	2024-05-31 04:55:26.5	5488	1	4336
3658	2024-05-31 04:55:26.5	10725	1	4337
3669	2024-05-30 16:23:26.5	0	1	4357
3670	2024-05-30 16:23:26.5	0	1	4358
3671	2024-05-30 16:23:26.5	0	1	4359
3672	2024-05-30 16:23:26.5	0	1	4360
3673	2024-05-30 16:23:26.5	0	1	4361
3674	2024-05-30 16:23:26.5	0	1	4362
3675	2024-05-30 16:23:26.5	0	1	4363
3676	2024-05-30 16:23:26.5	0	1	4364
3677	2024-05-30 16:23:26.5	0	1	4365
3678	2024-05-30 16:23:26.5	0	1	4366
3679	2024-05-30 16:23:26.5	0	1	4367
3680	2024-05-30 16:23:26.5	0	1	4368
3681	2024-05-30 16:23:26.5	0	1	4369
3682	2024-05-30 16:23:26.5	0	1	4370
3683	2024-05-30 16:23:26.5	0	1	4371
3684	2024-05-30 16:23:26.5	0	1	4372
3694	2024-05-30 16:23:26.5	0	1	4382
3695	2024-05-30 16:23:26.5	0	1	4383
3696	2024-05-30 16:23:26.5	0	1	4384
3697	2024-05-30 16:23:26.5	0	1	4385
3698	2024-05-30 16:23:26.5	0	1	4386
3699	2024-05-30 16:23:26.5	0	1	4387
3700	2024-05-30 16:23:26.5	0	1	4388
3701	2024-05-30 16:23:26.5	0	1	4389
3702	2024-05-30 16:23:26.5	0	1	4390
3703	2024-05-30 16:23:26.5	0	1	4391
3704	2024-05-30 16:23:26.5	0	1	4392
3705	2024-05-30 16:23:26.5	0	1	4393
3706	2024-05-30 16:23:26.5	0	1	4394
3707	2024-05-30 16:23:26.5	0	1	4395
3708	2024-05-30 16:23:26.5	0	1	4396
3709	2024-05-30 16:23:26.5	0	1	4397
3710	2024-05-30 16:23:26.5	100	1	4398
3711	2024-05-30 16:23:26.5	100	1	4399
3712	2024-05-30 16:23:26.5	100	1	4400
3713	2024-05-30 16:23:26.5	100	1	4401
3714	2024-05-30 16:23:26.5	100	1	4402
3715	2024-05-30 16:23:26.5	100	1	4403
3716	2024-05-30 16:23:26.5	100	1	4404
3717	2024-05-30 16:23:26.5	100	1	4405
3718	2024-05-30 16:23:26.5	100	1	4406
3734	2024-05-24 17:25:53	39	1	4351
3735	2024-04-25 11:56:18	1	1	4354
3737	2023-01-13 03:05:05.5	11800	1	4423
3738	2023-01-13 03:05:05.5	7600	1	4424
3739	2023-01-13 03:05:05.5	7600	1	4425
3740	2023-01-13 03:05:05.5	7600	1	4426
3741	2023-01-13 03:05:05.5	7600	1	4427
3757	2023-01-13 03:05:05.5	11600	1	4443
3758	2024-05-31 00:07:27	29	1	4444
3759	2024-05-31 03:11:27	30	1	4445
3760	2024-05-31 04:40:27	37	1	4446
3761	2024-05-31 04:53:27	40	1	4447
3762	2024-05-31 04:06:26.5	32	1	4448
3763	2024-05-31 04:50:26.5	32	1	4449
3764	2024-05-31 04:07:26.5	31	1	4450
3765	2024-05-31 03:24:26.5	35	1	4451
3766	2024-05-31 04:50:26.5	52	1	4452
3767	2024-05-31 04:56:26.5	40	1	4453
3768	2024-05-31 04:50:26.5	43	1	4454
3769	2024-05-31 04:50:26.5	48	1	4455
3770	2024-05-31 04:50:26.5	59	1	4456
3771	2024-05-31 04:56:26.5	46	1	4457
3772	2024-05-31 04:15:27	43	1	4458
3773	2024-05-31 04:54:27	42	1	4459
3774	2024-05-31 04:40:27	45	1	4460
3775	2024-05-31 04:56:26.5	5463	1	4461
3776	2024-05-31 04:56:26.5	10744	1	4462
3787	2024-05-30 16:23:26.5	0	1	4482
3788	2024-05-30 16:23:26.5	0	1	4483
3789	2024-05-30 16:23:26.5	0	1	4484
3790	2024-05-30 16:23:26.5	0	1	4485
3791	2024-05-30 16:23:26.5	0	1	4486
3792	2024-05-30 16:23:26.5	0	1	4487
3793	2024-05-30 16:23:26.5	0	1	4488
3794	2024-05-30 16:23:26.5	0	1	4489
3795	2024-05-30 16:23:26.5	0	1	4490
3796	2024-05-30 16:23:26.5	0	1	4491
3797	2024-05-30 16:23:26.5	0	1	4492
3798	2024-05-30 16:23:26.5	0	1	4493
3799	2024-05-30 16:23:26.5	0	1	4494
3800	2024-05-30 16:23:26.5	0	1	4495
3801	2024-05-30 16:23:26.5	0	1	4496
3802	2024-05-30 16:23:26.5	0	1	4497
3803	2024-05-29 12:20:18	5	1	4480
3804	2023-12-11 10:36:08.5	2	1	4479
3814	2024-05-30 16:23:26.5	0	1	4507
3815	2024-05-30 16:23:26.5	0	1	4508
3816	2024-05-30 16:23:26.5	0	1	4509
3817	2024-05-30 16:23:26.5	0	1	4510
3818	2024-05-30 16:23:26.5	0	1	4511
3819	2024-05-30 16:23:26.5	0	1	4512
3820	2024-05-30 16:23:26.5	0	1	4513
3821	2024-05-30 16:23:26.5	0	1	4514
3822	2024-05-30 16:23:26.5	0	1	4515
3823	2024-05-30 16:23:26.5	0	1	4516
3824	2024-05-30 16:23:26.5	0	1	4517
3825	2024-05-30 16:23:26.5	0	1	4518
3826	2024-05-30 16:23:26.5	0	1	4519
3827	2024-05-30 16:23:26.5	0	1	4520
3828	2024-05-30 16:23:26.5	0	1	4521
3829	2024-05-30 16:23:26.5	0	1	4522
3830	2024-05-30 16:23:26.5	100	1	4523
3831	2024-05-30 16:23:26.5	100	1	4524
3832	2024-05-30 16:23:26.5	100	1	4525
3833	2024-05-30 16:23:26.5	100	1	4526
3834	2024-05-30 16:23:26.5	100	1	4527
3835	2024-05-30 16:23:26.5	100	1	4528
3836	2024-05-30 16:23:26.5	100	1	4529
3837	2024-05-30 16:23:26.5	100	1	4530
3838	2024-05-30 16:23:26.5	100	1	4531
3855	2023-01-12 13:35:35	11800	1	4548
3856	2023-01-09 00:04:34.5	7600	1	4549
3857	2023-01-09 00:04:34.5	7600	1	4550
3858	2023-01-12 18:34:35	7800	1	4551
3859	2023-01-12 18:34:35	7800	1	4552
3875	2023-01-09 00:04:34.5	11400	1	4568
3876	2024-05-31 04:23:26.5	29	1	4569
3877	2024-05-31 04:48:26.5	31	1	4570
3878	2024-05-31 04:43:27	38	1	4571
3879	2024-05-31 04:55:26.5	43	1	4572
3880	2024-05-31 04:00:26.5	32	1	4573
3881	2024-05-31 03:13:27	31	1	4574
3882	2024-05-31 04:51:27	32	1	4575
3883	2024-05-30 23:52:26.5	34	1	4576
3884	2024-05-31 04:53:27	45	1	4577
3885	2024-05-31 04:49:26.5	42	1	4578
3886	2024-05-31 04:49:26.5	43	1	4579
3887	2024-05-31 04:54:27	46	1	4580
3888	2024-05-31 04:56:26.5	51	1	4581
3889	2024-05-31 04:33:27	46	1	4582
3890	2024-05-31 04:52:27	40	1	4583
3891	2024-05-31 04:51:27	43	1	4584
3892	2024-05-31 04:51:27	45	1	4585
3893	2024-05-31 04:56:26.5	5544	1	4586
3894	2024-05-31 04:52:27	10888	1	4587
3905	2024-05-30 16:23:26.5	0	1	4607
3906	2024-05-30 16:23:26.5	0	1	4608
3907	2024-05-30 16:23:26.5	0	1	4609
3908	2024-05-30 16:23:26.5	0	1	4610
3909	2024-05-30 16:23:26.5	0	1	4611
3910	2024-05-30 16:23:26.5	0	1	4612
3911	2024-05-30 16:23:26.5	0	1	4613
3912	2024-05-30 16:23:26.5	0	1	4614
3913	2024-05-30 16:23:26.5	0	1	4615
3914	2024-05-30 16:23:26.5	0	1	4616
3915	2024-05-30 16:23:26.5	0	1	4617
3916	2024-05-30 16:23:26.5	0	1	4618
3917	2024-05-30 16:23:26.5	0	1	4619
3918	2024-05-30 16:23:26.5	0	1	4620
3919	2024-05-30 16:23:26.5	0	1	4621
3920	2024-05-30 16:23:26.5	0	1	4622
3930	2024-05-30 16:23:26.5	0	1	4632
3931	2024-05-30 16:23:26.5	0	1	4633
3932	2024-05-30 16:23:26.5	0	1	4634
3933	2024-05-30 16:23:26.5	0	1	4635
3934	2024-05-30 16:23:26.5	0	1	4636
3935	2024-05-30 16:23:26.5	0	1	4637
3936	2024-05-30 16:23:26.5	0	1	4638
3937	2024-05-30 16:23:26.5	0	1	4639
3938	2024-05-30 16:23:26.5	0	1	4640
3939	2024-05-30 16:23:26.5	0	1	4641
3940	2024-05-30 16:23:26.5	0	1	4642
3941	2024-05-30 16:23:26.5	0	1	4643
3942	2024-05-30 16:23:26.5	0	1	4644
3943	2024-05-30 16:23:26.5	0	1	4645
3944	2024-05-30 16:23:26.5	0	1	4646
3945	2024-05-30 16:23:26.5	0	1	4647
3946	2024-05-30 16:23:26.5	100	1	4648
3947	2024-05-16 08:23:20	3	1	4606
3948	2024-05-30 16:23:26.5	100	1	4649
3949	2024-05-30 16:23:26.5	100	1	4650
3950	2024-05-30 16:23:26.5	100	1	4651
3951	2024-05-30 16:23:26.5	100	1	4652
3952	2024-05-30 16:23:26.5	100	1	4653
3953	2024-05-30 16:23:26.5	100	1	4654
3954	2024-05-30 16:23:26.5	100	1	4655
3955	2024-05-30 16:23:26.5	100	1	4656
3972	2023-01-12 12:03:37.5	11800	1	4673
3973	2023-01-09 00:04:37.5	7600	1	4674
3974	2023-01-09 00:04:37.5	7600	1	4675
3975	2023-01-12 18:10:37.5	7400	1	4676
3976	2023-01-12 18:10:37.5	7400	1	4677
3992	2023-01-09 00:04:37.5	11400	1	4693
3993	2024-05-31 04:38:26.5	29	1	4694
3994	2024-05-31 03:04:26.5	30	1	4695
3995	2024-05-31 04:52:27	37	1	4696
3996	2024-05-31 04:49:26.5	40	1	4697
3997	2024-05-31 03:50:26.5	32	1	4698
3998	2024-05-31 04:34:26.5	32	1	4699
3999	2024-05-31 03:38:26.5	31	1	4700
4000	2024-05-31 03:13:27	34	1	4701
4001	2024-05-31 04:50:26.5	50	1	4702
4002	2024-05-31 04:56:27.5	48	1	4703
4003	2024-05-31 04:48:28	51	1	4704
4004	2024-05-31 04:53:27.5	53	1	4705
4006	2024-05-31 04:48:28	48	1	4708
4007	2024-05-31 04:48:28	48	1	4709
4008	2024-05-31 00:11:28	45	1	4710
4009	2024-05-31 04:56:27.5	5475	1	4711
4010	2024-05-31 04:56:27.5	10425	1	4712
4021	2024-05-30 16:23:27.5	0	1	4732
4022	2024-05-30 16:23:27.5	0	1	4733
4023	2024-05-30 16:23:27.5	0	1	4734
4024	2024-05-30 16:23:27.5	0	1	4735
4026	2024-05-30 16:23:27.5	0	1	4737
4027	2024-05-30 16:23:27.5	0	1	4738
4028	2024-05-30 16:23:27.5	0	1	4739
4029	2024-05-30 16:23:27.5	0	1	4740
4030	2024-05-30 16:23:27.5	0	1	4741
4031	2024-05-30 16:23:27.5	0	1	4742
4032	2024-05-30 16:23:27.5	0	1	4743
4034	2024-05-30 16:23:27.5	0	1	4745
4035	2024-05-30 16:23:27.5	0	1	4746
4036	2024-05-30 16:23:27.5	0	1	4747
4046	2024-05-30 16:23:27.5	0	1	4757
4047	2024-05-30 16:23:27.5	0	1	4758
4048	2024-05-30 16:23:27.5	0	1	4759
4049	2024-05-30 16:23:27.5	0	1	4760
4051	2024-05-30 16:23:27.5	0	1	4762
4052	2024-05-30 16:23:27.5	0	1	4763
4053	2024-05-30 16:23:27.5	0	1	4764
4054	2024-05-30 16:23:27.5	0	1	4765
4055	2024-05-30 16:23:27.5	0	1	4766
4056	2024-05-30 16:23:27.5	0	1	4767
4057	2024-05-30 16:23:27.5	0	1	4768
4059	2024-05-30 16:23:27.5	0	1	4770
4060	2024-05-30 16:23:27.5	0	1	4771
4061	2024-05-30 16:23:27.5	0	1	4772
4062	2024-05-30 16:23:27.5	100	1	4773
4063	2024-05-30 16:23:27.5	100	1	4774
4064	2024-05-30 16:23:27.5	100	1	4775
4065	2024-05-30 16:23:27.5	100	1	4776
4067	2024-05-30 16:23:27.5	100	1	4778
4068	2024-05-31 04:33:28	90.5	1	4779
4069	2024-05-30 16:23:27.5	100	1	4780
4070	2024-05-30 16:23:27.5	100	1	4781
4087	2024-05-31 04:50:08.5	7	1	4728
4089	2024-05-31 04:54:27.5	6200	1	4798
4090	2024-05-30 16:23:27.5	7400	1	4799
4091	2024-05-30 16:23:27.5	7400	1	4800
4092	2024-05-31 04:48:28	7800	1	4801
4093	2024-05-31 04:48:28	7800	1	4802
4095	2024-05-30 16:23:27.5	11400	1	4804
4097	2024-05-30 16:23:27.5	11400	1	4806
4098	2024-05-31 04:20:28	7200	1	4807
4100	2024-05-31 04:20:28	7200	1	4809
4101	2024-05-31 04:20:28	7200	1	4810
4102	2024-05-31 04:20:28	7200	1	4811
4103	2024-05-31 04:20:28	7200	1	4812
4105	2024-05-31 04:20:28	7200	1	4814
4106	2024-05-31 04:20:28	7200	1	4815
4107	2024-05-31 04:20:28	7200	1	4816
4109	2024-05-31 04:51:27.5	7000	1	4818
4110	2024-05-31 04:53:27.5	38	1	4819
4111	2024-05-31 04:50:27.5	36	1	4820
4112	2024-05-31 04:50:27.5	43	1	4821
4114	2024-05-31 04:45:28	37	1	4824
4115	2024-05-31 04:50:27.5	39	1	4825
4116	2024-05-31 00:04:28	35	1	4826
4117	2024-05-31 04:53:27.5	46	1	4827
4118	2024-05-31 04:55:26	60	1	4828
4119	2024-05-31 04:46:26	54	1	4829
4120	2024-05-31 04:48:26	61	1	4830
4121	2024-05-31 04:52:26	55	1	4831
4122	2024-05-31 04:56:26	56	1	4832
4123	2024-05-31 04:55:26	5438	1	4836
4124	2024-05-31 04:56:26	10694	1	4837
4132	2024-05-30 16:23:26	0	1	4857
4133	2024-05-30 16:23:26	0	1	4858
4134	2024-05-30 16:23:26	0	1	4859
4135	2024-05-30 16:23:26	0	1	4860
4136	2024-05-30 16:23:26	0	1	4861
4137	2024-05-30 16:23:26	0	1	4865
4138	2024-05-30 16:23:26	0	1	4866
4139	2024-05-30 16:23:26	0	1	4867
4140	2024-05-30 16:23:26	0	1	4868
4141	2024-05-30 16:23:26	0	1	4869
4142	2024-05-31 04:55:45.5	14	1	4851
4148	2024-05-30 07:41:21	0	1	4882
4149	2024-05-30 07:41:21	0	1	4883
4150	2024-05-30 07:41:21	0	1	4884
4151	2024-05-30 07:41:21	0	1	4885
4152	2024-05-30 07:41:21	0	1	4886
4153	2024-05-30 16:23:26	0	1	4890
4154	2024-05-30 16:23:26	0	1	4891
4155	2024-05-30 16:23:26	0	1	4892
4156	2024-05-30 16:23:26	0	1	4893
4157	2024-05-30 16:23:26	0	1	4894
4158	2024-05-30 16:23:26	100	1	4898
4159	2024-05-30 16:23:26	100	1	4899
4160	2024-05-30 16:23:26	100	1	4900
4161	2024-05-30 16:23:26	100	1	4901
4162	2024-05-30 16:23:26	100	1	4902
4173	2024-05-30 16:23:26	11600	1	4924
4174	2024-05-30 16:23:26	11600	1	4925
4175	2024-05-30 16:23:26	11800	1	4926
4176	2024-05-30 16:23:26	11800	1	4927
4183	2024-05-31 04:56:26	53	1	4944
4184	2024-05-31 04:52:26	44	1	4945
4185	2024-05-31 04:53:26	52	1	4946
4186	2024-05-31 04:50:26	45	1	4947
4187	2024-05-31 03:20:26	44	1	4948
4188	2024-05-31 04:50:26	52	1	4953
4189	2024-05-31 04:49:26	49	1	4954
4190	2024-05-31 04:49:26	59	1	4955
4191	2024-05-31 04:49:26	51	1	4956
4192	2024-05-31 04:13:26	50	1	4957
4193	2024-05-31 04:56:26	5488	1	4958
4194	2024-05-31 04:55:26	10863	1	4959
4202	2024-05-30 16:23:26	0	1	4973
4203	2024-05-30 16:23:26	0	1	4974
4204	2024-05-30 16:23:26	0	1	4975
4205	2024-05-30 16:23:26	0	1	4976
4206	2024-05-30 16:23:26	0	1	4977
4207	2024-05-30 16:23:26	0	1	4978
4208	2024-05-30 16:23:26	0	1	4979
4209	2024-05-30 16:23:26	0	1	4980
4210	2024-05-30 16:23:26	0	1	4981
4211	2024-05-30 16:23:26	0	1	4982
4217	2024-05-30 16:22:53.5	0	1	4989
4218	2024-05-30 16:22:53.5	0	1	4990
4219	2024-05-30 16:22:53.5	0	1	4991
4220	2024-05-30 16:22:53.5	0	1	4992
4221	2024-05-30 16:22:53.5	0	1	4993
4222	2024-05-30 16:23:26	0	1	4994
4223	2024-05-30 16:23:26	0	1	4995
4224	2024-05-30 16:23:26	0	1	4996
4225	2024-05-30 16:23:26	0	1	4997
4226	2024-05-30 16:23:26	0	1	4998
4227	2024-05-30 16:23:26	100	1	4999
4228	2024-05-30 16:23:26	100	1	5000
4229	2024-05-30 16:23:26	100	1	5001
4230	2024-05-30 16:23:26	100	1	5002
4231	2024-05-30 16:23:26	100	1	5003
4242	2023-01-09 00:25:04	11200	1	5016
4243	2023-01-09 00:25:04	11200	1	5017
4244	2023-01-12 18:38:04	11600	1	5018
4245	2023-01-12 18:38:04	11600	1	5019
4252	2024-05-31 04:54:26	45	1	5030
4253	2024-05-31 04:36:26	39	1	5031
4254	2024-05-31 04:54:26	55	1	5032
4255	2024-05-31 04:55:26	40	1	5033
4256	2024-05-31 04:54:26	38	1	5034
4257	2024-05-31 04:30:29.5	53	1	5036
4258	2024-05-30 16:23:27.5	0	1	5040
4259	2024-05-31 04:49:28.5	47	1	5041
4260	2024-05-31 04:54:28.5	54	1	5042
4261	2024-05-31 04:56:28	5500	1	5045
4262	2024-05-31 04:55:28	10644	1	5046
4272	2024-05-30 16:23:27.5	0	1	5068
4273	2024-05-30 16:23:27.5	0	1	5069
4274	2024-05-30 16:23:27.5	0	1	5070
4275	2024-05-30 16:23:27.5	0	1	5071
4276	2024-05-30 16:23:27.5	0	1	5072
4277	2024-05-30 16:23:27.5	0	1	5073
4278	2024-05-30 16:23:27.5	0	1	5074
4279	2024-05-30 16:23:27.5	0	1	5077
4280	2024-05-30 16:23:27.5	0	1	5078
4281	2024-05-30 16:23:27.5	0	1	5079
4282	2024-05-30 16:23:27.5	0	1	5080
4283	2024-05-30 16:23:27.5	0	1	5081
4284	2024-05-30 16:23:27.5	0	1	5082
4285	2024-05-30 16:23:27.5	0	1	5083
4293	2024-05-30 16:23:27.5	0	1	5096
4294	2024-05-30 16:23:27.5	0	1	5097
4295	2024-05-30 16:23:27.5	0	1	5098
4296	2024-05-30 16:23:27.5	0	1	5099
4297	2024-05-31 04:49:28.5	79	1	5038
4298	2024-05-30 16:23:27.5	0	1	5100
4299	2024-05-30 16:23:27.5	0	1	5101
4300	2024-05-30 16:23:27.5	0	1	5102
4301	2024-05-30 16:23:27.5	0	1	5105
4302	2024-05-30 16:23:27.5	0	1	5106
4303	2024-05-30 16:23:27.5	0	1	5107
4304	2024-05-30 16:23:27.5	0	1	5108
4305	2024-05-30 16:23:27.5	0	1	5109
4306	2024-05-30 16:23:27.5	0	1	5110
4307	2024-05-30 16:23:27.5	0	1	5111
4308	2024-05-30 16:23:27.5	100	1	5114
4309	2024-05-30 16:23:27.5	100	1	5115
4310	2024-05-30 16:23:27.5	100	1	5116
4311	2024-05-30 16:23:27.5	100	1	5117
4312	2024-05-30 16:23:27.5	100	1	5118
4313	2024-05-30 16:23:27.5	100	1	5119
4314	2024-05-30 16:23:27.5	100	1	5120
4336	2024-05-31 04:49:28.5	11000	1	5154
4337	2024-05-31 04:49:28.5	11000	1	5155
4338	2024-05-31 04:49:28.5	11000	1	5156
4339	2024-05-31 04:49:28.5	11000	1	5157
4340	2024-05-31 04:49:28.5	11000	1	5158
4341	2024-05-31 04:49:28.5	11000	1	5159
4342	2024-05-31 04:49:28.5	11000	1	5160
4343	2024-05-30 16:23:27.5	0	1	5165
4344	2024-05-30 16:23:27.5	0	1	5166
4345	2024-05-30 16:23:27.5	0	1	5167
4346	2024-05-30 16:23:27.5	0	1	5169
4347	2024-05-31 04:54:28.5	38	1	5170
4348	2024-05-31 04:46:27.5	39	1	5171
4349	2024-05-31 04:56:28	30	1	5175
4350	2024-05-30 16:23:27	33	1	5176
4351	2024-05-31 04:20:27.5	47	1	5178
4352	2024-05-31 01:06:27.5	34	1	5179
4353	2024-05-31 04:56:28	5550	1	5181
4354	2024-05-31 04:54:28	10675	1	5182
4363	2024-05-30 16:23:27	0	1	5198
4364	2024-05-30 16:23:27	0	1	5199
4365	2024-05-30 16:23:27	0	1	5200
4366	2024-05-30 16:23:27	0	1	5201
4367	2024-05-30 16:23:27	0	1	5202
4368	2024-05-30 16:23:27	0	1	5203
4369	2024-05-30 16:23:27	0	1	5204
4370	2024-05-30 16:23:27	0	1	5205
4371	2024-05-30 16:23:27	0	1	5206
4372	2024-05-30 16:23:27	0	1	5207
4373	2024-05-30 16:23:27	0	1	5208
4374	2024-05-30 16:23:27	0	1	5209
4381	2024-05-30 16:23:27	0	1	5217
4382	2024-05-30 16:23:27	0	1	5218
4383	2024-05-30 16:23:27	0	1	5219
4384	2024-05-30 16:23:27	0	1	5220
4385	2024-05-30 16:23:27	0	1	5221
4386	2024-05-30 16:23:27	0	1	5222
4387	2024-05-30 16:23:27	0	1	5223
4388	2024-05-30 16:23:27	0	1	5224
4389	2024-05-30 16:23:27	0	1	5225
4390	2024-05-30 16:23:27	0	1	5226
4391	2024-05-30 16:23:27	0	1	5227
4392	2024-05-30 16:23:27	0	1	5228
4393	2024-05-30 16:23:27	100	1	5229
4394	2024-05-30 16:23:27	100	1	5230
4395	2024-05-30 16:23:27	100	1	5231
4396	2024-05-30 16:23:27	100	1	5232
4397	2024-05-30 16:23:27	100	1	5233
4398	2024-05-30 16:23:27	100	1	5234
4413	2024-05-31 04:54:28	60	1	5180
4414	2024-05-31 03:57:47	12	1	5194
4419	2024-05-30 16:23:27	11200	1	5257
4420	2024-05-30 16:23:27	11200	1	5258
4421	2024-05-30 16:23:27	11200	1	5259
4422	2024-05-30 16:23:27	11200	1	5260
4423	2024-05-30 16:23:27	11200	1	5261
4424	2024-05-30 16:23:27	11200	1	5262
4425	2024-05-31 04:55:27.5	21	1	5265
4426	2024-05-30 16:23:27	21	1	5266
4427	2024-05-30 23:55:27.5	38	1	5267
4428	2024-05-31 00:02:28	35	1	5268
4429	2024-05-31 02:33:28	23	1	5269
4430	2024-05-31 04:55:27.5	44	1	5270
4431	2024-05-31 04:56:26	59	1	5273
4432	2024-05-31 04:37:26	59	1	5274
4433	2024-05-31 04:56:26	5450	1	5275
4434	2024-05-31 04:56:26	10413	1	5276
4440	2024-05-30 16:23:26	0	1	5285
4441	2024-05-30 16:23:26	0	1	5286
4442	2024-05-30 16:23:26	0	1	5287
4443	2024-05-30 16:23:26	0	1	5288
4444	2024-05-30 16:23:26	0	1	5289
4445	2024-05-30 16:23:26	0	1	5290
4449	2024-05-30 16:23:26	0	1	5294
4450	2024-05-30 16:23:26	0	1	5295
4451	2024-05-30 16:23:26	0	1	5296
4452	2024-05-30 16:23:26	0	1	5297
4453	2024-05-30 16:23:26	0	1	5298
4454	2024-05-30 16:23:26	0	1	5299
4455	2024-05-30 16:23:26	100	1	5300
4456	2024-05-30 16:23:26	100	1	5301
4457	2024-05-30 16:23:26	100	1	5302
4467	2023-01-12 03:15:41	9000	1	5312
4468	2023-01-12 03:15:41	9000	1	5313
4469	2023-01-12 03:15:41	9000	1	5314
4470	2024-05-31 04:56:26	50	1	5315
4471	2024-05-31 04:56:26	52	1	5316
4472	2024-05-31 04:29:26	50	1	5317
4473	2024-05-31 04:35:26	60	1	5320
4474	2024-05-31 04:56:26	5356	1	5321
4475	2024-05-31 04:56:26	10550	1	5322
4479	2024-05-31 04:52:26	57	1	5272
4480	2024-05-31 04:55:26	59	1	5318
4483	2024-05-30 16:23:25.5	0	1	5331
4484	2024-05-30 16:23:25.5	0	1	5332
4485	2024-05-30 16:23:25.5	0	1	5333
4486	2024-05-30 16:23:25.5	0	1	5334
4487	2024-05-30 16:23:25.5	0	1	5335
4488	2024-05-30 16:23:25.5	0	1	5336
4492	2024-05-30 16:23:25.5	0	1	5340
4493	2024-05-30 16:23:25.5	0	1	5341
4494	2024-05-30 16:23:25.5	0	1	5342
4495	2024-05-30 16:23:25.5	0	1	5343
4496	2024-05-30 16:23:25.5	0	1	5344
4497	2024-05-30 16:23:25.5	0	1	5345
4498	2024-05-30 16:23:25.5	100	1	5346
4499	2024-05-30 16:23:25.5	100	1	5347
4500	2024-05-30 16:23:25.5	100	1	5348
4510	2023-01-12 23:50:58.5	11600	1	5358
4511	2023-01-12 23:50:58.5	11600	1	5359
4512	2023-01-12 23:50:58.5	11600	1	5360
4513	2024-05-31 04:56:26	51	1	5363
4514	2024-05-31 04:49:26	58	1	5364
4515	2024-05-31 04:56:26	58	1	5365
4516	2024-05-31 04:35:26	57	1	5366
4517	2024-05-31 04:52:26	5438	1	5367
4518	2024-05-31 04:56:26	10650	1	5368
4524	2024-05-30 16:23:25.5	0	1	5377
4525	2024-05-30 16:23:25.5	0	1	5378
4526	2024-05-30 16:23:25.5	0	1	5379
4527	2024-05-30 16:23:25.5	0	1	5380
4528	2024-05-30 16:23:25.5	0	1	5381
4529	2024-05-30 16:23:25.5	0	1	5382
4533	2024-05-30 16:23:25.5	0	1	5386
4534	2024-05-30 16:23:25.5	0	1	5387
4535	2024-05-30 16:23:25.5	0	1	5388
4536	2024-05-30 16:23:25.5	0	1	5389
4537	2024-05-30 16:23:25.5	0	1	5390
4538	2024-05-30 16:23:25.5	0	1	5391
4539	2024-05-30 16:23:25.5	100	1	5392
4540	2024-05-30 16:23:25.5	100	1	5393
4541	2024-05-30 16:23:25.5	100	1	5394
4549	2024-05-31 04:56:26	55	1	5361
4550	2023-01-12 23:44:12	12000	1	5402
4552	2023-01-12 23:47:12	11600	1	5404
4553	2023-01-12 23:47:12	11600	1	5405
4554	2023-01-12 23:47:12	11600	1	5406
4555	2024-05-31 04:55:26	48	1	5407
4556	2024-05-31 04:49:26	49	1	5408
4557	2024-05-31 04:47:26	50	1	5409
4558	2024-04-29 02:34:27	0	1	5410
4559	2024-04-29 02:34:27	0	1	5411
4560	2024-04-29 02:34:27	0	1	5412
4561	2024-04-29 02:34:27	0	1	5413
4562	2024-04-29 02:34:27	0	1	5414
4568	2024-04-29 02:34:27	0	1	5423
4569	2024-04-29 02:34:27	0	1	5424
4570	2024-04-29 02:34:27	0	1	5425
4571	2024-04-29 02:34:27	0	1	5426
4572	2024-04-29 02:34:27	0	1	5427
4573	2024-04-29 02:34:27	0	1	5428
4577	2024-04-29 02:34:27	0	1	5432
4578	2024-04-29 02:34:27	0	1	5433
4579	2024-04-29 02:34:27	0	1	5434
4580	2024-04-29 02:34:27	0	1	5435
4581	2024-04-29 02:34:27	0	1	5436
4582	2024-04-29 02:34:27	0	1	5437
4583	2024-04-29 02:34:27	0	1	5438
4584	2024-04-29 02:34:27	0	1	5439
4585	2024-04-29 02:34:27	0	1	5440
4593	2023-01-09 00:02:24	12000	1	5448
4595	2023-01-10 04:57:24	11200	1	5450
4596	2023-01-10 04:57:24	11200	1	5451
4597	2023-01-10 04:57:24	11200	1	5452
4598	2024-04-29 02:34:27	0	1	5453
4599	2024-04-29 02:34:27	0	1	5454
4600	2024-04-29 02:34:27	0	1	5455
4601	2024-05-31 04:31:26	58	1	5457
4602	2024-05-31 04:54:26	60	1	5458
4603	2024-05-31 04:56:26	5388	1	5459
4604	2024-05-31 04:56:26	10663	1	5460
4610	2024-05-30 16:23:26	0	1	5469
4611	2024-05-30 16:23:26	0	1	5470
4612	2024-05-30 16:23:26	0	1	5471
4613	2024-05-30 16:23:26	0	1	5472
4614	2024-05-30 16:23:26	0	1	5473
4615	2024-05-30 16:23:26	0	1	5474
4619	2024-05-30 16:23:26	0	1	5478
4620	2024-05-30 16:23:26	0	1	5479
4621	2024-05-30 16:23:26	0	1	5480
4622	2024-05-30 16:23:26	0	1	5481
4623	2024-05-30 16:23:26	0	1	5482
4624	2024-05-30 16:23:26	0	1	5483
4625	2024-05-30 16:23:26	100	1	5484
4626	2024-05-30 16:23:26	100	1	5485
4627	2024-05-30 16:23:26	100	1	5486
4635	2023-01-09 00:01:24	12000	1	5494
4637	2023-01-09 00:01:24	11200	1	5496
4638	2023-01-09 00:01:24	11200	1	5497
4639	2023-01-09 00:01:24	11200	1	5498
4640	2024-05-31 04:26:26	51	1	5500
4641	2024-05-31 04:27:26	49	1	5501
4642	2024-05-31 04:52:28	34	1	5502
4643	2024-05-31 04:17:27.5	34	1	5503
4644	2024-05-31 02:56:27.5	57	1	5504
4645	2024-05-30 23:51:28	45	1	5505
4646	2024-05-31 04:17:27.5	38	1	5506
4647	2024-05-31 04:56:28	56	1	5507
4648	2024-05-31 04:54:27.5	5531	1	5510
4649	2024-05-31 04:56:28	10700	1	5511
4658	2024-05-30 16:23:27	0	1	5531
4659	2024-05-30 16:23:27	0	1	5532
4660	2024-05-30 16:23:27	0	1	5533
4661	2024-05-30 16:23:27	0	1	5534
4662	2024-05-30 16:23:27	0	1	5535
4663	2024-05-30 16:23:27	0	1	5536
4664	2024-05-30 16:23:27	0	1	5539
4665	2024-05-30 16:23:27	0	1	5540
4666	2024-05-30 16:23:27	0	1	5541
4667	2024-05-30 16:23:27	0	1	5542
4668	2024-05-30 16:23:27	0	1	5543
4669	2024-05-30 16:23:27	0	1	5544
4676	2024-05-31 04:45:28.5	2	1	5526
4677	2024-05-30 16:23:27	0	1	5556
4678	2024-05-30 16:23:27	0	1	5557
4679	2024-05-30 16:23:27	0	1	5558
4680	2024-05-30 16:23:27	0	1	5559
4681	2024-05-30 16:23:27	0	1	5560
4682	2024-05-30 16:23:27	0	1	5561
4683	2024-05-30 16:23:27	0	1	5564
4684	2024-05-30 16:23:27	0	1	5565
4685	2024-05-30 16:23:27	0	1	5566
4686	2024-05-30 16:23:27	0	1	5567
4687	2024-05-30 16:23:27	0	1	5568
4688	2024-05-30 16:23:27	0	1	5569
4689	2024-05-30 16:23:27	100	1	5572
4690	2024-05-30 16:23:27	100	1	5573
4691	2024-05-30 16:23:27	100	1	5574
4692	2024-05-30 16:23:27	100	1	5575
4693	2024-05-30 16:23:27	100	1	5576
4694	2024-05-30 16:23:27	100	1	5577
4713	2024-05-30 16:23:27	11600	1	5608
4714	2024-05-30 16:23:27	11600	1	5609
4715	2024-05-30 16:23:27	11600	1	5610
4716	2024-05-30 16:23:27	11600	1	5611
4717	2024-05-30 16:23:27	11600	1	5612
4718	2024-05-30 16:23:27	11600	1	5613
4719	2024-05-31 04:41:27.5	21	1	5618
4720	2024-05-30 16:23:27	22	1	5619
4721	2024-05-30 23:55:28	39	1	5620
4722	2024-05-31 04:13:28	33	1	5621
4723	2024-05-31 02:20:28	24	1	5622
4724	2024-05-31 04:43:27.5	44	1	5623
4725	2024-05-31 04:48:27	63	1	5628
4726	2024-05-31 04:56:27	60	1	5629
4727	2024-05-31 04:53:27	5344	1	5630
4728	2024-05-31 04:56:27	10338	1	5631
4734	2024-05-30 16:23:27	0	1	5641
4735	2024-05-30 16:23:27	0	1	5642
4736	2024-05-30 16:23:27	0	1	5643
4737	2024-05-30 16:23:27	0	1	5644
4738	2024-05-30 16:23:27	0	1	5645
4739	2024-05-30 16:23:27	0	1	5646
4743	2024-05-30 16:23:27	0	1	5651
4744	2024-05-30 16:23:27	0	1	5652
4745	2024-05-30 16:23:27	0	1	5653
4746	2024-05-30 16:23:27	0	1	5654
4747	2024-05-30 16:23:27	0	1	5655
4748	2024-05-30 16:23:27	0	1	5656
4749	2024-05-30 16:23:27	100	1	5657
4750	2024-05-30 16:23:27	100	1	5658
4751	2024-05-30 16:23:27	100	1	5659
4760	2024-05-30 16:44:27	9000	1	5672
4761	2024-05-30 16:44:27	9000	1	5673
4762	2024-05-31 04:55:27	63	1	5676
4763	2024-05-31 04:46:27	55	1	5678
4764	2024-05-31 04:55:27.5	43	1	5680
4765	2024-05-31 04:56:27.5	47	1	5681
4766	2024-05-31 04:56:27.5	51	1	5682
4767	2024-05-31 04:55:27.5	52	1	5683
4768	2024-05-30 16:23:27.5	0	1	5684
4769	2024-05-31 04:25:28	47	1	5685
4770	2024-05-31 04:43:28	45	1	5686
4771	2024-05-31 04:56:27.5	45	1	5687
4772	2023-11-18 04:31:23	5469	1	5688
4773	2023-11-18 04:31:23	10775	1	5689
4784	2024-04-08 06:40:00.5	11	1	5704
4785	2024-05-30 16:23:27.5	0	1	5709
4786	2024-05-30 16:23:27.5	0	1	5710
4787	2024-05-30 16:23:27.5	0	1	5711
4788	2024-05-30 16:23:27.5	0	1	5712
4789	2024-05-30 16:23:27.5	0	1	5713
4790	2024-05-30 16:23:27.5	0	1	5714
4791	2024-05-30 16:23:27.5	0	1	5715
4792	2024-05-30 16:23:27.5	0	1	5716
4793	2024-05-30 16:23:27.5	0	1	5717
4794	2024-05-30 16:23:27.5	0	1	5718
4795	2024-05-30 16:23:27.5	0	1	5719
4796	2024-05-30 16:23:27.5	0	1	5720
4797	2024-05-30 16:23:27.5	0	1	5721
4798	2024-05-30 16:23:27.5	0	1	5722
4799	2024-05-30 16:23:27.5	0	1	5723
4800	2024-05-30 16:23:27.5	0	1	5724
4810	2024-05-30 16:23:27.5	0	1	5734
4811	2024-05-30 16:23:27.5	0	1	5735
4812	2024-05-30 16:23:27.5	0	1	5736
4813	2024-05-30 16:23:27.5	0	1	5737
4814	2024-05-30 16:23:27.5	0	1	5738
4815	2024-05-30 16:23:27.5	0	1	5739
4816	2024-05-30 16:23:27.5	0	1	5740
4817	2024-05-30 16:23:27.5	0	1	5741
4818	2024-05-30 16:23:27.5	0	1	5742
4819	2024-05-30 16:23:27.5	0	1	5743
4820	2024-05-30 16:23:27.5	0	1	5744
4821	2024-05-30 16:23:27.5	0	1	5745
4822	2024-05-30 16:23:27.5	0	1	5746
4823	2024-05-30 16:23:27.5	0	1	5747
4824	2024-05-30 16:23:27.5	0	1	5748
4825	2024-05-30 16:23:27.5	0	1	5749
4826	2024-05-30 16:23:27.5	100	1	5750
4827	2024-05-30 16:23:27.5	100	1	5751
4828	2024-05-30 16:23:27.5	100	1	5752
4829	2024-05-30 16:23:27.5	100	1	5753
4830	2024-05-30 16:23:27.5	100	1	5754
4831	2024-05-30 16:23:27.5	100	1	5755
4832	2024-05-30 16:23:27.5	100	1	5756
4833	2024-05-30 16:23:27.5	100	1	5757
4834	2024-05-30 16:23:27.5	100	1	5758
4851	2024-05-31 04:50:28	6400	1	5775
4852	2024-05-31 04:22:27.5	7800	1	5776
4853	2024-05-31 04:22:27.5	7800	1	5777
4854	2024-05-31 04:51:28	7800	1	5778
4855	2024-05-31 04:51:28	7800	1	5779
4857	2024-05-30 16:23:27.5	12000	1	5781
4859	2024-05-30 16:23:27.5	12000	1	5783
4860	2024-05-31 04:55:27.5	7000	1	5784
4862	2024-05-31 04:55:27.5	7000	1	5786
4863	2024-05-31 04:55:27.5	7000	1	5787
4864	2024-05-31 04:55:27.5	7000	1	5788
4865	2024-05-31 04:55:27.5	7000	1	5789
4866	2024-05-31 04:55:27.5	7000	1	5790
4867	2024-05-31 04:55:27.5	7000	1	5791
4868	2024-05-31 04:55:27.5	7000	1	5792
4869	2024-05-31 04:55:27.5	7000	1	5793
4871	2024-05-30 18:14:27.5	7200	1	5795
4872	2024-05-31 04:43:28	32	1	5796
4873	2024-05-31 04:51:28	37	1	5797
4874	2024-05-31 04:43:28	41	1	5798
4875	2024-05-31 04:50:28	43	1	5799
4876	2024-05-30 16:23:27.5	0	1	5800
4877	2024-05-31 03:35:27.5	35	1	5801
4878	2024-05-31 04:38:28	35	1	5802
4879	2024-05-31 04:50:28	33	1	5803
4880	2024-05-31 04:54:27.5	44	1	5804
4881	2024-05-31 04:56:28	47	1	5805
4882	2024-05-31 04:53:28	47	1	5806
4883	2024-05-31 04:53:28	54	1	5807
4884	2024-05-31 04:53:28	55	1	5808
4885	2024-05-30 16:23:27.5	0	1	5809
4886	2024-05-31 04:53:28	47	1	5810
4887	2024-05-31 04:42:27.5	46	1	5811
4888	2024-05-31 03:31:28	45	1	5812
4889	2024-05-31 04:53:28	5563	1	5813
4890	2024-05-31 04:56:28	10650	1	5814
4901	2024-05-30 16:23:27.5	0	1	5834
4902	2024-05-30 16:23:27.5	0	1	5835
4903	2024-05-30 16:23:27.5	0	1	5836
4904	2024-05-30 16:23:27.5	0	1	5837
4905	2024-05-30 16:23:27.5	0	1	5838
4906	2024-05-30 16:23:27.5	0	1	5839
4907	2024-05-30 16:23:27.5	0	1	5840
4908	2024-05-30 16:23:27.5	0	1	5841
4909	2024-05-30 16:23:27.5	0	1	5842
4910	2024-05-30 16:23:27.5	0	1	5843
4911	2024-05-30 16:23:27.5	0	1	5844
4912	2024-05-30 16:23:27.5	0	1	5845
4913	2024-05-30 16:23:27.5	0	1	5846
4914	2024-05-30 16:23:27.5	0	1	5847
4915	2024-05-30 16:23:27.5	0	1	5848
4916	2024-05-30 16:23:27.5	0	1	5849
4926	2024-05-30 16:23:27.5	0	1	5859
4927	2024-05-30 16:23:27.5	0	1	5860
4928	2024-05-30 16:23:27.5	0	1	5861
4929	2024-05-30 16:23:27.5	0	1	5862
4930	2024-05-30 16:23:27.5	0	1	5863
4931	2024-05-30 16:23:27.5	0	1	5864
4932	2024-05-30 16:23:27.5	0	1	5865
4933	2024-05-30 16:23:27.5	0	1	5866
4934	2024-05-30 16:23:27.5	0	1	5867
4935	2024-05-30 16:23:27.5	0	1	5868
4936	2024-05-30 16:23:27.5	0	1	5869
4937	2024-05-30 16:23:27.5	0	1	5870
4938	2024-05-30 16:23:27.5	0	1	5871
4939	2024-05-30 16:23:27.5	0	1	5872
4940	2024-05-30 16:23:27.5	0	1	5873
4941	2024-05-30 16:23:27.5	0	1	5874
4942	2024-05-30 16:23:27.5	100	1	5875
4943	2024-05-30 16:23:27.5	100	1	5876
4944	2024-05-30 16:23:27.5	100	1	5877
4945	2024-05-30 16:23:27.5	100	1	5878
4946	2024-05-30 16:23:27.5	100	1	5879
4947	2024-05-30 16:23:27.5	100	1	5880
4948	2024-05-30 16:23:27.5	100	1	5881
4949	2024-05-30 16:23:27.5	100	1	5882
4950	2024-05-30 16:23:27.5	100	1	5883
4967	2024-05-30 16:23:27.5	6400	1	5900
4968	2024-05-30 16:23:27.5	7600	1	5901
4969	2024-05-30 16:23:27.5	7600	1	5902
4970	2024-05-31 04:44:27.5	7800	1	5903
4971	2024-05-31 04:44:27.5	7800	1	5904
4973	2024-05-30 16:23:27.5	12000	1	5906
4975	2024-05-30 16:23:27.5	12000	1	5908
4976	2024-05-31 02:58:28.5	7200	1	5909
4978	2024-05-31 02:58:28.5	7200	1	5911
4979	2024-05-31 02:58:28.5	7200	1	5912
4980	2024-05-31 02:58:28.5	7200	1	5913
4981	2024-05-31 02:58:28.5	7200	1	5914
4982	2024-05-31 02:58:28.5	7200	1	5915
4983	2024-05-31 02:58:28.5	7200	1	5916
4984	2024-05-31 02:58:28.5	7200	1	5917
4985	2024-05-31 02:58:28.5	7200	1	5918
4987	2024-05-31 03:01:27.5	7200	1	5920
4988	2024-05-31 04:39:27.5	33	1	5921
4989	2024-05-31 04:39:27.5	38	1	5922
4990	2024-05-31 04:55:28	43	1	5923
4991	2024-05-31 04:56:28	44	1	5924
4992	2024-05-30 16:23:27.5	0	1	5925
4993	2024-05-31 04:17:28	36	1	5926
4994	2024-05-31 04:38:27.5	35	1	5927
4995	2024-05-31 03:12:27.5	34	1	5928
4996	2024-05-31 04:54:28	45	1	5929
4997	2024-05-31 04:56:27.5	43	1	5930
4998	2024-05-31 04:56:27.5	45	1	5931
4999	2024-05-31 04:55:27.5	52	1	5932
5000	2024-05-31 04:55:27.5	50	1	5933
5002	2024-05-31 04:56:27.5	45	1	5935
5003	2024-05-31 04:18:28	42	1	5936
5004	2024-05-31 04:18:28	45	1	5937
5005	2024-05-31 04:55:27.5	5450	1	5938
5006	2024-05-31 04:56:27.5	10650	1	5939
5017	2024-05-30 16:23:27.5	0	1	5959
5018	2024-05-30 16:23:27.5	0	1	5960
5019	2024-05-30 16:23:27.5	0	1	5961
5020	2024-05-30 16:23:27.5	0	1	5962
5022	2024-05-30 16:23:27.5	0	1	5964
5023	2024-05-30 16:23:27.5	0	1	5965
5024	2024-05-30 16:23:27.5	0	1	5966
5025	2024-05-30 16:23:27.5	0	1	5967
5026	2024-05-30 16:23:27.5	0	1	5968
5027	2024-05-30 16:23:27.5	0	1	5969
5028	2024-05-30 16:23:27.5	0	1	5970
5030	2024-05-30 16:23:27.5	0	1	5972
5031	2024-05-30 16:23:27.5	0	1	5973
5032	2024-05-30 16:23:27.5	0	1	5974
5042	2024-05-30 16:23:27.5	0	1	5984
5043	2024-05-30 16:23:27.5	0	1	5985
5044	2024-05-30 16:23:27.5	0	1	5986
5045	2024-05-30 16:23:27.5	0	1	5987
5047	2024-05-30 16:23:27.5	0	1	5989
5048	2024-05-30 16:23:27.5	0	1	5990
5049	2024-05-30 16:23:27.5	0	1	5991
5050	2024-05-30 16:23:27.5	0	1	5992
5051	2024-05-30 16:23:27.5	0	1	5993
5052	2024-05-30 16:23:27.5	0	1	5994
5053	2024-05-30 16:23:27.5	0	1	5995
5055	2024-05-30 16:23:27.5	0	1	5997
5056	2024-05-30 16:23:27.5	0	1	5998
5057	2024-05-30 16:23:27.5	0	1	5999
5058	2024-05-30 16:23:27.5	100	1	6000
5059	2024-05-30 16:23:27.5	100	1	6001
5060	2024-05-30 16:23:27.5	100	1	6002
5061	2024-05-30 16:23:27.5	100	1	6003
5063	2024-05-30 16:23:27.5	100	1	6005
5064	2024-05-30 16:23:27.5	100	1	6006
5065	2024-05-28 23:53:59	3	1	5955
5067	2024-05-30 16:23:27.5	100	1	6007
5068	2024-05-30 16:23:27.5	100	1	6008
5085	2024-05-30 16:23:27.5	6200	1	6025
5086	2024-05-30 16:23:27.5	7400	1	6026
5087	2024-05-30 16:23:27.5	7400	1	6027
5088	2024-05-30 16:23:27.5	7600	1	6028
5089	2024-05-30 16:23:27.5	7600	1	6029
5091	2024-05-31 04:55:27.5	11600	1	6031
5093	2024-05-31 04:55:27.5	11600	1	6033
5094	2024-05-30 16:22:53.5	0	1	6034
5096	2024-05-30 16:23:27.5	7000	1	6036
5097	2024-05-30 16:23:27.5	7000	1	6037
5098	2024-05-30 16:23:27.5	7000	1	6038
5099	2024-05-30 16:23:27.5	7000	1	6039
5101	2024-05-30 16:23:27.5	7000	1	6041
5102	2024-05-30 16:23:27.5	7000	1	6042
5103	2024-05-30 16:23:27.5	7000	1	6043
5105	2024-05-31 04:56:27.5	7200	1	6045
5106	2024-05-31 04:54:27.5	32	1	6046
5107	2024-05-31 04:42:28	35	1	6047
5108	2024-05-31 04:54:27.5	39	1	6048
5109	2024-05-31 04:50:28	43	1	6049
5111	2024-05-31 03:52:27.5	34	1	6051
5112	2024-05-31 04:37:28	33	1	6052
5113	2024-05-31 04:38:28	32	1	6053
5114	2024-05-31 04:54:27.5	42	1	6054
5115	2024-05-31 04:53:28	47	1	6055
5116	2024-05-31 04:56:28	44	1	6056
5117	2024-05-31 04:56:28	49	1	6057
5118	2024-05-31 04:54:28	55	1	6058
5120	2024-05-31 04:56:28	45	1	6060
5121	2024-05-31 04:50:28	41	1	6061
5122	2024-05-31 04:41:27.5	47	1	6062
5123	2024-05-31 04:56:28	5525	1	6063
5124	2024-05-31 04:56:28	10706	1	6064
5136	2024-05-30 16:23:27.5	0	1	6084
5137	2024-05-30 16:23:27.5	0	1	6085
5138	2024-05-30 16:23:27.5	0	1	6086
5139	2024-05-30 16:23:27.5	0	1	6087
5141	2024-05-30 16:23:27.5	0	1	6089
5142	2024-05-30 16:23:27.5	0	1	6090
5143	2024-05-30 16:23:27.5	0	1	6091
5144	2024-05-30 16:23:27.5	0	1	6092
5145	2024-05-30 16:23:27.5	0	1	6093
5146	2024-05-30 16:23:27.5	0	1	6094
5147	2024-05-30 16:23:27.5	0	1	6095
5149	2024-05-30 16:23:27.5	0	1	6097
5150	2024-05-30 16:23:27.5	0	1	6098
5151	2024-05-30 16:23:27.5	0	1	6099
5161	2024-05-30 16:23:27.5	0	1	6109
5162	2024-05-30 16:23:27.5	0	1	6110
5163	2024-05-30 16:23:27.5	0	1	6111
5164	2024-05-30 16:23:27.5	0	1	6112
5166	2024-05-30 16:23:27.5	0	1	6114
5167	2024-05-30 16:23:27.5	0	1	6115
5168	2024-05-30 16:23:27.5	0	1	6116
5169	2024-05-30 16:23:27.5	0	1	6117
5170	2024-05-30 16:23:27.5	0	1	6118
5171	2024-05-30 16:23:27.5	0	1	6119
5172	2024-05-30 16:23:27.5	0	1	6120
5174	2024-05-30 16:23:27.5	0	1	6122
5175	2024-05-30 16:23:27.5	0	1	6123
5176	2024-05-30 16:23:27.5	0	1	6124
5177	2024-05-30 16:23:27.5	100	1	6125
5178	2024-05-30 16:23:27.5	100	1	6126
5179	2024-05-30 16:23:27.5	100	1	6127
5180	2024-05-30 16:23:27.5	100	1	6128
5182	2024-05-30 16:23:27.5	100	1	6130
5183	2024-05-30 16:23:27.5	100	1	6131
5184	2024-05-30 16:23:27.5	100	1	6132
5185	2024-05-30 16:23:27.5	100	1	6133
5202	2024-05-30 16:23:27.5	6200	1	6150
5203	2024-05-31 04:55:28	7400	1	6151
5204	2024-05-31 04:55:28	7400	1	6152
5205	2024-05-30 19:09:27.5	7400	1	6153
5206	2024-05-30 19:09:27.5	7400	1	6154
5208	2024-05-31 02:48:28	11600	1	6156
5210	2024-05-31 02:48:28	11600	1	6158
5211	2024-05-31 04:56:28	7400	1	6159
5213	2024-05-31 04:56:28	7400	1	6161
5214	2024-05-31 04:56:28	7400	1	6162
5215	2024-05-31 04:56:28	7400	1	6163
5216	2024-05-31 04:56:28	7400	1	6164
5218	2024-05-31 04:56:28	7400	1	6166
5219	2024-05-31 04:56:28	7400	1	6167
5220	2024-05-31 04:56:28	7400	1	6168
5222	2024-05-30 21:16:28	7000	1	6170
5223	2024-05-31 04:54:28	34	1	6171
5224	2024-05-31 04:55:28	35	1	6172
5225	2024-05-31 04:54:28	41	1	6173
5226	2024-05-31 04:55:28	44	1	6174
5228	2024-05-31 03:19:27.5	35	1	6176
5229	2024-05-31 04:16:27.5	34	1	6177
5230	2024-05-31 04:41:27.5	33	1	6178
5231	2024-05-31 04:55:28	44	1	6179
5233	2024-05-31 04:35:26	63	1	5319
5234	2024-05-31 04:53:26	61	1	5456
5235	2024-05-31 04:56:27.5	63	1	3327
5236	2024-05-31 04:53:27.5	64	1	4706
5237	2024-05-31 04:54:27	66	1	5627
5238	2024-05-31 04:54:16	51	1	1117
5239	2024-05-31 02:20:26.5	39	1	30
5240	2024-05-31 04:56:28	51	1	5177
5241	2024-05-31 04:56:16	36	1	1233
5242	2024-05-31 04:52:27	57	1	5677
5243	2024-05-31 04:55:26	51	1	5362
5244	2024-05-31 04:55:28	53	1	5168
5245	2024-05-31 04:54:27.5	57	1	4822
5246	2024-05-31 04:56:28	53	1	649
5247	2024-05-31 04:55:26	55	1	5499
5248	2024-05-31 04:51:28	72	1	5037
5249	2024-05-31 04:54:28.5	59	1	5039
5250	2024-05-31 04:56:28	58	1	4081
5251	2024-05-31 04:52:53	2	1	50
5252	2024-05-31 04:52:52.5	4	1	52
5253	2024-05-31 04:50:36	39	1	177
5254	2024-05-18 14:31:01.5	1	1	302
5255	2024-05-18 14:30:57	7	1	303
5256	2024-05-18 14:31:02	7	1	304
5257	2024-05-18 14:31:00.5	68	1	301
5258	2024-05-31 04:52:43.5	65	1	51
5259	2024-05-26 12:25:16.5	2	1	425
5260	2024-05-26 12:25:18	2	1	427
5261	2024-05-26 12:25:16.5	5	1	428
5262	2024-05-31 01:12:03.5	6	1	550
5263	2024-05-31 01:12:04.5	95	1	551
5265	2024-05-31 01:12:03.5	3	1	555
5266	2024-05-31 04:37:29.5	127	1	1979
5267	2024-05-31 01:12:03.5	3	1	556
5268	2024-05-31 04:47:29	24	1	675
5269	2024-05-31 04:47:28	83	1	676
5270	2024-05-31 04:47:29	79	1	677
5271	2024-05-31 01:46:15	3	1	868
5272	2024-05-31 01:46:15	99	1	870
5273	2024-05-31 01:46:15	10	1	872
5274	2024-05-31 01:46:14.5	1	1	873
5275	2024-05-30 22:38:14	1	1	951
5276	2024-05-30 22:38:14	52	1	952
5277	2024-05-30 22:38:13.5	32	1	954
5278	2024-05-31 03:56:26.5	2	1	1036
5279	2024-05-30 12:19:00.5	32	1	4224
5280	2024-05-31 03:56:25.5	44	1	1037
5281	2024-05-31 03:09:37	4	1	1140
5282	2024-05-31 02:44:48.5	0	1	1262
5283	2024-05-31 04:37:21.5	36	1	1981
5284	2024-05-31 03:38:47.5	33	1	1139
5285	2024-05-31 03:56:24.5	4	1	1038
5286	2024-05-31 03:56:21.5	8	1	1040
5287	2024-05-31 02:05:24.5	5	1	1369
5288	2024-05-31 02:05:23.5	29	1	1370
5289	2024-05-31 02:05:24.5	1	1	1374
5290	2024-05-31 02:36:51.5	262	1	1464
5291	2024-05-31 02:36:51.5	41	1	1465
5292	2024-05-31 02:36:50.5	5	1	1467
5293	2024-05-31 04:37:29.5	1	1	1973
5294	2024-05-31 04:37:33	1	1	1974
5295	2024-05-31 04:37:30.5	112	1	1975
5296	2024-05-31 04:37:30.5	114	1	1976
5297	2024-05-30 07:42:16.5	0	1	2099
5298	2024-05-30 07:42:19.5	38	1	2100
5299	2024-05-30 07:42:18.5	127	1	2101
5300	2024-05-30 07:42:14.5	9	1	2104
5301	2024-05-30 16:22:33	6	1	2223
5302	2024-05-30 16:22:33	3	1	2224
5303	2024-05-30 23:54:53	23	1	2855
5304	2024-05-30 16:22:33	49	1	2225
5305	2024-05-30 16:22:33	47	1	2226
5306	2024-05-30 16:22:17	40	1	2228
5307	2024-05-11 17:54:10.5	0	1	2349
5308	2024-05-11 17:54:21.5	39	1	2350
5309	2024-05-31 00:00:55.5	2	1	2473
5310	2024-05-11 17:54:09.5	1	1	2348
5311	2024-05-11 17:54:10.5	4	1	2355
5312	2024-05-31 00:01:00.5	16	1	2475
5313	2024-05-31 00:01:00.5	22	1	2476
5314	2024-05-30 11:12:11	1	1	2598
5315	2024-05-30 11:12:17	42	1	2601
5316	2024-05-31 04:25:13.5	63	1	2725
5317	2024-05-31 04:25:12.5	84	1	2729
5318	2024-05-30 11:12:09	1	1	2599
5319	2024-05-30 23:54:58	0	1	2848
5320	2024-05-30 23:54:53	0	1	2849
5321	2024-05-30 23:54:59.5	28	1	2850
5322	2024-05-30 23:54:58	42	1	2851
5323	2024-05-23 08:03:14.843	190	1	6256
5324	2024-05-23 08:03:14.843	489.3276	1	6257
5325	2024-05-23 08:03:14.843	93.5676	1	6258
5326	2024-05-23 08:03:14.843	75.3984	1	6259
5327	2024-05-23 08:03:14.843	79.4548	1	6260
5328	2024-05-23 08:03:14.843	0	1	6261
5329	2024-05-23 08:03:14.843	0	1	6262
5330	2024-05-23 08:03:14.843	16.6402	3	6263
5331	2024-05-23 08:03:14.843	0	1	6264
5332	2024-05-23 08:03:14.843	0	1	6265
5333	2024-05-21 18:15:26	1	1	2973
5334	2024-05-21 18:15:27	89	1	2975
5335	2024-05-21 18:15:27	8	1	2979
5336	2024-05-21 18:15:23	41	1	2981
5337	2024-05-29 12:18:28.5	1	1	3098
5338	2024-05-29 12:18:27.5	26	1	3100
5339	2024-05-29 12:18:27.5	21	1	3105
5340	2024-05-21 18:15:27	96	1	2976
5341	2024-05-26 07:24:18.5	56	1	3225
5342	2024-05-25 16:44:56.5	29	1	3350
5343	2024-05-26 07:24:18.5	0	1	3224
5344	2024-05-26 07:24:18.5	54	1	3226
5345	2024-05-25 16:44:55	40	1	3351
5346	2024-05-30 00:05:13.5	17	1	3480
5347	2024-05-30 00:05:25.5	4	1	3479
5348	2024-05-31 00:03:51.5	1	1	3598
5349	2024-05-31 00:03:53.5	1	1	3599
5350	2024-05-31 00:04:01.5	31	1	3600
5351	2024-05-31 00:03:59.5	7	1	3604
5352	2024-05-26 07:31:14	2	1	3723
5353	2024-05-26 07:31:23	113	1	3730
5354	2024-05-26 07:31:29	33	1	3726
5355	2024-05-26 07:30:56	8	1	3728
5356	2024-05-26 07:31:29	0	1	3729
5357	2024-05-26 07:31:23	6	1	3731
5358	2024-05-30 23:57:58	1	1	3849
5359	2024-05-26 07:31:32.5	33	1	3725
5360	2024-05-26 07:35:41	90	1	3975
5361	2024-05-26 07:35:41	99	1	3976
5362	2024-05-26 07:35:36.5	4	1	3974
5363	2024-05-26 07:35:38.5	4	1	3978
5364	2024-05-30 12:19:01.5	28	1	4225
5365	2024-05-30 12:19:04	48	1	4226
5366	2024-05-26 07:35:41.5	6	1	3979
5367	2024-05-31 04:31:37	4	1	4099
5368	2024-05-31 04:31:41	25	1	4100
5369	2024-05-31 04:31:41	49	1	4101
5370	2024-05-31 04:31:39	16	1	4104
5371	2024-05-31 04:31:38	39	1	4105
5372	2024-05-31 04:31:38	21	1	4106
5373	2024-05-30 12:19:04	2	1	4223
5374	2024-05-31 04:31:36	2	1	4098
5375	2024-05-30 12:19:05	9	1	4228
5376	2024-05-08 06:45:00.5	0	1	4229
5377	2024-05-30 12:19:05	3	1	4231
5378	2024-05-24 17:26:09	2	1	4348
5379	2024-05-24 17:26:09	26	1	4349
5380	2024-05-24 17:26:05.5	0	1	4352
5381	2024-05-24 17:26:09	42	1	4353
5382	2024-05-29 12:20:19.5	2	1	4473
5383	2024-05-29 12:20:16	5	1	4474
5384	2024-05-29 12:20:19.5	13	1	4477
5385	2024-05-29 12:20:20	11	1	4478
5386	2024-05-29 12:20:20	8	1	4481
5387	2024-05-29 00:16:45.5	1	1	4598
5388	2024-05-26 06:29:00.5	40	1	6078
5389	2024-05-29 12:20:17	32	1	4475
5390	2024-05-29 00:16:38	3	1	4599
5391	2024-05-29 00:16:48.5	40	1	4600
5392	2024-05-29 00:16:48.5	49	1	4601
5393	2024-05-29 00:16:48	5	1	4602
5394	2024-05-29 00:16:47	3	1	4603
5395	2024-04-16 09:34:11	2	1	5708
5396	2024-05-31 04:50:08.5	2	1	4723
5397	2024-05-31 04:50:07.5	2	1	4724
5398	2024-05-31 04:50:07.5	100	1	4725
5399	2024-05-31 04:50:06.5	52	1	4730
5400	2024-05-31 04:50:06.5	17	1	4731
5401	2024-05-31 04:55:40	1	1	4848
5402	2024-05-31 04:55:39.5	4	1	4849
5403	2024-05-31 04:55:42.5	10	1	4850
5404	2024-05-31 04:55:37	13	1	4852
5405	2024-05-31 04:34:28	1	1	4967
5406	2024-05-31 04:34:28.5	3	1	4968
5407	2024-05-31 04:34:28.5	22	1	4969
5408	2024-05-31 04:34:23.5	6	1	4970
5409	2024-05-31 04:50:07.5	127	1	4726
5410	2024-05-31 04:54:15	86	1	5059
5411	2024-05-31 04:54:15	81	1	5060
5412	2024-05-31 04:54:15	3	1	5061
5413	2024-05-31 04:54:14	1	1	5062
5414	2024-05-26 06:26:16.5	2	1	5825
5415	2024-05-31 04:54:12.5	50	1	5063
5416	2024-05-31 04:54:14	57	1	5064
5417	2024-05-31 03:57:49	6	1	5191
5418	2024-05-31 03:57:49	24	1	5193
5419	2024-05-31 03:57:49	26	1	5196
5420	2024-05-31 04:45:29.5	50	1	5522
5421	2024-05-31 04:45:29.5	30	1	5524
5422	2024-05-31 04:45:29.5	12	1	5525
5423	2024-04-16 09:34:14	2	1	5700
5424	2024-04-16 09:34:14	0	1	5701
5425	2024-04-16 09:34:10	42	1	5702
5426	2024-04-16 09:34:07	42	1	5703
5427	2024-04-16 09:34:08.5	3	1	5705
5428	2024-04-16 09:34:07	28	1	5706
5429	2024-05-26 06:26:27.5	2	1	5826
5430	2024-05-26 06:26:28.5	125	1	5828
5431	2024-05-28 23:53:55	0	1	5950
5432	2024-05-28 23:53:56	2	1	5951
5433	2024-05-28 23:54:05	25	1	5952
5434	2024-05-28 23:53:56	2	1	5957
5435	2024-05-26 06:28:59.5	1	1	6075
5436	2024-05-26 06:29:00.5	34	1	6077
5437	2024-05-28 23:54:06	1	1	5956
5438	2024-05-30 23:57:53	1	1	3848
5439	2024-05-30 23:57:58	38	1	3851
5440	2024-05-30 23:57:57	33	1	3850
5441	2024-05-30 12:19:03.5	7	1	4230
5442	2024-05-30 23:57:56	1	1	3854
5443	2024-05-26 07:35:36.5	2	1	3980
5444	2024-05-30 23:57:52	4	1	3855
5445	2024-05-26 07:35:32.5	105	1	3973
5446	2024-05-31 00:04:01.5	38	1	3601
5447	2024-05-29 12:18:27.5	35	1	3101
5448	2024-05-31 00:03:54.5	3	1	3605
5449	2024-05-25 16:44:46	1	1	3348
5450	2024-05-25 16:44:53	4	1	3354
5451	2024-05-26 07:24:17.5	7	1	3229
5452	2024-05-30 00:05:23.5	103	1	3475
5453	2024-05-24 17:26:09	31	1	4350
5454	2024-05-26 12:25:18	113	1	429
5455	2024-05-26 12:24:57	14	1	433
5456	2024-05-30 11:12:12	5	1	2603
5457	2024-05-30 11:12:16	5	1	2604
5458	2024-05-11 17:54:22.5	46	1	2351
5459	2024-05-31 00:00:48.5	0	1	2474
5460	2024-05-25 16:44:53	3	1	3355
5461	2024-05-30 16:22:14	23	1	2230
5462	2024-05-28 23:54:05	41	1	5953
5463	2024-05-26 06:26:28.5	116	1	5827
5464	2024-05-26 06:26:27.5	3	1	5831
5465	2024-05-29 12:20:19.5	44	1	4476
5466	2024-03-27 22:40:11	1	1	4604
5467	2024-05-29 00:16:47	0	1	4605
5468	2024-05-31 04:50:07.5	6	1	4729
5469	2024-05-31 04:34:28	19	1	4971
5470	2024-05-31 04:37:21.5	2	1	1980
5471	2022-11-11 22:57:01.257	39.5338	1	6222
5472	2022-11-11 22:57:01.257	-0.2757	3	6223
5473	2022-11-11 22:57:01.257	986	1	6224
5474	2022-11-11 22:57:01.257	190	1	6225
5475	2022-11-11 22:57:01.257	214.999	1	6226
5476	2022-11-11 22:57:01.257	95.0003	1	6227
5477	2022-11-11 22:57:01.257	494.9999	1	6228
5478	2022-11-11 22:57:01.257	-0.022	1	6229
5479	2022-11-11 22:57:01.257	0.029	1	6230
5480	2022-11-11 22:57:01.257	0	1	6231
5481	2022-11-11 22:57:01.257	0	1	6232
5482	2022-11-11 22:57:01.257	0	1	6233
5483	2024-05-31 04:51:21	1	1	175
5484	2024-05-31 04:51:21.5	1	1	179
5485	2024-05-18 14:31:01	0	1	300
5486	2024-05-26 12:25:14.5	67	1	426
5487	2024-05-30 23:57:55	5	1	3853
5488	2024-05-30 11:12:09	23	1	2605
5489	2024-05-31 04:52:49.5	17	1	58
5490	2024-05-31 04:51:13.5	10	1	183
5491	2024-05-18 14:30:40	1	1	308
5492	2024-05-30 23:54:55	4	1	2854
5493	2024-05-21 18:15:22	2	1	2974
5494	2024-05-31 04:52:53	12	1	54
5495	2024-05-31 01:12:04.5	65	1	552
5496	2024-05-30 22:38:14	1	1	953
5497	2024-05-30 22:38:01.5	6	1	956
5498	2024-05-31 03:56:20.5	12	1	1039
5499	2024-05-31 03:38:37.5	0	1	1137
5500	2024-05-31 03:38:42.5	6	1	1138
5501	2024-05-31 02:44:50.5	14	1	1264
5502	2024-05-31 02:44:50.5	3	1	1261
5503	2024-05-31 02:44:50	10	1	1265
5504	2024-05-31 02:44:50.5	12	1	1266
5505	2024-05-31 02:44:49.5	2	1	1260
5506	2024-05-31 02:05:24.5	3	1	1371
5507	2024-05-31 02:05:20.5	14	1	1372
5508	2024-05-31 02:05:20.5	5	1	1375
5509	2024-05-31 02:36:51.5	7	1	1466
5510	2024-05-31 02:36:47	45	1	1469
5511	2024-05-30 07:42:19.5	3	1	2103
5512	2024-05-30 07:42:10.5	9	1	2106
5513	2024-05-30 16:22:31	19	1	2229
5514	2024-05-30 16:22:33	37	1	2231
5515	2024-05-11 17:53:48.5	0	1	2352
5516	2024-05-11 17:54:22.5	3	1	2353
5517	2024-05-11 17:54:21.5	16	1	2354
5518	2024-05-11 17:54:10.5	0	1	2356
5519	2024-05-31 00:00:26.5	40	1	2477
5520	2024-05-31 00:00:50.5	8	1	2478
5521	2024-05-31 00:00:59.5	5	1	2480
5522	2024-05-31 00:00:49.5	32	1	2481
5523	2024-05-30 11:12:09	38	1	2606
5524	2024-05-31 04:25:14.5	40	1	2726
5525	2024-05-31 04:25:06.5	32	1	2731
5526	2024-05-21 18:15:25	4	1	2978
5527	2024-05-21 18:15:26	4	1	2980
5528	2024-05-26 07:24:18.5	2	1	3230
5529	2024-05-31 00:03:54.5	5	1	3603
5530	2024-05-31 00:03:52.5	23	1	3606
5531	2024-03-31 04:46:35.34	-0.079	1	6237
5532	2024-03-31 04:46:35.34	495	1	6239
5533	2024-03-31 04:46:35.34	99.0006	1	6240
5534	2024-05-30 23:57:52	37	1	3856
5535	2024-05-24 17:25:15.5	6	1	4355
5536	2024-05-31 03:57:49	5	1	5192
5537	2024-05-31 03:57:49	2	1	5195
5538	2024-05-31 04:45:21.5	4	1	5523
5539	2024-05-31 04:45:23.5	1	1	5527
5540	2024-04-16 09:34:03.5	4	1	5707
5541	2024-05-26 06:29:00.5	1	1	6081
5542	2024-05-26 06:26:20.5	90	1	5829
5543	2024-05-26 06:26:20.5	43	1	5830
5544	2024-05-26 06:26:26.5	3	1	5832
5545	2024-05-26 06:26:19.5	18	1	5833
5546	2024-05-28 23:53:55	1	1	5958
5547	2024-05-26 06:28:51.5	10	1	6080
5548	2024-05-31 02:44:50.5	5	1	1263
5549	2024-03-31 04:46:35.34	1	1	6246
5550	2024-03-31 04:46:35.34	1	1	6247
5551	2024-03-31 04:46:35.34	1	1	6248
5552	2024-03-31 04:46:35.34	0	1	6249
5553	2024-05-30 07:42:09.5	2	1	2098
5554	2024-05-30 11:12:16	77	1	2600
5555	2024-05-31 04:25:04.5	1	1	2723
5556	2024-05-31 04:25:10.5	1	1	2724
5557	2024-05-31 04:25:12.5	2	1	2730
5558	2024-05-30 23:54:53	39	1	2856
5559	2024-05-29 12:18:27.5	1	1	3099
5560	2024-05-29 12:18:28.5	21	1	3104
5561	2024-03-31 04:46:35.34	0	1	6251
5562	2024-03-31 04:46:35.34	220.7714	1	6250
5563	2024-05-29 12:18:28.5	0	1	3106
5564	2024-05-26 07:24:13.5	30	1	3231
5565	2024-05-30 00:05:23.5	1	1	3473
5566	2024-05-25 16:44:44	1	1	3356
5567	2024-05-26 07:31:23	1	1	3724
5568	2024-05-30 00:05:14.5	36	1	3481
5569	2024-03-31 04:46:35.34	49.0535	1	6234
5570	2024-03-31 04:46:35.34	0.9988	1	6235
5571	2024-03-31 04:46:35.34	990.0002	1	6236
5572	2024-03-31 04:46:35.34	90	1	6238
5573	2024-03-31 04:46:35.34	99.239	1	6241
5574	2024-03-31 04:46:35.34	0	1	6242
5575	2024-03-31 04:46:35.34	0	1	6243
5576	2024-03-31 04:46:35.34	1	1	6244
5577	2024-03-31 04:46:35.34	0	1	6245
5578	2024-05-26 07:35:36.5	38	1	3981
5579	2024-05-31 04:54:14	4	1	5058
5580	2024-05-26 06:28:55.5	0	1	6076
5581	2024-05-26 06:28:55.5	2	1	6082
5582	2024-05-26 06:28:49.5	16	1	6083
5583	2024-05-26 07:24:16.5	2	1	3223
5584	2024-05-30 23:54:56	5	1	2853
5585	2024-05-30 07:42:11.5	5	1	2105
5586	2024-05-24 17:26:08	25	1	4356
5587	2024-05-31 01:46:15	29	1	869
5588	2024-05-23 08:03:14.843	16.6402	3	6252
5589	2024-05-23 08:03:14.843	986.0002	3	6253
5590	2024-05-23 08:03:14.843	986.0002	1	6254
5591	2024-05-23 08:03:14.843	16.6402	1	6255
5592	2024-05-25 16:44:46	1	1	3349
5593	2024-05-30 00:05:23.5	114	1	3476
5594	2024-05-30 00:05:14.5	5	1	3474
5595	2023-05-09 21:14:05.12	0	1	6288
5596	2023-05-09 21:14:05.12	0	1	6289
5597	2023-05-09 21:14:05.12	200	1	6290
5598	2023-05-09 21:14:05.12	0	1	6291
5599	2023-05-09 21:14:05.12	121	1	6292
5600	2023-05-09 21:14:05.12	0	1	6293
5601	2023-05-09 21:14:05.12	0	1	6294
5602	2023-12-08 09:34:39.468098	0	1	1
5603	2023-12-08 09:34:39.468098	0	1	2
5604	2023-12-08 09:34:39.468098	0	1	3
5605	2023-12-08 09:34:39.468098	0	1	4
5606	2023-12-08 09:34:39.468098	0	1	5
5607	2023-12-08 09:34:39.468098	0	1	6
5608	2023-12-08 09:34:39.468098	0	1	7
5609	2023-12-08 09:34:39.468098	0	1	8
5610	2023-12-08 09:34:39.468098	0	1	9
5611	2023-12-08 09:34:39.468098	0	1	10
5612	2023-12-08 09:34:39.468098	0	1	11
5613	2023-12-08 09:34:39.468098	0	1	12
5614	2023-12-08 09:34:39.468098	0	1	13
5615	2023-12-08 09:34:39.468098	0	1	14
5616	2023-12-08 09:34:39.468098	0	1	15
5617	2023-12-08 09:34:39.468098	0	1	16
5618	2023-12-08 09:34:39.468098	0	1	17
5619	2023-12-08 09:34:39.468098	0	1	18
5620	2023-12-08 09:34:39.468098	0	1	19
5621	2023-12-08 09:34:39.468098	0	1	20
5622	2023-12-08 09:34:39.468098	0	1	21
5623	2023-12-08 09:34:39.468098	0	1	22
5624	2024-05-31 04:56:26.5	11000	1	42
5625	2024-05-30 16:23:26	11400	1	43
5626	2024-05-30 16:23:26	11400	1	44
5627	2024-05-31 04:56:26.5	11000	1	45
5628	2024-05-30 16:23:26	8800	1	46
5629	2024-05-30 16:23:26	0	1	75
5630	2024-05-30 16:23:26	0	1	76
5631	2024-05-30 16:23:26	0	1	77
5632	2024-05-30 16:23:26	0	1	78
5633	2024-05-30 16:23:26	0	1	79
5634	2024-05-30 16:23:26	12000	1	80
5635	2024-05-30 16:23:26	0	1	109
5636	2024-05-30 16:23:26	0	1	110
5637	2024-05-30 16:23:26	0	1	111
5638	2024-05-30 16:23:26	0	1	112
5639	2024-05-30 16:23:26	0	1	113
5640	2024-05-30 16:23:26	0	1	117
5641	2024-05-30 16:23:26	0	1	118
5642	2024-05-30 16:23:26	0	1	119
5643	2024-05-30 16:23:26	0	1	120
5644	2024-05-30 16:23:26	0	1	121
5645	2024-05-30 16:23:26	12000	1	130
5646	2024-05-30 16:23:26	0	1	135
5647	2024-05-30 16:23:26	0	1	144
5648	2024-05-31 04:50:26.5	11600	1	167
5649	2024-05-30 16:23:26.5	11200	1	168
5650	2024-05-31 04:50:26.5	11600	1	169
5651	2024-05-30 16:23:26.5	11200	1	170
5652	2024-05-30 16:23:26.5	11200	1	171
5653	2024-05-30 16:23:26.5	0	1	200
5654	2024-05-30 16:23:26.5	0	1	201
5655	2024-05-30 16:23:26.5	0	1	202
5656	2024-05-30 16:23:26.5	0	1	203
5657	2024-05-30 16:23:26.5	0	1	204
5658	2024-05-30 16:23:26.5	0	1	205
5659	2024-05-30 16:23:26.5	0	1	234
5660	2024-05-30 16:23:26.5	0	1	235
5661	2024-05-30 16:23:26.5	0	1	236
5662	2024-05-30 16:23:26.5	0	1	237
5663	2024-05-30 16:23:26.5	0	1	238
5664	2024-05-30 16:23:26.5	0	1	242
5665	2024-05-30 16:23:26.5	0	1	243
5666	2024-05-30 16:23:26.5	0	1	244
5667	2024-05-30 16:23:26.5	0	1	245
5668	2024-05-30 16:23:26.5	0	1	246
5669	2024-05-30 16:23:26.5	0	1	255
5670	2024-05-30 16:23:26.5	0	1	260
5671	2024-05-30 16:23:26.5	0	1	269
5672	2024-05-30 16:23:26.5	11800	1	292
5673	2024-05-30 16:23:26.5	11400	1	293
5674	2024-05-30 16:23:26.5	11400	1	294
5675	2024-05-30 16:23:26.5	11800	1	295
5676	2024-05-30 16:23:26.5	8800	1	296
5677	2024-05-30 16:23:26.5	0	1	325
5678	2024-05-30 16:23:26.5	0	1	326
5679	2024-05-30 16:23:26.5	0	1	327
5680	2024-05-30 16:23:26.5	0	1	328
5681	2024-05-30 16:23:26.5	0	1	329
5682	2024-05-31 02:09:27	11800	1	330
5683	2024-05-30 16:23:26.5	0	1	359
5684	2024-05-30 16:23:26.5	0	1	360
5685	2024-05-30 16:23:26.5	0	1	361
5686	2024-05-30 16:23:26.5	0	1	362
5687	2024-05-30 16:23:26.5	0	1	363
5688	2024-05-30 16:23:26.5	0	1	367
5689	2024-05-30 16:23:26.5	0	1	368
5690	2024-05-30 16:23:26.5	0	1	369
5691	2024-05-30 16:23:26.5	0	1	370
5692	2024-05-30 16:23:26.5	0	1	371
5693	2024-05-30 16:23:26.5	12000	1	380
5694	2024-05-30 16:23:26.5	0	1	385
5695	2024-05-30 16:23:26.5	0	1	394
5696	2024-05-31 04:47:26.5	11000	1	417
5697	2024-05-31 04:46:26.5	11200	1	418
5698	2024-05-31 04:46:26.5	11200	1	419
5699	2024-05-31 04:47:26.5	11000	1	420
5700	2024-05-30 16:23:26.5	8800	1	421
5701	2024-05-30 16:23:26.5	0	1	450
5702	2024-05-30 16:23:26.5	0	1	451
5703	2024-05-30 16:23:26.5	0	1	452
5704	2024-05-30 16:23:26.5	0	1	453
5705	2024-05-30 16:23:26.5	0	1	454
5706	2024-05-30 16:23:26.5	12000	1	455
5707	2024-05-30 16:23:26.5	0	1	484
5708	2024-05-30 16:23:26.5	0	1	485
5709	2024-05-30 16:23:26.5	0	1	486
5710	2024-05-30 16:23:26.5	0	1	487
5711	2024-05-30 16:23:26.5	0	1	488
5712	2024-05-30 16:23:26.5	0	1	492
5713	2024-05-30 16:23:26.5	0	1	493
5714	2024-05-30 16:23:26.5	0	1	494
5715	2024-05-30 16:23:26.5	0	1	495
5716	2024-05-30 16:23:26.5	0	1	496
5717	2024-05-30 16:23:26.5	12000	1	505
5718	2024-05-30 16:23:26.5	0	1	510
5719	2024-05-30 16:23:26.5	0	1	519
5720	2024-05-30 16:23:27.5	11200	1	542
5721	2024-05-30 16:23:27.5	11200	1	543
5722	2024-05-30 16:23:27.5	11200	1	544
5723	2024-05-31 04:54:30.5	11400	1	545
5724	2024-05-31 04:54:30.5	11400	1	547
5725	2024-05-31 04:54:30.5	11400	1	548
5726	2024-05-30 16:22:53.5	0	1	576
5727	2024-05-30 16:22:53.5	0	1	577
5728	2024-05-30 16:22:53.5	0	1	578
5729	2024-05-30 16:22:53.5	0	1	579
5730	2024-05-30 16:22:53.5	0	1	581
5731	2024-05-30 16:22:53.5	0	1	582
5732	2024-05-30 16:23:27.5	0	1	609
5733	2024-05-30 16:23:27.5	0	1	610
5734	2024-05-30 16:23:27.5	0	1	611
5735	2024-05-30 16:23:27.5	0	1	612
5736	2024-05-30 16:23:27.5	0	1	614
5737	2024-05-30 16:23:27.5	0	1	615
5738	2024-05-30 16:23:27.5	0	1	617
5739	2024-05-30 16:23:27.5	0	1	618
5740	2024-05-30 16:23:27.5	0	1	619
5741	2024-05-30 16:23:27.5	0	1	620
5742	2024-05-30 16:23:27.5	0	1	622
5743	2024-05-30 16:23:27.5	0	1	623
5744	2024-05-30 16:23:27.5	0	1	626
5745	2024-05-30 16:23:27.5	0	1	627
5746	2024-05-30 16:23:27.5	0	1	628
5747	2024-05-30 16:23:27.5	0	1	629
5748	2024-05-30 16:23:27.5	0	1	631
5749	2024-05-30 16:23:27.5	0	1	632
5750	2023-12-08 09:34:39.468098	0	1	634
5751	2023-12-08 09:34:39.468098	0	1	635
5752	2023-12-08 09:34:39.468098	0	1	644
5753	2023-12-08 09:34:39.468098	0	1	645
5754	2024-05-30 17:42:34	11200	1	667
5755	2024-05-30 17:42:34	11200	1	668
5756	2024-05-30 17:42:34	11200	1	669
5757	2024-05-30 17:42:34	0	1	701
5758	2024-05-30 17:42:34	0	1	702
5759	2024-05-30 17:42:34	0	1	703
5760	2024-05-30 17:42:34	0	1	734
5761	2024-05-30 17:42:34	0	1	735
5762	2024-05-30 17:42:34	0	1	736
5763	2024-05-30 17:42:34	0	1	742
5764	2024-05-30 17:42:34	0	1	743
5765	2024-05-30 17:42:34	0	1	744
5766	2024-05-30 17:42:34	0	1	751
5767	2024-05-30 17:42:34	0	1	752
5768	2024-05-30 17:42:34	0	1	753
5769	2023-12-08 09:34:39.468098	0	1	759
5770	2023-12-08 09:34:39.468098	0	1	760
5771	2023-12-08 09:34:39.468098	0	1	769
5772	2023-12-08 09:34:39.468098	0	1	770
5773	2024-05-31 04:56:27.5	67	1	780
5774	2024-05-31 04:49:27.5	62	1	781
5775	2024-05-31 04:46:27.5	46	1	782
5776	2024-05-30 16:23:27	0	1	783
5777	2024-05-30 16:23:27	0	1	784
5778	2024-05-31 04:56:27.5	4981	1	785
5779	2024-05-31 04:56:27.5	9706	1	786
5780	2024-05-30 16:23:27	11600	1	789
5781	2024-05-30 16:23:27	11400	1	790
5782	2024-05-31 04:53:27.5	11800	1	791
5783	2024-05-31 02:54:27.5	9000	1	792
5784	2024-05-31 02:54:27.5	9000	1	793
5785	2023-12-08 09:34:39.468098	0	1	794
5786	2023-12-08 09:34:39.468098	0	1	795
5787	2023-12-08 09:34:39.468098	0	1	796
5788	2023-12-08 09:34:39.468098	0	1	797
5789	2023-12-08 09:34:39.468098	0	1	798
5790	2024-05-30 16:23:27	0	1	799
5791	2024-05-30 16:23:27	0	1	800
5792	2024-05-30 16:23:27	0	1	801
5793	2024-05-30 16:23:27	0	1	802
5794	2024-05-30 16:23:27	0	1	803
5795	2024-05-30 16:23:27	0	1	804
5796	2024-05-30 16:23:27	0	1	805
5797	2024-05-30 16:23:27	0	1	806
5798	2024-05-30 16:23:27	0	1	807
5799	2024-05-30 16:23:27	0	1	808
5800	2024-05-30 16:23:27	0	1	809
5801	2024-05-30 16:23:27	0	1	810
5802	2024-05-30 16:23:27	0	1	811
5803	2024-05-30 16:23:27	0	1	812
5804	2024-05-30 16:23:27	0	1	813
5805	2024-05-30 16:23:27	0	1	814
5806	2024-05-30 16:23:27	0	1	815
5807	2024-05-30 16:23:27	0	1	816
5808	2024-05-30 16:23:27	0	1	817
5809	2024-05-30 16:23:27	0	1	818
5810	2024-05-30 16:23:27	0	1	819
5811	2024-05-30 16:23:27	0	1	820
5812	2024-05-30 16:23:27	0	1	821
5813	2024-05-30 16:23:27	0	1	822
5814	2024-05-30 16:23:27	0	1	823
5815	2024-05-30 16:23:27	100	1	824
5816	2024-05-30 16:23:27	100	1	825
5817	2024-05-30 16:23:27	100	1	826
5818	2024-05-30 16:23:27	100	1	827
5819	2024-05-30 16:23:27	100	1	828
5820	2024-05-30 16:23:27	0	1	829
5821	2024-05-30 16:23:27	0	1	830
5822	2024-05-30 16:23:27	0	1	831
5823	2024-05-30 16:23:27	0	1	832
5824	2024-05-30 16:23:27	0	1	833
5825	2024-05-30 16:23:27	0	1	834
5826	2024-05-30 16:23:27	0	1	835
5827	2024-05-30 16:23:27	0	1	836
5828	2024-05-30 16:23:27	0	1	837
5829	2024-05-30 16:23:27	0	1	838
5830	2024-05-30 16:23:27	0	1	839
5831	2024-05-30 16:23:27	8000	1	840
5832	2024-05-30 16:23:27	0	1	841
5833	2024-05-30 16:23:27	0	1	842
5834	2024-05-30 16:23:27	0	1	843
5835	2024-05-30 16:23:27	11600	1	844
5836	2024-05-30 16:23:27	11600	1	845
5837	2024-05-30 16:23:27	11600	1	846
5838	2024-05-30 16:23:27	11600	1	847
5839	2024-05-30 16:23:27	11600	1	848
5840	2024-05-31 04:55:27.5	60	1	849
5841	2024-05-31 04:48:27.5	55	1	850
5842	2024-05-30 16:23:27	0	1	851
5843	2024-05-30 16:23:27	0	1	852
5844	2024-05-30 16:23:27	0	1	853
5845	2023-12-08 09:34:39.468098	0	1	863
5846	2023-12-08 09:34:39.468098	0	1	864
5847	2023-12-08 09:34:39.468098	0	1	865
5848	2023-12-08 09:34:39.468098	0	1	866
5849	2023-12-08 09:34:39.468098	0	1	867
5850	2023-12-08 09:34:39.468098	0	1	884
5851	2023-12-08 09:34:39.468098	0	1	885
5852	2023-12-08 09:34:39.468098	0	1	886
5853	2023-12-08 09:34:39.468098	0	1	887
5854	2023-12-08 09:34:39.468098	0	1	888
5855	2023-12-08 09:34:39.468098	0	1	889
5856	2023-12-08 09:34:39.468098	0	1	906
5857	2023-12-08 09:34:39.468098	0	1	907
5858	2023-12-08 09:34:39.468098	0	1	908
5859	2023-12-08 09:34:39.468098	0	1	909
5860	2023-12-08 09:34:39.468098	0	1	910
5861	2023-12-08 09:34:39.468098	0	1	911
5862	2023-12-08 09:34:39.468098	0	1	912
5863	2023-12-08 09:34:39.468098	0	1	913
5864	2023-12-08 09:34:39.468098	0	1	914
5865	2023-12-08 09:34:39.468098	0	1	915
5866	2023-12-08 09:34:39.468098	0	1	921
5867	2023-12-08 09:34:39.468098	0	1	923
5868	2023-12-08 09:34:39.468098	0	1	929
5869	2024-05-30 16:23:27	11200	1	946
5870	2024-05-30 16:23:27	11600	1	947
5871	2024-05-30 16:23:27	11600	1	948
5872	2024-05-30 16:23:27	11200	1	949
5873	2024-05-31 01:35:27	11400	1	950
5874	2024-05-30 16:23:27	0	1	967
5875	2024-05-30 16:23:27	0	1	968
5876	2024-05-30 16:23:27	0	1	969
5877	2024-05-30 16:23:27	0	1	970
5878	2024-05-30 16:23:27	0	1	971
5879	2024-05-30 16:23:27	0	1	972
5880	2024-05-30 16:23:27	0	1	989
5881	2024-05-30 16:23:27	0	1	990
5882	2024-05-30 16:23:27	0	1	991
5883	2024-05-30 16:23:27	0	1	992
5884	2024-05-30 16:23:27	0	1	993
5885	2024-05-30 16:23:27	0	1	994
5886	2024-05-30 16:23:27	0	1	995
5887	2024-05-30 16:23:27	0	1	996
5888	2024-05-30 16:23:27	0	1	997
5889	2024-05-30 16:23:27	0	1	998
5890	2024-05-30 16:23:27	0	1	1004
5891	2024-05-30 16:23:27	0	1	1006
5892	2024-05-30 16:23:27	0	1	1012
5893	2023-12-08 09:34:39.468098	0	1	1030
5894	2023-12-08 09:34:39.468098	0	1	1031
5895	2023-12-08 09:34:39.468098	0	1	1032
5896	2023-12-08 09:34:39.468098	0	1	1033
5897	2023-12-08 09:34:39.468098	0	1	1034
5898	2023-12-08 09:34:39.468098	0	1	1035
5899	2023-12-08 09:34:39.468098	0	1	1055
5900	2023-12-08 09:34:39.468098	0	1	1056
5901	2023-12-08 09:34:39.468098	0	1	1057
5902	2023-12-08 09:34:39.468098	0	1	1058
5903	2023-12-08 09:34:39.468098	0	1	1059
5904	2023-12-08 09:34:39.468098	0	1	1060
5905	2023-12-08 09:34:39.468098	0	1	1061
5906	2023-12-08 09:34:39.468098	0	1	1081
5907	2023-12-08 09:34:39.468098	0	1	1082
5908	2023-12-08 09:34:39.468098	0	1	1083
5909	2023-12-08 09:34:39.468098	0	1	1084
5910	2023-12-08 09:34:39.468098	0	1	1085
5911	2023-12-08 09:34:39.468098	0	1	1086
5912	2023-12-08 09:34:39.468098	0	1	1087
5913	2023-12-08 09:34:39.468098	0	1	1088
5914	2023-12-08 09:34:39.468098	0	1	1089
5915	2023-12-08 09:34:39.468098	0	1	1090
5916	2023-12-08 09:34:39.468098	0	1	1091
5917	2023-12-08 09:34:39.468098	0	1	1092
5918	2023-12-08 09:34:39.468098	0	1	1098
5919	2023-12-08 09:34:39.468098	0	1	1101
5920	2023-12-08 09:34:39.468098	0	1	1108
5921	2024-05-31 03:32:16	11400	1	1129
5922	2024-05-31 02:42:16	11400	1	1130
5923	2024-05-31 03:32:16	11400	1	1131
5924	2024-05-31 02:42:16	11400	1	1132
5925	2023-12-08 09:34:39.468098	0	1	1145
5926	2024-04-29 02:34:27	0	1	1162
5927	2024-05-31 02:42:16	0	1	1163
5928	2024-05-31 02:42:16	0	1	1164
5929	2024-05-31 02:42:16	0	1	1165
5930	2024-05-31 02:42:16	0	1	1166
5931	2024-04-29 02:34:27	0	1	1195
5932	2024-05-31 02:42:16	0	1	1196
5933	2024-05-31 02:42:16	0	1	1197
5934	2024-05-31 02:42:16	0	1	1198
5935	2024-05-31 02:42:16	0	1	1199
5936	2024-05-31 02:42:16	0	1	1204
5937	2024-05-31 02:42:16	0	1	1205
5938	2024-05-31 02:42:16	0	1	1206
5939	2024-05-31 02:42:16	0	1	1207
5940	2024-04-29 02:34:27	0	1	1212
5941	2024-05-31 02:42:16	0	1	1214
5942	2024-05-31 02:42:16	0	1	1216
5943	2024-04-29 02:34:27	0	1	1221
5944	2024-04-29 02:34:27	0	1	1222
5945	2024-04-29 02:34:27	0	1	1231
5946	2024-04-29 02:34:27	0	1	1232
5947	2024-04-29 02:34:27	0	1	1241
5948	2023-12-08 09:34:39.468098	0	1	1253
5949	2023-12-08 09:34:39.468098	0	1	1254
5950	2023-12-08 09:34:39.468098	0	1	1255
5951	2023-12-08 09:34:39.468098	0	1	1256
5952	2023-12-08 09:34:39.468098	0	1	1257
5953	2023-12-08 09:34:39.468098	0	1	1258
5954	2023-12-08 09:34:39.468098	0	1	1259
5955	2023-12-08 09:34:39.468098	0	1	1282
5956	2023-12-08 09:34:39.468098	0	1	1283
5957	2023-12-08 09:34:39.468098	0	1	1284
5958	2023-12-08 09:34:39.468098	0	1	1285
5959	2023-12-08 09:34:39.468098	0	1	1286
5960	2023-12-08 09:34:39.468098	0	1	1287
5961	2023-12-08 09:34:39.468098	0	1	1288
5962	2023-12-08 09:34:39.468098	0	1	1289
5963	2023-12-08 09:34:39.468098	0	1	1312
5964	2023-12-08 09:34:39.468098	0	1	1313
5965	2023-12-08 09:34:39.468098	0	1	1314
5966	2023-12-08 09:34:39.468098	0	1	1315
5967	2023-12-08 09:34:39.468098	0	1	1316
5968	2023-12-08 09:34:39.468098	0	1	1317
5969	2023-12-08 09:34:39.468098	0	1	1318
5970	2023-12-08 09:34:39.468098	0	1	1319
5971	2023-12-08 09:34:39.468098	0	1	1320
5972	2023-12-08 09:34:39.468098	0	1	1321
5973	2023-12-08 09:34:39.468098	0	1	1322
5974	2023-12-08 09:34:39.468098	0	1	1323
5975	2023-12-08 09:34:39.468098	0	1	1324
5976	2023-12-08 09:34:39.468098	0	1	1325
5977	2023-12-08 09:34:39.468098	0	1	1331
5978	2023-12-08 09:34:39.468098	0	1	1333
5979	2023-12-08 09:34:39.468098	0	1	1335
5980	2023-12-08 09:34:39.468098	0	1	1343
5981	2023-12-08 09:34:39.468098	0	1	1363
5982	2024-05-30 16:23:26.5	11600	1	1364
5983	2024-05-30 16:23:26.5	11600	1	1365
5984	2024-05-30 16:23:26.5	11400	1	1366
5985	2024-05-30 16:23:26.5	11400	1	1367
5986	2024-05-30 16:23:26.5	11400	1	1368
5987	2024-05-30 16:23:26.5	0	1	1388
5988	2023-12-08 09:34:39.468098	0	1	1389
5989	2024-05-30 16:23:26.5	0	1	1390
5990	2024-05-30 16:23:26.5	0	1	1391
5991	2024-05-30 16:23:26.5	0	1	1392
5992	2024-05-30 16:23:26.5	0	1	1393
5993	2024-05-30 16:23:26.5	0	1	1394
5994	2023-12-08 09:34:39.468098	0	1	1414
5995	2024-05-30 16:23:26.5	0	1	1415
5996	2024-05-30 16:23:26.5	0	1	1416
5997	2024-05-30 16:23:26.5	0	1	1417
5998	2024-05-30 16:23:26.5	0	1	1418
5999	2024-05-30 16:23:26.5	0	1	1419
6000	2023-12-08 09:34:39.468098	0	1	1420
6001	2024-05-30 16:23:26.5	0	1	1421
6002	2024-05-30 16:23:26.5	0	1	1422
6003	2024-05-30 16:23:26.5	0	1	1423
6004	2024-05-30 16:23:26.5	0	1	1424
6005	2024-05-30 16:23:26.5	0	1	1425
6006	2024-05-30 16:23:26.5	11800	1	1431
6007	2024-05-30 16:23:26.5	0	1	1434
6008	2024-05-30 16:23:26.5	0	1	1441
6009	2024-05-30 16:23:27	11400	1	1459
6010	2024-05-30 16:23:27	11400	1	1460
6011	2024-05-30 16:23:27	11400	1	1461
6012	2024-05-30 16:23:27	11400	1	1462
6013	2024-05-31 04:32:27	11400	1	1463
6014	2024-05-30 16:23:27	0	1	1480
6015	2024-05-30 16:23:27	0	1	1481
6016	2024-05-30 16:23:27	0	1	1482
6017	2024-05-30 16:23:27	0	1	1483
6018	2024-05-30 16:23:27	0	1	1484
6019	2024-05-30 16:23:27	0	1	1485
6020	2024-05-30 16:23:27	0	1	1502
6021	2024-05-30 16:23:27	0	1	1503
6022	2024-05-30 16:23:27	0	1	1504
6023	2024-05-30 16:23:27	0	1	1505
6024	2024-05-30 16:23:27	0	1	1506
6025	2024-05-30 16:23:27	0	1	1507
6026	2024-05-30 16:23:27	0	1	1508
6027	2024-05-30 16:23:27	0	1	1509
6028	2024-05-30 16:23:27	0	1	1510
6029	2024-05-30 16:23:27	0	1	1511
6030	2024-05-30 16:23:27	0	1	1517
6031	2024-05-30 16:23:27	0	1	1519
6032	2024-05-30 16:23:27	0	1	1525
6033	2023-12-08 09:34:39.468098	0	1	1541
6034	2023-12-08 09:34:39.468098	0	1	1542
6035	2023-12-08 09:34:39.468098	0	1	1543
6036	2023-12-08 09:34:39.468098	0	1	1544
6037	2023-12-08 09:34:39.468098	0	1	1545
6038	2023-12-08 09:34:39.468098	0	1	1546
6039	2023-12-08 09:34:39.468098	0	1	1547
6040	2023-12-08 09:34:39.468098	0	1	1548
6041	2023-12-08 09:34:39.468098	0	1	1557
6042	2023-12-08 09:34:39.468098	0	1	1558
6043	2023-12-08 09:34:39.468098	0	1	1559
6044	2023-12-08 09:34:39.468098	0	1	1560
6045	2023-12-08 09:34:39.468098	0	1	1573
6046	2023-12-08 09:34:39.468098	0	1	1574
6047	2023-12-08 09:34:39.468098	0	1	1575
6048	2023-12-08 09:34:39.468098	0	1	1576
6049	2023-12-08 09:34:39.468098	0	1	1577
6050	2023-12-08 09:34:39.468098	0	1	1578
6051	2023-12-08 09:34:39.468098	0	1	1579
6052	2023-12-08 09:34:39.468098	0	1	1580
6053	2023-12-08 09:34:39.468098	0	1	1583
6054	2023-12-08 09:34:39.468098	0	1	1584
6055	2023-12-08 09:34:39.468098	0	1	1601
6056	2023-12-08 09:34:39.468098	0	1	1602
6057	2023-12-08 09:34:39.468098	0	1	1603
6058	2023-12-08 09:34:39.468098	0	1	1604
6059	2023-12-08 09:34:39.468098	0	1	1605
6060	2023-12-08 09:34:39.468098	0	1	1606
6061	2023-12-08 09:34:39.468098	0	1	1607
6062	2023-12-08 09:34:39.468098	0	1	1608
6063	2023-12-08 09:34:39.468098	0	1	1617
6064	2023-12-08 09:34:39.468098	0	1	1618
6065	2023-12-08 09:34:39.468098	0	1	1619
6066	2023-12-08 09:34:39.468098	0	1	1620
6067	2023-12-08 09:34:39.468098	0	1	1633
6068	2023-12-08 09:34:39.468098	0	1	1634
6069	2023-12-08 09:34:39.468098	0	1	1635
6070	2023-12-08 09:34:39.468098	0	1	1636
6071	2023-12-08 09:34:39.468098	0	1	1637
6072	2023-12-08 09:34:39.468098	0	1	1638
6073	2023-12-08 09:34:39.468098	0	1	1639
6074	2023-12-08 09:34:39.468098	0	1	1640
6075	2023-12-08 09:34:39.468098	0	1	1642
6076	2023-12-08 09:34:39.468098	0	1	1643
6077	2023-12-08 09:34:39.468098	0	1	1644
6078	2023-12-08 09:34:39.468098	0	1	1661
6079	2023-12-08 09:34:39.468098	0	1	1662
6080	2023-12-08 09:34:39.468098	0	1	1663
6081	2023-12-08 09:34:39.468098	0	1	1664
6082	2023-12-08 09:34:39.468098	0	1	1665
6083	2023-12-08 09:34:39.468098	0	1	1666
6084	2023-12-08 09:34:39.468098	0	1	1667
6085	2023-12-08 09:34:39.468098	0	1	1668
6086	2023-12-08 09:34:39.468098	0	1	1677
6087	2023-12-08 09:34:39.468098	0	1	1678
6088	2023-12-08 09:34:39.468098	0	1	1679
6089	2023-12-08 09:34:39.468098	0	1	1680
6090	2023-12-08 09:34:39.468098	0	1	1693
6091	2023-12-08 09:34:39.468098	0	1	1694
6092	2023-12-08 09:34:39.468098	0	1	1695
6093	2023-12-08 09:34:39.468098	0	1	1696
6094	2023-12-08 09:34:39.468098	0	1	1697
6095	2023-12-08 09:34:39.468098	0	1	1698
6096	2023-12-08 09:34:39.468098	0	1	1699
6097	2023-12-08 09:34:39.468098	0	1	1700
6098	2023-12-08 09:34:39.468098	0	1	1703
6099	2023-12-08 09:34:39.468098	0	1	1704
6100	2023-12-08 09:34:39.468098	0	1	1721
6101	2023-12-08 09:34:39.468098	0	1	1722
6102	2023-12-08 09:34:39.468098	0	1	1723
6103	2023-12-08 09:34:39.468098	0	1	1724
6104	2023-12-08 09:34:39.468098	0	1	1725
6105	2023-12-08 09:34:39.468098	0	1	1726
6106	2023-12-08 09:34:39.468098	0	1	1727
6107	2023-12-08 09:34:39.468098	0	1	1728
6108	2023-12-08 09:34:39.468098	0	1	1737
6109	2023-12-08 09:34:39.468098	0	1	1738
6110	2023-12-08 09:34:39.468098	0	1	1739
6111	2023-12-08 09:34:39.468098	0	1	1740
6112	2023-12-08 09:34:39.468098	0	1	1753
6113	2023-12-08 09:34:39.468098	0	1	1754
6114	2023-12-08 09:34:39.468098	0	1	1755
6115	2023-12-08 09:34:39.468098	0	1	1756
6116	2023-12-08 09:34:39.468098	0	1	1757
6117	2023-12-08 09:34:39.468098	0	1	1758
6118	2023-12-08 09:34:39.468098	0	1	1759
6119	2023-12-08 09:34:39.468098	0	1	1760
6120	2023-12-08 09:34:39.468098	0	1	1761
6121	2023-12-08 09:34:39.468098	0	1	1762
6122	2023-12-08 09:34:39.468098	0	1	1763
6123	2023-12-08 09:34:39.468098	0	1	1764
6124	2023-12-08 09:34:39.468098	0	1	1781
6125	2023-12-08 09:34:39.468098	0	1	1782
6126	2023-12-08 09:34:39.468098	0	1	1783
6127	2023-12-08 09:34:39.468098	0	1	1784
6128	2023-12-08 09:34:39.468098	0	1	1785
6129	2023-12-08 09:34:39.468098	0	1	1786
6130	2023-12-08 09:34:39.468098	0	1	1787
6131	2023-12-08 09:34:39.468098	0	1	1788
6132	2023-12-08 09:34:39.468098	0	1	1797
6133	2023-12-08 09:34:39.468098	0	1	1798
6134	2023-12-08 09:34:39.468098	0	1	1799
6135	2023-12-08 09:34:39.468098	0	1	1800
6136	2023-12-08 09:34:39.468098	0	1	1813
6137	2023-12-08 09:34:39.468098	0	1	1814
6138	2023-12-08 09:34:39.468098	0	1	1815
6139	2023-12-08 09:34:39.468098	0	1	1816
6140	2023-12-08 09:34:39.468098	0	1	1817
6141	2023-12-08 09:34:39.468098	0	1	1818
6142	2023-12-08 09:34:39.468098	0	1	1819
6143	2023-12-08 09:34:39.468098	0	1	1820
6144	2023-12-08 09:34:39.468098	0	1	1823
6145	2023-12-08 09:34:39.468098	0	1	1824
6146	2023-12-08 09:34:39.468098	0	1	1841
6147	2023-12-08 09:34:39.468098	0	1	1842
6148	2023-12-08 09:34:39.468098	0	1	1843
6149	2023-12-08 09:34:39.468098	0	1	1844
6150	2023-12-08 09:34:39.468098	0	1	1845
6151	2023-12-08 09:34:39.468098	0	1	1846
6152	2023-12-08 09:34:39.468098	0	1	1847
6153	2023-12-08 09:34:39.468098	0	1	1848
6154	2023-12-08 09:34:39.468098	0	1	1857
6155	2023-12-08 09:34:39.468098	0	1	1858
6156	2023-12-08 09:34:39.468098	0	1	1859
6157	2023-12-08 09:34:39.468098	0	1	1860
6158	2023-12-08 09:34:39.468098	0	1	1873
6159	2023-12-08 09:34:39.468098	0	1	1874
6160	2023-12-08 09:34:39.468098	0	1	1875
6161	2023-12-08 09:34:39.468098	0	1	1876
6162	2023-12-08 09:34:39.468098	0	1	1877
6163	2023-12-08 09:34:39.468098	0	1	1878
6164	2023-12-08 09:34:39.468098	0	1	1879
6165	2023-12-08 09:34:39.468098	0	1	1880
6166	2023-12-08 09:34:39.468098	0	1	1883
6167	2023-12-08 09:34:39.468098	0	1	1884
6168	2023-12-08 09:34:39.468098	0	1	1901
6169	2023-12-08 09:34:39.468098	0	1	1902
6170	2023-12-08 09:34:39.468098	0	1	1903
6171	2023-12-08 09:34:39.468098	0	1	1904
6172	2023-12-08 09:34:39.468098	0	1	1905
6173	2023-12-08 09:34:39.468098	0	1	1906
6174	2023-12-08 09:34:39.468098	0	1	1907
6175	2023-12-08 09:34:39.468098	0	1	1908
6176	2023-12-08 09:34:39.468098	0	1	1917
6177	2023-12-08 09:34:39.468098	0	1	1918
6178	2023-12-08 09:34:39.468098	0	1	1919
6179	2023-12-08 09:34:39.468098	0	1	1920
6180	2023-12-08 09:34:39.468098	0	1	1933
6181	2023-12-08 09:34:39.468098	0	1	1934
6182	2023-12-08 09:34:39.468098	0	1	1935
6183	2023-12-08 09:34:39.468098	0	1	1936
6184	2023-12-08 09:34:39.468098	0	1	1937
6185	2023-12-08 09:34:39.468098	0	1	1938
6186	2023-12-08 09:34:39.468098	0	1	1939
6187	2023-12-08 09:34:39.468098	0	1	1940
6188	2023-12-08 09:34:39.468098	0	1	1942
6189	2023-12-08 09:34:39.468098	0	1	1943
6190	2023-12-08 09:34:39.468098	0	1	1944
6191	2024-05-31 04:47:27.5	11400	1	1965
6192	2024-05-31 04:47:27.5	11400	1	1966
6193	2024-05-31 04:56:28	11400	1	1967
6194	2024-05-31 04:56:28	11400	1	1968
6195	2024-05-31 04:52:28	11400	1	1970
6196	2024-05-30 16:23:27	11600	1	1971
6197	2024-05-31 04:52:28	11400	1	1972
6198	2024-05-30 16:23:27	0	1	1998
6199	2024-05-30 16:23:27	0	1	1999
6200	2024-05-30 16:23:27	0	1	2000
6201	2024-05-30 16:23:27	0	1	2001
6202	2024-05-30 16:23:27	0	1	2002
6203	2024-05-31 04:53:28	11800	1	2004
6204	2024-05-30 16:23:27	0	1	2005
6205	2024-05-31 04:53:28	11800	1	2006
6206	2024-05-30 16:23:27	0	1	2032
6207	2024-05-30 16:23:27	0	1	2033
6208	2024-05-30 16:23:27	0	1	2034
6209	2024-05-30 16:23:27	0	1	2035
6210	2024-05-30 16:23:27	0	1	2037
6211	2024-05-30 16:23:27	0	1	2038
6212	2024-05-30 16:23:27	0	1	2039
6213	2024-05-30 16:23:27	0	1	2040
6214	2024-05-30 16:23:27	0	1	2041
6215	2024-05-30 16:23:27	0	1	2042
6216	2024-05-30 16:23:27	0	1	2043
6217	2024-05-30 16:23:27	0	1	2045
6218	2024-05-30 16:23:27	0	1	2046
6219	2024-05-30 16:23:27	0	1	2047
6220	2024-05-30 16:23:27	0	1	2055
6221	2024-05-30 16:23:27	0	1	2058
6222	2024-05-30 16:23:27	0	1	2067
6223	2024-05-30 17:38:28.5	11800	1	2090
6224	2024-05-30 17:38:28.5	11800	1	2091
6225	2024-05-31 04:56:28.5	11400	1	2092
6226	2024-05-31 04:56:28.5	11400	1	2093
6227	2024-05-31 04:55:28	11200	1	2094
6228	2024-05-31 04:38:28.5	8800	1	2095
6229	2024-05-31 04:55:28	11200	1	2096
6230	2024-05-31 04:38:28.5	8800	1	2097
6231	2024-05-30 16:23:28	0	1	2123
6232	2024-05-30 16:23:28	0	1	2124
6233	2024-05-30 16:23:28	0	1	2125
6234	2024-05-30 16:23:28	0	1	2126
6235	2024-05-30 16:23:28	0	1	2127
6236	2024-05-30 16:23:28	0	1	2128
6237	2024-05-30 16:23:28	12000	1	2129
6238	2024-05-30 16:23:28	0	1	2130
6239	2024-05-30 16:23:28	12000	1	2131
6240	2024-05-30 16:23:28	0	1	2157
6241	2024-05-30 16:23:28	0	1	2158
6242	2024-05-30 16:23:28	0	1	2159
6243	2024-05-30 16:23:28	0	1	2160
6244	2024-05-30 16:23:28	0	1	2161
6245	2024-05-30 16:23:28	0	1	2162
6246	2024-05-30 16:23:28	0	1	2163
6247	2024-05-30 16:23:28	0	1	2164
6248	2024-05-30 16:23:28	0	1	2165
6249	2024-05-30 16:23:28	0	1	2166
6250	2024-05-30 16:23:28	0	1	2167
6251	2024-05-30 16:23:28	0	1	2168
6252	2024-05-30 16:23:28	0	1	2169
6253	2024-05-30 16:23:28	0	1	2170
6254	2024-05-30 16:23:28	0	1	2171
6255	2024-05-30 16:23:28	0	1	2172
6256	2024-05-30 16:23:28	11400	1	2178
6257	2024-05-30 16:23:28	11400	1	2180
6258	2024-05-30 16:23:28	0	1	2183
6259	2024-05-30 16:23:28	7400	1	2188
6260	2024-05-30 16:23:28	0	1	2192
6261	2024-05-30 18:17:28	11200	1	2215
6262	2024-05-30 18:17:28	11200	1	2216
6263	2024-05-31 04:56:27.5	11400	1	2217
6264	2024-05-31 04:56:27.5	11400	1	2218
6265	2024-05-30 16:23:27.5	11200	1	2219
6266	2024-05-30 16:23:27.5	9000	1	2220
6267	2024-05-30 16:23:27.5	11200	1	2221
6268	2024-05-30 16:23:27.5	9000	1	2222
6269	2024-05-30 16:23:27.5	0	1	2248
6270	2024-05-30 16:23:27.5	0	1	2249
6271	2024-05-30 16:23:27.5	0	1	2250
6272	2024-05-30 16:23:27.5	0	1	2251
6273	2024-05-30 16:23:27.5	0	1	2252
6274	2024-05-30 16:23:27.5	0	1	2253
6275	2024-05-30 16:23:27.5	12000	1	2254
6276	2024-05-30 16:23:27.5	0	1	2255
6277	2024-05-30 16:23:27.5	12000	1	2256
6278	2024-05-30 16:23:27.5	0	1	2282
6279	2024-05-30 16:23:27.5	0	1	2283
6280	2024-05-30 16:23:27.5	0	1	2284
6281	2024-05-30 16:23:27.5	0	1	2285
6282	2024-05-30 16:23:27.5	0	1	2286
6283	2024-05-30 16:23:27.5	0	1	2287
6284	2024-05-30 16:23:27.5	0	1	2288
6285	2024-05-30 16:23:27.5	0	1	2289
6286	2024-05-30 16:23:27.5	0	1	2290
6287	2024-05-30 16:23:27.5	0	1	2291
6288	2024-05-30 16:23:27.5	0	1	2292
6289	2024-05-30 16:23:27.5	0	1	2293
6290	2024-05-30 16:23:27.5	0	1	2294
6291	2024-05-30 16:23:27.5	0	1	2295
6292	2024-05-30 16:23:27.5	0	1	2296
6293	2024-05-30 16:23:27.5	0	1	2297
6294	2024-05-30 16:23:27.5	11800	1	2303
6295	2024-05-30 16:23:27.5	11800	1	2305
6296	2024-05-30 16:22:53.5	0	1	2308
6297	2024-05-30 16:23:27.5	7400	1	2313
6298	2024-05-30 16:23:27.5	0	1	2317
6299	2024-05-30 16:23:27.5	11200	1	2340
6300	2024-05-30 16:23:27.5	11200	1	2341
6301	2024-05-30 16:23:27.5	11400	1	2342
6302	2024-05-30 16:23:27.5	11400	1	2343
6303	2024-05-30 16:23:27.5	11600	1	2344
6304	2024-05-30 16:23:27.5	9000	1	2345
6305	2024-05-30 16:23:27.5	11600	1	2346
6306	2024-05-30 16:23:27.5	9000	1	2347
6307	2024-05-30 16:23:27.5	0	1	2373
6308	2024-05-30 16:23:27.5	0	1	2374
6309	2024-05-30 16:23:27.5	0	1	2375
6310	2024-05-30 16:23:27.5	0	1	2376
6311	2024-05-30 16:23:27.5	0	1	2377
6312	2024-05-30 16:23:27.5	0	1	2378
6313	2024-05-31 04:56:28	11800	1	2379
6314	2024-05-30 16:23:27.5	0	1	2380
6315	2024-05-31 04:56:28	11800	1	2381
6316	2024-05-30 16:23:27.5	0	1	2407
6317	2024-05-30 16:23:27.5	0	1	2408
6318	2024-05-30 16:23:27.5	0	1	2409
6319	2024-05-30 16:23:27.5	0	1	2410
6320	2024-05-30 16:23:27.5	0	1	2411
6321	2024-05-30 16:23:27.5	0	1	2412
6322	2024-05-30 16:23:27.5	0	1	2413
6323	2024-05-30 16:23:27.5	0	1	2414
6324	2024-05-30 16:23:27.5	0	1	2415
6325	2024-05-30 16:23:27.5	0	1	2416
6326	2024-05-30 16:23:27.5	0	1	2417
6327	2024-05-30 16:23:27.5	0	1	2418
6328	2024-05-30 16:23:27.5	0	1	2419
6329	2024-05-30 16:23:27.5	0	1	2420
6330	2024-05-30 16:23:27.5	0	1	2421
6331	2024-05-30 16:23:27.5	0	1	2422
6332	2024-05-31 04:56:28	11400	1	2428
6333	2024-05-31 04:56:28	11400	1	2430
6334	2024-05-30 16:22:54	0	1	2433
6335	2024-05-30 16:23:27.5	0	1	2442
6336	2024-05-31 04:05:09	11000	1	2465
6337	2024-05-31 04:05:09	11000	1	2466
6338	2024-05-30 16:23:09	11400	1	2467
6339	2024-05-30 16:23:09	11400	1	2468
6340	2024-05-30 16:23:09	11000	1	2469
6341	2024-05-31 04:07:09.5	9000	1	2470
6342	2024-05-30 16:23:09	11000	1	2471
6343	2024-05-31 04:07:09.5	9000	1	2472
6344	2024-05-30 16:23:09	0	1	2498
6345	2024-05-30 16:23:09	0	1	2499
6346	2024-05-30 16:23:09	0	1	2500
6347	2024-05-30 16:23:09	0	1	2501
6348	2024-05-30 16:23:09	0	1	2502
6349	2024-05-30 16:23:09	0	1	2503
6350	2024-05-30 16:23:09	12000	1	2504
6351	2024-05-30 16:23:09	0	1	2505
6352	2024-05-30 16:23:09	12000	1	2506
6353	2024-05-30 16:23:09	0	1	2532
6354	2024-05-30 16:23:09	0	1	2533
6355	2024-05-30 16:23:09	0	1	2534
6356	2024-05-30 16:23:09	0	1	2535
6357	2024-05-30 16:23:09	0	1	2536
6358	2024-05-30 16:23:09	0	1	2537
6359	2024-05-30 16:23:09	0	1	2538
6360	2024-05-30 16:23:09	0	1	2539
6361	2024-05-30 16:23:09	0	1	2540
6362	2024-05-30 16:23:09	0	1	2541
6363	2024-05-30 16:23:09	0	1	2542
6364	2024-05-30 16:23:09	0	1	2543
6365	2024-05-30 16:23:09	0	1	2544
6366	2024-05-30 16:23:09	0	1	2545
6367	2024-05-30 16:23:09	0	1	2546
6368	2024-05-30 16:23:09	0	1	2547
6369	2024-05-31 04:07:09.5	11600	1	2553
6370	2024-05-31 04:07:09.5	11600	1	2555
6371	2024-05-30 16:23:09	0	1	2558
6372	2024-05-30 16:23:09	0	1	2567
6373	2024-05-30 16:23:27.5	11400	1	2590
6374	2024-05-30 16:23:27.5	11400	1	2591
6375	2024-05-30 16:23:27.5	11600	1	2592
6376	2024-05-30 16:23:27.5	11600	1	2593
6377	2024-05-31 03:22:28	9000	1	2595
6378	2024-05-31 01:43:28	11600	1	2596
6379	2024-05-31 03:22:28	9000	1	2597
6380	2024-05-30 16:23:27.5	0	1	2623
6381	2024-05-30 16:23:27.5	0	1	2624
6382	2024-05-30 16:23:27.5	0	1	2625
6383	2024-05-30 16:23:27.5	0	1	2626
6384	2024-05-30 16:23:27.5	0	1	2627
6385	2024-05-30 16:23:27.5	12000	1	2629
6386	2024-05-30 16:23:27.5	0	1	2630
6387	2024-05-30 16:23:27.5	12000	1	2631
6388	2024-05-30 16:23:27.5	0	1	2657
6389	2024-05-30 16:23:27.5	0	1	2658
6390	2024-05-30 16:23:27.5	0	1	2659
6391	2024-05-30 16:23:27.5	0	1	2660
6392	2024-05-30 16:23:27.5	0	1	2662
6393	2024-05-30 16:23:27.5	0	1	2663
6394	2024-05-30 16:23:27.5	0	1	2664
6395	2024-05-30 16:23:27.5	0	1	2665
6396	2024-05-30 16:23:27.5	0	1	2666
6397	2024-05-30 16:23:27.5	0	1	2667
6398	2024-05-30 16:23:27.5	0	1	2668
6399	2024-05-30 16:23:27.5	0	1	2670
6400	2024-05-30 16:23:27.5	0	1	2671
6401	2024-05-30 16:23:27.5	0	1	2672
6402	2024-05-30 16:23:27.5	0	1	2680
6403	2024-05-30 16:22:54	0	1	2683
6404	2024-05-30 16:23:27.5	0	1	2692
6405	2024-05-30 16:23:27.5	11200	1	2715
6406	2024-05-30 16:23:27.5	11200	1	2716
6407	2024-05-30 16:23:27.5	11400	1	2717
6408	2024-05-30 16:23:27.5	11400	1	2718
6409	2024-05-31 03:44:28	9000	1	2720
6410	2024-05-31 04:43:28	11600	1	2721
6411	2024-05-31 03:44:28	9000	1	2722
6412	2024-05-30 16:23:27.5	0	1	2748
6413	2024-05-30 16:23:27.5	0	1	2749
6414	2024-05-30 16:23:27.5	0	1	2750
6415	2024-05-30 16:23:27.5	0	1	2751
6416	2024-05-30 16:23:27.5	0	1	2752
6417	2024-05-30 16:23:27.5	11800	1	2754
6418	2024-05-30 16:23:27.5	0	1	2755
6419	2024-05-30 16:23:27.5	11800	1	2756
6420	2024-05-30 16:23:27.5	0	1	2782
6421	2024-05-30 16:23:27.5	0	1	2783
6422	2024-05-30 16:23:27.5	0	1	2784
6423	2024-05-30 16:23:27.5	0	1	2785
6424	2024-05-30 16:23:27.5	0	1	2787
6425	2024-05-30 16:23:27.5	0	1	2788
6426	2024-05-30 16:23:27.5	0	1	2789
6427	2024-05-30 16:23:27.5	0	1	2790
6428	2024-05-30 16:23:27.5	0	1	2791
6429	2024-05-30 16:23:27.5	0	1	2792
6430	2024-05-30 16:23:27.5	0	1	2793
6431	2024-05-30 16:23:27.5	0	1	2795
6432	2024-05-30 16:23:27.5	0	1	2796
6433	2024-05-30 16:23:27.5	0	1	2797
6434	2024-05-30 16:23:27.5	0	1	2805
6435	2024-05-30 16:22:54	0	1	2808
6436	2024-05-30 16:23:27.5	0	1	2817
6437	2024-05-31 04:43:39.5	11200	1	2840
6438	2024-05-31 04:43:39.5	11200	1	2841
6439	2024-05-31 04:56:40	11200	1	2842
6440	2024-05-31 04:56:40	11200	1	2843
6441	2024-05-31 04:43:39.5	9000	1	2845
6442	2024-05-31 04:54:40	11800	1	2846
6443	2024-05-31 04:43:39.5	9000	1	2847
6444	2024-05-31 04:43:39.5	0	1	2873
6445	2024-05-31 04:43:39.5	0	1	2874
6446	2024-05-31 04:43:39.5	0	1	2875
6447	2024-05-31 04:43:39.5	0	1	2876
6448	2024-05-31 04:43:39.5	0	1	2877
6449	2024-05-31 04:43:39.5	12000	1	2879
6450	2024-05-31 04:43:39.5	0	1	2880
6451	2024-05-31 04:43:39.5	12000	1	2881
6452	2024-05-31 04:43:39.5	0	1	2907
6453	2024-05-31 04:43:39.5	0	1	2908
6454	2024-05-31 04:43:39.5	0	1	2909
6455	2024-05-31 04:43:39.5	0	1	2910
6456	2024-05-31 04:43:39.5	0	1	2912
6457	2024-05-31 04:43:39.5	0	1	2913
6458	2024-05-31 04:43:39.5	0	1	2914
6459	2024-05-31 04:43:39.5	0	1	2915
6460	2024-05-31 04:43:39.5	0	1	2916
6461	2024-05-31 04:43:39.5	0	1	2917
6462	2024-05-31 04:43:39.5	0	1	2918
6463	2024-05-31 04:43:39.5	0	1	2920
6464	2024-05-31 04:43:39.5	0	1	2921
6465	2024-05-31 04:43:39.5	0	1	2922
6466	2024-05-31 04:43:39.5	0	1	2930
6467	2024-05-31 04:43:39.5	0	1	2933
6468	2024-05-31 04:43:39.5	0	1	2942
6469	2024-05-30 16:23:27.5	11600	1	2965
6470	2024-05-30 16:23:27.5	11600	1	2966
6471	2024-05-30 16:23:27.5	11400	1	2967
6472	2024-05-30 16:23:27.5	11400	1	2968
6473	2024-05-30 16:23:27.5	9000	1	2970
6474	2024-05-30 16:23:27.5	11600	1	2971
6475	2024-05-30 16:23:27.5	9000	1	2972
6476	2024-05-30 16:22:54	0	1	2998
6477	2024-05-30 16:22:54	0	1	2999
6478	2024-05-30 16:22:54	0	1	3000
6479	2024-05-30 16:22:54	0	1	3001
6480	2024-05-30 16:22:54	0	1	3002
6481	2024-05-30 16:22:54	0	1	3004
6482	2024-05-30 16:22:54	0	1	3005
6483	2024-05-30 16:22:54	0	1	3006
6484	2024-05-30 16:23:27.5	0	1	3032
6485	2024-05-30 16:23:27.5	0	1	3033
6486	2024-05-30 16:23:27.5	0	1	3034
6487	2024-05-30 16:23:27.5	0	1	3035
6488	2024-05-30 16:23:27.5	0	1	3037
6489	2024-05-30 16:23:27.5	0	1	3038
6490	2024-05-30 16:23:27.5	0	1	3039
6491	2024-05-30 16:23:27.5	0	1	3040
6492	2024-05-30 16:23:27.5	0	1	3041
6493	2024-05-30 16:23:27.5	0	1	3042
6494	2024-05-30 16:23:27.5	0	1	3043
6495	2024-05-30 16:23:27.5	0	1	3045
6496	2024-05-30 16:23:27.5	0	1	3046
6497	2024-05-30 16:23:27.5	0	1	3047
6498	2024-05-30 16:23:27.5	0	1	3055
6499	2024-05-30 16:22:54	0	1	3058
6500	2024-05-30 16:23:27.5	0	1	3067
6501	2024-05-30 16:23:28	11000	1	3090
6502	2024-05-30 16:23:28	11000	1	3091
6503	2024-05-31 04:56:28.5	11200	1	3092
6504	2024-05-31 04:56:28.5	11200	1	3093
6505	2024-05-30 16:23:28	8800	1	3095
6506	2024-05-31 03:27:28.5	11600	1	3096
6507	2024-05-30 16:23:28	8800	1	3097
6508	2024-05-30 16:23:28	0	1	3123
6509	2024-05-30 16:23:28	0	1	3124
6510	2024-05-30 16:23:28	0	1	3125
6511	2024-05-30 16:23:28	0	1	3126
6512	2024-05-30 16:23:28	0	1	3127
6513	2024-05-30 16:23:28	12000	1	3129
6514	2024-05-30 16:23:28	0	1	3130
6515	2024-05-30 16:23:28	12000	1	3131
6516	2024-05-30 16:23:28	0	1	3157
6517	2024-05-30 16:23:28	0	1	3158
6518	2024-05-30 16:23:28	0	1	3159
6519	2024-05-30 16:23:28	0	1	3160
6520	2024-05-30 16:23:28	0	1	3162
6521	2024-05-30 16:23:28	0	1	3163
6522	2024-05-30 16:23:28	0	1	3164
6523	2024-05-30 16:23:28	0	1	3165
6524	2024-05-30 16:23:28	0	1	3166
6525	2024-05-30 16:23:28	0	1	3167
6526	2024-05-30 16:23:28	0	1	3168
6527	2024-05-30 16:23:28	0	1	3170
6528	2024-05-30 16:23:28	0	1	3171
6529	2024-05-30 16:23:28	0	1	3172
6530	2024-05-30 16:23:28	0	1	3180
6531	2024-05-30 16:23:28	0	1	3183
6532	2024-05-30 16:23:28	0	1	3192
6533	2024-05-31 00:27:28	11200	1	3215
6534	2024-05-31 00:27:28	11200	1	3216
6535	2024-05-31 04:55:28	11600	1	3217
6536	2024-05-31 04:55:28	11600	1	3218
6537	2024-05-31 04:43:28	8800	1	3220
6538	2024-05-30 16:23:27.5	11600	1	3221
6539	2024-05-31 04:43:28	8800	1	3222
6540	2024-05-30 16:22:53.5	0	1	3248
6541	2024-05-30 16:22:53.5	0	1	3249
6542	2024-05-30 16:22:53.5	0	1	3250
6543	2024-05-30 16:22:53.5	0	1	3251
6544	2024-05-30 16:22:53.5	0	1	3252
6545	2024-05-30 16:22:53.5	0	1	3254
6546	2024-05-30 16:22:53.5	0	1	3255
6547	2024-05-30 16:22:53.5	0	1	3256
6548	2024-05-30 16:23:27.5	0	1	3282
6549	2024-05-30 16:23:27.5	0	1	3283
6550	2024-05-30 16:23:27.5	0	1	3284
6551	2024-05-30 16:23:27.5	0	1	3285
6552	2024-05-30 16:23:27.5	0	1	3287
6553	2024-05-30 16:23:27.5	0	1	3288
6554	2024-05-30 16:23:27.5	0	1	3289
6555	2024-05-30 16:23:27.5	0	1	3290
6556	2024-05-30 16:23:27.5	0	1	3291
6557	2024-05-30 16:23:27.5	0	1	3292
6558	2024-05-30 16:23:27.5	0	1	3293
6559	2024-05-30 16:23:27.5	0	1	3295
6560	2024-05-30 16:23:27.5	0	1	3296
6561	2024-05-30 16:23:27.5	0	1	3297
6562	2024-05-30 16:23:27.5	0	1	3305
6563	2024-05-30 16:22:53.5	0	1	3308
6564	2024-05-30 16:23:27.5	0	1	3317
6565	2024-05-30 16:23:27.5	10800	1	3340
6566	2024-05-30 16:23:27.5	10800	1	3341
6567	2024-05-30 16:23:27.5	11000	1	3342
6568	2024-05-30 16:23:27.5	11000	1	3343
6569	2024-05-30 16:23:27.5	8800	1	3345
6570	2024-05-31 04:32:28	11600	1	3346
6571	2024-05-30 16:23:27.5	8800	1	3347
6572	2024-05-30 16:22:53.5	0	1	3373
6573	2024-05-30 16:22:53.5	0	1	3374
6574	2024-05-30 16:22:53.5	0	1	3375
6575	2024-05-30 16:22:53.5	0	1	3376
6576	2024-05-30 16:22:53.5	0	1	3377
6577	2024-05-30 16:22:53.5	0	1	3379
6578	2024-05-30 16:22:53.5	0	1	3380
6579	2024-05-30 16:22:53.5	0	1	3381
6580	2024-05-30 16:23:27.5	0	1	3407
6581	2024-05-30 16:23:27.5	0	1	3408
6582	2024-05-30 16:23:27.5	0	1	3409
6583	2024-05-30 16:23:27.5	0	1	3410
6584	2024-05-30 16:23:27.5	0	1	3412
6585	2024-05-30 16:23:27.5	0	1	3413
6586	2024-05-30 16:23:27.5	0	1	3414
6587	2024-05-30 16:23:27.5	0	1	3415
6588	2024-05-30 16:23:27.5	0	1	3416
6589	2024-05-30 16:23:27.5	0	1	3417
6590	2024-05-30 16:23:27.5	0	1	3418
6591	2024-05-30 16:23:27.5	0	1	3420
6592	2024-05-30 16:23:27.5	0	1	3421
6593	2024-05-30 16:23:27.5	0	1	3422
6594	2024-05-30 16:23:27.5	0	1	3430
6595	2024-05-30 16:22:53.5	0	1	3433
6596	2024-05-30 16:23:27.5	0	1	3442
6597	2024-05-30 19:24:27.5	11000	1	3465
6598	2024-05-30 19:24:27.5	11000	1	3466
6599	2024-05-31 04:35:28	11400	1	3467
6600	2024-05-31 04:35:28	11400	1	3468
6601	2024-05-30 22:14:27.5	9000	1	3470
6602	2024-05-31 04:42:28	11400	1	3471
6603	2024-05-30 22:14:27.5	9000	1	3472
6604	2024-05-30 16:22:53.5	0	1	3498
6605	2024-05-30 16:22:53.5	0	1	3499
6606	2024-05-30 16:22:53.5	0	1	3500
6607	2024-05-30 16:22:53.5	0	1	3501
6608	2024-05-30 16:22:53.5	0	1	3502
6609	2024-05-31 03:09:27.5	11600	1	3504
6610	2024-05-30 16:22:53.5	0	1	3505
6611	2024-05-31 03:09:27.5	11600	1	3506
6612	2024-05-30 16:23:27.5	0	1	3532
6613	2024-05-30 16:23:27.5	0	1	3533
6614	2024-05-30 16:23:27.5	0	1	3534
6615	2024-05-30 16:23:27.5	0	1	3535
6616	2024-05-30 16:23:27.5	0	1	3537
6617	2024-05-30 16:23:27.5	0	1	3538
6618	2024-05-30 16:23:27.5	0	1	3539
6619	2024-05-30 16:23:27.5	0	1	3540
6620	2024-05-30 16:23:27.5	0	1	3541
6621	2024-05-30 16:23:27.5	0	1	3542
6622	2024-05-30 16:23:27.5	0	1	3543
6623	2024-05-30 16:23:27.5	0	1	3545
6624	2024-05-30 16:23:27.5	0	1	3546
6625	2024-05-30 16:23:27.5	0	1	3547
6626	2024-05-30 16:23:27.5	0	1	3555
6627	2024-05-30 16:22:53.5	0	1	3558
6628	2024-05-30 16:23:27.5	0	1	3567
6629	2024-05-30 16:23:27.5	11600	1	3590
6630	2024-05-30 16:23:27.5	11600	1	3591
6631	2024-05-30 16:23:27.5	11400	1	3592
6632	2024-05-30 16:23:27.5	11400	1	3593
6633	2024-05-30 16:23:27.5	8800	1	3595
6634	2024-05-30 16:23:27.5	11600	1	3596
6635	2024-05-30 16:23:27.5	8800	1	3597
6636	2024-05-30 16:22:53.5	0	1	3623
6637	2024-05-30 16:22:53.5	0	1	3624
6638	2024-05-30 16:22:53.5	0	1	3625
6639	2024-05-30 16:22:53.5	0	1	3626
6640	2024-05-30 16:22:53.5	0	1	3627
6641	2024-05-30 16:22:53.5	0	1	3629
6642	2024-05-30 16:22:53.5	0	1	3630
6643	2024-05-30 16:22:53.5	0	1	3631
6644	2024-05-30 16:23:27.5	0	1	3657
6645	2024-05-30 16:23:27.5	0	1	3658
6646	2024-05-30 16:23:27.5	0	1	3659
6647	2024-05-30 16:23:27.5	0	1	3660
6648	2024-05-30 16:23:27.5	0	1	3662
6649	2024-05-30 16:23:27.5	0	1	3663
6650	2024-05-30 16:23:27.5	0	1	3664
6651	2024-05-30 16:23:27.5	0	1	3665
6652	2024-05-30 16:23:27.5	0	1	3666
6653	2024-05-30 16:23:27.5	0	1	3667
6654	2024-05-30 16:23:27.5	0	1	3668
6655	2024-05-30 16:23:27.5	0	1	3670
6656	2024-05-30 16:23:27.5	0	1	3671
6657	2024-05-30 16:23:27.5	0	1	3672
6658	2024-05-30 16:23:27.5	0	1	3680
6659	2024-05-30 16:22:53.5	0	1	3683
6660	2024-05-30 16:23:27.5	0	1	3692
6661	2024-05-31 04:54:32.5	11400	1	3715
6662	2024-05-31 04:54:32.5	11400	1	3716
6663	2024-05-31 04:54:32.5	11400	1	3717
6664	2024-05-31 04:54:32.5	11400	1	3718
6665	2024-05-31 04:54:32.5	9000	1	3720
6666	2024-05-31 04:54:32.5	11400	1	3721
6667	2024-05-31 04:54:32.5	9000	1	3722
6668	2024-05-31 04:54:32.5	0	1	3748
6669	2024-05-31 04:54:32.5	0	1	3749
6670	2024-05-31 04:54:32.5	0	1	3750
6671	2024-05-31 04:54:32.5	0	1	3751
6672	2024-05-31 04:54:32.5	0	1	3752
6673	2024-05-31 04:54:32.5	12000	1	3754
6674	2024-05-31 04:54:32.5	0	1	3755
6675	2024-05-31 04:54:32.5	12000	1	3756
6676	2024-05-31 04:54:32.5	0	1	3782
6677	2024-05-31 04:54:32.5	0	1	3783
6678	2024-05-31 04:54:32.5	0	1	3784
6679	2024-05-31 04:54:32.5	0	1	3785
6680	2024-05-31 04:54:32.5	0	1	3787
6681	2024-05-31 04:54:32.5	0	1	3788
6682	2024-05-31 04:54:32.5	0	1	3789
6683	2024-05-31 04:54:32.5	0	1	3790
6684	2024-05-31 04:54:32.5	0	1	3791
6685	2024-05-31 04:54:32.5	0	1	3792
6686	2024-05-31 04:54:32.5	0	1	3793
6687	2024-05-31 04:54:32.5	0	1	3795
6688	2024-05-31 04:54:32.5	0	1	3796
6689	2024-05-31 04:54:32.5	0	1	3797
6690	2024-05-31 04:54:32.5	0	1	3805
6691	2024-05-31 04:54:32.5	0	1	3808
6692	2024-05-31 04:54:32.5	0	1	3817
6693	2024-05-30 16:23:27.5	11200	1	3840
6694	2024-05-30 16:23:27.5	11200	1	3841
6695	2024-05-30 16:23:27.5	11200	1	3842
6696	2024-05-30 16:23:27.5	11200	1	3843
6697	2024-05-30 16:23:27.5	9000	1	3845
6698	2024-05-30 16:23:27.5	11400	1	3846
6699	2024-05-30 16:23:27.5	9000	1	3847
6700	2024-05-30 16:22:53.5	0	1	3873
6701	2024-05-30 16:22:53.5	0	1	3874
6702	2024-05-30 16:22:53.5	0	1	3875
6703	2024-05-30 16:22:53.5	0	1	3876
6704	2024-05-30 16:22:53.5	0	1	3877
6705	2024-05-30 16:22:53.5	0	1	3879
6706	2024-05-30 16:22:53.5	0	1	3880
6707	2024-05-30 16:22:53.5	0	1	3881
6708	2024-05-30 16:23:27.5	0	1	3907
6709	2024-05-30 16:23:27.5	0	1	3908
6710	2024-05-30 16:23:27.5	0	1	3909
6711	2024-05-30 16:23:27.5	0	1	3910
6712	2024-05-30 16:23:27.5	0	1	3912
6713	2024-05-30 16:23:27.5	0	1	3913
6714	2024-05-30 16:23:27.5	0	1	3914
6715	2024-05-30 16:23:27.5	0	1	3915
6716	2024-05-30 16:23:27.5	0	1	3916
6717	2024-05-30 16:23:27.5	0	1	3917
6718	2024-05-30 16:23:27.5	0	1	3918
6719	2024-05-30 16:23:27.5	0	1	3920
6720	2024-05-30 16:23:27.5	0	1	3921
6721	2024-05-30 16:23:27.5	0	1	3922
6722	2024-05-30 16:23:27.5	0	1	3930
6723	2024-05-30 16:22:53.5	0	1	3933
6724	2024-05-30 16:23:27.5	0	1	3942
6725	2024-05-31 04:54:27.5	11400	1	3965
6726	2024-05-31 04:54:27.5	11400	1	3966
6727	2024-05-30 16:23:27.5	11400	1	3967
6728	2024-05-30 16:23:27.5	11400	1	3968
6729	2024-05-30 16:23:27.5	8800	1	3970
6730	2024-05-30 16:23:27.5	11400	1	3971
6731	2024-05-30 16:23:27.5	8800	1	3972
6732	2024-05-30 16:22:54	0	1	3998
6733	2024-05-30 16:22:54	0	1	3999
6734	2024-05-30 16:22:54	0	1	4000
6735	2024-05-30 16:22:54	0	1	4001
6736	2024-05-30 16:22:54	0	1	4002
6737	2024-05-30 16:22:54	0	1	4004
6738	2024-05-30 16:22:54	0	1	4005
6739	2024-05-30 16:22:54	0	1	4006
6740	2024-05-30 16:23:27.5	0	1	4032
6741	2024-05-30 16:23:27.5	0	1	4033
6742	2024-05-30 16:23:27.5	0	1	4034
6743	2024-05-30 16:23:27.5	0	1	4035
6744	2024-05-30 16:23:27.5	0	1	4037
6745	2024-05-30 16:23:27.5	0	1	4038
6746	2024-05-30 16:23:27.5	0	1	4039
6747	2024-05-30 16:23:27.5	0	1	4040
6748	2024-05-30 16:23:27.5	0	1	4041
6749	2024-05-30 16:23:27.5	0	1	4042
6750	2024-05-30 16:23:27.5	0	1	4043
6751	2024-05-30 16:23:27.5	0	1	4045
6752	2024-05-30 16:23:27.5	0	1	4046
6753	2024-05-30 16:23:27.5	0	1	4047
6754	2024-05-30 16:23:27.5	0	1	4055
6755	2024-05-30 16:22:54	0	1	4058
6756	2024-05-30 16:23:27.5	7200	1	4061
6757	2024-05-30 16:23:27.5	0	1	4067
6758	2023-12-08 09:34:39.468098	0	1	4088
6759	2023-12-08 09:34:39.468098	0	1	4089
6760	2024-05-31 00:27:27.5	11200	1	4090
6761	2024-05-31 00:27:27.5	11200	1	4091
6762	2024-05-30 16:23:27.5	11400	1	4092
6763	2024-05-30 16:23:27.5	11400	1	4093
6764	2024-05-30 16:23:27.5	11400	1	4095
6765	2024-05-30 16:23:27.5	11600	1	4096
6766	2024-05-30 16:23:27.5	11400	1	4097
6767	2024-05-30 16:22:53.5	0	1	4123
6768	2024-05-30 16:22:53.5	0	1	4124
6769	2024-05-30 16:22:53.5	0	1	4125
6770	2024-05-30 16:22:53.5	0	1	4126
6771	2024-05-30 16:22:53.5	0	1	4127
6772	2024-05-30 16:22:53.5	0	1	4129
6773	2024-05-30 16:22:53.5	0	1	4130
6774	2024-05-30 16:22:53.5	0	1	4131
6775	2024-05-30 16:23:27.5	0	1	4157
6776	2024-05-30 16:23:27.5	0	1	4158
6777	2024-05-30 16:23:27.5	0	1	4159
6778	2024-05-30 16:23:27.5	0	1	4160
6779	2024-05-30 16:23:27.5	0	1	4162
6780	2024-05-30 16:23:27.5	0	1	4163
6781	2024-05-30 16:23:27.5	0	1	4164
6782	2024-05-30 16:23:27.5	0	1	4165
6783	2024-05-30 16:23:27.5	0	1	4166
6784	2024-05-30 16:23:27.5	0	1	4167
6785	2024-05-30 16:23:27.5	0	1	4168
6786	2024-05-30 16:23:27.5	0	1	4170
6787	2024-05-30 16:23:27.5	0	1	4171
6788	2024-05-30 16:23:27.5	0	1	4172
6789	2024-05-30 16:23:27.5	6000	1	4173
6790	2024-05-30 16:23:27.5	0	1	4180
6791	2024-05-30 16:22:53.5	0	1	4183
6792	2024-05-30 16:23:27.5	0	1	4192
6793	2023-12-08 09:34:39.468098	0	1	4215
6794	2023-12-08 09:34:39.468098	0	1	4216
6795	2023-12-08 09:34:39.468098	0	1	4217
6796	2023-12-08 09:34:39.468098	0	1	4218
6797	2023-12-08 09:34:39.468098	0	1	4219
6798	2023-12-08 09:34:39.468098	0	1	4220
6799	2023-12-08 09:34:39.468098	0	1	4221
6800	2023-12-08 09:34:39.468098	0	1	4222
6801	2023-12-08 09:34:39.468098	0	1	4248
6802	2023-12-08 09:34:39.468098	0	1	4249
6803	2023-12-08 09:34:39.468098	0	1	4250
6804	2023-12-08 09:34:39.468098	0	1	4251
6805	2023-12-08 09:34:39.468098	0	1	4252
6806	2023-12-08 09:34:39.468098	0	1	4253
6807	2023-12-08 09:34:39.468098	0	1	4254
6808	2023-12-08 09:34:39.468098	0	1	4255
6809	2023-12-08 09:34:39.468098	0	1	4256
6810	2023-12-08 09:34:39.468098	0	1	4282
6811	2023-12-08 09:34:39.468098	0	1	4283
6812	2023-12-08 09:34:39.468098	0	1	4284
6813	2023-12-08 09:34:39.468098	0	1	4285
6814	2023-12-08 09:34:39.468098	0	1	4286
6815	2023-12-08 09:34:39.468098	0	1	4287
6816	2023-12-08 09:34:39.468098	0	1	4288
6817	2023-12-08 09:34:39.468098	0	1	4289
6818	2023-12-08 09:34:39.468098	0	1	4290
6819	2023-12-08 09:34:39.468098	0	1	4291
6820	2023-12-08 09:34:39.468098	0	1	4292
6821	2023-12-08 09:34:39.468098	0	1	4293
6822	2023-12-08 09:34:39.468098	0	1	4294
6823	2023-12-08 09:34:39.468098	0	1	4295
6824	2023-12-08 09:34:39.468098	0	1	4296
6825	2023-12-08 09:34:39.468098	0	1	4297
6826	2023-12-08 09:34:39.468098	0	1	4303
6827	2023-12-08 09:34:39.468098	0	1	4304
6828	2023-12-08 09:34:39.468098	0	1	4305
6829	2023-12-08 09:34:39.468098	0	1	4306
6830	2023-12-08 09:34:39.468098	0	1	4307
6831	2023-12-08 09:34:39.468098	0	1	4308
6832	2023-12-08 09:34:39.468098	0	1	4309
6833	2023-12-08 09:34:39.468098	0	1	4310
6834	2023-12-08 09:34:39.468098	0	1	4311
6835	2023-12-08 09:34:39.468098	0	1	4312
6836	2023-12-08 09:34:39.468098	0	1	4313
6837	2023-12-08 09:34:39.468098	0	1	4314
6838	2023-12-08 09:34:39.468098	0	1	4315
6839	2023-12-08 09:34:39.468098	0	1	4316
6840	2023-12-08 09:34:39.468098	0	1	4317
6841	2023-12-08 09:34:39.468098	0	1	4340
6842	2023-12-08 09:34:39.468098	0	1	4341
6843	2023-12-08 09:34:39.468098	0	1	4342
6844	2023-12-08 09:34:39.468098	0	1	4343
6845	2023-12-08 09:34:39.468098	0	1	4344
6846	2023-12-08 09:34:39.468098	0	1	4345
6847	2023-12-08 09:34:39.468098	0	1	4346
6848	2023-12-08 09:34:39.468098	0	1	4347
6849	2023-12-08 09:34:39.468098	0	1	4373
6850	2023-12-08 09:34:39.468098	0	1	4374
6851	2023-12-08 09:34:39.468098	0	1	4375
6852	2023-12-08 09:34:39.468098	0	1	4376
6853	2023-12-08 09:34:39.468098	0	1	4377
6854	2023-12-08 09:34:39.468098	0	1	4378
6855	2023-12-08 09:34:39.468098	0	1	4379
6856	2023-12-08 09:34:39.468098	0	1	4380
6857	2023-12-08 09:34:39.468098	0	1	4381
6858	2023-12-08 09:34:39.468098	0	1	4407
6859	2023-12-08 09:34:39.468098	0	1	4408
6860	2023-12-08 09:34:39.468098	0	1	4409
6861	2023-12-08 09:34:39.468098	0	1	4410
6862	2023-12-08 09:34:39.468098	0	1	4411
6863	2023-12-08 09:34:39.468098	0	1	4412
6864	2023-12-08 09:34:39.468098	0	1	4413
6865	2023-12-08 09:34:39.468098	0	1	4414
6866	2023-12-08 09:34:39.468098	0	1	4415
6867	2023-12-08 09:34:39.468098	0	1	4416
6868	2023-12-08 09:34:39.468098	0	1	4417
6869	2023-12-08 09:34:39.468098	0	1	4418
6870	2023-12-08 09:34:39.468098	0	1	4419
6871	2023-12-08 09:34:39.468098	0	1	4420
6872	2023-12-08 09:34:39.468098	0	1	4421
6873	2023-12-08 09:34:39.468098	0	1	4422
6874	2023-12-08 09:34:39.468098	0	1	4428
6875	2023-12-08 09:34:39.468098	0	1	4429
6876	2023-12-08 09:34:39.468098	0	1	4430
6877	2023-12-08 09:34:39.468098	0	1	4431
6878	2023-12-08 09:34:39.468098	0	1	4432
6879	2023-12-08 09:34:39.468098	0	1	4433
6880	2023-12-08 09:34:39.468098	0	1	4434
6881	2023-12-08 09:34:39.468098	0	1	4435
6882	2023-12-08 09:34:39.468098	0	1	4436
6883	2023-12-08 09:34:39.468098	0	1	4437
6884	2023-12-08 09:34:39.468098	0	1	4438
6885	2023-12-08 09:34:39.468098	0	1	4439
6886	2023-12-08 09:34:39.468098	0	1	4440
6887	2023-12-08 09:34:39.468098	0	1	4441
6888	2023-12-08 09:34:39.468098	0	1	4442
6889	2023-12-08 09:34:39.468098	0	1	4465
6890	2023-12-08 09:34:39.468098	0	1	4466
6891	2023-12-08 09:34:39.468098	0	1	4467
6892	2023-12-08 09:34:39.468098	0	1	4468
6893	2023-12-08 09:34:39.468098	0	1	4469
6894	2023-12-08 09:34:39.468098	0	1	4470
6895	2023-12-08 09:34:39.468098	0	1	4471
6896	2023-12-08 09:34:39.468098	0	1	4472
6897	2023-12-08 09:34:39.468098	0	1	4498
6898	2023-12-08 09:34:39.468098	0	1	4499
6899	2023-12-08 09:34:39.468098	0	1	4500
6900	2023-12-08 09:34:39.468098	0	1	4501
6901	2023-12-08 09:34:39.468098	0	1	4502
6902	2023-12-08 09:34:39.468098	0	1	4503
6903	2023-12-08 09:34:39.468098	0	1	4504
6904	2023-12-08 09:34:39.468098	0	1	4505
6905	2023-12-08 09:34:39.468098	0	1	4506
6906	2023-12-08 09:34:39.468098	0	1	4532
6907	2023-12-08 09:34:39.468098	0	1	4533
6908	2023-12-08 09:34:39.468098	0	1	4534
6909	2023-12-08 09:34:39.468098	0	1	4535
6910	2023-12-08 09:34:39.468098	0	1	4536
6911	2023-12-08 09:34:39.468098	0	1	4537
6912	2023-12-08 09:34:39.468098	0	1	4538
6913	2023-12-08 09:34:39.468098	0	1	4539
6914	2023-12-08 09:34:39.468098	0	1	4540
6915	2023-12-08 09:34:39.468098	0	1	4541
6916	2023-12-08 09:34:39.468098	0	1	4542
6917	2023-12-08 09:34:39.468098	0	1	4543
6918	2023-12-08 09:34:39.468098	0	1	4544
6919	2023-12-08 09:34:39.468098	0	1	4545
6920	2023-12-08 09:34:39.468098	0	1	4546
6921	2023-12-08 09:34:39.468098	0	1	4547
6922	2023-12-08 09:34:39.468098	0	1	4553
6923	2023-12-08 09:34:39.468098	0	1	4554
6924	2023-12-08 09:34:39.468098	0	1	4555
6925	2023-12-08 09:34:39.468098	0	1	4556
6926	2023-12-08 09:34:39.468098	0	1	4557
6927	2023-12-08 09:34:39.468098	0	1	4558
6928	2023-12-08 09:34:39.468098	0	1	4559
6929	2023-12-08 09:34:39.468098	0	1	4560
6930	2023-12-08 09:34:39.468098	0	1	4561
6931	2023-12-08 09:34:39.468098	0	1	4562
6932	2023-12-08 09:34:39.468098	0	1	4563
6933	2023-12-08 09:34:39.468098	0	1	4564
6934	2023-12-08 09:34:39.468098	0	1	4565
6935	2023-12-08 09:34:39.468098	0	1	4566
6936	2023-12-08 09:34:39.468098	0	1	4567
6937	2023-12-08 09:34:39.468098	0	1	4590
6938	2023-12-08 09:34:39.468098	0	1	4591
6939	2023-12-08 09:34:39.468098	0	1	4592
6940	2023-12-08 09:34:39.468098	0	1	4593
6941	2023-12-08 09:34:39.468098	0	1	4594
6942	2023-12-08 09:34:39.468098	0	1	4595
6943	2023-12-08 09:34:39.468098	0	1	4596
6944	2023-12-08 09:34:39.468098	0	1	4597
6945	2023-12-08 09:34:39.468098	0	1	4623
6946	2023-12-08 09:34:39.468098	0	1	4624
6947	2023-12-08 09:34:39.468098	0	1	4625
6948	2023-12-08 09:34:39.468098	0	1	4626
6949	2023-12-08 09:34:39.468098	0	1	4627
6950	2023-12-08 09:34:39.468098	0	1	4628
6951	2023-12-08 09:34:39.468098	0	1	4629
6952	2023-12-08 09:34:39.468098	0	1	4630
6953	2023-12-08 09:34:39.468098	0	1	4631
6954	2023-12-08 09:34:39.468098	0	1	4657
6955	2023-12-08 09:34:39.468098	0	1	4658
6956	2023-12-08 09:34:39.468098	0	1	4659
6957	2023-12-08 09:34:39.468098	0	1	4660
6958	2023-12-08 09:34:39.468098	0	1	4661
6959	2023-12-08 09:34:39.468098	0	1	4662
6960	2023-12-08 09:34:39.468098	0	1	4663
6961	2023-12-08 09:34:39.468098	0	1	4664
6962	2023-12-08 09:34:39.468098	0	1	4665
6963	2023-12-08 09:34:39.468098	0	1	4666
6964	2023-12-08 09:34:39.468098	0	1	4667
6965	2023-12-08 09:34:39.468098	0	1	4668
6966	2023-12-08 09:34:39.468098	0	1	4669
6967	2023-12-08 09:34:39.468098	0	1	4670
6968	2023-12-08 09:34:39.468098	0	1	4671
6969	2023-12-08 09:34:39.468098	0	1	4672
6970	2023-12-08 09:34:39.468098	0	1	4678
6971	2023-12-08 09:34:39.468098	0	1	4679
6972	2023-12-08 09:34:39.468098	0	1	4680
6973	2023-12-08 09:34:39.468098	0	1	4681
6974	2023-12-08 09:34:39.468098	0	1	4682
6975	2023-12-08 09:34:39.468098	0	1	4683
6976	2023-12-08 09:34:39.468098	0	1	4684
6977	2023-12-08 09:34:39.468098	0	1	4685
6978	2023-12-08 09:34:39.468098	0	1	4686
6979	2023-12-08 09:34:39.468098	0	1	4687
6980	2023-12-08 09:34:39.468098	0	1	4688
6981	2023-12-08 09:34:39.468098	0	1	4689
6982	2023-12-08 09:34:39.468098	0	1	4690
6983	2023-12-08 09:34:39.468098	0	1	4691
6984	2023-12-08 09:34:39.468098	0	1	4692
6985	2024-05-30 16:23:27.5	11400	1	4715
6986	2024-05-30 16:23:27.5	11400	1	4716
6987	2024-05-30 16:23:27.5	11400	1	4717
6988	2024-05-30 16:23:27.5	11400	1	4718
6989	2024-05-30 16:23:27.5	8800	1	4720
6990	2024-05-30 16:23:27.5	9000	1	4721
6991	2024-05-30 16:23:27.5	8800	1	4722
6992	2024-05-30 16:22:53.5	0	1	4748
6993	2024-05-30 16:22:53.5	0	1	4749
6994	2024-05-30 16:22:53.5	0	1	4750
6995	2024-05-30 16:22:53.5	0	1	4751
6996	2024-05-30 16:22:53.5	0	1	4752
6997	2024-05-31 04:56:27.5	12000	1	4754
6998	2024-05-30 16:22:53.5	0	1	4755
6999	2024-05-31 04:56:27.5	12000	1	4756
7000	2024-05-30 16:23:27.5	0	1	4782
7001	2024-05-30 16:23:27.5	0	1	4783
7002	2024-05-30 16:23:27.5	0	1	4784
7003	2024-05-30 16:23:27.5	0	1	4785
7004	2024-05-30 16:23:27.5	0	1	4787
7005	2024-05-30 16:23:27.5	0	1	4788
7006	2024-05-30 16:23:27.5	0	1	4789
7007	2024-05-30 16:23:27.5	0	1	4790
7008	2024-05-30 16:23:27.5	0	1	4791
7009	2024-05-30 16:23:27.5	0	1	4792
7010	2024-05-30 16:23:27.5	0	1	4793
7011	2024-05-30 16:23:27.5	0	1	4795
7012	2024-05-30 16:23:27.5	0	1	4796
7013	2024-05-30 16:23:27.5	0	1	4797
7014	2024-05-30 16:23:27.5	0	1	4805
7015	2024-05-30 16:22:53.5	0	1	4808
7016	2024-05-30 16:23:27.5	0	1	4817
7017	2024-05-31 04:55:26	11200	1	4840
7018	2024-05-31 04:55:26	11200	1	4841
7019	2024-05-31 03:58:26	11400	1	4842
7020	2024-05-31 03:58:26	11400	1	4843
7021	2024-05-30 16:23:26	11200	1	4844
7022	2023-12-08 09:34:39.468098	0	1	4856
7023	2024-04-29 02:34:27	0	1	4873
7024	2024-05-30 16:23:26	0	1	4874
7025	2024-05-30 16:23:26	0	1	4875
7026	2024-05-30 16:23:26	0	1	4876
7027	2024-05-30 16:23:26	0	1	4877
7028	2024-05-30 16:23:26	0	1	4878
7029	2024-04-29 02:34:27	0	1	4906
7030	2024-05-30 16:23:26	0	1	4907
7031	2024-05-30 16:23:26	0	1	4908
7032	2024-05-30 16:23:26	0	1	4909
7033	2024-05-30 16:23:26	0	1	4910
7034	2024-05-30 16:23:26	0	1	4911
7035	2024-05-30 16:23:26	0	1	4915
7036	2024-05-30 16:23:26	0	1	4916
7037	2024-05-30 16:23:26	0	1	4917
7038	2024-05-30 16:23:26	0	1	4918
7039	2024-05-30 16:23:26	0	1	4919
7040	2024-04-29 02:34:27	0	1	4923
7041	2024-05-30 16:23:26	0	1	4928
7042	2024-04-29 02:34:27	0	1	4932
7043	2024-04-29 02:34:27	0	1	4933
7044	2024-05-30 16:23:26	0	1	4934
7045	2024-05-30 16:23:26	0	1	4935
7046	2024-05-30 16:23:26	0	1	4936
7047	2024-05-30 16:23:26	0	1	4937
7048	2024-05-30 16:23:26	0	1	4938
7049	2024-04-29 02:34:27	0	1	4942
7050	2024-04-29 02:34:27	0	1	4943
7051	2024-04-29 02:34:27	0	1	4952
7052	2023-12-08 09:34:39.468098	0	1	4962
7053	2023-12-08 09:34:39.468098	0	1	4963
7054	2023-12-08 09:34:39.468098	0	1	4964
7055	2023-12-08 09:34:39.468098	0	1	4965
7056	2023-12-08 09:34:39.468098	0	1	4966
7057	2023-12-08 09:34:39.468098	0	1	4972
7058	2023-12-08 09:34:39.468098	0	1	4983
7059	2023-12-08 09:34:39.468098	0	1	4984
7060	2023-12-08 09:34:39.468098	0	1	4985
7061	2023-12-08 09:34:39.468098	0	1	4986
7062	2023-12-08 09:34:39.468098	0	1	4987
7063	2023-12-08 09:34:39.468098	0	1	4988
7064	2024-04-29 02:34:27	0	1	5004
7065	2023-12-08 09:34:39.468098	0	1	5005
7066	2023-12-08 09:34:39.468098	0	1	5006
7067	2023-12-08 09:34:39.468098	0	1	5007
7068	2023-12-08 09:34:39.468098	0	1	5008
7069	2023-12-08 09:34:39.468098	0	1	5009
7070	2023-12-08 09:34:39.468098	0	1	5010
7071	2023-12-08 09:34:39.468098	0	1	5011
7072	2023-12-08 09:34:39.468098	0	1	5012
7073	2023-12-08 09:34:39.468098	0	1	5013
7074	2023-12-08 09:34:39.468098	0	1	5014
7075	2023-12-08 09:34:39.468098	0	1	5015
7076	2023-12-08 09:34:39.468098	0	1	5020
7077	2023-12-08 09:34:39.468098	0	1	5021
7078	2023-12-08 09:34:39.468098	0	1	5022
7079	2023-12-08 09:34:39.468098	0	1	5023
7080	2023-12-08 09:34:39.468098	0	1	5024
7081	2023-12-08 09:34:39.468098	0	1	5025
7082	2023-12-08 09:34:39.468098	0	1	5026
7083	2023-12-08 09:34:39.468098	0	1	5027
7084	2023-12-08 09:34:39.468098	0	1	5028
7085	2023-12-08 09:34:39.468098	0	1	5029
7086	2024-04-29 02:34:27	0	1	5035
7087	2024-05-30 16:23:27.5	11200	1	5049
7088	2024-05-30 16:23:27.5	11200	1	5050
7089	2024-05-30 16:23:27.5	11200	1	5051
7090	2024-05-31 04:39:27.5	11400	1	5052
7091	2024-05-30 16:23:27.5	11200	1	5053
7092	2024-05-31 04:39:27.5	11400	1	5054
7093	2024-05-31 04:39:27.5	11400	1	5055
7094	2024-05-30 16:22:53.5	0	1	5087
7095	2024-05-30 16:22:53.5	0	1	5088
7096	2024-05-30 16:22:53.5	0	1	5089
7097	2024-05-30 16:22:53.5	0	1	5090
7098	2024-05-30 16:22:53.5	0	1	5091
7099	2024-05-30 16:22:53.5	0	1	5092
7100	2024-05-30 16:22:53.5	0	1	5093
7101	2024-05-30 16:23:27.5	0	1	5124
7102	2024-05-30 16:23:27.5	0	1	5125
7103	2024-05-30 16:23:27.5	0	1	5126
7104	2024-05-30 16:23:27.5	0	1	5127
7105	2024-05-30 16:23:27.5	0	1	5128
7106	2024-05-30 16:23:27.5	0	1	5129
7107	2024-05-30 16:23:27.5	0	1	5130
7108	2024-05-30 16:23:27.5	0	1	5133
7109	2024-05-30 16:23:27.5	0	1	5134
7110	2024-05-30 16:23:27.5	0	1	5135
7111	2024-05-30 16:23:27.5	0	1	5136
7112	2024-05-30 16:23:27.5	0	1	5137
7113	2024-05-30 16:23:27.5	0	1	5138
7114	2024-05-30 16:23:27.5	0	1	5139
7115	2024-05-30 16:23:27.5	0	1	5143
7116	2024-05-30 16:23:27.5	0	1	5144
7117	2024-05-30 16:23:27.5	0	1	5145
7118	2024-05-30 16:23:27.5	0	1	5146
7119	2024-05-30 16:23:27.5	0	1	5147
7120	2024-05-30 16:23:27.5	0	1	5148
7121	2024-05-30 16:23:27.5	0	1	5149
7122	2023-12-08 09:34:39.468098	0	1	5152
7123	2023-12-08 09:34:39.468098	0	1	5153
7124	2023-12-08 09:34:39.468098	0	1	5163
7125	2023-12-08 09:34:39.468098	0	1	5164
7126	2024-05-30 16:23:27	11600	1	5185
7127	2024-05-30 16:23:27	11600	1	5186
7128	2024-05-30 16:23:27	11600	1	5187
7129	2024-05-30 16:23:27	11800	1	5188
7130	2024-05-30 16:23:27	11800	1	5189
7131	2024-05-30 16:23:27	11800	1	5190
7132	2024-05-30 16:23:27	0	1	5211
7133	2024-05-30 16:23:27	0	1	5212
7134	2024-05-30 16:23:27	0	1	5213
7135	2024-05-30 16:23:27	0	1	5214
7136	2024-05-30 16:23:27	0	1	5215
7137	2024-05-30 16:23:27	0	1	5216
7138	2024-05-30 16:23:27	0	1	5236
7139	2024-05-30 16:23:27	0	1	5237
7140	2024-05-30 16:23:27	0	1	5238
7141	2024-05-30 16:23:27	0	1	5239
7142	2024-05-30 16:23:27	0	1	5240
7143	2024-05-30 16:23:27	0	1	5241
7144	2024-05-30 16:23:27	0	1	5242
7145	2024-05-30 16:23:27	0	1	5243
7146	2024-05-30 16:23:27	0	1	5244
7147	2024-05-30 16:23:27	0	1	5245
7148	2024-05-30 16:23:27	0	1	5246
7149	2024-05-30 16:23:27	0	1	5247
7150	2024-05-30 16:23:27	0	1	5249
7151	2024-05-30 16:23:27	0	1	5250
7152	2024-05-30 16:23:27	0	1	5251
7153	2024-05-30 16:23:27	0	1	5252
7154	2024-05-30 16:23:27	0	1	5253
7155	2024-05-30 16:23:27	0	1	5254
7156	2023-12-08 09:34:39.468098	0	1	5255
7157	2023-12-08 09:34:39.468098	0	1	5256
7158	2023-12-08 09:34:39.468098	0	1	5263
7159	2023-12-08 09:34:39.468098	0	1	5264
7160	2023-12-08 09:34:39.468098	0	1	5279
7161	2023-12-08 09:34:39.468098	0	1	5280
7162	2023-12-08 09:34:39.468098	0	1	5281
7163	2023-12-08 09:34:39.468098	0	1	5282
7164	2023-12-08 09:34:39.468098	0	1	5283
7165	2023-12-08 09:34:39.468098	0	1	5284
7166	2023-12-08 09:34:39.468098	0	1	5291
7167	2023-12-08 09:34:39.468098	0	1	5292
7168	2023-12-08 09:34:39.468098	0	1	5293
7169	2023-12-08 09:34:39.468098	0	1	5303
7170	2023-12-08 09:34:39.468098	0	1	5304
7171	2023-12-08 09:34:39.468098	0	1	5305
7172	2023-12-08 09:34:39.468098	0	1	5306
7173	2023-12-08 09:34:39.468098	0	1	5307
7174	2023-12-08 09:34:39.468098	0	1	5308
7175	2023-12-08 09:34:39.468098	0	1	5309
7176	2023-12-08 09:34:39.468098	0	1	5310
7177	2023-12-08 09:34:39.468098	0	1	5311
7178	2023-12-08 09:34:39.468098	0	1	5325
7179	2023-12-08 09:34:39.468098	0	1	5326
7180	2023-12-08 09:34:39.468098	0	1	5327
7181	2023-12-08 09:34:39.468098	0	1	5328
7182	2023-12-08 09:34:39.468098	0	1	5329
7183	2023-12-08 09:34:39.468098	0	1	5330
7184	2023-12-08 09:34:39.468098	0	1	5337
7185	2023-12-08 09:34:39.468098	0	1	5338
7186	2023-12-08 09:34:39.468098	0	1	5339
7187	2023-12-08 09:34:39.468098	0	1	5349
7188	2023-12-08 09:34:39.468098	0	1	5350
7189	2023-12-08 09:34:39.468098	0	1	5351
7190	2023-12-08 09:34:39.468098	0	1	5352
7191	2023-12-08 09:34:39.468098	0	1	5353
7192	2023-12-08 09:34:39.468098	0	1	5354
7193	2023-12-08 09:34:39.468098	0	1	5355
7194	2023-12-08 09:34:39.468098	0	1	5356
7195	2023-12-08 09:34:39.468098	0	1	5357
7196	2023-12-08 09:34:39.468098	0	1	5371
7197	2023-12-08 09:34:39.468098	0	1	5372
7198	2023-12-08 09:34:39.468098	0	1	5373
7199	2023-12-08 09:34:39.468098	0	1	5374
7200	2023-12-08 09:34:39.468098	0	1	5375
7201	2023-12-08 09:34:39.468098	0	1	5376
7202	2023-12-08 09:34:39.468098	0	1	5383
7203	2023-12-08 09:34:39.468098	0	1	5384
7204	2023-12-08 09:34:39.468098	0	1	5385
7205	2023-12-08 09:34:39.468098	0	1	5395
7206	2023-12-08 09:34:39.468098	0	1	5396
7207	2023-12-08 09:34:39.468098	0	1	5397
7208	2023-12-08 09:34:39.468098	0	1	5398
7209	2023-12-08 09:34:39.468098	0	1	5399
7210	2023-12-08 09:34:39.468098	0	1	5400
7211	2023-12-08 09:34:39.468098	0	1	5401
7212	2023-12-08 09:34:39.468098	0	1	5403
7213	2023-12-08 09:34:39.468098	0	1	5417
7214	2023-12-08 09:34:39.468098	0	1	5418
7215	2023-12-08 09:34:39.468098	0	1	5419
7216	2023-12-08 09:34:39.468098	0	1	5420
7217	2023-12-08 09:34:39.468098	0	1	5421
7218	2023-12-08 09:34:39.468098	0	1	5422
7219	2023-12-08 09:34:39.468098	0	1	5429
7220	2023-12-08 09:34:39.468098	0	1	5430
7221	2023-12-08 09:34:39.468098	0	1	5431
7222	2023-12-08 09:34:39.468098	0	1	5441
7223	2023-12-08 09:34:39.468098	0	1	5442
7224	2023-12-08 09:34:39.468098	0	1	5443
7225	2023-12-08 09:34:39.468098	0	1	5444
7226	2023-12-08 09:34:39.468098	0	1	5445
7227	2023-12-08 09:34:39.468098	0	1	5446
7228	2023-12-08 09:34:39.468098	0	1	5447
7229	2023-12-08 09:34:39.468098	0	1	5449
7230	2023-12-08 09:34:39.468098	0	1	5463
7231	2023-12-08 09:34:39.468098	0	1	5464
7232	2023-12-08 09:34:39.468098	0	1	5465
7233	2023-12-08 09:34:39.468098	0	1	5466
7234	2023-12-08 09:34:39.468098	0	1	5467
7235	2023-12-08 09:34:39.468098	0	1	5468
7236	2023-12-08 09:34:39.468098	0	1	5475
7237	2023-12-08 09:34:39.468098	0	1	5476
7238	2023-12-08 09:34:39.468098	0	1	5477
7239	2023-12-08 09:34:39.468098	0	1	5487
7240	2023-12-08 09:34:39.468098	0	1	5488
7241	2023-12-08 09:34:39.468098	0	1	5489
7242	2023-12-08 09:34:39.468098	0	1	5490
7243	2023-12-08 09:34:39.468098	0	1	5491
7244	2023-12-08 09:34:39.468098	0	1	5492
7245	2023-12-08 09:34:39.468098	0	1	5493
7246	2023-12-08 09:34:39.468098	0	1	5495
7247	2024-05-30 16:23:27	11600	1	5514
7248	2024-05-30 16:23:27	11600	1	5515
7249	2024-05-30 16:23:27	11600	1	5516
7250	2024-05-30 23:45:27.5	11600	1	5517
7251	2024-05-30 23:45:27.5	11600	1	5518
7252	2024-05-30 23:45:27.5	11600	1	5519
7253	2024-05-30 16:23:27	0	1	5548
7254	2024-05-30 16:23:27	0	1	5549
7255	2024-05-30 16:23:27	0	1	5550
7256	2024-05-30 16:23:27	0	1	5551
7257	2024-05-30 16:23:27	0	1	5552
7258	2024-05-30 16:23:27	0	1	5553
7259	2024-05-30 16:23:27	0	1	5581
7260	2024-05-30 16:23:27	0	1	5582
7261	2024-05-30 16:23:27	0	1	5583
7262	2024-05-30 16:23:27	0	1	5584
7263	2024-05-30 16:23:27	0	1	5585
7264	2024-05-30 16:23:27	0	1	5586
7265	2024-05-30 16:23:27	0	1	5589
7266	2024-05-30 16:23:27	0	1	5590
7267	2024-05-30 16:23:27	0	1	5591
7268	2024-05-30 16:23:27	0	1	5592
7269	2024-05-30 16:23:27	0	1	5593
7270	2024-05-30 16:23:27	0	1	5594
7271	2024-05-30 16:23:27	0	1	5598
7272	2024-05-30 16:23:27	0	1	5599
7273	2024-05-30 16:23:27	0	1	5600
7274	2024-05-30 16:23:27	0	1	5601
7275	2024-05-30 16:23:27	0	1	5602
7276	2024-05-30 16:23:27	0	1	5603
7277	2023-12-08 09:34:39.468098	0	1	5606
7278	2023-12-08 09:34:39.468098	0	1	5607
7279	2023-12-08 09:34:39.468098	0	1	5616
7280	2023-12-08 09:34:39.468098	0	1	5617
7281	2024-05-30 16:23:27	11600	1	5634
7282	2024-05-30 16:23:27	9000	1	5635
7283	2024-05-30 16:23:27	9000	1	5636
7284	2023-12-08 09:34:39.468098	0	1	5637
7285	2023-12-08 09:34:39.468098	0	1	5638
7286	2023-12-08 09:34:39.468098	0	1	5639
7287	2024-05-30 16:23:27	0	1	5648
7288	2024-05-30 16:23:27	0	1	5649
7289	2024-05-30 16:23:27	0	1	5650
7290	2024-05-30 16:23:27	0	1	5661
7291	2024-05-30 16:23:27	0	1	5662
7292	2024-05-30 16:23:27	0	1	5663
7293	2024-05-30 16:23:27	0	1	5664
7294	2024-05-30 16:23:27	0	1	5665
7295	2024-05-30 16:23:27	0	1	5667
7296	2024-05-30 16:23:27	12000	1	5668
7297	2024-05-30 16:23:27	12000	1	5669
7298	2023-12-08 09:34:39.468098	0	1	5670
7299	2023-12-08 09:34:39.468098	0	1	5671
7300	2023-12-08 09:34:39.468098	0	1	5674
7301	2023-12-08 09:34:39.468098	0	1	5675
7302	2023-12-08 09:34:39.468098	0	1	5690
7303	2023-12-08 09:34:39.468098	0	1	5691
7304	2024-05-30 16:23:27.5	11200	1	5692
7305	2024-05-30 16:23:27.5	11200	1	5693
7306	2024-05-30 16:23:27.5	11400	1	5694
7307	2024-05-30 16:23:27.5	11400	1	5695
7308	2024-05-30 16:23:27.5	11200	1	5696
7309	2024-05-30 16:23:27.5	8800	1	5697
7310	2024-05-30 16:23:27.5	11200	1	5698
7311	2024-05-30 16:23:27.5	8800	1	5699
7312	2024-05-30 16:23:27.5	0	1	5725
7313	2024-05-30 16:23:27.5	0	1	5726
7314	2024-05-30 16:23:27.5	0	1	5727
7315	2024-05-30 16:23:27.5	0	1	5728
7316	2024-05-30 16:23:27.5	0	1	5729
7317	2024-05-30 16:23:27.5	0	1	5730
7318	2024-05-31 04:54:27.5	11800	1	5731
7319	2024-05-30 16:23:27.5	0	1	5732
7320	2024-05-31 04:54:27.5	11800	1	5733
7321	2024-05-30 16:23:27.5	0	1	5759
7322	2024-05-30 16:23:27.5	0	1	5760
7323	2024-05-30 16:23:27.5	0	1	5761
7324	2024-05-30 16:23:27.5	0	1	5762
7325	2024-05-30 16:23:27.5	0	1	5763
7326	2024-05-30 16:23:27.5	0	1	5764
7327	2024-05-30 16:23:27.5	0	1	5765
7328	2024-05-30 16:23:27.5	0	1	5766
7329	2024-05-30 16:23:27.5	0	1	5767
7330	2024-05-30 16:23:27.5	0	1	5768
7331	2024-05-30 16:23:27.5	0	1	5769
7332	2024-05-30 16:23:27.5	0	1	5770
7333	2024-05-30 16:23:27.5	0	1	5771
7334	2024-05-30 16:23:27.5	0	1	5772
7335	2024-05-30 16:23:27.5	0	1	5773
7336	2024-05-30 16:23:27.5	0	1	5774
7337	2024-05-30 16:23:27.5	11800	1	5780
7338	2024-05-30 16:23:27.5	11800	1	5782
7339	2024-05-30 16:23:27.5	0	1	5785
7340	2024-05-30 16:23:27.5	0	1	5794
7341	2024-05-30 16:23:27.5	11200	1	5817
7342	2024-05-30 16:23:27.5	11200	1	5818
7343	2024-05-30 16:23:27.5	11800	1	5819
7344	2024-05-30 16:23:27.5	11800	1	5820
7345	2024-05-30 16:23:27.5	11400	1	5821
7346	2024-05-30 16:23:27.5	8800	1	5822
7347	2024-05-30 16:23:27.5	11400	1	5823
7348	2024-05-30 16:23:27.5	8800	1	5824
7349	2024-05-30 16:23:27.5	0	1	5850
7350	2024-05-30 16:23:27.5	0	1	5851
7351	2024-05-30 16:23:27.5	0	1	5852
7352	2024-05-30 16:23:27.5	0	1	5853
7353	2024-05-30 16:23:27.5	0	1	5854
7354	2024-05-30 16:23:27.5	0	1	5855
7355	2024-05-30 16:23:27.5	12000	1	5856
7356	2024-05-30 16:23:27.5	0	1	5857
7357	2024-05-30 16:23:27.5	12000	1	5858
7358	2024-05-30 16:23:27.5	0	1	5884
7359	2024-05-30 16:23:27.5	0	1	5885
7360	2024-05-30 16:23:27.5	0	1	5886
7361	2024-05-30 16:23:27.5	0	1	5887
7362	2024-05-30 16:23:27.5	0	1	5888
7363	2024-05-30 16:23:27.5	0	1	5889
7364	2024-05-30 16:23:27.5	0	1	5890
7365	2024-05-30 16:23:27.5	0	1	5891
7366	2024-05-30 16:23:27.5	0	1	5892
7367	2024-05-30 16:23:27.5	0	1	5893
7368	2024-05-30 16:23:27.5	0	1	5894
7369	2024-05-30 16:23:27.5	0	1	5895
7370	2024-05-30 16:23:27.5	0	1	5896
7371	2024-05-30 16:23:27.5	0	1	5897
7372	2024-05-30 16:23:27.5	0	1	5898
7373	2024-05-30 16:23:27.5	0	1	5899
7374	2024-05-31 04:21:28	12000	1	5905
7375	2024-05-31 04:21:28	12000	1	5907
7376	2024-05-30 16:22:54	0	1	5910
7377	2024-05-30 16:23:27.5	0	1	5919
7378	2024-05-30 16:23:27.5	11000	1	5942
7379	2024-05-30 16:23:27.5	11000	1	5943
7380	2024-05-30 16:23:27.5	11800	1	5944
7381	2024-05-30 16:23:27.5	11800	1	5945
7382	2024-05-30 16:23:27.5	8800	1	5947
7383	2024-05-30 16:23:27.5	11800	1	5948
7384	2024-05-30 16:23:27.5	8800	1	5949
7385	2024-05-30 16:23:27.5	0	1	5975
7386	2024-05-30 16:23:27.5	0	1	5976
7387	2024-05-30 16:23:27.5	0	1	5977
7388	2024-05-30 16:23:27.5	0	1	5978
7389	2024-05-30 16:23:27.5	0	1	5979
7390	2024-05-30 16:23:27.5	11800	1	5981
7391	2024-05-30 16:23:27.5	0	1	5982
7392	2024-05-30 16:23:27.5	11800	1	5983
7393	2024-05-30 16:23:27.5	0	1	6009
7394	2024-05-30 16:23:27.5	0	1	6010
7395	2024-05-30 16:23:27.5	0	1	6011
7396	2024-05-30 16:23:27.5	0	1	6012
7397	2024-05-30 16:23:27.5	0	1	6014
7398	2024-05-30 16:23:27.5	0	1	6015
7399	2024-05-30 16:23:27.5	0	1	6016
7400	2024-05-30 16:23:27.5	0	1	6017
7401	2024-05-30 16:23:27.5	0	1	6018
7402	2024-05-30 16:23:27.5	0	1	6019
7403	2024-05-30 16:23:27.5	0	1	6020
7404	2024-05-30 16:23:27.5	0	1	6022
7405	2024-05-30 16:23:27.5	0	1	6023
7406	2024-05-30 16:23:27.5	0	1	6024
7407	2024-05-30 16:23:27.5	0	1	6032
7408	2024-05-30 16:22:53.5	0	1	6035
7409	2024-05-30 16:23:27.5	0	1	6044
7410	2024-05-30 16:23:27.5	11400	1	6067
7411	2024-05-30 16:23:27.5	11400	1	6068
7412	2024-05-30 16:23:27.5	11400	1	6069
7413	2024-05-30 16:23:27.5	11400	1	6070
7414	2024-05-31 04:49:28	8800	1	6072
7415	2024-05-31 04:44:27.5	11400	1	6073
7416	2024-05-31 04:49:28	8800	1	6074
7417	2024-05-30 16:23:27.5	0	1	6100
7418	2024-05-30 16:23:27.5	0	1	6101
7419	2024-05-30 16:23:27.5	0	1	6102
7420	2024-05-30 16:23:27.5	0	1	6103
7421	2024-05-30 16:23:27.5	0	1	6104
7422	2024-05-30 16:23:27.5	12000	1	6106
7423	2024-05-30 16:23:27.5	0	1	6107
7424	2024-05-30 16:23:27.5	12000	1	6108
7425	2024-05-30 16:23:27.5	0	1	6134
7426	2024-05-30 16:23:27.5	0	1	6135
7427	2024-05-30 16:23:27.5	0	1	6136
7428	2024-05-30 16:23:27.5	0	1	6137
7429	2024-05-30 16:23:27.5	0	1	6139
7430	2024-05-30 16:23:27.5	0	1	6140
7431	2024-05-30 16:23:27.5	0	1	6141
7432	2024-05-30 16:23:27.5	0	1	6142
7433	2024-05-30 16:23:27.5	0	1	6143
7434	2024-05-30 16:23:27.5	0	1	6144
7435	2024-05-30 16:23:27.5	0	1	6145
7436	2024-05-30 16:23:27.5	0	1	6147
7437	2024-05-30 16:23:27.5	0	1	6148
7438	2024-05-30 16:23:27.5	0	1	6149
7439	2024-05-30 16:23:27.5	0	1	6157
7440	2024-05-30 16:22:53.5	0	1	6160
7441	2024-05-30 16:23:27.5	0	1	6169
7442	2023-12-08 09:34:39.468098	0	1	6266
7443	2023-12-08 09:34:39.468098	0	1	6267
7444	2023-12-08 09:34:39.468098	0	1	6268
7445	2023-12-08 09:34:39.468098	0	1	6269
7446	2023-12-08 09:34:39.468098	0	1	6270
7447	2023-12-08 09:34:39.468098	0	1	6271
7448	2023-12-08 09:34:39.468098	0	1	6272
7449	2023-12-08 09:34:39.468098	0	1	6273
7450	2023-12-08 09:34:39.468098	0	1	6274
7451	2023-12-08 09:34:39.468098	0	1	6275
7452	2023-12-08 09:34:39.468098	0	1	6276
7453	2023-12-08 09:34:39.468098	0	1	6277
7454	2023-12-08 09:34:39.468098	0	1	6278
7455	2023-12-08 09:34:39.468098	0	1	6279
7456	2023-12-08 09:34:39.468098	0	1	6280
7457	2023-12-08 09:34:39.468098	0	1	6281
7458	2023-12-08 09:34:39.468098	0	1	6282
7459	2023-12-08 09:34:39.468098	0	1	6283
7460	2023-12-08 09:34:39.468098	0	1	6284
7461	2023-12-08 09:34:39.468098	0	1	6285
7462	2023-12-08 09:34:39.468098	0	1	6286
7463	2023-12-08 09:34:39.468098	0	1	6287
7464	2024-05-30 16:23:27	0	1	6295
7465	2024-05-30 16:23:27	0	1	6296
7466	2024-05-31 03:09:27.5	30	1	6297
7467	2024-05-31 04:56:28	45	1	6298
7468	2024-05-30 16:23:27	100	1	6299
7469	2024-05-31 04:55:28	11400	1	6300
7470	2024-05-30 16:23:27	0	1	6301
7471	2024-05-30 16:23:27	0	1	6302
7472	2024-05-30 16:23:27	7400	1	6303
7473	2024-05-30 16:23:27	0	1	6304
7474	2024-05-30 16:23:27	0	1	6305
7475	2024-05-30 20:16:27.5	11400	1	6306
7476	2024-05-30 20:16:27.5	11400	1	6307
7477	2024-05-30 16:22:53.5	0	1	6308
7478	2024-05-30 16:22:53.5	0	1	6309
7479	2024-05-30 16:23:27.5	0	1	6310
7480	2024-05-30 16:23:27.5	0	1	6311
7481	2024-05-30 16:23:27.5	100	1	6312
7482	2024-05-30 16:23:27.5	100	1	6313
7483	2024-05-30 16:23:27.5	0	1	6314
7484	2024-05-30 16:23:27.5	0	1	6315
7485	2024-05-30 16:23:27.5	0	1	6316
7486	2024-05-30 16:23:27.5	0	1	6317
7487	2024-05-30 16:23:27.5	0	1	6318
7488	2024-05-30 16:23:27.5	0	1	6319
7489	2024-05-30 16:23:27.5	0	1	6320
7490	2024-05-30 16:23:27.5	0	1	6321
7491	2024-05-30 16:23:27.5	0	1	6322
7492	2024-05-30 16:23:27.5	0	1	6323
7493	2024-05-31 01:11:52.5	1	1	6324
7494	2024-05-31 01:12:03.5	11	1	6325
7495	2024-05-30 16:23:27.5	0	1	6326
7496	2024-05-30 16:23:27.5	0	1	6327
7497	2024-05-30 16:23:27.5	0	1	6328
7498	2024-05-30 16:23:27.5	0	1	6329
7499	2024-05-31 04:47:31	5469	1	6330
7500	2024-05-31 04:56:28	10600	1	6331
7501	2024-05-31 04:48:27.5	66	1	6332
7502	2024-05-31 03:46:27.5	44	1	6333
7503	2024-05-30 16:23:27.5	11600	1	6334
7504	2024-05-30 16:23:27.5	11600	1	6335
7505	2024-05-30 22:20:34	11000	1	6336
7506	2024-05-30 22:20:34	11000	1	6337
7507	2024-05-30 17:42:34	0	1	6338
7508	2024-05-30 17:42:34	0	1	6339
7509	2024-05-30 17:42:34	0	1	6340
7510	2024-05-30 17:42:34	0	1	6341
7511	2024-05-30 17:43:35	100	1	6342
7512	2024-05-30 17:43:35	100	1	6343
7513	2024-05-30 17:42:34	0	1	6344
7514	2024-05-30 17:42:34	0	1	6345
7515	2024-05-30 17:42:34	0	1	6346
7516	2024-05-30 17:42:34	0	1	6347
7517	2024-05-30 17:42:34	0	1	6348
7518	2024-05-30 17:42:34	0	1	6349
7519	2024-05-30 17:42:34	0	1	6350
7520	2024-05-30 17:42:34	0	1	6351
7521	2024-05-30 17:42:34	0	1	6352
7522	2024-05-30 17:42:34	0	1	6353
7523	2024-05-31 04:47:27	105	1	6354
7524	2024-05-31 04:47:21	9	1	6355
7525	2024-05-30 17:42:34	0	1	6356
7526	2024-05-30 17:42:34	0	1	6357
7527	2024-05-30 17:42:34	0	1	6358
7528	2024-05-30 17:42:34	0	1	6359
7529	2024-05-31 04:56:34.5	10744	1	6360
7530	2024-05-31 04:56:34.5	5475	1	6361
7531	2024-05-31 04:23:34.5	46	1	6362
7532	2024-05-31 04:54:34	72	1	6363
7533	2024-05-31 04:42:34.5	11600	1	6364
7534	2024-05-31 04:42:34.5	11600	1	6365
7535	2024-05-31 04:47:27.5	11600	1	6366
7536	2024-05-31 04:47:27.5	11600	1	6367
7537	2024-05-31 04:47:27.5	11600	1	6368
7538	2024-05-31 04:47:27.5	11600	1	6369
7539	2024-05-30 16:23:27	11600	1	6370
7540	2024-05-31 04:47:27.5	11600	1	6371
7541	2024-05-30 16:23:27	0	1	6372
7542	2024-05-30 16:23:27	0	1	6373
7543	2024-05-30 16:23:27	0	1	6374
7544	2024-05-30 16:23:27	0	1	6375
7545	2024-05-30 16:23:27	0	1	6376
7546	2024-05-30 16:23:27	0	1	6377
7547	2024-05-30 16:23:27	0	1	6378
7548	2024-05-30 16:23:27	0	1	6379
7549	2024-05-30 16:23:27	0	1	6380
7550	2024-05-30 16:23:27	0	1	6381
7551	2024-05-30 16:23:27	0	1	6382
7552	2024-05-30 16:23:27	0	1	6383
7553	2024-05-30 16:23:27	100	1	6384
7554	2024-05-30 16:23:27	100	1	6385
7555	2024-05-30 16:23:27	100	1	6386
7556	2024-05-30 16:23:27	100	1	6387
7557	2024-05-30 16:23:27	100	1	6388
7558	2024-05-30 16:23:27	100	1	6389
7559	2024-05-30 16:23:27	0	1	6390
7560	2024-05-30 16:23:27	0	1	6391
7561	2024-05-30 16:23:27	0	1	6392
7562	2024-05-30 16:23:27	0	1	6393
7563	2024-05-30 16:23:27	0	1	6394
7564	2024-05-30 16:23:27	0	1	6395
7565	2024-05-30 16:23:27	0	1	6396
7566	2024-05-30 16:23:27	0	1	6397
7567	2024-05-30 16:23:27	0	1	6398
7568	2024-05-30 16:23:27	0	1	6399
7569	2024-05-30 16:23:27	0	1	6400
7570	2024-05-30 16:23:27	0	1	6401
7571	2024-05-30 16:23:27	0	1	6402
7572	2024-05-30 16:23:27	0	1	6403
7573	2024-05-30 16:23:27	0	1	6404
7574	2024-05-30 16:23:27	0	1	6405
7575	2024-05-30 16:23:27	0	1	6406
7576	2024-05-30 16:23:27	0	1	6407
7577	2024-05-30 16:23:27	0	1	6408
7578	2024-05-30 16:23:27	0	1	6409
7579	2024-05-30 16:23:27	0	1	6410
7580	2024-05-30 16:23:27	0	1	6411
7581	2024-05-30 16:23:27	0	1	6412
7582	2024-05-30 16:23:27	0	1	6413
7583	2024-05-30 16:23:27	0	1	6414
7584	2024-05-30 16:23:27	0	1	6415
7585	2024-05-30 16:23:27	0	1	6416
7586	2024-05-30 16:23:27	0	1	6417
7587	2024-05-30 16:23:27	0	1	6418
7588	2024-05-30 16:23:27	0	1	6419
7589	2023-12-08 09:34:39.468098	0	1	6420
7590	2023-12-08 09:34:39.468098	0	1	6421
7591	2023-12-08 09:34:39.468098	0	1	6422
7592	2023-12-08 09:34:39.468098	0	1	6423
7593	2023-12-08 09:34:39.468098	0	1	6424
7594	2023-12-08 09:34:39.468098	0	1	6425
7595	2024-05-30 16:23:27	0	1	6426
7596	2024-05-30 16:23:27	8000	1	6427
7597	2024-05-30 16:23:27	0	1	6428
7598	2024-05-30 16:23:27	0	1	6429
7599	2024-05-30 16:23:27	0	1	6430
7600	2024-05-30 16:23:27	0	1	6431
7601	2024-05-30 16:23:27	0	1	6432
7602	2024-05-30 16:23:27	0	1	6433
7603	2024-05-31 04:48:27.5	55	1	6434
7604	2024-05-30 16:23:27	0	1	6435
7605	2024-05-30 16:23:27	0	1	6436
7606	2024-05-30 16:23:27	0	1	6437
7607	2024-05-31 04:56:27.5	9706	1	6438
7608	2024-05-31 04:56:27.5	4981	1	6439
7609	2024-05-31 04:45:28	45	1	6440
7610	2024-05-31 04:56:27.5	58	1	6441
7611	2024-05-30 16:23:27	0	1	6442
7612	2024-05-30 16:23:27	0	1	6443
7613	2024-05-30 16:23:27	0	1	6444
7614	2024-05-30 16:23:27	0	1	6445
7615	2024-05-30 16:23:27	11200	1	6446
7616	2024-05-30 16:23:27	11200	1	6447
7617	2024-05-31 04:56:27.5	11600	1	6448
7618	2024-05-31 02:54:27.5	9000	1	6449
7619	2024-05-30 16:23:27	11400	1	6450
7620	2024-05-30 16:23:27	11200	1	6451
7621	2024-05-31 04:53:28	11800	1	6452
7622	2024-05-31 04:37:30.5	3	1	6453
7623	2024-05-30 16:23:27	12000	1	6454
7624	2024-05-31 01:07:28	7400	1	6455
7625	2024-05-30 16:23:28	12000	1	6456
7626	2024-05-30 16:23:28	0	1	6457
7627	2024-05-31 04:53:28	98.2	1	6458
7628	2024-05-30 16:23:28	0	1	6459
7629	2024-05-30 16:23:28	0	1	6460
7630	2024-05-30 16:23:28	0	1	6461
7631	2024-05-30 16:23:28	0	1	6462
7632	2024-05-30 16:23:28	0	1	6463
7633	2024-05-30 07:42:06.5	3	1	6464
7634	2024-05-30 16:23:28	12000	1	6465
7635	2024-05-31 03:24:28	29	1	6466
7636	2024-05-31 04:53:28	42	1	6467
7637	2024-05-31 04:15:28.5	8800	1	6468
7638	2024-05-30 16:23:27.5	7400	1	6469
7639	2024-05-30 16:23:27.5	12000	1	6470
7640	2024-05-30 16:23:27.5	0	1	6471
7641	2024-05-30 16:23:27.5	100	1	6472
7642	2024-05-30 16:23:27.5	0	1	6473
7643	2024-05-30 16:23:27.5	0	1	6474
7644	2024-05-30 16:23:27.5	0	1	6475
7645	2024-05-30 16:23:27.5	0	1	6476
7646	2024-05-30 16:23:27.5	0	1	6477
7647	2024-05-30 16:22:16	5	1	6478
7648	2024-05-31 04:48:27.5	12000	1	6479
7649	2024-05-31 04:56:27.5	31	1	6480
7650	2024-05-31 04:55:27.5	5525	1	6481
7651	2024-05-31 04:56:27.5	10781	1	6482
7652	2024-05-31 04:54:27.5	42	1	6483
7653	2024-05-30 16:23:27.5	9000	1	6484
7654	2024-05-30 16:23:27.5	7000	1	6485
7655	2024-05-31 04:56:28	11800	1	6486
7656	2024-05-30 16:23:27.5	0	1	6487
7657	2024-05-30 16:23:27.5	100	1	6488
7658	2024-05-30 16:23:27.5	0	1	6489
7659	2024-05-30 16:23:27.5	0	1	6490
7660	2024-05-30 16:23:27.5	0	1	6491
7661	2024-05-30 16:23:27.5	0	1	6492
7662	2024-05-30 16:23:27.5	0	1	6493
7663	2024-05-11 17:54:22.5	4	1	6494
7664	2024-05-31 04:28:27.5	11600	1	6495
7665	2024-05-31 04:14:28	29	1	6496
7666	2024-05-31 04:55:28	5406	1	6497
7667	2024-05-31 04:55:28	10863	1	6498
7668	2024-05-31 03:05:27.5	41	1	6499
7669	2024-05-30 16:23:27.5	9000	1	6500
7670	2024-05-30 17:39:09.5	7200	1	6501
7671	2024-05-30 16:23:09	12000	1	6502
7672	2024-05-30 16:23:09	0	1	6503
7673	2024-05-30 16:23:09	100	1	6504
7674	2024-05-30 16:23:09	0	1	6505
7675	2024-05-30 16:23:09	0	1	6506
7676	2024-05-30 16:23:09	0	1	6507
7677	2024-05-30 16:23:09	0	1	6508
7678	2024-05-30 16:23:09	0	1	6509
7679	2024-05-31 00:00:58.5	4	1	6510
7680	2024-05-31 00:03:09	11600	1	6511
7681	2024-05-31 00:04:09	31	1	6512
7682	2024-05-31 04:56:09.5	10463	1	6513
7683	2024-05-31 04:56:09.5	5506	1	6514
7684	2024-05-31 03:27:09.5	45	1	6515
7685	2024-05-31 00:01:11	9000	1	6516
7686	2024-05-30 16:23:27.5	7200	1	6517
7687	2024-05-30 16:23:27.5	12000	1	6518
7688	2024-05-30 16:23:27.5	0	1	6519
7689	2024-05-30 16:23:27.5	100	1	6520
7690	2024-05-30 16:23:27.5	0	1	6521
7691	2024-05-30 16:23:27.5	0	1	6522
7692	2024-05-30 16:23:27.5	0	1	6523
7693	2024-05-30 16:23:27.5	0	1	6524
7694	2024-05-30 16:23:27.5	0	1	6525
7695	2024-05-30 11:12:17	70	1	6526
7696	2024-05-30 16:23:27.5	12000	1	6527
7697	2024-05-31 03:00:27.5	30	1	6528
7698	2024-05-31 04:54:27.5	5494	1	6529
7699	2024-05-31 04:56:27.5	10731	1	6530
7700	2024-05-31 04:42:27.5	43	1	6531
7701	2024-05-31 02:53:27.5	9000	1	6532
7702	2024-05-30 16:23:27.5	7200	1	6533
7703	2024-05-30 16:23:27.5	11800	1	6534
7704	2024-05-30 16:23:27.5	0	1	6535
7705	2024-05-30 16:23:27.5	100	1	6536
7706	2024-05-30 16:23:27.5	0	1	6537
7707	2024-05-30 16:23:27.5	0	1	6538
7708	2024-05-30 16:23:27.5	0	1	6539
7709	2024-05-30 16:23:27.5	0	1	6540
7710	2024-05-30 16:23:27.5	0	1	6541
7711	2024-05-31 04:25:14.5	24	1	6542
7712	2024-05-31 04:55:28	11800	1	6543
7713	2024-05-31 00:07:27.5	30	1	6544
7714	2024-05-31 04:56:28	5481	1	6545
7715	2024-05-31 04:56:28	10663	1	6546
7716	2024-05-31 03:00:27.5	45	1	6547
7717	2024-05-31 03:55:27.5	9000	1	6548
7718	2024-05-31 04:43:39.5	7200	1	6549
7719	2024-05-31 04:43:39.5	12000	1	6550
7720	2024-05-31 04:43:39.5	0	1	6551
7721	2024-05-31 04:43:39.5	100	1	6552
7722	2024-05-31 04:43:39.5	0	1	6553
7723	2024-05-31 04:43:39.5	0	1	6554
7724	2024-05-31 04:43:39.5	0	1	6555
7725	2024-05-31 04:43:39.5	0	1	6556
7726	2024-05-31 04:43:39.5	0	1	6557
7727	2024-05-30 23:54:58	13	1	6558
7728	2024-05-31 04:43:39.5	12000	1	6559
7729	2024-05-31 04:43:39.5	30	1	6560
7730	2024-05-31 04:53:39.5	10800	1	6561
7731	2024-05-31 04:44:39.5	5438	1	6562
7732	2024-05-31 04:53:39.5	43	1	6563
7733	2024-05-31 04:43:39.5	9000	1	6564
7734	2024-05-30 16:23:27.5	7200	1	6565
7735	2024-05-30 16:22:54	0	1	6566
7736	2024-05-30 16:23:27.5	0	1	6567
7737	2024-05-30 16:23:27.5	100	1	6568
7738	2024-05-30 16:23:27.5	0	1	6569
7739	2024-05-30 16:23:27.5	0	1	6570
7740	2024-05-30 16:23:27.5	0	1	6571
7741	2024-05-30 16:23:27.5	0	1	6572
7742	2024-05-30 16:23:27.5	0	1	6573
7743	2024-05-21 18:15:28	58	1	6574
7744	2024-05-30 16:23:27.5	12000	1	6575
7745	2024-05-31 00:28:27.5	30	1	6576
7746	2024-05-31 04:56:28	5425	1	6577
7747	2024-05-31 04:54:28	10719	1	6578
7748	2024-05-31 04:38:28	41	1	6579
7749	2024-05-30 16:23:27.5	9000	1	6580
7750	2024-05-30 16:23:28	7400	1	6581
7751	2024-05-30 16:23:28	12000	1	6582
7752	2024-05-30 16:23:28	0	1	6583
7753	2024-05-30 16:23:28	100	1	6584
7754	2024-05-30 07:41:23	0	1	6585
7755	2024-05-30 16:23:28	0	1	6586
7756	2024-05-30 16:23:28	0	1	6587
7757	2024-05-30 16:23:28	0	1	6588
7758	2024-05-30 16:23:28	0	1	6589
7759	2024-05-29 12:18:23.5	4	1	6590
7760	2024-05-31 04:44:29	12000	1	6591
7761	2024-05-31 02:19:29	30	1	6592
7762	2024-05-31 04:56:28.5	5438	1	6593
7763	2024-05-31 04:56:28.5	10888	1	6594
7764	2024-05-31 04:13:28.5	44	1	6595
7765	2024-05-30 16:23:28	8800	1	6596
7766	2024-05-30 16:23:27.5	7200	1	6597
7767	2024-05-30 16:22:53.5	0	1	6598
7768	2024-05-30 16:23:27.5	0	1	6599
7769	2024-05-30 16:23:27.5	100	1	6600
7770	2024-05-30 16:23:27.5	0	1	6601
7771	2024-05-30 16:23:27.5	0	1	6602
7772	2024-05-30 16:23:27.5	0	1	6603
7773	2024-05-30 16:23:27.5	0	1	6604
7774	2024-05-30 16:23:27.5	0	1	6605
7775	2024-05-26 07:24:16.5	3	1	6606
7776	2024-05-30 16:23:27.5	11600	1	6607
7777	2024-05-31 00:25:28	31	1	6608
7778	2024-05-31 04:55:28	10813	1	6609
7779	2024-05-31 04:51:28	5569	1	6610
7780	2024-05-31 04:56:27.5	43	1	6611
7781	2024-05-31 04:56:27.5	8800	1	6612
7782	2024-05-30 16:23:27.5	7400	1	6613
7783	2024-05-30 16:22:53.5	0	1	6614
7784	2024-05-30 16:23:27.5	0	1	6615
7785	2024-05-30 16:23:27.5	100	1	6616
7786	2024-05-30 16:23:27.5	0	1	6617
7787	2024-05-30 16:23:27.5	0	1	6618
7788	2024-05-30 16:23:27.5	0	1	6619
7789	2024-05-30 16:23:27.5	0	1	6620
7790	2024-05-30 16:23:27.5	0	1	6621
7791	2024-05-25 16:44:56.5	4	1	6622
7792	2024-05-30 16:23:27.5	11800	1	6623
7793	2024-05-31 00:53:27.5	29	1	6624
7794	2024-05-31 04:55:27.5	5563	1	6625
7795	2024-05-31 04:56:27.5	10844	1	6626
7796	2024-05-31 04:36:27.5	43	1	6627
7797	2024-05-30 16:23:27.5	8800	1	6628
7798	2024-05-30 16:23:27.5	7200	1	6629
7799	2024-05-31 04:56:28	11600	1	6630
7800	2024-05-30 16:23:27.5	0	1	6631
7801	2024-05-30 16:23:27.5	100	1	6632
7802	2024-05-30 16:23:27.5	0	1	6633
7803	2024-05-30 16:23:27.5	0	1	6634
7804	2024-05-30 16:23:27.5	0	1	6635
7805	2024-05-30 16:23:27.5	0	1	6636
7806	2024-05-30 16:23:27.5	0	1	6637
7807	2024-05-30 00:05:25.5	11	1	6638
7808	2024-05-31 02:45:28	11400	1	6639
7809	2024-05-31 00:59:28	29	1	6640
7810	2024-05-31 04:55:28	5406	1	6641
7811	2024-05-31 04:56:28	10888	1	6642
7812	2024-05-31 04:24:28	42	1	6643
7813	2024-05-31 04:55:28	9000	1	6644
7814	2024-05-31 04:32:27.5	7200	1	6645
7815	2024-05-30 16:22:53.5	0	1	6646
7816	2024-05-30 16:23:27.5	0	1	6647
7817	2024-05-30 16:23:27.5	100	1	6648
7818	2024-05-30 16:23:27.5	0	1	6649
7819	2024-05-30 16:23:27.5	0	1	6650
7820	2024-05-30 16:23:27.5	0	1	6651
7821	2024-05-30 16:23:27.5	0	1	6652
7822	2024-05-30 16:23:27.5	0	1	6653
7823	2024-05-31 00:03:57.5	3	1	6654
7824	2024-05-30 16:23:27.5	12000	1	6655
7825	2024-05-31 04:10:28	29	1	6656
7826	2024-05-31 04:56:27.5	5469	1	6657
7827	2024-05-31 04:55:27.5	10656	1	6658
7828	2024-05-31 02:53:27.5	42	1	6659
7829	2024-05-30 16:23:27.5	8800	1	6660
7830	2024-05-31 04:54:32.5	7200	1	6661
7831	2024-05-31 04:54:32.5	12000	1	6662
7832	2024-05-31 04:54:32.5	0	1	6663
7833	2024-05-31 04:54:32.5	100	1	6664
7834	2024-05-31 04:54:32.5	0	1	6665
7835	2024-05-31 04:54:32.5	0	1	6666
7836	2024-05-31 04:54:32.5	0	1	6667
7837	2024-05-31 04:54:32.5	0	1	6668
7838	2024-05-31 04:54:32.5	0	1	6669
7839	2024-05-26 07:31:29.5	1	1	6670
7840	2024-05-31 04:56:33	11600	1	6671
7841	2024-05-31 04:54:32.5	30	1	6672
7842	2024-05-31 04:56:33	10875	1	6673
7843	2024-05-31 04:56:33	5500	1	6674
7844	2024-05-31 04:54:32.5	41	1	6675
7845	2024-05-31 04:54:32.5	9000	1	6676
7846	2024-05-31 04:56:27.5	6800	1	6677
7847	2024-05-30 16:22:53.5	0	1	6678
7848	2024-05-30 16:23:27.5	0	1	6679
7849	2024-05-30 16:23:27.5	100	1	6680
7850	2024-05-30 16:23:27.5	0	1	6681
7851	2024-05-30 16:23:27.5	0	1	6682
7852	2024-05-30 16:23:27.5	0	1	6683
7853	2024-05-30 16:23:27.5	0	1	6684
7854	2024-05-30 16:23:27.5	0	1	6685
7855	2024-05-30 23:57:55	3	1	6686
7856	2024-05-30 16:23:27.5	11600	1	6687
7857	2024-05-31 00:26:27.5	30	1	6688
7858	2024-05-31 04:56:27.5	10563	1	6689
7859	2024-05-31 04:56:27.5	5519	1	6690
7860	2024-05-31 04:56:27.5	40	1	6691
7861	2024-05-30 16:23:27.5	9000	1	6692
7862	2024-05-30 16:23:27.5	7200	1	6693
7863	2024-05-30 16:22:54	0	1	6694
7864	2024-05-30 16:23:27.5	0	1	6695
7865	2024-05-30 16:23:27.5	100	1	6696
7866	2024-05-30 16:23:27.5	0	1	6697
7867	2024-05-30 16:23:27.5	0	1	6698
7868	2024-05-30 16:23:27.5	0	1	6699
7869	2024-05-30 16:23:27.5	0	1	6700
7870	2024-05-30 16:23:27.5	0	1	6701
7871	2024-05-26 07:35:38.5	4	1	6702
7872	2024-05-30 16:23:27.5	12000	1	6703
7873	2024-05-31 00:55:28	30	1	6704
7874	2024-05-31 04:16:27.5	44	1	6705
7875	2024-05-30 16:23:27.5	8800	1	6706
7876	2024-05-30 16:23:27.5	7200	1	6707
7877	2024-05-30 16:22:53.5	0	1	6708
7878	2024-05-30 16:23:27.5	0	1	6709
7879	2024-05-30 16:23:27.5	100	1	6710
7880	2024-05-30 16:23:27.5	0	1	6711
7881	2024-05-30 16:23:27.5	0	1	6712
7882	2024-05-30 16:23:27.5	0	1	6713
7883	2024-05-30 16:23:27.5	0	1	6714
7884	2024-05-30 16:23:27.5	0	1	6715
7885	2024-05-31 04:31:40	4	1	6716
7886	2024-05-30 16:23:27.5	12000	1	6717
7887	2024-05-31 03:46:28	30	1	6718
7888	2024-05-31 03:06:30	45	1	6719
7889	2024-05-30 16:23:27.5	11400	1	6720
7890	2024-05-31 04:52:27.5	7200	1	6721
7891	2024-05-31 04:53:27.5	12000	1	6722
7892	2024-05-30 16:23:27.5	0	1	6723
7893	2024-05-31 04:33:28	92.5	1	6724
7894	2024-05-30 16:23:27.5	0	1	6725
7895	2024-05-30 16:23:27.5	0	1	6726
7896	2024-05-30 16:23:27.5	0	1	6727
7897	2024-05-30 16:23:27.5	0	1	6728
7898	2024-05-30 16:23:27.5	0	1	6729
7899	2024-05-31 04:50:08.5	4	1	6730
7900	2024-05-30 16:23:27.5	11400	1	6731
7901	2024-05-30 23:49:28	32	1	6732
7902	2024-05-31 04:55:27.5	5475	1	6733
7903	2024-05-31 04:56:27.5	10425	1	6734
7904	2024-05-31 04:04:28	46	1	6735
7905	2024-05-30 16:23:27.5	8800	1	6736
7906	2024-05-31 04:49:28.5	11000	1	6737
7907	2024-05-31 04:49:28.5	11000	1	6738
7908	2024-05-31 04:49:28.5	11000	1	6739
7909	2024-05-31 04:49:28.5	11000	1	6740
7910	2024-05-31 04:49:28.5	11000	1	6741
7911	2024-05-30 16:22:53.5	0	1	6742
7912	2024-05-30 16:22:53.5	0	1	6743
7913	2024-05-30 16:22:53.5	0	1	6744
7914	2024-05-30 16:22:53.5	0	1	6745
7915	2024-05-30 16:22:53.5	0	1	6746
7916	2024-05-30 16:23:27.5	0	1	6747
7917	2024-05-30 16:23:27.5	0	1	6748
7918	2024-05-30 16:23:27.5	0	1	6749
7919	2024-05-30 16:23:27.5	0	1	6750
7920	2024-05-30 16:23:27.5	0	1	6751
7921	2024-05-30 16:23:27.5	100	1	6752
7922	2024-05-30 16:23:27.5	100	1	6753
7923	2024-05-30 16:23:27.5	100	1	6754
7924	2024-05-30 16:23:27.5	100	1	6755
7925	2024-05-30 16:23:27.5	100	1	6756
7926	2024-05-30 16:23:27.5	0	1	6757
7927	2024-05-30 16:23:27.5	0	1	6758
7928	2024-05-30 16:23:27.5	0	1	6759
7929	2024-05-30 16:23:27.5	0	1	6760
7930	2024-05-30 16:23:27.5	0	1	6761
7931	2024-05-30 16:23:27.5	0	1	6762
7932	2024-05-30 16:23:27.5	0	1	6763
7933	2024-05-30 16:23:27.5	0	1	6764
7934	2024-05-30 16:23:27.5	0	1	6765
7935	2024-05-30 16:23:27.5	0	1	6766
7936	2024-05-30 16:23:27.5	0	1	6767
7937	2024-05-30 16:23:27.5	0	1	6768
7938	2024-05-30 16:23:27.5	0	1	6769
7939	2024-05-30 16:23:27.5	0	1	6770
7940	2024-05-30 16:23:27.5	0	1	6771
7941	2024-05-30 16:23:27.5	0	1	6772
7942	2024-05-30 16:23:27.5	0	1	6773
7943	2024-05-30 16:23:27.5	0	1	6774
7944	2024-05-30 16:23:27.5	0	1	6775
7945	2024-05-30 16:23:27.5	0	1	6776
7946	2024-05-30 16:23:27.5	0	1	6777
7947	2024-05-30 16:23:27.5	0	1	6778
7948	2024-05-30 16:23:27.5	0	1	6779
7949	2024-05-30 16:23:27.5	0	1	6780
7950	2024-05-30 16:23:27.5	0	1	6781
7951	2024-05-31 04:54:06.5	7	1	6782
7952	2024-05-31 04:54:14	106	1	6783
7953	2024-05-31 04:54:14	1	1	6784
7954	2024-05-31 04:54:15	2	1	6785
7955	2024-05-31 04:54:15	36	1	6786
7956	2024-05-30 16:23:27.5	0	1	6787
7957	2024-05-30 16:23:27.5	0	1	6788
7958	2024-05-30 16:23:27.5	0	1	6789
7959	2024-05-30 16:23:27.5	0	1	6790
7960	2024-05-30 16:23:27.5	0	1	6791
7961	2024-05-30 16:23:27.5	0	1	6792
7962	2024-05-30 16:23:27.5	0	1	6793
7963	2024-05-30 16:23:27.5	0	1	6794
7964	2024-05-30 16:23:27.5	0	1	6795
7965	2024-05-30 16:23:27.5	0	1	6796
7966	2024-05-31 04:55:28	10644	1	6797
7967	2024-05-31 04:56:28	5500	1	6798
7968	2024-05-30 16:23:27.5	0	1	6799
7969	2024-05-31 04:55:28	71	1	6800
7970	2024-05-30 16:23:27.5	0	1	6801
7971	2024-05-30 16:23:27.5	0	1	6802
7972	2024-05-31 04:55:28	47	1	6803
7973	2024-05-30 16:23:27.5	11600	1	6804
7974	2024-05-30 16:23:27.5	11200	1	6805
7975	2024-05-30 16:23:27.5	11600	1	6806
7976	2024-05-31 04:41:27.5	11400	1	6807
7977	2024-05-31 04:41:27.5	11400	1	6808
7978	2024-05-30 21:51:28	11200	1	6809
7979	2024-05-30 21:51:28	11200	1	6810
7980	2024-05-30 21:51:28	11200	1	6811
7981	2024-05-30 16:23:27	0	1	6812
7982	2024-05-30 16:23:27	0	1	6813
7983	2024-05-30 16:23:27	0	1	6814
7984	2024-05-30 16:23:27	0	1	6815
7985	2024-05-30 16:23:27	0	1	6816
7986	2024-05-30 16:23:27	0	1	6817
7987	2024-05-30 16:23:27	100	1	6818
7988	2024-05-30 16:23:27	100	1	6819
7989	2024-05-30 16:23:27	100	1	6820
7990	2024-05-30 16:23:27	0	1	6821
7991	2024-05-30 16:23:27	0	1	6822
7992	2024-05-30 16:23:27	0	1	6823
7993	2024-05-30 16:23:27	0	1	6824
7994	2024-05-30 16:23:27	0	1	6825
7995	2024-05-30 16:23:27	0	1	6826
7996	2024-05-30 16:23:27	0	1	6827
7997	2024-05-30 16:23:27	0	1	6828
7998	2024-05-30 16:23:27	0	1	6829
7999	2024-05-30 16:23:27	0	1	6830
8000	2024-05-30 16:23:27	0	1	6831
8001	2024-05-30 16:23:27	0	1	6832
8002	2024-05-30 16:23:27	0	1	6833
8003	2024-05-30 16:23:27	0	1	6834
8004	2024-05-30 16:23:27	0	1	6835
8005	2024-05-31 03:56:45	3	1	6836
8006	2024-05-31 03:57:26	4	1	6837
8007	2024-05-31 03:57:45	5	1	6838
8008	2024-05-30 16:23:27	0	1	6839
8009	2024-05-30 16:23:27	0	1	6840
8010	2024-05-30 16:23:27	0	1	6841
8011	2024-05-31 04:15:28	22	1	6842
8012	2024-05-30 23:55:27.5	40	1	6843
8013	2024-05-30 17:51:28	24	1	6844
8014	2024-05-31 04:56:28	5550	1	6845
8015	2024-05-31 04:56:28	10675	1	6846
8016	2024-05-31 04:56:28	36	1	6847
8017	2024-05-31 04:54:28	54	1	6848
8018	2024-05-30 23:55:27.5	36	1	6849
8019	2024-05-30 16:23:27	11400	1	6850
8020	2024-05-30 16:23:27	11400	1	6851
8021	2024-05-30 16:23:27	11400	1	6852
8022	2024-05-30 16:23:27	11600	1	6853
8023	2024-05-30 16:23:27	11600	1	6854
8024	2024-05-30 16:23:27	11600	1	6855
8025	2024-05-30 16:23:27	0	1	6856
8026	2024-05-30 16:23:27	0	1	6857
8027	2024-05-30 16:23:27	0	1	6858
8028	2024-05-30 16:23:27	0	1	6859
8029	2024-05-30 16:23:27	0	1	6860
8030	2024-05-30 16:23:27	0	1	6861
8031	2024-05-30 16:23:27	100	1	6862
8032	2024-05-30 16:23:27	100	1	6863
8033	2024-05-30 16:23:27	100	1	6864
8034	2024-05-30 16:23:27	0	1	6865
8035	2024-05-30 16:23:27	0	1	6866
8036	2024-05-30 16:23:27	0	1	6867
8037	2024-05-30 16:23:27	0	1	6868
8038	2024-05-30 16:23:27	0	1	6869
8039	2024-05-30 16:23:27	0	1	6870
8040	2024-05-30 16:23:27	0	1	6871
8041	2024-05-30 16:23:27	0	1	6872
8042	2024-05-30 16:23:27	0	1	6873
8043	2024-05-30 16:23:27	0	1	6874
8044	2024-05-30 16:23:27	0	1	6875
8045	2024-05-30 16:23:27	0	1	6876
8046	2024-05-30 16:23:27	0	1	6877
8047	2024-05-30 16:23:27	0	1	6878
8048	2024-05-30 16:23:27	0	1	6879
8049	2024-05-31 04:45:28.5	5	1	6880
8050	2024-05-31 04:45:28.5	2	1	6881
8051	2024-05-31 03:59:56	2	1	6882
8052	2024-05-30 16:23:27	0	1	6883
8053	2024-05-30 16:23:27	0	1	6884
8054	2024-05-30 16:23:27	0	1	6885
8055	2024-05-31 04:36:27.5	23	1	6886
8056	2024-05-31 02:41:28	26	1	6887
8057	2024-05-31 04:53:28	42	1	6888
8058	2024-05-31 04:54:27.5	5531	1	6889
8059	2024-05-31 04:56:28	10700	1	6890
8060	2024-05-31 04:56:28	58	1	6891
8061	2024-05-31 04:51:28	37	1	6892
8062	2024-05-31 04:56:28	39	1	6893
8063	2024-05-30 16:23:27	11800	1	6894
8064	2024-05-30 16:23:27	11800	1	6895
8065	2024-05-30 16:23:27	11800	1	6896
8066	2024-05-30 16:23:27	9000	1	6897
8067	2024-05-30 16:44:27	9000	1	6898
8068	2024-05-30 16:23:27	9000	1	6899
8069	2024-05-30 16:23:27	0	1	6900
8070	2024-05-30 16:23:27	0	1	6901
8071	2024-05-30 16:23:27	0	1	6902
8072	2024-05-30 16:23:27	0	1	6903
8073	2024-05-30 16:23:27	0	1	6904
8074	2024-05-30 16:23:27	100	1	6905
8075	2024-05-30 16:23:27	100	1	6906
8076	2024-05-30 16:23:27	0	1	6907
8077	2024-05-30 16:23:27	0	1	6908
8078	2024-05-30 16:23:27	0	1	6909
8079	2024-05-30 16:23:27	0	1	6910
8080	2024-05-30 16:23:27	0	1	6911
8081	2024-05-30 16:23:27	0	1	6912
8082	2024-05-30 16:23:27	0	1	6913
8083	2024-05-30 16:23:27	0	1	6914
8084	2024-05-30 16:23:27	0	1	6915
8085	2024-05-30 16:23:27	0	1	6916
8086	2023-12-08 09:34:39.468098	0	1	6917
8087	2023-12-08 09:34:39.468098	0	1	6918
8088	2024-05-30 16:23:27	0	1	6919
8089	2024-05-30 16:23:27	0	1	6920
8090	2024-05-31 04:51:27	41	1	6921
8091	2024-05-31 04:56:27	57	1	6922
8092	2024-05-31 04:56:27	10338	1	6923
8093	2024-05-31 04:53:27	5344	1	6924
8094	2024-05-31 04:53:27	48	1	6925
8095	2024-05-31 04:39:27	63	1	6926
8096	2024-05-30 16:23:27	11600	1	6927
8097	2024-05-30 16:23:27	11400	1	6928
8098	2024-05-31 04:55:27.5	7000	1	6929
8099	2024-05-31 04:54:27.5	11800	1	6930
8100	2024-05-30 16:23:27.5	0	1	6931
8101	2024-05-30 16:23:27.5	100	1	6932
8102	2024-05-30 16:23:27.5	0	1	6933
8103	2024-05-30 16:23:27.5	0	1	6934
8104	2024-05-30 16:23:27.5	0	1	6935
8105	2024-05-30 16:23:27.5	0	1	6936
8106	2024-05-30 16:23:27.5	0	1	6937
8107	2024-04-16 09:33:34.5	2	1	6938
8108	2024-05-30 16:23:27.5	12000	1	6939
8109	2024-05-31 03:00:28	29	1	6940
8110	2024-05-31 00:28:27.5	40	1	6941
8111	2024-05-30 16:23:27.5	8800	1	6942
8112	2024-05-31 01:35:27.5	7200	1	6943
8113	2024-05-30 16:23:27.5	12000	1	6944
8114	2024-05-30 16:23:27.5	0	1	6945
8115	2024-05-30 16:23:27.5	100	1	6946
8116	2024-05-30 16:23:27.5	0	1	6947
8117	2024-05-30 16:23:27.5	0	1	6948
8118	2024-05-30 16:23:27.5	0	1	6949
8119	2024-05-30 16:23:27.5	0	1	6950
8120	2024-05-30 16:23:27.5	0	1	6951
8121	2024-05-26 06:26:26.5	2	1	6952
8122	2024-05-30 16:23:27.5	12000	1	6953
8123	2024-05-31 03:41:28	31	1	6954
8124	2024-05-31 04:56:28	10644	1	6955
8125	2024-05-31 04:53:28	5563	1	6956
8126	2024-05-31 04:03:28	43	1	6957
8127	2024-05-30 16:23:27.5	8800	1	6958
8128	2024-05-30 16:23:27.5	7000	1	6959
8129	2024-05-30 16:23:27.5	11800	1	6960
8130	2024-05-30 16:23:27.5	0	1	6961
8131	2024-05-30 16:23:27.5	100	1	6962
8132	2024-05-30 16:23:27.5	0	1	6963
8133	2024-05-30 16:23:27.5	0	1	6964
8134	2024-05-30 16:23:27.5	0	1	6965
8135	2024-05-30 16:23:27.5	0	1	6966
8136	2024-05-30 16:23:27.5	0	1	6967
8137	2024-05-28 23:53:58	2	1	6968
8138	2024-05-31 04:55:27.5	11600	1	6969
8139	2024-05-31 03:13:27.5	29	1	6970
8140	2024-05-31 04:55:27.5	5450	1	6971
8141	2024-05-31 04:56:27.5	10650	1	6972
8142	2024-05-31 03:36:28	44	1	6973
8143	2024-05-30 16:23:27.5	8800	1	6974
8144	2024-05-31 04:56:28	7400	1	6975
8145	2024-05-30 16:23:27.5	12000	1	6976
8146	2024-05-30 16:23:27.5	0	1	6977
8147	2024-05-30 16:23:27.5	100	1	6978
8148	2024-05-30 16:23:27.5	0	1	6979
8149	2024-05-30 16:23:27.5	0	1	6980
8150	2024-05-30 16:23:27.5	0	1	6981
8151	2024-05-30 16:23:27.5	0	1	6982
8152	2024-05-30 16:23:27.5	0	1	6983
8153	2024-05-26 06:28:57.5	3	1	6984
8154	2024-05-31 02:50:28	11600	1	6985
8155	2024-05-31 03:01:27.5	30	1	6986
8156	2024-05-31 04:56:28	10706	1	6987
8157	2024-05-31 04:56:28	5525	1	6988
8158	2024-05-31 04:55:28	44	1	6989
8161	2024-05-31 04:56:28.5	100000	2	6992
8160	2024-05-31 04:52:28.5	5525	2	6991
8159	2024-05-31 04:49:28	8800	2	6990
12	2024-05-31 04:55:26.5	5513	3	38
\.


--
-- TOC entry 3671 (class 0 OID 16881)
-- Dependencies: 249
-- Data for Name: spare_part; Type: TABLE DATA; Schema: tiei_sample_5; Owner: postgres
--

COPY tiei_sample_5.spare_part (id, part_name, reference_part_number, warning_limit, critical_limit, machine_id) FROM stdin;
1	Hydraulic Pump	10045	2	1	1
2	Drive Belt	10046	3	1	1
3	Air Filter	10047	5	2	2
4	Oil Filter	10048	4	2	2
5	Bearing Assembly	10049	2	1	3
6	gearA	1000	100	120	2
7	Test	1000	3	7	6
8	cmti	1000	5	10	7
\.


--
-- TOC entry 3672 (class 0 OID 16886)
-- Dependencies: 250
-- Data for Name: spare_part_activity; Type: TABLE DATA; Schema: tiei_sample_5; Owner: postgres
--

COPY tiei_sample_5.spare_part_activity (id, machine_id, spare_part_id, spare_part_name, date_of_identification, priority, target_date_of_completion, corrective_measurement, spare_required, support_needed, responsible_person_id) FROM stdin;
2	2	3	Air Filter	2024-10-18 00:00:00	Medium	2024-10-28	Replace clogged air filter	New air filter	this is edited 1	5
1	1	1	Hydraulic Pump	2024-10-15 00:00:00	High	2024-10-25	Replace hydraulic pump due to pressure loss	New hydraulic pump assembly	this is edited 2	1
\.


--
-- TOC entry 3673 (class 0 OID 16891)
-- Dependencies: 251
-- Data for Name: spare_part_activity_history; Type: TABLE DATA; Schema: tiei_sample_5; Owner: postgres
--

COPY tiei_sample_5.spare_part_activity_history (id, machine_id, spare_part_id, spare_part_name, date_of_identification, priority, target_date_of_completion, corrective_measurement, spare_required, support_needed, responsible_person_id, date_of_completion) FROM stdin;
3	3	5	Bearing Assembly	2024-10-20 00:00:00	Critical	2024-10-22	This is the new edited data that is being saved kehooooooooooooo	New dsassembly kit	asdasd	1	2024-10-23
\.


--
-- TOC entry 3677 (class 0 OID 16899)
-- Dependencies: 255
-- Data for Name: units; Type: TABLE DATA; Schema: tiei_sample_5; Owner: postgres
--

COPY tiei_sample_5.units (id, name, short_name, description, type) FROM stdin;
1	millimeter per minute	mm/min	Used to denote speed of components, such as fan speed	speed
2	watt	W	Used to power consumption	power
3	millisecond	ms	this is used to denote time in milli seconds	time
4	grams per second	0.01g/s	this is used to weight flow rate	flow_rate
5	degree	0.01deg	this is used to denote angular position	position
6	no_units	none	this is used for cases where there is no units	none
7	kilo_pascal	0.01KPa	this is used to denote pressure in kilo pascal	pressure
8	liters per minute	L/min	this is used to denote flow rate in liters per minute	flow_rate
9	0.1 millisecond	0.1ms	Used to denote time in 0.1 milli second	time
10	0.01 grams	0.01g	Used to denote time in 0.01 grams	weight
11	10 watt	10W	Used to denote 10 watt power consumption	power
12	Microns	microns	Used to denote length in microns	length
13	temperature	c	use to represent temperature	temperature
15	instulation_resistance	Ω	used to represent resistance	resistance
16	rotational_speed	rpm	used to represent rotation speed such as cnc fan speed	speed
17	load_percentage	%	use to represent load in percentage	percentage
\.


--
-- TOC entry 3679 (class 0 OID 16905)
-- Dependencies: 257
-- Data for Name: user; Type: TABLE DATA; Schema: tiei_sample_5; Owner: postgres
--

COPY tiei_sample_5."user" (id, username, email, full_name, disabled, hashed_password, role, company_id) FROM stdin;
4	nihal	sadasd@gmail.com		f	$2b$12$DreiOfkZsHmbq1wOIuaiyeIcjzYmo6e4Q2OzXuclBXhsI7mcwK2pu	guest	123123
5	NihalDM	NihalG@gmail.com		f	$2b$12$mfQt3aXHNaIJ2L7vtjWMN.O65fsmvK4yV7r2f5Ro2zvN/lzdIIxzW	maintenance_operator	12123
6	Guest2	Nihaldm123@gmail.com		f	$2b$12$i/gdwbNz9N.wxdBjU2pSfu3nRNud4QKStQNml7kSIIQkjvAZHl5oa	guest	67656
1	cmti	cmti@cmti.res.in	CMTI SMDDC	f	$2y$10$kmtK6CWajzgOg6VmxUgPzuKrlz2nO0RXvvUxJiXQrvk5gMWN7Aw.e	admin	42069
7	shashank	shashank.cmti@gmail.com		f	$2b$12$bZDOrsI4h8aQRN4dcveD7uAkbzjaHQbVY5ILiOp773l3pD1aKFjlW	maintenance_operator	123
\.


--
-- TOC entry 3680 (class 0 OID 16910)
-- Dependencies: 258
-- Data for Name: user_access_log; Type: TABLE DATA; Schema: tiei_sample_5; Owner: postgres
--

COPY tiei_sample_5.user_access_log (id, user_id, "timestamp") FROM stdin;
94	1	2024-11-25 06:35:09.823597
95	1	2024-11-25 06:36:58.88124
96	1	2024-11-25 06:38:57.802278
97	1	2024-11-25 06:44:53.189632
98	1	2024-11-25 09:05:18.282774
99	1	2024-11-25 09:15:57.800628
100	1	2024-11-25 09:42:28.572283
101	1	2024-11-25 12:45:08.803503
102	1	2024-11-25 12:45:59.602303
103	1	2024-11-25 12:48:25.234009
104	1	2024-11-25 12:50:19.651308
105	1	2024-11-25 12:50:40.752555
106	1	2024-11-25 12:50:51.985467
107	1	2024-11-25 13:00:41.73732
108	1	2024-11-25 13:30:54.372885
109	1	2024-11-26 03:24:33.170273
110	1	2024-11-29 09:26:22.087393
111	1	2024-12-01 06:24:23.638592
112	1	2024-12-01 06:26:45.302321
113	1	2024-12-01 06:26:45.363543
114	1	2024-12-01 06:26:45.41319
115	1	2024-12-01 06:28:54.000675
116	1	2024-12-01 06:28:54.055271
117	1	2024-12-01 06:28:54.104813
118	1	2024-12-01 16:30:07.154114
119	1	2024-12-02 04:01:57.921097
120	1	2024-12-03 16:48:23.284995
121	1	2024-12-04 03:51:23.220211
122	1	2024-12-04 05:33:03.312548
123	1	2024-12-04 08:36:29.994637
124	1	2024-12-05 12:27:07.146143
125	1	2024-12-16 09:47:55.474482
126	1	2024-12-16 09:48:25.542805
127	1	2024-12-16 09:51:51.456031
128	1	2024-12-16 09:52:13.077815
129	1	2024-12-16 10:11:33.913839
130	1	2024-12-17 09:31:15.806191
131	1	2024-12-17 09:31:16.851702
132	1	2024-12-17 09:31:17.526878
133	1	2024-12-17 09:31:17.804091
134	1	2024-12-17 09:43:39.644533
135	1	2024-12-17 09:43:40.36991
136	1	2024-12-17 09:43:41.169001
137	1	2024-12-17 09:43:41.406972
138	1	2024-12-17 09:43:46.568841
139	1	2024-12-17 09:43:48.600588
140	1	2024-12-17 09:43:49.74525
141	1	2024-12-17 09:43:49.953054
142	1	2024-12-17 09:45:41.390256
143	1	2024-12-17 09:46:20.112628
144	1	2024-12-17 09:46:20.722127
145	1	2024-12-17 09:46:21.232588
146	1	2024-12-17 09:46:21.504713
147	1	2024-12-17 09:46:22.249199
148	1	2024-12-17 09:46:22.503032
149	1	2024-12-17 09:46:22.721348
150	1	2024-12-18 04:18:01.206595
151	1	2024-12-18 04:18:39.756489
152	1	2024-12-18 04:57:59.03563
153	1	2024-12-18 05:05:33.8982
154	1	2024-12-21 11:42:34.200346
155	1	2025-01-06 08:42:32.848084
156	1	2025-01-06 09:21:59.343358
157	1	2025-01-10 08:17:34.902764
158	1	2025-01-10 08:21:15.426246
159	1	2025-01-10 09:35:03.501989
160	1	2025-01-10 09:35:03.923066
161	1	2025-01-15 05:30:03.127302
162	1	2025-01-17 08:18:03.74889
163	1	2025-01-21 07:35:08.819481
164	1	2025-01-22 04:18:51.223658
165	1	2025-01-22 05:21:23.739199
166	1	2025-01-22 05:55:28.215494
167	1	2025-01-22 06:02:41.946353
168	1	2025-01-23 03:52:14.880124
169	1	2025-01-23 06:44:22.583268
170	1	2025-01-23 06:57:21.202343
171	1	2025-01-23 06:57:57.901167
172	1	2025-01-23 06:58:07.97454
173	1	2025-01-24 03:07:49.804246
174	1	2025-01-24 08:08:38.819778
175	1	2025-01-27 07:28:14.815312
176	1	2025-01-31 08:57:22.426254
177	1	2025-02-04 04:41:54.285066
178	1	2025-02-04 09:26:45.414855
179	1	2025-02-04 09:35:18.073992
180	1	2025-02-04 11:38:39.611785
181	1	2025-02-04 11:40:27.709981
182	1	2025-02-06 03:41:39.342761
183	1	2025-02-06 08:38:43.995864
184	1	2025-02-11 06:32:43.070603
185	1	2025-02-12 13:42:50.89515
186	1	2025-02-15 03:55:56.69653
187	1	2025-02-15 04:26:57.069747
188	1	2025-02-17 10:57:11.587359
189	1	2025-02-17 11:19:00.404516
190	1	2025-02-17 11:19:01.930447
191	1	2025-02-17 11:19:02.065397
192	1	2025-02-17 11:19:02.120046
193	1	2025-02-19 06:35:45.343801
194	1	2025-02-19 07:07:38.734766
195	1	2025-02-19 07:07:38.786622
196	1	2025-02-19 07:07:38.839092
197	1	2025-02-20 03:59:31.501207
198	1	2025-02-20 04:00:31.861166
199	1	2025-02-20 04:00:32.400757
200	1	2025-02-20 05:00:38.564869
201	1	2025-02-20 07:01:22.466498
202	1	2025-02-21 04:48:35.362482
203	1	2025-02-21 10:43:52.552508
204	1	2025-02-25 06:22:00.473232
205	1	2025-02-27 08:34:55.961271
206	1	2025-02-28 06:31:46.121456
207	1	2025-02-28 07:22:04.127661
208	1	2025-03-03 11:06:09.769039
209	1	2025-03-04 05:13:32.401692
210	1	2025-03-06 09:53:43.361613
211	1	2025-03-10 07:38:01.613978
212	1	2025-03-10 10:00:19.708134
213	1	2025-03-10 10:40:36.209482
92	1	2024-11-25 06:32:47.207574
93	1	2024-11-25 06:32:54.763996
214	1	2025-03-10 12:00:35.845083
215	1	2025-03-10 12:11:22.203494
216	1	2025-03-10 12:15:22.335204
217	1	2025-03-13 06:50:09.631075
218	1	2025-03-19 06:25:35.566794
219	1	2025-03-20 07:20:07.916509
220	1	2025-03-20 07:32:51.519383
221	1	2025-03-20 07:32:51.578036
222	1	2025-03-20 07:32:51.628537
223	1	2025-03-20 07:32:51.678898
224	1	2025-03-20 07:32:51.733724
225	1	2025-03-20 07:32:51.784249
226	1	2025-03-20 07:32:51.841036
227	1	2025-03-20 07:32:51.892426
228	1	2025-03-20 07:32:51.947903
229	1	2025-03-20 07:32:51.998182
230	1	2025-03-20 08:44:35.020088
231	1	2025-03-21 09:22:07.968716
232	1	2025-03-24 09:55:54.37118
233	1	2025-03-25 07:00:33.871614
234	1	2025-03-25 11:27:55.997972
235	1	2025-03-28 03:56:50.855632
236	1	2025-04-10 09:42:18.913444
237	1	2025-04-10 09:42:18.968439
238	1	2025-04-10 09:42:19.121866
239	1	2025-04-15 09:54:17.234465
240	1	2025-04-16 07:44:05.056622
241	1	2025-04-16 07:56:43.949193
242	1	2025-04-17 10:13:49.297871
243	1	2025-04-21 04:50:23.715679
244	1	2025-04-22 09:21:39.982554
245	1	2025-04-24 11:23:55.835619
246	1	2025-04-25 08:59:43.194091
247	1	2025-04-25 09:00:05.645948
248	1	2025-04-25 09:05:20.925821
249	1	2025-04-26 07:01:06.67529
250	1	2025-04-26 09:24:19.236392
251	1	2025-05-07 04:03:50.122999
252	1	2025-05-07 07:26:01.703496
253	1	2025-05-10 06:58:20.375616
254	1	2025-05-10 07:02:35.226823
255	1	2025-05-10 07:03:05.359883
256	1	2025-05-10 07:03:05.41114
257	1	2025-05-10 07:03:05.463185
258	1	2025-05-10 07:03:05.513987
259	1	2025-05-10 07:03:05.563566
260	1	2025-05-10 07:03:05.614465
261	1	2025-05-10 07:03:05.665482
262	1	2025-05-10 07:03:05.716295
263	1	2025-05-10 07:03:05.767447
264	1	2025-05-10 07:03:05.818084
265	1	2025-05-10 07:03:05.868796
266	1	2025-05-10 07:03:05.919161
267	1	2025-05-10 07:03:05.97033
268	1	2025-05-10 07:03:06.021084
269	1	2025-05-10 07:03:06.071426
270	1	2025-05-10 07:03:06.170729
271	1	2025-05-10 07:03:06.370914
272	1	2025-05-10 07:03:06.424633
273	1	2025-05-10 07:03:06.474781
274	1	2025-05-10 07:03:06.525038
275	1	2025-05-10 07:03:06.576214
276	1	2025-05-10 07:03:06.627613
277	1	2025-05-10 07:03:07.445621
278	1	2025-05-10 07:03:07.49858
279	1	2025-05-10 07:03:07.549129
280	1	2025-05-13 06:03:13.879896
281	1	2025-05-15 10:12:36.577469
282	1	2025-05-27 08:04:04.345497
283	1	2025-05-27 08:13:00.183083
284	1	2025-05-28 04:23:24.706451
285	1	2025-05-28 04:34:45.011481
286	1	2025-05-28 04:47:32.250053
287	1	2025-06-07 09:02:39.609645
288	1	2025-06-11 03:48:19.892721
289	1	2025-06-12 08:18:16.885227
290	1	2025-06-16 08:35:11.912905
291	1	2025-06-16 09:53:23.805185
292	1	2025-06-20 07:50:48.167799
293	1	2025-06-25 05:09:14.507162
294	1	2025-06-25 06:59:15.267808
295	1	2025-06-25 06:59:15.320241
296	1	2025-06-25 06:59:15.369341
297	1	2025-06-25 06:59:15.419453
298	1	2025-06-25 06:59:15.472576
299	1	2025-06-25 07:03:23.854652
300	1	2025-06-25 07:03:23.905284
301	1	2025-06-25 07:03:54.084674
302	1	2025-06-25 07:03:54.138179
303	1	2025-06-25 07:03:54.19403
304	1	2025-06-27 03:46:26.156615
305	1	2025-06-27 05:01:02.094229
306	1	2025-06-27 06:13:17.984848
307	1	2025-06-27 06:13:18.035439
308	1	2025-06-27 06:13:18.084498
309	1	2025-06-27 06:13:18.133931
310	1	2025-06-27 06:13:18.183949
311	1	2025-06-27 06:13:18.233489
312	1	2025-06-27 06:13:48.625806
313	1	2025-06-27 06:13:48.682217
314	1	2025-06-27 06:13:48.735478
315	1	2025-06-27 06:13:49.38813
316	1	2025-06-27 06:13:49.466674
317	1	2025-06-27 07:13:23.741573
318	1	2025-06-27 07:13:23.79352
319	1	2025-06-28 08:33:56.196646
320	1	2025-07-01 07:20:47.90785
321	1	2025-07-02 05:20:04.801979
322	1	2025-07-02 11:11:19.293797
323	1	2025-07-02 11:39:40.221265
324	1	2025-07-02 11:39:40.276189
325	1	2025-07-02 11:39:40.327634
326	1	2025-07-02 11:39:40.379001
327	1	2025-07-03 08:51:04.410908
328	1	2025-07-09 09:20:06.743254
329	1	2025-07-17 08:53:51.666516
330	1	2025-07-17 09:08:37.458675
331	1	2025-07-18 04:25:12.624754
332	1	2025-08-13 07:39:38.737989
333	1	2025-08-20 09:46:19.103342
334	1	2025-08-22 05:23:25.083542
335	1	2025-08-22 05:30:03.250956
336	1	2025-08-22 05:30:03.303381
337	1	2025-08-22 05:30:03.352567
338	1	2025-08-22 05:30:33.450165
339	1	2025-08-22 08:14:45.78851
340	1	2025-08-22 08:14:45.839516
341	1	2025-08-22 08:14:45.889187
342	1	2025-08-22 08:14:45.939701
343	1	2025-08-22 10:23:44.666598
344	1	2025-08-22 10:24:14.83669
345	1	2025-08-22 10:24:14.889749
346	1	2025-08-22 10:24:45.063852
347	1	2025-09-03 06:53:52.017008
348	1	2025-09-03 12:07:45.62767
349	1	2025-09-09 07:53:34.937039
350	1	2025-09-09 09:55:24.427879
351	1	2025-09-09 10:50:52.333285
352	1	2025-09-09 10:51:22.537521
353	1	2025-09-09 10:51:52.737734
354	1	2025-09-09 10:51:52.817519
355	1	2025-09-09 10:51:52.867596
356	1	2025-09-09 10:51:52.917404
357	1	2025-09-09 10:51:52.967644
358	1	2025-09-09 10:51:53.017671
359	1	2025-09-09 10:52:23.441625
360	1	2025-09-09 10:52:23.494364
361	1	2025-09-09 10:52:23.559917
362	1	2025-09-09 10:52:53.638663
363	1	2025-09-09 10:52:53.693936
364	1	2025-09-09 10:53:23.850422
365	1	2025-09-09 11:23:36.350634
366	1	2025-09-09 11:23:37.019885
367	1	2025-09-09 11:24:07.558807
368	1	2025-09-12 06:31:28.071677
369	1	2025-09-22 10:19:26.549889
370	1	2025-10-07 05:40:33.946065
371	1	2025-10-09 10:33:29.800688
372	1	2025-10-09 10:38:07.035629
373	1	2025-10-09 10:39:56.29958
374	1	2025-10-09 10:41:24.371883
375	1	2025-10-09 10:41:24.423662
376	1	2025-10-09 10:41:29.127941
377	1	2025-10-09 10:41:43.986488
378	1	2025-10-09 10:41:44.74755
379	1	2025-10-09 10:41:55.772574
380	1	2025-10-09 10:47:02.132961
381	1	2025-10-09 10:48:08.464401
382	1	2025-10-09 10:48:38.665521
383	1	2025-10-09 10:51:25.369575
384	1	2025-10-14 11:00:07.533642
385	1	2025-10-17 11:30:17.758443
386	1	2025-10-27 06:14:46.792964
387	1	2025-10-27 06:21:24.924989
388	1	2025-10-27 06:21:24.977483
389	1	2025-10-27 06:21:55.127597
390	1	2025-10-27 06:21:55.178013
391	1	2025-10-27 06:21:55.227975
392	1	2025-10-27 06:21:55.277973
393	1	2025-10-27 06:21:55.327927
394	1	2025-10-27 06:21:55.378177
395	1	2025-10-27 06:21:55.428301
396	1	2025-10-27 06:21:55.478245
397	1	2025-10-27 06:21:55.530054
398	1	2025-10-27 06:21:55.579414
399	1	2025-10-27 06:21:55.629872
400	1	2025-10-27 06:21:55.679655
401	1	2025-10-27 06:21:55.72938
402	1	2025-10-27 06:21:55.778687
403	1	2025-10-27 06:21:55.827662
404	1	2025-10-27 06:21:55.877471
405	1	2025-10-27 06:21:55.92739
406	1	2025-10-28 11:23:05.412019
407	1	2025-10-28 11:24:41.357277
408	1	2025-10-28 11:27:42.572473
409	1	2025-10-28 11:28:12.759874
410	1	2025-10-28 11:38:16.964066
411	1	2025-10-28 11:38:17.019326
412	1	2025-10-28 11:38:17.068935
413	1	2025-10-28 11:38:17.118318
414	1	2025-10-28 11:38:47.671317
415	1	2025-10-28 11:38:47.725786
416	1	2025-10-28 11:39:17.866967
417	1	2025-10-28 11:47:51.381191
418	1	2025-10-28 11:53:53.887671
419	1	2025-11-04 05:27:40.084407
420	1	2025-11-04 05:43:59.304034
421	1	2025-11-04 06:29:53.317016
422	1	2025-11-04 06:29:53.367433
423	1	2025-11-04 06:29:53.416929
424	1	2025-11-04 06:29:53.466454
425	1	2025-11-04 06:29:53.516487
426	1	2025-11-04 06:29:53.566929
427	1	2025-11-04 06:29:53.616447
428	1	2025-11-04 06:29:53.665952
429	1	2025-11-04 06:30:24.083043
430	1	2025-11-04 06:30:24.135436
431	1	2025-11-04 06:30:24.186416
432	1	2025-11-04 06:30:54.281929
433	1	2025-11-04 06:30:54.332979
434	1	2025-11-04 06:31:24.486477
435	1	2025-11-04 06:31:24.541157
436	1	2025-11-04 06:32:24.900187
437	1	2025-11-04 06:32:24.952501
438	1	2025-11-04 06:32:25.002694
439	1	2025-11-04 06:32:25.053021
440	1	2025-11-04 06:32:25.103439
441	1	2025-11-04 06:32:25.152887
442	1	2025-11-04 06:32:25.201855
443	1	2025-11-04 06:32:25.251354
444	1	2025-11-04 06:32:25.300692
445	1	2025-11-04 06:32:25.350593
446	1	2025-11-04 06:32:25.400253
447	1	2025-11-04 06:32:25.453008
448	1	2025-11-04 06:32:25.795367
449	1	2025-11-04 06:32:25.847672
450	1	2025-11-04 06:32:25.897264
451	1	2025-11-04 06:32:25.947135
452	1	2025-11-04 06:32:25.996654
453	1	2025-11-04 06:32:26.046247
454	1	2025-11-05 11:02:15.843757
455	1	2025-11-06 04:36:45.499306
456	1	2025-11-06 04:36:57.154895
457	1	2025-11-06 04:37:04.392776
458	1	2025-11-06 04:37:45.232832
459	1	2025-11-06 04:37:58.221863
460	1	2025-11-06 04:43:11.707784
461	1	2025-11-06 04:43:16.525931
462	1	2025-11-06 04:45:08.615102
463	1	2025-11-06 04:47:25.081624
464	1	2025-11-06 04:47:25.151305
465	1	2025-11-06 04:47:25.218837
466	1	2025-11-06 04:47:25.36505
467	1	2025-11-06 04:47:25.513871
468	1	2025-11-06 04:47:25.582113
469	1	2025-11-06 04:47:25.665239
470	1	2025-11-06 04:48:32.656715
571	1	2026-04-23 06:33:58.114361
572	1	2026-04-24 09:36:52.959043
574	1	2026-05-04 08:07:14.781314
575	1	2026-05-06 06:22:00.770645
576	1	2026-05-07 05:02:34.730238
578	1	2026-05-11 07:48:38.395465
579	1	2026-05-11 09:57:58.491828
581	1	2026-05-19 05:20:53.134437
582	1	2026-05-19 06:27:24.731655
583	1	2026-05-19 10:22:04.186828
584	1	2026-05-20 05:26:22.799615
585	1	2026-05-20 08:33:16.956115
586	1	2026-05-20 10:55:24.069513
587	1	2026-05-20 11:41:12.152793
588	1	2026-05-20 14:05:18.050867
589	1	2026-05-20 14:07:04.806847
590	1	2026-05-21 03:48:59.505168
591	1	2026-05-21 03:56:12.185606
592	1	2026-05-21 09:48:39.090274
593	1	2026-05-21 10:11:14.041706
594	1	2026-05-22 09:30:04.672252
595	1	2026-05-23 03:59:58.314216
603	1	2026-05-25 04:30:19.833632
604	1	2026-05-25 04:32:09.463501
605	1	2026-05-25 04:32:25.05359
606	1	2026-05-25 04:32:46.374449
607	1	2026-05-25 06:28:50.581364
609	1	2026-05-26 06:56:18.159073
610	1	2026-05-29 09:44:03.270549
611	1	2026-06-01 05:13:40.175665
612	1	2026-06-01 12:17:16.002211
613	1	2026-06-01 12:17:16.055762
614	1	2026-06-01 12:17:16.105718
615	1	2026-06-02 03:42:53.486619
616	1	2026-06-02 05:14:09.489945
471	1	2025-11-06 04:52:30.298765
472	1	2025-11-06 04:56:58.047672
473	1	2025-11-19 10:28:57.973318
474	1	2025-11-21 04:19:28.468329
475	1	2025-11-27 06:48:34.465777
476	1	2025-11-27 06:50:40.390224
477	1	2025-11-27 06:50:40.443152
478	1	2025-11-27 06:50:40.493327
479	1	2025-11-27 06:50:40.543099
480	1	2025-11-27 06:50:40.593068
481	1	2025-11-27 06:50:40.642617
482	1	2025-12-05 03:42:23.759882
483	1	2025-12-05 04:09:43.743834
484	1	2025-12-05 04:10:20.861328
485	1	2025-12-05 04:11:28.466775
486	1	2025-12-05 04:11:57.516485
487	1	2025-12-05 04:12:09.248575
488	1	2025-12-05 04:17:43.042116
489	1	2025-12-05 04:18:38.757099
490	1	2025-12-05 04:18:51.886465
491	1	2025-12-05 04:18:53.440912
492	1	2025-12-05 04:18:53.543944
493	1	2025-12-05 04:18:53.698276
494	1	2025-12-05 04:18:53.868049
495	1	2025-12-05 04:18:54.04203
496	1	2025-12-05 04:18:54.217193
497	1	2025-12-05 04:18:54.406936
498	1	2025-12-05 04:18:54.565392
499	1	2025-12-05 04:18:54.745691
500	1	2025-12-05 04:18:54.92398
501	1	2025-12-05 04:18:55.080758
502	1	2025-12-05 04:20:40.603632
503	1	2025-12-05 04:23:31.0505
504	1	2025-12-05 04:23:31.155793
505	1	2025-12-05 06:37:59.858933
506	1	2025-12-09 03:44:55.093965
507	1	2025-12-11 04:05:19.131072
508	1	2025-12-11 05:21:19.583998
509	1	2025-12-15 08:33:53.389782
510	1	2025-12-16 09:32:04.124913
511	1	2025-12-17 04:32:54.638265
512	1	2025-12-17 08:30:43.13583
513	1	2025-12-22 12:44:18.312056
514	1	2026-01-20 08:25:05.206358
515	1	2026-01-28 06:52:31.57882
516	1	2026-01-28 06:52:49.120088
517	1	2026-01-28 06:52:56.895603
518	1	2026-01-28 06:53:26.096106
519	1	2026-01-28 06:53:26.280772
520	1	2026-01-28 06:53:26.462489
521	1	2026-01-28 06:53:26.688488
522	1	2026-01-28 06:53:30.307622
523	1	2026-01-28 07:13:34.469206
524	1	2026-01-28 07:14:10.149178
525	1	2026-01-28 07:14:10.21602
526	1	2026-01-28 07:14:10.280306
527	1	2026-01-28 07:15:13.686856
528	1	2026-01-28 07:16:09.004366
529	1	2026-01-28 08:29:05.3188
530	1	2026-01-28 08:29:54.571735
531	1	2026-01-28 08:39:04.344892
532	7	2026-01-28 08:39:56.675369
533	1	2026-01-28 08:40:46.361511
534	1	2026-01-28 09:00:55.357518
535	1	2026-01-28 11:03:01.680684
536	1	2026-01-28 11:27:38.767738
537	1	2026-01-29 05:09:09.563396
538	1	2026-02-24 12:33:26.190051
539	1	2026-02-26 07:33:29.831132
540	1	2026-03-23 10:47:36.523363
541	1	2026-03-24 05:10:14.3595
542	1	2026-03-30 06:02:42.337584
543	1	2026-03-30 06:52:47.478975
544	1	2026-03-31 11:35:09.74755
545	1	2026-03-31 11:37:23.494358
546	1	2026-03-31 11:38:20.345365
547	1	2026-03-31 11:38:45.537082
548	1	2026-04-02 05:21:07.517542
549	1	2026-04-02 08:27:18.627198
550	1	2026-04-09 06:12:10.163879
551	1	2026-04-10 06:53:14.925324
552	1	2026-04-10 06:54:37.073396
553	1	2026-04-10 06:55:20.85539
554	1	2026-04-10 07:05:31.235511
555	1	2026-04-10 08:46:32.741547
556	1	2026-04-10 08:48:50.821032
557	1	2026-04-10 09:13:33.89046
558	1	2026-04-10 09:40:37.67142
559	1	2026-04-10 11:37:42.644964
560	1	2026-04-13 04:20:07.883316
561	1	2026-04-13 05:10:52.454022
562	1	2026-04-17 09:23:52.548915
563	1	2026-04-18 03:50:14.371914
564	1	2026-04-18 07:13:22.342396
565	1	2026-04-20 12:52:55.819148
566	1	2026-04-21 04:23:57.541327
567	1	2026-04-21 07:26:27.952696
568	1	2026-04-21 08:26:47.516595
569	1	2026-04-21 08:38:07.453513
570	1	2026-04-21 09:05:02.91017
573	1	2026-04-24 12:25:14.265351
577	1	2026-05-07 06:26:03.46625
580	1	2026-05-11 11:56:54.806232
596	1	2026-05-23 05:20:02.323971
597	1	2026-05-23 05:20:16.944116
598	1	2026-05-23 05:20:42.297477
599	1	2026-05-23 06:07:55.24613
600	1	2026-05-23 06:09:57.385962
601	1	2026-05-23 06:13:54.461254
602	1	2026-05-23 06:14:01.312222
608	1	2026-05-25 08:53:32.82372
\.


--
-- TOC entry 3709 (class 0 OID 0)
-- Dependencies: 218
-- Name: UpdateLog_id_seq; Type: SEQUENCE SET; Schema: tiei_sample_5; Owner: postgres
--

SELECT pg_catalog.setval('tiei_sample_5."UpdateLog_id_seq"', 50, true);


--
-- TOC entry 3710 (class 0 OID 0)
-- Dependencies: 221
-- Name: corrective_activity_id_seq; Type: SEQUENCE SET; Schema: tiei_sample_5; Owner: postgres
--

SELECT pg_catalog.setval('tiei_sample_5.corrective_activity_id_seq', 5, true);


--
-- TOC entry 3711 (class 0 OID 0)
-- Dependencies: 223
-- Name: emailuser_id_seq; Type: SEQUENCE SET; Schema: tiei_sample_5; Owner: postgres
--

SELECT pg_catalog.setval('tiei_sample_5.emailuser_id_seq', 1, false);


--
-- TOC entry 3712 (class 0 OID 0)
-- Dependencies: 225
-- Name: event_static_machine_parameters_id_seq; Type: SEQUENCE SET; Schema: tiei_sample_5; Owner: postgres
--

SELECT pg_catalog.setval('tiei_sample_5.event_static_machine_parameters_id_seq', 1, false);


--
-- TOC entry 3713 (class 0 OID 0)
-- Dependencies: 227
-- Name: events_id_seq; Type: SEQUENCE SET; Schema: tiei_sample_5; Owner: postgres
--

SELECT pg_catalog.setval('tiei_sample_5.events_id_seq', 1, false);


--
-- TOC entry 3714 (class 0 OID 0)
-- Dependencies: 229
-- Name: ignored_parameter_id_seq; Type: SEQUENCE SET; Schema: tiei_sample_5; Owner: postgres
--

SELECT pg_catalog.setval('tiei_sample_5.ignored_parameter_id_seq', 1, false);


--
-- TOC entry 3715 (class 0 OID 0)
-- Dependencies: 231
-- Name: machine_event_timeline_id_seq; Type: SEQUENCE SET; Schema: tiei_sample_5; Owner: postgres
--

SELECT pg_catalog.setval('tiei_sample_5.machine_event_timeline_id_seq', 1, false);


--
-- TOC entry 3716 (class 0 OID 0)
-- Dependencies: 233
-- Name: machine_parameters_id_seq; Type: SEQUENCE SET; Schema: tiei_sample_5; Owner: postgres
--

SELECT pg_catalog.setval('tiei_sample_5.machine_parameters_id_seq', 1, false);


--
-- TOC entry 3717 (class 0 OID 0)
-- Dependencies: 235
-- Name: machine_production_timeline_id_seq; Type: SEQUENCE SET; Schema: tiei_sample_5; Owner: postgres
--

SELECT pg_catalog.setval('tiei_sample_5.machine_production_timeline_id_seq', 1, false);


--
-- TOC entry 3718 (class 0 OID 0)
-- Dependencies: 237
-- Name: machinepartcount_id_seq; Type: SEQUENCE SET; Schema: tiei_sample_5; Owner: postgres
--

SELECT pg_catalog.setval('tiei_sample_5.machinepartcount_id_seq', 1, false);


--
-- TOC entry 3719 (class 0 OID 0)
-- Dependencies: 239
-- Name: machines_id_seq; Type: SEQUENCE SET; Schema: tiei_sample_5; Owner: postgres
--

SELECT pg_catalog.setval('tiei_sample_5.machines_id_seq', 1, false);


--
-- TOC entry 3720 (class 0 OID 0)
-- Dependencies: 241
-- Name: parameter_comparison_id_seq; Type: SEQUENCE SET; Schema: tiei_sample_5; Owner: postgres
--

SELECT pg_catalog.setval('tiei_sample_5.parameter_comparison_id_seq', 17, true);


--
-- TOC entry 3721 (class 0 OID 0)
-- Dependencies: 243
-- Name: parameter_conditions_id_seq; Type: SEQUENCE SET; Schema: tiei_sample_5; Owner: postgres
--

SELECT pg_catalog.setval('tiei_sample_5.parameter_conditions_id_seq', 1, false);


--
-- TOC entry 3722 (class 0 OID 0)
-- Dependencies: 245
-- Name: parameters_group_id_seq; Type: SEQUENCE SET; Schema: tiei_sample_5; Owner: postgres
--

SELECT pg_catalog.setval('tiei_sample_5.parameters_group_id_seq', 1, false);


--
-- TOC entry 3723 (class 0 OID 0)
-- Dependencies: 248
-- Name: real_time_machine_parameters_active_id_seq; Type: SEQUENCE SET; Schema: tiei_sample_5; Owner: postgres
--

SELECT pg_catalog.setval('tiei_sample_5.real_time_machine_parameters_active_id_seq', 1, false);


--
-- TOC entry 3724 (class 0 OID 0)
-- Dependencies: 252
-- Name: spare_part_activity_history_id_seq; Type: SEQUENCE SET; Schema: tiei_sample_5; Owner: postgres
--

SELECT pg_catalog.setval('tiei_sample_5.spare_part_activity_history_id_seq', 1, false);


--
-- TOC entry 3725 (class 0 OID 0)
-- Dependencies: 253
-- Name: spare_part_activity_id_seq; Type: SEQUENCE SET; Schema: tiei_sample_5; Owner: postgres
--

SELECT pg_catalog.setval('tiei_sample_5.spare_part_activity_id_seq', 1, false);


--
-- TOC entry 3726 (class 0 OID 0)
-- Dependencies: 254
-- Name: spare_part_id_seq; Type: SEQUENCE SET; Schema: tiei_sample_5; Owner: postgres
--

SELECT pg_catalog.setval('tiei_sample_5.spare_part_id_seq', 8, true);


--
-- TOC entry 3727 (class 0 OID 0)
-- Dependencies: 256
-- Name: units_id_seq; Type: SEQUENCE SET; Schema: tiei_sample_5; Owner: postgres
--

SELECT pg_catalog.setval('tiei_sample_5.units_id_seq', 1, false);


--
-- TOC entry 3728 (class 0 OID 0)
-- Dependencies: 259
-- Name: user_access_log_id_seq; Type: SEQUENCE SET; Schema: tiei_sample_5; Owner: postgres
--

SELECT pg_catalog.setval('tiei_sample_5.user_access_log_id_seq', 616, true);


--
-- TOC entry 3729 (class 0 OID 0)
-- Dependencies: 260
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: tiei_sample_5; Owner: postgres
--

SELECT pg_catalog.setval('tiei_sample_5.user_id_seq', 7, true);


--
-- TOC entry 3381 (class 2606 OID 16937)
-- Name: UpdateLog UpdateLog_pkey; Type: CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5."UpdateLog"
    ADD CONSTRAINT "UpdateLog_pkey" PRIMARY KEY (id);


--
-- TOC entry 3383 (class 2606 OID 16939)
-- Name: activities_history activities_history_pkey; Type: CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.activities_history
    ADD CONSTRAINT activities_history_pkey PRIMARY KEY (date_of_identification, machine_parameters_id);


--
-- TOC entry 3388 (class 2606 OID 16941)
-- Name: corrective_activity corrective_activity_pkey; Type: CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.corrective_activity
    ADD CONSTRAINT corrective_activity_pkey PRIMARY KEY (id);


--
-- TOC entry 3394 (class 2606 OID 16943)
-- Name: emailuser emailuser_pkey; Type: CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.emailuser
    ADD CONSTRAINT emailuser_pkey PRIMARY KEY (id);


--
-- TOC entry 3396 (class 2606 OID 16945)
-- Name: event_static_machine_parameters event_static_machine_parameters_pkey; Type: CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.event_static_machine_parameters
    ADD CONSTRAINT event_static_machine_parameters_pkey PRIMARY KEY (id);


--
-- TOC entry 3400 (class 2606 OID 16947)
-- Name: events events_pkey; Type: CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- TOC entry 3403 (class 2606 OID 16949)
-- Name: ignored_parameter ignored_parameter_pkey; Type: CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.ignored_parameter
    ADD CONSTRAINT ignored_parameter_pkey PRIMARY KEY (id);


--
-- TOC entry 3407 (class 2606 OID 16951)
-- Name: machine_event_timeline machine_event_timeline_pkey; Type: CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.machine_event_timeline
    ADD CONSTRAINT machine_event_timeline_pkey PRIMARY KEY (id);


--
-- TOC entry 3412 (class 2606 OID 16953)
-- Name: machine_parameters machine_parameters_pkey; Type: CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.machine_parameters
    ADD CONSTRAINT machine_parameters_pkey PRIMARY KEY (id);


--
-- TOC entry 3416 (class 2606 OID 16955)
-- Name: machine_production_timeline machine_production_timeline_pkey; Type: CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.machine_production_timeline
    ADD CONSTRAINT machine_production_timeline_pkey PRIMARY KEY (id);


--
-- TOC entry 3419 (class 2606 OID 16957)
-- Name: machinepartcount machinepartcount_pkey; Type: CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.machinepartcount
    ADD CONSTRAINT machinepartcount_pkey PRIMARY KEY (id);


--
-- TOC entry 3421 (class 2606 OID 16959)
-- Name: machines machines_pkey; Type: CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.machines
    ADD CONSTRAINT machines_pkey PRIMARY KEY (id);


--
-- TOC entry 3428 (class 2606 OID 16961)
-- Name: parameter_comparison parameter_comparison_pkey; Type: CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.parameter_comparison
    ADD CONSTRAINT parameter_comparison_pkey PRIMARY KEY (id);


--
-- TOC entry 3430 (class 2606 OID 16963)
-- Name: parameter_conditions parameter_conditions_pkey; Type: CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.parameter_conditions
    ADD CONSTRAINT parameter_conditions_pkey PRIMARY KEY (id);


--
-- TOC entry 3432 (class 2606 OID 16965)
-- Name: parameters_group parameters_group_pkey; Type: CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.parameters_group
    ADD CONSTRAINT parameters_group_pkey PRIMARY KEY (id);


--
-- TOC entry 3440 (class 2606 OID 16967)
-- Name: real_time_machine_parameters_active real_time_machine_parameters_active_pkey; Type: CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.real_time_machine_parameters_active
    ADD CONSTRAINT real_time_machine_parameters_active_pkey PRIMARY KEY (id);


--
-- TOC entry 3436 (class 2606 OID 16969)
-- Name: real_time_machine_parameters real_time_machine_parameters_pkey; Type: CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.real_time_machine_parameters
    ADD CONSTRAINT real_time_machine_parameters_pkey PRIMARY KEY ("time", machine_parameters_id);


--
-- TOC entry 3453 (class 2606 OID 16971)
-- Name: spare_part_activity_history spare_part_activity_history_pkey; Type: CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.spare_part_activity_history
    ADD CONSTRAINT spare_part_activity_history_pkey PRIMARY KEY (id);


--
-- TOC entry 3448 (class 2606 OID 16973)
-- Name: spare_part_activity spare_part_activity_pkey; Type: CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.spare_part_activity
    ADD CONSTRAINT spare_part_activity_pkey PRIMARY KEY (id);


--
-- TOC entry 3443 (class 2606 OID 16975)
-- Name: spare_part spare_part_pkey; Type: CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.spare_part
    ADD CONSTRAINT spare_part_pkey PRIMARY KEY (id);


--
-- TOC entry 3455 (class 2606 OID 16977)
-- Name: units units_pkey; Type: CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.units
    ADD CONSTRAINT units_pkey PRIMARY KEY (id);


--
-- TOC entry 3461 (class 2606 OID 16979)
-- Name: user_access_log user_access_log_pkey; Type: CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.user_access_log
    ADD CONSTRAINT user_access_log_pkey PRIMARY KEY (id);


--
-- TOC entry 3458 (class 2606 OID 16981)
-- Name: user user_pkey; Type: CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- TOC entry 3384 (class 1259 OID 16982)
-- Name: idx_activities_history__machine_parameters_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_activities_history__machine_parameters_id ON tiei_sample_5.activities_history USING btree (machine_parameters_id);


--
-- TOC entry 3385 (class 1259 OID 16983)
-- Name: idx_activities_history__parameter_condition_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_activities_history__parameter_condition_id ON tiei_sample_5.activities_history USING btree (parameter_condition_id);


--
-- TOC entry 3386 (class 1259 OID 16984)
-- Name: idx_activities_history__responsible_person_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_activities_history__responsible_person_id ON tiei_sample_5.activities_history USING btree (responsible_person_id);


--
-- TOC entry 3389 (class 1259 OID 16985)
-- Name: idx_corrective_activity__parameter_condition_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_corrective_activity__parameter_condition_id ON tiei_sample_5.corrective_activity USING btree (parameter_condition_id);


--
-- TOC entry 3390 (class 1259 OID 16986)
-- Name: idx_corrective_activity__responsible_person_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_corrective_activity__responsible_person_id ON tiei_sample_5.corrective_activity USING btree (responsible_person_id);


--
-- TOC entry 3391 (class 1259 OID 16987)
-- Name: idx_date_of_identification; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_date_of_identification ON tiei_sample_5.corrective_activity USING btree (date_of_identification);


--
-- TOC entry 3397 (class 1259 OID 16988)
-- Name: idx_event_static_machine_parameters__machine_event_timeline_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_event_static_machine_parameters__machine_event_timeline_id ON tiei_sample_5.event_static_machine_parameters USING btree (machine_event_timeline_id);


--
-- TOC entry 3398 (class 1259 OID 16989)
-- Name: idx_event_static_machine_parameters__machine_parameters_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_event_static_machine_parameters__machine_parameters_id ON tiei_sample_5.event_static_machine_parameters USING btree (machine_parameters_id);


--
-- TOC entry 3401 (class 1259 OID 16990)
-- Name: idx_ignored_parameter__machine_parameter_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_ignored_parameter__machine_parameter_id ON tiei_sample_5.ignored_parameter USING btree (machine_parameter_id);


--
-- TOC entry 3404 (class 1259 OID 16991)
-- Name: idx_machine_event_timeline__events_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_machine_event_timeline__events_id ON tiei_sample_5.machine_event_timeline USING btree (events_id);


--
-- TOC entry 3405 (class 1259 OID 16992)
-- Name: idx_machine_event_timeline__machine_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_machine_event_timeline__machine_id ON tiei_sample_5.machine_event_timeline USING btree (machine_id);


--
-- TOC entry 3392 (class 1259 OID 16993)
-- Name: idx_machine_parameter_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_machine_parameter_id ON tiei_sample_5.corrective_activity USING btree (machine_parameters_id);


--
-- TOC entry 3408 (class 1259 OID 16994)
-- Name: idx_machine_parameters__machine_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_machine_parameters__machine_id ON tiei_sample_5.machine_parameters USING btree (machine_id);


--
-- TOC entry 3409 (class 1259 OID 16995)
-- Name: idx_machine_parameters__parameter_group_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_machine_parameters__parameter_group_id ON tiei_sample_5.machine_parameters USING btree (parameter_group_id);


--
-- TOC entry 3410 (class 1259 OID 16996)
-- Name: idx_machine_parameters__unit_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_machine_parameters__unit_id ON tiei_sample_5.machine_parameters USING btree (unit_id);


--
-- TOC entry 3413 (class 1259 OID 16997)
-- Name: idx_machine_production_timeline__machine_event_timeline_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_machine_production_timeline__machine_event_timeline_id ON tiei_sample_5.machine_production_timeline USING btree (machine_event_timeline_id);


--
-- TOC entry 3414 (class 1259 OID 16998)
-- Name: idx_machine_production_timeline__machine_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_machine_production_timeline__machine_id ON tiei_sample_5.machine_production_timeline USING btree (machine_id);


--
-- TOC entry 3417 (class 1259 OID 16999)
-- Name: idx_machinepartcount__machine_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_machinepartcount__machine_id ON tiei_sample_5.machinepartcount USING btree (machine_id);


--
-- TOC entry 3422 (class 1259 OID 17000)
-- Name: idx_parameter_comparison__condition_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_parameter_comparison__condition_id ON tiei_sample_5.parameter_comparison USING btree (condition_id);


--
-- TOC entry 3423 (class 1259 OID 17001)
-- Name: idx_parameter_comparison__machine_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_parameter_comparison__machine_id ON tiei_sample_5.parameter_comparison USING btree (machine_id);


--
-- TOC entry 3424 (class 1259 OID 17002)
-- Name: idx_parameter_comparison__machine_parameter1_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_parameter_comparison__machine_parameter1_id ON tiei_sample_5.parameter_comparison USING btree (machine_parameter1_id);


--
-- TOC entry 3425 (class 1259 OID 17003)
-- Name: idx_parameter_comparison__machine_parameter2_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_parameter_comparison__machine_parameter2_id ON tiei_sample_5.parameter_comparison USING btree (machine_parameter2_id);


--
-- TOC entry 3426 (class 1259 OID 17004)
-- Name: idx_parameter_comparison__parameter_group_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_parameter_comparison__parameter_group_id ON tiei_sample_5.parameter_comparison USING btree (parameter_group_id);


--
-- TOC entry 3433 (class 1259 OID 17005)
-- Name: idx_real_time_machine_parameters__condition_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_real_time_machine_parameters__condition_id ON tiei_sample_5.real_time_machine_parameters USING btree (condition_id);


--
-- TOC entry 3434 (class 1259 OID 17006)
-- Name: idx_real_time_machine_parameters__machine_parameters_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_real_time_machine_parameters__machine_parameters_id ON tiei_sample_5.real_time_machine_parameters USING btree (machine_parameters_id);


--
-- TOC entry 3437 (class 1259 OID 17007)
-- Name: idx_real_time_machine_parameters_active__condition_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_real_time_machine_parameters_active__condition_id ON tiei_sample_5.real_time_machine_parameters_active USING btree (condition_id);


--
-- TOC entry 3438 (class 1259 OID 17008)
-- Name: idx_real_time_machine_parameters_active__machine_parameters_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_real_time_machine_parameters_active__machine_parameters_id ON tiei_sample_5.real_time_machine_parameters_active USING btree (machine_parameters_id);


--
-- TOC entry 3441 (class 1259 OID 17009)
-- Name: idx_spare_part__machine_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_spare_part__machine_id ON tiei_sample_5.spare_part USING btree (machine_id);


--
-- TOC entry 3444 (class 1259 OID 17010)
-- Name: idx_spare_part_activity__machine_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_spare_part_activity__machine_id ON tiei_sample_5.spare_part_activity USING btree (machine_id);


--
-- TOC entry 3445 (class 1259 OID 17011)
-- Name: idx_spare_part_activity__responsible_person_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_spare_part_activity__responsible_person_id ON tiei_sample_5.spare_part_activity USING btree (responsible_person_id);


--
-- TOC entry 3446 (class 1259 OID 17012)
-- Name: idx_spare_part_activity__spare_part_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_spare_part_activity__spare_part_id ON tiei_sample_5.spare_part_activity USING btree (spare_part_id);


--
-- TOC entry 3449 (class 1259 OID 17013)
-- Name: idx_spare_part_activity_history__machine_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_spare_part_activity_history__machine_id ON tiei_sample_5.spare_part_activity_history USING btree (machine_id);


--
-- TOC entry 3450 (class 1259 OID 17014)
-- Name: idx_spare_part_activity_history__responsible_person_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_spare_part_activity_history__responsible_person_id ON tiei_sample_5.spare_part_activity_history USING btree (responsible_person_id);


--
-- TOC entry 3451 (class 1259 OID 17015)
-- Name: idx_spare_part_activity_history__spare_part_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_spare_part_activity_history__spare_part_id ON tiei_sample_5.spare_part_activity_history USING btree (spare_part_id);


--
-- TOC entry 3459 (class 1259 OID 17016)
-- Name: idx_user_access_log__user_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_user_access_log__user_id ON tiei_sample_5.user_access_log USING btree (user_id);


--
-- TOC entry 3456 (class 1259 OID 17017)
-- Name: idx_user_company_id; Type: INDEX; Schema: tiei_sample_5; Owner: postgres
--

CREATE INDEX idx_user_company_id ON tiei_sample_5."user" USING btree (company_id);


--
-- TOC entry 3462 (class 2606 OID 17018)
-- Name: activities_history fk_activities_history__machine_parameters_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.activities_history
    ADD CONSTRAINT fk_activities_history__machine_parameters_id FOREIGN KEY (machine_parameters_id) REFERENCES tiei_sample_5.machine_parameters(id) ON DELETE CASCADE;


--
-- TOC entry 3463 (class 2606 OID 17023)
-- Name: activities_history fk_activities_history__parameter_condition_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.activities_history
    ADD CONSTRAINT fk_activities_history__parameter_condition_id FOREIGN KEY (parameter_condition_id) REFERENCES tiei_sample_5.parameter_conditions(id) ON DELETE SET NULL;


--
-- TOC entry 3464 (class 2606 OID 17028)
-- Name: activities_history fk_activities_history__responsible_person_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.activities_history
    ADD CONSTRAINT fk_activities_history__responsible_person_id FOREIGN KEY (responsible_person_id) REFERENCES tiei_sample_5."user"(id) ON DELETE SET NULL;


--
-- TOC entry 3465 (class 2606 OID 17033)
-- Name: corrective_activity fk_corrective_activity__machine_parameters_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.corrective_activity
    ADD CONSTRAINT fk_corrective_activity__machine_parameters_id FOREIGN KEY (machine_parameters_id) REFERENCES tiei_sample_5.machine_parameters(id);


--
-- TOC entry 3466 (class 2606 OID 17038)
-- Name: corrective_activity fk_corrective_activity__parameter_condition_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.corrective_activity
    ADD CONSTRAINT fk_corrective_activity__parameter_condition_id FOREIGN KEY (parameter_condition_id) REFERENCES tiei_sample_5.parameter_conditions(id) ON DELETE SET NULL;


--
-- TOC entry 3467 (class 2606 OID 17043)
-- Name: corrective_activity fk_corrective_activity__responsible_person_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.corrective_activity
    ADD CONSTRAINT fk_corrective_activity__responsible_person_id FOREIGN KEY (responsible_person_id) REFERENCES tiei_sample_5."user"(id) ON DELETE SET NULL;


--
-- TOC entry 3468 (class 2606 OID 17048)
-- Name: event_static_machine_parameters fk_event_static_machine_parameters__machine_event_timeline_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.event_static_machine_parameters
    ADD CONSTRAINT fk_event_static_machine_parameters__machine_event_timeline_id FOREIGN KEY (machine_event_timeline_id) REFERENCES tiei_sample_5.machine_event_timeline(id) ON DELETE CASCADE;


--
-- TOC entry 3469 (class 2606 OID 17053)
-- Name: event_static_machine_parameters fk_event_static_machine_parameters__machine_parameters_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.event_static_machine_parameters
    ADD CONSTRAINT fk_event_static_machine_parameters__machine_parameters_id FOREIGN KEY (machine_parameters_id) REFERENCES tiei_sample_5.machine_parameters(id) ON DELETE CASCADE;


--
-- TOC entry 3470 (class 2606 OID 17058)
-- Name: ignored_parameter fk_ignored_parameter__machine_parameter_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.ignored_parameter
    ADD CONSTRAINT fk_ignored_parameter__machine_parameter_id FOREIGN KEY (machine_parameter_id) REFERENCES tiei_sample_5.machine_parameters(id);


--
-- TOC entry 3471 (class 2606 OID 17063)
-- Name: machine_event_timeline fk_machine_event_timeline__events_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.machine_event_timeline
    ADD CONSTRAINT fk_machine_event_timeline__events_id FOREIGN KEY (events_id) REFERENCES tiei_sample_5.events(id) ON DELETE CASCADE;


--
-- TOC entry 3472 (class 2606 OID 17068)
-- Name: machine_event_timeline fk_machine_event_timeline__machine_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.machine_event_timeline
    ADD CONSTRAINT fk_machine_event_timeline__machine_id FOREIGN KEY (machine_id) REFERENCES tiei_sample_5.machines(id) ON DELETE CASCADE;


--
-- TOC entry 3473 (class 2606 OID 17073)
-- Name: machine_parameters fk_machine_parameters__machine_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.machine_parameters
    ADD CONSTRAINT fk_machine_parameters__machine_id FOREIGN KEY (machine_id) REFERENCES tiei_sample_5.machines(id) ON DELETE CASCADE;


--
-- TOC entry 3474 (class 2606 OID 17078)
-- Name: machine_parameters fk_machine_parameters__parameter_group_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.machine_parameters
    ADD CONSTRAINT fk_machine_parameters__parameter_group_id FOREIGN KEY (parameter_group_id) REFERENCES tiei_sample_5.parameters_group(id) ON DELETE SET NULL;


--
-- TOC entry 3475 (class 2606 OID 17083)
-- Name: machine_parameters fk_machine_parameters__unit_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.machine_parameters
    ADD CONSTRAINT fk_machine_parameters__unit_id FOREIGN KEY (unit_id) REFERENCES tiei_sample_5.units(id) ON DELETE CASCADE;


--
-- TOC entry 3476 (class 2606 OID 17088)
-- Name: machine_production_timeline fk_machine_production_timeline__machine_event_timeline_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.machine_production_timeline
    ADD CONSTRAINT fk_machine_production_timeline__machine_event_timeline_id FOREIGN KEY (machine_event_timeline_id) REFERENCES tiei_sample_5.machine_event_timeline(id) ON DELETE CASCADE;


--
-- TOC entry 3477 (class 2606 OID 17093)
-- Name: machine_production_timeline fk_machine_production_timeline__machine_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.machine_production_timeline
    ADD CONSTRAINT fk_machine_production_timeline__machine_id FOREIGN KEY (machine_id) REFERENCES tiei_sample_5.machines(id) ON DELETE CASCADE;


--
-- TOC entry 3478 (class 2606 OID 17098)
-- Name: machinepartcount fk_machinepartcount__machine_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.machinepartcount
    ADD CONSTRAINT fk_machinepartcount__machine_id FOREIGN KEY (machine_id) REFERENCES tiei_sample_5.machines(id);


--
-- TOC entry 3479 (class 2606 OID 17103)
-- Name: parameter_comparison fk_parameter_comparison__condition_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.parameter_comparison
    ADD CONSTRAINT fk_parameter_comparison__condition_id FOREIGN KEY (condition_id) REFERENCES tiei_sample_5.parameter_conditions(id) ON DELETE SET NULL;


--
-- TOC entry 3480 (class 2606 OID 17108)
-- Name: parameter_comparison fk_parameter_comparison__machine_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.parameter_comparison
    ADD CONSTRAINT fk_parameter_comparison__machine_id FOREIGN KEY (machine_id) REFERENCES tiei_sample_5.machines(id) ON DELETE SET NULL;


--
-- TOC entry 3481 (class 2606 OID 17113)
-- Name: parameter_comparison fk_parameter_comparison__machine_parameter1_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.parameter_comparison
    ADD CONSTRAINT fk_parameter_comparison__machine_parameter1_id FOREIGN KEY (machine_parameter1_id) REFERENCES tiei_sample_5.machine_parameters(id) ON DELETE SET NULL;


--
-- TOC entry 3482 (class 2606 OID 17118)
-- Name: parameter_comparison fk_parameter_comparison__machine_parameter2_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.parameter_comparison
    ADD CONSTRAINT fk_parameter_comparison__machine_parameter2_id FOREIGN KEY (machine_parameter2_id) REFERENCES tiei_sample_5.machine_parameters(id) ON DELETE SET NULL;


--
-- TOC entry 3483 (class 2606 OID 17123)
-- Name: parameter_comparison fk_parameter_comparison__parameter_group_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.parameter_comparison
    ADD CONSTRAINT fk_parameter_comparison__parameter_group_id FOREIGN KEY (parameter_group_id) REFERENCES tiei_sample_5.parameters_group(id) ON DELETE SET NULL;


--
-- TOC entry 3484 (class 2606 OID 17128)
-- Name: real_time_machine_parameters fk_real_time_machine_parameters__condition_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.real_time_machine_parameters
    ADD CONSTRAINT fk_real_time_machine_parameters__condition_id FOREIGN KEY (condition_id) REFERENCES tiei_sample_5.parameter_conditions(id) ON DELETE SET NULL;


--
-- TOC entry 3485 (class 2606 OID 17133)
-- Name: real_time_machine_parameters fk_real_time_machine_parameters__machine_parameters_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.real_time_machine_parameters
    ADD CONSTRAINT fk_real_time_machine_parameters__machine_parameters_id FOREIGN KEY (machine_parameters_id) REFERENCES tiei_sample_5.machine_parameters(id) ON DELETE CASCADE;


--
-- TOC entry 3486 (class 2606 OID 17138)
-- Name: real_time_machine_parameters_active fk_real_time_machine_parameters_active__condition_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.real_time_machine_parameters_active
    ADD CONSTRAINT fk_real_time_machine_parameters_active__condition_id FOREIGN KEY (condition_id) REFERENCES tiei_sample_5.parameter_conditions(id) ON DELETE CASCADE;


--
-- TOC entry 3487 (class 2606 OID 17143)
-- Name: real_time_machine_parameters_active fk_real_time_machine_parameters_active__machine_parameters_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.real_time_machine_parameters_active
    ADD CONSTRAINT fk_real_time_machine_parameters_active__machine_parameters_id FOREIGN KEY (machine_parameters_id) REFERENCES tiei_sample_5.machine_parameters(id);


--
-- TOC entry 3488 (class 2606 OID 17148)
-- Name: spare_part fk_spare_part__machine_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.spare_part
    ADD CONSTRAINT fk_spare_part__machine_id FOREIGN KEY (machine_id) REFERENCES tiei_sample_5.machines(id) ON DELETE CASCADE;


--
-- TOC entry 3489 (class 2606 OID 17153)
-- Name: spare_part_activity fk_spare_part_activity__machine_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.spare_part_activity
    ADD CONSTRAINT fk_spare_part_activity__machine_id FOREIGN KEY (machine_id) REFERENCES tiei_sample_5.machines(id) ON DELETE CASCADE;


--
-- TOC entry 3490 (class 2606 OID 17158)
-- Name: spare_part_activity fk_spare_part_activity__responsible_person_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.spare_part_activity
    ADD CONSTRAINT fk_spare_part_activity__responsible_person_id FOREIGN KEY (responsible_person_id) REFERENCES tiei_sample_5."user"(id) ON DELETE SET NULL;


--
-- TOC entry 3491 (class 2606 OID 17163)
-- Name: spare_part_activity fk_spare_part_activity__spare_part_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.spare_part_activity
    ADD CONSTRAINT fk_spare_part_activity__spare_part_id FOREIGN KEY (spare_part_id) REFERENCES tiei_sample_5.spare_part(id) ON DELETE CASCADE;


--
-- TOC entry 3492 (class 2606 OID 17168)
-- Name: spare_part_activity_history fk_spare_part_activity_history__machine_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.spare_part_activity_history
    ADD CONSTRAINT fk_spare_part_activity_history__machine_id FOREIGN KEY (machine_id) REFERENCES tiei_sample_5.machines(id) ON DELETE CASCADE;


--
-- TOC entry 3493 (class 2606 OID 17173)
-- Name: spare_part_activity_history fk_spare_part_activity_history__responsible_person_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.spare_part_activity_history
    ADD CONSTRAINT fk_spare_part_activity_history__responsible_person_id FOREIGN KEY (responsible_person_id) REFERENCES tiei_sample_5."user"(id) ON DELETE SET NULL;


--
-- TOC entry 3494 (class 2606 OID 17178)
-- Name: spare_part_activity_history fk_spare_part_activity_history__spare_part_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.spare_part_activity_history
    ADD CONSTRAINT fk_spare_part_activity_history__spare_part_id FOREIGN KEY (spare_part_id) REFERENCES tiei_sample_5.spare_part(id) ON DELETE CASCADE;


--
-- TOC entry 3495 (class 2606 OID 17183)
-- Name: user_access_log fk_user_access_log__user_id; Type: FK CONSTRAINT; Schema: tiei_sample_5; Owner: postgres
--

ALTER TABLE ONLY tiei_sample_5.user_access_log
    ADD CONSTRAINT fk_user_access_log__user_id FOREIGN KEY (user_id) REFERENCES tiei_sample_5."user"(id) ON DELETE CASCADE;


-- Completed on 2026-06-02 14:20:19

--
-- PostgreSQL database dump complete
--

\unrestrict ery40vEvYTtllR9RZJwTDqumoWBoANMPnfhhBsHa1uo9deDWjqBvnCupWAc3vDV

