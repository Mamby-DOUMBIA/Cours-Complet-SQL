-- ============================================================
-- EXERCICES EXPERT — ex81 à ex90
-- Niveau : Architecte / Senior Engineer
-- ============================================================

-- ─────────────────────────────────────────────────────────────
-- EX81 ★★★★★ — Procédure de commande complète
-- ─────────────────────────────────────────────────────────────
-- Créez une procédure stockée passer_commande_complete qui :
--   1. Vérifie que le client existe
--   2. Vérifie le stock pour chaque produit de la liste
--   3. Crée la commande et les lignes_commande en transaction
--   4. Décrémente les stocks
--   5. Retourne l'ID de commande et le montant total
--   6. Rollback automatique en cas d'erreur

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX82 ★★★★★ — Trigger d'audit complet
-- ─────────────────────────────────────────────────────────────
-- Créez un système d'audit qui enregistre dans une table
-- audit_log toutes les modifications (INSERT/UPDATE/DELETE)
-- sur la table produits, avec : ancien prix, nouveau prix,
-- utilisateur, timestamp.

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX83 ★★★★★ — Vue matérialisée avec rafraîchissement
-- ─────────────────────────────────────────────────────────────
-- (PostgreSQL) Créez une vue matérialisée mv_dashboard_quotidien
-- qui calcule les KPIs du jour. Créez aussi une fonction
-- pour la rafraîchir. Indexez les colonnes principales.

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX84 ★★★★★ — Optimisation d'une requête complexe
-- ─────────────────────────────────────────────────────────────
-- Cette requête prend 30 secondes sur 10M de lignes.
-- Analysez, proposez les index, réécrivez-la :

SELECT
    c.nom, c.email,
    COUNT(DISTINCT co.commande_id) AS nb_commandes,
    SUM(lc.quantite * lc.prix_unitaire) AS ca,
    GROUP_CONCAT(DISTINCT cat.nom) AS categories_achetees,
    MAX(co.date_commande) AS derniere_commande
FROM clients c
LEFT JOIN commandes co ON c.client_id = co.client_id
LEFT JOIN lignes_commande lc ON co.commande_id = lc.commande_id
LEFT JOIN produits p ON lc.produit_id = p.produit_id
LEFT JOIN categories cat ON p.categorie_id = cat.categorie_id
WHERE YEAR(co.date_commande) >= 2023
  AND co.statut NOT IN ('annulee')
GROUP BY c.client_id, c.nom, c.email
HAVING ca > 100
ORDER BY ca DESC;

-- Votre analyse et requête optimisée :


-- ─────────────────────────────────────────────────────────────
-- EX85 ★★★★★ — Détection d'anomalies statistiques
-- ─────────────────────────────────────────────────────────────
-- Identifiez les transactions bancaires anormales en utilisant
-- la règle des 3 écarts-types (z-score > 3 = anomalie).
-- Utilisez les fonctions fenêtres pour calculer moyenne et
-- écart-type par compte.

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX86 ★★★★★ — Graphe d'amis communs
-- ─────────────────────────────────────────────────────────────
-- Dans la base social_db, pour chaque paire d'utilisateurs
-- NON connectés, calculez le nombre d'amis en commun.
-- Recommandez les 5 connexions avec le plus d'amis communs
-- pour l'utilisateur 1.

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX87 ★★★★★ — Schéma de partitionnement
-- ─────────────────────────────────────────────────────────────
-- Concevez une stratégie de partitionnement pour la table
-- evenements (analytics_db) qui contiendra 1 milliard de lignes.
-- Justifiez votre choix et écrivez le DDL complet.

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX88 ★★★★★ — Pipeline ETL SQL
-- ─────────────────────────────────────────────────────────────
-- Créez un pipeline SQL qui :
--   1. Extrait les nouvelles commandes depuis hier
--   2. Les transforme (calcule les métriques)
--   3. Les charge dans la table metriques_journalieres
-- Utilisez des CTE, gestion d'erreurs et idempotence.

-- Votre réponse :

