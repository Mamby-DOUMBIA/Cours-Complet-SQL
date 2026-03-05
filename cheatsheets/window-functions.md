# 🪟 Fonctions de Fenêtrage SQL — Référence Complète

## Syntaxe Générale

```sql
fonction_fenetre() OVER (
    [PARTITION BY colonne(s)]   -- Divise en partitions (comme GROUP BY mais sans réduire les lignes)
    [ORDER BY colonne [ASC|DESC]]  -- Ordre à l'intérieur de chaque partition
    [ROWS|RANGE BETWEEN debut AND fin]  -- Définit la fenêtre glissante
)
```

---

## Fonctions de Classement

```sql
SELECT
    nom,
    score,
    -- Numéro unique, jamais de doublons
    ROW_NUMBER() OVER (ORDER BY score DESC)   AS row_num,

    -- Rang avec sauts (1, 1, 3, 4)
    RANK()       OVER (ORDER BY score DESC)   AS rnk,

    -- Rang sans sauts (1, 1, 2, 3)
    DENSE_RANK() OVER (ORDER BY score DESC)   AS dense_rnk,

    -- Divise en 4 groupes égaux (quartiles)
    NTILE(4)     OVER (ORDER BY score DESC)   AS quartile,

    -- Position relative 0.0 → 1.0
    PERCENT_RANK() OVER (ORDER BY score)      AS pct_rank,

    -- Rang cumulatif 0.0 → 1.0
    CUME_DIST()    OVER (ORDER BY score)      AS cume_dist

FROM resultats;
```

### Top N par groupe (pattern très courant)

```sql
WITH ranked AS (
    SELECT *,
           RANK() OVER (PARTITION BY categorie_id ORDER BY ventes DESC) AS rnk
    FROM produits
)
SELECT * FROM ranked WHERE rnk <= 3;  -- Top 3 par catégorie
```

---

## Fonctions Analytiques

### LAG et LEAD — Accéder aux lignes voisines

```sql
SELECT
    date_cmd,
    ca,
    LAG(ca)    OVER (ORDER BY date_cmd)        AS ca_precedent,
    LEAD(ca)   OVER (ORDER BY date_cmd)        AS ca_suivant,
    LAG(ca, 3, 0) OVER (ORDER BY date_cmd)    AS ca_il_y_a_3_jours,
    -- Variation
    ca - LAG(ca) OVER (ORDER BY date_cmd)      AS variation_absolue,
    ROUND((ca - LAG(ca) OVER (ORDER BY date_cmd))
          / NULLIF(LAG(ca) OVER (ORDER BY date_cmd), 0) * 100, 2) AS variation_pct
FROM ventes_journalieres;
```

### FIRST_VALUE et LAST_VALUE

```sql
SELECT
    nom,
    salaire,
    FIRST_VALUE(nom) OVER (PARTITION BY dept ORDER BY salaire DESC)   AS mieux_paye,
    LAST_VALUE(nom)  OVER (
        PARTITION BY dept ORDER BY salaire DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING      -- ⚠️ Important !
    ) AS moins_bien_paye
FROM employes;
```

> ⚠️ `LAST_VALUE` nécessite `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING` sinon il retourne la valeur de la ligne courante.

---

## Fonctions d'Agrégation Fenêtrées

### Somme cumulative (running total)

```sql
SELECT
    date_cmd,
    montant,
    SUM(montant) OVER (ORDER BY date_cmd)  AS total_cumulatif
FROM commandes;
```

### Moyenne glissante sur N dernières lignes

```sql
SELECT
    date_cmd,
    montant,
    -- Moyenne sur les 7 dernières lignes
    AVG(montant) OVER (
        ORDER BY date_cmd
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS moy_glissante_7j,
    -- Moyenne glissante sur 30 jours calendaires
    AVG(montant) OVER (
        ORDER BY date_cmd
        RANGE BETWEEN INTERVAL 30 DAY PRECEDING AND CURRENT ROW
    ) AS moy_30j
FROM commandes;
```

### Total global dans chaque ligne

```sql
SELECT
    nom,
    ventes,
    SUM(ventes) OVER ()                          AS total_global,
    ROUND(ventes / SUM(ventes) OVER () * 100, 1) AS pct_total
FROM produits;
```

---

## Frames : ROWS vs RANGE

```sql
-- ROWS : basé sur le nombre physique de lignes
ROWS BETWEEN 3 PRECEDING AND CURRENT ROW          -- 3 lignes avant + courante
ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING          -- Fenêtre de 3 lignes centrée
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW  -- De la 1ère ligne jusqu'à la courante
ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING  -- De la courante jusqu'à la dernière

-- RANGE : basé sur la valeur de ORDER BY (inclut les ex-aequo)
RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW  -- Par défaut si ORDER BY sans ROWS
RANGE BETWEEN INTERVAL '7' DAY PRECEDING AND CURRENT ROW  -- 7 derniers jours
```

---

## Cas d'Usage Courants

### 1. Numérotation des lignes par groupe

```sql
SELECT *, ROW_NUMBER() OVER (PARTITION BY client_id ORDER BY date_commande) AS num_commande
FROM commandes;
-- → Numéroter les commandes de chaque client (1ère, 2ème, 3ème...)
```

### 2. Déduplication (garder 1 ligne par groupe)

```sql
WITH cte AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY email ORDER BY created_at) AS rn
    FROM clients
)
DELETE FROM clients WHERE client_id IN (SELECT client_id FROM cte WHERE rn > 1);
```

### 3. Classement percentile (scoring)

```sql
SELECT
    client_id,
    ca_total,
    NTILE(10) OVER (ORDER BY ca_total) AS decile,     -- 1 à 10
    NTILE(100) OVER (ORDER BY ca_total) AS percentile  -- 1 à 100
FROM (SELECT client_id, SUM(montant) AS ca_total FROM commandes GROUP BY client_id) t;
```

### 4. Variation YoY (Year over Year)

```sql
WITH ca_annuel AS (
    SELECT YEAR(date_commande) AS annee, SUM(montant_total) AS ca
    FROM commandes GROUP BY YEAR(date_commande)
)
SELECT
    annee, ca,
    LAG(ca) OVER (ORDER BY annee)  AS ca_n1,
    ROUND((ca - LAG(ca) OVER (ORDER BY annee)) / LAG(ca) OVER (ORDER BY annee) * 100, 1) AS yoy_pct
FROM ca_annuel;
```

---

## Compatibilité

| Fonction | MySQL | PostgreSQL | SQL Server |
|---|---|---|---|
| ROW_NUMBER | ✅ 8.0+ | ✅ | ✅ |
| RANK / DENSE_RANK | ✅ 8.0+ | ✅ | ✅ |
| NTILE | ✅ 8.0+ | ✅ | ✅ |
| LAG / LEAD | ✅ 8.0+ | ✅ | ✅ |
| FIRST/LAST_VALUE | ✅ 8.0+ | ✅ | ✅ |
| RANGE INTERVAL | ❌ | ✅ | Partiel |
| SUM() OVER | ✅ 8.0+ | ✅ | ✅ |
