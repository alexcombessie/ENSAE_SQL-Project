SELECT id_person, count(distinct position_domain) as nbFonctions
FROM Staff
GROUP BY id_person
ORDER BY nbFonctions DESC
LIMIT 10