SELECT 
    l.municipio,
    l.estado,
    COUNT(o.id_obito) AS total_obitos_sem_necropsia
FROM public.obitos o
JOIN public.localizacoes l ON o.id_local = l.id_local
WHERE o.necropsia IS NULL OR o.necropsia = 'não'
GROUP BY l.municipio, l.estado
ORDER BY total_obitos_sem_necropsia DESC
LIMIT 10;