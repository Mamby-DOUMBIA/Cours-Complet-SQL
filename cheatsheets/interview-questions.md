# 💼 50 Questions d'Entretien SQL — Avec Réponses

> Classées par niveau de difficulté. Idéal pour préparer les entretiens techniques.

---

## 🟢 Niveau Débutant (Q1–Q15)

### Q1. Quelle est la différence entre DELETE et TRUNCATE ?

| | DELETE | TRUNCATE |
|---|---|---|
| Filtre WHERE | ✅ Oui | ❌ Non |
| Loggé ligne par ligne | ✅ Oui | ❌ Non |
| Rollback possible | ✅ Oui | Partiel |
| Réinitialise auto-increment | ❌ Non | ✅ Oui |
| Déclenche les triggers | ✅ Oui | ❌ Non |
| Vitesse | Lent | Rapide |

```sql
DELETE FROM logs WHERE date < '2023-01-01';  -- Ciblé, réversible
TRUNCATE TABLE logs;                          -- Tout supprimer, rapide
```

---

### Q2. Différence entre INNER JOIN et LEFT JOIN ?

- **INNER JOIN** : retourne uniquement les lignes qui ont une correspondance **dans les deux tables**.
- **LEFT JOIN** : retourne **toutes les lignes** de la table gauche, et les correspondances (ou NULL) de la table droite.

```sql
-- INNER JOIN : exclut les clients sans commande
SELECT c.nom, co.commande_id FROM clients c INNER JOIN commandes co ON c.client_id = co.client_id;

-- LEFT JOIN : inclut les clients sans commande (commande_id = NULL)
SELECT c.nom, co.commande_id FROM clients c LEFT JOIN commandes co ON c.client_id = co.client_id;
```

---

### Q3. Qu'est-ce qu'une clé primaire ? Une clé étrangère ?

- **Clé primaire** : identifiant unique d'une ligne dans une table. Valeur NOT NULL et unique.
- **Clé étrangère** : colonne qui référence la clé primaire d'une autre table. Garantit l'intégrité référentielle.

---

### Q4. Peut-on utiliser un alias de SELECT dans un WHERE ?

**Non.** L'alias de SELECT n'est pas encore calculé lors de l'exécution du WHERE (ordre logique).

```sql
-- ❌ ERREUR
SELECT prix * 1.2 AS prix_ttc FROM produits WHERE prix_ttc > 100;

-- ✅ CORRECT
SELECT prix * 1.2 AS prix_ttc FROM produits WHERE prix * 1.2 > 100;
-- Ou avec une sous-requête :
SELECT * FROM (SELECT prix * 1.2 AS prix_ttc FROM produits) t WHERE prix_ttc > 100;
```

---

### Q5. Différence entre WHERE et HAVING ?

- **WHERE** : filtre les lignes **avant** le GROUP BY (sur les données brutes).
- **HAVING** : filtre les groupes **après** le GROUP BY (sur les résultats d'agrégation).

```sql
SELECT client_id, SUM(montant) AS total
FROM commandes
WHERE statut = 'livree'          -- Filtre avant regroupement
GROUP BY client_id
HAVING SUM(montant) > 500;       -- Filtre après regroupement
```

---

### Q6. Comment écrire une requête pour trouver les doublons ?

```sql
SELECT email, COUNT(*) AS nb_occurrences
FROM clients
GROUP BY email
HAVING COUNT(*) > 1
ORDER BY nb_occurrences DESC;
```

---

### Q7. Que retourne NULL = NULL en SQL ?

`NULL` — et non `TRUE`. En SQL, NULL n'est jamais égal à quoi que ce soit, pas même à lui-même.
Utilisez `IS NULL` ou `IS NOT NULL`.

```sql
SELECT NULL = NULL;  -- NULL (pas TRUE !)
SELECT NULL IS NULL; -- TRUE ✅
```

---

### Q8. Différence entre CHAR et VARCHAR ?

- **CHAR(n)** : longueur fixe. Complété par des espaces. Légèrement plus rapide pour des colonnes à taille fixe (codes, codes postaux).
- **VARCHAR(n)** : longueur variable. Stocke seulement les caractères saisis + 1-2 octets de longueur.

---

### Q9. Qu'est-ce qu'un index ? Pourquoi est-il important ?

Un index est une structure de données auxiliaire (B-Tree en général) qui accélère la recherche de lignes. Sans index = Full Table Scan (lecture de toutes les lignes). Avec index = accès direct à quelques lignes.

**Coût** : chaque index ralentit légèrement les INSERT/UPDATE/DELETE (maintenance de l'index).

---

### Q10. Comment sélectionner la Nième valeur la plus élevée ?

```sql
-- Option 1 : LIMIT/OFFSET (MySQL/PostgreSQL)
SELECT DISTINCT prix FROM produits ORDER BY prix DESC LIMIT 1 OFFSET 2;  -- 3ème valeur (N=3)

-- Option 2 : Fonctions fenêtres (plus robuste)
SELECT prix FROM (
    SELECT prix, DENSE_RANK() OVER (ORDER BY prix DESC) AS rnk FROM produits
) t WHERE rnk = 3;
```

---

## 🔵 Niveau Intermédiaire (Q16–Q30)

### Q11. Expliquez les propriétés ACID.

| Propriété | Description | Exemple |
|---|---|---|
| **A**tomicité | Tout ou rien | Virement = débit + crédit simultanés |
| **C**ohérence | État valide avant et après | Contraintes toujours respectées |
| **I**solation | Transactions indépendantes | Deux utilisateurs ne se gênent pas |
| **D**urabilité | Persistance après COMMIT | Données sauvées même après crash |

---

### Q12. Différence entre CTE et sous-requête ?

```sql
-- Sous-requête (imbriquée, lisibilité réduite)
SELECT * FROM (SELECT client_id, SUM(montant) AS ca FROM commandes GROUP BY client_id) t
WHERE t.ca > 500;

-- CTE (nommée, réutilisable, lisible)
WITH ca_clients AS (SELECT client_id, SUM(montant) AS ca FROM commandes GROUP BY client_id)
SELECT * FROM ca_clients WHERE ca > 500;
```

**Avantages CTE** : lisibilité, réutilisabilité dans la même requête, récursivité possible.

---

### Q13. Comment fonctionne RANK() vs DENSE_RANK() ?

```
Valeurs : 100, 100, 80, 70, 70, 50

RANK()       : 1, 1, 3, 4, 4, 6   (sauts)
DENSE_RANK() : 1, 1, 2, 3, 3, 4   (sans saut)
ROW_NUMBER() : 1, 2, 3, 4, 5, 6   (toujours unique)
```

---

### Q14. Qu'est-ce qu'une vue matérialisée ?

Une **vue matérialisée** stocke physiquement le résultat de la requête (contrairement à une vue standard qui recalcule à chaque appel). Très performante pour les requêtes analytiques coûteuses.

```sql
-- PostgreSQL
CREATE MATERIALIZED VIEW mv_ventes_mensuelles AS
SELECT DATE_TRUNC('month', date_commande) AS mois, SUM(montant_total) AS ca
FROM commandes WHERE statut = 'livree' GROUP BY 1;

REFRESH MATERIALIZED VIEW mv_ventes_mensuelles;  -- Mettre à jour les données
```

---

### Q15. Différence entre EXISTS et IN ?

- **IN** : évalue toute la sous-requête et compare les valeurs.
- **EXISTS** : s'arrête à la **première** correspondance trouvée (court-circuit).

**EXISTS** est généralement plus rapide pour les sous-requêtes corrélées sur de grands volumes. **Attention** : `NOT IN` avec des NULL dans la sous-requête retourne toujours zéro résultat !

```sql
-- EXISTS (préféré pour grands volumes)
SELECT * FROM clients c WHERE EXISTS (SELECT 1 FROM commandes WHERE client_id = c.client_id);

-- NOT IN risqué si NULL possible :
SELECT * FROM produits WHERE id NOT IN (SELECT produit_id FROM lignes_commande);
-- Si lignes_commande contient un NULL dans produit_id → 0 résultat !

-- NOT EXISTS (sûr)
SELECT * FROM produits p WHERE NOT EXISTS (SELECT 1 FROM lignes_commande WHERE produit_id = p.id);
```

---

## 🟠 Niveau Avancé (Q31–Q45)

### Q16. Comment analyser un plan d'exécution ?

```sql
EXPLAIN SELECT * FROM commandes WHERE statut = 'livree' AND client_id = 1;
```

**Points clés à vérifier :**
- `type = ALL` → Full Table Scan (🔴 mauvais)
- `type = ref` ou `const` → Index utilisé (🟢 bon)
- `key = NULL` → Pas d'index utilisé
- `rows` → Estimation du nombre de lignes examinées
- `Extra: Using filesort` → Tri coûteux sans index

---

### Q17. Qu'est-ce qu'un index couvrant (covering index) ?

Un index couvrant contient **toutes les colonnes** nécessaires à la requête. Le moteur lit uniquement l'index sans accéder à la table principale.

```sql
-- Requête :
SELECT client_id, date_commande, montant_total FROM commandes WHERE statut = 'livree';

-- Index couvrant (contient toutes les colonnes de la requête) :
CREATE INDEX idx_cov ON commandes(statut) INCLUDE (client_id, date_commande, montant_total);
-- PostgreSQL/SQL Server : INCLUDE pour les colonnes non filtrées
-- MySQL : les lister dans l'index composite
```

---

### Q18. Expliquez les niveaux d'isolation des transactions.

| Niveau | Dirty Read | Non-Repeatable Read | Phantom Read |
|---|---|---|---|
| READ UNCOMMITTED | ✅ Possible | ✅ Possible | ✅ Possible |
| READ COMMITTED | ❌ Non | ✅ Possible | ✅ Possible |
| REPEATABLE READ | ❌ Non | ❌ Non | ✅ Possible |
| SERIALIZABLE | ❌ Non | ❌ Non | ❌ Non |

---

### Q19. Comment optimiser une requête lente ?

1. **EXPLAIN / EXPLAIN ANALYZE** → identifier le bottleneck
2. **Ajouter des index** adaptés (sélectivité, composite, couvrant)
3. **Éviter les fonctions sur les colonnes indexées** dans WHERE
4. **Remplacer SELECT *** par des colonnes explicites
5. **Utiliser EXISTS plutôt que IN** pour les sous-requêtes corrélées
6. **Pagination Keyset** au lieu de OFFSET pour les grandes tables
7. **Partitionnement** pour les très grandes tables
8. **Vues matérialisées** pour les rapports récurrents

---

### Q20. Qu'est-ce que le partitionnement de table ?

Diviser une grande table en partitions physiques selon une règle (RANGE, LIST, HASH). Améliore les performances car les requêtes n'accèdent qu'aux partitions pertinentes (partition pruning).

```sql
-- MySQL : partitionnement par année
CREATE TABLE commandes_part (...)
PARTITION BY RANGE (YEAR(date_commande)) (
    PARTITION p2022 VALUES LESS THAN (2023),
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p_futur VALUES LESS THAN MAXVALUE
);
```

---

## 🔴 Questions Pratiques Classiques

### Q21. Trouver les employés qui gagnent plus que leur manager

```sql
SELECT e.nom AS employe, e.salaire, m.nom AS manager, m.salaire AS salaire_manager
FROM employes e JOIN employes m ON e.manager_id = m.id
WHERE e.salaire > m.salaire;
```

### Q22. Afficher le 2ème salaire le plus élevé

```sql
SELECT MAX(salaire) FROM employes WHERE salaire < (SELECT MAX(salaire) FROM employes);
-- Ou plus générique :
SELECT salaire FROM (SELECT salaire, DENSE_RANK() OVER (ORDER BY salaire DESC) AS rnk FROM employes) t WHERE rnk = 2;
```

### Q23. Trouver les transactions consécutives (gaps and islands)

```sql
-- Identifier les groupes de transactions sans interruption
WITH numbered AS (
    SELECT *, ROW_NUMBER() OVER (ORDER BY date_op) AS rn,
    date_op - INTERVAL ROW_NUMBER() OVER (ORDER BY date_op) DAY AS groupe
    FROM transactions
)
SELECT groupe, MIN(date_op) AS debut, MAX(date_op) AS fin, COUNT(*) AS nb_jours
FROM numbered GROUP BY groupe;
```

### Q24. Calculer un taux de rétention

```sql
WITH cohorte AS (SELECT client_id, MIN(DATE_FORMAT(date_cmd,'%Y-%m')) AS mois_0 FROM commandes GROUP BY client_id),
activite  AS (SELECT co.client_id, c.mois_0, DATE_FORMAT(co.date_cmd,'%Y-%m') AS mois_a FROM commandes co JOIN cohorte c ON co.client_id = c.client_id)
SELECT mois_0,
    COUNT(DISTINCT CASE WHEN mois_0 = mois_a THEN client_id END) AS m0,
    COUNT(DISTINCT CASE WHEN PERIOD_DIFF(mois_a, mois_0) = 1 THEN client_id END) AS m1,
    COUNT(DISTINCT CASE WHEN PERIOD_DIFF(mois_a, mois_0) = 3 THEN client_id END) AS m3
FROM activite GROUP BY mois_0 ORDER BY mois_0;
```

### Q25. Détecter les doublons et les supprimer en gardant 1

```sql
-- Identifier
SELECT email, COUNT(*) FROM clients GROUP BY email HAVING COUNT(*) > 1;

-- Supprimer les doublons (garder le plus ancien)
DELETE FROM clients WHERE client_id NOT IN (
    SELECT MIN(client_id) FROM clients GROUP BY email
);
```

---

## 💡 Conseils d'Entretien

1. **Toujours expliquer votre raisonnement** avant d'écrire la requête
2. **Penser aux cas limites** : valeurs NULL, données vides, ex-aequo
3. **Mentionner les performances** : index, complexité, alternatives
4. **Connaître les 3 variantes** (MySQL, PostgreSQL, SQL Server)
5. **Écrire du code lisible** avec indentation et alias clairs
