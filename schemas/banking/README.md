# 🏦 Schéma Bancaire

Système de gestion bancaire simplifié. Utilisé pour les exercices sur les transactions et la détection de fraude.

## Tables

| Table | Description |
|-------|-------------|
| `clients_banque` | Titulaires de comptes |
| `comptes` | Comptes bancaires (courant, épargne...) |
| `transactions_bancaires` | Historique de toutes les opérations |
| `cartes_bancaires` | Cartes associées aux comptes |
| `credits` | Crédits en cours |

## Points de sécurité modélisés

- Contrainte `CHECK (solde >= -5000)` → découvert autorisé limité
- `compte_source` et `compte_dest` dans transactions → traçabilité bidirectionnelle
- Statuts de compte : `actif`, `bloque`, `clos`
