<div align="center">

<img src="https://img.shields.io/badge/SQL-Mastery-1A3A5C?style=for-the-badge&logo=postgresql&logoColor=white" alt="SQL Mastery"/>

# 🗄️ SQL Mastery — Du Débutant à l'Expert

**Formation SQL professionnelle complète · MySQL · PostgreSQL · SQL Server**

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![MySQL](https://img.shields.io/badge/MySQL-8.0+-4479A1?logo=mysql&logoColor=white)](https://dev.mysql.com/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16+-336791?logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![SQL Server](https://img.shields.io/badge/SQL_Server-2022+-CC2927?logo=microsoftsqlserver&logoColor=white)](https://www.microsoft.com/sql-server)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

</div>

---

## 📋 Table des Matières

- [🎯 Objectifs](#-objectifs)
- [🗺️ Parcours d'apprentissage](#️-parcours-dapprentissage)
- [📁 Structure du Repo](#-structure-du-repo)
- [🚀 Démarrage Rapide](#-démarrage-rapide)
- [📚 Chapitres du Cours](#-chapitres-du-cours)
- [🏋️ Exercices](#️-exercices)
- [🔨 Projets Pratiques](#-projets-pratiques)
- [📝 Aide-Mémoires](#-aide-mémoires)
- [🔗 Ressources](#-ressources)
- [🤝 Contribuer](#-contribuer)

---

## 🎯 Objectifs

À l'issue de cette formation, vous serez capable de :

| Compétence | Niveau |
|---|---|
| 🏗️ Concevoir des bases de données relationnelles normalisées | Expert |
| ✍️ Écrire des requêtes SQL complexes (fenêtres, CTE récursives) | Expert |
| ⚡ Optimiser les performances (index, plans d'exécution) | Avancé |
| 📊 Travailler avec de grands ensembles de données | Avancé |
| 🔐 Gérer les transactions et la concurrence | Avancé |
| 🏢 Concevoir des couches de données backend | Expert |

---

## 🗺️ Parcours d'Apprentissage

```
🟢 DÉBUTANT (Chapitres 1-5)          ⏱️ ~20h
   ├── Introduction aux BDD
   ├── Fondements SQL (SELECT, WHERE, ORDER BY)
   ├── DDL (CREATE, ALTER, DROP)
   ├── DML (INSERT, UPDATE, DELETE)
   └── Fonctions SQL de base

🔵 INTERMÉDIAIRE (Chapitres 6-9)     ⏱️ ~25h
   ├── Jointures (INNER, LEFT, FULL, SELF)
   ├── Sous-requêtes & CTE
   ├── Vues & Indexation
   └── Transactions & ACID

🟠 AVANCÉ (Chapitres 10-12)          ⏱️ ~30h
   ├── Normalisation (1NF → 5NF)
   ├── Fonctions de fenêtrage
   └── Optimisation des performances

🔴 EXPERT (Chapitres 13-15)          ⏱️ ~25h
   ├── Procédures, Fonctions, Triggers
   ├── Projets pratiques complets
   └── Écosystème & Certification
```

---

## 📁 Structure du Repo

```
sql-mastery/
│
├── 📖 README.md                          # Ce fichier
├── 📄 LICENSE
├── 🤝 CONTRIBUTING.md
│
├── 📚 docs/                              # Cours complet
│   ├── 01-introduction-bdd.md
│   ├── 02-fondements-sql.md
│   ├── 03-ddl-definition-donnees.md
│   ├── 04-dml-manipulation-donnees.md
│   ├── 05-fonctions-sql.md
│   ├── 06-jointures.md
│   ├── 07-sous-requetes-cte.md
│   ├── 08-vues-indexation.md
│   ├── 09-transactions-acid.md
│   ├── 10-normalisation.md
│   ├── 11-fonctions-fenetrage.md
│   ├── 12-optimisation-performances.md
│   ├── 13-procedures-triggers.md
│   ├── 14-projets-pratiques.md
│   └── 15-ecosysteme-ressources.md
│
├── 🗂️ schemas/                           # Schémas de BDD réels
│   ├── ecommerce/
│   │   ├── schema.sql
│   │   ├── seed-data.sql
│   │   └── README.md
│   ├── social-network/
│   │   ├── schema.sql
│   │   ├── seed-data.sql
│   │   └── README.md
│   ├── banking/
│   │   ├── schema.sql
│   │   ├── seed-data.sql
│   │   └── README.md
│   └── analytics/
│       ├── schema.sql
│       ├── seed-data.sql
│       └── README.md
│
├── 🏋️ exercises/                         # Exercices par niveau
│   ├── beginner/    (ex01 → ex20)
│   ├── intermediate/ (ex21 → ex50)
│   ├── advanced/    (ex51 → ex80)
│   └── expert/      (ex81 → ex100)
│
├── ✅ solutions/                          # Corrigés détaillés
│   ├── beginner/
│   ├── intermediate/
│   ├── advanced/
│   └── expert/
│
├── 🔨 projects/                          # Projets complets
│   ├── ecommerce/
│   ├── social-network/
│   ├── banking/
│   └── analytics/
│
└── 📝 cheatsheets/                       # Aide-mémoires
    ├── sql-syntax.md
    ├── functions-reference.md
    ├── joins-visual.md
    ├── window-functions.md
    └── interview-questions.md
```

---

## 🚀 Démarrage Rapide

### 1. Cloner le repo

```bash
git clone https://github.com/votre-username/sql-mastery.git
cd sql-mastery
```

### 2. Initialiser la base de données E-Commerce (MySQL)

```bash
mysql -u root -p < schemas/ecommerce/schema.sql
mysql -u root -p ecommerce_db < schemas/ecommerce/seed-data.sql
```

### 3. Initialiser avec PostgreSQL

```bash
createdb sql_mastery
psql -d sql_mastery -f schemas/ecommerce/schema.sql
psql -d sql_mastery -f schemas/ecommerce/seed-data.sql
```

### 4. Initialiser avec SQL Server

```bash
sqlcmd -S localhost -U sa -P YourPassword -i schemas/ecommerce/schema.sql
sqlcmd -S localhost -U sa -P YourPassword -d ecommerce_db -i schemas/ecommerce/seed-data.sql
```

### 5. Vérifier l'installation

```sql
SELECT 'Installation réussie !' AS message,
       COUNT(*) AS nb_clients
FROM clients;
-- Résultat attendu : 20 clients
```

---

## 📚 Chapitres du Cours

| # | Chapitre | Niveau | Sujets couverts |
|---|----------|--------|-----------------|
| [01](docs/01-introduction-bdd.md) | Introduction aux BDD | 🟢 | Modèle relationnel, SGBD, types de BDD |
| [02](docs/02-fondements-sql.md) | Fondements SQL | 🟢 | SELECT, WHERE, ORDER BY, LIMIT |
| [03](docs/03-ddl-definition-donnees.md) | DDL | 🟢 | CREATE TABLE, contraintes, ALTER, DROP |
| [04](docs/04-dml-manipulation-donnees.md) | DML | 🟢 | INSERT, UPDATE, DELETE, UPSERT |
| [05](docs/05-fonctions-sql.md) | Fonctions SQL | 🟢 | Agrégation, chaînes, dates, conditionnelles |
| [06](docs/06-jointures.md) | Jointures | 🔵 | INNER, LEFT, RIGHT, FULL, CROSS, SELF |
| [07](docs/07-sous-requetes-cte.md) | Sous-requêtes & CTE | 🔵 | Sous-requêtes, CTE, CTE récursives |
| [08](docs/08-vues-indexation.md) | Vues & Index | 🔵 | Views, Materialized Views, stratégie d'index |
| [09](docs/09-transactions-acid.md) | Transactions | 🔵 | ACID, COMMIT, ROLLBACK, niveaux d'isolation |
| [10](docs/10-normalisation.md) | Normalisation | 🟠 | 1NF, 2NF, 3NF, BCNF, dénormalisation |
| [11](docs/11-fonctions-fenetrage.md) | Fenêtrage | 🟠 | RANK, LAG/LEAD, sommes cumulatives, PIVOT |
| [12](docs/12-optimisation-performances.md) | Optimisation | 🟠 | EXPLAIN, index couvrants, partitionnement |
| [13](docs/13-procedures-triggers.md) | Objets programmables | 🔴 | Stored Procedures, Functions, Triggers |
| [14](docs/14-projets-pratiques.md) | Projets | 🔴 | Dashboard, RFM, analyses complexes |
| [15](docs/15-ecosysteme-ressources.md) | Écosystème | 🔴 | Outils, certifications, entretiens |

---

## 🏋️ Exercices

### Distribution par niveau

| Niveau | Exercices | Description |
|--------|-----------|-------------|
| 🟢 [Débutant](exercises/beginner/) | ex01–ex15 | SELECT, filtres, tris basiques |
| 🔵 [Intermédiaire](exercises/intermediate/) | ex21–ex30 | Jointures, agrégations, sous-requêtes |
| 🟠 [Avancé](exercises/advanced/) | ex51–ex60 | CTE, fenêtrage, optimisation |
| 🔴 [Expert](exercises/expert/) | ex81–ex88 | Architecture, tuning, projets complets |

### Exemple d'exercice

```sql
-- exercices/intermediate/ex35-top-clients.sql
-- ============================================
-- EXERCICE 35 : Top 5 clients par CA (commandes livrées)
-- Niveau : Intermédiaire
-- Concepts : JOIN, GROUP BY, ORDER BY, LIMIT
-- ============================================

-- Votre réponse ici :
SELECT ...

-- → Voir la solution : solutions/intermediate/ex35-solution.sql
```

---

## 🔨 Projets Pratiques

### 🛒 [Projet 1 — Dashboard E-Commerce](projects/ecommerce/)
> Construire un tableau de bord complet avec KPIs, tendances et segmentation RFM

**Requêtes incluses :** CA mensuel, taux de conversion, top produits, analyse de cohortes

### 📱 [Projet 2 — Réseau Social Analytics](projects/social-network/)
> Analyser les métriques d'engagement d'une plateforme sociale

**Requêtes incluses :** Feed utilisateur, graphe d'abonnements, viralité des posts

### 🏦 [Projet 3 — Système Bancaire](projects/banking/)
> Modéliser et interroger un système de gestion bancaire

**Requêtes incluses :** Virements sécurisés, détection de fraude, reporting réglementaire

### 📊 [Projet 4 — Analytique Avancée](projects/analytics/)
> Requêtes analytiques complexes sur grands volumes

**Requêtes incluses :** Fenêtrage, cohortes, classification ABC, prévisions

---

## 📝 Aide-Mémoires

| Aide-mémoire | Description |
|---|---|
| [📋 Syntaxe SQL](cheatsheets/sql-syntax.md) | Toutes les commandes DDL/DML/DQL |
| [🔧 Fonctions](cheatsheets/functions-reference.md) | Référence complète des fonctions |
| [🔗 Jointures visuelles](cheatsheets/joins-visual.md) | Diagrammes de Venn pour les JOINs |
| [🪟 Fonctions fenêtres](cheatsheets/window-functions.md) | OVER, PARTITION BY, frames |
| [💼 Questions d'entretien](cheatsheets/interview-questions.md) | 50 questions avec réponses |

---

## 🔗 Ressources

### 📖 Documentation Officielle
- 🔵 [Documentation MySQL 8.0](https://dev.mysql.com/doc/refman/8.0/en/)
- 🟢 [Documentation PostgreSQL 16](https://www.postgresql.org/docs/16/)
- 🔴 [Documentation SQL Server 2022](https://docs.microsoft.com/en-us/sql/sql-server/)

### 🛠️ Outils & IDEs
- [DBeaver](https://dbeaver.io/) — IDE universel multi-SGBD (gratuit)
- [MySQL Workbench](https://dev.mysql.com/downloads/workbench/) — IDE officiel MySQL
- [pgAdmin 4](https://www.pgadmin.org/) — Interface graphique PostgreSQL
- [TablePlus](https://tableplus.com/) — Client SQL moderne (Mac/Win/Linux)
- [DataGrip](https://www.jetbrains.com/datagrip/) — IDE JetBrains pour BDD

### 🎮 Plateformes d'Entraînement
- [LeetCode Database](https://leetcode.com/problemset/database/) — Exercices type entretien
- [HackerRank SQL](https://www.hackerrank.com/domains/sql) — Challenges progressifs
- [SQLZoo](https://sqlzoo.net/) — Apprentissage interactif gratuit
- [Mode SQL Tutorial](https://mode.com/sql-tutorial/) — SQL analytique
- [DB Fiddle](https://www.db-fiddle.com/) — Test rapide en ligne
- [SQLFiddle](http://sqlfiddle.com/) — Multi-SGBD en ligne

### 📚 Livres Recommandés
- [SQL: The Complete Reference](https://www.amazon.fr/SQL-Complete-Reference-James-Groff/dp/0071592555) — Groff & Weinberg
- [Learning SQL](https://www.oreilly.com/library/view/learning-sql-3rd/9781492057604/) — Alan Beaulieu (O'Reilly)
- [SQL Antipatterns](https://pragprog.com/titles/bksqla/sql-antipatterns/) — Bill Karwin
- [Database Design for Mere Mortals](https://www.amazon.fr/Database-Design-Mere-Mortals-Hands/dp/0136788041) — Michael Hernandez

### 🏆 Certifications
- [Oracle Database SQL (1Z0-071)](https://education.oracle.com/oracle-database-sql/pexam_1Z0-071)
- [Microsoft DP-900: Azure Data Fundamentals](https://learn.microsoft.com/en-us/certifications/azure-data-fundamentals/)
- [Microsoft DA-100: Data Analyst Associate](https://learn.microsoft.com/en-us/certifications/data-analyst-associate/)
- [Google Professional Data Engineer](https://cloud.google.com/certification/data-engineer)

---

## 🤝 Contribuer

Les contributions sont les bienvenues ! Consultez [CONTRIBUTING.md](CONTRIBUTING.md) pour les guidelines.

### Comment contribuer
1. 🍴 Forkez le repo
2. 🌿 Créez une branche (`git checkout -b feature/ajout-exercices-avances`)
3. ✍️ Committez vos changements (`git commit -m 'feat: ajouter exercices fenêtrage'`)
4. 📤 Pushez (`git push origin feature/ajout-exercices-avances`)
5. 🔁 Ouvrez une Pull Request

---

<div align="center">

**⭐ Si ce repo vous a été utile, n'oubliez pas de lui mettre une étoile !**

Made with ❤️ pour la communauté SQL francophone

</div>
