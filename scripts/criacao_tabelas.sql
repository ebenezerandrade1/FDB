CREATE TABLE causas (
    id_causa SERIAL PRIMARY KEY,
    codigo_cid VARCHAR(10) UNIQUE NOT NULL,
    descricao TEXT NOT NULL
);