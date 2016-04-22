DROP TABLE IF EXISTS PriceByMenu;
CREATE TABLE PriceByMenu AS SELECT Country, id_menu, SUM(price*reduction) AS Price FROM 
(
	SELECT * FROM (SELECT Menu.country AS Country, Menu.id_menu, id_item1 AS id_item, Carte.Price AS price, Menu.reduction FROM Menu
	  JOIN Carte ON Carte.Country = Menu.country AND Carte.id_item = Menu.id_item1)
UNION ALL
	SELECT * FROM (SELECT Menu.country AS Country, Menu.id_menu, id_item2 AS id_item, Carte.Price AS price, Menu.reduction FROM Menu
	  JOIN Carte ON Carte.Country = Menu.country AND Carte.id_item = Menu.id_item2)
	  UNION ALL
	  	SELECT * FROM (SELECT Menu.country AS Country, Menu.id_menu, id_item3 AS id_item, Carte.Price AS price, Menu.reduction FROM Menu
	  JOIN Carte ON Carte.Country = Menu.country AND Carte.id_item = Menu.id_item3)
	  UNION ALL
	  	SELECT * FROM (SELECT Menu.country AS Country, Menu.id_menu, id_item4 AS id_item, Carte.Price AS price, Menu.reduction FROM Menu
	  JOIN Carte ON Carte.Country = Menu.country AND Carte.id_item = Menu.id_item4)
	  ) GROUP BY Country, id_menu;
	  
	  
DROP TABLE IF EXISTS CaMenu;
CREATE TABLE CaMenu AS
SELECT Cafe.id_cafe as id_cafe, Cafe.coworking as coworking, sum(Command.quantity*PriceByMenu.Price) as CA
FROM Command
JOIN Cafe ON Command.id_cafe = Cafe.id_cafe
JOIN PriceByMenu ON Command.id_menu = PriceByMenu.id_menu AND Cafe.country = PriceByMenu.Country
WHERE Command.id_menu IS NOT NULL
GROUP BY Cafe.id_cafe, Cafe.coworking;

DROP TABLE IF EXISTS CaCarte;
CREATE TABLE CaCarte AS
SELECT Cafe.id_cafe as id_cafe, Cafe.coworking as cowroking, sum(Command.quantity*Carte.Price) as CA
FROM Command
JOIN Cafe ON Command.id_cafe = Cafe.id_cafe
JOIN Carte ON Command.id_item = Carte.id_item AND Cafe.country = Carte.Country
WHERE Command.id_item IS NOT NULL
GROUP BY Cafe.id_cafe, Cafe.coworking;


SELECT coworking, avg(CA_Cafe) as CA_moyen
FROM
(SELECT id_cafe, coworking, sum(CA) as CA_Cafe FROM (SELECT * FROM CaMenu UNION ALL SELECT * FROM CaCarte) GROUP BY coworking, id_cafe)
GROUP BY coworking;

DROP TABLE IF EXISTS PriceByMenu;
DROP TABLE IF EXISTS CaMenu;
DROP TABLE IF EXISTS CaCarte;