--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: lsh_user
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO lsh_user;

--
-- Name: assignment; Type: TABLE; Schema: public; Owner: lsh_user
--

CREATE TABLE public.assignment (
    id integer NOT NULL,
    start_date character varying(100),
    end_date character varying(100),
    formatted_start_date character varying(100),
    formatted_end_time character varying(100),
    event_id integer NOT NULL,
    trainer_id integer,
    trainer_status character varying(50),
    "isLead" boolean,
    resource_id integer
);


ALTER TABLE public.assignment OWNER TO lsh_user;

--
-- Name: assignment_id_seq; Type: SEQUENCE; Schema: public; Owner: lsh_user
--

ALTER TABLE public.assignment ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.assignment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: event; Type: TABLE; Schema: public; Owner: lsh_user
--

CREATE TABLE public.event (
    id integer NOT NULL,
    name character varying(50),
    email character varying(50),
    phone character varying(16),
    title character varying(50),
    training_types character varying(500),
    mission character varying(500),
    num_learners integer,
    learners character varying(500),
    place character varying(500),
    chairs_tables character varying(300),
    cultural character varying(500),
    content_concerns character varying(500),
    music character varying(300),
    photos character varying(200),
    other_info character varying(1500),
    status character varying(100),
    admin_notes character varying(500)
);


ALTER TABLE public.event OWNER TO lsh_user;

--
-- Name: event_date; Type: TABLE; Schema: public; Owner: lsh_user
--

CREATE TABLE public.event_date (
    id integer NOT NULL,
    start_date timestamp with time zone,
    end_date timestamp with time zone,
    formatted_start_date character varying(100),
    formatted_end_time character varying(100),
    iso_formatted_start_date character varying(100),
    iso_formatted_end_date character varying(100),
    "allDay" boolean,
    "timeOfDay" character varying(100)
);


ALTER TABLE public.event_date OWNER TO lsh_user;

--
-- Name: event_date_association; Type: TABLE; Schema: public; Owner: lsh_user
--

CREATE TABLE public.event_date_association (
    event_id integer,
    event_date_id integer
);


ALTER TABLE public.event_date_association OWNER TO lsh_user;

--
-- Name: event_date_id_seq; Type: SEQUENCE; Schema: public; Owner: lsh_user
--

CREATE SEQUENCE public.event_date_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.event_date_id_seq OWNER TO lsh_user;

--
-- Name: event_date_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lsh_user
--

ALTER SEQUENCE public.event_date_id_seq OWNED BY public.event_date.id;


--
-- Name: event_id_seq; Type: SEQUENCE; Schema: public; Owner: lsh_user
--

ALTER TABLE public.event ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: resource; Type: TABLE; Schema: public; Owner: lsh_user
--

CREATE TABLE public.resource (
    id integer NOT NULL,
    name character varying(50),
    type character varying(50),
    status character varying(50),
    admin_notes character varying(1500)
);


ALTER TABLE public.resource OWNER TO lsh_user;

--
-- Name: resource_id_seq; Type: SEQUENCE; Schema: public; Owner: lsh_user
--

CREATE SEQUENCE public.resource_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.resource_id_seq OWNER TO lsh_user;

--
-- Name: resource_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lsh_user
--

ALTER SEQUENCE public.resource_id_seq OWNED BY public.resource.id;


--
-- Name: trainer; Type: TABLE; Schema: public; Owner: lsh_user
--

CREATE TABLE public.trainer (
    id integer NOT NULL,
    name character varying(50),
    nickname character varying(50),
    date_of_birth date,
    pronouns character varying(50),
    race_ethnicity character varying(100),
    how_did_you_hear character varying(200),
    phone character varying(16),
    text_or_call character varying(16),
    email character varying(50),
    education character varying(100),
    lifesaver_skills character varying(500),
    relevant_exp character varying(500),
    heartsaver_interest character varying(4),
    gen_avail character varying(500),
    hrs_per_month integer,
    languages character varying(50),
    other_info character varying(1500),
    documents character varying(256),
    status character varying(100),
    admin_notes character varying(1500),
    "CPR_AED" boolean DEFAULT false,
    "STB" boolean DEFAULT false,
    "Narcan" boolean DEFAULT false,
    "AHA_HS" boolean DEFAULT false,
    "AHA_BLS" boolean DEFAULT false
);


ALTER TABLE public.trainer OWNER TO lsh_user;

--
-- Name: trainer_date; Type: TABLE; Schema: public; Owner: lsh_user
--

CREATE TABLE public.trainer_date (
    id integer NOT NULL,
    "trainerName" character varying(50),
    start_date timestamp with time zone,
    end_date timestamp with time zone,
    weekday character varying(20),
    formatted_start_time character varying(100),
    formatted_end_time character varying(100),
    iso_formatted_start_date character varying(100),
    iso_formatted_end_date character varying(100),
    trainer_id integer NOT NULL
);


ALTER TABLE public.trainer_date OWNER TO lsh_user;

--
-- Name: trainer_date_id_seq; Type: SEQUENCE; Schema: public; Owner: lsh_user
--

CREATE SEQUENCE public.trainer_date_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.trainer_date_id_seq OWNER TO lsh_user;

--
-- Name: trainer_date_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lsh_user
--

ALTER SEQUENCE public.trainer_date_id_seq OWNED BY public.trainer_date.id;


--
-- Name: trainer_id_seq; Type: SEQUENCE; Schema: public; Owner: lsh_user
--

ALTER TABLE public.trainer ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.trainer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: user; Type: TABLE; Schema: public; Owner: lsh_user
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    email character varying(150),
    password character varying(150),
    first_name character varying(150)
);


ALTER TABLE public."user" OWNER TO lsh_user;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: lsh_user
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_id_seq OWNER TO lsh_user;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lsh_user
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: event_date id; Type: DEFAULT; Schema: public; Owner: lsh_user
--

ALTER TABLE ONLY public.event_date ALTER COLUMN id SET DEFAULT nextval('public.event_date_id_seq'::regclass);


--
-- Name: resource id; Type: DEFAULT; Schema: public; Owner: lsh_user
--

ALTER TABLE ONLY public.resource ALTER COLUMN id SET DEFAULT nextval('public.resource_id_seq'::regclass);


--
-- Name: trainer_date id; Type: DEFAULT; Schema: public; Owner: lsh_user
--

ALTER TABLE ONLY public.trainer_date ALTER COLUMN id SET DEFAULT nextval('public.trainer_date_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: lsh_user
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: lsh_user
--

COPY public.alembic_version (version_num) FROM stdin;
257a9550a213
\.


--
-- Data for Name: assignment; Type: TABLE DATA; Schema: public; Owner: lsh_user
--

COPY public.assignment (id, start_date, end_date, formatted_start_date, formatted_end_time, event_id, trainer_id, trainer_status, "isLead", resource_id) FROM stdin;
84	2024-03-07 12:00:00	2024-03-07 14:00:00	03/07/2024 12:00 PM	02:00 PM	3	1	Team Lead	t	\N
85	2024-03-07 12:00:00	2024-03-07 14:00:00	03/07/2024 12:00 PM	02:00 PM	3	5	Suspended	f	\N
86	2024-03-07 12:00:00	2024-03-07 14:00:00	03/07/2024 12:00 PM	02:00 PM	3	9	Basic Trainer	f	\N
87	2024-03-07 12:00:00	2024-03-07 14:00:00	03/07/2024 12:00 PM	02:00 PM	3	4	Team Lead	f	\N
88	2024-03-07 12:00:00	2024-03-07 14:00:00	03/07/2024 12:00 PM	02:00 PM	3	2	Basic Trainer	f	\N
89	2024-03-07 12:00:00	2024-03-07 14:00:00	03/07/2024 12:00 PM	02:00 PM	3	11	Basic Trainer	f	\N
90	2024-03-07 12:00:00	2024-03-07 14:00:00	03/07/2024 12:00 PM	02:00 PM	3	\N	\N	f	1000
91	2024-03-07 14:00:00	2024-03-07 16:00:00	03/07/2024 02:00 PM	04:00 PM	12	8	Team Lead	t	\N
92	2024-03-07 14:00:00	2024-03-07 16:00:00	03/07/2024 02:00 PM	04:00 PM	12	1	Team Lead	f	\N
93	2024-03-07 14:00:00	2024-03-07 16:00:00	03/07/2024 02:00 PM	04:00 PM	12	12	New	f	\N
94	2024-03-07 14:00:00	2024-03-07 16:00:00	03/07/2024 02:00 PM	04:00 PM	12	11	Basic Trainer	f	\N
95	2024-03-07 14:00:00	2024-03-07 16:00:00	03/07/2024 02:00 PM	04:00 PM	12	17	New	f	\N
96	2024-03-07 14:00:00	2024-03-07 16:00:00	03/07/2024 02:00 PM	04:00 PM	12	\N	\N	f	1001
97	2024-03-07 14:00:00	2024-03-07 16:00:00	03/07/2024 02:00 PM	04:00 PM	12	\N	\N	f	1005
98	2024-03-07 14:00:00	2024-03-07 16:00:00	03/07/2024 02:00 PM	04:00 PM	12	\N	\N	f	1003
70	2024-03-05 11:30:00	2024-03-05 13:30:00	03/05/2024 11:30 AM	01:30 PM	2	8	Team Lead	t	\N
71	2024-03-05 11:30:00	2024-03-05 13:30:00	03/05/2024 11:30 AM	01:30 PM	2	14	New	f	\N
72	2024-03-05 11:30:00	2024-03-05 13:30:00	03/05/2024 11:30 AM	01:30 PM	2	10	Basic Trainer	f	\N
73	2024-03-05 11:30:00	2024-03-05 13:30:00	03/05/2024 11:30 AM	01:30 PM	2	13	New	f	\N
74	2024-03-05 11:30:00	2024-03-05 13:30:00	03/05/2024 11:30 AM	01:30 PM	2	7	Team Lead	f	\N
75	2024-03-05 11:30:00	2024-03-05 13:30:00	03/05/2024 11:30 AM	01:30 PM	2	9	Basic Trainer	f	\N
76	2024-03-05 11:30:00	2024-03-05 13:30:00	03/05/2024 11:30 AM	01:30 PM	2	\N	\N	f	1002
77	2024-03-05 11:30:00	2024-03-05 13:30:00	03/05/2024 11:30 AM	01:30 PM	2	\N	\N	f	1001
\.


--
-- Data for Name: event; Type: TABLE DATA; Schema: public; Owner: lsh_user
--

COPY public.event (id, name, email, phone, title, training_types, mission, num_learners, learners, place, chairs_tables, cultural, content_concerns, music, photos, other_info, status, admin_notes) FROM stdin;
4	Fake Name 4	fake4@fakeemail.com	13241324134	Pitt Program Council	Hands-only Adult CPR/AED - Street/Health Fair	To teach students about lifesaving skills!	50	18-28	Outside Hillman Library.	Yes.						New	\N
13	Mr. Extra	extra@fakeemail.com	1234132413	Extra Gum	Hands-only Adult CPR/AED - Classroom setting, Heartsaver CPR/AED/FA, Child/Infant CPR		30		Yes.	Yes.						New	\N
2	Fake Name 2	fake2@fakeemail.com	1324123412394876	Panthers United	Hands-only Adult CPR/AED - Classroom setting, Child/Infant CPR, Narcan	To promote diversity, equity, and inclusion!	25	18-30, no medical backgrounds	Petersen Events Center	Yes						Tentative	None
3	Fake Name 3	fake3@fakeemail.com	13248716329876	UPMC	Hands-only Adult CPR/AED - Classroom setting, Child/Infant CPR, Narcan, Hemorrhage Control - Formal STB	Life changing medicine.	30	Medically trained professionals, but not necessarily certified in emergency lifesaving skills.	UPMC Mercy	Yes						Tentative	None
6	Fake Name 6	fake6@fakeemail.com	45145145	WXPI	Hands-only Adult CPR/AED - Street/Health Fair		100		Fake location and parking.	Yes.						New	None
5	Fake Name 5	fake5@fakeemail.com	13413241451451	Duolingo	Hands-only Adult CPR/AED - Classroom setting, Heartsaver CPR/AED/FA	To teach our team members about potentially lifesaving skills!	24	24-56	Duolingo	Yes						New	\N
1	Fake Name 1	fake1@fakeemail.com	2341234123419876	Pitt Panthers Men's Basketball Team	Hands-only Adult CPR/AED - Classroom setting, Heartsaver CPR/AED/FA	To prepare our players for our emergency!	25	18-25	Petersen Events Center	Yes						Confirmed	None
12	Mr. Canada	canadadry@fakeemail.com	134132413	Canada Dry	Hands-only Adult CPR/AED - Classroom setting, Child/Infant CPR, Narcan		12		Canada Dry HQ	Yes.						Tentative	\N
9	Mr. Taffy	laffytaffy@fakeemail.com	617340984	Laffy Taffy	Hands-only Adult CPR/AED - Classroom setting		12		Fake location and parking.	Yes.						New	\N
\.


--
-- Data for Name: event_date; Type: TABLE DATA; Schema: public; Owner: lsh_user
--

COPY public.event_date (id, start_date, end_date, formatted_start_date, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, "allDay", "timeOfDay") FROM stdin;
2	2024-02-26 13:00:00-05	2024-02-26 15:00:00-05	02/26/2024 01:00 PM	03:00 PM	2024-02-26T13:00:00	2024-02-26T15:00:00	f	\N
12	2024-03-26 12:00:00-04	2024-03-26 14:00:00-04	03/26/2024 12:00 PM	02:00 PM	2024-03-26T12:00:00	2024-03-26T14:00:00	f	\N
11	2024-03-20 12:00:00-04	2024-03-20 14:00:00-04	03/20/2024 12:00 PM	02:00 PM	2024-03-20T12:00:00	2024-03-20T14:00:00	f	\N
10	2024-03-07 16:00:00-05	2024-03-07 18:00:00-05	03/07/2024 04:00 PM	06:00 PM	2024-03-07T16:00:00	2024-03-07T18:00:00	f	\N
1	2024-02-28 14:00:00-05	2024-02-28 16:00:00-05	02/28/2024 02:00 PM	04:00 PM	2024-02-28T14:00:00	2024-02-28T16:00:00	f	\N
9	2024-03-04 16:00:00-05	2024-03-04 18:00:00-05	03/04/2024 04:00 PM	06:00 PM	2024-03-04T16:00:00	2024-03-04T18:00:00	f	\N
8	2024-03-07 14:00:00-05	2024-03-07 16:00:00-05	03/07/2024 02:00 PM	04:00 PM	2024-03-07T14:00:00	2024-03-07T16:00:00	f	\N
3	2024-03-05 11:30:00-05	2024-03-05 13:30:00-05	03/05/2024 11:30 AM	01:30 PM	2024-03-05T11:30:00	2024-03-05T13:30:00	f	\N
7	2024-03-07 13:00:00-05	2024-03-07 15:00:00-05	03/07/2024 01:00 PM	03:00 PM	2024-03-07T13:00:00	2024-03-07T15:00:00	f	\N
4	2024-02-26 15:00:00-05	2024-02-26 17:30:00-05	02/26/2024 03:00 PM	05:30 PM	2024-02-26T15:00:00	2024-02-26T17:30:00	f	\N
6	2024-02-29 08:00:00-05	2024-02-29 12:00:00-05	02/29/2024 08:00 AM	12:00 PM	2024-02-29T08:00:00	2024-02-29T12:00:00	f	\N
5	2024-03-09 08:00:00-05	2024-03-09 11:30:00-05	03/09/2024 08:00 AM	11:30 AM	2024-03-09T08:00:00	2024-03-09T11:30:00	f	\N
14	2024-03-20 12:00:00-04	2024-03-20 14:00:00-04	03/20/2024 04:00 PM	06:00 PM	2024-03-20T16:00:00	2024-03-20T18:00:00.000	f	\N
13	2024-03-19 04:00:00-04	2024-03-20 07:00:00-04	03/19/2024	11:00 AM	2024-03-19T08:00:00	2024-03-20T11:00:00.000	t	Morning
15	2024-03-19 09:00:00-04	2024-03-20 12:00:00-04	03/19/2024	04:00 PM	2024-03-19T13:00:00	2024-03-20T16:00:00.000	t	Afternoon
17	2024-03-21 13:30:00-04	2024-03-21 16:00:00-04	03/21/2024 05:30 PM	08:00 PM	2024-03-21T17:30:00	2024-03-21T20:00:00.000	f	
16	2024-03-20 12:00:00-04	2024-03-20 14:00:00-04	03/20/2024 04:00 PM	06:00 PM	2024-03-20T16:00:00	2024-03-20T18:00:00.000	f	
\.


--
-- Data for Name: event_date_association; Type: TABLE DATA; Schema: public; Owner: lsh_user
--

COPY public.event_date_association (event_id, event_date_id) FROM stdin;
1	2
6	12
3	5
5	11
2	3
4	7
12	13
12	14
9	1
9	4
9	6
12	8
4	9
1	10
13	15
13	16
13	17
\.


--
-- Data for Name: resource; Type: TABLE DATA; Schema: public; Owner: lsh_user
--

COPY public.resource (id, name, type, status, admin_notes) FROM stdin;
1002	AED 1	AED trainer	Good	\N
1000	Sally	Adult manikin	Good	\N
1003	STB Kit 1	STB kit	Good	\N
1005	AED 3	AED trainer	Good	\N
1006	AED 2	AED trainer	Good	\N
1001	Jim	Infant manikin	Good	Change batteries.
1004	Billy	Pediatric manikin	Good	\N
\.


--
-- Data for Name: trainer; Type: TABLE DATA; Schema: public; Owner: lsh_user
--

COPY public.trainer (id, name, nickname, date_of_birth, pronouns, race_ethnicity, how_did_you_hear, phone, text_or_call, email, education, lifesaver_skills, relevant_exp, heartsaver_interest, gen_avail, hrs_per_month, languages, other_info, documents, status, admin_notes, "CPR_AED", "STB", "Narcan", "AHA_HS", "AHA_BLS") FROM stdin;
12	Katherine Jude Barkley	Katie Barkley	1994-12-07	She/Her/Hers	Black	 Website	46143146	Texts	katiebarkley@fakeemail.com		Red Cross Certification, Red Cross Instructor, Heartsaver Certification, Heartsaver Instructor, BLS Certification, BLS Instructor	 EMT	No	\N	30	Spanish	 	\N	New	\N	f	f	f	f	f
13	Jessica Patten	Jessie Patten	1988-11-13	She/They		 	5315135135	Texts	jessiepatten@fakeemail.com			 EMT	No	\N	20		 	\N	New	\N	f	f	f	f	f
16	Alexander Michael Mayer	Alex Mayer	2000-06-01	He/Him/His		 	53251235	Calls	alexmayer@fakeemail.com		Red Cross Certification, Red Cross Instructor	 	Yes	\N	20		 	\N	New	\N	f	f	f	f	f
17	Yoko Maya Hinman	Yoko Hinman	1999-03-03	She/They		 Email	12351325	Texts	yokohinman@fakeemail.com	Yes, B.S.	None/Other	 	Yes	\N	20		 	\N	New	\N	f	f	f	f	f
14	Christopher Kenneth Stamp	Chris Stamp	1998-04-16	He/Him/His		UPMC Flyer 	51351351	Texts	chrisstamp@fakeemail.com	No		 CPR Certified	Yes	\N	20		 	\N	New	None	t	f	f	f	f
5	Alexandra Derubeis	Allie Derubeis	2001-09-09	They/Them/Theirs	White	Annie 	132412341	Calls	alliederubeis@fakeemail.com	No		 	Yes	\N	40	Italian	 	\N	Suspended	None	t	f	f	f	f
15	Josephine Strobel	Jo Strobel	2001-01-28	She/Her/Hers		 	1351351351	Texts	jostrobel		Red Cross Certification, Red Cross Instructor, BLS Certification, BLS Instructor	 	Yes	\N	20		 	\N	New	\N	t	f	f	f	f
2	Molly McKay	Molly McKay	2002-07-20	She/Her/Hers		 	123413248	Calls	mollymckay@fakeemail.com	Yes, B.S. in Economics	None/Other	 	No	\N	30	Italian	 	\N	Basic Trainer	None	f	f	f	t	t
3	Elyssa Allen	Elyssa Allen	2002-01-10	She/Her/Hers		 	325132513513	Texts	elyssaallen@fakeemail.com		None/Other	 	Yes	\N	30	French	 	\N	Basic Trainer	None	f	f	f	f	f
11	Rose Ruth Hancock	Rose Hancock	1991-05-30	She/Her/Hers		 	513515	Texts	rosehancock@fakeemail.com		Red Cross Certification, Red Cross Instructor, BLS Certification, BLS Instructor	 EMT	Yes	\N	40		 	\N	Basic Trainer	None	f	f	f	f	f
8	Jane Doe	Jane Doe	1999-04-11	She/Her/Hers	White	 	4513515	Calls	janedoe@fakeemail.com		Red Cross Certification, Red Cross Instructor, Heartsaver Certification, Heartsaver Instructor, BLS Certification, BLS Instructor	 	No	\N	40		 	\N	Team Lead	None	t	t	t	t	t
9	Joshua Doe III	Josh Doe	2000-08-25	He/Him/His	White	 	351325135	Texts	joshdoe@fakeemail.com		Red Cross Certification, Red Cross Instructor, BLS Certification, BLS Instructor	 Lifeguard!	Yes	\N	20		 	\N	Basic Trainer	None	t	f	t	f	f
10	George James Snyder	George Synder	1992-07-16	He/Him/His		 	451235135	Calls	georgesynder@fakeemail.com		Red Cross Certification, Red Cross Instructor	 	Yes	\N	20		 	\N	Basic Trainer	None	t	f	t	f	f
7	Jonathan Doe II	John Doe	1997-09-02	He/They		 	35132876591	Texts	johndoe@fakeemail.com		Red Cross Certification, Red Cross Instructor, Heartsaver Certification, Heartsaver Instructor, BLS Certification, BLS Instructor	 	No	\N	40		 	\N	Team Lead	None	t	t	t	t	t
4	Lily Schneider	Lily Schneider	2001-01-11	She/Her/Hers	Asian	UPMC 	1234761538	Calls	lilyschneider@fakeemail.com	Yes, B.S.	Red Cross Certification	 EMT certified.	No	\N	30		 	\N	Team Lead	None	t	f	t	t	t
6	Jared Peters	Jared Peters	2000-07-02	He/Him/His	White	 	45123515	Texts	jaredpeters@fakemail.com	Yes, B.S. in Computer Science. 		 	No	\N	20		 	\N	Team Lead	None	t	t	t	t	t
1	Ann Wang	Annie Wang	2002-02-08	She/Her/Hers	Asian	Website	1234132413	Texts	anniewang@fakeemail.com	Yes, B.S. in Computer Science. 		 CPR certified!	Yes	\N	30	Chinese	 	\N	Team Lead	None	t	t	t	t	t
\.


--
-- Data for Name: trainer_date; Type: TABLE DATA; Schema: public; Owner: lsh_user
--

COPY public.trainer_date (id, "trainerName", start_date, end_date, weekday, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id) FROM stdin;
1	Ann Wang	2023-12-25 08:00:00-05	2023-12-25 16:00:00-05	Monday	08:00 AM	04:00 PM	2023-12-25T08:00:00-05:00	2023-12-25T16:00:00-05:00	1
2	Ann Wang	2023-12-26 16:00:00-05	2023-12-26 22:00:00-05	Tuesday	04:00 PM	10:00 PM	2023-12-26T16:00:00-05:00	2023-12-26T22:00:00-05:00	1
3	Ann Wang	2023-12-28 12:30:00-05	2023-12-28 17:30:00-05	Thursday	12:30 PM	05:30 PM	2023-12-28T12:30:00-05:00	2023-12-28T17:30:00-05:00	1
4	Ann Wang	2023-12-30 09:00:00-05	2023-12-30 12:30:00-05	Saturday	09:00 AM	12:30 PM	2023-12-30T09:00:00-05:00	2023-12-30T12:30:00-05:00	1
5	Ann Wang	2023-12-30 15:00:00-05	2023-12-30 22:00:00-05	Saturday	03:00 PM	10:00 PM	2023-12-30T15:00:00-05:00	2023-12-30T22:00:00-05:00	1
6	Ann Wang	2023-12-31 08:00:00-05	2023-12-31 16:00:00-05	Sunday	08:00 AM	04:00 PM	2023-12-31T08:00:00-05:00	2023-12-31T16:00:00-05:00	1
7	Molly McKay	2023-12-25 08:00:00-05	2023-12-25 16:00:00-05	Monday	08:00 AM	04:00 PM	2023-12-25T08:00:00-05:00	2023-12-25T16:00:00-05:00	2
8	Molly McKay	2023-12-26 16:00:00-05	2023-12-26 23:00:00-05	Tuesday	04:00 PM	11:00 PM	2023-12-26T16:00:00-05:00	2023-12-26T23:00:00-05:00	2
9	Molly McKay	2023-12-27 19:00:00-05	2023-12-27 23:00:00-05	Wednesday	07:00 PM	11:00 PM	2023-12-27T19:00:00-05:00	2023-12-27T23:00:00-05:00	2
10	Molly McKay	2023-12-28 08:00:00-05	2023-12-28 16:00:00-05	Thursday	08:00 AM	04:00 PM	2023-12-28T08:00:00-05:00	2023-12-28T16:00:00-05:00	2
11	Molly McKay	2023-12-29 16:00:00-05	2023-12-29 23:00:00-05	Friday	04:00 PM	11:00 PM	2023-12-29T16:00:00-05:00	2023-12-29T23:00:00-05:00	2
12	Molly McKay	2023-12-30 11:00:00-05	2023-12-30 17:00:00-05	Saturday	11:00 AM	05:00 PM	2023-12-30T11:00:00-05:00	2023-12-30T17:00:00-05:00	2
13	Molly McKay	2023-12-31 16:00:00-05	2023-12-31 23:00:00-05	Sunday	04:00 PM	11:00 PM	2023-12-31T16:00:00-05:00	2023-12-31T23:00:00-05:00	2
14	Elyssa Allen	2023-12-25 08:00:00-05	2023-12-25 15:00:00-05	Monday	08:00 AM	03:00 PM	2023-12-25T08:00:00-05:00	2023-12-25T15:00:00-05:00	3
15	Elyssa Allen	2023-12-26 16:00:00-05	2023-12-26 22:30:00-05	Tuesday	04:00 PM	10:30 PM	2023-12-26T16:00:00-05:00	2023-12-26T22:30:00-05:00	3
16	Elyssa Allen	2023-12-29 16:00:00-05	2023-12-29 23:00:00-05	Friday	04:00 PM	11:00 PM	2023-12-29T16:00:00-05:00	2023-12-29T23:00:00-05:00	3
17	Elyssa Allen	2023-12-30 15:00:00-05	2023-12-30 23:00:00-05	Saturday	03:00 PM	11:00 PM	2023-12-30T15:00:00-05:00	2023-12-30T23:00:00-05:00	3
18	Elyssa Allen	2023-12-31 15:00:00-05	2023-12-31 23:00:00-05	Sunday	03:00 PM	11:00 PM	2023-12-31T15:00:00-05:00	2023-12-31T23:00:00-05:00	3
19	Lily Schneider	2023-12-25 07:00:00-05	2023-12-26 00:00:00-05	Monday	07:00 AM	12:00 AM	2023-12-25T07:00:00-05:00	2023-12-26T00:00:00-05:00	4
20	Lily Schneider	2023-12-26 07:00:00-05	2023-12-26 10:30:00-05	Tuesday	07:00 AM	10:30 AM	2023-12-26T07:00:00-05:00	2023-12-26T10:30:00-05:00	4
21	Lily Schneider	2023-12-26 14:30:00-05	2023-12-27 00:00:00-05	Tuesday	02:30 PM	12:00 AM	2023-12-26T14:30:00-05:00	2023-12-27T00:00:00-05:00	4
22	Lily Schneider	2023-12-27 16:00:00-05	2023-12-27 23:00:00-05	Wednesday	04:00 PM	11:00 PM	2023-12-27T16:00:00-05:00	2023-12-27T23:00:00-05:00	4
23	Lily Schneider	2023-12-28 11:00:00-05	2023-12-28 22:00:00-05	Thursday	11:00 AM	10:00 PM	2023-12-28T11:00:00-05:00	2023-12-28T22:00:00-05:00	4
24	Lily Schneider	2023-12-29 16:00:00-05	2023-12-29 22:00:00-05	Friday	04:00 PM	10:00 PM	2023-12-29T16:00:00-05:00	2023-12-29T22:00:00-05:00	4
25	Alexandra Derubeis	2023-12-26 09:00:00-05	2023-12-26 18:00:00-05	Tuesday	09:00 AM	06:00 PM	2023-12-26T09:00:00-05:00	2023-12-26T18:00:00-05:00	5
26	Alexandra Derubeis	2023-12-27 09:00:00-05	2023-12-27 18:00:00-05	Wednesday	09:00 AM	06:00 PM	2023-12-27T09:00:00-05:00	2023-12-27T18:00:00-05:00	5
27	Alexandra Derubeis	2023-12-28 09:00:00-05	2023-12-28 18:00:00-05	Thursday	09:00 AM	06:00 PM	2023-12-28T09:00:00-05:00	2023-12-28T18:00:00-05:00	5
28	Alexandra Derubeis	2023-12-29 09:00:00-05	2023-12-29 18:00:00-05	Friday	09:00 AM	06:00 PM	2023-12-29T09:00:00-05:00	2023-12-29T18:00:00-05:00	5
29	Alexandra Derubeis	2023-12-30 09:00:00-05	2023-12-30 18:00:00-05	Saturday	09:00 AM	06:00 PM	2023-12-30T09:00:00-05:00	2023-12-30T18:00:00-05:00	5
30	Alexandra Derubeis	2023-12-25 09:00:00-05	2023-12-25 18:00:00-05	Monday	09:00 AM	06:00 PM	2023-12-25T09:00:00-05:00	2023-12-25T18:00:00-05:00	5
31	Jared Peters	2023-12-26 16:00:00-05	2023-12-26 22:00:00-05	Tuesday	04:00 PM	10:00 PM	2023-12-26T16:00:00-05:00	2023-12-26T22:00:00-05:00	6
32	Jared Peters	2023-12-27 16:00:00-05	2023-12-27 22:00:00-05	Wednesday	04:00 PM	10:00 PM	2023-12-27T16:00:00-05:00	2023-12-27T22:00:00-05:00	6
33	Jared Peters	2023-12-28 16:00:00-05	2023-12-28 22:00:00-05	Thursday	04:00 PM	10:00 PM	2023-12-28T16:00:00-05:00	2023-12-28T22:00:00-05:00	6
34	Jared Peters	2023-12-29 16:00:00-05	2023-12-29 22:00:00-05	Friday	04:00 PM	10:00 PM	2023-12-29T16:00:00-05:00	2023-12-29T22:00:00-05:00	6
35	Jared Peters	2023-12-30 16:00:00-05	2023-12-30 22:00:00-05	Saturday	04:00 PM	10:00 PM	2023-12-30T16:00:00-05:00	2023-12-30T22:00:00-05:00	6
36	Jonathan Doe II	2023-12-25 06:00:00-05	2023-12-25 18:00:00-05	Monday	06:00 AM	06:00 PM	2023-12-25T06:00:00-05:00	2023-12-25T18:00:00-05:00	7
37	Jonathan Doe II	2023-12-26 06:00:00-05	2023-12-27 00:00:00-05	Tuesday	06:00 AM	12:00 AM	2023-12-26T06:00:00-05:00	2023-12-27T00:00:00-05:00	7
38	Jonathan Doe II	2023-12-27 06:00:00-05	2023-12-27 13:00:00-05	Wednesday	06:00 AM	01:00 PM	2023-12-27T06:00:00-05:00	2023-12-27T13:00:00-05:00	7
39	Jonathan Doe II	2023-12-29 06:00:00-05	2023-12-29 13:00:00-05	Friday	06:00 AM	01:00 PM	2023-12-29T06:00:00-05:00	2023-12-29T13:00:00-05:00	7
40	Jonathan Doe II	2023-12-31 06:00:00-05	2024-01-01 00:00:00-05	Sunday	06:00 AM	12:00 AM	2023-12-31T06:00:00-05:00	2024-01-01T00:00:00-05:00	7
41	Jane Doe	2023-12-26 06:00:00-05	2023-12-26 17:00:00-05	Tuesday	06:00 AM	05:00 PM	2023-12-26T06:00:00-05:00	2023-12-26T17:00:00-05:00	8
42	Jane Doe	2023-12-27 10:00:00-05	2023-12-27 18:30:00-05	Wednesday	10:00 AM	06:30 PM	2023-12-27T10:00:00-05:00	2023-12-27T18:30:00-05:00	8
43	Jane Doe	2023-12-28 10:00:00-05	2023-12-28 18:30:00-05	Thursday	10:00 AM	06:30 PM	2023-12-28T10:00:00-05:00	2023-12-28T18:30:00-05:00	8
44	Jane Doe	2023-12-29 16:00:00-05	2023-12-29 23:00:00-05	Friday	04:00 PM	11:00 PM	2023-12-29T16:00:00-05:00	2023-12-29T23:00:00-05:00	8
45	Jane Doe	2023-12-30 16:00:00-05	2023-12-30 23:00:00-05	Saturday	04:00 PM	11:00 PM	2023-12-30T16:00:00-05:00	2023-12-30T23:00:00-05:00	8
46	Jane Doe	2023-12-31 16:00:00-05	2023-12-31 23:00:00-05	Sunday	04:00 PM	11:00 PM	2023-12-31T16:00:00-05:00	2023-12-31T23:00:00-05:00	8
47	Joshua Doe III	2023-12-25 06:00:00-05	2023-12-25 17:00:00-05	Monday	06:00 AM	05:00 PM	2023-12-25T06:00:00-05:00	2023-12-25T17:00:00-05:00	9
48	Joshua Doe III	2023-12-26 06:00:00-05	2023-12-26 17:00:00-05	Tuesday	06:00 AM	05:00 PM	2023-12-26T06:00:00-05:00	2023-12-26T17:00:00-05:00	9
49	Joshua Doe III	2023-12-27 06:00:00-05	2023-12-27 16:00:00-05	Wednesday	06:00 AM	04:00 PM	2023-12-27T06:00:00-05:00	2023-12-27T16:00:00-05:00	9
50	Joshua Doe III	2023-12-28 06:00:00-05	2023-12-28 16:00:00-05	Thursday	06:00 AM	04:00 PM	2023-12-28T06:00:00-05:00	2023-12-28T16:00:00-05:00	9
51	Joshua Doe III	2023-12-29 06:00:00-05	2023-12-29 16:00:00-05	Friday	06:00 AM	04:00 PM	2023-12-29T06:00:00-05:00	2023-12-29T16:00:00-05:00	9
52	Joshua Doe III	2023-12-30 06:00:00-05	2023-12-30 16:00:00-05	Saturday	06:00 AM	04:00 PM	2023-12-30T06:00:00-05:00	2023-12-30T16:00:00-05:00	9
53	Joshua Doe III	2023-12-31 06:00:00-05	2023-12-31 21:00:00-05	Sunday	06:00 AM	09:00 PM	2023-12-31T06:00:00-05:00	2023-12-31T21:00:00-05:00	9
54	George James Snyder	2023-12-25 10:00:00-05	2023-12-25 17:00:00-05	Monday	10:00 AM	05:00 PM	2023-12-25T10:00:00-05:00	2023-12-25T17:00:00-05:00	10
55	George James Snyder	2023-12-26 10:00:00-05	2023-12-26 17:00:00-05	Tuesday	10:00 AM	05:00 PM	2023-12-26T10:00:00-05:00	2023-12-26T17:00:00-05:00	10
56	George James Snyder	2023-12-27 11:00:00-05	2023-12-27 17:00:00-05	Wednesday	11:00 AM	05:00 PM	2023-12-27T11:00:00-05:00	2023-12-27T17:00:00-05:00	10
57	George James Snyder	2023-12-29 11:00:00-05	2023-12-29 17:00:00-05	Friday	11:00 AM	05:00 PM	2023-12-29T11:00:00-05:00	2023-12-29T17:00:00-05:00	10
58	George James Snyder	2023-12-31 11:00:00-05	2023-12-31 17:00:00-05	Sunday	11:00 AM	05:00 PM	2023-12-31T11:00:00-05:00	2023-12-31T17:00:00-05:00	10
59	Rose Ruth Hancock	2023-12-25 06:00:00-05	2023-12-25 14:00:00-05	Monday	06:00 AM	02:00 PM	2023-12-25T06:00:00-05:00	2023-12-25T14:00:00-05:00	11
60	Rose Ruth Hancock	2023-12-26 07:00:00-05	2023-12-26 15:00:00-05	Tuesday	07:00 AM	03:00 PM	2023-12-26T07:00:00-05:00	2023-12-26T15:00:00-05:00	11
61	Rose Ruth Hancock	2023-12-27 07:00:00-05	2023-12-27 15:00:00-05	Wednesday	07:00 AM	03:00 PM	2023-12-27T07:00:00-05:00	2023-12-27T15:00:00-05:00	11
62	Rose Ruth Hancock	2023-12-28 11:00:00-05	2023-12-28 18:00:00-05	Thursday	11:00 AM	06:00 PM	2023-12-28T11:00:00-05:00	2023-12-28T18:00:00-05:00	11
63	Rose Ruth Hancock	2023-12-29 11:00:00-05	2023-12-29 18:00:00-05	Friday	11:00 AM	06:00 PM	2023-12-29T11:00:00-05:00	2023-12-29T18:00:00-05:00	11
64	Rose Ruth Hancock	2023-12-30 08:30:00-05	2023-12-30 16:30:00-05	Saturday	08:30 AM	04:30 PM	2023-12-30T08:30:00-05:00	2023-12-30T16:30:00-05:00	11
65	Rose Ruth Hancock	2023-12-31 12:00:00-05	2023-12-31 20:00:00-05	Sunday	12:00 PM	08:00 PM	2023-12-31T12:00:00-05:00	2023-12-31T20:00:00-05:00	11
66	Katherine Jude Barkley	2023-12-25 08:00:00-05	2023-12-25 21:00:00-05	Monday	08:00 AM	09:00 PM	2023-12-25T08:00:00-05:00	2023-12-25T21:00:00-05:00	12
67	Katherine Jude Barkley	2023-12-26 16:00:00-05	2023-12-26 23:00:00-05	Tuesday	04:00 PM	11:00 PM	2023-12-26T16:00:00-05:00	2023-12-26T23:00:00-05:00	12
68	Katherine Jude Barkley	2023-12-27 16:00:00-05	2023-12-27 23:00:00-05	Wednesday	04:00 PM	11:00 PM	2023-12-27T16:00:00-05:00	2023-12-27T23:00:00-05:00	12
69	Katherine Jude Barkley	2023-12-29 16:00:00-05	2023-12-29 23:00:00-05	Friday	04:00 PM	11:00 PM	2023-12-29T16:00:00-05:00	2023-12-29T23:00:00-05:00	12
70	Katherine Jude Barkley	2023-12-28 08:00:00-05	2023-12-28 16:00:00-05	Thursday	08:00 AM	04:00 PM	2023-12-28T08:00:00-05:00	2023-12-28T16:00:00-05:00	12
71	Katherine Jude Barkley	2023-12-30 08:00:00-05	2023-12-30 16:00:00-05	Saturday	08:00 AM	04:00 PM	2023-12-30T08:00:00-05:00	2023-12-30T16:00:00-05:00	12
72	Katherine Jude Barkley	2023-12-31 11:30:00-05	2023-12-31 18:30:00-05	Sunday	11:30 AM	06:30 PM	2023-12-31T11:30:00-05:00	2023-12-31T18:30:00-05:00	12
73	Jessica Patten	2023-12-26 11:00:00-05	2023-12-26 18:00:00-05	Tuesday	11:00 AM	06:00 PM	2023-12-26T11:00:00-05:00	2023-12-26T18:00:00-05:00	13
74	Jessica Patten	2023-12-28 16:00:00-05	2023-12-28 21:00:00-05	Thursday	04:00 PM	09:00 PM	2023-12-28T16:00:00-05:00	2023-12-28T21:00:00-05:00	13
75	Jessica Patten	2023-12-30 16:00:00-05	2023-12-30 21:00:00-05	Saturday	04:00 PM	09:00 PM	2023-12-30T16:00:00-05:00	2023-12-30T21:00:00-05:00	13
76	Jessica Patten	2023-12-29 17:00:00-05	2023-12-29 23:00:00-05	Friday	05:00 PM	11:00 PM	2023-12-29T17:00:00-05:00	2023-12-29T23:00:00-05:00	13
77	Christopher Kenneth Stamp	2023-12-29 09:00:00-05	2023-12-29 17:00:00-05	Friday	09:00 AM	05:00 PM	2023-12-29T09:00:00-05:00	2023-12-29T17:00:00-05:00	14
78	Christopher Kenneth Stamp	2023-12-30 09:00:00-05	2023-12-30 17:00:00-05	Saturday	09:00 AM	05:00 PM	2023-12-30T09:00:00-05:00	2023-12-30T17:00:00-05:00	14
79	Christopher Kenneth Stamp	2023-12-31 09:00:00-05	2023-12-31 16:00:00-05	Sunday	09:00 AM	04:00 PM	2023-12-31T09:00:00-05:00	2023-12-31T16:00:00-05:00	14
80	Christopher Kenneth Stamp	2023-12-27 11:00:00-05	2023-12-27 17:00:00-05	Wednesday	11:00 AM	05:00 PM	2023-12-27T11:00:00-05:00	2023-12-27T17:00:00-05:00	14
81	Christopher Kenneth Stamp	2023-12-26 11:00:00-05	2023-12-26 16:00:00-05	Tuesday	11:00 AM	04:00 PM	2023-12-26T11:00:00-05:00	2023-12-26T16:00:00-05:00	14
82	Josephine Strobel	2023-12-25 11:00:00-05	2023-12-25 17:00:00-05	Monday	11:00 AM	05:00 PM	2023-12-25T11:00:00-05:00	2023-12-25T17:00:00-05:00	15
83	Josephine Strobel	2023-12-27 11:00:00-05	2023-12-27 17:00:00-05	Wednesday	11:00 AM	05:00 PM	2023-12-27T11:00:00-05:00	2023-12-27T17:00:00-05:00	15
84	Josephine Strobel	2023-12-30 11:00:00-05	2023-12-30 17:00:00-05	Saturday	11:00 AM	05:00 PM	2023-12-30T11:00:00-05:00	2023-12-30T17:00:00-05:00	15
85	Josephine Strobel	2023-12-26 14:00:00-05	2023-12-26 20:00:00-05	Tuesday	02:00 PM	08:00 PM	2023-12-26T14:00:00-05:00	2023-12-26T20:00:00-05:00	15
86	Alexander Michael Mayer	2023-12-26 16:00:00-05	2023-12-26 23:00:00-05	Tuesday	04:00 PM	11:00 PM	2023-12-26T16:00:00-05:00	2023-12-26T23:00:00-05:00	16
87	Alexander Michael Mayer	2023-12-27 17:00:00-05	2023-12-27 23:00:00-05	Wednesday	05:00 PM	11:00 PM	2023-12-27T17:00:00-05:00	2023-12-27T23:00:00-05:00	16
88	Alexander Michael Mayer	2023-12-29 17:00:00-05	2023-12-29 23:00:00-05	Friday	05:00 PM	11:00 PM	2023-12-29T17:00:00-05:00	2023-12-29T23:00:00-05:00	16
89	Alexander Michael Mayer	2023-12-25 09:00:00-05	2023-12-25 16:00:00-05	Monday	09:00 AM	04:00 PM	2023-12-25T09:00:00-05:00	2023-12-25T16:00:00-05:00	16
90	Alexander Michael Mayer	2023-12-31 09:00:00-05	2023-12-31 16:00:00-05	Sunday	09:00 AM	04:00 PM	2023-12-31T09:00:00-05:00	2023-12-31T16:00:00-05:00	16
91	Yoko Maya Hinman	2023-12-25 13:00:00-05	2023-12-25 21:00:00-05	Monday	01:00 PM	09:00 PM	2023-12-25T13:00:00-05:00	2023-12-25T21:00:00-05:00	17
92	Yoko Maya Hinman	2023-12-26 11:00:00-05	2023-12-26 17:00:00-05	Tuesday	11:00 AM	05:00 PM	2023-12-26T11:00:00-05:00	2023-12-26T17:00:00-05:00	17
93	Yoko Maya Hinman	2023-12-28 11:00:00-05	2023-12-28 17:00:00-05	Thursday	11:00 AM	05:00 PM	2023-12-28T11:00:00-05:00	2023-12-28T17:00:00-05:00	17
94	Yoko Maya Hinman	2023-12-30 11:00:00-05	2023-12-30 20:30:00-05	Saturday	11:00 AM	08:30 PM	2023-12-30T11:00:00-05:00	2023-12-30T20:30:00-05:00	17
95	Yoko Maya Hinman	2023-12-31 11:00:00-05	2023-12-31 20:30:00-05	Sunday	11:00 AM	08:30 PM	2023-12-31T11:00:00-05:00	2023-12-31T20:30:00-05:00	17
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: lsh_user
--

COPY public."user" (id, email, password, first_name) FROM stdin;
1	fake@fake.fake	sha256$mFgsKKtOjCxllmaR$5e72dc11e2583a1090d5183833558b5312ed215a6e0b63f0528bb5f75cbc48a8	fake
2	fake@fake2.fake	sha256$RS14VrkgeF1x1NJK$f384b328e71cc048e7c572fa78d10102ab9d2e38e5753c470857661720f1c26e	Fake2
3	fake3@fake.com	sha256$THelp2nQThRfgxUJ$9e0fc8c0e92e83f65b76c9cdc2c11953341e1ee38275a12108c5b145697bd199	Fake 3
\.


--
-- Name: assignment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lsh_user
--

SELECT pg_catalog.setval('public.assignment_id_seq', 98, true);


--
-- Name: event_date_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lsh_user
--

SELECT pg_catalog.setval('public.event_date_id_seq', 17, true);


--
-- Name: event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lsh_user
--

SELECT pg_catalog.setval('public.event_id_seq', 13, true);


--
-- Name: resource_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lsh_user
--

SELECT pg_catalog.setval('public.resource_id_seq', 1005, true);


--
-- Name: trainer_date_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lsh_user
--

SELECT pg_catalog.setval('public.trainer_date_id_seq', 95, true);


--
-- Name: trainer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lsh_user
--

SELECT pg_catalog.setval('public.trainer_id_seq', 17, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lsh_user
--

SELECT pg_catalog.setval('public.user_id_seq', 3, true);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: lsh_user
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: assignment assignment_pkey; Type: CONSTRAINT; Schema: public; Owner: lsh_user
--

ALTER TABLE ONLY public.assignment
    ADD CONSTRAINT assignment_pkey PRIMARY KEY (id);


--
-- Name: event_date event_date_pkey; Type: CONSTRAINT; Schema: public; Owner: lsh_user
--

ALTER TABLE ONLY public.event_date
    ADD CONSTRAINT event_date_pkey PRIMARY KEY (id);


--
-- Name: event event_pkey; Type: CONSTRAINT; Schema: public; Owner: lsh_user
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_pkey PRIMARY KEY (id);


--
-- Name: resource resource_pkey; Type: CONSTRAINT; Schema: public; Owner: lsh_user
--

ALTER TABLE ONLY public.resource
    ADD CONSTRAINT resource_pkey PRIMARY KEY (id);


--
-- Name: trainer_date trainer_date_pkey; Type: CONSTRAINT; Schema: public; Owner: lsh_user
--

ALTER TABLE ONLY public.trainer_date
    ADD CONSTRAINT trainer_date_pkey PRIMARY KEY (id);


--
-- Name: trainer trainer_pkey; Type: CONSTRAINT; Schema: public; Owner: lsh_user
--

ALTER TABLE ONLY public.trainer
    ADD CONSTRAINT trainer_pkey PRIMARY KEY (id);


--
-- Name: user user_email_key; Type: CONSTRAINT; Schema: public; Owner: lsh_user
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_email_key UNIQUE (email);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: lsh_user
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: assignment assignment_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lsh_user
--

ALTER TABLE ONLY public.assignment
    ADD CONSTRAINT assignment_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.event(id);


--
-- Name: assignment assignment_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lsh_user
--

ALTER TABLE ONLY public.assignment
    ADD CONSTRAINT assignment_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES public.resource(id);


--
-- Name: assignment assignment_trainer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lsh_user
--

ALTER TABLE ONLY public.assignment
    ADD CONSTRAINT assignment_trainer_id_fkey FOREIGN KEY (trainer_id) REFERENCES public.trainer(id);


--
-- Name: event_date_association event_date_association_event_date_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lsh_user
--

ALTER TABLE ONLY public.event_date_association
    ADD CONSTRAINT event_date_association_event_date_id_fkey FOREIGN KEY (event_date_id) REFERENCES public.event_date(id);


--
-- Name: event_date_association event_date_association_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lsh_user
--

ALTER TABLE ONLY public.event_date_association
    ADD CONSTRAINT event_date_association_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.event(id);


--
-- Name: trainer_date trainer_date_trainer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lsh_user
--

ALTER TABLE ONLY public.trainer_date
    ADD CONSTRAINT trainer_date_trainer_id_fkey FOREIGN KEY (trainer_id) REFERENCES public.trainer(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO lsh_user;


--
-- PostgreSQL database dump complete
--

