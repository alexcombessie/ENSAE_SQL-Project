/*h. Extraire le top 10 des cafés payant le mieux leurs employés ayant plus de deux ans d’expérience. 
(Colonne 1 : cafe, colonne 2 : salaireMoyen)*/

/*On commence par trouver les employés qui ont deux ans d'expérience au moins dans le groupe (on fait l'hypothèse qu'il n'y a pas de trou dans le parcours des employés - 
impossible de quitter puis de revenir dans le groupe- donc tous les employés qui étaient là il y a 2 ans ont au moins 2 ans d'expérience.
On crée une table intermédiaire avec tous les employés qui étaient dans le groupe il y a 2 ans*/

DROP TABLE IF EXISTS EmpExp;
CREATE TABLE EmpExp AS 
SELECT DISTINCT Staff.id_person
FROM Staff
WHERE Staff.start_date <= date('now', '-2 years')

/*On regarde ensuite parmi ces employés ceux qui sont encore dans le groupe aujourd'hui, et on fait la moyenne de leurs salaires moyens agrégés par café. Enfin, on affiche le top 10*/

SELECT Cafe.name_cafe AS cafe, avg(Salary.amount) AS salaireMoyen
FROM EmpExp 
JOIN Staff ON EmpExp.id_person = Staff.id_person
JOIN Cafe ON Cafe.id_cafe = Staff.id_cafe
JOIN Salary on Staff.id_person = Salary.id_person
WHERE Salary.year = strftime('%Y', 'now')
GROUP BY Cafe.name_cafe
ORDER BY salaireMoyen DESC
LIMIT 10