# Projet SQL - Starckub

**Projet final du cours de Base de Données à l'ENSAE ParisTech**

*Par Alexandre COMBESSIE et Thibaut DUGUET*

******

## Introduction

Ce projet de base de données a été l'occasion de découvrir différents aspects de la gestion de base de données : de la conception du modèle de données à la mise en place de requêtes élaborées, en passant par la constitution d'un jeu de données simulées. Nous sommes ici placés dans le cadre relationnel, ce qui implique une certaine manière de penser le modèle de données. Le moteur de base de données utilisé est `SQLite`, qui a l'avantage d'être très léger. Il est ainsi utilisé dans les systèmes d'exploitation mobiles iOS et Android.

L'objet de ce projet est *"Starckub"*, chaîne imaginaire de cafés présente dans plusieurs pays. Cela permet de couvrir à la fois des sujets de base de données côté client, employé, et opérations (finance, gestion des stocks). Nous sommes partis d'un ensemble de besoins exprimés simples mais assez proches de la réalité d'une vraie chaîne de cafés.

Notons que le modèle de données implémenté est un choix personnel basé sur certaines hypothèses. En effet, l'expression des besoins laisse une certaine marge d'interprétation. De plus, même pour des hypothèses identiques, il existe plusieurs manières de répondre à ces besoins. Il y a de nombreuses façons d'exprimer des requêtes pour des résultats identiques. Dans la mesure du possible nous avons pris des hypothèses réalistes pour la gestion d'une vraie chaîne de café.

L'ensemble de notre projet (données et scripts) est disponible comme un repo GitHub : http://github.com/alexcombessie/ENSAE_SQL-Project.

******

## 1. Modèle de données choisi

Nous avons travaillé avec le logiciel GenMyModel pour concevoir notre modèle de données. Nous avons ainsi construit un diagramme avec toutes nos tables, leurs champs de données ainsi que leur types. Nous avons également indiqué pour chaque table quelles sont les clés primaires.

Ce diagramme est disponible sur Internet : http://repository.genmymodel.com/alexcombessie/Starckub. 

Vous le trouverez également en version image ci-dessous / en page suivante.


![](http://i.imgur.com/4LRXS6t.png)

Chaque couleur correspond à une fonction spécifique de gestion de la chaîne de cafés : 
- Bleu pour la relation client
- Vert pour les ressources humaines
- Rouge pour la gestion interne des opérations
- Noir pour l'offre de produits

On a notamment indiqué les primary keys sur ce diagramme.




******

## 2. Hypothèses complémentaires


### a. Relation client 

Les commandes sont enregistrées au fil de l'eau, avec l'ensemble des renseignements stockées pour chaque commande. Certaines commandes possèdent un `id_client`, d'autres non. Nous avons en effet fait l'hypothèse que tous les clients n'étaient pas enregistrés dans le CRM, et que certaines commandes étaient faites par des personnes n'ayant pas de carte de fidélité. Le champ correspondant dans la table commande est alors laissé vide.

### b. Ressources humaines

Pour la gestion des ressources humaines, nous avons choisi d'utiliser trois tables, une pour chaque élément "atomique" que nous avions à traiter. Ainsi, une première table s'est imposée, la table Person avec les informations de l'ensemble des employés de l'entreprise, quelque soit leur statut. Nous avons également choisi de créer deux objets dans cette table qui ont un statut particulier:
- Une personne avec le nom *Groupe* correspondant à la maison mère, et nous avons ainsi fait l'hypothèse que les évaluations des directeurs de chaque Cafés étaient faites par cette personne.
- Une deuxième personne avec le nom *Borne Rapide* correspondant à une commande faite à une borne, et non pas encaissée par un caissier employé du groupe.

A noter qu'il est toujours très facile de faire des requêtes pour les *vrais* employés, puisque ces deux personnesau statut particulier ont le champ `gender` vide.

Nous avons ensuite créé une deuxième table nommé Staff, pour enregistrer le statut de chaque employé à une date donnée. Chaque ligne correspond ainsi à la situation d'un employé entre deux dates (poste occupé, café auquel l'employé est rattaché). Nous disposons ainsi très facilement de tout l'historique des postes occupés par un même employé sur longue période.

Nous avions dans un premier temps pensé créer trois tables différentes en fonction du niveau dans la hiérarchie (opérationnel, manager, directeur), mais il nous a semblé plus clair de ne créer qu'une seule table pour avoir très facilement et sans jointure l'ensemble des informations pour un individu donné. Par ailleurs, en mettant en place des index sur cette table, les performances des requêtes restent relativement peu affectées.

Nous avons enfin utilisé une dernière table, Salary, pour enregistrer les salaires de chacun des employés. Nous avons ici fait une hypothèse assez simplificatrice : nous aurions pu raisonner comme dans la table staff avec une date de début et une table de fin, mais nous avons ici simplifié la situation, en supposant que les augmentations de salaire n'avaient lieu qu'une fois par an, au 1er janvier. On peut aussi imaginer que pour une personne recevant une augmentation de salaire en cours d'année, on modifie la valeur du champ `amount`, mais on perd alors l'historique, ce qui est regrettable, notamment pour le caclcul des coûts. Au final, nous faisons donc l'hypothèse que les augmentations n'ont lieu qu'une fois par an, au moment où chaque supérieur hiérarchique doit mettre une note sur les performances des employés sous ses ordres. Il nous a en effet semblé pertinent de mettre dans une même table le salaire et la note de l'année précédente, puisque ces deux paramètres sont liés.


### c. Gestion interne des opérations


Pour la gestion des stocks, nous avons adopté un système d'enregistrement à la journée pour chaque café et ingrédient. Afin de faciliter le suivi, nous enregistrons non seulement le stock à la fin de la journée, mais aussi le volume d'entrée et sortie de stock. Originellement, nous avions uniquement enregistré le stock, mais cela ne permettait pas de reconstituer la consommation cumulée pour chaque ingrédient. 

### d. Offre de produits

Nous supposons que les prix et les coûts des items et ingrédients sont définis par pays. Cela correspond à une politique d'approvisionnement local des ingrédients. En revanche, les recettes sont les mêmes pour tous les pays. De plus, nous définissons un `id_item` unique pour chaque taille de boisson. Il est possible de regrouper l'ensemble des tailles d'une boisson donnée en utilisant le champ `name_item`.

En ce qui concerne les menus, chaque pays a la liberté de constituer ses menus et le niveau de ses réductions. En revanche, il n'est pas possible de mettre plus de 4 items dans un menu. Cela nous laisse un item de plus qu'indiqué dans l'expression des besoins.


******

## Conclusion

Ce projet nous a amené à réfléchir sur l'architecture globale d'une base de données relationnelle. Nous avons en effet dû répondre à un certains nombre de questions pour mettre en place concrètement une architecture qui nous permette par la suite de répondre aux différentes questions qui nous étaient posées. Il s'agit souvent de faire un arbitrage entre la complexité du modèle de données, la flexibilité offerte par un tel modèle, et la redondance dans le stockage de l'information. Un modèle plus complexe permet très souvent de faire des requêtes plus simples, mais il implique souvent une redondance dans le stockage de données. Au final, nous avons essayé de rester le plus proche possible des concepts concrets décrits par notre modèle de données, afin que celui ci soit plus facilement compréhensible.
