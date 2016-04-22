/*i. Extraire le nombre moyen de ventes réalisées pour chaque heure par un employé ayant moins d’1 an d’expérience 
(Colonne 1 : Heure, Colonne 2 : NbVentes).*/

/*On compte le nombre de ventes réalisées pa heure, en se restreignant via le "WHERE" aux ventes réalisées par des employés présents dans le groupe depuis moins de 1 an*/ 

SELECT Command.hour AS Heure, COUNT(Staff.id_person) AS NbVentes
FROM Command
LEFT JOIN Staff ON Command.id_seller = Staff.id_person
WHERE Staff.start_date > date('now', '-1 years')
GROUP BY Command.hour
ORDER BY Command.hour