/*n. Extraire le top 10 des employés ayant le plus changé de fonction.*/

/*On repère un changement de fonction à la création d'une nouvelle entrée dans la table Staff, avec un champ 'position_domain' différent*/

SELECT Person.last_name, count(distinct Staff.position_domain) as nbFonctions
FROM Staff
JOIN Person ON Staff.id_person = Person.id_person
GROUP BY Staff.id_person
ORDER BY nbFonctions DESC
LIMIT 10

