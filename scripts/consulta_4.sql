WITH obitos_por_regiao_sexo AS (
    SELECT 
        l.regiao,
        o.sexo,
        o.id_causa_principal,
        c.codigo_cid,
        c.descricao,
        COUNT(o.id_obito) AS total_obitos
    FROM public.obitos o
    JOIN public.localizacoes l ON o.id_local = l.id_local
    JOIN public.causas c ON o.id_causa_principal = c.id_causa
    WHERE o.sexo IN ('M', 'F')  -- Filtra apenas óbitos de homens e mulheres
    GROUP BY l.regiao, o.sexo, o.id_causa_principal, c.codigo_cid, c.descricao
),
ranked_causas AS (
    SELECT *,
        RANK() OVER (PARTITION BY regiao, sexo ORDER BY total_obitos DESC) AS rank
    FROM obitos_por_regiao_sexo
)
SELECT regiao, sexo, codigo_cid, descricao, total_obitos
FROM ranked_causas
WHERE rank = 1
ORDER BY regiao, sexo;