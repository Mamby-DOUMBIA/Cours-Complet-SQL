-- ============================================================
-- CORRIGÉS — Exercices Avancés ex51 à ex60
-- ============================================================

-- EX51 — Déduplication avec ROW_NUMBER
WITH ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY email ORDER BY client_id) AS rn
    FROM clients
)
SELECT client_id, nom, prenom, email, ville
FROM ranked WHERE rn = 1;

-- EX52 — Top 2 produits par catégorie
WITH ranked_products AS (
    SELECT
        p.nom,
        p.prix,
        c.nom AS categorie,
        RANK() OVER (PARTITION BY p.categorie_id ORDER BY p.prix DESC) AS rnk
    FROM produits p
    JOIN categories c ON p.categorie_id = c.categorie_id
)
SELECT categorie, nom, prix
FROM ranked_products
WHERE rnk <= 2
ORDER BY categorie, rnk;

-- EX53 — Somme cumulative + % CA
WITH ca_par_jour AS (
    SELECT
        DATE(date_commande) AS jour,
        SUM(montant_total)  AS ca_jour
    FROM commandes
    WHERE statut = 'livree'
    GROUP BY DATE(date_commande)
)
SELECT
    jour,
    ROUND(ca_jour, 2)                                                   AS ca_jour,
    ROUND(SUM(ca_jour) OVER (ORDER BY jour), 2)                         AS ca_cumulatif,
    ROUND(SUM(ca_jour) OVER (ORDER BY jour) /
          SUM(ca_jour) OVER () * 100, 1)                                AS pct_ca_total
FROM ca_par_jour
ORDER BY jour;

-- EX54 — Variation mensuelle avec LAG
WITH ca_mensuel AS (
    SELECT
        DATE_FORMAT(date_commande, '%Y-%m')  AS mois,
        SUM(montant_total)                   AS ca
    FROM commandes
    WHERE statut = 'livree'
    GROUP BY DATE_FORMAT(date_commande, '%Y-%m')
)
SELECT
    mois,
    ROUND(ca, 2)                                                          AS ca,
    ROUND(LAG(ca) OVER (ORDER BY mois), 2)                               AS ca_precedent,
    ROUND((ca - LAG(ca) OVER (ORDER BY mois))
          / NULLIF(LAG(ca) OVER (ORDER BY mois), 0) * 100, 1)           AS variation_pct
FROM ca_mensuel
ORDER BY mois;

-- EX55 — CTE récursive hiérarchie catégories
WITH RECURSIVE arbre AS (
    SELECT
        categorie_id,
        nom,
        categorie_parent_id,
        0 AS niveau,
        CAST(nom AS CHAR(500)) AS chemin
    FROM categories
    WHERE categorie_parent_id IS NULL

    UNION ALL

    SELECT
        c.categorie_id,
        c.nom,
        c.categorie_parent_id,
        a.niveau + 1,
        CONCAT(a.chemin, ' > ', c.nom)
    FROM categories c
    JOIN arbre a ON c.categorie_parent_id = a.categorie_id
)
SELECT
    CONCAT(REPEAT('  ', niveau), nom) AS arborescence,
    chemin,
    niveau
FROM arbre
ORDER BY chemin;

-- EX56 — Analyse RFM
WITH rfm_raw AS (
    SELECT
        c.client_id,
        CONCAT(c.prenom, ' ', c.nom) AS client,
        DATEDIFF(NOW(), MAX(co.date_commande)) AS recence,
        COUNT(co.commande_id)                  AS frequence,
        COALESCE(SUM(co.montant_total), 0)     AS monetaire
    FROM clients c
    LEFT JOIN commandes co ON c.client_id = co.client_id AND co.statut = 'livree'
    GROUP BY c.client_id, c.prenom, c.nom
),
rfm_scores AS (
    SELECT *,
        NTILE(5) OVER (ORDER BY recence DESC)   AS score_r,
        NTILE(5) OVER (ORDER BY frequence)      AS score_f,
        NTILE(5) OVER (ORDER BY monetaire)      AS score_m
    FROM rfm_raw
)
SELECT
    client,
    recence,
    frequence,
    ROUND(monetaire, 2)  AS monetaire,
    score_r, score_f, score_m,
    CASE
        WHEN score_r >= 4 AND score_f >= 4 AND score_m >= 4 THEN 'Champions'
        WHEN score_r >= 3 AND score_f >= 3                  THEN 'Fidèles'
        WHEN score_r >= 4 AND score_f <= 2                  THEN 'Nouveaux'
        WHEN score_r <= 2 AND score_f >= 3                  THEN 'À risque'
        ELSE                                                     'Inactifs'
    END AS segment
FROM rfm_scores
ORDER BY score_m DESC, score_f DESC;

-- EX57 — PIVOT CA mensuel par catégorie principale
SELECT
    c.nom AS categorie,
    ROUND(SUM(CASE WHEN MONTH(co.date_commande)=1  THEN lc.quantite*lc.prix_unitaire END),0) AS Jan,
    ROUND(SUM(CASE WHEN MONTH(co.date_commande)=2  THEN lc.quantite*lc.prix_unitaire END),0) AS Fev,
    ROUND(SUM(CASE WHEN MONTH(co.date_commande)=3  THEN lc.quantite*lc.prix_unitaire END),0) AS Mar,
    ROUND(SUM(CASE WHEN MONTH(co.date_commande)=4  THEN lc.quantite*lc.prix_unitaire END),0) AS Avr,
    ROUND(SUM(CASE WHEN MONTH(co.date_commande)=5  THEN lc.quantite*lc.prix_unitaire END),0) AS Mai,
    ROUND(SUM(CASE WHEN MONTH(co.date_commande)=6  THEN lc.quantite*lc.prix_unitaire END),0) AS Jun,
    ROUND(SUM(CASE WHEN MONTH(co.date_commande)=7  THEN lc.quantite*lc.prix_unitaire END),0) AS Jul,
    ROUND(SUM(CASE WHEN MONTH(co.date_commande)=8  THEN lc.quantite*lc.prix_unitaire END),0) AS Aou,
    ROUND(SUM(CASE WHEN MONTH(co.date_commande)=9  THEN lc.quantite*lc.prix_unitaire END),0) AS Sep,
    ROUND(SUM(CASE WHEN MONTH(co.date_commande)=10 THEN lc.quantite*lc.prix_unitaire END),0) AS Oct,
    ROUND(SUM(CASE WHEN MONTH(co.date_commande)=11 THEN lc.quantite*lc.prix_unitaire END),0) AS Nov,
    ROUND(SUM(CASE WHEN MONTH(co.date_commande)=12 THEN lc.quantite*lc.prix_unitaire END),0) AS Dec
FROM categories c
JOIN produits p  ON p.categorie_id = c.categorie_id
JOIN lignes_commande lc ON lc.produit_id = p.produit_id
JOIN commandes co ON co.commande_id = lc.commande_id
WHERE c.categorie_parent_id IS NULL
  AND co.statut = 'livree'
GROUP BY c.categorie_id, c.nom
ORDER BY c.nom;

-- EX58 — Optimisation
-- Requête optimisée :
SELECT
    c.client_id,
    c.nom,
    c.email,
    SUM(co.montant_total) AS ca
FROM clients c
JOIN commandes co ON c.client_id = co.client_id
WHERE co.date_commande BETWEEN '2023-01-01' AND '2023-12-31 23:59:59'  -- Évite YEAR()
  AND co.statut = 'livree'
  AND c.pays = 'France'
GROUP BY c.client_id, c.nom, c.email
HAVING SUM(co.montant_total) > 500
ORDER BY ca DESC;

-- Index recommandés :
-- CREATE INDEX idx_cmd_statut_date ON commandes(statut, date_commande) INCLUDE (client_id, montant_total);
-- CREATE INDEX idx_clients_pays    ON clients(pays, client_id);
