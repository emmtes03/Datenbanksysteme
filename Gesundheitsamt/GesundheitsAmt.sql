--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.0

-- Started on 2024-01-13 17:41:55 CET

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

--
-- TOC entry 245 (class 1255 OID 16623)
-- Name: check_quarantaene_ende(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_quarantaene_ende() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.ende <= (SELECT datum FROM Test WHERE test_id = NEW.test_id) THEN
    RAISE EXCEPTION 'Ende-Datum muss nach dem Test-Datum liegen';
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_quarantaene_ende() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 216 (class 1259 OID 16403)
-- Name: amt; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.amt (
    amt_id integer NOT NULL,
    name character varying(255) NOT NULL,
    CONSTRAINT amt_name_check CHECK (((name)::text <> ''::text))
);


ALTER TABLE public.amt OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16402)
-- Name: amt_amt_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.amt_amt_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.amt_amt_id_seq OWNER TO postgres;

--
-- TOC entry 3798 (class 0 OID 0)
-- Dependencies: 215
-- Name: amt_amt_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.amt_amt_id_seq OWNED BY public.amt.amt_id;


--
-- TOC entry 228 (class 1259 OID 16471)
-- Name: buerger; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.buerger (
    buerger_id integer NOT NULL,
    person_id integer,
    stadt_id integer,
    "straße" character varying(255) NOT NULL,
    hausnummer character varying(5) NOT NULL,
    CONSTRAINT buerger_hausnummer_check CHECK (((hausnummer)::text ~ '^\d{1,4}[a-zA-Z]?$'::text)),
    CONSTRAINT "buerger_straße_check" CHECK ((("straße")::text <> ''::text))
);


ALTER TABLE public.buerger OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16470)
-- Name: buerger_buerger_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.buerger_buerger_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.buerger_buerger_id_seq OWNER TO postgres;

--
-- TOC entry 3799 (class 0 OID 0)
-- Dependencies: 227
-- Name: buerger_buerger_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.buerger_buerger_id_seq OWNED BY public.buerger.buerger_id;


--
-- TOC entry 242 (class 1259 OID 16606)
-- Name: bußgeld; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."bußgeld" (
    "bußgeld_id" integer NOT NULL,
    "bußgeldkatalog_id" integer,
    kontroll_id integer,
    betrag numeric(10,2) NOT NULL,
    CONSTRAINT "bußgeld_betrag_check" CHECK ((betrag > (0)::numeric))
);


ALTER TABLE public."bußgeld" OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 16605)
-- Name: bußgeld_bußgeld_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."bußgeld_bußgeld_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."bußgeld_bußgeld_id_seq" OWNER TO postgres;

--
-- TOC entry 3800 (class 0 OID 0)
-- Dependencies: 241
-- Name: bußgeld_bußgeld_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."bußgeld_bußgeld_id_seq" OWNED BY public."bußgeld"."bußgeld_id";


--
-- TOC entry 244 (class 1259 OID 16627)
-- Name: bußgeld_katalog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."bußgeld_katalog" (
    "bußgeldkatalog_id" integer NOT NULL,
    name character varying(255) NOT NULL,
    "max_bußgeld" integer,
    CONSTRAINT "bußgeld_katalog_max_bußgeld_check" CHECK (("max_bußgeld" > 0))
);


ALTER TABLE public."bußgeld_katalog" OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 16626)
-- Name: bußgeld_katalog_bußgeldkatalog_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."bußgeld_katalog_bußgeldkatalog_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."bußgeld_katalog_bußgeldkatalog_id_seq" OWNER TO postgres;

--
-- TOC entry 3801 (class 0 OID 0)
-- Dependencies: 243
-- Name: bußgeld_katalog_bußgeldkatalog_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."bußgeld_katalog_bußgeldkatalog_id_seq" OWNED BY public."bußgeld_katalog"."bußgeldkatalog_id";


--
-- TOC entry 236 (class 1259 OID 16554)
-- Name: einsatzplan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.einsatzplan (
    einsatz_id integer NOT NULL,
    mitarbeiter_id integer,
    datum date NOT NULL,
    CONSTRAINT einsatzplan_datum_check CHECK ((datum > '2000-01-01'::date))
);


ALTER TABLE public.einsatzplan OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16553)
-- Name: einsatzplan_einsatz_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.einsatzplan_einsatz_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.einsatzplan_einsatz_id_seq OWNER TO postgres;

--
-- TOC entry 3802 (class 0 OID 0)
-- Dependencies: 235
-- Name: einsatzplan_einsatz_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.einsatzplan_einsatz_id_seq OWNED BY public.einsatzplan.einsatz_id;


--
-- TOC entry 224 (class 1259 OID 16442)
-- Name: impfstoff; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.impfstoff (
    impfstoff_id integer NOT NULL,
    hersteller character varying(255) NOT NULL,
    art character varying(255) NOT NULL,
    datum date NOT NULL,
    CONSTRAINT impfstoff_art_check CHECK (((art)::text <> ''::text)),
    CONSTRAINT impfstoff_datum_check CHECK ((datum > '1960-01-01'::date)),
    CONSTRAINT impfstoff_hersteller_check CHECK (((hersteller)::text <> ''::text))
);


ALTER TABLE public.impfstoff OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16441)
-- Name: impfstoff_impfstoff_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.impfstoff_impfstoff_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.impfstoff_impfstoff_id_seq OWNER TO postgres;

--
-- TOC entry 3803 (class 0 OID 0)
-- Dependencies: 223
-- Name: impfstoff_impfstoff_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.impfstoff_impfstoff_id_seq OWNED BY public.impfstoff.impfstoff_id;


--
-- TOC entry 234 (class 1259 OID 16531)
-- Name: impfung; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.impfung (
    impf_id integer NOT NULL,
    buerger_id integer,
    med_id integer,
    impfstoff_id integer,
    datum date NOT NULL,
    CONSTRAINT impfung_datum_check CHECK ((datum > '2000-01-01'::date))
);


ALTER TABLE public.impfung OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16530)
-- Name: impfung_impf_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.impfung_impf_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.impfung_impf_id_seq OWNER TO postgres;

--
-- TOC entry 3804 (class 0 OID 0)
-- Dependencies: 233
-- Name: impfung_impf_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.impfung_impf_id_seq OWNED BY public.impfung.impf_id;


--
-- TOC entry 240 (class 1259 OID 16589)
-- Name: kontrollen; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kontrollen (
    kontroll_id integer NOT NULL,
    einsatz_id integer,
    quarantaene_id integer,
    uhrzeit time without time zone NOT NULL
);


ALTER TABLE public.kontrollen OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 16588)
-- Name: kontrollen_kontroll_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.kontrollen_kontroll_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.kontrollen_kontroll_id_seq OWNER TO postgres;

--
-- TOC entry 3805 (class 0 OID 0)
-- Dependencies: 239
-- Name: kontrollen_kontroll_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kontrollen_kontroll_id_seq OWNED BY public.kontrollen.kontroll_id;


--
-- TOC entry 226 (class 1259 OID 16454)
-- Name: medizinische_einrichtung; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medizinische_einrichtung (
    med_id integer NOT NULL,
    stadt_id integer,
    name character varying(255) NOT NULL,
    "straße" character varying(255) NOT NULL,
    hausnummer character varying(5) NOT NULL,
    CONSTRAINT medizinische_einrichtung_hausnummer_check CHECK (((hausnummer)::text ~ '^\d{1,4}[a-zA-Z]?$'::text)),
    CONSTRAINT medizinische_einrichtung_name_check CHECK (((name)::text <> ''::text)),
    CONSTRAINT "medizinische_einrichtung_straße_check" CHECK ((("straße")::text <> ''::text))
);


ALTER TABLE public.medizinische_einrichtung OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16453)
-- Name: medizinische_einrichtung_med_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.medizinische_einrichtung_med_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.medizinische_einrichtung_med_id_seq OWNER TO postgres;

--
-- TOC entry 3806 (class 0 OID 0)
-- Dependencies: 225
-- Name: medizinische_einrichtung_med_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.medizinische_einrichtung_med_id_seq OWNED BY public.medizinische_einrichtung.med_id;


--
-- TOC entry 230 (class 1259 OID 16490)
-- Name: mitarbeiter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mitarbeiter (
    mitarbeiter_id integer NOT NULL,
    buerger_id integer,
    amt_id integer,
    abteilung character varying(255) NOT NULL,
    CONSTRAINT mitarbeiter_abteilung_check CHECK (((abteilung)::text <> ''::text))
);


ALTER TABLE public.mitarbeiter OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16489)
-- Name: mitarbeiter_mitarbeiter_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mitarbeiter_mitarbeiter_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mitarbeiter_mitarbeiter_id_seq OWNER TO postgres;

--
-- TOC entry 3807 (class 0 OID 0)
-- Dependencies: 229
-- Name: mitarbeiter_mitarbeiter_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mitarbeiter_mitarbeiter_id_seq OWNED BY public.mitarbeiter.mitarbeiter_id;


--
-- TOC entry 218 (class 1259 OID 16413)
-- Name: person; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person (
    person_id integer NOT NULL,
    vorname character varying(255) NOT NULL,
    nachname character varying(255) NOT NULL,
    age integer NOT NULL,
    CONSTRAINT person_age_check CHECK ((age > 0))
);


ALTER TABLE public.person OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16412)
-- Name: person_person_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.person_person_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.person_person_id_seq OWNER TO postgres;

--
-- TOC entry 3808 (class 0 OID 0)
-- Dependencies: 217
-- Name: person_person_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.person_person_id_seq OWNED BY public.person.person_id;


--
-- TOC entry 238 (class 1259 OID 16572)
-- Name: quarantaene; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quarantaene (
    quarantaene_id integer NOT NULL,
    mitarbeiter_id integer,
    test_id integer,
    ende date NOT NULL
);


ALTER TABLE public.quarantaene OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16571)
-- Name: quarantaene_quarantaene_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.quarantaene_quarantaene_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.quarantaene_quarantaene_id_seq OWNER TO postgres;

--
-- TOC entry 3809 (class 0 OID 0)
-- Dependencies: 237
-- Name: quarantaene_quarantaene_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.quarantaene_quarantaene_id_seq OWNED BY public.quarantaene.quarantaene_id;


--
-- TOC entry 220 (class 1259 OID 16423)
-- Name: staedte; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staedte (
    stadt_id integer NOT NULL,
    plz integer NOT NULL,
    name character varying(255) NOT NULL,
    CONSTRAINT staedte_name_check CHECK (((name)::text <> ''::text))
);


ALTER TABLE public.staedte OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16422)
-- Name: staedte_stadt_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.staedte_stadt_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.staedte_stadt_id_seq OWNER TO postgres;

--
-- TOC entry 3810 (class 0 OID 0)
-- Dependencies: 219
-- Name: staedte_stadt_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.staedte_stadt_id_seq OWNED BY public.staedte.stadt_id;


--
-- TOC entry 232 (class 1259 OID 16508)
-- Name: test; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test (
    test_id integer NOT NULL,
    buerger_id integer,
    med_id integer,
    kit_id integer,
    datum date NOT NULL,
    positiv boolean NOT NULL,
    CONSTRAINT test_datum_check CHECK ((datum > '2000-01-01'::date))
);


ALTER TABLE public.test OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16431)
-- Name: test_kit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test_kit (
    kit_id integer NOT NULL,
    hersteller character varying(255) NOT NULL,
    art character varying(255) NOT NULL,
    CONSTRAINT test_kit_art_check CHECK (((art)::text <> ''::text)),
    CONSTRAINT test_kit_hersteller_check CHECK (((hersteller)::text <> ''::text))
);


ALTER TABLE public.test_kit OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16430)
-- Name: test_kit_kit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.test_kit_kit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.test_kit_kit_id_seq OWNER TO postgres;

--
-- TOC entry 3811 (class 0 OID 0)
-- Dependencies: 221
-- Name: test_kit_kit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.test_kit_kit_id_seq OWNED BY public.test_kit.kit_id;


--
-- TOC entry 231 (class 1259 OID 16507)
-- Name: test_test_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.test_test_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.test_test_id_seq OWNER TO postgres;

--
-- TOC entry 3812 (class 0 OID 0)
-- Dependencies: 231
-- Name: test_test_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.test_test_id_seq OWNED BY public.test.test_id;


--
-- TOC entry 3536 (class 2604 OID 16406)
-- Name: amt amt_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.amt ALTER COLUMN amt_id SET DEFAULT nextval('public.amt_amt_id_seq'::regclass);


--
-- TOC entry 3542 (class 2604 OID 16474)
-- Name: buerger buerger_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buerger ALTER COLUMN buerger_id SET DEFAULT nextval('public.buerger_buerger_id_seq'::regclass);


--
-- TOC entry 3549 (class 2604 OID 16609)
-- Name: bußgeld bußgeld_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."bußgeld" ALTER COLUMN "bußgeld_id" SET DEFAULT nextval('public."bußgeld_bußgeld_id_seq"'::regclass);


--
-- TOC entry 3550 (class 2604 OID 16630)
-- Name: bußgeld_katalog bußgeldkatalog_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."bußgeld_katalog" ALTER COLUMN "bußgeldkatalog_id" SET DEFAULT nextval('public."bußgeld_katalog_bußgeldkatalog_id_seq"'::regclass);


--
-- TOC entry 3546 (class 2604 OID 16557)
-- Name: einsatzplan einsatz_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.einsatzplan ALTER COLUMN einsatz_id SET DEFAULT nextval('public.einsatzplan_einsatz_id_seq'::regclass);


--
-- TOC entry 3540 (class 2604 OID 16445)
-- Name: impfstoff impfstoff_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.impfstoff ALTER COLUMN impfstoff_id SET DEFAULT nextval('public.impfstoff_impfstoff_id_seq'::regclass);


--
-- TOC entry 3545 (class 2604 OID 16534)
-- Name: impfung impf_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.impfung ALTER COLUMN impf_id SET DEFAULT nextval('public.impfung_impf_id_seq'::regclass);


--
-- TOC entry 3548 (class 2604 OID 16592)
-- Name: kontrollen kontroll_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kontrollen ALTER COLUMN kontroll_id SET DEFAULT nextval('public.kontrollen_kontroll_id_seq'::regclass);


--
-- TOC entry 3541 (class 2604 OID 16457)
-- Name: medizinische_einrichtung med_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medizinische_einrichtung ALTER COLUMN med_id SET DEFAULT nextval('public.medizinische_einrichtung_med_id_seq'::regclass);


--
-- TOC entry 3543 (class 2604 OID 16493)
-- Name: mitarbeiter mitarbeiter_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mitarbeiter ALTER COLUMN mitarbeiter_id SET DEFAULT nextval('public.mitarbeiter_mitarbeiter_id_seq'::regclass);


--
-- TOC entry 3537 (class 2604 OID 16416)
-- Name: person person_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person ALTER COLUMN person_id SET DEFAULT nextval('public.person_person_id_seq'::regclass);


--
-- TOC entry 3547 (class 2604 OID 16575)
-- Name: quarantaene quarantaene_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quarantaene ALTER COLUMN quarantaene_id SET DEFAULT nextval('public.quarantaene_quarantaene_id_seq'::regclass);


--
-- TOC entry 3538 (class 2604 OID 16426)
-- Name: staedte stadt_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staedte ALTER COLUMN stadt_id SET DEFAULT nextval('public.staedte_stadt_id_seq'::regclass);


--
-- TOC entry 3544 (class 2604 OID 16511)
-- Name: test test_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test ALTER COLUMN test_id SET DEFAULT nextval('public.test_test_id_seq'::regclass);


--
-- TOC entry 3539 (class 2604 OID 16434)
-- Name: test_kit kit_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_kit ALTER COLUMN kit_id SET DEFAULT nextval('public.test_kit_kit_id_seq'::regclass);


--
-- TOC entry 3764 (class 0 OID 16403)
-- Dependencies: 216
-- Data for Name: amt; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.amt (amt_id, name) VALUES (1, 'Gesundheitsamt');
INSERT INTO public.amt (amt_id, name) VALUES (2, 'Ordnungsamt');
INSERT INTO public.amt (amt_id, name) VALUES (3, 'Polizei');


--
-- TOC entry 3776 (class 0 OID 16471)
-- Dependencies: 228
-- Data for Name: buerger; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (52, 1, 1, 'Hauptstraße', '7');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (53, 2, 3, 'Nebenweg', '12');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (54, 3, 5, 'Gesundheitsplatz', '25');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (55, 4, 7, 'Heilungsgasse', '14');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (56, 5, 9, 'Vitalweg', '36');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (57, 6, 1, 'Regenerationsstraße', '18');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (58, 7, 3, 'Therapieplatz', '42');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (59, 8, 5, 'Behandlungsweg', '29');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (60, 9, 1, 'Gesundheitsallee', '8');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (61, 10, 9, 'Kurvenweg', '51');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (62, 11, 2, 'Lebenskraftplatz', '16');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (63, 12, 4, 'Erholungsgasse', '33');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (64, 13, 6, 'Heilungspfad', '22');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (65, 14, 8, 'Entspannungsweg', '45');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (66, 15, 10, 'Vitalitätsgasse', '11');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (67, 16, 2, 'Gesundheitsoase', '27');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (68, 17, 4, 'Wohlbefindenstraße', '5');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (69, 18, 6, 'Regenerationsplatz', '38');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (70, 19, 8, 'Gesundheitsplatz', '19');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (71, 20, 2, 'Harmonieweg', '48');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (72, 21, 2, 'Eichenweg', '7');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (73, 22, 4, 'Buchenallee', '12');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (74, 23, 6, 'Ahornstraße', '25');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (75, 24, 8, 'Lindenplatz', '14');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (76, 25, 1, 'Fliederweg', '36');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (77, 26, 2, 'Birkenstraße', '18');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (78, 27, 4, 'Kastanienplatz', '42');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (79, 28, 6, 'Eschenweg', '29');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (80, 29, 8, 'Rosenallee', '8');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (81, 30, 2, 'Tulpenweg', '51');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (82, 31, 1, 'Bergstraße', '16');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (83, 32, 3, 'Bachgasse', '33');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (84, 33, 5, 'Mühlenweg', '22');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (85, 34, 7, 'Schulstraße', '45');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (86, 35, 9, 'Hauptplatz', '11');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (87, 36, 1, 'Parkallee', '27');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (88, 37, 3, 'Kirchgasse', '5');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (89, 38, 5, 'Marktplatz', '38');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (90, 39, 7, 'Waldring', '19');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (91, 40, 9, 'Blumenstraße', '48');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (92, 41, 2, 'Drosselweg', '10');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (93, 42, 4, 'Mühlgasse', '31');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (94, 43, 6, 'Bachstraße', '14');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (95, 44, 1, 'Fichtenweg', '10');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (96, 45, 3, 'Birkenallee', '31');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (97, 46, 5, 'Amselweg', '14');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (98, 47, 7, 'Erlenstraße', '22');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (99, 48, 9, 'Buchenweg', '36');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (100, 49, 1, 'Ulmenplatz', '18');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (101, 50, 3, 'Wiesenweg', '42');
INSERT INTO public.buerger (buerger_id, person_id, stadt_id, "straße", hausnummer) VALUES (102, 51, 5, 'Dahlienstraße', '29');


--
-- TOC entry 3790 (class 0 OID 16606)
-- Dependencies: 242
-- Data for Name: bußgeld; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."bußgeld" ("bußgeld_id", "bußgeldkatalog_id", kontroll_id, betrag) VALUES (1, 4, 25, 3000.00);
INSERT INTO public."bußgeld" ("bußgeld_id", "bußgeldkatalog_id", kontroll_id, betrag) VALUES (2, 5, 33, 1500.00);
INSERT INTO public."bußgeld" ("bußgeld_id", "bußgeldkatalog_id", kontroll_id, betrag) VALUES (3, 5, 31, 800.00);
INSERT INTO public."bußgeld" ("bußgeld_id", "bußgeldkatalog_id", kontroll_id, betrag) VALUES (4, 5, 29, 1000.00);
INSERT INTO public."bußgeld" ("bußgeld_id", "bußgeldkatalog_id", kontroll_id, betrag) VALUES (5, 4, 23, 4000.00);
INSERT INTO public."bußgeld" ("bußgeld_id", "bußgeldkatalog_id", kontroll_id, betrag) VALUES (6, 5, 32, 1200.00);


--
-- TOC entry 3792 (class 0 OID 16627)
-- Dependencies: 244
-- Data for Name: bußgeld_katalog; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."bußgeld_katalog" ("bußgeldkatalog_id", name, "max_bußgeld") VALUES (1, 'Verstoß gegen die Maskenpflicht', 150);
INSERT INTO public."bußgeld_katalog" ("bußgeldkatalog_id", name, "max_bußgeld") VALUES (2, 'Nichteinhaltung von Abstandsregeln', 250);
INSERT INTO public."bußgeld_katalog" ("bußgeldkatalog_id", name, "max_bußgeld") VALUES (3, 'Nichtbeachtung von Ausgangsbeschränkungen', 500);
INSERT INTO public."bußgeld_katalog" ("bußgeldkatalog_id", name, "max_bußgeld") VALUES (4, 'Veranstaltung illegaler Partys oder Events', 5000);
INSERT INTO public."bußgeld_katalog" ("bußgeldkatalog_id", name, "max_bußgeld") VALUES (5, 'Missachtung von Quarantänevorschriften', 2000);
INSERT INTO public."bußgeld_katalog" ("bußgeldkatalog_id", name, "max_bußgeld") VALUES (6, 'Nichtregistrierung in Restaurants und Bars', 500);
INSERT INTO public."bußgeld_katalog" ("bußgeldkatalog_id", name, "max_bußgeld") VALUES (7, 'Nichteinhaltung von Homeoffice-Regelungen', 1500);
INSERT INTO public."bußgeld_katalog" ("bußgeldkatalog_id", name, "max_bußgeld") VALUES (8, 'Verstoß gegen Reisebeschränkungen', 1000);
INSERT INTO public."bußgeld_katalog" ("bußgeldkatalog_id", name, "max_bußgeld") VALUES (9, 'Nichtbeachtung von Hygienevorschriften in Geschäften', 250);
INSERT INTO public."bußgeld_katalog" ("bußgeldkatalog_id", name, "max_bußgeld") VALUES (10, 'Falsche Angaben bei der Kontaktnachverfolgung', 1000);


--
-- TOC entry 3784 (class 0 OID 16554)
-- Dependencies: 236
-- Data for Name: einsatzplan; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.einsatzplan (einsatz_id, mitarbeiter_id, datum) VALUES (1, 1, '2023-06-15');
INSERT INTO public.einsatzplan (einsatz_id, mitarbeiter_id, datum) VALUES (2, 2, '2024-07-16');
INSERT INTO public.einsatzplan (einsatz_id, mitarbeiter_id, datum) VALUES (3, 1, '2023-08-19');
INSERT INTO public.einsatzplan (einsatz_id, mitarbeiter_id, datum) VALUES (4, 2, '2023-10-18');
INSERT INTO public.einsatzplan (einsatz_id, mitarbeiter_id, datum) VALUES (5, 1, '2024-01-10');
INSERT INTO public.einsatzplan (einsatz_id, mitarbeiter_id, datum) VALUES (6, 2, '2023-02-28');
INSERT INTO public.einsatzplan (einsatz_id, mitarbeiter_id, datum) VALUES (7, 2, '2023-06-01');
INSERT INTO public.einsatzplan (einsatz_id, mitarbeiter_id, datum) VALUES (8, 1, '2023-07-02');
INSERT INTO public.einsatzplan (einsatz_id, mitarbeiter_id, datum) VALUES (9, 2, '2023-09-01');
INSERT INTO public.einsatzplan (einsatz_id, mitarbeiter_id, datum) VALUES (10, 1, '2023-11-05');


--
-- TOC entry 3772 (class 0 OID 16442)
-- Dependencies: 224
-- Data for Name: impfstoff; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.impfstoff (impfstoff_id, hersteller, art, datum) VALUES (1, 'Pfizer/BioNTech', 'mRNA', '2020-12-14');
INSERT INTO public.impfstoff (impfstoff_id, hersteller, art, datum) VALUES (2, 'Moderna', 'mRNA', '2020-12-21');
INSERT INTO public.impfstoff (impfstoff_id, hersteller, art, datum) VALUES (3, 'Johnson & Johnson', 'Vektor', '2021-02-27');
INSERT INTO public.impfstoff (impfstoff_id, hersteller, art, datum) VALUES (4, 'AstraZeneca', 'Vektor', '2021-01-04');
INSERT INTO public.impfstoff (impfstoff_id, hersteller, art, datum) VALUES (5, 'Novavax', 'Protein Subunit', '2022-03-25');


--
-- TOC entry 3782 (class 0 OID 16531)
-- Dependencies: 234
-- Data for Name: impfung; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (41, 64, 9, 1, '2023-06-02');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (42, 80, 1, 5, '2023-08-19');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (43, 71, 10, 4, '2023-11-03');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (44, 98, 8, 2, '2023-07-11');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (45, 58, 4, 3, '2023-05-25');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (46, 57, 3, 1, '2023-12-29');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (47, 89, 7, 5, '2023-04-07');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (48, 66, 2, 2, '2023-01-28');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (49, 97, 6, 4, '2023-10-10');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (50, 53, 5, 3, '2023-09-21');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (51, 70, 1, 5, '2023-03-14');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (52, 76, 10, 1, '2023-06-28');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (53, 63, 9, 4, '2023-02-09');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (54, 79, 3, 2, '2023-07-05');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (55, 96, 8, 5, '2023-09-01');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (56, 67, 2, 3, '2023-12-16');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (57, 84, 7, 4, '2023-05-31');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (58, 62, 6, 1, '2023-11-15');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (59, 88, 5, 5, '2023-04-20');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (60, 54, 4, 3, '2023-08-05');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (61, 68, 10, 1, '2023-10-20');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (62, 81, 9, 2, '2023-01-05');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (63, 95, 1, 4, '2023-04-09');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (64, 75, 8, 5, '2023-11-24');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (65, 56, 7, 1, '2023-07-19');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (66, 83, 2, 2, '2023-03-25');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (67, 72, 6, 3, '2023-09-29');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (68, 82, 3, 4, '2023-12-04');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (69, 73, 4, 5, '2023-05-10');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (70, 90, 5, 1, '2023-08-26');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (71, 74, 1, 2, '2023-02-14');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (72, 55, 9, 3, '2023-06-19');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (73, 69, 10, 4, '2023-11-03');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (74, 85, 8, 5, '2023-07-15');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (75, 91, 7, 1, '2023-04-23');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (76, 59, 2, 2, '2023-10-06');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (77, 78, 6, 3, '2023-03-20');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (78, 65, 3, 4, '2023-09-04');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (79, 94, 4, 5, '2023-12-09');
INSERT INTO public.impfung (impf_id, buerger_id, med_id, impfstoff_id, datum) VALUES (80, 86, 5, 1, '2023-05-14');


--
-- TOC entry 3788 (class 0 OID 16589)
-- Dependencies: 240
-- Data for Name: kontrollen; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.kontrollen (kontroll_id, einsatz_id, quarantaene_id, uhrzeit) VALUES (23, 1, 56, '12:30:00');
INSERT INTO public.kontrollen (kontroll_id, einsatz_id, quarantaene_id, uhrzeit) VALUES (24, 2, 57, '09:40:00');
INSERT INTO public.kontrollen (kontroll_id, einsatz_id, quarantaene_id, uhrzeit) VALUES (25, 3, 58, '13:05:00');
INSERT INTO public.kontrollen (kontroll_id, einsatz_id, quarantaene_id, uhrzeit) VALUES (26, 4, 59, '17:45:00');
INSERT INTO public.kontrollen (kontroll_id, einsatz_id, quarantaene_id, uhrzeit) VALUES (27, 5, 60, '10:50:00');
INSERT INTO public.kontrollen (kontroll_id, einsatz_id, quarantaene_id, uhrzeit) VALUES (28, 6, 61, '11:30:00');
INSERT INTO public.kontrollen (kontroll_id, einsatz_id, quarantaene_id, uhrzeit) VALUES (29, 6, 62, '15:30:00');
INSERT INTO public.kontrollen (kontroll_id, einsatz_id, quarantaene_id, uhrzeit) VALUES (30, 7, 63, '10:00:00');
INSERT INTO public.kontrollen (kontroll_id, einsatz_id, quarantaene_id, uhrzeit) VALUES (31, 8, 64, '17:00:00');
INSERT INTO public.kontrollen (kontroll_id, einsatz_id, quarantaene_id, uhrzeit) VALUES (32, 9, 65, '15:15:00');
INSERT INTO public.kontrollen (kontroll_id, einsatz_id, quarantaene_id, uhrzeit) VALUES (33, 10, 66, '11:11:00');


--
-- TOC entry 3774 (class 0 OID 16454)
-- Dependencies: 226
-- Data for Name: medizinische_einrichtung; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.medizinische_einrichtung (med_id, stadt_id, name, "straße", hausnummer) VALUES (1, 1, 'Heilende Hände Klinik', 'Musterstraße', '12');
INSERT INTO public.medizinische_einrichtung (med_id, stadt_id, name, "straße", hausnummer) VALUES (2, 2, 'GesundheitsOase', 'Beispielweg', '6');
INSERT INTO public.medizinische_einrichtung (med_id, stadt_id, name, "straße", hausnummer) VALUES (3, 3, 'Vitality Center', 'Testgasse', '78');
INSERT INTO public.medizinische_einrichtung (med_id, stadt_id, name, "straße", hausnummer) VALUES (4, 4, 'MediCare Excellence', 'Probenweg', '9');
INSERT INTO public.medizinische_einrichtung (med_id, stadt_id, name, "straße", hausnummer) VALUES (5, 5, 'Therapie Zentrum', 'Therapieallee', '43');
INSERT INTO public.medizinische_einrichtung (med_id, stadt_id, name, "straße", hausnummer) VALUES (6, 6, 'RegenerationsInstitut', 'Heilstraße', '86');
INSERT INTO public.medizinische_einrichtung (med_id, stadt_id, name, "straße", hausnummer) VALUES (7, 7, 'Heilkraft Hospital', 'Praxisplatz', '31');
INSERT INTO public.medizinische_einrichtung (med_id, stadt_id, name, "straße", hausnummer) VALUES (8, 8, 'GesundheitsQuelle', 'Behandlungsweg', '54');
INSERT INTO public.medizinische_einrichtung (med_id, stadt_id, name, "straße", hausnummer) VALUES (9, 9, 'KurPark Klinik', 'Kurvenweg', '20');
INSERT INTO public.medizinische_einrichtung (med_id, stadt_id, name, "straße", hausnummer) VALUES (10, 10, 'Gesundheitszentrum Harmonie', 'Genesungsgasse', '79');


--
-- TOC entry 3778 (class 0 OID 16490)
-- Dependencies: 230
-- Data for Name: mitarbeiter; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.mitarbeiter (mitarbeiter_id, buerger_id, amt_id, abteilung) VALUES (1, 81, 2, 'Ordnungskontrolle');
INSERT INTO public.mitarbeiter (mitarbeiter_id, buerger_id, amt_id, abteilung) VALUES (2, 82, 2, 'Ordnungskontrolle');
INSERT INTO public.mitarbeiter (mitarbeiter_id, buerger_id, amt_id, abteilung) VALUES (3, 100, 3, 'Streife');
INSERT INTO public.mitarbeiter (mitarbeiter_id, buerger_id, amt_id, abteilung) VALUES (4, 88, 3, 'Streife');
INSERT INTO public.mitarbeiter (mitarbeiter_id, buerger_id, amt_id, abteilung) VALUES (5, 73, 1, 'Tester');
INSERT INTO public.mitarbeiter (mitarbeiter_id, buerger_id, amt_id, abteilung) VALUES (6, 62, 1, 'Tester');
INSERT INTO public.mitarbeiter (mitarbeiter_id, buerger_id, amt_id, abteilung) VALUES (7, 59, 1, 'Tester');
INSERT INTO public.mitarbeiter (mitarbeiter_id, buerger_id, amt_id, abteilung) VALUES (8, 74, 1, 'Tester');
INSERT INTO public.mitarbeiter (mitarbeiter_id, buerger_id, amt_id, abteilung) VALUES (9, 61, 1, 'Verwaltung');
INSERT INTO public.mitarbeiter (mitarbeiter_id, buerger_id, amt_id, abteilung) VALUES (10, 95, 1, 'Verwaltung');


--
-- TOC entry 3766 (class 0 OID 16413)
-- Dependencies: 218
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (1, 'Max', 'Mustermann', 30);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (2, 'Maria', 'Musterfrau', 25);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (3, 'Peter', 'Petersen', 40);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (4, 'Anna', 'Schmidt', 28);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (5, 'Michael', 'Müller', 35);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (6, 'Laura', 'Schneider', 22);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (7, 'David', 'Fischer', 33);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (8, 'Sophie', 'Wagner', 29);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (9, 'Thomas', 'Becker', 45);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (10, 'Sarah', 'Schulz', 26);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (11, 'Daniel', 'Hoffmann', 31);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (12, 'Julia', 'Wolf', 27);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (13, 'Christian', 'Schwarz', 38);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (14, 'Lena', 'Bauer', 24);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (15, 'Patrick', 'Hofmann', 37);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (16, 'Jessica', 'Keller', 32);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (17, 'Alexander', 'Lange', 29);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (18, 'Lisa', 'Stein', 26);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (19, 'Andreas', 'Schreiber', 40);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (20, 'Mia', 'Vogel', 23);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (21, 'Sebastian', 'Schmitt', 34);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (22, 'Vanessa', 'König', 28);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (23, 'Markus', 'Walter', 39);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (24, 'Emily', 'Kraft', 25);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (25, 'Dominik', 'Böhme', 33);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (26, 'Laura', 'Bergmann', 30);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (27, 'Nico', 'Simon', 36);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (28, 'Isabella', 'Huber', 29);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (29, 'Simon', 'Kühn', 31);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (30, 'Lea', 'Hahn', 27);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (31, 'Marco', 'Graf', 42);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (32, 'Sophia', 'Schulze', 26);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (33, 'Benjamin', 'Werner', 35);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (34, 'Hannah', 'Beck', 24);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (35, 'Tim', 'Krause', 38);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (36, 'Johanna', 'Richter', 30);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (37, 'Kevin', 'Koch', 33);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (38, 'Lara', 'Schuster', 28);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (39, 'Julian', 'Böhm', 39);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (40, 'Elena', 'Beyer', 22);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (41, 'Christian', 'Kaiser', 37);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (42, 'Vanessa', 'Brandt', 31);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (43, 'Felix', 'Lehmann', 26);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (44, 'Lisa', 'Schwarz', 29);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (45, 'Moritz', 'Neumann', 34);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (46, 'Celina', 'Winkler', 27);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (47, 'Philipp', 'Götz', 40);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (48, 'Sarah', 'Voigt', 25);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (49, 'Johannes', 'Lechner', 32);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (50, 'Katharina', 'Schmitt', 23);
INSERT INTO public.person (person_id, vorname, nachname, age) VALUES (51, 'Erik', 'Zimmermann', 36);


--
-- TOC entry 3786 (class 0 OID 16572)
-- Dependencies: 238
-- Data for Name: quarantaene; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (55, 9, 272, '2023-02-16');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (56, 10, 276, '2023-06-20');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (57, 9, 277, '2024-07-21');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (58, 10, 278, '2023-08-22');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (59, 9, 280, '2023-10-24');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (60, 10, 283, '2024-01-17');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (61, 9, 285, '2023-03-01');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (62, 10, 286, '2023-03-02');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (63, 9, 289, '2023-06-03');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (64, 10, 290, '2023-07-04');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (65, 9, 292, '2023-09-05');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (66, 10, 294, '2023-11-07');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (67, 9, 295, '2023-12-09');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (68, 10, 297, '2024-02-10');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (69, 9, 299, '2023-02-23');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (70, 10, 302, '2023-05-16');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (71, 9, 303, '2023-06-17');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (72, 10, 305, '2023-08-19');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (73, 9, 307, '2023-10-21');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (74, 10, 308, '2023-11-22');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (75, 9, 311, '2023-01-25');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (82, 10, 312, '2023-02-26');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (83, 9, 311, '2023-01-25');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (84, 10, 315, '2023-05-29');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (85, 9, 318, '2023-09-02');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (86, 10, 321, '2024-01-03');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (89, 9, 322, '2024-02-25');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (90, 10, 324, '2023-02-07');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (103, 9, 326, '2023-04-09');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (104, 10, 327, '2023-05-10');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (105, 9, 329, '2023-07-11');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (106, 10, 332, '2023-09-15');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (107, 9, 333, '2023-10-16');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (108, 10, 336, '2024-01-19');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (109, 9, 337, '2023-01-20');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (110, 10, 340, '2023-04-23');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (111, 9, 343, '2023-07-26');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (112, 10, 344, '2023-08-27');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (113, 9, 347, '2023-11-30');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (117, 10, 349, '2024-02-21');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (118, 9, 352, '2023-04-04');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (119, 10, 353, '2023-05-04');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (120, 9, 355, '2023-07-05');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (121, 10, 358, '2023-10-10');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (122, 9, 359, '2023-11-11');
INSERT INTO public.quarantaene (quarantaene_id, mitarbeiter_id, test_id, ende) VALUES (123, 10, 362, '2024-02-14');


--
-- TOC entry 3768 (class 0 OID 16423)
-- Dependencies: 220
-- Data for Name: staedte; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.staedte (stadt_id, plz, name) VALUES (1, 60306, 'Frankfurt am Main');
INSERT INTO public.staedte (stadt_id, plz, name) VALUES (2, 65183, 'Wiesbaden');
INSERT INTO public.staedte (stadt_id, plz, name) VALUES (3, 34117, 'Kassel');
INSERT INTO public.staedte (stadt_id, plz, name) VALUES (4, 35390, 'Gießen');
INSERT INTO public.staedte (stadt_id, plz, name) VALUES (5, 35037, 'Marburg');
INSERT INTO public.staedte (stadt_id, plz, name) VALUES (6, 63065, 'Offenbach am Main');
INSERT INTO public.staedte (stadt_id, plz, name) VALUES (7, 63450, 'Hanau');
INSERT INTO public.staedte (stadt_id, plz, name) VALUES (8, 64283, 'Darmstadt');
INSERT INTO public.staedte (stadt_id, plz, name) VALUES (9, 36037, 'Fulda');
INSERT INTO public.staedte (stadt_id, plz, name) VALUES (10, 35578, 'Wetzlar');


--
-- TOC entry 3780 (class 0 OID 16508)
-- Dependencies: 232
-- Data for Name: test; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (272, 65, 1, 2, '2023-01-02', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (273, 87, 8, 4, '2023-02-03', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (274, 101, 6, 3, '2023-03-04', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (275, 76, 3, 1, '2023-04-05', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (276, 95, 5, 2, '2023-05-06', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (277, 68, 9, 5, '2023-06-07', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (278, 57, 7, 4, '2023-07-08', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (279, 83, 1, 3, '2023-08-09', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (280, 72, 4, 2, '2023-09-10', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (281, 90, 2, 1, '2023-10-11', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (282, 73, 8, 5, '2023-11-12', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (283, 81, 10, 4, '2023-12-13', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (284, 64, 6, 1, '2024-01-14', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (285, 59, 4, 3, '2023-01-15', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (286, 79, 3, 5, '2023-02-16', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (287, 78, 1, 2, '2023-03-17', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (288, 71, 9, 4, '2023-04-18', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (289, 88, 2, 1, '2023-05-19', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (290, 82, 7, 3, '2023-06-20', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (291, 93, 5, 4, '2023-07-21', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (292, 60, 10, 5, '2023-08-22', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (293, 69, 3, 1, '2023-09-23', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (294, 80, 7, 2, '2023-10-24', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (295, 92, 9, 3, '2023-11-25', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (296, 66, 10, 4, '2023-12-26', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (297, 74, 1, 5, '2024-01-27', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (298, 91, 6, 3, '2023-01-28', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (299, 70, 5, 4, '2023-02-09', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (300, 98, 2, 5, '2023-03-30', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (301, 75, 8, 1, '2023-04-01', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (302, 89, 7, 2, '2023-05-02', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (303, 96, 4, 3, '2023-06-03', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (304, 86, 10, 4, '2023-07-04', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (305, 56, 6, 5, '2023-08-05', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (306, 54, 2, 1, '2023-09-06', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (307, 77, 7, 3, '2023-10-07', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (308, 97, 1, 4, '2023-11-08', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (309, 99, 5, 5, '2023-12-09', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (310, 85, 9, 2, '2024-01-10', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (311, 63, 3, 1, '2023-01-11', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (312, 67, 6, 2, '2023-02-12', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (313, 58, 4, 3, '2023-03-13', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (314, 62, 10, 4, '2023-04-14', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (315, 55, 8, 5, '2023-05-15', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (316, 84, 7, 1, '2023-06-16', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (317, 61, 5, 2, '2023-07-17', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (318, 66, 9, 3, '2023-08-18', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (319, 53, 1, 4, '2023-09-19', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (320, 81, 3, 5, '2023-10-20', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (321, 75, 6, 1, '2023-11-21', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (322, 92, 10, 2, '2023-12-22', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (323, 68, 5, 3, '2024-01-23', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (324, 82, 8, 4, '2023-01-24', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (325, 76, 4, 5, '2023-02-25', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (326, 87, 2, 1, '2023-03-26', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (327, 74, 7, 2, '2023-04-27', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (328, 94, 3, 3, '2023-05-28', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (329, 83, 1, 4, '2023-06-29', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (330, 55, 10, 5, '2023-07-30', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (331, 69, 6, 1, '2023-08-31', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (332, 91, 8, 2, '2023-09-01', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (333, 97, 4, 3, '2023-10-02', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (334, 78, 9, 4, '2023-11-03', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (335, 93, 5, 5, '2023-12-04', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (336, 58, 2, 1, '2024-01-05', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (337, 72, 7, 2, '2023-01-06', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (338, 80, 3, 3, '2023-02-07', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (339, 64, 1, 4, '2023-03-08', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (340, 89, 6, 5, '2023-04-09', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (341, 59, 10, 1, '2023-05-10', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (342, 96, 8, 2, '2023-06-11', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (343, 85, 5, 3, '2023-07-12', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (344, 60, 9, 4, '2023-08-13', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (345, 66, 4, 5, '2023-09-14', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (346, 71, 2, 1, '2023-10-15', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (347, 99, 7, 2, '2023-11-16', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (348, 74, 3, 3, '2023-12-17', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (349, 68, 1, 4, '2024-01-18', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (350, 82, 10, 5, '2023-01-19', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (351, 93, 6, 1, '2023-02-20', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (352, 56, 9, 2, '2023-03-21', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (353, 61, 5, 3, '2023-04-22', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (354, 88, 2, 4, '2023-05-23', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (355, 62, 8, 5, '2023-06-24', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (356, 70, 4, 1, '2023-07-25', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (357, 87, 10, 2, '2023-08-26', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (358, 64, 7, 3, '2023-09-27', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (359, 91, 1, 4, '2023-10-28', true);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (360, 73, 6, 5, '2023-11-29', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (361, 75, 9, 1, '2023-12-30', false);
INSERT INTO public.test (test_id, buerger_id, med_id, kit_id, datum, positiv) VALUES (362, 79, 5, 2, '2024-01-31', true);


--
-- TOC entry 3770 (class 0 OID 16431)
-- Dependencies: 222
-- Data for Name: test_kit; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.test_kit (kit_id, hersteller, art) VALUES (1, 'Pfizer', 'PCR');
INSERT INTO public.test_kit (kit_id, hersteller, art) VALUES (2, 'Roche', 'Antigen');
INSERT INTO public.test_kit (kit_id, hersteller, art) VALUES (3, 'Abbott', 'LAMP');
INSERT INTO public.test_kit (kit_id, hersteller, art) VALUES (4, 'Siemens Healthineers', 'Molekulare Tests');
INSERT INTO public.test_kit (kit_id, hersteller, art) VALUES (5, 'BD', 'Schnelltest');


--
-- TOC entry 3813 (class 0 OID 0)
-- Dependencies: 215
-- Name: amt_amt_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.amt_amt_id_seq', 3, true);


--
-- TOC entry 3814 (class 0 OID 0)
-- Dependencies: 227
-- Name: buerger_buerger_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.buerger_buerger_id_seq', 102, true);


--
-- TOC entry 3815 (class 0 OID 0)
-- Dependencies: 241
-- Name: bußgeld_bußgeld_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."bußgeld_bußgeld_id_seq"', 6, true);


--
-- TOC entry 3816 (class 0 OID 0)
-- Dependencies: 243
-- Name: bußgeld_katalog_bußgeldkatalog_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."bußgeld_katalog_bußgeldkatalog_id_seq"', 10, true);


--
-- TOC entry 3817 (class 0 OID 0)
-- Dependencies: 235
-- Name: einsatzplan_einsatz_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.einsatzplan_einsatz_id_seq', 10, true);


--
-- TOC entry 3818 (class 0 OID 0)
-- Dependencies: 223
-- Name: impfstoff_impfstoff_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.impfstoff_impfstoff_id_seq', 5, true);


--
-- TOC entry 3819 (class 0 OID 0)
-- Dependencies: 233
-- Name: impfung_impf_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.impfung_impf_id_seq', 80, true);


--
-- TOC entry 3820 (class 0 OID 0)
-- Dependencies: 239
-- Name: kontrollen_kontroll_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kontrollen_kontroll_id_seq', 33, true);


--
-- TOC entry 3821 (class 0 OID 0)
-- Dependencies: 225
-- Name: medizinische_einrichtung_med_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.medizinische_einrichtung_med_id_seq', 10, true);


--
-- TOC entry 3822 (class 0 OID 0)
-- Dependencies: 229
-- Name: mitarbeiter_mitarbeiter_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mitarbeiter_mitarbeiter_id_seq', 10, true);


--
-- TOC entry 3823 (class 0 OID 0)
-- Dependencies: 217
-- Name: person_person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.person_person_id_seq', 51, true);


--
-- TOC entry 3824 (class 0 OID 0)
-- Dependencies: 237
-- Name: quarantaene_quarantaene_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.quarantaene_quarantaene_id_seq', 123, true);


--
-- TOC entry 3825 (class 0 OID 0)
-- Dependencies: 219
-- Name: staedte_stadt_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.staedte_stadt_id_seq', 10, true);


--
-- TOC entry 3826 (class 0 OID 0)
-- Dependencies: 221
-- Name: test_kit_kit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.test_kit_kit_id_seq', 5, true);


--
-- TOC entry 3827 (class 0 OID 0)
-- Dependencies: 231
-- Name: test_test_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.test_test_id_seq', 362, true);


--
-- TOC entry 3571 (class 2606 OID 16411)
-- Name: amt amt_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.amt
    ADD CONSTRAINT amt_name_key UNIQUE (name);


--
-- TOC entry 3573 (class 2606 OID 16409)
-- Name: amt amt_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.amt
    ADD CONSTRAINT amt_pkey PRIMARY KEY (amt_id);


--
-- TOC entry 3585 (class 2606 OID 16478)
-- Name: buerger buerger_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buerger
    ADD CONSTRAINT buerger_pkey PRIMARY KEY (buerger_id);


--
-- TOC entry 3601 (class 2606 OID 16633)
-- Name: bußgeld_katalog bußgeld_katalog_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."bußgeld_katalog"
    ADD CONSTRAINT "bußgeld_katalog_pkey" PRIMARY KEY ("bußgeldkatalog_id");


--
-- TOC entry 3599 (class 2606 OID 16612)
-- Name: bußgeld bußgeld_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."bußgeld"
    ADD CONSTRAINT "bußgeld_pkey" PRIMARY KEY ("bußgeld_id");


--
-- TOC entry 3593 (class 2606 OID 16560)
-- Name: einsatzplan einsatzplan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.einsatzplan
    ADD CONSTRAINT einsatzplan_pkey PRIMARY KEY (einsatz_id);


--
-- TOC entry 3581 (class 2606 OID 16452)
-- Name: impfstoff impfstoff_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.impfstoff
    ADD CONSTRAINT impfstoff_pkey PRIMARY KEY (impfstoff_id);


--
-- TOC entry 3591 (class 2606 OID 16537)
-- Name: impfung impfung_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.impfung
    ADD CONSTRAINT impfung_pkey PRIMARY KEY (impf_id);


--
-- TOC entry 3597 (class 2606 OID 16594)
-- Name: kontrollen kontrollen_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kontrollen
    ADD CONSTRAINT kontrollen_pkey PRIMARY KEY (kontroll_id);


--
-- TOC entry 3583 (class 2606 OID 16464)
-- Name: medizinische_einrichtung medizinische_einrichtung_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medizinische_einrichtung
    ADD CONSTRAINT medizinische_einrichtung_pkey PRIMARY KEY (med_id);


--
-- TOC entry 3587 (class 2606 OID 16496)
-- Name: mitarbeiter mitarbeiter_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mitarbeiter
    ADD CONSTRAINT mitarbeiter_pkey PRIMARY KEY (mitarbeiter_id);


--
-- TOC entry 3575 (class 2606 OID 16421)
-- Name: person person_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_pkey PRIMARY KEY (person_id);


--
-- TOC entry 3595 (class 2606 OID 16577)
-- Name: quarantaene quarantaene_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quarantaene
    ADD CONSTRAINT quarantaene_pkey PRIMARY KEY (quarantaene_id);


--
-- TOC entry 3577 (class 2606 OID 16429)
-- Name: staedte staedte_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staedte
    ADD CONSTRAINT staedte_pkey PRIMARY KEY (stadt_id);


--
-- TOC entry 3579 (class 2606 OID 16440)
-- Name: test_kit test_kit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_kit
    ADD CONSTRAINT test_kit_pkey PRIMARY KEY (kit_id);


--
-- TOC entry 3589 (class 2606 OID 16514)
-- Name: test test_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test
    ADD CONSTRAINT test_pkey PRIMARY KEY (test_id);


--
-- TOC entry 3619 (class 2620 OID 16624)
-- Name: quarantaene check_quarantaene_ende_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER check_quarantaene_ende_trigger BEFORE INSERT OR UPDATE ON public.quarantaene FOR EACH ROW EXECUTE FUNCTION public.check_quarantaene_ende();


--
-- TOC entry 3603 (class 2606 OID 16479)
-- Name: buerger buerger_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buerger
    ADD CONSTRAINT buerger_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(person_id) ON DELETE CASCADE;


--
-- TOC entry 3604 (class 2606 OID 16484)
-- Name: buerger buerger_stadt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buerger
    ADD CONSTRAINT buerger_stadt_id_fkey FOREIGN KEY (stadt_id) REFERENCES public.staedte(stadt_id) ON DELETE CASCADE;


--
-- TOC entry 3618 (class 2606 OID 16618)
-- Name: bußgeld bußgeld_kontroll_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."bußgeld"
    ADD CONSTRAINT "bußgeld_kontroll_id_fkey" FOREIGN KEY (kontroll_id) REFERENCES public.kontrollen(kontroll_id) ON DELETE CASCADE;


--
-- TOC entry 3613 (class 2606 OID 16561)
-- Name: einsatzplan einsatzplan_mitarbeiter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.einsatzplan
    ADD CONSTRAINT einsatzplan_mitarbeiter_id_fkey FOREIGN KEY (mitarbeiter_id) REFERENCES public.mitarbeiter(mitarbeiter_id) ON DELETE CASCADE;


--
-- TOC entry 3610 (class 2606 OID 16538)
-- Name: impfung impfung_buerger_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.impfung
    ADD CONSTRAINT impfung_buerger_id_fkey FOREIGN KEY (buerger_id) REFERENCES public.buerger(buerger_id) ON DELETE CASCADE;


--
-- TOC entry 3611 (class 2606 OID 16548)
-- Name: impfung impfung_impfstoff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.impfung
    ADD CONSTRAINT impfung_impfstoff_id_fkey FOREIGN KEY (impfstoff_id) REFERENCES public.impfstoff(impfstoff_id) ON DELETE CASCADE;


--
-- TOC entry 3612 (class 2606 OID 16543)
-- Name: impfung impfung_med_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.impfung
    ADD CONSTRAINT impfung_med_id_fkey FOREIGN KEY (med_id) REFERENCES public.medizinische_einrichtung(med_id) ON DELETE CASCADE;


--
-- TOC entry 3616 (class 2606 OID 16595)
-- Name: kontrollen kontrollen_einsatz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kontrollen
    ADD CONSTRAINT kontrollen_einsatz_id_fkey FOREIGN KEY (einsatz_id) REFERENCES public.einsatzplan(einsatz_id) ON DELETE CASCADE;


--
-- TOC entry 3617 (class 2606 OID 16600)
-- Name: kontrollen kontrollen_quarantaene_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kontrollen
    ADD CONSTRAINT kontrollen_quarantaene_id_fkey FOREIGN KEY (quarantaene_id) REFERENCES public.quarantaene(quarantaene_id) ON DELETE CASCADE;


--
-- TOC entry 3602 (class 2606 OID 16465)
-- Name: medizinische_einrichtung medizinische_einrichtung_stadt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medizinische_einrichtung
    ADD CONSTRAINT medizinische_einrichtung_stadt_id_fkey FOREIGN KEY (stadt_id) REFERENCES public.staedte(stadt_id) ON DELETE CASCADE;


--
-- TOC entry 3605 (class 2606 OID 16502)
-- Name: mitarbeiter mitarbeiter_amt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mitarbeiter
    ADD CONSTRAINT mitarbeiter_amt_id_fkey FOREIGN KEY (amt_id) REFERENCES public.amt(amt_id) ON DELETE SET NULL;


--
-- TOC entry 3606 (class 2606 OID 16497)
-- Name: mitarbeiter mitarbeiter_buerger_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mitarbeiter
    ADD CONSTRAINT mitarbeiter_buerger_id_fkey FOREIGN KEY (buerger_id) REFERENCES public.buerger(buerger_id) ON DELETE CASCADE;


--
-- TOC entry 3614 (class 2606 OID 16578)
-- Name: quarantaene quarantaene_mitarbeiter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quarantaene
    ADD CONSTRAINT quarantaene_mitarbeiter_id_fkey FOREIGN KEY (mitarbeiter_id) REFERENCES public.mitarbeiter(mitarbeiter_id) ON DELETE CASCADE;


--
-- TOC entry 3615 (class 2606 OID 16583)
-- Name: quarantaene quarantaene_test_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quarantaene
    ADD CONSTRAINT quarantaene_test_id_fkey FOREIGN KEY (test_id) REFERENCES public.test(test_id) ON DELETE CASCADE;


--
-- TOC entry 3607 (class 2606 OID 16515)
-- Name: test test_buerger_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test
    ADD CONSTRAINT test_buerger_id_fkey FOREIGN KEY (buerger_id) REFERENCES public.buerger(buerger_id) ON DELETE CASCADE;


--
-- TOC entry 3608 (class 2606 OID 16525)
-- Name: test test_kit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test
    ADD CONSTRAINT test_kit_id_fkey FOREIGN KEY (kit_id) REFERENCES public.test_kit(kit_id) ON DELETE CASCADE;


--
-- TOC entry 3609 (class 2606 OID 16520)
-- Name: test test_med_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test
    ADD CONSTRAINT test_med_id_fkey FOREIGN KEY (med_id) REFERENCES public.medizinische_einrichtung(med_id) ON DELETE CASCADE;


-- Completed on 2024-01-13 17:41:55 CET

--
-- PostgreSQL database dump complete
--

