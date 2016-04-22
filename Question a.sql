select count(1) as employes_75
from Staff staff join Cafe cafe on staff.id_cafe = cafe.id_cafe
where staff.end_date like '' and cafe.postal_code like '75%'
