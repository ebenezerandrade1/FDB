WITH obitos_faixa_etaria AS (
    SELECT 
        CASE 
            WHEN o.idade BETWEEN 0 AND 10 THEN '0 a 10 anos'
            WHEN o.idade BETWEEN 11 AND 30 THEN '11 a 30 anos'
            WHEN o.idade BETWEEN 31 AND 50 THEN '31 a 50 anos'
            WHEN o.idade BETWEEN 51 AND 70 THEN '51 a 70 anos'
            WHEN o.idade > 71 THEN 'Maior que 71 anos'
        END AS faixa_etaria,
        o.id_causa_principal,
        c.codigo_cid,
        c.descricao,
        COUNT(o.id_obito) AS total_obitos
    FROM public.obitos o
    JOIN public.causas c ON o.id_causa_principal = c.id_causa
    WHERE o.idade IS NOT NULL
    GROUP BY faixa_etaria, o.id_causa_principal, c.codigo_cid, c.descricao
),
ranking_causas AS (
    SELECT *,
        RANK() OVER (PARTITION BY faixa_etaria ORDER BY total_obitos DESC) AS rank
    FROM obitos_faixa_etaria
)
SELECT id_causa_principal, codigo_cid, descricao, faixa_etaria, total_obitos
FROM ranking_causas
WHERE rank = 1
ORDER BY faixa_etaria;