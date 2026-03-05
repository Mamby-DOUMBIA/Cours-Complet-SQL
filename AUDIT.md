# Audit Technique — SQL Mastery

Date: 2026-03-05

## Cartographie du projet

- `schemas/`: modeles SQL (ecommerce, social-network, banking, analytics)
- `exercises/`: exercices par niveau
- `solutions/`: corriges associes
- `projects/`: requetes de projets metier
- `cheatsheets/`: references SQL rapides
- `docs/`: chapitres de cours (ajoutes pour coherence des liens)
- `.github/workflows/ci.yml`: lint SQL + validation liens markdown

## Constat principal (avant optimisation)

- Liens markdown internes casses (`docs/` et certains projets absents).
- `ci.yml` referencait `.github/mlc_config.json` absent.
- Dossier parasite avec accolades (`{docs,schemas,...}`) generant des warnings de chemins.
- Ecart entre README et contenu reel (verification `nb_clients`).
- Contraintes/index manquants dans plusieurs schemas, risquant incoherences et perfs degradees.

## Optimisations appliquees

- Nettoyage structurel:
- Suppression du dossier parasite long-path.
- Ajout de `.github/mlc_config.json`.

- Coherence documentaire:
- Creation des 15 fichiers `docs/` references par le README.
- Creation des dossiers projets manquants:
  - `projects/social-network/README.md`
  - `projects/banking/README.md`
  - `projects/analytics/README.md`
- Correction README:
  - attendu installation passe de 50 a 20 clients
  - plages d'exercices alignees sur les fichiers reels

- Jeux de donnees:
- Ajout de `seed-data.sql` pour:
  - `schemas/social-network/`
  - `schemas/banking/`
  - `schemas/analytics/`

- Hardening SQL (integrite/performance):
- `schemas/ecommerce/schema.sql`:
  - checks sur montants/frais
  - unicite avis client+produit
  - index composites commandes/avis
- `schemas/social-network/schema.sql`:
  - checks compteurs >= 0
  - index `likes(post_id, user_id)`
- `schemas/banking/schema.sql`:
  - checks robustes sur transactions/cartes/credits
  - index composites pour requetes frequentes
- `schemas/analytics/schema.sql`:
  - FK `metriques_journalieres.date_id -> dim_date`
  - checks metriques non negatives et `taux_rebond` borne
  - index complementaires session/date et canal/device

## Verification post-optimisation

- Controle des liens markdown: `NO_MISSING_LINKS`.
- Etat du depot pret pour versionnement et publication.
