select cafe.name_cafe, sum(salary.amount) as masse_salariale
from Cafe cafe join Staff staff on cafe.id_cafe = staff.id_cafe join Salary salary on staff.id_person = salary.id_person
where staff.end_date like ''
group by cafe.name_cafe
order by masse_salariale asc
limit 1