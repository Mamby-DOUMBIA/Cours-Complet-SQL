-- ============================================================
-- EXERCICES AVANCÉS — ex51 à ex70
-- Base de données : ecommerce_db
-- ============================================================

-- ─────────────────────────────────────────────────────────────
-- EX51 ★★★ — ROW_NUMBER et déduplication
-- ─────────────────────────────────────────────────────────────
-- La table contient parfois des doublons d'email clients.
-- Écrivez une requête qui garde seulement la première
-- inscription par email (client_id le plus petit).

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX52 ★★★ — RANK et classement
-- ─────────────────────────────────────────────────────────────
-- Pour chaque catégorie, classez les produits par prix décroissant.
-- Affichez les 2 produits les plus chers de chaque catégorie.

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX53 ★★★ — SUM cumulatif
-- ─────────────────────────────────────────────────────────────
-- Calculez la somme cumulative du chiffre d'affaires
-- par date de commande (commandes livrées uniquement).
-- Affichez aussi le % du CA total atteint.

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX54 ★★★ — LAG et variation
-- ─────────────────────────────────────────────────────────────
-- Par mois, calculez le CA mensuel et la variation
-- en % par rapport au mois précédent.
-- (Utiliser LAG)

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX55 ★★★★ — CTE récursive : hiérarchie
-- ─────────────────────────────────────────────────────────────
-- Affichez l'arborescence complète des catégories
-- avec le niveau d'imbrication et le chemin complet.
-- Exemple : "Électronique > Smartphones"

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX56 ★★★★ — Analyse RFM
-- ─────────────────────────────────────────────────────────────
-- Calculez le score RFM (Récence, Fréquence, Monétaire) pour
-- chaque client actif, et segmentez-les en : Champions,
-- Fidèles, À risque, Inactifs.

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX57 ★★★★ — PIVOT mensuel
-- ─────────────────────────────────────────────────────────────
-- Créez un tableau croisé du CA mensuel par catégorie principale
-- (colonnes : Jan, Fev, Mar, Avr, Mai, Jun, Jul, Aou, Sep, Oct, Nov, Dec)

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX58 ★★★★ — Optimisation
-- ─────────────────────────────────────────────────────────────
-- La requête suivante est lente. Analysez-la avec EXPLAIN
-- et proposez les index optimaux :
--
-- SELECT c.nom, c.email, SUM(co.montant_total) AS ca
-- FROM clients c
-- JOIN commandes co ON c.client_id = co.client_id
-- WHERE YEAR(co.date_commande) = 2023
--   AND co.statut = 'livree'
--   AND c.pays = 'France'
-- GROUP BY c.client_id
-- HAVING SUM(co.montant_total) > 500;
--
-- Réécrivez la requête ET proposez les CREATE INDEX.

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX59 ★★★★ — Détection de fraude
-- ─────────────────────────────────────────────────────────────
-- Dans la base banking_db, identifiez les comptes suspects :
-- ceux ayant plus de 5 transactions dans la même heure,
-- ou une transaction supérieure à 3x la moyenne du compte.

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX60 ★★★★ — Analyse de cohorte
-- ─────────────────────────────────────────────────────────────
-- Calculez le taux de rétention mensuelle par cohorte
-- (mois d'inscription). Une cohorte est "retenue" si le client
-- a passé au moins une commande dans le mois considéré.

-- Votre réponse :

