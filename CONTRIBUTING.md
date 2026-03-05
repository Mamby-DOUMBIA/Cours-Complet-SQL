# 🤝 Guide de Contribution

Merci de contribuer à **SQL Mastery** ! Ce projet vit grâce à sa communauté.

## Types de Contributions

- 🐛 **Correction de bugs** : erreur SQL, typo, lien cassé
- ✍️ **Nouveau contenu** : exercices, chapitres, explications
- 🌍 **Traductions** : adapter le contenu pour d'autres langues
- 🛠️ **Améliorations** : reformulations, exemples supplémentaires
- ⭐ **Compatibilité** : adapter les requêtes pour un SGBD manquant

## Conventions SQL

```sql
-- ✅ BIEN : Mots-clés en MAJUSCULES, identifiants en snake_case
SELECT c.client_id, c.nom, SUM(co.montant_total) AS ca_total
FROM clients c
INNER JOIN commandes co ON c.client_id = co.client_id
WHERE co.statut = 'livree'
GROUP BY c.client_id, c.nom
ORDER BY ca_total DESC;

-- ❌ À ÉVITER : mots-clés en minuscules, noms ambigus
select id, n, sum(m) as t from c join o on c.id=o.cid where s='livree' group by 1,2;
```

## Structure des Exercices

Chaque exercice doit contenir :

```sql
-- ─────────────────────────────────────────────────────────────
-- EXnn ★★☆ — Titre de l'exercice
-- ─────────────────────────────────────────────────────────────
-- Description claire du problème.
-- Indiquer les colonnes à afficher et le tri attendu.
-- Compétences : JOIN, GROUP BY, HAVING (liste des concepts)
-- ─────────────────────────────────────────────────────────────

-- Votre réponse :
```

## Pull Request

1. Forkez le repo
2. Créez une branche descriptive : `feat/exercices-triggers` ou `fix/ex23-typo`
3. Testez vos requêtes sur MySQL ET PostgreSQL si possible
4. Mettez à jour les solutions correspondantes
5. Ouvrez la PR avec une description claire

## Code de Conduite

- Respectez tous les contributeurs
- Les critiques constructives sont bienvenues
- Priorisez la clarté pédagogique sur la sophistication technique
