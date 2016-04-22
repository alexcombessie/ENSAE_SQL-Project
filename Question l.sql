/*l. Extraire le nombre de vente pour le vendeur « BorneRapide » pour le magasin du 92240 ainsi que le nombre de vente pour l’ensemble des autres vendeurs 
(Colonne 1 : Vendeur : Colonne 2 : nbVente. Ligne 1 : BorneRapide, Ligne 2 : Ensemble des vendeurs)*/

SELECT vendeur, count(1) as nbVentes
FROM
(SELECT CASE WHEN id_seller = '1' THEN 'Borne Rapide' ELSE 'Ensemble des vendeurs' END as vendeur
FROM Command
JOIN Cafe ON Cafe.id_cafe = Command.id_cafe
WHERE Cafe.postal_code = '92240')
GROUP BY vendeur