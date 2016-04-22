SELECT cafe.name_cafe, avg(salary.amount) as salaireMoyen
FROM Cafe cafe 
JOIN Staff staff on cafe.id_cafe = staff.id_cafe
JOIN Salary salary on staff.id_person = salary.id_person
WHERE staff.start_date <= date('now', '-2 years') AND salary.year = strftime('%Y', 'now')
GROUP BY cafe.name_cafe
ORDER BY salaireMoyen DESC
LIMIT 10

