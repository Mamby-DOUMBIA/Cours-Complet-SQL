-- ============================================================
-- EXERCICES DÉBUTANT — ex01 à ex10
-- Base de données : ecommerce_db
-- ============================================================
-- Prérequis : schemas/ecommerce/schema.sql + seed-data.sql
-- Solutions  : solutions/beginner/ex01-10-solutions.sql
-- ============================================================

-- ─────────────────────────────────────────────────────────────
-- EX01 ★☆☆ — SELECT de base
-- ─────────────────────────────────────────────────────────────
-- Affichez tous les clients (toutes les colonnes).
-- Combien y a-t-il de clients dans la table ?

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX02 ★☆☆ — Sélection de colonnes
-- ─────────────────────────────────────────────────────────────
-- Affichez uniquement le prénom, le nom et l'email
-- de tous les clients, dans cet ordre.

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX03 ★☆☆ — Alias de colonnes
-- ─────────────────────────────────────────────────────────────
-- Affichez les colonnes suivantes avec des alias :
--   - nom_complet   : prénom + ' ' + nom
--   - email_contact : email
--   - localisation  : ville

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX04 ★☆☆ — Filtre WHERE simple
-- ─────────────────────────────────────────────────────────────
-- Listez tous les produits dont le prix est supérieur à 500€.
-- Affichez : référence, nom, prix.

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX05 ★☆☆ — Filtre WHERE avec BETWEEN
-- ─────────────────────────────────────────────────────────────
-- Trouvez les produits dont le prix est compris
-- entre 100€ et 500€ inclus.

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX06 ★☆☆ — Filtre WHERE avec IN
-- ─────────────────────────────────────────────────────────────
-- Listez les clients qui habitent à Paris, Lyon ou Marseille.
-- Affichez : prénom, nom, ville.

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX07 ★☆☆ — Filtre LIKE
-- ─────────────────────────────────────────────────────────────
-- Trouvez tous les produits dont le nom contient le mot
-- 'Pro' (peu importe la casse).
-- Affichez : référence, nom, prix.

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX08 ★☆☆ — ORDER BY
-- ─────────────────────────────────────────────────────────────
-- Listez tous les produits triés par prix décroissant.
-- En cas d'égalité de prix, triez par nom alphabétiquement.

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX09 ★☆☆ — LIMIT et pagination
-- ─────────────────────────────────────────────────────────────
-- Affichez les 5 produits les moins chers disponibles
-- (stock > 0), du moins cher au plus cher.

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX10 ★☆☆ — IS NULL / IS NOT NULL
-- ─────────────────────────────────────────────────────────────
-- Trouvez les clients qui n'ont pas de numéro de téléphone
-- enregistré. Affichez leur nom complet et email.

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX11 ★★☆ — DISTINCT
-- ─────────────────────────────────────────────────────────────
-- Listez toutes les villes distinctes dans lesquelles
-- se trouvent des clients, triées alphabétiquement.

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX12 ★★☆ — Combinaison AND / OR
-- ─────────────────────────────────────────────────────────────
-- Trouvez les produits qui sont soit :
--   - Dans la catégorie 4 (Smartphones) avec un prix < 1000€
--   - Dans la catégorie 6 (Audio) avec un stock > 50
-- Affichez : nom, prix, stock, categorie_id

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX13 ★★☆ — NOT IN
-- ─────────────────────────────────────────────────────────────
-- Listez les commandes qui ne sont ni 'livree' ni 'annulee'.
-- Affichez : commande_id, client_id, statut, date_commande.

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX14 ★★☆ — COUNT simple
-- ─────────────────────────────────────────────────────────────
-- Comptez le nombre total de produits, le nombre de produits
-- actifs, et le nombre de produits en rupture de stock.
-- (tout dans une seule requête)

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX15 ★★☆ — SUM, AVG, MIN, MAX
-- ─────────────────────────────────────────────────────────────
-- Calculez, pour l'ensemble des commandes livrées :
--   - Le nombre de commandes
--   - Le chiffre d'affaires total
--   - Le montant moyen d'une commande
--   - La commande la moins chère
--   - La commande la plus chère

-- Votre réponse :

