Select cafe.name_cafe, count(staff.id_person) as nb_employes
From Cafe cafe left join Staff staff on cafe.id_cafe = staff.id_cafe
Group By cafe.name_cafe
Having nb_employes = 0
