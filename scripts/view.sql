CREATE OR REPLACE VIEW vw_obitos_detalhado AS
SELECT 
    o.id_obito,
    o.data AS data_obito,
    o.data_nascimento,
    o.idade,
    o.sexo,
    rc.descricao AS raca_cor,
    c.codigo_cid,
    c.descricao AS causa_morte,
    l.municipio,
    l.estado,
    l.regiao,
    o.assist_med,
    o.necropsia
FROM public.obitos o
LEFT JOIN public.raca_cor rc ON o.id_raca_cor = rc.id_raca_cor
LEFT JOIN public.causas c ON o.id_causa_principal = c.id_causa
LEFT JOIN public.localizacoes l ON o.id_local = l.id_local;

-- Consulta
SELECT * FROM vw_obitos_detalhado;
