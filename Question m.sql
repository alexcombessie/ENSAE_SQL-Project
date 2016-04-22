/* m. Extraire l’ensemble des menus pour la France et l’Angleterre classés 
de la plus importante réduction à la moins importante 
(Colonne 1 : Pays, Colonne 2 : NomMenu, Colonne 3 : Reduction).*/
SELECT Menu.country AS Pays, Menu.name_menu AS NomMenu, Menu.reduction AS Reduction FROM Menu
WHERE Menu.country ='France' OR Menu.country='UK' 
ORDER BY  Menu.country,  Menu.reduction