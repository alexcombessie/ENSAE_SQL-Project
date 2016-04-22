/* a. a. Extraire le nombre d’employés dans le département du 75. 
(Colonne 1 : nbemployes)*/

SELECT COUNT(1) AS employes_75
FROM Staff 
JOIN Cafe ON Staff.id_cafe = Cafe.id_cafe
WHERE Staff.end_date LIKE '' AND Cafe.postal_code LIKE '75%';
