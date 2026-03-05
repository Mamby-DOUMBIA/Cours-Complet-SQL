# 📋 SQL Syntax — Aide-Mémoire Complet

## Ordre d'écriture vs Ordre d'exécution

```sql
-- ORDRE D'ÉCRITURE (ce que vous tapez) :
SELECT   colonnes
FROM     table
JOIN     autre_table ON condition
WHERE    condition_filtre
GROUP BY colonne(s)
HAVING   condition_agregat
ORDER BY colonne [ASC|DESC]
LIMIT    n OFFSET m;

-- ORDRE D'EXÉCUTION (ce que fait le moteur) :
-- 1. FROM / JOIN  → Assembler les tables
-- 2. WHERE        → Filtrer les lignes
-- 3. GROUP BY     → Regrouper
-- 4. HAVING       → Filtrer les groupes
-- 5. SELECT       → Calculer les colonnes
-- 6. DISTINCT     → Dédupliquer
-- 7. ORDER BY     → Trier
-- 8. LIMIT/OFFSET → Paginer
```

---

## DDL — Data Definition Language

```sql
-- Créer une base
CREATE DATABASE ma_base CHARACTER SET utf8mb4;
USE ma_base;

-- Créer une table
CREATE TABLE IF NOT EXISTS produits (
    id          INT          NOT NULL AUTO_INCREMENT,  -- MySQL
    id          SERIAL,                                -- PostgreSQL
    id          INT IDENTITY(1,1),                     -- SQL Server
    nom         VARCHAR(200) NOT NULL,
    prix        DECIMAL(10,2) NOT NULL DEFAULT 0,
    actif       TINYINT(1)   NOT NULL DEFAULT 1,
    created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_produits PRIMARY KEY (id),
    CONSTRAINT chk_prix    CHECK (prix >= 0)
);

-- Modifier une table
ALTER TABLE produits ADD COLUMN description TEXT;
ALTER TABLE produits MODIFY COLUMN nom VARCHAR(300);     -- MySQL
ALTER TABLE produits ALTER COLUMN nom TYPE VARCHAR(300); -- PostgreSQL
ALTER TABLE produits DROP COLUMN description;
ALTER TABLE produits ADD CONSTRAINT uq_nom UNIQUE (nom);

-- Supprimer
DROP TABLE IF EXISTS ancienne_table;
TRUNCATE TABLE logs;  -- Vider (réinitialise auto-increment)
```

---

## DML — Data Manipulation Language

```sql
-- INSERT
INSERT INTO produits (nom, prix) VALUES ('Produit A', 29.99);
INSERT INTO produits (nom, prix) VALUES ('A', 10), ('B', 20), ('C', 30);

-- INSERT avec sous-requête
INSERT INTO archive SELECT * FROM produits WHERE actif = 0;

-- UPSERT MySQL
INSERT INTO produits (ref, prix) VALUES ('P001', 99)
ON DUPLICATE KEY UPDATE prix = VALUES(prix);

-- UPSERT PostgreSQL
INSERT INTO produits (ref, prix) VALUES ('P001', 99)
ON CONFLICT (ref) DO UPDATE SET prix = EXCLUDED.prix;

-- UPDATE
UPDATE produits SET prix = prix * 0.90 WHERE categorie_id = 1;

-- DELETE
DELETE FROM produits WHERE stock = 0 AND actif = 0;
```

---

## DQL — Interrogation de données

```sql
-- Filtres
WHERE col = 'valeur'
WHERE col <> 'valeur'           -- Différent
WHERE col BETWEEN 10 AND 100    -- Inclusif
WHERE col IN ('a', 'b', 'c')
WHERE col NOT IN (...)
WHERE col LIKE 'A%'             -- Commence par A
WHERE col LIKE '%tion'          -- Finit par tion
WHERE col LIKE '%mot%'          -- Contient mot
WHERE col IS NULL
WHERE col IS NOT NULL

-- Logique booléenne
WHERE (cond1 AND cond2) OR cond3
WHERE NOT cond

-- Tri
ORDER BY col1 ASC, col2 DESC
ORDER BY 2 DESC                 -- Par position (à éviter)

-- Pagination MySQL/PG
LIMIT 10 OFFSET 20

-- Pagination SQL Server
ORDER BY id OFFSET 20 ROWS FETCH NEXT 10 ROWS ONLY
```

---

## JOINs

```sql
-- INNER JOIN : seulement les lignes avec correspondance
SELECT * FROM a INNER JOIN b ON a.id = b.a_id;

-- LEFT JOIN : toutes les lignes de gauche
SELECT * FROM a LEFT JOIN b ON a.id = b.a_id;

-- RIGHT JOIN : toutes les lignes de droite
SELECT * FROM a RIGHT JOIN b ON a.id = b.a_id;

-- FULL OUTER JOIN (PostgreSQL/SQL Server)
SELECT * FROM a FULL OUTER JOIN b ON a.id = b.a_id;

-- CROSS JOIN : produit cartésien
SELECT * FROM couleurs CROSS JOIN tailles;

-- SELF JOIN : table jointe avec elle-même
SELECT e.nom, m.nom AS manager
FROM employes e LEFT JOIN employes m ON e.manager_id = m.id;
```

---

## Agrégation

```sql
-- Fonctions
COUNT(*)            -- Toutes les lignes
COUNT(col)          -- Valeurs non NULL
SUM(col)
AVG(col)
MIN(col) / MAX(col)
GROUP_CONCAT(col ORDER BY col SEPARATOR ',')  -- MySQL
STRING_AGG(col, ',') -- PostgreSQL / SQL Server

-- Groupement
GROUP BY col1, col2
GROUP BY col WITH ROLLUP          -- MySQL (sous-totaux)
GROUP BY ROLLUP(col1, col2)       -- PostgreSQL

-- Filtre sur agrégats
HAVING COUNT(*) > 5
HAVING SUM(montant) > 1000
```

---

## CTE et Sous-requêtes

```sql
-- CTE simple
WITH clients_actifs AS (
    SELECT * FROM clients WHERE actif = 1
)
SELECT * FROM clients_actifs WHERE ville = 'Paris';

-- CTE multiple
WITH
a AS (SELECT ...),
b AS (SELECT ... FROM a)
SELECT * FROM b;

-- CTE récursive
WITH RECURSIVE cte AS (
    SELECT id, nom, parent_id, 0 AS niveau FROM categories WHERE parent_id IS NULL
    UNION ALL
    SELECT c.id, c.nom, c.parent_id, r.niveau + 1
    FROM categories c JOIN cte r ON c.parent_id = r.id
)
SELECT * FROM cte;
```

---

## Fonctions de Fenêtrage

```sql
-- Syntaxe
fonction() OVER (
    [PARTITION BY col]
    [ORDER BY col]
    [ROWS BETWEEN n PRECEDING AND CURRENT ROW]
)

-- Classement
ROW_NUMBER()   -- 1, 2, 3, 4, 5 (toujours unique)
RANK()         -- 1, 2, 2, 4, 5 (sauts en cas d'ex-aequo)
DENSE_RANK()   -- 1, 2, 2, 3, 4 (sans saut)
NTILE(4)       -- Divise en 4 groupes (quartiles)
PERCENT_RANK() -- Position relative 0 à 1

-- Analytiques
SUM(col) OVER (ORDER BY date)                    -- Cumul
AVG(col) OVER (ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)  -- Moyenne glissante
LAG(col, 1, 0) OVER (ORDER BY date)             -- Valeur ligne précédente
LEAD(col, 1) OVER (ORDER BY date)               -- Valeur ligne suivante
FIRST_VALUE(col) OVER (PARTITION BY p ORDER BY date)
LAST_VALUE(col)  OVER (PARTITION BY p ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
```

---

## Fonctions Conditionnelles

```sql
-- CASE WHEN (universel)
CASE WHEN condition1 THEN val1
     WHEN condition2 THEN val2
     ELSE val_defaut
END

-- CASE simple
CASE statut
    WHEN 'actif'   THEN '✅'
    WHEN 'inactif' THEN '❌'
    ELSE '❓'
END

-- COALESCE : première valeur non-NULL
COALESCE(col1, col2, 'défaut')

-- NULLIF : retourne NULL si égalité
NULLIF(valeur, 0)  -- Évite division par zéro

-- IF (MySQL) / IIF (SQL Server)
IF(stock > 0, 'Dispo', 'Rupture')
IIF(stock > 0, 'Dispo', 'Rupture')
```

---

## Transactions

```sql
BEGIN;              -- ou START TRANSACTION;
-- opérations...
COMMIT;             -- Valider
ROLLBACK;           -- Annuler

SAVEPOINT sp1;      -- Point de sauvegarde
ROLLBACK TO sp1;    -- Revenir au savepoint
RELEASE SAVEPOINT sp1;

-- Niveau d'isolation
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- Niveaux : READ UNCOMMITTED | READ COMMITTED | REPEATABLE READ | SERIALIZABLE
```

---

## Différences MySQL / PostgreSQL / SQL Server

| Fonctionnalité | MySQL | PostgreSQL | SQL Server |
|---|---|---|---|
| Auto-incrément | `AUTO_INCREMENT` | `SERIAL` ou `GENERATED` | `IDENTITY(1,1)` |
| Limite | `LIMIT n` | `LIMIT n` | `TOP n` ou `FETCH NEXT n` |
| Date actuelle | `NOW()` | `NOW()` | `GETDATE()` |
| Concaténation | `CONCAT(a,b)` | `a \|\| b` | `CONCAT(a,b)` |
| Texte long | `TEXT` | `TEXT` | `NVARCHAR(MAX)` |
| Booléen | `TINYINT(1)` | `BOOLEAN` | `BIT` |
| Regex | `REGEXP` | `~` | `LIKE` (limité) |
| UPSERT | `ON DUPLICATE KEY` | `ON CONFLICT` | `MERGE` |
| Format date | `DATE_FORMAT()` | `TO_CHAR()` | `FORMAT()` |
| Ajouter jours | `DATE_ADD(d, INTERVAL n DAY)` | `d + INTERVAL 'n day'` | `DATEADD(DAY, n, d)` |
