# 🛒 Schéma E-Commerce

Base de données d'une boutique en ligne complète. Schéma principal utilisé tout au long du cours.

## Tables

| Table | Lignes (seed) | Description |
|-------|--------------|-------------|
| `categories` | 10 | Arborescence de catégories produit |
| `clients` | 20 | Clients inscrits |
| `produits` | 30 | Catalogue produits |
| `commandes` | 30 | Commandes passées |
| `lignes_commande` | 29 | Détail des commandes |
| `avis` | — | Avis clients sur les produits |

## Diagramme ER (simplifié)

```
categories ─────────────── produits
    │                          │
    └── (parent_id self-ref)   │
                               │
clients ──── commandes ──── lignes_commande
```

## Installation rapide

```bash
# MySQL
mysql -u root -p -e "source schemas/ecommerce/schema.sql"
mysql -u root -p ecommerce_db -e "source schemas/ecommerce/seed-data.sql"

# PostgreSQL
psql -d postgres -f schemas/ecommerce/schema.sql
psql -d ecommerce_db -f schemas/ecommerce/seed-data.sql
```
