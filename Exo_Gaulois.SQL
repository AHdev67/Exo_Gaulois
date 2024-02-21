-- 1) Nom des lieux qui finissent par 'um'
SELECT nom_lieu
FROM lieu
WHERE nom_lieu LIKE '%um';

--  2) Nombre de personnages par lieu (trié par nombre de personnages décroissant)
SELECT nom_lieu, COUNT(id_personnage) AS nb_personnages
FROM personnage
INNER JOIN lieu
	ON personnage.id_lieu = lieu.id_lieu
GROUP BY lieu.id_lieu
ORDER BY nb_personnages DESC

-- 3) Nom des personnages + spécialité + adresse et lieu d'habitation, triés par lieu puis par nom de personnage
SELECT nom_personnage, nom_specialite, adresse_personnage, nom_lieu
FROM personnage
INNER JOIN specialite ON personnage.id_specialite = specialite.id_specialite
INNER JOIN lieu ON personnage.id_lieu = lieu.id_lieu
ORDER BY lieu.nom_lieu, personnage.nom_personnage;

-- 4) Nom des spécialités avec nombre de personnages par spécialité (trié par nombre de personnages décroissant)
SELECT nom_specialite, COUNT(id_personnage) AS nb_personnages
FROM specialite
INNER JOIN personnage ON specialite.id_specialite = personnage.id_specialite
GROUP BY specialite.id_specialite
ORDER BY nb_personnages DESC;

-- 5) Nom, date et lieu des batailles, classées de la plus récente à la plus ancienne (dates affichées au format jj/mm/aaaa)
SELECT nom_bataille, DATE_FORMAT(date_bataille, "%d/%m/%Y"), lieu.nom_lieu
FROM bataille
INNER JOIN lieu ON bataille.id_lieu = lieu.id_lieu
ORDER BY date_bataille;

-- 6) Nom des potions + coût de réalisation de la potion (trié par coût décroissant)
SELECT nom_potion, SUM(qte * cout_ingredient) AS cout_potion
FROM potion
INNER JOIN composer ON potion.id_potion = composer.id_potion
INNER JOIN ingredient ON composer.id_ingredient = ingredient.id_ingredient
GROUP BY potion.id_potion
ORDER BY cout_potion DESC;

-- 7) Nom des ingrédients + coût + quantité de chaque ingrédient qui composent la potion 'Santé'
SELECT nom_ingredient, cout_ingredient, qte
FROM ingredient
INNER JOIN composer ON ingredient.id_ingredient = composer.id_ingredient
INNER JOIN potion ON composer.id_potion = potion.id_potion
WHERE potion.id_potion = 3;

-- 8) Nom du ou des personnages qui ont pris le plus de casques dans la bataille 'Bataille du village gaulois'
SELECT nom_personnage, SUM(prendre_casque.qte) AS casques_pris
FROM personnage
INNER JOIN prendre_casque ON personnage.id_personnage = prendre_casque.id_personnage
INNER JOIN bataille ON prendre_casque.id_bataille = bataille.id_bataille
WHERE prendre_casque.id_bataille = 1
GROUP BY personnage.id_personnage
HAVING casques_pris >= ALL(
	SELECT SUM(prendre_casque.qte)
	FROM personnage
	INNER JOIN prendre_casque ON personnage.id_personnage = prendre_casque.id_personnage
	INNER JOIN bataille ON prendre_casque.id_bataille = bataille.id_bataille
	WHERE prendre_casque.id_bataille = 1
	GROUP BY personnage.id_personnage
)	

-- 9) Nom des personnages et leur quantité de potion bue (en les classant du plus grand buveur au plus petit)
SELECT nom_personnage, SUM(dose_boire) AS potion_bue
FROM personnage
INNER JOIN boire ON personnage.id_personnage = boire.id_personnage
GROUP BY personnage.id_personnage
ORDER BY potion_bue DESC;

-- 10) Nom de la bataille où le nombre de casques pris a été le plus important
SELECT nom_bataille, SUM(prendre_casque.qte) AS casques_pris
FROM bataille
INNER JOIN prendre_casque ON bataille.id_bataille = prendre_casque.id_bataille
GROUP BY bataille.id_bataille
HAVING casques_pris >= ALL(
	SELECT SUM(prendre_casque.qte)
	FROM bataille
	INNER JOIN prendre_casque ON bataille.id_bataille = prendre_casque.id_bataille
	GROUP BY bataille.id_bataille
);

-- 11) Combien existe-t-il de casques de chaque type et quel est leur coût total ? (classés par nombre décroissant)
SELECT nom_type_casque, COUNT(casque.nom_casque) AS qte_type_casque, SUM(cout_casque) AS cout_total
FROM type_casque
INNER JOIN casque ON type_casque.id_type_casque = casque.id_type_casque
GROUP BY type_casque.id_type_casque
ORDER BY qte_type_casque DESC;

-- 12) Nom des potions dont un des ingrédients est le poisson frais
SELECT nom_potion AS potion_poisson
FROM potion
INNER JOIN composer ON potion.id_potion = composer.id_potion
INNER JOIN ingredient ON composer.id_ingredient = ingredient.id_ingredient
WHERE ingredient.id_ingredient = 24;

-- 13) Nom du / des lieu(x) possédant le plus d'habitants, en dehors du village gaulois
SELECT nom_lieu, COUNT(personnage.id_personnage) AS nb_habitants
FROM lieu
INNER JOIN personnage ON lieu.id_lieu = personnage.id_lieu
WHERE NOT lieu.id_lieu = 1
GROUP BY lieu.id_lieu
HAVING nb_habitants >= ALL(
	SELECT COUNT(personnage.id_personnage)
	FROM lieu
	INNER JOIN personnage ON lieu.id_lieu = personnage.id_lieu
	WHERE NOT lieu.id_lieu = 1
	GROUP BY lieu.id_lieu
);

-- 14) Nom des personnages qui n'ont jamais bu aucune potion.
SELECT nom_personnage AS personnages_sobres
FROM personnage p
WHERE NOT EXISTS(SELECT id_personnage FROM boire b WHERE p.id_personnage = b.id_personnage);

-- 15) Nom du / des personnages qui n'ont pas le droit de boire de la potion 'Magique'
SELECT nom_personnage
FROM personnage p
WHERE p.id_personnage NOT IN (
	SELECT id_personnage
	FROM autoriser_boire ab
	WHERE ab.id_potion = 1
);

-- A) Ajoutez le personnage suivant : Champdeblix, agriculteur résidant à la ferme Hantassion de Rotomagus
INSERT INTO personnage (nom_personnage, adresse_personnage, id_lieu, id_specialite)
VALUES ('Champdeblix', 'Ferme Hantassion', 6, 12); 

-- B) Autorisez Bonemine à boire de la potion magique, elle est jalouse d'Iélosubmarine...
INSERT INTO autoriser_boire (id_potion, id_personnage)
VALUES (1, 12);

-- C) Supprimez les casques grecs qui n'ont jamais été pris lors d'une bataille
DELETE FROM casque
WHERE id_type_casque = 2 AND casque.id_casque NOT IN(
	SELECT prendre_casque.id_casque
	FROM prendre_casque
);

-- D) Modifiez l'adresse de Zérozérosix : il a été mis en prison à Condate
UPDATE personnage
SET adresse_personnage = 'prison', id_lieu = 9
WHERE id_personnage = 23;

-- E) La potion 'Soupe' ne doit plus contenir de persil
DELETE FROM composer
WHERE id_potion = 9 AND id_ingredient = 19;

-- F) Obélix s'est trompé : ce sont 42 casques Weisenau, et non Ostrogoths, qu'il a pris lors de la bataille 'Attaque de la banque postale'. Corrigez son erreur !
UPDATE prendre_casque
SET id_casque = 10, qte = 42
WHERE id_personnage = 5 AND id_bataille = 9;