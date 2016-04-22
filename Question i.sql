SELECT command.hour, count(staff.id_person)
FROM Command command
LEFT JOIN Staff staff on command.id_seller = staff.id_person
WHERE staff.start_date > date('now', '-1 years')
GROUP BY command.hour
ORDER BY command.hour