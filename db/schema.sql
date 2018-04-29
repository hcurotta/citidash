--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: routes; Type: TABLE; Schema: public; Owner: harrycurotta; Tablespace: 
--

CREATE TABLE routes (
    id integer NOT NULL,
    origin_id integer,
    destination_id integer
);


ALTER TABLE routes OWNER TO harrycurotta;

--
-- Name: routes_id_seq; Type: SEQUENCE; Schema: public; Owner: harrycurotta
--

CREATE SEQUENCE routes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE routes_id_seq OWNER TO harrycurotta;

--
-- Name: routes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: harrycurotta
--

ALTER SEQUENCE routes_id_seq OWNED BY routes.id;


--
-- Name: schema_info; Type: TABLE; Schema: public; Owner: harrycurotta; Tablespace: 
--

CREATE TABLE schema_info (
    version integer DEFAULT 0 NOT NULL
);


ALTER TABLE schema_info OWNER TO harrycurotta;

--
-- Name: stations; Type: TABLE; Schema: public; Owner: harrycurotta; Tablespace: 
--

CREATE TABLE stations (
    id integer NOT NULL,
    citibike_station_id integer,
    name text,
    lat numeric,
    lon numeric,
    inactive boolean DEFAULT false
);


ALTER TABLE stations OWNER TO harrycurotta;

--
-- Name: stations_id_seq; Type: SEQUENCE; Schema: public; Owner: harrycurotta
--

CREATE SEQUENCE stations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE stations_id_seq OWNER TO harrycurotta;

--
-- Name: stations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: harrycurotta
--

ALTER SEQUENCE stations_id_seq OWNED BY stations.id;


--
-- Name: statistics; Type: TABLE; Schema: public; Owner: harrycurotta; Tablespace: 
--

CREATE TABLE statistics (
    id integer NOT NULL,
    user_id integer,
    trip_count integer,
    total_duration_in_seconds integer,
    distance_travelled integer
);


ALTER TABLE statistics OWNER TO harrycurotta;

--
-- Name: statistics_id_seq; Type: SEQUENCE; Schema: public; Owner: harrycurotta
--

CREATE SEQUENCE statistics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE statistics_id_seq OWNER TO harrycurotta;

--
-- Name: statistics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: harrycurotta
--

ALTER SEQUENCE statistics_id_seq OWNED BY statistics.id;


--
-- Name: trips; Type: TABLE; Schema: public; Owner: harrycurotta; Tablespace: 
--

CREATE TABLE trips (
    id integer NOT NULL,
    user_id integer,
    route_id integer,
    origin_id integer,
    destination_id integer,
    started_at timestamp without time zone,
    ended_at timestamp without time zone,
    duration_in_seconds integer
);


ALTER TABLE trips OWNER TO harrycurotta;

--
-- Name: trips_id_seq; Type: SEQUENCE; Schema: public; Owner: harrycurotta
--

CREATE SEQUENCE trips_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE trips_id_seq OWNER TO harrycurotta;

--
-- Name: trips_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: harrycurotta
--

ALTER SEQUENCE trips_id_seq OWNED BY trips.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: harrycurotta; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email text,
    encrypted_password text,
    password_iv text,
    first_name text,
    last_name text,
    short_name text,
    citibike_id text NOT NULL
);


ALTER TABLE users OWNER TO harrycurotta;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: harrycurotta
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_id_seq OWNER TO harrycurotta;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: harrycurotta
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: harrycurotta
--

ALTER TABLE ONLY routes ALTER COLUMN id SET DEFAULT nextval('routes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: harrycurotta
--

ALTER TABLE ONLY stations ALTER COLUMN id SET DEFAULT nextval('stations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: harrycurotta
--

ALTER TABLE ONLY statistics ALTER COLUMN id SET DEFAULT nextval('statistics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: harrycurotta
--

ALTER TABLE ONLY trips ALTER COLUMN id SET DEFAULT nextval('trips_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: harrycurotta
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: routes_pkey; Type: CONSTRAINT; Schema: public; Owner: harrycurotta; Tablespace: 
--

ALTER TABLE ONLY routes
    ADD CONSTRAINT routes_pkey PRIMARY KEY (id);


--
-- Name: stations_pkey; Type: CONSTRAINT; Schema: public; Owner: harrycurotta; Tablespace: 
--

ALTER TABLE ONLY stations
    ADD CONSTRAINT stations_pkey PRIMARY KEY (id);


--
-- Name: statistics_pkey; Type: CONSTRAINT; Schema: public; Owner: harrycurotta; Tablespace: 
--

ALTER TABLE ONLY statistics
    ADD CONSTRAINT statistics_pkey PRIMARY KEY (id);


--
-- Name: trips_pkey; Type: CONSTRAINT; Schema: public; Owner: harrycurotta; Tablespace: 
--

ALTER TABLE ONLY trips
    ADD CONSTRAINT trips_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: harrycurotta; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: public; Type: ACL; Schema: -; Owner: harrycurotta
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM harrycurotta;
GRANT ALL ON SCHEMA public TO harrycurotta;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

