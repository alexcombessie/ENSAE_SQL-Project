DROP TABLE IF EXISTS ItemQuantity;
CREATE TABLE ItemQuantity AS 
SELECT Command.id_item AS id_item, SUM(Command.quantity) AS quantity
FROM Command
JOIN Client ON Command.id_client = Client.id_client
JOIN Cafe ON Cafe.id_cafe = Command.id_cafe
WHERE Client.birth_date >= date('now', '-40 years') AND Command.id_item NOT LIKE "" AND Cafe.country = "France"
GROUP BY Command.id_item, Cafe.country
ORDER BY quantity DESC;

DROP TABLE IF EXISTS ItemQuantity1;
CREATE TABLE ItemQuantity1 AS 
SELECT Menu.id_item1 AS id_item, SUM(Command.quantity) AS quantity
FROM Command
JOIN Menu ON Menu.id_menu = Command.id_menu
JOIN Client ON Command.id_client = Client.id_client
JOIN Cafe ON Cafe.id_cafe = Command.id_cafe
WHERE Client.birth_date >= date('now', '-40 years') AND Command.id_menu NOT LIKE "" AND Cafe.country = "France"
GROUP BY Menu.id_item1, Cafe.country
ORDER BY quantity DESC;

DROP TABLE IF EXISTS ItemQuantity2;
CREATE TABLE ItemQuantity2 AS 
SELECT Menu.id_item2 AS id_item, SUM(Command.quantity) AS quantity
FROM Command
JOIN Menu ON Menu.id_menu = Command.id_menu
JOIN Client ON Command.id_client = Client.id_client
JOIN Cafe ON Cafe.id_cafe = Command.id_cafe
WHERE Client.birth_date >= date('now', '-40 years') AND Command.id_menu NOT LIKE "" AND Cafe.country = "France"
GROUP BY Menu.id_item2, Cafe.country
ORDER BY quantity DESC;

DROP TABLE IF EXISTS ItemQuantity3;
CREATE TABLE ItemQuantity3 AS 
SELECT Menu.id_item3 AS id_item, SUM(Command.quantity) AS quantity
FROM Command
JOIN Menu ON Menu.id_menu = Command.id_menu
JOIN Client ON Command.id_client = Client.id_client
JOIN Cafe ON Cafe.id_cafe = Command.id_cafe
WHERE Client.birth_date >= date('now', '-40 years') AND Command.id_menu NOT LIKE "" AND Cafe.country = "France"
GROUP BY Menu.id_item3, Cafe.country
ORDER BY quantity DESC;

DROP TABLE IF EXISTS ItemQuantity4;
CREATE TABLE ItemQuantity4 AS 
SELECT Menu.id_item4 AS id_item, SUM(Command.quantity) AS quantity
FROM Command
JOIN Menu ON Menu.id_menu = Command.id_menu
JOIN Client ON Command.id_client = Client.id_client
JOIN Cafe ON Cafe.id_cafe = Command.id_cafe
WHERE Client.birth_date >= date('now', '-40 years') AND Command.id_menu NOT LIKE "" AND Cafe.country = "France"
GROUP BY Menu.id_item4, Cafe.country
ORDER BY quantity DESC;

SELECT Item.name_item, Item.size, SUM(temp_table.quantity) AS quantity
FROM
(SELECT * FROM ItemQuantity UNION ALL SELECT * FROM ItemQuantity1 UNION ALL SELECT * FROM ItemQuantity2 UNION ALL SELECT *
FROM ItemQuantity3 UNION ALL SELECT * FROM ItemQuantity4) AS temp_table
JOIN Item ON Item.id_item = temp_table.id_item
GROUP BY Item.name_item, Item.size
ORDER BY quantity DESC;

DROP TABLE IF EXISTS ItemQuantity;
DROP TABLE IF EXISTS ItemQuantity1;
DROP TABLE IF EXISTS ItemQuantity2;
DROP TABLE IF EXISTS ItemQuantity3;
DROP TABLE IF EXISTS ItemQuantity4;