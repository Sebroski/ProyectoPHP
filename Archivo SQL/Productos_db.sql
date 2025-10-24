--
-- PostgreSQL database dump
--

\restrict hla30BUXMsp3J0AF9fq5m7dSoPGfcLfw5BLBdsOrMLbdLgBlCyQpGRhT01dU6IF

-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.0

-- Started on 2025-10-24 10:16:56

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 222 (class 1259 OID 16395)
-- Name: tbl_bodegas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_bodegas (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL
);


ALTER TABLE public.tbl_bodegas OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16394)
-- Name: tbl_bodegas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_bodegas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tbl_bodegas_id_seq OWNER TO postgres;

--
-- TOC entry 5050 (class 0 OID 0)
-- Dependencies: 221
-- Name: tbl_bodegas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tbl_bodegas_id_seq OWNED BY public.tbl_bodegas.id;


--
-- TOC entry 220 (class 1259 OID 16386)
-- Name: tbl_monedas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_monedas (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    simbolo character varying(5)
);


ALTER TABLE public.tbl_monedas OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16385)
-- Name: tbl_monedas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_monedas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tbl_monedas_id_seq OWNER TO postgres;

--
-- TOC entry 5051 (class 0 OID 0)
-- Dependencies: 219
-- Name: tbl_monedas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tbl_monedas_id_seq OWNED BY public.tbl_monedas.id;


--
-- TOC entry 226 (class 1259 OID 16419)
-- Name: tbl_productos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_productos (
    id integer NOT NULL,
    codigo character varying(15) NOT NULL,
    nombre character varying(50) NOT NULL,
    id_bodega integer NOT NULL,
    id_sucursal integer NOT NULL,
    id_moneda integer NOT NULL,
    precio numeric(10,2) NOT NULL,
    materiales character varying(255) NOT NULL,
    descripcion character varying(1000) NOT NULL,
    fecha_registro timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.tbl_productos OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16418)
-- Name: tbl_productos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_productos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tbl_productos_id_seq OWNER TO postgres;

--
-- TOC entry 5052 (class 0 OID 0)
-- Dependencies: 225
-- Name: tbl_productos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tbl_productos_id_seq OWNED BY public.tbl_productos.id;


--
-- TOC entry 224 (class 1259 OID 16404)
-- Name: tbl_sucursales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_sucursales (
    id integer NOT NULL,
    id_bodega integer NOT NULL,
    nombre character varying(100) NOT NULL
);


ALTER TABLE public.tbl_sucursales OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16403)
-- Name: tbl_sucursales_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_sucursales_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tbl_sucursales_id_seq OWNER TO postgres;

--
-- TOC entry 5053 (class 0 OID 0)
-- Dependencies: 223
-- Name: tbl_sucursales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tbl_sucursales_id_seq OWNED BY public.tbl_sucursales.id;


--
-- TOC entry 4872 (class 2604 OID 16398)
-- Name: tbl_bodegas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_bodegas ALTER COLUMN id SET DEFAULT nextval('public.tbl_bodegas_id_seq'::regclass);


--
-- TOC entry 4871 (class 2604 OID 16389)
-- Name: tbl_monedas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_monedas ALTER COLUMN id SET DEFAULT nextval('public.tbl_monedas_id_seq'::regclass);


--
-- TOC entry 4874 (class 2604 OID 16422)
-- Name: tbl_productos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_productos ALTER COLUMN id SET DEFAULT nextval('public.tbl_productos_id_seq'::regclass);


--
-- TOC entry 4873 (class 2604 OID 16407)
-- Name: tbl_sucursales id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_sucursales ALTER COLUMN id SET DEFAULT nextval('public.tbl_sucursales_id_seq'::regclass);


--
-- TOC entry 5040 (class 0 OID 16395)
-- Dependencies: 222
-- Data for Name: tbl_bodegas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_bodegas (id, nombre) FROM stdin;
1	Bodega 1
2	Bodega 2
3	Bodega Central
4	Bodega Zona Sur
5	Bodega Ecommerce
\.


--
-- TOC entry 5038 (class 0 OID 16386)
-- Dependencies: 220
-- Data for Name: tbl_monedas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_monedas (id, nombre, simbolo) FROM stdin;
1	DÓLAR	$
2	PESO (CLP)	$
3	EURO	€
\.


--
-- TOC entry 5044 (class 0 OID 16419)
-- Dependencies: 226
-- Data for Name: tbl_productos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_productos (id, codigo, nombre, id_bodega, id_sucursal, id_moneda, precio, materiales, descripcion, fecha_registro) FROM stdin;
1	MUEBLE001	Set Comedor 4 Sillas	3	4	2	199990.00	Madera,Textil	Elegante set de comedor de madera sólida. Incluye 4 sillas tapizadas en tela gris.	2025-10-24 10:13:18.915792
2	ESCMET01A	Escritorio Moderno	1	1	1	120.50	Metal,Madera	Escritorio estilo industrial con cubierta de madera y patas metálicas. Ideal para home office.	2025-10-24 10:13:18.915792
3	SILLONVDE9	Sillón Velvet Verde	3	5	2	249900.00	Textil,Madera	Sillón individual de terciopelo (velvet) color verde esmeralda. Patas de madera.	2025-10-24 10:13:18.915792
4	LAMPARA05	Lámpara de Pie Arco	2	3	1	89.99	Metal,Plástico	Lámpara de pie moderna con base de metal y pantalla plástica. Diseño curvo.	2025-10-24 10:13:18.915792
5	ESTANTE5R	Estante 5 Repisas	5	9	2	79990.00	Metal,Madera	Estantería tipo escalera con 5 repisas de madera y estructura metálica negra.	2025-10-24 10:13:18.915792
6	MESVIDR12	Mesa de Centro Vidrio	1	2	3	150.00	Vidrio,Metal	Mesa de centro con cubierta de vidrio templado y base de metal cromado.	2025-10-24 10:13:18.915792
7	SILLAERG01	Silla Ergonómica Malla	5	9	2	119990.00	Plástico,Textil,Metal	Silla de oficina ergonómica con respaldo de malla transpirable y base metálica.	2025-10-24 10:13:18.915792
8	RACKTV150	Rack TV 150cm	4	7	2	99990.00	Madera,Metal	Mueble para TV de hasta 60 pulgadas. Estilo nórdico, madera clara y patas de metal.	2025-10-24 10:13:18.915792
9	BANCOPL02	Banqueta Tolix	2	3	1	45.00	Metal,Plástico	Banqueta alta (piso) estilo Tolix color negro. Asiento de plástico y patas de metal.	2025-10-24 10:13:18.915792
10	VASOALTO6	Set 6 Vasos Altos	5	10	2	19990.00	Vidrio,Madera	Set de 6 vasos altos de vidrio grueso. Presentación en caja de madera de pino.	2025-10-24 10:13:18.915792
\.


--
-- TOC entry 5042 (class 0 OID 16404)
-- Dependencies: 224
-- Data for Name: tbl_sucursales; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_sucursales (id, id_bodega, nombre) FROM stdin;
1	1	Sucursal 1-A
2	1	Sucursal 1-B
3	2	Sucursal 2-A
4	3	Sucursal Central Norte
5	3	Sucursal Central Sur
6	3	Sucursal Central Oriente
7	4	Sucursal Concepción
8	4	Sucursal Temuco
9	5	Despacho R.M.
10	5	Despacho Regiones
\.


--
-- TOC entry 5054 (class 0 OID 0)
-- Dependencies: 221
-- Name: tbl_bodegas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_bodegas_id_seq', 5, true);


--
-- TOC entry 5055 (class 0 OID 0)
-- Dependencies: 219
-- Name: tbl_monedas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_monedas_id_seq', 3, true);


--
-- TOC entry 5056 (class 0 OID 0)
-- Dependencies: 225
-- Name: tbl_productos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_productos_id_seq', 10, true);


--
-- TOC entry 5057 (class 0 OID 0)
-- Dependencies: 223
-- Name: tbl_sucursales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_sucursales_id_seq', 10, true);


--
-- TOC entry 4879 (class 2606 OID 16402)
-- Name: tbl_bodegas tbl_bodegas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_bodegas
    ADD CONSTRAINT tbl_bodegas_pkey PRIMARY KEY (id);


--
-- TOC entry 4877 (class 2606 OID 16393)
-- Name: tbl_monedas tbl_monedas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_monedas
    ADD CONSTRAINT tbl_monedas_pkey PRIMARY KEY (id);


--
-- TOC entry 4883 (class 2606 OID 16438)
-- Name: tbl_productos tbl_productos_codigo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_productos
    ADD CONSTRAINT tbl_productos_codigo_key UNIQUE (codigo);


--
-- TOC entry 4885 (class 2606 OID 16436)
-- Name: tbl_productos tbl_productos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_productos
    ADD CONSTRAINT tbl_productos_pkey PRIMARY KEY (id);


--
-- TOC entry 4881 (class 2606 OID 16412)
-- Name: tbl_sucursales tbl_sucursales_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_sucursales
    ADD CONSTRAINT tbl_sucursales_pkey PRIMARY KEY (id);


--
-- TOC entry 4886 (class 2606 OID 16413)
-- Name: tbl_sucursales fk_bodega; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_sucursales
    ADD CONSTRAINT fk_bodega FOREIGN KEY (id_bodega) REFERENCES public.tbl_bodegas(id) ON DELETE CASCADE;


--
-- TOC entry 4887 (class 2606 OID 16439)
-- Name: tbl_productos fk_bodega_prod; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_productos
    ADD CONSTRAINT fk_bodega_prod FOREIGN KEY (id_bodega) REFERENCES public.tbl_bodegas(id);


--
-- TOC entry 4888 (class 2606 OID 16449)
-- Name: tbl_productos fk_moneda_prod; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_productos
    ADD CONSTRAINT fk_moneda_prod FOREIGN KEY (id_moneda) REFERENCES public.tbl_monedas(id);


--
-- TOC entry 4889 (class 2606 OID 16444)
-- Name: tbl_productos fk_sucursal_prod; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_productos
    ADD CONSTRAINT fk_sucursal_prod FOREIGN KEY (id_sucursal) REFERENCES public.tbl_sucursales(id);


-- Completed on 2025-10-24 10:16:56

--
-- PostgreSQL database dump complete
--

\unrestrict hla30BUXMsp3J0AF9fq5m7dSoPGfcLfw5BLBdsOrMLbdLgBlCyQpGRhT01dU6IF

