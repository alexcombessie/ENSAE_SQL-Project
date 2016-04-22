/* g. Extraire le bénéfice moyen de chaque pays sur l’ensemble des produits vendus
(bénéfice = prix de vente d’un item - prix d’achat). (Colonne 1 : Pays, Colonne 2 : Benefmoyen) */

/* Calculer le bénéfice pour chaque accompagement*/
DROP TABLE IF EXISTS BenefByFood;
CREATE TABLE BenefByFood AS
SELECT Carte.country AS Country, Item.id_item AS id_item, Carte.price AS Price, Item.cost_food AS Cost,
CASE WHEN Item.type="Food" THEN (Carte.price - Item.cost_food) ELSE '' END AS Benef
FROM Carte
JOIN Item ON Item.country=Carte.country AND Item.id_item=Carte.id_item
WHERE Item.type="Food";

/* Calculer le bénéfice pour chaque boisson composée d'ingrédients*/
DROP TABLE IF EXISTS BenefByDrink;
CREATE TABLE BenefByDrink AS
SELECT Carte.country AS Country, Item.id_item AS id_item, Carte.price AS Price,  SUM(Recipe.quantity * Ingredient.unit_cost) AS Cost,
(Carte.price - SUM(Recipe.quantity * Ingredient.unit_cost)) AS Benef
FROM Carte
INNER JOIN Item ON Item.country=Carte.country AND Item.id_item=Carte.id_item
CROSS JOIN Recipe ON Recipe.id_item = Carte.id_item
INNER JOIN Ingredient ON Ingredient.id_ingredient = Recipe.id_ingredient AND Ingredient.country = Carte.country
WHERE Item.type="Drink"
GROUP BY Carte.country, Carte.id_item;

/* Combiner les deux tables précédentes en une table benefice par item (et par pays)*/
DROP TABLE IF EXISTS BenefByItem;
CREATE TABLE BenefByItem AS
SELECT * FROM (SELECT * FROM BenefByDrink UNION ALL SELECT * FROM BenefByFood) GROUP BY Country, id_item;

/* A partir de la table benefice par item, reconstruire le benefice par menu en fonction des items dans les menus (et par pays)*/
DROP TABLE IF EXISTS BenefByMenu;
CREATE TABLE BenefByMenu AS SELECT Country, id_menu, SUM(price*reduction) AS Price, SUM(Cost) AS Cost, SUM(price*reduction-Cost) AS Benef FROM
(
	SELECT * FROM (SELECT Menu.country AS Country, Menu.id_menu, id_item1 AS id_item, BenefByItem.Price AS price, Menu.reduction, BenefByItem.Cost AS Cost FROM Menu
	  JOIN BenefByItem ON BenefByItem.Country = Menu.country AND BenefByItem.id_item = Menu.id_item1)
UNION ALL
	SELECT * FROM (SELECT Menu.country AS Country, Menu.id_menu, id_item2 AS id_item, BenefByItem.Price AS price, Menu.reduction, BenefByItem.Cost AS Cost FROM Menu
	  JOIN BenefByItem ON BenefByItem.Country = Menu.country AND BenefByItem.id_item = Menu.id_item2)
	  UNION ALL
	  	SELECT * FROM (SELECT Menu.country AS Country, Menu.id_menu, id_item3 AS id_item, BenefByItem.Price AS price, Menu.reduction, BenefByItem.Cost AS Cost FROM Menu
	  JOIN BenefByItem ON BenefByItem.Country = Menu.country AND BenefByItem.id_item = Menu.id_item3)
	  UNION ALL
	  	SELECT * FROM (SELECT Menu.country AS Country, Menu.id_menu, id_item4 AS id_item, BenefByItem.Price AS price, Menu.reduction, BenefByItem.Cost AS Cost FROM Menu
	  JOIN BenefByItem ON BenefByItem.Country = Menu.country AND BenefByItem.id_item = Menu.id_item4)
	  ) GROUP BY Country, id_menu;

/* A partir des tables benefice par item et benefice par menu on peut calculer le benefice moyen par item/menu vendu dans chaque pays */
SELECT country, AVG(Benef) AS Benefmoyen FROM  (
SELECT * FROM (
	SELECT Cafe.country, Command.id_item, Command.id_menu, (Command.quantity*BenefByItem.Benef) AS Benef FROM Command
	JOIN Cafe ON Cafe.id_cafe = Command.id_cafe
	JOIN BenefByItem ON BenefByItem.id_item = Command.id_item AND BenefByItem.Country = Cafe.country)
UNION ALL
SELECT * FROM (
	SELECT  Cafe.country, Command.id_item, Command.id_menu, (Command.quantity* BenefByMenu.Benef) AS Benef FROM Command
	JOIN Cafe ON Cafe.id_cafe = Command.id_cafe
	JOIN BenefByMenu ON BenefByMenu.id_menu = Command.id_menu AND BenefByMenu.Country = Cafe.country)
) GROUP BY country;

/* Supprimer les tables intermédiaires*/
DROP TABLE IF EXISTS BenefByItem;
DROP TABLE IF EXISTS BenefByFood;
DROP TABLE IF EXISTS BenefByDrink;
DROP TABLE IF EXISTS BenefByMenu;
