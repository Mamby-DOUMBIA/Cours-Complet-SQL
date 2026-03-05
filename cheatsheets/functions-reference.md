# 🔧 Référence des Fonctions SQL

## Fonctions de Chaînes

| MySQL | PostgreSQL | SQL Server | Description |
|-------|-----------|------------|-------------|
| `CONCAT(a,b)` | `a \|\| b` | `CONCAT(a,b)` | Concaténation |
| `LENGTH(s)` | `LENGTH(s)` | `LEN(s)` | Longueur (chars) |
| `UPPER(s)` | `UPPER(s)` | `UPPER(s)` | Majuscules |
| `LOWER(s)` | `LOWER(s)` | `LOWER(s)` | Minuscules |
| `TRIM(s)` | `TRIM(s)` | `TRIM(s)` | Supprimer espaces |
| `LTRIM(s)` | `LTRIM(s)` | `LTRIM(s)` | Espaces gauche |
| `RTRIM(s)` | `RTRIM(s)` | `RTRIM(s)` | Espaces droite |
| `SUBSTRING(s,p,n)` | `SUBSTR(s,p,n)` | `SUBSTRING(s,p,n)` | Sous-chaîne |
| `REPLACE(s,a,b)` | `REPLACE(s,a,b)` | `REPLACE(s,a,b)` | Remplacement |
| `INSTR(s,sub)` | `POSITION(sub IN s)` | `CHARINDEX(sub,s)` | Position |
| `LPAD(s,n,c)` | `LPAD(s,n,c)` | — | Padding gauche |
| `RPAD(s,n,c)` | `RPAD(s,n,c)` | — | Padding droite |
| `REVERSE(s)` | `REVERSE(s)` | `REVERSE(s)` | Inverser |
| `GROUP_CONCAT(s)` | `STRING_AGG(s,',')` | `STRING_AGG(s,',')` | Agrégation texte |
| `REGEXP_REPLACE()` | `REGEXP_REPLACE()` | — | Regex replace |

## Fonctions Numériques

| Fonction | Description | Exemple |
|----------|-------------|---------|
| `ROUND(n, d)` | Arrondir à d décimales | `ROUND(3.145, 2)` → 3.15 |
| `FLOOR(n)` | Arrondir vers le bas | `FLOOR(3.9)` → 3 |
| `CEIL(n)` | Arrondir vers le haut | `CEIL(3.1)` → 4 |
| `ABS(n)` | Valeur absolue | `ABS(-5)` → 5 |
| `MOD(a,b)` | Modulo | `MOD(10,3)` → 1 |
| `POWER(n,e)` | Puissance | `POWER(2,10)` → 1024 |
| `SQRT(n)` | Racine carrée | `SQRT(16)` → 4 |
| `RAND()` | Nombre aléatoire 0-1 | — |
| `TRUNCATE(n,d)` / `TRUNC()` | Tronquer | `TRUNCATE(3.99,1)` → 3.9 |

## Fonctions de Dates

```sql
-- Date et heure actuelles
NOW()              -- MySQL/PG : date + heure
CURRENT_TIMESTAMP  -- Standard SQL
GETDATE()          -- SQL Server
CURDATE()          -- MySQL : date seule
CURRENT_DATE       -- PG : date seule

-- Extraire des composantes
YEAR(d)            -- MySQL/SQL Server
EXTRACT(YEAR FROM d)  -- Standard SQL/PG
MONTH(d) | DAY(d) | HOUR(d) | MINUTE(d)
DAYNAME(d)         -- MySQL : 'Monday', 'Tuesday'...
TO_CHAR(d, 'Day')  -- PostgreSQL

-- Arithmétique de dates
DATE_ADD(d, INTERVAL 7 DAY)          -- MySQL
d + INTERVAL '7 days'                -- PostgreSQL
DATEADD(DAY, 7, d)                   -- SQL Server
DATEDIFF(d2, d1)                     -- MySQL (jours entre d1 et d2)
d2 - d1                              -- PostgreSQL (retourne INTERVAL)
DATEDIFF(DAY, d1, d2)                -- SQL Server

-- Formater
DATE_FORMAT(d, '%d/%m/%Y')           -- MySQL
TO_CHAR(d, 'DD/MM/YYYY')             -- PostgreSQL
FORMAT(d, 'dd/MM/yyyy', 'fr-FR')     -- SQL Server

-- Tronquer
DATE_TRUNC('month', d)               -- PostgreSQL
DATE_FORMAT(d, '%Y-%m-01')           -- MySQL simulation
DATETRUNC('month', d)                -- SQL Server 2022+
```

## Fonctions de Conversion

```sql
-- Convertir des types
CAST(valeur AS type)              -- Standard SQL (tous)
CONVERT(valeur, type)             -- MySQL
CONVERT(type, valeur)             -- SQL Server

-- Exemples
CAST('2024-01-15' AS DATE)
CAST(prix AS CHAR)
CAST('123' AS INT)

-- NULL handling
COALESCE(col, 'défaut')           -- Première valeur non-NULL
NULLIF(a, b)                      -- NULL si a = b
ISNULL(col, 'défaut')             -- SQL Server
IFNULL(col, 'défaut')             -- MySQL
```
