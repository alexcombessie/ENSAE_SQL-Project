/*d. Extraire la boisson la moins vendue entre 00h00 et 11h59 pour chaque café.
(Colonne 1 : cafe, colonne 2 : boisson, colonne 3 : quantite)*/

DROP TABLE IF EXISTS SumItem;
CREATE TABLE SumItem AS 
SELECT Cafe.id_cafe AS id_cafe, name_cafe AS cafe, Item.name_item AS boisson, SUM(Command.quantity) AS quantite FROM Command 
JOIN Cafe ON Cafe.id_cafe=Command.id_cafe
JOIN Item ON Item.id_item=Command.id_item AND Item.country=Cafe.country
WHERE Command.id_item != "" AND Command.hour BETWEEN 0 AND 11 AND Item.type="Drink"
GROUP BY Cafe.id_cafe, Item.name_item;


DROP TABLE IF EXISTS SumMenu;
CREATE TABLE SumMenu AS 
SELECT Cafe.id_cafe AS id_cafe, Cafe.country AS country, name_cafe AS cafe, id_item1, id_item2, id_item3, id_item4, SUM(Command.quantity) AS quantite FROM Command 
JOIN Cafe ON Cafe.id_cafe=Command.id_cafe 
JOIN Menu ON Menu.id_menu = Command.id_menu AND Menu.country = Cafe.country
WHERE Command.id_menu != "" AND Command.hour BETWEEN 0 AND 12
GROUP BY Cafe.id_cafe, Command.id_menu;

DROP TABLE IF EXISTS SumMenuUnpvt;
CREATE TABLE SumMenuUnpvt AS 
SELECT * FROM (SELECT country, id_cafe, cafe, id_item1 AS id_item, quantite FROM SumMenu) 
UNION ALL
SELECT * FROM (SELECT country, id_cafe, cafe, id_item2 AS id_item, quantite FROM SumMenu) 
UNION ALL
SELECT * FROM (SELECT country, id_cafe, cafe, id_item3 AS id_item, quantite FROM SumMenu) 
UNION ALL
SELECT * FROM (SELECT country, id_cafe, cafe, id_item4 AS id_item, quantite FROM SumMenu) ;

DROP TABLE IF EXISTS SumMenuDrink;
CREATE TABLE SumMenuDrink AS 
SELECT SumMenuUnpvt.id_cafe AS id_cafe, cafe, Item.name_item AS boisson, SUM(quantite) AS quantite FROM SumMenuUnpvt
JOIN Item ON Item.id_item = SumMenuUnpvt.id_item AND Item.country = SumMenuUnpvt.country
WHERE Item.type="Drink"
GROUP BY id_cafe, Item.name_item;

DROP TABLE IF EXISTS SumMenuItem;
CREATE TABLE SumMenuItem AS  SELECT  id_cafe, cafe, boisson, SUM(quantite) AS quantite FROM (
SELECT * FROM SumMenuDrink UNION ALL SELECT * FROM SumItem )
GROUP BY id_cafe, boisson;

DROP TABLE IF EXISTS CafeBoisson;
CREATE TABLE CafeBoisson AS SELECT * FROM (
			(SELECT DISTINCT id_cafe, name_cafe FROM Cafe) 
			CROSS JOIN
			(SELECT DISTINCT name_item AS boisson FROM Item WHERE type="Drink" ) )
;

DROP TABLE IF EXISTS SumMenuItemZero;
CREATE TABLE SumMenuItemZero AS SELECT cafe, boisson, quantite FROM (
SELECT CafeBoisson.id_cafe AS id_cafe, CafeBoisson.name_cafe AS cafe, CafeBoisson.boisson AS boisson, COALESCE(SumMenuItem.quantite,0) AS quantite  
FROM CafeBoisson
LEFT JOIN SumMenuItem 
ON SumMenuItem.id_cafe = CafeBoisson.id_cafe AND SumMenuItem.boisson = CafeBoisson.boisson );

SELECT cafe, boisson, MIN(quantite)  AS quantite
FROM SumMenuItemZero
GROUP BY cafe;


DROP TABLE IF EXISTS SumItem;
DROP TABLE IF EXISTS SumMenu;
DROP TABLE IF EXISTS SumMenuUnpvt;
DROP TABLE IF EXISTS SumMenuDrink;
DROP TABLE IF EXISTS SumMenuItem;
DROP TABLE IF EXISTS SumMenuItemZero;
DROP TABLE IF EXISTS CafeBoisson;

