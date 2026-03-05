# 🔗 Jointures SQL — Guide Visuel

## Rappel : Tables d'exemple

```
Table A (clients)          Table B (commandes)
┌────┬────────┐            ┌────┬──────────┬────────────┐
│ id │ nom    │            │ id │ client_id│ montant    │
├────┼────────┤            ├────┼──────────┼────────────┤
│  1 │ Alice  │            │  1 │    1     │   199.00   │
│  2 │ Bob    │            │  2 │    1     │   349.00   │
│  3 │ Claire │            │  3 │    2     │    59.99   │
│  4 │ David  │            │  4 │    5     │   999.00   │
└────┴────────┘            └────┴──────────┴────────────┘
(David et Claire n'ont pas de commande ; commande 4 → client inexistant)
```

---

## INNER JOIN

```
    A ∩ B
  ╔═══╗
  ║ A ║B║
  ╚═══╝
```

> Retourne seulement les lignes qui ont une correspondance dans **les deux** tables.

```sql
SELECT c.nom, co.montant
FROM clients c
INNER JOIN commandes co ON c.id = co.client_id;

-- Résultat :
-- nom   | montant
-- ------+---------
-- Alice | 199.00
-- Alice | 349.00
-- Bob   | 59.99
-- (Claire et David exclus — pas de commande)
-- (commande 4 exclue — client 5 inexistant)
```

---

## LEFT JOIN (LEFT OUTER JOIN)

```
  ╔═══════╗
  ║ A  ║B ║
  ╚═══════╝
```

> Toutes les lignes de A + les correspondances de B. NULL si pas de correspondance.

```sql
SELECT c.nom, co.montant
FROM clients c
LEFT JOIN commandes co ON c.id = co.client_id;

-- Résultat :
-- nom    | montant
-- -------+---------
-- Alice  | 199.00
-- Alice  | 349.00
-- Bob    | 59.99
-- Claire | NULL    ← Inclus mais sans commande
-- David  | NULL    ← Inclus mais sans commande
```

### Trouver les lignes SANS correspondance (Anti-JOIN)

```sql
SELECT c.nom
FROM clients c
LEFT JOIN commandes co ON c.id = co.client_id
WHERE co.client_id IS NULL;  -- Clients sans aucune commande

-- Résultat : Claire, David
```

---

## RIGHT JOIN (RIGHT OUTER JOIN)

```
     ╔═══════╗
     ║A ║ B  ║
     ╚═══════╝
```

> Toutes les lignes de B + les correspondances de A. (Peu utilisé — préférer LEFT JOIN en inversant les tables)

```sql
SELECT c.nom, co.montant
FROM clients c
RIGHT JOIN commandes co ON c.id = co.client_id;

-- Résultat :
-- nom   | montant
-- ------+---------
-- Alice | 199.00
-- Alice | 349.00
-- Bob   | 59.99
-- NULL  | 999.00  ← Commande sans client existant
```

---

## FULL OUTER JOIN

```
  ╔═══════════╗
  ║ A  ║  B  ║
  ╚═══════════╝
```

> Toutes les lignes des deux tables. NULL des deux côtés si pas de correspondance.

```sql
-- PostgreSQL / SQL Server
SELECT c.nom, co.montant
FROM clients c
FULL OUTER JOIN commandes co ON c.id = co.client_id;

-- MySQL (pas de FULL OUTER JOIN natif) :
SELECT c.nom, co.montant FROM clients c LEFT  JOIN commandes co ON c.id = co.client_id
UNION
SELECT c.nom, co.montant FROM clients c RIGHT JOIN commandes co ON c.id = co.client_id;

-- Résultat :
-- nom    | montant
-- -------+---------
-- Alice  | 199.00
-- Alice  | 349.00
-- Bob    | 59.99
-- Claire | NULL
-- David  | NULL
-- NULL   | 999.00
```

---

## CROSS JOIN (Produit Cartésien)

> Chaque ligne de A combinée avec chaque ligne de B. Résultat : |A| × |B| lignes.

```sql
-- Générer toutes les combinaisons taille × couleur
SELECT t.nom AS taille, c.nom AS couleur
FROM tailles t CROSS JOIN couleurs c;

-- Si tailles = {S, M, L, XL} et couleurs = {Rouge, Bleu, Vert}
-- Résultat : 4 × 3 = 12 lignes
```

**⚠️ Attention** : sans condition ON, tout JOIN devient implicitement un CROSS JOIN. Sur 2 tables de 10 000 lignes = 100 millions de lignes !

---

## SELF JOIN

> Une table jointe avec elle-même. Utile pour les hiérarchies et comparaisons internes.

```sql
-- Trouver les catégories avec leur parent
SELECT
    enfant.nom           AS categorie,
    COALESCE(parent.nom, 'Racine') AS parent
FROM categories enfant
LEFT JOIN categories parent ON enfant.parent_id = parent.id;

-- Employés avec leur manager
SELECT
    e.nom    AS employe,
    m.nom    AS manager
FROM employes e
LEFT JOIN employes m ON e.manager_id = m.id;
```

---

## Récapitulatif

| JOIN | Lignes de A | Lignes de B | Résultat |
|---|---|---|---|
| INNER | Avec correspondance | Avec correspondance | Intersection |
| LEFT | Toutes | Avec correspondance (+ NULL) | A complet |
| RIGHT | Avec correspondance (+ NULL) | Toutes | B complet |
| FULL OUTER | Toutes | Toutes | Union |
| CROSS | Toutes | Toutes | A × B |

---

## Bonnes Pratiques

```sql
-- ✅ Toujours utiliser des alias de table
SELECT c.nom, co.montant FROM clients c JOIN commandes co ON c.id = co.client_id;

-- ✅ Spécifier explicitement INNER, LEFT, etc.
SELECT ... FROM a INNER JOIN b ON ...;  -- Pas juste JOIN

-- ✅ Attention au filtre ON vs WHERE avec LEFT JOIN
-- ON filtre AVANT le join (conserve toutes les lignes de gauche)
SELECT c.nom, co.montant
FROM clients c
LEFT JOIN commandes co ON c.id = co.client_id
                       AND co.statut = 'livree';  -- Ne retire pas les clients sans commande

-- WHERE filtre APRÈS le join (peut transformer un LEFT en INNER)
SELECT c.nom, co.montant
FROM clients c
LEFT JOIN commandes co ON c.id = co.client_id
WHERE co.statut = 'livree';  -- ⚠️ Exclut les clients sans commande livrée !
```
