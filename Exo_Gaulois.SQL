-- 1) Nom des lieux qui finissent par 'um'
SELECT nom_lieu
FROM lieu
WHERE nom_lieu
LIKE '%um';

--  2) Nombre de personnages par lieu (trié par nombre de personnages décroissant)
SELECT nom_lieu,
	COUNT(id_personnage)
FROM personnage
INNER JOIN lieu
	ON personnage.id_lieu = lieu.id_lieu
GROUP BY lieu.id_lieu
ORDER BY COUNT(lieu.id_lieu) DESC

-- 3) Nom des personnages + spécialité + adresse et lieu d'habitation, triés par lieu puis par nom de personnage
SELECT nom_personnage, nom_specialite, adresse_personnage, nom_lieu
FROM personnage
INNER JOIN specialite ON personnage.id_specialite = specialite.id_specialite
INNER JOIN lieu ON personnage.id_lieu = lieu.id_lieu
ORDER BY lieu.nom_lieu, personnage.nom_personnage;

-- 4) Nom des spécialités avec nombre de personnages par spécialité (trié par nombre de personnages décroissant)
SELECT nom_specialite, COUNT(id_personnage)
FROM specialite
INNER JOIN personnage ON specialite.id_specialite = personnage.id_specialite
GROUP BY specialite.id_specialite
ORDER BY COUNT(id_personnage) DESC;

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
ORDER BY cout_potion;

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
ORDER BY casques_pris DESC;

-- 9) Nom des personnages et leur quantité de potion bue (en les classant du plus grand buveur au plus petit)
SELECT nom_personnage, SUM(dose_boire) AS potion_bue
FROM personnage
INNER JOIN boire ON personnage.id_personnage = boire.id_personnage
GROUP BY personnage.id_personnage
ORDER BY potion_bue DESC;