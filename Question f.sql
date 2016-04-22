/* f. Extraire les stocks du café du 92240 avec une colonne en plus appelée 
« A commander » qui aura comme valeur (Colonne 1 : Ingredient, Colonne 2 : A commander) :
- Si l’ingrédient a plus de 1000 unités en stock, le statut est « OK ».
- Si l’ingrédient a entre 750 et 999 unités en stock, le statut est « en stock ».
- Si l’ingrédient a entre 500 et 747 unités en stock, le statut est « à commander : Pas d’urgence ».
- Si l’ingrédient a entre 250 et 499 unités en stock, le statut est « à commander : urgence ».
- Si l’ingrédient a entre 1 et 249 unités en stock, le statut est « à commander : prioritaire ».
- Si l’ingrédient n’a pas de stock, le statut est : « à commander : Rupture de stock ». */
SELECT Ingredient.name_ingredient AS "Ingredient", 
  CASE
    WHEN (Stock_ingredient.stock >=1000) THEN "OK"
	WHEN (Stock_ingredient.stock BETWEEN 750 AND 999) THEN "en stock"
	WHEN (Stock_ingredient.stock BETWEEN 500 AND 749) THEN "à commander : Pas d’urgence"
	WHEN (Stock_ingredient.stock BETWEEN 250 AND 499) THEN "à commander : urgence"
	WHEN (Stock_ingredient.stock BETWEEN 1 AND 249) THEN "à commander : prioritaire"
	ELSE "à commander : Rupture de stock"
  END AS "A Commander"
FROM Stock_ingredient 
JOIN Ingredient ON Stock_ingredient.id_ingredient = Ingredient.id_ingredient
JOIN Cafe ON Cafe.id_cafe = Stock_ingredient.id_cafe
WHERE Stock_ingredient.date_stock = (SELECT  MAX(Stock_ingredient.date_stock) FROM Stock_ingredient) 
AND Cafe.postal_code = "92240"
AND Ingredient.country = (SELECT country FROM  cafe WHERE postal_code="92240")

