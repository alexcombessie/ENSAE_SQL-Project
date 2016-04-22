/*k. Extraire la moyenne des notes attribuées pour chaque manager aux employés sous leurs ordres 
(Colonne 1 : manager, Colonne 2 : notemoyenne).*/

SELECT Person.last_name AS manager, AVG(Salary.rating_previous_year) as NoteMoyenne
FROM Salary
JOIN Person ON Salary.id_manager = Person.id_person
GROUP BY Salary.id_manager, Person.last_name;