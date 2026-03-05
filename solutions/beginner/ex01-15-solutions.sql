-- ============================================================
-- CORRIGÉS — Exercices Débutant ex01 à ex15
-- ============================================================

-- EX01 — SELECT de base
SELECT * FROM clients;
-- Réponse : 20 clients

-- EX02 — Sélection de colonnes
SELECT prenom, nom, email
FROM clients;

-- EX03 — Alias de colonnes
SELECT
    CONCAT(prenom, ' ', nom)  AS nom_complet,
    email                      AS email_contact,
    ville                      AS localisation
FROM clients;

-- EX04 — Filtre WHERE simple
SELECT reference, nom, prix
FROM produits
WHERE prix > 500
ORDER BY prix DESC;

-- EX05 — BETWEEN
SELECT reference, nom, prix
FROM produits
WHERE prix BETWEEN 100 AND 500
ORDER BY prix;

-- EX06 — IN
SELECT prenom, nom, ville
FROM clients
WHERE ville IN ('Paris', 'Lyon', 'Marseille')
ORDER BY ville, nom;

-- EX07 — LIKE
SELECT reference, nom, prix
FROM produits
WHERE nom LIKE '%Pro%'
ORDER BY prix DESC;

-- EX08 — ORDER BY multi-colonnes
SELECT nom, prix, stock
FROM produits
ORDER BY prix DESC, nom ASC;

-- EX09 — LIMIT avec filtre
SELECT nom, prix, stock
FROM produits
WHERE stock > 0
ORDER BY prix ASC
LIMIT 5;

-- EX10 — IS NULL
SELECT CONCAT(prenom, ' ', nom) AS nom_complet, email
FROM clients
WHERE telephone IS NULL;

-- EX11 — DISTINCT
SELECT DISTINCT ville
FROM clients
WHERE ville IS NOT NULL
ORDER BY ville;

-- EX12 — AND / OR combinés
SELECT nom, prix, stock, categorie_id
FROM produits
WHERE (categorie_id = 4 AND prix < 1000)
   OR (categorie_id = 6 AND stock > 50)
ORDER BY categorie_id, prix;

-- EX13 — NOT IN
SELECT commande_id, client_id, statut, date_commande
FROM commandes
WHERE statut NOT IN ('livree', 'annulee')
ORDER BY date_commande DESC;

-- EX14 — COUNT multiple
SELECT
    COUNT(*)                            AS total_produits,
    COUNT(CASE WHEN actif = 1 THEN 1 END) AS produits_actifs,
    COUNT(CASE WHEN stock = 0 THEN 1 END) AS en_rupture
FROM produits;

-- EX15 — Agrégats
SELECT
    COUNT(*)                        AS nb_commandes,
    ROUND(SUM(montant_total), 2)    AS ca_total,
    ROUND(AVG(montant_total), 2)    AS panier_moyen,
    MIN(montant_total)              AS min_commande,
    MAX(montant_total)              AS max_commande
FROM commandes
WHERE statut = 'livree';
