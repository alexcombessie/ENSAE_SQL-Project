SELECT vendeur, count(1) as nbVentes
FROM
(SELECT CASE WHEN id_seller = '1' THEN 'Borne Rapide' ELSE 'Ensemble des vendeurs' END as vendeur
FROM Command
JOIN Cafe ON Cafe.id_cafe = Command.id_cafe
WHERE Cafe.postal_code = '92240')
GROUP BY vendeur