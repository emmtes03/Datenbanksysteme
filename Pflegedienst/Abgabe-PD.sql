--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

-- Started on 2024-01-13 17:38:40

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
-- TOC entry 929 (class 1247 OID 18855)
-- Name: bewertung_antwort; Type: TYPE; Schema: public; Owner: emmelie
--

CREATE TYPE public.bewertung_antwort AS ENUM (
    'sehr gut',
    'gut',
    'ok',
    'schlecht',
    'sehr schlecht'
);


ALTER TYPE public.bewertung_antwort OWNER TO emmelie;

--
-- TOC entry 884 (class 1247 OID 18686)
-- Name: euro_einheit; Type: TYPE; Schema: public; Owner: emmelie
--

CREATE TYPE public.euro_einheit AS ENUM (
    '€'
);


ALTER TYPE public.euro_einheit OWNER TO emmelie;

--
-- TOC entry 890 (class 1247 OID 18699)
-- Name: geschlecht; Type: TYPE; Schema: public; Owner: emmelie
--

CREATE TYPE public.geschlecht AS ENUM (
    'Mann',
    'Frau',
    'Divers'
);


ALTER TYPE public.geschlecht OWNER TO emmelie;

--
-- TOC entry 878 (class 1247 OID 18672)
-- Name: kraftstoffkategorie; Type: TYPE; Schema: public; Owner: emmelie
--

CREATE TYPE public.kraftstoffkategorie AS ENUM (
    'Diesel',
    'Benzin',
    'Elektro'
);


ALTER TYPE public.kraftstoffkategorie OWNER TO emmelie;

--
-- TOC entry 875 (class 1247 OID 18666)
-- Name: streckeneinheit; Type: TYPE; Schema: public; Owner: emmelie
--

CREATE TYPE public.streckeneinheit AS ENUM (
    'km',
    'm'
);


ALTER TYPE public.streckeneinheit OWNER TO emmelie;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 239 (class 1259 OID 18820)
-- Name: abrechnungen; Type: TABLE; Schema: public; Owner: emmelie
--

CREATE TABLE public.abrechnungen (
    id_rechnung integer NOT NULL,
    preis numeric(7,2),
    datum timestamp without time zone,
    "id_kostenträger" integer NOT NULL,
    CONSTRAINT abrechnungen_preis_check CHECK ((preis >= (0)::numeric))
);


ALTER TABLE public.abrechnungen OWNER TO emmelie;

--
-- TOC entry 238 (class 1259 OID 18819)
-- Name: abrechnungen_id_rechnung_seq; Type: SEQUENCE; Schema: public; Owner: emmelie
--

ALTER TABLE public.abrechnungen ALTER COLUMN id_rechnung ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.abrechnungen_id_rechnung_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 237 (class 1259 OID 18804)
-- Name: angehörige; Type: TABLE; Schema: public; Owner: emmelie
--

CREATE TABLE public."angehörige" (
    "id_angehörige" integer NOT NULL,
    vorname character varying(255),
    nachname character varying(255),
    telefonnummer character varying(20),
    "straße" character varying(255),
    plz character varying(5),
    hausnummer character varying(3),
    beziehung character varying(255),
    id_patient integer NOT NULL,
    CONSTRAINT "angehörige_hausnummer_check" CHECK (((hausnummer)::text ~ '[0-9]{1,2}[a-z]{0,1}'::text)),
    CONSTRAINT "angehörige_plz_check" CHECK (((plz)::text ~ '^[0-9]{5}$'::text)),
    CONSTRAINT "angehörige_telefonnummer_check" CHECK (((telefonnummer)::text ~ '^(?:\+?\d{1,3})?[ -]?\(?\d{1,4}\)?[ -]?\d{3,}(?:[ -]?\d{2,})?$'::text))
);


ALTER TABLE public."angehörige" OWNER TO emmelie;

--
-- TOC entry 236 (class 1259 OID 18803)
-- Name: angehörige_id_angehörige_seq; Type: SEQUENCE; Schema: public; Owner: emmelie
--

ALTER TABLE public."angehörige" ALTER COLUMN "id_angehörige" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."angehörige_id_angehörige_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 227 (class 1259 OID 18737)
-- Name: arbeitsschichten; Type: TABLE; Schema: public; Owner: emmelie
--

CREATE TABLE public.arbeitsschichten (
    id_schicht integer NOT NULL,
    bezeichnung character varying(255),
    anfang time without time zone,
    ende time without time zone
);


ALTER TABLE public.arbeitsschichten OWNER TO emmelie;

--
-- TOC entry 226 (class 1259 OID 18736)
-- Name: arbeitsschichten_id_schicht_seq; Type: SEQUENCE; Schema: public; Owner: emmelie
--

ALTER TABLE public.arbeitsschichten ALTER COLUMN id_schicht ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.arbeitsschichten_id_schicht_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 233 (class 1259 OID 18766)
-- Name: auftragspositionen; Type: TABLE; Schema: public; Owner: emmelie
--

CREATE TABLE public.auftragspositionen (
    id_auftragsposition integer NOT NULL,
    preis numeric(7,2),
    einheit public.euro_einheit,
    id_leistung integer NOT NULL,
    id_auftrag integer NOT NULL,
    id_tour integer
);


ALTER TABLE public.auftragspositionen OWNER TO emmelie;

--
-- TOC entry 232 (class 1259 OID 18765)
-- Name: auftragspositionen_id_auftragsposition_seq; Type: SEQUENCE; Schema: public; Owner: emmelie
--

ALTER TABLE public.auftragspositionen ALTER COLUMN id_auftragsposition ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.auftragspositionen_id_auftragsposition_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 229 (class 1259 OID 18743)
-- Name: aufträge; Type: TABLE; Schema: public; Owner: emmelie
--

CREATE TABLE public."aufträge" (
    id_auftrag integer NOT NULL,
    id_patient integer NOT NULL,
    datum timestamp without time zone
);


ALTER TABLE public."aufträge" OWNER TO emmelie;

--
-- TOC entry 228 (class 1259 OID 18742)
-- Name: aufträge_id_auftrag_seq; Type: SEQUENCE; Schema: public; Owner: emmelie
--

ALTER TABLE public."aufträge" ALTER COLUMN id_auftrag ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."aufträge_id_auftrag_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 242 (class 1259 OID 18848)
-- Name: diagnosen; Type: TABLE; Schema: public; Owner: emmelie
--

CREATE TABLE public.diagnosen (
    id_patient integer NOT NULL,
    icd_diagnose character varying(10) NOT NULL,
    "gültigkeitsdatum" timestamp without time zone,
    CONSTRAINT diagnosen_icd_diagnose_check CHECK (((icd_diagnose)::text ~ '^[A-Z][0-9]{2}\.[0-9]{2}$'::text))
);


ALTER TABLE public.diagnosen OWNER TO emmelie;

--
-- TOC entry 247 (class 1259 OID 18909)
-- Name: dienstplan; Type: TABLE; Schema: public; Owner: emmelie
--

CREATE TABLE public.dienstplan (
    id_mitarbeiter integer NOT NULL,
    id_schicht integer NOT NULL,
    datum date NOT NULL
);


ALTER TABLE public.dienstplan OWNER TO emmelie;

--
-- TOC entry 246 (class 1259 OID 18887)
-- Name: dokumentation; Type: TABLE; Schema: public; Owner: emmelie
--

CREATE TABLE public.dokumentation (
    id_dokumentation integer NOT NULL,
    id_pflegeeinsatz integer,
    id_patient integer,
    id_mitarbeiter integer,
    zeitpunkt timestamp without time zone,
    beschreibung text
);


ALTER TABLE public.dokumentation OWNER TO emmelie;

--
-- TOC entry 245 (class 1259 OID 18886)
-- Name: dokumentation_id_dokumentation_seq; Type: SEQUENCE; Schema: public; Owner: emmelie
--

ALTER TABLE public.dokumentation ALTER COLUMN id_dokumentation ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.dokumentation_id_dokumentation_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 244 (class 1259 OID 18866)
-- Name: evaluation; Type: TABLE; Schema: public; Owner: emmelie
--

CREATE TABLE public.evaluation (
    nr_evaluation integer NOT NULL,
    datum timestamp without time zone,
    id_mitarbeiter integer,
    id_patient integer,
    id_frage integer NOT NULL,
    bewertung public.bewertung_antwort
);


ALTER TABLE public.evaluation OWNER TO emmelie;

--
-- TOC entry 243 (class 1259 OID 18865)
-- Name: evaluation_nr_evaluation_seq; Type: SEQUENCE; Schema: public; Owner: emmelie
--

ALTER TABLE public.evaluation ALTER COLUMN nr_evaluation ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.evaluation_nr_evaluation_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 217 (class 1259 OID 18679)
-- Name: firmenfahrzeuge; Type: TABLE; Schema: public; Owner: emmelie
--

CREATE TABLE public.firmenfahrzeuge (
    kennzeichen character varying(10) NOT NULL,
    kilometerstand numeric(10,0) NOT NULL,
    einheit public.streckeneinheit,
    fahrzeugkategorie character varying(255),
    kraftstoff public.kraftstoffkategorie,
    CONSTRAINT firmenfahrzeuge_kennzeichen_check CHECK (((kennzeichen)::text ~* '^[A-ZÄÖÜ]{1,3}-[A-ZÄÖÜ]{1,2}-[0-9]{1,4}$'::text))
);


ALTER TABLE public.firmenfahrzeuge OWNER TO emmelie;

--
-- TOC entry 225 (class 1259 OID 18729)
-- Name: fragebogenkatalog; Type: TABLE; Schema: public; Owner: emmelie
--

CREATE TABLE public.fragebogenkatalog (
    id_frage integer NOT NULL,
    kategorie character varying(255),
    beschreibung text
);


ALTER TABLE public.fragebogenkatalog OWNER TO emmelie;

--
-- TOC entry 224 (class 1259 OID 18728)
-- Name: fragebogenkatalog_id_frage_seq; Type: SEQUENCE; Schema: public; Owner: emmelie
--

ALTER TABLE public.fragebogenkatalog ALTER COLUMN id_frage ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.fragebogenkatalog_id_frage_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 223 (class 1259 OID 18719)
-- Name: kostenträger; Type: TABLE; Schema: public; Owner: emmelie
--

CREATE TABLE public."kostenträger" (
    "id_kostenträger" integer NOT NULL,
    name character varying(255),
    plz character varying(5),
    "straße" character varying(255),
    hausnummer character varying(3),
    CONSTRAINT "kostenträger_hausnummer_check" CHECK (((hausnummer)::text ~ '[0-9]{1,2}[a-z]{0,1}'::text)),
    CONSTRAINT "kostenträger_plz_check" CHECK (((plz)::text ~ '^[0-9]{5}$'::text))
);


ALTER TABLE public."kostenträger" OWNER TO emmelie;

--
-- TOC entry 222 (class 1259 OID 18718)
-- Name: kostenträger_id_kostenträger_seq; Type: SEQUENCE; Schema: public; Owner: emmelie
--

ALTER TABLE public."kostenträger" ALTER COLUMN "id_kostenträger" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."kostenträger_id_kostenträger_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 216 (class 1259 OID 18658)
-- Name: mitarbeiter; Type: TABLE; Schema: public; Owner: emmelie
--

CREATE TABLE public.mitarbeiter (
    id_mitarbeiter integer NOT NULL,
    vorname character varying(255) NOT NULL,
    nachname character varying(255) NOT NULL,
    geburtsdatum timestamp without time zone NOT NULL,
    qualifikation character varying(255) NOT NULL,
    "tätigkeitsfeld" character varying(255) NOT NULL
);


ALTER TABLE public.mitarbeiter OWNER TO emmelie;

--
-- TOC entry 215 (class 1259 OID 18657)
-- Name: mitarbeiter_id_mitarbeiter_seq; Type: SEQUENCE; Schema: public; Owner: emmelie
--

ALTER TABLE public.mitarbeiter ALTER COLUMN id_mitarbeiter ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.mitarbeiter_id_mitarbeiter_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 221 (class 1259 OID 18706)
-- Name: patienten; Type: TABLE; Schema: public; Owner: emmelie
--

CREATE TABLE public.patienten (
    id_patient integer NOT NULL,
    vorname character varying(255) NOT NULL,
    nachname character varying(255) NOT NULL,
    geburtsdatum timestamp without time zone,
    geschlecht public.geschlecht NOT NULL,
    "straße" character varying(255) NOT NULL,
    plz character varying(5) NOT NULL,
    hausnummer character varying(3) NOT NULL,
    telefonnummer character varying(20),
    hausarzt character varying(255),
    pflegegrad integer,
    CONSTRAINT patienten_hausnummer_check CHECK (((hausnummer)::text ~ '[0-9]{1,2}[a-z]{0,1}'::text)),
    CONSTRAINT patienten_pflegegrad_check CHECK ((pflegegrad >= 1)),
    CONSTRAINT patienten_pflegegrad_check1 CHECK ((pflegegrad <= 5)),
    CONSTRAINT patienten_plz_check CHECK (((plz)::text ~ '^[0-9]{5}$'::text)),
    CONSTRAINT patienten_telefonnummer_check CHECK (((telefonnummer)::text ~ '^(?:\+?\d{1,3})?[ -]?\(?\d{1,4}\)?[ -]?\d{3,}(?:[ -]?\d{2,})?$'::text))
);


ALTER TABLE public.patienten OWNER TO emmelie;

--
-- TOC entry 220 (class 1259 OID 18705)
-- Name: patienten_id_patient_seq; Type: SEQUENCE; Schema: public; Owner: emmelie
--

ALTER TABLE public.patienten ALTER COLUMN id_patient ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.patienten_id_patient_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 219 (class 1259 OID 18690)
-- Name: pflegedienstkatalog; Type: TABLE; Schema: public; Owner: emmelie
--

CREATE TABLE public.pflegedienstkatalog (
    id_leistung integer NOT NULL,
    bezeichnung character varying(255) NOT NULL,
    kategorie character varying(255),
    preis numeric(7,2) NOT NULL,
    einheit public.euro_einheit,
    CONSTRAINT pflegedienstkatalog_preis_check CHECK ((preis >= (0)::numeric))
);


ALTER TABLE public.pflegedienstkatalog OWNER TO emmelie;

--
-- TOC entry 218 (class 1259 OID 18689)
-- Name: pflegedienstkatalog_id_leistung_seq; Type: SEQUENCE; Schema: public; Owner: emmelie
--

ALTER TABLE public.pflegedienstkatalog ALTER COLUMN id_leistung ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.pflegedienstkatalog_id_leistung_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 235 (class 1259 OID 18787)
-- Name: pflegeeinsätze; Type: TABLE; Schema: public; Owner: emmelie
--

CREATE TABLE public."pflegeeinsätze" (
    id_pflegeeinsatz integer NOT NULL,
    ankunft timestamp without time zone,
    abfahrt timestamp without time zone,
    dauer time without time zone,
    id_auftragsposition integer NOT NULL,
    id_mitarbeiter integer NOT NULL,
    CONSTRAINT "pflegeeinsätze_check" CHECK ((abfahrt > ankunft))
);


ALTER TABLE public."pflegeeinsätze" OWNER TO emmelie;

--
-- TOC entry 234 (class 1259 OID 18786)
-- Name: pflegeeinsätze_id_pflegeeinsatz_seq; Type: SEQUENCE; Schema: public; Owner: emmelie
--

ALTER TABLE public."pflegeeinsätze" ALTER COLUMN id_pflegeeinsatz ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."pflegeeinsätze_id_pflegeeinsatz_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 241 (class 1259 OID 18832)
-- Name: rechnungspositionen; Type: TABLE; Schema: public; Owner: emmelie
--

CREATE TABLE public.rechnungspositionen (
    id_rechnungsposition integer NOT NULL,
    preis numeric(7,2),
    datum timestamp without time zone,
    id_rechnung integer NOT NULL,
    id_pflegeeinsatz integer NOT NULL,
    CONSTRAINT rechnungspositionen_preis_check CHECK ((preis >= (0)::numeric))
);


ALTER TABLE public.rechnungspositionen OWNER TO emmelie;

--
-- TOC entry 240 (class 1259 OID 18831)
-- Name: rechnungspositionen_id_rechnungsposition_seq; Type: SEQUENCE; Schema: public; Owner: emmelie
--

ALTER TABLE public.rechnungspositionen ALTER COLUMN id_rechnungsposition ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.rechnungspositionen_id_rechnungsposition_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 231 (class 1259 OID 18754)
-- Name: tourenpläne; Type: TABLE; Schema: public; Owner: emmelie
--

CREATE TABLE public."tourenpläne" (
    id_tour integer NOT NULL,
    tourname character varying(255),
    datum timestamp without time zone,
    strecke numeric(4,2),
    einheit public.streckeneinheit,
    kennzeichen character varying(10),
    CONSTRAINT "tourenpläne_kennzeichen_check" CHECK (((kennzeichen)::text ~* '^[A-ZÄÖÜ]{1,3}-[A-ZÄÖÜ]{1,2}-[0-9]{1,4}$'::text))
);


ALTER TABLE public."tourenpläne" OWNER TO emmelie;

--
-- TOC entry 230 (class 1259 OID 18753)
-- Name: tourenpläne_id_tour_seq; Type: SEQUENCE; Schema: public; Owner: emmelie
--

ALTER TABLE public."tourenpläne" ALTER COLUMN id_tour ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."tourenpläne_id_tour_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 5024 (class 0 OID 18820)
-- Dependencies: 239
-- Data for Name: abrechnungen; Type: TABLE DATA; Schema: public; Owner: emmelie
--

INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (1, 125.50, '2023-08-15 09:30:00', 3);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (2, 200.00, '2023-08-20 14:45:00', 2);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (3, 75.25, '2023-09-05 11:00:00', 1);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (4, 300.50, '2023-08-15 09:30:00', 4);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (5, 450.00, '2023-08-20 14:45:00', 5);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (6, 75.25, '2023-09-05 11:00:00', 6);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (7, 125.50, '2023-09-10 09:30:00', 7);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (8, 200.00, '2023-09-12 14:45:00', 8);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (9, 75.25, '2023-09-15 11:00:00', 9);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (10, 300.50, '2023-09-20 09:30:00', 10);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (11, 450.00, '2023-09-22 14:45:00', 11);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (12, 75.25, '2023-09-25 11:00:00', 12);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (13, 125.50, '2023-09-30 09:30:00', 13);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (14, 200.00, '2023-10-02 14:45:00', 14);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (15, 75.25, '2023-10-05 11:00:00', 15);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (16, 300.50, '2023-10-10 09:30:00', 16);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (17, 450.00, '2023-10-12 14:45:00', 17);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (18, 75.25, '2023-10-15 11:00:00', 18);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (19, 125.50, '2023-10-20 09:30:00', 19);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (20, 200.00, '2023-10-22 14:45:00', 20);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (21, 75.25, '2023-10-25 11:00:00', 2);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (22, 300.50, '2023-10-30 09:30:00', 2);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (23, 450.00, '2023-11-02 14:45:00', 3);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (24, 75.25, '2023-11-05 11:00:00', 4);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (25, 125.50, '2023-11-10 09:30:00', 5);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (26, 200.00, '2023-11-12 14:45:00', 6);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (27, 75.25, '2023-11-15 11:00:00', 7);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (28, 300.50, '2023-11-20 09:30:00', 8);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (29, 450.00, '2023-11-22 14:45:00', 9);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (30, 75.25, '2023-11-25 11:00:00', 13);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (31, 125.50, '2023-11-30 09:30:00', 1);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (32, 200.00, '2023-12-02 14:45:00', 12);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (33, 75.25, '2023-12-05 11:00:00', 3);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (34, 300.50, '2023-12-10 09:30:00', 14);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (35, 450.00, '2023-12-12 14:45:00', 15);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (36, 75.25, '2023-12-15 11:00:00', 16);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (37, 125.50, '2023-12-20 09:30:00', 7);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (38, 200.00, '2023-12-22 14:45:00', 8);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (39, 75.25, '2023-12-25 11:00:00', 9);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (40, 300.50, '2023-12-30 09:30:00', 2);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (41, 450.00, '2024-01-02 14:45:00', 2);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (42, 75.25, '2024-01-05 11:00:00', 9);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (43, 125.50, '2024-01-10 09:30:00', 3);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (44, 200.00, '2024-01-12 14:45:00', 4);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (45, 75.25, '2024-01-15 11:00:00', 5);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (46, 300.50, '2024-01-20 09:30:00', 6);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (47, 450.00, '2024-01-22 14:45:00', 7);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (48, 75.25, '2024-01-25 11:00:00', 8);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (49, 125.50, '2024-01-30 09:30:00', 9);
INSERT INTO public.abrechnungen (id_rechnung, preis, datum, "id_kostenträger") OVERRIDING SYSTEM VALUE VALUES (50, 200.00, '2024-02-02 14:45:00', 5);


--
-- TOC entry 5022 (class 0 OID 18804)
-- Dependencies: 237
-- Data for Name: angehörige; Type: TABLE DATA; Schema: public; Owner: emmelie
--

INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (1, 'Jana', 'Fischer', '0123456789', 'Seestraße 12', '56789', '12', 'Cousin', 1);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (2, 'Jonas', 'Müller', '9876543210', 'Bergweg 7', '98765', '7b', 'Onkel', 2);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (3, 'Laura', 'Schmidt', '0123456789', 'Parkstraße 3', '12345', '3', 'Schwester', 3);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (4, 'Anna', 'Müller', '+49123456789', 'Beispielstraße 1', '12345', '5', 'Ehepartner', 1);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (5, 'Peter', 'Schmidt', '+49876543210', 'Musterweg 2', '54321', '9', 'Elternteil', 7);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (6, 'Laura', 'Wagner', '+490987654321', 'Testgasse 3', '98765', '10', 'Geschwister', 6);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (7, 'Max', 'Becker', '+491234567890', 'Probestraße 4', '13579', '18b', 'Freund', 5);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (8, 'Sophie', 'Fischer', '+49987654321', 'Musterplatz 5', '24680', '22', 'Verwandter', 4);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (9, 'Sophie', 'Mayer', '+49123456789', 'Sonnenweg 10', '34567', '4', 'Tochter', 1);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (10, 'Max', 'Schulz', '+49876543210', 'Hauptstraße 8', '56789', '11', 'Sohn', 2);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (11, 'Laura', 'Becker', '+49123456789', 'Musterallee 6', '23456', '7', 'Nichte', 3);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (12, 'Felix', 'Weber', '+491234567890', 'Wiesenweg 3', '12345', '2a', 'Cousin', 4);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (13, 'Anna', 'Fischer', '+49123456789', 'Bachgasse 5', '54321', '9', 'Enkelin', 5);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (14, 'Julia', 'Schmidt', '+490987654321', 'Parkweg 7', '98765', '15', 'Schwägerin', 6);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (15, 'Simon', 'Hoffmann', '+49987654321', 'Blumenstraße 12', '24680', '18', 'Schwager', 7);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (16, 'David', 'Müller', '+491234567890', 'Bergweg 4', '13579', '8', 'Neffe', 8);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (17, 'Lena', 'Becker', '+49876543210', 'Waldstraße 1', '11111', '21', 'Cousine', 9);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (18, 'Jonas', 'Weber', '+490987654321', 'Berggasse 2', '22222', '6', 'Großvater', 10);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (19, 'Laura', 'Fischer', '+49123456789', 'Rosenweg 8', '33333', '14', 'Großmutter', 11);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (20, 'Max', 'Schmidt', '+491234567890', 'Bachstraße 3', '44444', '12', 'Onkel', 12);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (21, 'Sophie', 'Wagner', '+49987654321', 'Wiesenweg 7', '55555', '19', 'Tante', 13);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (22, 'Simon', 'Mayer', '+49123456789', 'Hauptplatz 5', '66666', '10', 'Verwandter', 14);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (23, 'Anna', 'Becker', '+49876543210', 'Blumenallee 4', '77777', '17', 'Verwandte', 15);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (24, 'Felix', 'Schulz', '+491234567890', 'Sonnenplatz 6', '88888', '13', 'Freund', 16);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (25, 'Laura', 'Weber', '+49123456789', 'Rosenstraße 2', '99999', '5', 'Freundin', 17);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (26, 'Max', 'Fischer', '+491234567890', 'Waldweg 1', '10101', '20', 'Bekannter', 18);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (27, 'Sophie', 'Hoffmann', '+49987654321', 'Musterweg 3', '20202', '16', 'Bekannte', 19);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (28, 'Simon', 'Müller', '+49123456789', 'Parkgasse 7', '30303', '22', 'Kollege', 20);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (29, 'Anna', 'Schulz', '+49876543210', 'Blumenweg 5', '40404', '9', 'Kollegin', 21);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (30, 'Julia', 'Becker', '+490987654321', 'Bachallee 8', '50505', '14', 'Arbeitskollegin', 22);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (31, 'Felix', 'Schmidt', '+491234567890', 'Rosenplatz 3', '60606', '11', 'Arbeitskollege', 23);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (32, 'David', 'Fischer', '+49123456789', 'Hauptgasse 6', '70707', '18', 'Bekannter', 24);
INSERT INTO public."angehörige" ("id_angehörige", vorname, nachname, telefonnummer, "straße", plz, hausnummer, beziehung, id_patient) OVERRIDING SYSTEM VALUE VALUES (33, 'Lena', 'Weber', '+49876543210', 'Waldweg 2', '80808', '7', 'Bekannte', 25);


--
-- TOC entry 5012 (class 0 OID 18737)
-- Dependencies: 227
-- Data for Name: arbeitsschichten; Type: TABLE DATA; Schema: public; Owner: emmelie
--

INSERT INTO public.arbeitsschichten (id_schicht, bezeichnung, anfang, ende) OVERRIDING SYSTEM VALUE VALUES (1, 'Frühschicht', '08:00:00', '16:00:00');
INSERT INTO public.arbeitsschichten (id_schicht, bezeichnung, anfang, ende) OVERRIDING SYSTEM VALUE VALUES (2, 'Spätschicht', '14:00:00', '22:00:00');
INSERT INTO public.arbeitsschichten (id_schicht, bezeichnung, anfang, ende) OVERRIDING SYSTEM VALUE VALUES (3, 'Nachtschicht', '22:00:00', '06:00:00');
INSERT INTO public.arbeitsschichten (id_schicht, bezeichnung, anfang, ende) OVERRIDING SYSTEM VALUE VALUES (4, 'Bereitschaftsdienst', '22:00:00', '06:00:00');
INSERT INTO public.arbeitsschichten (id_schicht, bezeichnung, anfang, ende) OVERRIDING SYSTEM VALUE VALUES (5, 'Alternative Mittagsschicht', '11:00:00', '18:00:00');


--
-- TOC entry 5018 (class 0 OID 18766)
-- Dependencies: 233
-- Data for Name: auftragspositionen; Type: TABLE DATA; Schema: public; Owner: emmelie
--

INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (1, 150.00, '€', 1, 1, 1);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (2, 200.50, '€', 2, 1, 1);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (3, 180.75, '€', 3, 2, 3);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (4, 120.50, '€', 5, 3, 3);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (5, 60.00, '€', 8, 1, 1);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (6, 75.00, '€', 4, 2, 3);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (7, 150.00, '€', 1, 3, 3);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (8, 150.00, '€', 1, 1, 1);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (9, 200.00, '€', 2, 2, 3);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (10, 180.00, '€', 2, 4, 5);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (11, 120.50, '€', 5, 5, 6);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (12, 80.75, '€', 3, 6, 7);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (13, 90.25, '€', 4, 7, 8);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (14, 150.00, '€', 1, 8, 9);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (15, 200.50, '€', 2, 9, 10);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (16, 95.00, '€', 3, 10, 11);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (17, 120.00, '€', 4, 11, 12);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (18, 110.00, '€', 5, 12, 13);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (19, 75.00, '€', 6, 13, 14);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (20, 100.00, '€', 7, 14, 15);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (21, 180.50, '€', 8, 15, 16);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (22, 130.25, '€', 1, 16, 1);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (23, 160.00, '€', 2, 17, 11);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (24, 75.50, '€', 3, 18, 9);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (25, 95.75, '€', 4, 19, 2);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (26, 120.00, '€', 5, 20, 2);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (27, 150.50, '€', 6, 21, 12);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (28, 80.25, '€', 7, 22, 3);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (29, 110.75, '€', 8, 23, 4);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (30, 125.00, '€', 1, 24, 5);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (31, 140.50, '€', 2, 25, 6);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (32, 100.75, '€', 3, 26, 7);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (33, 85.25, '€', 4, 27, 8);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (34, 115.00, '€', 5, 28, 9);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (35, 90.50, '€', 6, 29, 11);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (36, 105.25, '€', 7, 30, 14);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (37, 135.00, '€', 8, 31, 3);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (38, 75.75, '€', 1, 32, 14);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (39, 95.50, '€', 2, 33, 4);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (40, 120.25, '€', 3, 34, 5);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (41, 110.00, '€', 4, 35, 6);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (42, 140.50, '€', 5, 36, 7);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (43, 160.25, '€', 6, 37, 8);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (44, 180.00, '€', 7, 8, 9);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (45, 200.50, '€', 8, 9, 10);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (46, 105.00, '€', 1, 10, 14);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (47, 125.75, '€', 2, 1, 14);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (48, 140.25, '€', 3, 2, 13);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (49, 95.50, '€', 4, 3, 14);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (50, 120.00, '€', 5, 4, 15);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (51, 130.50, '€', 6, 5, 16);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (52, 85.25, '€', 7, 16, 16);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (53, 110.75, '€', 8, 17, 8);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (54, 115.00, '€', 1, 18, 9);
INSERT INTO public.auftragspositionen (id_auftragsposition, preis, einheit, id_leistung, id_auftrag, id_tour) OVERRIDING SYSTEM VALUE VALUES (55, 135.50, '€', 2, 19, 5);


--
-- TOC entry 5014 (class 0 OID 18743)
-- Dependencies: 229
-- Data for Name: aufträge; Type: TABLE DATA; Schema: public; Owner: emmelie
--

INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (1, 1, '2024-01-09 10:30:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (2, 2, '2024-01-10 11:45:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (3, 3, '2024-01-11 09:15:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (4, 4, '2023-06-09 15:36:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (5, 5, '2023-08-10 08:45:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (6, 6, '2023-09-11 17:15:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (7, 7, '2023-12-09 15:22:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (8, 8, '2022-08-10 12:45:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (9, 9, '2023-10-01 15:36:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (10, 10, '2024-01-12 14:30:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (11, 11, '2024-01-13 16:45:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (12, 12, '2024-01-14 09:15:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (13, 13, '2023-11-05 12:36:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (14, 14, '2023-10-20 08:30:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (15, 15, '2023-09-25 13:45:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (16, 16, '2023-08-18 15:22:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (17, 17, '2022-09-22 11:15:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (18, 18, '2023-07-01 10:36:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (19, 19, '2023-04-15 09:20:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (20, 20, '2023-02-28 14:50:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (21, 21, '2022-11-10 17:30:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (22, 22, '2022-12-05 08:15:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (23, 23, '2022-08-16 14:22:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (24, 24, '2022-07-09 11:45:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (25, 25, '2022-06-14 10:30:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (26, 26, '2022-05-19 09:00:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (27, 27, '2022-04-22 15:36:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (28, 28, '2022-03-27 08:45:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (29, 29, '2022-02-10 11:15:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (30, 30, '2022-01-15 14:22:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (31, 31, '2021-12-20 09:30:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (32, 32, '2021-11-25 16:00:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (33, 33, '2021-10-30 13:15:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (34, 34, '2021-09-04 10:45:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (35, 35, '2021-08-09 15:36:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (36, 36, '2021-07-14 08:30:00');
INSERT INTO public."aufträge" (id_auftrag, id_patient, datum) OVERRIDING SYSTEM VALUE VALUES (37, 37, '2021-06-19 14:45:00');


--
-- TOC entry 5027 (class 0 OID 18848)
-- Dependencies: 242
-- Data for Name: diagnosen; Type: TABLE DATA; Schema: public; Owner: emmelie
--

INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (1, 'A00.14', '2023-05-10 08:00:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (2, 'B12.32', '2023-07-22 11:30:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (3, 'C45.69', '2023-06-15 09:45:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (4, 'D56.21', '2024-08-05 14:20:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (4, 'E78.42', '2024-09-18 10:10:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (6, 'F32.92', '2023-11-30 16:45:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (1, 'A01.12', '2024-01-10 08:00:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (1, 'B02.45', '2024-01-12 11:30:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (2, 'C03.23', '2024-01-15 09:45:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (2, 'D04.56', '2024-01-20 12:00:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (3, 'E05.67', '2024-01-22 10:30:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (3, 'F06.78', '2024-01-25 11:45:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (4, 'G07.89', '2024-01-30 14:20:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (4, 'H08.90', '2024-02-02 15:30:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (5, 'I09.01', '2024-02-05 16:45:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (5, 'J10.12', '2024-02-10 18:00:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (6, 'K11.23', '2024-02-12 08:00:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (6, 'L12.34', '2024-02-15 11:30:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (7, 'M13.45', '2024-02-20 09:45:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (7, 'N14.56', '2024-02-22 12:00:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (8, 'O15.67', '2024-02-25 10:30:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (8, 'P16.78', '2024-02-28 11:45:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (9, 'Q17.89', '2024-03-05 14:20:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (9, 'R18.90', '2024-03-08 15:30:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (10, 'S19.01', '2024-03-10 16:45:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (10, 'T20.12', '2024-03-15 18:00:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (11, 'U21.23', '2024-03-20 08:00:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (11, 'V22.34', '2024-03-22 11:30:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (12, 'W23.45', '2024-03-25 09:45:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (12, 'X24.56', '2024-03-28 12:00:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (13, 'Y25.67', '2024-04-02 10:30:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (13, 'Z26.78', '2024-04-05 11:45:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (14, 'A27.89', '2024-04-10 14:20:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (14, 'B28.90', '2024-04-12 15:30:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (15, 'C29.01', '2024-04-15 16:45:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (15, 'D30.12', '2024-04-20 18:00:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (16, 'E31.23', '2024-04-22 08:00:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (16, 'F32.34', '2024-04-25 11:30:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (17, 'G33.45', '2024-04-30 09:45:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (17, 'H34.56', '2024-05-02 12:00:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (18, 'I35.67', '2024-05-05 10:30:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (18, 'J36.78', '2024-05-08 11:45:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (19, 'K37.89', '2024-05-10 14:20:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (19, 'L38.90', '2024-05-12 15:30:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (20, 'M39.01', '2024-05-15 16:45:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (20, 'N40.12', '2024-05-20 18:00:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (21, 'A41.23', '2024-05-22 08:00:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (21, 'B42.34', '2024-05-25 11:30:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (22, 'C43.45', '2024-05-30 09:45:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (22, 'D44.56', '2024-06-02 12:00:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (23, 'E45.67', '2024-06-05 10:30:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (23, 'F46.78', '2024-06-08 11:45:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (24, 'G47.89', '2024-06-10 14:20:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (24, 'H48.90', '2024-06-12 15:30:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (25, 'I49.01', '2024-06-15 16:45:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (25, 'J50.12', '2024-06-20 18:00:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (26, 'K51.23', '2024-06-22 08:00:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (26, 'L52.34', '2024-06-25 11:30:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (27, 'M53.45', '2024-06-30 09:45:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (27, 'N54.56', '2024-07-02 12:00:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (28, 'O55.67', '2024-07-05 10:30:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (28, 'P56.78', '2024-07-08 11:45:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (29, 'Q57.89', '2024-07-10 14:20:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (29, 'R58.90', '2024-07-12 15:30:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (30, 'S59.01', '2024-07-15 16:45:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (30, 'T60.12', '2024-07-20 18:00:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (31, 'U61.23', '2024-07-22 08:00:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (31, 'V62.34', '2024-07-25 11:30:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (32, 'W63.45', '2024-07-30 09:45:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (32, 'X64.56', '2024-08-02 12:00:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (33, 'Y65.67', '2024-08-05 10:30:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (33, 'Z66.78', '2024-08-08 11:45:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (34, 'A67.89', '2024-08-10 14:20:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (34, 'B68.90', '2024-08-12 15:30:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (35, 'C69.01', '2024-08-15 16:45:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (35, 'D70.12', '2024-08-20 18:00:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (36, 'E71.23', '2024-08-22 08:00:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (36, 'F72.34', '2024-08-25 11:30:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (37, 'G73.45', '2024-08-30 09:45:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (37, 'H74.56', '2024-09-02 12:00:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (38, 'I75.67', '2024-09-05 10:30:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (38, 'J76.78', '2024-09-08 11:45:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (39, 'K77.89', '2024-09-10 14:20:00');
INSERT INTO public.diagnosen (id_patient, icd_diagnose, "gültigkeitsdatum") VALUES (39, 'L78.90', '2024-09-12 15:30:00');


--
-- TOC entry 5032 (class 0 OID 18909)
-- Dependencies: 247
-- Data for Name: dienstplan; Type: TABLE DATA; Schema: public; Owner: emmelie
--

INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (1, 1, '2023-08-15');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (2, 2, '2023-08-16');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (3, 3, '2023-08-17');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (4, 1, '2024-08-18');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (5, 2, '2024-08-19');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (6, 3, '2024-08-20');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (7, 1, '2023-08-18');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (8, 2, '2023-08-19');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (9, 3, '2023-08-20');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (10, 1, '2023-08-21');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (11, 2, '2023-08-22');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (12, 3, '2023-08-23');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (13, 1, '2023-08-24');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (14, 4, '2023-08-25');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (15, 3, '2023-08-26');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (16, 1, '2023-08-27');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (17, 5, '2023-08-28');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (18, 3, '2023-08-29');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (19, 4, '2023-08-30');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (20, 2, '2023-08-31');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (21, 3, '2023-09-01');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (22, 5, '2023-09-02');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (23, 2, '2023-09-03');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (24, 3, '2023-09-04');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (25, 1, '2023-09-05');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (26, 2, '2023-09-06');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (27, 3, '2023-09-07');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (28, 1, '2023-09-08');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (29, 2, '2023-09-09');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (30, 3, '2023-09-10');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (31, 1, '2023-09-11');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (32, 4, '2023-09-12');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (33, 3, '2023-09-13');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (34, 4, '2023-09-14');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (35, 2, '2023-09-15');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (36, 3, '2023-09-16');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (37, 1, '2023-09-17');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (38, 2, '2023-09-18');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (39, 3, '2023-09-19');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (40, 1, '2023-09-20');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (41, 4, '2023-09-21');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (42, 3, '2023-09-22');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (43, 5, '2023-09-23');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (44, 5, '2023-09-24');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (45, 3, '2023-09-25');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (46, 5, '2023-09-26');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (47, 2, '2023-09-27');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (48, 3, '2023-09-28');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (49, 1, '2023-09-29');
INSERT INTO public.dienstplan (id_mitarbeiter, id_schicht, datum) VALUES (50, 2, '2023-09-30');


--
-- TOC entry 5031 (class 0 OID 18887)
-- Dependencies: 246
-- Data for Name: dokumentation; Type: TABLE DATA; Schema: public; Owner: emmelie
--

INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (1, 1, 1, 1, '2023-08-15 10:00:00', 'Pflegeeinsatz erfolgreich abgeschlossen.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (2, 3, 2, 1, '2023-08-16 09:30:00', 'Patient zeigte verbesserte Reaktion auf Medikation.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (3, 3, 1, 2, '2023-08-17 11:45:00', 'Plan für weitere Pflegeeinsätze erstellt.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (4, 2, 3, 2, '2023-08-18 14:20:00', 'Medikation wurde angepasst.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (5, 1, 4, 3, '2023-08-19 08:45:00', 'Verbandwechsel durchgeführt.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (6, 4, 5, 4, '2023-08-20 12:30:00', 'Patient für Rehabilitationsprogramm empfohlen.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (7, 7, 8, 15, '2022-05-25 11:45:00', 'Medikamentendosierung angepasst.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (8, 8, 12, 20, '2022-05-30 10:00:00', 'Rehabilitationsplan aktualisiert.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (9, 9, 16, 25, '2022-06-02 12:15:00', 'Pflegeeinsatz erfolgreich abgeschlossen.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (10, 10, 20, 30, '2022-06-05 10:45:00', 'Notfallversorgung durchgeführt.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (11, 11, 24, 35, '2022-06-08 12:00:00', 'Patientenfortschritt überwacht.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (12, 12, 28, 20, '2022-06-10 14:30:00', 'Ernährungsplan erstellt.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (13, 13, 32, 15, '2022-06-12 15:45:00', 'Therapieempfehlung ausgesprochen.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (14, 14, 36, 50, '2022-06-15 17:00:00', 'Patientenreaktion auf Medikation überprüft.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (15, 15, 20, 5, '2022-06-20 18:15:00', 'Pflegeeinsatzplanung abgeschlossen.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (16, 16, 4, 10, '2022-06-22 08:15:00', 'Verbandwechsel durchgeführt.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (17, 17, 8, 15, '2022-06-25 12:00:00', 'Medikationsplan aktualisiert.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (18, 18, 2, 20, '2022-06-30 10:15:00', 'Rehabilitationsfortschritt bewertet.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (19, 19, 6, 25, '2022-07-02 12:30:00', 'Patientenstatus überprüft.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (20, 20, 10, 30, '2022-07-05 11:00:00', 'Ernährungsempfehlungen übermittelt.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (21, 21, 14, 35, '2022-07-08 12:15:00', 'Pflegeeinsatz erfolgreich abgeschlossen.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (22, 22, 18, 40, '2022-07-10 14:45:00', 'Patientenreaktion auf Medikation dokumentiert.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (23, 23, 22, 45, '2022-07-12 16:00:00', 'Notfallversorgung durchgeführt.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (24, 24, 26, 50, '2022-07-15 17:15:00', 'Therapieplan aktualisiert.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (25, 25, 30, 5, '2022-07-20 18:30:00', 'Verbandwechsel durchgeführt.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (26, 26, 34, 10, '2022-07-22 08:30:00', 'Patientenfortschritt bewertet.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (27, 27, 38, 15, '2022-07-25 12:15:00', 'Medikamentendosierung angepasst.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (28, 28, 2, 20, '2022-07-30 10:30:00', 'Rehabilitationsplan aktualisiert.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (29, 29, 6, 25, '2022-08-02 12:45:00', 'Pflegeeinsatz erfolgreich abgeschlossen.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (30, 30, 30, 30, '2023-08-15 10:15:00', 'Patientenstatus überprüft.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (31, 31, 3, 35, '2023-08-16 09:45:00', 'Medikamentendosierung angepasst.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (32, 32, 7, 40, '2023-08-17 12:00:00', 'Rehabilitationsplan aktualisiert.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (33, 33, 11, 45, '2023-08-15 15:15:00', 'Pflegeeinsatz erfolgreich abgeschlossen.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (34, 34, 15, 50, '2023-08-16 12:45:00', 'Notfallversorgung durchgeführt.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (35, 35, 19, 5, '2023-08-17 17:00:00', 'Patientenfortschritt bewertet.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (36, 36, 23, 10, '2023-08-18 18:15:00', 'Ernährungsplan erstellt.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (37, 37, 27, 15, '2023-08-19 08:30:00', 'Therapieempfehlung ausgesprochen.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (38, 38, 31, 20, '2023-08-20 10:45:00', 'Patientenreaktion auf Medikation überprüft.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (39, 39, 35, 25, '2023-08-15 12:00:00', 'Pflegeeinsatzplanung abgeschlossen.');
INSERT INTO public.dokumentation (id_dokumentation, id_pflegeeinsatz, id_patient, id_mitarbeiter, zeitpunkt, beschreibung) OVERRIDING SYSTEM VALUE VALUES (40, 40, 39, 30, '2023-08-16 14:15:00', 'Verbandwechsel durchgeführt.');


--
-- TOC entry 5029 (class 0 OID 18866)
-- Dependencies: 244
-- Data for Name: evaluation; Type: TABLE DATA; Schema: public; Owner: emmelie
--

INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (1, '2023-08-15 10:00:00', 1, 1, 1, 'sehr gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (2, '2023-08-16 09:30:00', 2, 2, 2, 'ok');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (3, '2023-08-17 11:45:00', 3, 3, 3, 'gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (4, '2024-08-15 15:00:00', 5, 6, 2, 'sehr schlecht');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (5, '2022-08-16 12:30:00', 7, 8, 4, 'schlecht');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (6, '2023-08-17 16:45:00', 3, 2, 6, 'gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (7, '2022-05-22 08:00:00', 4, 8, 1, 'gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (8, '2022-05-25 11:30:00', 6, 12, 2, 'sehr gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (9, '2022-05-30 09:45:00', 8, 16, 3, 'ok');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (10, '2022-06-02 12:00:00', 10, 20, 4, 'schlecht');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (11, '2022-06-05 10:30:00', 12, 24, 5, 'sehr schlecht');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (12, '2022-06-08 11:45:00', 14, 28, 6, 'gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (13, '2022-06-10 14:20:00', 16, 32, 1, 'sehr gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (14, '2022-06-12 15:30:00', 18, 36, 2, 'ok');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (15, '2022-06-15 16:45:00', 20, 20, 3, 'gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (16, '2022-06-20 18:00:00', 22, 14, 4, 'sehr schlecht');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (17, '2022-06-22 08:00:00', 24, 8, 5, 'ok');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (18, '2022-06-25 11:30:00', 26, 2, 6, 'gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (19, '2022-06-30 09:45:00', 28, 6, 1, 'sehr schlecht');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (20, '2022-07-02 12:00:00', 30, 10, 2, 'sehr gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (21, '2022-07-05 10:30:00', 32, 14, 3, 'schlecht');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (22, '2022-07-08 11:45:00', 34, 18, 4, 'gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (23, '2022-07-10 14:20:00', 36, 22, 5, 'sehr schlecht');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (24, '2022-07-12 15:30:00', 38, 26, 6, 'gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (25, '2022-07-15 16:45:00', 40, 30, 1, 'sehr gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (26, '2022-07-20 18:00:00', 42, 34, 2, 'ok');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (27, '2022-07-22 08:00:00', 44, 38, 3, 'gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (28, '2022-07-25 11:30:00', 46, 2, 4, 'schlecht');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (29, '2022-07-30 09:45:00', 48, 4, 5, 'sehr schlecht');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (30, '2022-08-02 12:00:00', 50, 1, 6, 'gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (31, '2023-08-15 10:00:00', 1, 3, 1, 'sehr gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (32, '2023-08-16 09:30:00', 2, 7, 2, 'ok');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (33, '2023-08-17 11:45:00', 3, 11, 3, 'gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (34, '2023-08-15 15:00:00', 5, 15, 2, 'sehr schlecht');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (35, '2023-08-16 12:30:00', 7, 19, 4, 'schlecht');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (36, '2023-08-17 16:45:00', 3, 23, 6, 'gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (37, '2023-05-22 08:00:00', 4, 27, 1, 'gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (38, '2023-05-25 11:30:00', 6, 31, 2, 'sehr gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (39, '2023-05-30 09:45:00', 8, 35, 3, 'ok');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (40, '2023-06-02 12:00:00', 10, 39, 4, 'schlecht');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (41, '2023-06-05 10:30:00', 12, 33, 5, 'sehr schlecht');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (42, '2023-06-08 11:45:00', 14, 17, 6, 'gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (43, '2023-06-10 14:20:00', 16, 2, 1, 'sehr gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (44, '2023-06-12 15:30:00', 18, 6, 2, 'ok');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (45, '2023-06-15 16:45:00', 20, 10, 3, 'gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (46, '2023-06-20 18:00:00', 22, 14, 4, 'sehr schlecht');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (47, '2023-06-22 08:00:00', 24, 18, 5, 'ok');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (48, '2023-06-25 11:30:00', 26, 22, 6, 'gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (49, '2023-06-30 09:45:00', 28, 26, 1, 'sehr schlecht');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (50, '2023-07-02 12:00:00', 30, 30, 2, 'sehr gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (51, '2023-07-05 10:30:00', 32, 34, 3, 'schlecht');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (52, '2023-07-08 11:45:00', 34, 38, 4, 'gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (53, '2023-07-10 14:20:00', 36, 12, 5, 'sehr schlecht');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (54, '2023-07-12 15:30:00', 38, 6, 6, 'gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (55, '2023-07-15 16:45:00', 40, 5, 1, 'sehr gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (56, '2023-07-20 18:00:00', 42, 4, 2, 'ok');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (57, '2023-07-22 08:00:00', 44, 8, 3, 'gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (58, '2023-07-25 11:30:00', 46, 12, 4, 'schlecht');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (59, '2023-07-30 09:45:00', 48, 16, 5, 'sehr schlecht');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (60, '2023-08-02 12:00:00', 50, 20, 6, 'gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (61, '2024-08-15 10:00:00', 1, 24, 1, 'sehr gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (62, '2024-08-16 09:30:00', 2, 28, 2, 'ok');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (63, '2024-08-17 11:45:00', 3, 32, 3, 'gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (64, '2024-08-15 15:00:00', 5, 36, 2, 'sehr schlecht');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (65, '2024-08-16 12:30:00', 7, 30, 4, 'schlecht');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (66, '2024-08-17 16:45:00', 3, 14, 6, 'gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (67, '2024-05-22 08:00:00', 4, 28, 1, 'gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (68, '2024-05-25 11:30:00', 6, 2, 2, 'sehr gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (69, '2024-05-30 09:45:00', 8, 6, 3, 'ok');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (70, '2024-06-02 12:00:00', 10, 10, 4, 'schlecht');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (71, '2024-06-05 10:30:00', 12, 14, 5, 'sehr schlecht');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (72, '2024-06-08 11:45:00', 14, 18, 6, 'gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (73, '2024-06-10 14:20:00', 16, 22, 1, 'sehr gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (74, '2024-06-12 15:30:00', 18, 26, 2, 'ok');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (75, '2024-06-15 16:45:00', 20, 30, 3, 'gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (76, '2024-06-20 18:00:00', 22, 34, 4, 'sehr schlecht');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (77, '2024-06-22 08:00:00', 24, 38, 5, 'ok');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (78, '2024-06-25 11:30:00', 26, 2, 6, 'gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (79, '2024-06-30 09:45:00', 28, 16, 1, 'sehr schlecht');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (80, '2024-07-02 12:00:00', 30, 5, 2, 'sehr gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (81, '2024-07-05 10:30:00', 32, 4, 3, 'schlecht');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (82, '2024-07-08 11:45:00', 34, 8, 4, 'gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (83, '2024-07-10 14:20:00', 36, 12, 5, 'sehr schlecht');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (84, '2024-07-12 15:30:00', 38, 16, 6, 'gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (85, '2024-07-15 16:45:00', 40, 20, 1, 'sehr gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (86, '2024-07-20 18:00:00', 42, 24, 2, 'ok');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (87, '2024-07-22 08:00:00', 44, 28, 3, 'gut');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (88, '2024-07-25 11:30:00', 46, 32, 4, 'schlecht');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (89, '2024-07-30 09:45:00', 48, 36, 5, 'sehr schlecht');
INSERT INTO public.evaluation (nr_evaluation, datum, id_mitarbeiter, id_patient, id_frage, bewertung) OVERRIDING SYSTEM VALUE VALUES (90, '2024-08-02 12:00:00', 50, 10, 6, 'gut');


--
-- TOC entry 5002 (class 0 OID 18679)
-- Dependencies: 217
-- Data for Name: firmenfahrzeuge; Type: TABLE DATA; Schema: public; Owner: emmelie
--

INSERT INTO public.firmenfahrzeuge (kennzeichen, kilometerstand, einheit, fahrzeugkategorie, kraftstoff) VALUES ('ABC-XY-123', 12000, 'km', 'Kleinwagen', 'Benzin');
INSERT INTO public.firmenfahrzeuge (kennzeichen, kilometerstand, einheit, fahrzeugkategorie, kraftstoff) VALUES ('DEF-ZZ-456', 8500, 'km', 'Transporter', 'Diesel');
INSERT INTO public.firmenfahrzeuge (kennzeichen, kilometerstand, einheit, fahrzeugkategorie, kraftstoff) VALUES ('GHI-AB-789', 22000, 'km', 'Limousine', 'Elektro');
INSERT INTO public.firmenfahrzeuge (kennzeichen, kilometerstand, einheit, fahrzeugkategorie, kraftstoff) VALUES ('ABC-YX-123', 50000, 'km', 'Kleinwagen', 'Benzin');
INSERT INTO public.firmenfahrzeuge (kennzeichen, kilometerstand, einheit, fahrzeugkategorie, kraftstoff) VALUES ('DEF-ZI-567', 70000, 'km', 'Kombi', 'Diesel');
INSERT INTO public.firmenfahrzeuge (kennzeichen, kilometerstand, einheit, fahrzeugkategorie, kraftstoff) VALUES ('DEF-MN-901', 30000, 'km', 'SUV', 'Elektro');
INSERT INTO public.firmenfahrzeuge (kennzeichen, kilometerstand, einheit, fahrzeugkategorie, kraftstoff) VALUES ('ABC-RS-345', 90000, 'km', 'Kleinwagen', 'Benzin');
INSERT INTO public.firmenfahrzeuge (kennzeichen, kilometerstand, einheit, fahrzeugkategorie, kraftstoff) VALUES ('GHI-WX-789', 60000, 'km', 'Transporter', 'Diesel');
INSERT INTO public.firmenfahrzeuge (kennzeichen, kilometerstand, einheit, fahrzeugkategorie, kraftstoff) VALUES ('GHI-BC-234', 40000, 'km', 'Elektroauto', 'Elektro');


--
-- TOC entry 5010 (class 0 OID 18729)
-- Dependencies: 225
-- Data for Name: fragebogenkatalog; Type: TABLE DATA; Schema: public; Owner: emmelie
--

INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (1, 'Umgang mit Patienten', 'Wie zufrieden waren Sie mit dem Umgang Ihnen gegenüber?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (2, 'Pünktlichkeit', 'Wie zufrieden waren Sie mit der Pünktlichkeit des Personals?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (3, 'Befinden', 'Fühlen wohl fühlen Sie sich dem Personal gegenüber?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (4, 'Körperliche Gesundheit', 'Wie bewerten Sie Ihr derzeitiges körperliches Befinden?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (5, 'Psychische Verfassung', 'Fühlen sie sich psychisch stabil?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (6, 'Soziales Umfeld', 'Wie gut unterstützen wir Sie in Ihrem sozialen Umfeld?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (7, 'Medikamenteneinnahme', 'Wie gut unterstützen wir Sie bei der Medikamenteneinnahme');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (8, 'Lebensqualität', 'Wie gut fördern wir Ihre Lebensqualität?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (9, 'Ernährung', 'Wie gut unterstützen wir Sie in Ihrer Ernährung?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (10, 'Pflegequalität', 'Wie zufrieden sind Sie mit der Qualität der Pflege?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (11, 'Sauberkeit', 'Wie bewerten Sie die Sauberkeit in Ihrer Umgebung?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (12, 'Kommunikation', 'Wie gut kommunizieren wir mit Ihnen?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (13, 'Privatsphäre', 'Fühlen Sie sich in Ihrer Privatsphäre respektiert?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (14, 'Informationstransparenz', 'Wie transparent halten wir Sie über Ihre Pflege informiert?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (15, 'Behandlungsplanung', 'Wie gut erklären wir Ihnen Ihre Behandlungspläne?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (16, 'Schmerzmanagement', 'Wie effektiv wird Ihr Schmerzmanagement behandelt?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (17, 'Notfallreaktion', 'Wie zufrieden sind Sie mit unserer Reaktion auf Notfälle?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (18, 'Beschwerdemanagement', 'Wie gut handhaben wir Ihre Beschwerden?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (19, 'Koordinierung der Dienstleistungen', 'Wie gut koordinieren wir die verschiedenen Dienstleistungen für Sie?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (20, 'Austausch von Informationen', 'Wie gut tauschen wir relevante Informationen mit Ihnen aus?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (21, 'Respektvolle Behandlung', 'Fühlen Sie sich respektvoll behandelt?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (22, 'Hilfe bei der Selbstpflege', 'Wie gut unterstützen wir Sie bei der Selbstpflege?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (23, 'Familienunterstützung', 'Wie gut unterstützen wir Ihre Familie in der Pflege?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (24, 'Kontinuität der Pflege', 'Wie zufrieden sind Sie mit der Kontinuität Ihrer Pflege?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (25, 'Sicherheitsmaßnahmen', 'Wie sicher fühlen Sie sich in Ihrer Umgebung?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (26, 'Verfügbarkeit des Personals', 'Wie zufrieden sind Sie mit der Verfügbarkeit des Personals?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (27, 'Koordination von Terminen', 'Wie gut koordinieren wir Ihre Termine?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (28, 'Einhaltung des Zeitplans', 'Wie gut halten wir den vereinbarten Zeitplan ein?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (29, 'Erfüllung individueller Bedürfnisse', 'Wie gut erfüllen wir Ihre individuellen Bedürfnisse?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (30, 'Barrierefreiheit', 'Wie barrierefrei ist unsere Einrichtung für Sie?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (31, 'Respekt für Ihre Entscheidungen', 'Fühlen Sie sich respektiert in Bezug auf Ihre Entscheidungen?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (32, 'Unterstützung bei Aktivitäten des täglichen Lebens', 'Wie gut unterstützen wir Sie bei alltäglichen Aktivitäten?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (33, 'Einhaltung von Datenschutzrichtlinien', 'Wie gut halten wir Datenschutzrichtlinien ein?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (34, 'Zufriedenheit mit Mahlzeiten', 'Wie zufrieden sind Sie mit den bereitgestellten Mahlzeiten?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (35, 'Achtung der religiösen Überzeugungen', 'Fühlen Sie sich respektiert in Bezug auf Ihre religiösen Überzeugungen?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (36, 'Verfügbarkeit von Hilfsmitteln', 'Wie gut sind die benötigten Hilfsmittel für Sie verfügbar?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (37, 'Achtung der kulturellen Bedürfnisse', 'Fühlen Sie sich respektiert in Bezug auf Ihre kulturellen Bedürfnisse?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (38, 'Bereitstellung von Bildungsmaterial', 'Wie gut informieren wir Sie mit Bildungsmaterial über Ihre Pflege?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (39, 'Effektive Schmerzkontrolle', 'Wie effektiv wird Ihr Schmerz kontrolliert?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (40, 'Zufriedenheit mit Unterstützungsdiensten', 'Wie zufrieden sind Sie mit den angebotenen Unterstützungsdiensten?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (41, 'Achtung der Privatsphäre bei Behandlungen', 'Fühlen Sie sich in Ihrer Privatsphäre während der Behandlungen respektiert?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (42, 'Bewältigung von Stress', 'Wie gut unterstützen wir Sie bei der Bewältigung von Stress?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (43, 'Verfügbarkeit von Freizeitaktivitäten', 'Wie zufrieden sind Sie mit der Verfügbarkeit von Freizeitaktivitäten?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (44, 'Einhaltung von Ethikrichtlinien', 'Wie gut halten wir ethische Richtlinien in der Pflege ein?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (45, 'Zufriedenheit mit therapeutischen Diensten', 'Wie zufrieden sind Sie mit den angebotenen therapeutischen Diensten?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (46, 'Respekt für die Würde', 'Fühlen Sie sich respektiert in Bezug auf Ihre Würde?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (47, 'Achtung der sexuellen Identität', 'Fühlen Sie sich respektiert in Bezug auf Ihre sexuelle Identität?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (48, 'Zufriedenheit mit psychosozialen Dienstleistungen', 'Wie zufrieden sind Sie mit den angebotenen psychosozialen Dienstleistungen?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (49, 'Achtung der Autonomie', 'Fühlen Sie sich respektiert in Bezug auf Ihre Autonomie?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (50, 'Zufriedenheit mit Rehabilitationsdiensten', 'Wie zufrieden sind Sie mit den angebotenen Rehabilitationsdiensten?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (51, 'Einhaltung von Hygienestandards', 'Wie gut halten wir Hygienestandards in unserer Einrichtung ein?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (52, 'Zufriedenheit mit Pflegeberatung', 'Wie zufrieden sind Sie mit der angebotenen Pflegeberatung?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (53, 'Achtung der Intimsphäre', 'Fühlen Sie sich respektiert in Bezug auf Ihre Intimsphäre?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (54, 'Zufriedenheit mit Pflegeplanung', 'Wie zufrieden sind Sie mit der erstellten Pflegeplanung?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (55, 'Achtung der Gleichberechtigung', 'Fühlen Sie sich gleichberechtigt in unserer Einrichtung?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (56, 'Zufriedenheit mit spirituellen Dienstleistungen', 'Wie zufrieden sind Sie mit den angebotenen spirituellen Dienstleistungen?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (57, 'Einhaltung von Umweltschutzrichtlinien', 'Wie gut halten wir Umweltschutzrichtlinien in unserer Einrichtung ein?');
INSERT INTO public.fragebogenkatalog (id_frage, kategorie, beschreibung) OVERRIDING SYSTEM VALUE VALUES (58, 'Zufriedenheit mit Aktivitätstherapie', 'Wie zufrieden sind Sie mit den angebotenen Aktivitätstherapien?');


--
-- TOC entry 5008 (class 0 OID 18719)
-- Dependencies: 223
-- Data for Name: kostenträger; Type: TABLE DATA; Schema: public; Owner: emmelie
--

INSERT INTO public."kostenträger" ("id_kostenträger", name, plz, "straße", hausnummer) OVERRIDING SYSTEM VALUE VALUES (1, 'Krankenkasse XYZ', '12345', 'Musterstraße 1', '12');
INSERT INTO public."kostenträger" ("id_kostenträger", name, plz, "straße", hausnummer) OVERRIDING SYSTEM VALUE VALUES (2, 'Unfallversicherung ABC', '54321', 'Beispielweg 5', '3a');
INSERT INTO public."kostenträger" ("id_kostenträger", name, plz, "straße", hausnummer) OVERRIDING SYSTEM VALUE VALUES (3, 'Pflegekasse DEF', '98765', 'Testgasse 8', '7');
INSERT INTO public."kostenträger" ("id_kostenträger", name, plz, "straße", hausnummer) OVERRIDING SYSTEM VALUE VALUES (4, 'Krankenkasse A', '12345', 'Hauptstraße 1', '5');
INSERT INTO public."kostenträger" ("id_kostenträger", name, plz, "straße", hausnummer) OVERRIDING SYSTEM VALUE VALUES (5, 'Versicherung B', '54321', 'Nebenweg 2', '9c');
INSERT INTO public."kostenträger" ("id_kostenträger", name, plz, "straße", hausnummer) OVERRIDING SYSTEM VALUE VALUES (6, 'Pflegedienst C', '98765', 'Parkweg 3', '10');
INSERT INTO public."kostenträger" ("id_kostenträger", name, plz, "straße", hausnummer) OVERRIDING SYSTEM VALUE VALUES (7, 'Krankenkasse D', '13579', 'Bachgasse 4', '18b');
INSERT INTO public."kostenträger" ("id_kostenträger", name, plz, "straße", hausnummer) OVERRIDING SYSTEM VALUE VALUES (8, 'Versicherung E', '24680', 'Gartenallee 5', '22');
INSERT INTO public."kostenträger" ("id_kostenträger", name, plz, "straße", hausnummer) OVERRIDING SYSTEM VALUE VALUES (9, 'Krankenkasse F', '87654', 'Drosselstraße 6', '7');
INSERT INTO public."kostenträger" ("id_kostenträger", name, plz, "straße", hausnummer) OVERRIDING SYSTEM VALUE VALUES (10, 'Versicherung G', '11111', 'Hauptplatz 7', '3a');
INSERT INTO public."kostenträger" ("id_kostenträger", name, plz, "straße", hausnummer) OVERRIDING SYSTEM VALUE VALUES (11, 'Krankenkasse H', '22222', 'Sonnenweg 8', '14');
INSERT INTO public."kostenträger" ("id_kostenträger", name, plz, "straße", hausnummer) OVERRIDING SYSTEM VALUE VALUES (12, 'Versicherung I', '33333', 'Mondstraße 9', '5c');
INSERT INTO public."kostenträger" ("id_kostenträger", name, plz, "straße", hausnummer) OVERRIDING SYSTEM VALUE VALUES (13, 'Pflegedienst J', '44444', 'Regenplatz 10', '2');
INSERT INTO public."kostenträger" ("id_kostenträger", name, plz, "straße", hausnummer) OVERRIDING SYSTEM VALUE VALUES (14, 'Krankenkasse K', '55555', 'Blumenallee 11', '8b');
INSERT INTO public."kostenträger" ("id_kostenträger", name, plz, "straße", hausnummer) OVERRIDING SYSTEM VALUE VALUES (15, 'Versicherung L', '66666', 'Waldgasse 12', '17');
INSERT INTO public."kostenträger" ("id_kostenträger", name, plz, "straße", hausnummer) OVERRIDING SYSTEM VALUE VALUES (16, 'Krankenkasse M', '77777', 'Bergstraße 13', '6');
INSERT INTO public."kostenträger" ("id_kostenträger", name, plz, "straße", hausnummer) OVERRIDING SYSTEM VALUE VALUES (17, 'Versicherung N', '88888', 'Seestraße 14', '3b');
INSERT INTO public."kostenträger" ("id_kostenträger", name, plz, "straße", hausnummer) OVERRIDING SYSTEM VALUE VALUES (18, 'Krankenkasse O', '99999', 'Wiesenweg 15', '9');
INSERT INTO public."kostenträger" ("id_kostenträger", name, plz, "straße", hausnummer) OVERRIDING SYSTEM VALUE VALUES (19, 'Versicherung P', '10101', 'Bachstraße 16', '11c');
INSERT INTO public."kostenträger" ("id_kostenträger", name, plz, "straße", hausnummer) OVERRIDING SYSTEM VALUE VALUES (20, 'Pflegedienst Q', '12121', 'Berggasse 17', '4');


--
-- TOC entry 5001 (class 0 OID 18658)
-- Dependencies: 216
-- Data for Name: mitarbeiter; Type: TABLE DATA; Schema: public; Owner: emmelie
--

INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (1, 'Max', 'Mustermann', '1990-05-15 00:00:00', 'Pflegefachkraft', 'Stationäre Pflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (2, 'Anna', 'Beispiel', '1985-09-20 00:00:00', 'Krankenschwester', 'Ambulante Pflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (3, 'Felix', 'Muster', '1988-11-03 00:00:00', 'Altenpfleger', 'Mobile Pflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (4, 'Helena', 'Schmidt', '1990-07-25 00:00:00', 'Altenpfleger', 'Ambulante Pflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (5, 'Julia', 'Müller', '1980-12-10 00:00:00', 'Krankenschwester', 'Intensivpflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (6, 'Jan', 'Wagner', '1976-09-02 00:00:00', 'Pflegehelfer', 'Gerontopsychiatrie');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (7, 'Sophie', 'Koch', '1995-04-20 00:00:00', 'Pflegedienstleitung', 'Heimleitung');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (8, 'Simon', 'Hoffmann', '1988-11-18 00:00:00', 'Gesundheits- und Krankenpfleger', 'Onkologie');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (9, 'Laura', 'Weber', '1992-03-08 00:00:00', 'Krankenschwester', 'Ambulante Pflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (10, 'Tobias', 'Schulz', '1984-06-14 00:00:00', 'Altenpfleger', 'Mobile Pflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (11, 'Lea', 'Fischer', '1987-09-30 00:00:00', 'Pflegefachkraft', 'Stationäre Pflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (12, 'Nico', 'Bauer', '1993-12-05 00:00:00', 'Pflegehelfer', 'Gerontopsychiatrie');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (13, 'Lena', 'Kühn', '1982-08-22 00:00:00', 'Gesundheits- und Krankenpfleger', 'Onkologie');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (14, 'Tom', 'Lange', '1991-04-18 00:00:00', 'Altenpfleger', 'Ambulante Pflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (15, 'Hannah', 'Schneider', '1989-11-15 00:00:00', 'Krankenschwester', 'Intensivpflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (16, 'Marcel', 'Herrmann', '1978-07-03 00:00:00', 'Pflegedienstleitung', 'Heimleitung');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (17, 'Sophia', 'Huber', '1985-02-09 00:00:00', 'Pflegefachkraft', 'Mobile Pflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (18, 'Daniel', 'Walter', '1994-06-27 00:00:00', 'Gesundheits- und Krankenpfleger', 'Stationäre Pflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (19, 'Lisa', 'Meyer', '1983-09-12 00:00:00', 'Pflegehelfer', 'Gerontopsychiatrie');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (20, 'Tim', 'Schmidt', '1990-01-25 00:00:00', 'Altenpfleger', 'Ambulante Pflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (21, 'Melanie', 'Keller', '1986-04-11 00:00:00', 'Pflegefachkraft', 'Intensivpflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (22, 'Michael', 'Lehmann', '1977-10-18 00:00:00', 'Krankenschwester', 'Onkologie');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (23, 'Vanessa', 'Schmitt', '1996-05-20 00:00:00', 'Pflegehelfer', 'Heimleitung');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (24, 'Patrick', 'Becker', '1981-12-02 00:00:00', 'Gesundheits- und Krankenpfleger', 'Mobile Pflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (25, 'Isabella', 'Richter', '1988-08-28 00:00:00', 'Altenpfleger', 'Stationäre Pflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (26, 'Marco', 'Schulze', '1995-03-15 00:00:00', 'Krankenschwester', 'Ambulante Pflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (27, 'Jessica', 'Wolf', '1980-06-10 00:00:00', 'Pflegefachkraft', 'Intensivpflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (28, 'Andreas', 'Böhme', '1976-09-02 00:00:00', 'Pflegehelfer', 'Gerontopsychiatrie');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (29, 'Julia', 'Hofmann', '1993-04-20 00:00:00', 'Pflegedienstleitung', 'Heimleitung');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (30, 'Simon', 'Möller', '1988-11-18 00:00:00', 'Gesundheits- und Krankenpfleger', 'Onkologie');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (31, 'Katharina', 'Schuster', '1992-07-08 00:00:00', 'Krankenschwester', 'Mobile Pflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (32, 'Jonas', 'Lorenz', '1984-12-14 00:00:00', 'Altenpfleger', 'Stationäre Pflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (33, 'Marie', 'Schulz', '1987-09-30 00:00:00', 'Pflegefachkraft', 'Heimleitung');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (34, 'Alexander', 'Sauer', '1993-12-05 00:00:00', 'Pflegehelfer', 'Gerontopsychiatrie');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (35, 'Laura', 'Mayer', '1982-08-22 00:00:00', 'Gesundheits- und Krankenpfleger', 'Onkologie');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (36, 'Philipp', 'Vogel', '1991-04-18 00:00:00', 'Altenpfleger', 'Ambulante Pflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (37, 'Anna', 'Friedrich', '1989-11-15 00:00:00', 'Krankenschwester', 'Intensivpflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (38, 'Markus', 'Koch', '1978-07-03 00:00:00', 'Pflegedienstleitung', 'Mobile Pflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (39, 'Nina', 'Schäfer', '1985-02-09 00:00:00', 'Pflegefachkraft', 'Stationäre Pflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (40, 'Sebastian', 'Fischer', '1994-06-27 00:00:00', 'Gesundheits- und Krankenpfleger', 'Heimleitung');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (41, 'Laura', 'Werner', '1983-09-12 00:00:00', 'Pflegehelfer', 'Gerontopsychiatrie');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (42, 'Christian', 'Lehmann', '1990-01-25 00:00:00', 'Altenpfleger', 'Ambulante Pflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (43, 'Verena', 'Huber', '1986-04-11 00:00:00', 'Pflegefachkraft', 'Intensivpflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (44, 'Kevin', 'Schneider', '1977-10-18 00:00:00', 'Krankenschwester', 'Onkologie');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (45, 'Sandra', 'Keller', '1996-05-20 00:00:00', 'Pflegehelfer', 'Heimleitung');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (46, 'Andreas', 'Müller', '1981-12-02 00:00:00', 'Gesundheits- und Krankenpfleger', 'Mobile Pflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (47, 'Carolin', 'Richter', '1988-08-28 00:00:00', 'Altenpfleger', 'Stationäre Pflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (48, 'Stefan', 'Schulze', '1995-03-15 00:00:00', 'Krankenschwester', 'Ambulante Pflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (49, 'Nicole', 'Wolf', '1980-06-10 00:00:00', 'Pflegefachkraft', 'Intensivpflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (50, 'Johannes', 'Böhme', '1976-09-02 00:00:00', 'Pflegehelfer', 'Gerontopsychiatrie');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (51, 'Sophie', 'Hofmann', '1993-04-20 00:00:00', 'Pflegedienstleitung', 'Heimleitung');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (52, 'Fabian', 'Möller', '1988-11-18 00:00:00', 'Gesundheits- und Krankenpfleger', 'Onkologie');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (53, 'Kristina', 'Schuster', '1992-07-08 00:00:00', 'Krankenschwester', 'Mobile Pflege');
INSERT INTO public.mitarbeiter (id_mitarbeiter, vorname, nachname, geburtsdatum, qualifikation, "tätigkeitsfeld") OVERRIDING SYSTEM VALUE VALUES (54, 'David', 'Lorenz', '1984-12-14 00:00:00', 'Altenpfleger', 'Stationäre Pflege');


--
-- TOC entry 5006 (class 0 OID 18706)
-- Dependencies: 221
-- Data for Name: patienten; Type: TABLE DATA; Schema: public; Owner: emmelie
--

INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (1, 'Sophie', 'Schulze', '1960-09-18 00:00:00', 'Frau', 'Schulweg 7', '34567', '23a', '+499876543210', 'Dr. Mayer', 2);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (2, 'David', 'Becker', '1957-06-30 00:00:00', 'Mann', 'Beckerplatz 5', '56789', '9', '+498765432101', 'Dr. Schneider', 4);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (3, 'Lena', 'Hoffmann', '1940-12-04 00:00:00', 'Frau', 'Hoffmannstraße 12', '23456', '78', '+491234567890', 'Dr. Meier', 3);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (4, 'Max', 'Müller', '1978-05-12 00:00:00', 'Mann', 'Musterstraße 1', '12345', '12', '+49123456789', 'Dr. Schmidt', 3);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (5, 'Anna', 'Schmidt', '1933-09-20 00:00:00', 'Frau', 'Hauptweg 5', '54321', '7a', '+49876543210', 'Dr. Mayer', 2);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (6, 'Julia', 'Weber', '1962-02-28 00:00:00', 'Divers', 'Am Park 12', '98765', '101', '+490987654321', 'Dr. Wagner', 4);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (7, 'Felix', 'Becker', '1955-12-15 00:00:00', 'Mann', 'Bachstraße 8', '13579', '42b', '+491234567890', 'Dr. Meier', 1);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (8, 'Sophie', 'Schulz', '1951-06-08 00:00:00', 'Frau', 'Gartenweg 3', '24680', '15', '+49987654321', 'Dr. Müller', 5);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (9, 'Simon', 'Hofmann', '1945-11-25 00:00:00', 'Mann', 'Drosselweg 7', '87654', '3', '+490987654321', 'Dr. Fischer', 3);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (10, 'Elisabeth', 'Schulz', '1940-02-15 00:00:00', 'Frau', 'Ahornstraße 23', '98765', '15', '+498765432101', 'Dr. Müller', 4);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (11, 'Heinrich', 'Becker', '1935-08-10 00:00:00', 'Mann', 'Eichenweg 8', '23456', '33', '+490987654321', 'Dr. Meier', 3);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (12, 'Gertrud', 'Hoffmann', '1930-11-24 00:00:00', 'Frau', 'Rosenstraße 6', '34567', '14', '+499876543210', 'Dr. Mayer', 5);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (13, 'Walter', 'Müller', '1948-05-12 00:00:00', 'Mann', 'Fliederplatz 14', '54321', '8a', '+498765432101', 'Dr. Schneider', 2);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (14, 'Käthe', 'Schmidt', '1945-09-20 00:00:00', 'Frau', 'Kastanienweg 7', '87654', '29', '+490987654321', 'Dr. Fischer', 3);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (15, 'Hans', 'Hofmann', '1942-10-18 00:00:00', 'Mann', 'Ulmenstraße 3', '23456', '7c', '+491234567890', 'Dr. Wagner', 1);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (16, 'Erika', 'Schneider', '1936-04-11 00:00:00', 'Frau', 'Eichenallee 15', '98765', '105', '+49876543210', 'Dr. Müller', 2);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (17, 'Karl', 'Herrmann', '1940-09-26 00:00:00', 'Mann', 'Ulmenweg 3', '87654', '11', '+490987654321', 'Dr. Schmidt', 4);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (18, 'Ingrid', 'Huber', '1935-02-01 00:00:00', 'Frau', 'Kastanienweg 7', '23456', '25', '+491234567890', 'Dr. Meier', 3);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (19, 'Erwin', 'Walter', '1948-06-27 00:00:00', 'Mann', 'Lärchenstraße 2', '34567', '16', '+499876543210', 'Dr. Mayer', 2);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (20, 'Lieselotte', 'Meyer', '1932-09-12 00:00:00', 'Frau', 'Fliederplatz 17', '54321', '8a', '+498765432101', 'Dr. Schneider', 4);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (21, 'Günter', 'Schmidt', '1940-01-25 00:00:00', 'Mann', 'Amselweg 5', '98765', '32', '+49123456789', 'Dr. Fischer', 3);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (22, 'Ida', 'Keller', '1936-04-20 00:00:00', 'Frau', 'Kiefernstraße 9', '87654', '22', '+490987654321', 'Dr. Müller', 1);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (23, 'Wolfgang', 'Lehmann', '1933-10-18 00:00:00', 'Mann', 'Ahornweg 11', '23456', '5', '+491234567890', 'Dr. Wagner', 5);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (24, 'Elfriede', 'Schmitt', '1948-05-20 00:00:00', 'Frau', 'Buchenweg 17', '34567', '12b', '+498765432101', 'Dr. Schneider', 3);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (25, 'Gerd', 'Becker', '1931-12-02 00:00:00', 'Mann', 'Erlenstraße 8', '54321', '18', '+49123456789', 'Dr. Meier', 2);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (26, 'Irmgard', 'Richter', '1938-08-28 00:00:00', 'Frau', 'Kastanienplatz 6', '87654', '29', '+490987654321', 'Dr. Mayer', 4);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (27, 'Helmut', 'Schulze', '1945-03-15 00:00:00', 'Mann', 'Ulmenweg 3', '23456', '7c', '+491234567890', 'Dr. Fischer', 5);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (28, 'Hildegard', 'Friedrich', '1939-11-15 00:00:00', 'Divers', 'Lindenallee 10', '54321', '15', '+498765432101', 'Dr. Wagner', 3);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (29, 'Rudi', 'Möller', '1934-11-18 00:00:00', 'Mann', 'Rosenplatz 5', '98765', '23', '+49123456789', 'Dr. Schneider', 2);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (30, 'Elsa', 'Schuster', '1942-07-08 00:00:00', 'Frau', 'Ahornplatz 2', '34567', '4', '+490987654321', 'Dr. Meier', 4);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (31, 'Erich', 'Lorenz', '1936-12-14 00:00:00', 'Mann', 'Eichenstraße 7', '87654', '13', '+491234567890', 'Dr. Mayer', 3);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (32, 'Hannelore', 'Schulz', '1947-09-30 00:00:00', 'Frau', 'Fliederweg 6', '23456', '11', '+498765432101', 'Dr. Fischer', 1);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (33, 'Hermann', 'Sauer', '1943-12-05 00:00:00', 'Mann', 'Kiefernplatz 3', '54321', '9a', '+49123456789', 'Dr. Wagner', 5);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (34, 'Margarete', 'Schneider', '1939-11-15 00:00:00', 'Frau', 'Ahornweg 15', '87654', '17', '+490987654321', 'Dr. Schneider', 4);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (35, 'Alfred', 'Vogel', '1944-06-27 00:00:00', 'Mann', 'Buchenstraße 4', '34567', '8', '+491234567890', 'Dr. Meier', 3);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (36, 'Eva', 'Friedrich', '1938-08-28 00:00:00', 'Frau', 'Erlenplatz 7', '98765', '14', '+498765432101', 'Dr. Mayer', 2);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (37, 'Herbert', 'Koch', '1945-03-15 00:00:00', 'Mann', 'Kastanienplatz 11', '23456', '21', '+49123456789', 'Dr. Fischer', 4);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (38, 'Eva', 'Friedrich', '1938-08-28 00:00:00', 'Frau', 'Erlenplatz 7', '98765', '14', '+498765432101', 'Dr. Mayer', 2);
INSERT INTO public.patienten (id_patient, vorname, nachname, geburtsdatum, geschlecht, "straße", plz, hausnummer, telefonnummer, hausarzt, pflegegrad) OVERRIDING SYSTEM VALUE VALUES (39, 'Herbert', 'Koch', '1945-03-15 00:00:00', 'Mann', 'Kastanienplatz 11', '23456', '21', '+49123456789', 'Dr. Fischer', 4);


--
-- TOC entry 5004 (class 0 OID 18690)
-- Dependencies: 219
-- Data for Name: pflegedienstkatalog; Type: TABLE DATA; Schema: public; Owner: emmelie
--

INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (1, 'Grundpflege', 'Pflegeleistungen', 75.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (2, 'Behandlungspflege', 'Pflegeleistungen', 95.50, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (3, 'Hauswirtschaftliche Versorgung', 'Sonstiges', 60.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (4, 'Kathetherwechsel', 'Medizinische Versorgung', 75.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (5, 'Insulin-Verabreichung', 'Medizinische Versorgung', 120.50, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (6, 'Begleitung zu Terminen', 'Soziale Betreuung', 50.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (7, '24-Stunden-Betreuung', 'Rund-um-die-Uhr-Pflege', 250.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (8, 'Kochen', 'Sonstiges', 60.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (9, 'Urlaubsvertretung', 'Flexible Pflegeleistungen', 90.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (10, 'Wundversorgung', 'Medizinische Versorgung', 85.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (11, 'Physiotherapie', 'Therapeutische Leistungen', 110.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (12, 'Essen auf Rädern', 'Sonstiges', 55.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (13, 'Begleitung bei Spaziergängen', 'Soziale Betreuung', 40.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (14, 'Nachtbetreuung', 'Rund-um-die-Uhr-Pflege', 200.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (15, 'Reinigungsdienst', 'Hauswirtschaft', 65.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (16, 'Kurzzeitpflege', 'Flexible Pflegeleistungen', 120.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (17, 'Sturzprophylaxe', 'Therapeutische Leistungen', 75.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (18, 'Einkaufsservice', 'Sonstiges', 45.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (19, 'Psychotherapeutische Betreuung', 'Psychosoziale Betreuung', 150.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (20, 'Blutzuckermessung', 'Medizinische Versorgung', 60.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (21, 'Freizeitgestaltung', 'Soziale Betreuung', 30.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (22, 'Schmerztherapie', 'Therapeutische Leistungen', 90.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (23, 'Hilfe bei der Medikamenteneinnahme', 'Medizinische Versorgung', 50.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (24, 'Fahrdienst zu Arztterminen', 'Soziale Betreuung', 55.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (25, 'Kurzzeitpflege', 'Flexible Pflegeleistungen', 100.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (26, 'Ernährungsberatung', 'Hauswirtschaft', 70.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (27, 'Kontrolle von Vitalparametern', 'Medizinische Versorgung', 80.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (28, 'Betreuung bei Demenz', 'Psychosoziale Betreuung', 130.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (29, 'Hilfe bei der Körperpflege', 'Grundpflege', 40.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (30, 'Besorgungen', 'Flexible Pflegeleistungen', 45.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (31, 'Therapeutische Gespräche', 'Psychosoziale Betreuung', 110.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (32, 'Hausnotrufdienst', 'Notfallversorgung', 35.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (33, 'Fahrdienst zu Freizeitaktivitäten', 'Soziale Betreuung', 60.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (34, 'Betreuung bei schweren Erkrankungen', 'Palliativpflege', 160.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (35, 'Unterstützung beim An- und Auskleiden', 'Grundpflege', 50.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (36, 'Hausbesuche durch den Pflegedienst', 'Flexible Pflegeleistungen', 75.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (37, 'Nahrungsergänzung', 'Hauswirtschaft', 55.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (38, 'Beratung zur Pflegeversicherung', 'Beratungsdienstleistungen', 25.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (39, 'Begleitung zu kulturellen Veranstaltungen', 'Soziale Betreuung', 70.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (40, 'Stoma-Versorgung', 'Medizinische Versorgung', 95.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (41, 'Gedächtnistraining', 'Psychosoziale Betreuung', 80.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (42, 'Verhinderungspflege', 'Flexible Pflegeleistungen', 85.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (43, 'Injektionen verabreichen', 'Medizinische Versorgung', 65.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (44, 'Hauswirtschaftliche Hilfe bei Haustieren', 'Hauswirtschaft', 40.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (45, 'Kontinenztraining', 'Therapeutische Leistungen', 75.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (46, 'Vermittlung von Pflegekursen', 'Beratungsdienstleistungen', 30.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (47, 'Fahrdienst zu Familienfeiern', 'Soziale Betreuung', 50.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (48, 'Betreuung von Angehörigen', 'Psychosoziale Betreuung', 90.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (49, 'Hauswirtschaftliche Hilfe bei Veranstaltungen', 'Hauswirtschaft', 60.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (50, 'Rückenschule', 'Therapeutische Leistungen', 70.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (51, 'Vermittlung von Unterstützungsdiensten', 'Beratungsdienstleistungen', 35.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (52, 'Fahrdienst zu Therapieeinheiten', 'Soziale Betreuung', 55.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (53, 'Sterbebegleitung', 'Palliativpflege', 120.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (54, 'Hauswirtschaftliche Hilfe bei Umzügen', 'Hauswirtschaft', 65.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (55, 'Musiktherapie', 'Therapeutische Leistungen', 100.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (56, 'Vermittlung von Betreuungsdiensten', 'Beratungsdienstleistungen', 40.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (57, 'Fahrdienst zu Gruppentreffen', 'Soziale Betreuung', 45.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (58, 'Tiergestützte Therapie', 'Therapeutische Leistungen', 80.00, '€');
INSERT INTO public.pflegedienstkatalog (id_leistung, bezeichnung, kategorie, preis, einheit) OVERRIDING SYSTEM VALUE VALUES (59, 'Beratung zur Patientenverfügung', 'Beratungsdienstleistungen', 25.00, '€');


--
-- TOC entry 5020 (class 0 OID 18787)
-- Dependencies: 235
-- Data for Name: pflegeeinsätze; Type: TABLE DATA; Schema: public; Owner: emmelie
--

INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (1, '2024-01-09 08:00:00', '2024-01-09 12:00:00', '04:00:00', 1, 1);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (2, '2024-01-10 09:30:00', '2024-01-10 14:00:00', '04:30:00', 2, 2);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (3, '2024-01-11 10:15:00', '2024-01-11 13:30:00', '03:15:00', 3, 3);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (4, '2023-05-09 08:00:00', '2023-05-09 10:15:00', '02:15:00', 4, 5);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (5, '2023-07-10 09:30:00', '2023-07-10 10:00:00', '00:30:00', 6, 4);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (6, '2023-12-11 10:15:00', '2023-12-11 13:30:00', '03:15:00', 3, 7);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (7, '2024-01-12 08:00:00', '2024-01-12 12:30:00', '04:30:00', 5, 5);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (8, '2024-01-13 09:30:00', '2024-01-13 14:15:00', '04:45:00', 6, 6);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (9, '2024-01-14 10:15:00', '2024-01-14 13:00:00', '02:45:00', 7, 7);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (10, '2024-01-15 11:00:00', '2024-01-15 13:30:00', '02:30:00', 8, 8);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (11, '2023-01-12 08:00:00', '2023-01-12 11:45:00', '03:45:00', 9, 9);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (12, '2023-01-13 09:30:00', '2023-01-13 12:15:00', '02:45:00', 10, 10);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (13, '2023-01-14 10:15:00', '2023-01-14 13:30:00', '03:15:00', 11, 11);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (14, '2023-01-15 11:00:00', '2023-01-15 13:45:00', '02:45:00', 12, 12);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (15, '2022-01-12 08:00:00', '2022-01-12 12:00:00', '04:00:00', 13, 13);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (16, '2022-01-13 09:30:00', '2022-01-13 14:15:00', '04:45:00', 14, 14);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (17, '2022-01-14 10:15:00', '2022-01-14 13:30:00', '03:15:00', 15, 15);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (18, '2022-01-15 11:00:00', '2022-01-15 13:30:00', '02:30:00', 16, 16);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (19, '2021-01-12 08:00:00', '2021-01-12 11:45:00', '03:45:00', 17, 17);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (20, '2021-01-13 09:30:00', '2021-01-13 12:15:00', '02:45:00', 18, 18);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (21, '2021-01-14 10:15:00', '2021-01-14 13:30:00', '03:15:00', 19, 19);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (22, '2021-01-15 11:00:00', '2021-01-15 13:45:00', '02:45:00', 20, 20);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (23, '2020-01-12 08:00:00', '2020-01-12 12:00:00', '04:00:00', 21, 21);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (24, '2020-01-13 09:30:00', '2020-01-13 14:15:00', '04:45:00', 22, 22);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (25, '2020-01-14 10:15:00', '2020-01-14 13:30:00', '03:15:00', 23, 23);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (26, '2020-01-15 11:00:00', '2020-01-15 13:30:00', '02:30:00', 24, 24);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (27, '2019-01-12 08:00:00', '2019-01-12 11:45:00', '03:45:00', 25, 25);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (28, '2019-01-13 09:30:00', '2019-01-13 12:15:00', '02:45:00', 26, 26);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (29, '2019-01-14 10:15:00', '2019-01-14 13:30:00', '03:15:00', 27, 27);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (30, '2019-01-15 11:00:00', '2019-01-15 13:45:00', '02:45:00', 28, 28);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (31, '2018-01-12 08:00:00', '2018-01-12 12:00:00', '04:00:00', 29, 29);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (32, '2018-01-13 09:30:00', '2018-01-13 14:15:00', '04:45:00', 30, 30);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (33, '2018-01-14 10:15:00', '2018-01-14 13:30:00', '03:15:00', 31, 31);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (34, '2018-01-15 11:00:00', '2018-01-15 13:30:00', '02:30:00', 32, 32);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (35, '2017-01-12 08:00:00', '2017-01-12 11:45:00', '03:45:00', 33, 33);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (36, '2017-01-13 09:30:00', '2017-01-13 12:15:00', '02:45:00', 34, 34);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (37, '2017-01-14 10:15:00', '2017-01-14 13:30:00', '03:15:00', 35, 35);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (38, '2017-01-15 11:00:00', '2017-01-15 13:45:00', '02:45:00', 36, 36);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (39, '2016-01-12 08:00:00', '2016-01-12 12:00:00', '04:00:00', 37, 37);
INSERT INTO public."pflegeeinsätze" (id_pflegeeinsatz, ankunft, abfahrt, dauer, id_auftragsposition, id_mitarbeiter) OVERRIDING SYSTEM VALUE VALUES (40, '2016-01-13 09:30:00', '2016-01-13 14:15:00', '04:45:00', 38, 38);


--
-- TOC entry 5026 (class 0 OID 18832)
-- Dependencies: 241
-- Data for Name: rechnungspositionen; Type: TABLE DATA; Schema: public; Owner: emmelie
--

INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (1, 85.75, '2023-08-15 10:00:00', 1, 3);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (2, 120.00, '2023-08-20 12:30:00', 2, 2);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (3, 50.50, '2023-09-05 09:15:00', 3, 1);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (4, 125.00, '2023-08-15 10:00:00', 4, 4);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (5, 180.00, '2023-08-20 12:30:00', 2, 6);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (6, 80.00, '2023-09-05 09:15:00', 1, 5);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (7, 85.75, '2023-09-10 10:00:00', 5, 8);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (8, 120.00, '2023-09-12 12:30:00', 6, 10);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (9, 50.50, '2023-09-15 09:15:00', 7, 12);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (10, 125.00, '2023-09-20 10:00:00', 8, 14);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (11, 180.00, '2023-09-22 12:30:00', 9, 16);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (12, 80.00, '2023-09-25 09:15:00', 10, 18);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (13, 85.75, '2023-09-30 10:00:00', 11, 20);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (14, 120.00, '2023-10-02 12:30:00', 12, 22);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (15, 50.50, '2023-10-05 09:15:00', 13, 24);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (16, 125.00, '2023-10-10 10:00:00', 14, 26);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (17, 180.00, '2023-10-12 12:30:00', 15, 28);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (18, 80.00, '2023-10-15 09:15:00', 16, 30);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (19, 85.75, '2023-10-20 10:00:00', 17, 32);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (20, 120.00, '2023-10-22 12:30:00', 18, 34);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (21, 50.50, '2023-10-25 09:15:00', 19, 36);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (22, 125.00, '2023-10-30 10:00:00', 20, 38);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (23, 180.00, '2023-11-02 12:30:00', 21, 40);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (24, 80.00, '2023-11-05 09:15:00', 22, 31);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (25, 85.75, '2023-11-10 10:00:00', 23, 4);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (26, 120.00, '2023-11-12 12:30:00', 24, 26);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (27, 50.50, '2023-11-15 09:15:00', 25, 38);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (28, 125.00, '2023-11-20 10:00:00', 26, 10);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (29, 180.00, '2023-11-22 12:30:00', 27, 2);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (30, 80.00, '2023-11-25 09:15:00', 28, 4);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (31, 85.75, '2023-11-30 10:00:00', 29, 36);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (32, 120.00, '2023-12-02 12:30:00', 30, 28);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (33, 50.50, '2023-12-05 09:15:00', 31, 40);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (34, 125.00, '2023-12-10 10:00:00', 32, 12);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (35, 180.00, '2023-12-12 12:30:00', 33, 4);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (36, 80.00, '2023-12-15 09:15:00', 34, 6);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (37, 85.75, '2023-12-20 10:00:00', 35, 8);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (38, 120.00, '2023-12-22 12:30:00', 36, 17);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (39, 50.50, '2023-12-25 09:15:00', 37, 32);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (40, 125.00, '2023-12-30 10:00:00', 38, 14);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (41, 180.00, '2024-01-02 12:30:00', 39, 26);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (42, 80.00, '2024-01-05 09:15:00', 40, 38);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (43, 85.75, '2024-01-10 10:00:00', 41, 40);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (44, 120.00, '2024-01-12 12:30:00', 42, 22);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (45, 50.50, '2024-01-15 09:15:00', 43, 4);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (46, 125.00, '2024-01-20 10:00:00', 44, 11);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (47, 180.00, '2024-01-22 12:30:00', 45, 8);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (48, 80.00, '2024-01-25 09:15:00', 46, 30);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (49, 85.75, '2024-01-30 10:00:00', 47, 9);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (50, 120.00, '2024-02-02 12:30:00', 48, 9);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (51, 50.50, '2024-02-05 09:15:00', 49, 6);
INSERT INTO public.rechnungspositionen (id_rechnungsposition, preis, datum, id_rechnung, id_pflegeeinsatz) OVERRIDING SYSTEM VALUE VALUES (52, 125.00, '2024-02-10 10:00:00', 50, 38);


--
-- TOC entry 5016 (class 0 OID 18754)
-- Dependencies: 231
-- Data for Name: tourenpläne; Type: TABLE DATA; Schema: public; Owner: emmelie
--

INSERT INTO public."tourenpläne" (id_tour, tourname, datum, strecke, einheit, kennzeichen) OVERRIDING SYSTEM VALUE VALUES (1, 'Tour 1', '2024-01-09 08:00:00', 90.50, 'km', 'ABC-XY-123');
INSERT INTO public."tourenpläne" (id_tour, tourname, datum, strecke, einheit, kennzeichen) OVERRIDING SYSTEM VALUE VALUES (2, 'Tour 2', '2024-01-10 09:30:00', 85.25, 'km', 'DEF-ZZ-456');
INSERT INTO public."tourenpläne" (id_tour, tourname, datum, strecke, einheit, kennzeichen) OVERRIDING SYSTEM VALUE VALUES (3, 'Tour 3', '2024-01-11 10:15:00', 71.75, 'km', 'GHI-AB-789');
INSERT INTO public."tourenpläne" (id_tour, tourname, datum, strecke, einheit, kennzeichen) OVERRIDING SYSTEM VALUE VALUES (4, 'Tour 4', '2023-01-09 08:00:00', 75.50, 'km', 'ABC-RS-345');
INSERT INTO public."tourenpläne" (id_tour, tourname, datum, strecke, einheit, kennzeichen) OVERRIDING SYSTEM VALUE VALUES (5, 'Tour 5', '2023-01-10 09:30:00', 82.29, 'km', 'DEF-ZZ-456');
INSERT INTO public."tourenpläne" (id_tour, tourname, datum, strecke, einheit, kennzeichen) OVERRIDING SYSTEM VALUE VALUES (6, 'Tour 6', '2023-01-11 10:15:00', 66.75, 'km', 'GHI-BC-234');
INSERT INTO public."tourenpläne" (id_tour, tourname, datum, strecke, einheit, kennzeichen) OVERRIDING SYSTEM VALUE VALUES (7, 'Tour 7', '2024-01-12 08:30:00', 88.75, 'km', 'ABC-XY-123');
INSERT INTO public."tourenpläne" (id_tour, tourname, datum, strecke, einheit, kennzeichen) OVERRIDING SYSTEM VALUE VALUES (8, 'Tour 8', '2024-01-13 09:45:00', 79.20, 'km', 'DEF-ZI-567');
INSERT INTO public."tourenpläne" (id_tour, tourname, datum, strecke, einheit, kennzeichen) OVERRIDING SYSTEM VALUE VALUES (9, 'Tour 9', '2024-01-14 11:00:00', 93.45, 'km', 'GHI-WX-789');
INSERT INTO public."tourenpläne" (id_tour, tourname, datum, strecke, einheit, kennzeichen) OVERRIDING SYSTEM VALUE VALUES (10, 'Tour 10', '2023-01-12 08:30:00', 85.00, 'km', 'ABC-YX-123');
INSERT INTO public."tourenpläne" (id_tour, tourname, datum, strecke, einheit, kennzeichen) OVERRIDING SYSTEM VALUE VALUES (11, 'Tour 11', '2023-01-13 09:45:00', 91.80, 'km', 'DEF-MN-901');
INSERT INTO public."tourenpläne" (id_tour, tourname, datum, strecke, einheit, kennzeichen) OVERRIDING SYSTEM VALUE VALUES (12, 'Tour 12', '2023-01-14 11:00:00', 78.25, 'km', 'GHI-AB-789');
INSERT INTO public."tourenpläne" (id_tour, tourname, datum, strecke, einheit, kennzeichen) OVERRIDING SYSTEM VALUE VALUES (13, 'Tour 13', '2022-01-12 08:30:00', 70.90, 'km', 'ABC-YX-123');
INSERT INTO public."tourenpläne" (id_tour, tourname, datum, strecke, einheit, kennzeichen) OVERRIDING SYSTEM VALUE VALUES (14, 'Tour 14', '2022-01-13 09:45:00', 77.60, 'km', 'DEF-ZI-567');
INSERT INTO public."tourenpläne" (id_tour, tourname, datum, strecke, einheit, kennzeichen) OVERRIDING SYSTEM VALUE VALUES (15, 'Tour 15', '2022-01-14 11:00:00', 84.30, 'km', 'GHI-WX-789');
INSERT INTO public."tourenpläne" (id_tour, tourname, datum, strecke, einheit, kennzeichen) OVERRIDING SYSTEM VALUE VALUES (16, 'Tour 16', '2022-01-15 10:30:00', 96.15, 'km', 'ABC-RS-345');


--
-- TOC entry 5038 (class 0 OID 0)
-- Dependencies: 238
-- Name: abrechnungen_id_rechnung_seq; Type: SEQUENCE SET; Schema: public; Owner: emmelie
--

SELECT pg_catalog.setval('public.abrechnungen_id_rechnung_seq', 50, true);


--
-- TOC entry 5039 (class 0 OID 0)
-- Dependencies: 236
-- Name: angehörige_id_angehörige_seq; Type: SEQUENCE SET; Schema: public; Owner: emmelie
--

SELECT pg_catalog.setval('public."angehörige_id_angehörige_seq"', 33, true);


--
-- TOC entry 5040 (class 0 OID 0)
-- Dependencies: 226
-- Name: arbeitsschichten_id_schicht_seq; Type: SEQUENCE SET; Schema: public; Owner: emmelie
--

SELECT pg_catalog.setval('public.arbeitsschichten_id_schicht_seq', 5, true);


--
-- TOC entry 5041 (class 0 OID 0)
-- Dependencies: 232
-- Name: auftragspositionen_id_auftragsposition_seq; Type: SEQUENCE SET; Schema: public; Owner: emmelie
--

SELECT pg_catalog.setval('public.auftragspositionen_id_auftragsposition_seq', 55, true);


--
-- TOC entry 5042 (class 0 OID 0)
-- Dependencies: 228
-- Name: aufträge_id_auftrag_seq; Type: SEQUENCE SET; Schema: public; Owner: emmelie
--

SELECT pg_catalog.setval('public."aufträge_id_auftrag_seq"', 37, true);


--
-- TOC entry 5043 (class 0 OID 0)
-- Dependencies: 245
-- Name: dokumentation_id_dokumentation_seq; Type: SEQUENCE SET; Schema: public; Owner: emmelie
--

SELECT pg_catalog.setval('public.dokumentation_id_dokumentation_seq', 40, true);


--
-- TOC entry 5044 (class 0 OID 0)
-- Dependencies: 243
-- Name: evaluation_nr_evaluation_seq; Type: SEQUENCE SET; Schema: public; Owner: emmelie
--

SELECT pg_catalog.setval('public.evaluation_nr_evaluation_seq', 90, true);


--
-- TOC entry 5045 (class 0 OID 0)
-- Dependencies: 224
-- Name: fragebogenkatalog_id_frage_seq; Type: SEQUENCE SET; Schema: public; Owner: emmelie
--

SELECT pg_catalog.setval('public.fragebogenkatalog_id_frage_seq', 58, true);


--
-- TOC entry 5046 (class 0 OID 0)
-- Dependencies: 222
-- Name: kostenträger_id_kostenträger_seq; Type: SEQUENCE SET; Schema: public; Owner: emmelie
--

SELECT pg_catalog.setval('public."kostenträger_id_kostenträger_seq"', 20, true);


--
-- TOC entry 5047 (class 0 OID 0)
-- Dependencies: 215
-- Name: mitarbeiter_id_mitarbeiter_seq; Type: SEQUENCE SET; Schema: public; Owner: emmelie
--

SELECT pg_catalog.setval('public.mitarbeiter_id_mitarbeiter_seq', 54, true);


--
-- TOC entry 5048 (class 0 OID 0)
-- Dependencies: 220
-- Name: patienten_id_patient_seq; Type: SEQUENCE SET; Schema: public; Owner: emmelie
--

SELECT pg_catalog.setval('public.patienten_id_patient_seq', 39, true);


--
-- TOC entry 5049 (class 0 OID 0)
-- Dependencies: 218
-- Name: pflegedienstkatalog_id_leistung_seq; Type: SEQUENCE SET; Schema: public; Owner: emmelie
--

SELECT pg_catalog.setval('public.pflegedienstkatalog_id_leistung_seq', 59, true);


--
-- TOC entry 5050 (class 0 OID 0)
-- Dependencies: 234
-- Name: pflegeeinsätze_id_pflegeeinsatz_seq; Type: SEQUENCE SET; Schema: public; Owner: emmelie
--

SELECT pg_catalog.setval('public."pflegeeinsätze_id_pflegeeinsatz_seq"', 40, true);


--
-- TOC entry 5051 (class 0 OID 0)
-- Dependencies: 240
-- Name: rechnungspositionen_id_rechnungsposition_seq; Type: SEQUENCE SET; Schema: public; Owner: emmelie
--

SELECT pg_catalog.setval('public.rechnungspositionen_id_rechnungsposition_seq', 52, true);


--
-- TOC entry 5052 (class 0 OID 0)
-- Dependencies: 230
-- Name: tourenpläne_id_tour_seq; Type: SEQUENCE SET; Schema: public; Owner: emmelie
--

SELECT pg_catalog.setval('public."tourenpläne_id_tour_seq"', 16, true);


--
-- TOC entry 4827 (class 2606 OID 18825)
-- Name: abrechnungen abrechnungen_pkey; Type: CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public.abrechnungen
    ADD CONSTRAINT abrechnungen_pkey PRIMARY KEY (id_rechnung);


--
-- TOC entry 4825 (class 2606 OID 18813)
-- Name: angehörige angehörige_pkey; Type: CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public."angehörige"
    ADD CONSTRAINT "angehörige_pkey" PRIMARY KEY ("id_angehörige");


--
-- TOC entry 4815 (class 2606 OID 18741)
-- Name: arbeitsschichten arbeitsschichten_pkey; Type: CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public.arbeitsschichten
    ADD CONSTRAINT arbeitsschichten_pkey PRIMARY KEY (id_schicht);


--
-- TOC entry 4821 (class 2606 OID 18770)
-- Name: auftragspositionen auftragspositionen_pkey; Type: CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public.auftragspositionen
    ADD CONSTRAINT auftragspositionen_pkey PRIMARY KEY (id_auftragsposition);


--
-- TOC entry 4817 (class 2606 OID 18747)
-- Name: aufträge aufträge_pkey; Type: CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public."aufträge"
    ADD CONSTRAINT "aufträge_pkey" PRIMARY KEY (id_auftrag);


--
-- TOC entry 4831 (class 2606 OID 18853)
-- Name: diagnosen diagnosen_pkey; Type: CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public.diagnosen
    ADD CONSTRAINT diagnosen_pkey PRIMARY KEY (id_patient, icd_diagnose);


--
-- TOC entry 4837 (class 2606 OID 18913)
-- Name: dienstplan dienstplan_pkey; Type: CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public.dienstplan
    ADD CONSTRAINT dienstplan_pkey PRIMARY KEY (id_mitarbeiter, id_schicht, datum);


--
-- TOC entry 4835 (class 2606 OID 18893)
-- Name: dokumentation dokumentation_pkey; Type: CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public.dokumentation
    ADD CONSTRAINT dokumentation_pkey PRIMARY KEY (id_dokumentation);


--
-- TOC entry 4833 (class 2606 OID 18870)
-- Name: evaluation evaluation_pkey; Type: CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public.evaluation
    ADD CONSTRAINT evaluation_pkey PRIMARY KEY (nr_evaluation);


--
-- TOC entry 4805 (class 2606 OID 18684)
-- Name: firmenfahrzeuge firmenfahrzeuge_pkey; Type: CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public.firmenfahrzeuge
    ADD CONSTRAINT firmenfahrzeuge_pkey PRIMARY KEY (kennzeichen);


--
-- TOC entry 4813 (class 2606 OID 18735)
-- Name: fragebogenkatalog fragebogenkatalog_pkey; Type: CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public.fragebogenkatalog
    ADD CONSTRAINT fragebogenkatalog_pkey PRIMARY KEY (id_frage);


--
-- TOC entry 4811 (class 2606 OID 18727)
-- Name: kostenträger kostenträger_pkey; Type: CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public."kostenträger"
    ADD CONSTRAINT "kostenträger_pkey" PRIMARY KEY ("id_kostenträger");


--
-- TOC entry 4803 (class 2606 OID 18664)
-- Name: mitarbeiter mitarbeiter_pkey; Type: CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public.mitarbeiter
    ADD CONSTRAINT mitarbeiter_pkey PRIMARY KEY (id_mitarbeiter);


--
-- TOC entry 4809 (class 2606 OID 18717)
-- Name: patienten patienten_pkey; Type: CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public.patienten
    ADD CONSTRAINT patienten_pkey PRIMARY KEY (id_patient);


--
-- TOC entry 4807 (class 2606 OID 18697)
-- Name: pflegedienstkatalog pflegedienstkatalog_pkey; Type: CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public.pflegedienstkatalog
    ADD CONSTRAINT pflegedienstkatalog_pkey PRIMARY KEY (id_leistung);


--
-- TOC entry 4823 (class 2606 OID 18792)
-- Name: pflegeeinsätze pflegeeinsätze_pkey; Type: CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public."pflegeeinsätze"
    ADD CONSTRAINT "pflegeeinsätze_pkey" PRIMARY KEY (id_pflegeeinsatz);


--
-- TOC entry 4829 (class 2606 OID 18837)
-- Name: rechnungspositionen rechnungspositionen_pkey; Type: CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public.rechnungspositionen
    ADD CONSTRAINT rechnungspositionen_pkey PRIMARY KEY (id_rechnungsposition);


--
-- TOC entry 4819 (class 2606 OID 18759)
-- Name: tourenpläne tourenpläne_pkey; Type: CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public."tourenpläne"
    ADD CONSTRAINT "tourenpläne_pkey" PRIMARY KEY (id_tour);


--
-- TOC entry 4846 (class 2606 OID 18826)
-- Name: abrechnungen abrechnungen_id_kostenträger_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public.abrechnungen
    ADD CONSTRAINT "abrechnungen_id_kostenträger_fkey" FOREIGN KEY ("id_kostenträger") REFERENCES public."kostenträger"("id_kostenträger");


--
-- TOC entry 4845 (class 2606 OID 18814)
-- Name: angehörige angehörige_id_patient_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public."angehörige"
    ADD CONSTRAINT "angehörige_id_patient_fkey" FOREIGN KEY (id_patient) REFERENCES public.patienten(id_patient) ON UPDATE CASCADE;


--
-- TOC entry 4840 (class 2606 OID 18776)
-- Name: auftragspositionen auftragspositionen_id_auftrag_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public.auftragspositionen
    ADD CONSTRAINT auftragspositionen_id_auftrag_fkey FOREIGN KEY (id_auftrag) REFERENCES public."aufträge"(id_auftrag);


--
-- TOC entry 4841 (class 2606 OID 18771)
-- Name: auftragspositionen auftragspositionen_id_leistung_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public.auftragspositionen
    ADD CONSTRAINT auftragspositionen_id_leistung_fkey FOREIGN KEY (id_leistung) REFERENCES public.pflegedienstkatalog(id_leistung);


--
-- TOC entry 4842 (class 2606 OID 18781)
-- Name: auftragspositionen auftragspositionen_id_tour_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public.auftragspositionen
    ADD CONSTRAINT auftragspositionen_id_tour_fkey FOREIGN KEY (id_tour) REFERENCES public."tourenpläne"(id_tour);


--
-- TOC entry 4838 (class 2606 OID 18748)
-- Name: aufträge aufträge_id_patient_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public."aufträge"
    ADD CONSTRAINT "aufträge_id_patient_fkey" FOREIGN KEY (id_patient) REFERENCES public.patienten(id_patient) ON UPDATE CASCADE;


--
-- TOC entry 4855 (class 2606 OID 18919)
-- Name: dienstplan dienstplan_id_mitarbeiter_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public.dienstplan
    ADD CONSTRAINT dienstplan_id_mitarbeiter_fkey FOREIGN KEY (id_mitarbeiter) REFERENCES public.mitarbeiter(id_mitarbeiter) ON UPDATE CASCADE;


--
-- TOC entry 4856 (class 2606 OID 18914)
-- Name: dienstplan dienstplan_id_schicht_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public.dienstplan
    ADD CONSTRAINT dienstplan_id_schicht_fkey FOREIGN KEY (id_schicht) REFERENCES public.arbeitsschichten(id_schicht);


--
-- TOC entry 4852 (class 2606 OID 18904)
-- Name: dokumentation dokumentation_id_mitarbeiter_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public.dokumentation
    ADD CONSTRAINT dokumentation_id_mitarbeiter_fkey FOREIGN KEY (id_mitarbeiter) REFERENCES public.mitarbeiter(id_mitarbeiter) ON UPDATE CASCADE;


--
-- TOC entry 4853 (class 2606 OID 18899)
-- Name: dokumentation dokumentation_id_patient_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public.dokumentation
    ADD CONSTRAINT dokumentation_id_patient_fkey FOREIGN KEY (id_patient) REFERENCES public.patienten(id_patient);


--
-- TOC entry 4854 (class 2606 OID 18894)
-- Name: dokumentation dokumentation_id_pflegeeinsatz_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public.dokumentation
    ADD CONSTRAINT dokumentation_id_pflegeeinsatz_fkey FOREIGN KEY (id_pflegeeinsatz) REFERENCES public."pflegeeinsätze"(id_pflegeeinsatz);


--
-- TOC entry 4849 (class 2606 OID 18881)
-- Name: evaluation evaluation_id_frage_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public.evaluation
    ADD CONSTRAINT evaluation_id_frage_fkey FOREIGN KEY (id_frage) REFERENCES public.fragebogenkatalog(id_frage) ON UPDATE CASCADE;


--
-- TOC entry 4850 (class 2606 OID 18871)
-- Name: evaluation evaluation_id_mitarbeiter_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public.evaluation
    ADD CONSTRAINT evaluation_id_mitarbeiter_fkey FOREIGN KEY (id_mitarbeiter) REFERENCES public.mitarbeiter(id_mitarbeiter) ON UPDATE CASCADE;


--
-- TOC entry 4851 (class 2606 OID 18876)
-- Name: evaluation evaluation_id_patient_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public.evaluation
    ADD CONSTRAINT evaluation_id_patient_fkey FOREIGN KEY (id_patient) REFERENCES public.patienten(id_patient);


--
-- TOC entry 4843 (class 2606 OID 18793)
-- Name: pflegeeinsätze pflegeeinsätze_id_auftragsposition_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public."pflegeeinsätze"
    ADD CONSTRAINT "pflegeeinsätze_id_auftragsposition_fkey" FOREIGN KEY (id_auftragsposition) REFERENCES public.auftragspositionen(id_auftragsposition) ON UPDATE CASCADE;


--
-- TOC entry 4844 (class 2606 OID 18798)
-- Name: pflegeeinsätze pflegeeinsätze_id_mitarbeiter_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public."pflegeeinsätze"
    ADD CONSTRAINT "pflegeeinsätze_id_mitarbeiter_fkey" FOREIGN KEY (id_mitarbeiter) REFERENCES public.mitarbeiter(id_mitarbeiter) ON UPDATE CASCADE;


--
-- TOC entry 4847 (class 2606 OID 18843)
-- Name: rechnungspositionen rechnungspositionen_id_pflegeeinsatz_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public.rechnungspositionen
    ADD CONSTRAINT rechnungspositionen_id_pflegeeinsatz_fkey FOREIGN KEY (id_pflegeeinsatz) REFERENCES public."pflegeeinsätze"(id_pflegeeinsatz);


--
-- TOC entry 4848 (class 2606 OID 18838)
-- Name: rechnungspositionen rechnungspositionen_id_rechnung_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public.rechnungspositionen
    ADD CONSTRAINT rechnungspositionen_id_rechnung_fkey FOREIGN KEY (id_rechnung) REFERENCES public.abrechnungen(id_rechnung);


--
-- TOC entry 4839 (class 2606 OID 18760)
-- Name: tourenpläne tourenpläne_kennzeichen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: emmelie
--

ALTER TABLE ONLY public."tourenpläne"
    ADD CONSTRAINT "tourenpläne_kennzeichen_fkey" FOREIGN KEY (kennzeichen) REFERENCES public.firmenfahrzeuge(kennzeichen);


-- Completed on 2024-01-13 17:38:40

--
-- PostgreSQL database dump complete
--

