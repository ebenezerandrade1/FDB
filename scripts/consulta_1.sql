WITH obitos_por_municipio AS (
    SELECT 
        l.estado,
        l.municipio,
        COUNT(o.id_obito) AS total_obitos,
        RANK() OVER (PARTITION BY l.estado ORDER BY COUNT(o.id_obito) DESC) AS rank
    FROM public.obitos o
    JOIN public.localizacoes l ON o.id_local = l.id_local
    GROUP BY l.estado, l.municipio
)
SELECT estado, municipio, total_obitos
FROM obitos_por_municipio
WHERE rank = 1
ORDER BY total_obitos DESC;