/*Extraire les cafés n’ayant pas encore ouvert (sans employés). 
(Colonne 1 : cafe)*/

/*On compte le nombre d'employés par cafés et on se restreint aux cafés qui ont 0 employés*/

SELECT Cafe.name_cafe AS cafe
FROM Cafe 
LEFT JOIN Staff ON Cafe.id_cafe = Staff.id_cafe
GROUP BY cafe.name_cafe
HAVING COUNT(Staff.id_person) = 0
