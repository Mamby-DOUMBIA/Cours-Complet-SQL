-- ============================================================
-- PROJET 1 — DASHBOARD E-COMMERCE
-- sql-mastery / projects/ecommerce/
-- ============================================================
-- Objectif : construire un tableau de bord analytique complet
-- Base     : ecommerce_db
-- ============================================================

-- ─────────────────────────────────────────────────────────────
-- KPI 1 : Vue d'ensemble globale
-- ─────────────────────────────────────────────────────────────
SELECT
    COUNT(DISTINCT cl.client_id)            AS total_clients,
    COUNT(DISTINCT CASE WHEN co.commande_id IS NOT NULL THEN cl.client_id END) AS clients_actifs,
    COUNT(co.commande_id)                   AS total_commandes,
    COUNT(CASE WHEN co.statut='livree' THEN 1 END)   AS commandes_livrees,
    COUNT(CASE WHEN co.statut='annulee' THEN 1 END)  AS commandes_annulees,
    ROUND(SUM(CASE WHEN co.statut='livree' THEN co.montant_total END), 2) AS ca_total,
    ROUND(AVG(CASE WHEN co.statut='livree' THEN co.montant_total END), 2) AS panier_moyen,
    COUNT(DISTINCT p.produit_id)            AS nb_produits
FROM clients cl
LEFT JOIN commandes co  ON cl.client_id = co.client_id
CROSS JOIN (SELECT COUNT(*) AS nb FROM produits WHERE actif=1) p;

-- ─────────────────────────────────────────────────────────────
-- KPI 2 : CA mensuel avec tendance (12 derniers mois)
-- ─────────────────────────────────────────────────────────────
WITH ca_mois AS (
    SELECT
        DATE_FORMAT(date_commande, '%Y-%m')  AS mois,
        COUNT(*)                             AS nb_commandes,
        SUM(montant_total)                   AS ca
    FROM commandes
    WHERE statut = 'livree'
      AND date_commande >= DATE_SUB(NOW(), INTERVAL 12 MONTH)
    GROUP BY DATE_FORMAT(date_commande, '%Y-%m')
)
SELECT
    mois,
    nb_commandes,
    ROUND(ca, 2)                                                        AS ca,
    ROUND(LAG(ca) OVER (ORDER BY mois), 2)                             AS ca_mois_prec,
    ROUND((ca - LAG(ca) OVER (ORDER BY mois))
          / NULLIF(LAG(ca) OVER (ORDER BY mois), 0) * 100, 1)         AS evolution_pct,
    ROUND(SUM(ca) OVER (ORDER BY mois), 2)                             AS ca_cumulatif
FROM ca_mois
ORDER BY mois;

-- ─────────────────────────────────────────────────────────────
-- KPI 3 : Top 10 produits par revenus
-- ─────────────────────────────────────────────────────────────
SELECT
    p.reference,
    p.nom,
    cat.nom                                 AS categorie,
    SUM(lc.quantite)                        AS unites_vendues,
    ROUND(SUM(lc.quantite * lc.prix_unitaire), 2) AS revenus,
    ROUND(AVG(lc.prix_unitaire), 2)         AS prix_moyen_vente,
    DENSE_RANK() OVER (ORDER BY SUM(lc.quantite * lc.prix_unitaire) DESC) AS rang
FROM produits p
JOIN lignes_commande lc ON p.produit_id  = lc.produit_id
JOIN commandes co       ON lc.commande_id = co.commande_id
LEFT JOIN categories cat ON p.categorie_id = cat.categorie_id
WHERE co.statut = 'livree'
GROUP BY p.produit_id, p.reference, p.nom, cat.nom
ORDER BY revenus DESC
LIMIT 10;

-- ─────────────────────────────────────────────────────────────
-- KPI 4 : Taux de conversion par statut
-- ─────────────────────────────────────────────────────────────
SELECT
    statut,
    COUNT(*)                                AS nb_commandes,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pourcentage
FROM commandes
GROUP BY statut
ORDER BY nb_commandes DESC;

-- ─────────────────────────────────────────────────────────────
-- KPI 5 : Segmentation clients RFM
-- ─────────────────────────────────────────────────────────────
WITH rfm_base AS (
    SELECT
        c.client_id,
        CONCAT(c.prenom, ' ', c.nom)             AS client,
        c.email,
        DATEDIFF(NOW(), MAX(co.date_commande))   AS recence_jours,
        COUNT(co.commande_id)                     AS frequence,
        COALESCE(SUM(co.montant_total), 0)        AS monetaire
    FROM clients c
    LEFT JOIN commandes co ON c.client_id = co.client_id AND co.statut = 'livree'
    GROUP BY c.client_id, c.prenom, c.nom, c.email
),
rfm_scores AS (
    SELECT *,
        NTILE(5) OVER (ORDER BY recence_jours ASC)  AS r_score,
        NTILE(5) OVER (ORDER BY frequence DESC)     AS f_score,
        NTILE(5) OVER (ORDER BY monetaire DESC)     AS m_score
    FROM rfm_base
)
SELECT
    client, email,
    recence_jours, frequence,
    ROUND(monetaire, 2)  AS valeur_totale,
    r_score + f_score + m_score  AS rfm_total,
    CASE
        WHEN r_score + f_score + m_score >= 13 THEN '🏆 Champions'
        WHEN r_score >= 4 AND f_score >= 3      THEN '💛 Fidèles'
        WHEN r_score >= 4 AND f_score <= 2      THEN '🌱 Nouveaux'
        WHEN r_score <= 2 AND f_score >= 3      THEN '⚠️  À risque'
        WHEN r_score <= 2                       THEN '😴 Inactifs'
        ELSE                                         '🔍 À analyser'
    END AS segment_rfm
FROM rfm_scores
ORDER BY rfm_total DESC;

-- ─────────────────────────────────────────────────────────────
-- KPI 6 : Performance par catégorie
-- ─────────────────────────────────────────────────────────────
WITH cat_perf AS (
    SELECT
        c.categorie_id,
        c.nom AS categorie,
        COUNT(DISTINCT p.produit_id) AS nb_produits,
        SUM(lc.quantite)             AS unites_vendues,
        SUM(lc.quantite * lc.prix_unitaire) AS ca
    FROM categories c
    JOIN produits p     ON p.categorie_id  = c.categorie_id
    JOIN lignes_commande lc ON lc.produit_id = p.produit_id
    JOIN commandes co   ON co.commande_id  = lc.commande_id
    WHERE co.statut = 'livree' AND c.categorie_parent_id IS NULL
    GROUP BY c.categorie_id, c.nom
)
SELECT
    categorie,
    nb_produits,
    unites_vendues,
    ROUND(ca, 2) AS ca,
    ROUND(ca / SUM(ca) OVER () * 100, 1) AS pct_ca,
    ROUND(ca / NULLIF(unites_vendues, 0), 2) AS panier_moyen_produit
FROM cat_perf
ORDER BY ca DESC;

-- ─────────────────────────────────────────────────────────────
-- KPI 7 : Analyse de cohorte (rétention mensuelle)
-- ─────────────────────────────────────────────────────────────
WITH premier_achat AS (
    SELECT
        client_id,
        DATE_FORMAT(MIN(date_commande), '%Y-%m') AS cohorte
    FROM commandes WHERE statut = 'livree'
    GROUP BY client_id
),
activite AS (
    SELECT
        co.client_id,
        DATE_FORMAT(co.date_commande, '%Y-%m') AS mois_activite,
        pa.cohorte,
        PERIOD_DIFF(
            PERIOD(YEAR(co.date_commande), MONTH(co.date_commande)),
            PERIOD(SUBSTR(pa.cohorte,1,4), SUBSTR(pa.cohorte,6,2))
        ) AS mois_depuis_entree
    FROM commandes co
    JOIN premier_achat pa ON co.client_id = pa.client_id
    WHERE co.statut = 'livree'
)
SELECT
    cohorte,
    COUNT(DISTINCT CASE WHEN mois_depuis_entree = 0 THEN client_id END) AS m0,
    COUNT(DISTINCT CASE WHEN mois_depuis_entree = 1 THEN client_id END) AS m1,
    COUNT(DISTINCT CASE WHEN mois_depuis_entree = 2 THEN client_id END) AS m2,
    COUNT(DISTINCT CASE WHEN mois_depuis_entree = 3 THEN client_id END) AS m3,
    COUNT(DISTINCT CASE WHEN mois_depuis_entree = 6 THEN client_id END) AS m6
FROM activite
GROUP BY cohorte
ORDER BY cohorte;
