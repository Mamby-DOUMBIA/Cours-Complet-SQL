-- ============================================================
-- CORRIGÉS — Exercices Intermédiaires ex21 à ex30
-- ============================================================

-- EX21 — INNER JOIN basique
SELECT
    co.commande_id,
    CONCAT(c.prenom, ' ', c.nom) AS client,
    co.date_commande,
    co.statut,
    ROUND(co.montant_total, 2) AS montant_total
FROM commandes co
INNER JOIN clients c ON co.client_id = c.client_id
ORDER BY co.date_commande DESC;

-- EX22 — JOIN multiple 3 tables
SELECT
    CONCAT(c.prenom, ' ', c.nom)      AS client,
    co.commande_id,
    p.nom                              AS produit,
    lc.quantite,
    lc.prix_unitaire,
    ROUND(lc.quantite * lc.prix_unitaire, 2) AS sous_total
FROM clients c
INNER JOIN commandes co    ON c.client_id  = co.client_id
INNER JOIN lignes_commande lc ON co.commande_id = lc.commande_id
INNER JOIN produits p      ON lc.produit_id = p.produit_id
WHERE co.statut = 'livree'
ORDER BY co.date_commande DESC, p.nom;

-- EX23 — Clients sans commande (anti-join)
SELECT c.nom, c.prenom, c.email, c.date_creation
FROM clients c
LEFT JOIN commandes co ON c.client_id = co.client_id
WHERE co.commande_id IS NULL
ORDER BY c.nom;

-- EX24 — Statistiques par catégorie (avec LEFT JOIN)
SELECT
    c.nom                           AS categorie,
    COUNT(p.produit_id)             AS nb_produits,
    ROUND(AVG(p.prix), 2)          AS prix_moyen,
    MIN(p.prix)                     AS prix_min,
    MAX(p.prix)                     AS prix_max,
    SUM(p.stock)                    AS stock_total
FROM categories c
LEFT JOIN produits p ON c.categorie_id = p.categorie_id AND p.actif = 1
GROUP BY c.categorie_id, c.nom
ORDER BY nb_produits DESC;

-- EX25 — GROUP BY + HAVING
SELECT
    CONCAT(c.prenom, ' ', c.nom)  AS client,
    COUNT(co.commande_id)          AS nb_commandes,
    ROUND(SUM(co.montant_total), 2) AS ca_total
FROM clients c
INNER JOIN commandes co ON c.client_id = co.client_id
WHERE co.statut = 'livree'
GROUP BY c.client_id, c.prenom, c.nom
HAVING COUNT(co.commande_id) > 2
   AND SUM(co.montant_total) > 1000
ORDER BY ca_total DESC;

-- EX26 — Sous-requête scalaire : écart au prix moyen catégorie
SELECT
    p.nom,
    p.prix,
    c.nom AS categorie,
    ROUND((SELECT AVG(p2.prix) FROM produits p2 WHERE p2.categorie_id = p.categorie_id), 2) AS prix_moy_cat,
    ROUND((p.prix - (SELECT AVG(p2.prix) FROM produits p2 WHERE p2.categorie_id = p.categorie_id))
          / NULLIF((SELECT AVG(p2.prix) FROM produits p2 WHERE p2.categorie_id = p.categorie_id), 0) * 100, 1) AS ecart_pct
FROM produits p
LEFT JOIN categories c ON p.categorie_id = c.categorie_id
ORDER BY ABS(p.prix - (SELECT AVG(p2.prix) FROM produits p2 WHERE p2.categorie_id = p.categorie_id)) DESC;

-- EX27 — Produits jamais commandés
SELECT p.reference, p.nom, p.prix, p.stock
FROM produits p
WHERE NOT EXISTS (
    SELECT 1 FROM lignes_commande lc WHERE lc.produit_id = p.produit_id
)
ORDER BY p.prix DESC;

-- EX28 — CTE : Top 3 produits par CA
WITH ca_produits AS (
    SELECT
        p.produit_id,
        p.nom,
        SUM(lc.quantite * lc.prix_unitaire) AS ca_total
    FROM produits p
    JOIN lignes_commande lc ON p.produit_id = lc.produit_id
    JOIN commandes co ON lc.commande_id = co.commande_id
    WHERE co.statut = 'livree'
    GROUP BY p.produit_id, p.nom
)
SELECT nom, ROUND(ca_total, 2) AS ca_total
FROM ca_produits
ORDER BY ca_total DESC
LIMIT 3;

-- EX29 — SELF JOIN : catégories avec leur parent
SELECT
    c.nom                                           AS categorie,
    COALESCE(parent.nom, '— Racine —')             AS parent
FROM categories c
LEFT JOIN categories parent ON c.categorie_parent_id = parent.categorie_id
ORDER BY parent.nom NULLS FIRST, c.nom;

-- EX30 — CASE WHEN : segmentation produits
SELECT
    nom,
    ROUND(prix, 2) AS prix,
    stock,
    CASE
        WHEN prix < 50   THEN 'Entrée de gamme'
        WHEN prix <= 500 THEN 'Milieu de gamme'
        ELSE                  'Premium'
    END AS segment_prix,
    CASE
        WHEN stock = 0   THEN '🔴 Rupture de stock'
        WHEN stock < 20  THEN '🟡 Stock faible'
        ELSE                  '🟢 Disponible'
    END AS statut_stock
FROM produits
WHERE actif = 1
ORDER BY
    CASE WHEN prix < 50 THEN 1 WHEN prix <= 500 THEN 2 ELSE 3 END,
    nom;
