/* c. Extraire le café ayant la masse salariale la moins importante (somme des salaires) 
(Colonne 1 : cafe, Colonne 2 : masse salariale) */

/*On fait la somme des salaires en agrégeant par café, puis on trie les résultats pour obtenir la masse salariale la moins importante*/

SELECT Cafe.name_cafe, SUM(Salary.amount) AS masse_salariale
FROM Cafe  
JOIN Staff ON Cafe.id_cafe = Staff.id_cafe 
JOIN Salary ON Staff.id_person = Salary.id_person
WHERE Staff.end_date LIKE ''
GROUP BY Cafe.name_cafe
ORDER BY masse_salariale ASC
LIMIT 1;