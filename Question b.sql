/* b. Extraire l’ingrédient le plus utilisé dans chaque département.
(Colonne 1 : Departement, Colonne 2 : ingredient) */

/* On construit une table intermédiaire
qui fait la somme des sorties de stock pour chaque ingrédient
*/
DROP TABLE IF EXISTS SumByCountryDep;
CREATE TABLE SumByCountryDep AS
SELECT Cafe.country AS country, substr(Cafe.postal_code,1,2) AS departement, Ingredient.name_ingredient AS ingredient, SUM(Stock_ingredient.out) AS sum_ingredient
FROM Stock_ingredient
JOIN Cafe ON Cafe.id_cafe = Stock_ingredient.id_cafe
JOIN Ingredient ON Ingredient.id_ingredient = Stock_ingredient.id_ingredient AND Ingredient.country = Cafe.country
GROUP BY Cafe.country, substr(Cafe.postal_code,1,2), Stock_ingredient.id_ingredient;
SELECT * FROM SumByCountryDep;

/* On utilise la command MAX sur un GROUP BY
pour extraire l'ingredient le plus utilisé
*/
SELECT (country || "-"|| departement) AS departement, ingredient FROM (
SELECT country, departement, ingredient, MAX(sum_ingredient) FROM SumByCountryDep GROUP BY country, departement);
DROP TABLE IF EXISTS SumByCountryDep;
