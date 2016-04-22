/*o. Extraire pour chaque département, la proportion d’homme et la proportion de femmes qui sont clients. 
(Colonne 1 : Departement, Colonne 2 : Proportion homme (%), Colonne 3 : Proportion femme)*/

/*On commence par regarder, pour chaque département, l'ensemble des clients distincts. On ajoute à ces données le genre de chacun des clients en faisant un JOIN avec la table Client.
Enfin, on agrège ces données pour obtenir les proportions voulues*/ 

SELECT dpt, 1.0*nbHommes/(nbHommes+nbFemmes) AS prop_Hommes, 1.0*nbFemmes/(nbHommes+nbFemmes) AS prop_Femmes
FROM
(SELECT distinctByDpt.dpt, SUM(CASE WHEN Client.gender = "M" THEN 1 ELSE 0 END) AS nbHommes, SUM(CASE WHEN Client.gender = "F" THEN 1 ELSE 0 END) AS nbFemmes
FROM 
(SELECT distinct SUBSTR(Cafe.postal_code,1,2) AS dpt, Command.id_client  FROM Cafe JOIN Command ON Cafe.id_cafe = Command.id_cafe
WHERE Command.id_client NOT LIKE "") AS distinctByDpt
JOIN Client ON Client.id_client = distinctByDpt.id_client
GROUP BY distinctByDpt.dpt) AS temp_results

