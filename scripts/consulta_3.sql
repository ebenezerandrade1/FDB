SELECT c.codigo_cid, c.descricao, ROUND(AVG(o.idade), 1) AS idade_media, COUNT(o.id_obito) AS total_obitos
FROM obitos o
JOIN causas c ON o.id_causa_principal = c.id_causa
WHERE o.idade > 0
GROUP BY c.codigo_cid, c.descricao
ORDER BY total_obitos DESC
LIMIT 10;