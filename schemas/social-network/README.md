# 📱 Schéma Réseau Social

Modélisation d'une plateforme sociale type Instagram/Twitter.

## Tables

| Table | Description |
|-------|-------------|
| `utilisateurs` | Comptes utilisateurs |
| `publications` | Posts et reposts |
| `commentaires` | Commentaires sur les posts |
| `likes` | Likes (clé composite user+post) |
| `abonnements` | Relations suiveur/suivi |
| `hashtags` | Index des hashtags |
| `post_hashtags` | Association post↔hashtag |

## Particularités

- `likes` : clé primaire composite `(user_id, post_id)` → empêche les double-likes
- `abonnements` : contrainte `CHECK (suiveur_id <> suivi_id)` → on ne peut pas se suivre soi-même
- `publications` : `post_parent_id` → permet les reposts/citations
