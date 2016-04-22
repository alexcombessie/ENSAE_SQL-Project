SELECT Salary.id_manager, Person.last_name, avg(Salary.rating_previous_year)
FROM Salary
JOIN Person ON Salary.id_manager = Person.id_person
GROUP BY Salary.id_manager, Person.last_name