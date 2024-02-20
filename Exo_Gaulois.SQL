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
