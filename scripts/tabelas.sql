-- Table: public.raca_cor

-- DROP TABLE IF EXISTS public.raca_cor;

CREATE TABLE IF NOT EXISTS public.raca_cor
(
    id_raca_cor integer NOT NULL DEFAULT nextval('raca_cor_id_raca_cor_seq'::regclass),
    descricao character varying(20) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT raca_cor_pkey PRIMARY KEY (id_raca_cor),
    CONSTRAINT raca_cor_descricao_key UNIQUE (descricao)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.raca_cor OWNER to postgres;
	
-- Table: public.causas

-- DROP TABLE IF EXISTS public.causas;

CREATE TABLE IF NOT EXISTS public.causas
(
    id_causa integer NOT NULL DEFAULT nextval('causas_id_causa_seq'::regclass),
    codigo_cid character varying(10) COLLATE pg_catalog."default" NOT NULL,
    descricao text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT causas_pkey PRIMARY KEY (id_causa),
    CONSTRAINT causas_codigo_cid_key UNIQUE (codigo_cid)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.causas OWNER to postgres;
	
-- Table: public.localizacoes

-- DROP TABLE IF EXISTS public.localizacoes;

CREATE TABLE IF NOT EXISTS public.localizacoes
(
    id_local integer NOT NULL DEFAULT nextval('localizacoes_id_local_seq'::regclass),
    municipio character varying(60) COLLATE pg_catalog."default" NOT NULL,
    estado character(2) COLLATE pg_catalog."default" NOT NULL,
    regiao character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT localizacoes_pkey PRIMARY KEY (id_local)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.localizacoes OWNER to postgres;
	
-- Table: public.obitos

-- DROP TABLE IF EXISTS public.obitos;

CREATE TABLE IF NOT EXISTS public.obitos
(
    id_obito integer NOT NULL DEFAULT nextval('obitos_id_obito_seq'::regclass),
    data timestamp without time zone,
    id_local integer,
    data_nascimento timestamp without time zone,
    idade integer,
    sexo character(1) COLLATE pg_catalog."default",
    id_causa_principal integer,
    assist_med text COLLATE pg_catalog."default",
    necropsia text COLLATE pg_catalog."default",
    id_raca_cor integer,
    CONSTRAINT obitos_pkey PRIMARY KEY (id_obito),
    CONSTRAINT fk_obitos_causa FOREIGN KEY (id_causa_principal)
        REFERENCES public.causas (id_causa) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT fk_obitos_local FOREIGN KEY (id_local)
        REFERENCES public.localizacoes (id_local) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT fk_obitos_raca_cor FOREIGN KEY (id_raca_cor)
        REFERENCES public.raca_cor (id_raca_cor) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.obitos OWNER to postgres;

-- Table: public.auditoria

-- DROP TABLE IF EXISTS public.auditoria;

CREATE TABLE IF NOT EXISTS public.auditoria
(
    id_auditoria integer NOT NULL DEFAULT nextval('auditoria_id_auditoria_seq'::regclass),
    operacao character varying(10) COLLATE pg_catalog."default" NOT NULL,
    id_obito integer,
    data_antiga timestamp without time zone,
    data_nova timestamp without time zone,
    idade_antiga integer,
    idade_nova integer,
    sexo_antigo character(1) COLLATE pg_catalog."default",
    sexo_novo character(1) COLLATE pg_catalog."default",
    usuario text COLLATE pg_catalog."default" DEFAULT CURRENT_USER,
    data_modificacao timestamp without time zone DEFAULT now(),
    CONSTRAINT auditoria_pkey PRIMARY KEY (id_auditoria)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.auditoria OWNER to postgres;