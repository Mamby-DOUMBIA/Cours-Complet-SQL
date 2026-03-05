-- ============================================================
-- EXERCICES INTERMÉDIAIRE — ex21 à ex40
-- Base de données : ecommerce_db
-- ============================================================

-- ─────────────────────────────────────────────────────────────
-- EX21 ★★☆ — INNER JOIN basique
-- ─────────────────────────────────────────────────────────────
-- Listez toutes les commandes avec le nom du client correspondant.
-- Affichez : commande_id, client (prénom+nom), date_commande, statut, montant_total.
-- Triez par date décroissante.

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX22 ★★☆ — JOIN multiple (3 tables)
-- ─────────────────────────────────────────────────────────────
-- Affichez le détail complet de toutes les commandes livrées :
-- client, produit acheté, quantité, prix unitaire, sous-total.

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX23 ★★☆ — LEFT JOIN : clients sans commande
-- ─────────────────────────────────────────────────────────────
-- Trouvez les clients qui n'ont JAMAIS passé de commande.
-- Affichez leur nom, email et date d'inscription.

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX24 ★★☆ — JOIN + GROUP BY
-- ─────────────────────────────────────────────────────────────
-- Pour chaque catégorie, calculez :
--   - Le nombre de produits
--   - Le prix moyen
--   - Le prix min et max
--   - Le stock total
-- Incluez les catégories sans produits.

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX25 ★★★ — GROUP BY + HAVING
-- ─────────────────────────────────────────────────────────────
-- Trouvez les clients qui ont passé plus de 2 commandes livrées
-- ET dont le total des achats dépasse 1000€.
-- Affichez : client, nb_commandes, ca_total.

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX26 ★★★ — Sous-requête scalaire
-- ─────────────────────────────────────────────────────────────
-- Affichez chaque produit avec son prix ET le prix moyen
-- de sa catégorie, ainsi que l'écart en %.

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX27 ★★★ — Sous-requête avec IN
-- ─────────────────────────────────────────────────────────────
-- Listez les produits qui n'ont jamais été commandés.

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX28 ★★★ — CTE simple
-- ─────────────────────────────────────────────────────────────
-- En utilisant une CTE, trouvez les 3 produits
-- générant le plus de chiffre d'affaires.

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX29 ★★★ — SELF JOIN
-- ─────────────────────────────────────────────────────────────
-- Affichez chaque catégorie avec le nom de sa catégorie parente.
-- Les catégories racines doivent afficher 'Racine' comme parent.

-- Votre réponse :


-- ─────────────────────────────────────────────────────────────
-- EX30 ★★★ — Cas d'utilisation CASE WHEN
-- ─────────────────────────────────────────────────────────────
-- Créez un rapport de produits avec :
--   - nom, prix, stock
--   - Segment prix : 'Entrée de gamme' (<50€), 'Milieu' (50-500€), 'Premium' (>500€)
--   - Statut stock : 'Rupture', 'Stock faible' (<20), 'Disponible'
-- Triez par segment prix puis par nom.

-- Votre réponse :

