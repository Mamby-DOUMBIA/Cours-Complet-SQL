-- ============================================================
-- DONNEES DE TEST — Reseau Social
-- ============================================================

USE social_db;

INSERT INTO utilisateurs (user_id, username, email, nom_affiche, bio, compte_prive)
VALUES
    (1, 'alice_data', 'alice@example.com', 'Alice Data', 'SQL + analytics', 0),
    (2, 'bob_query', 'bob@example.com', 'Bob Query', 'Backend engineer', 0),
    (3, 'carol_db', 'carol@example.com', 'Carol DB', 'Database architect', 1);

INSERT INTO publications (post_id, user_id, contenu, nb_likes, nb_commentaires, nb_partages)
VALUES
    (1, 1, 'Premier post SQL Mastery', 2, 1, 0),
    (2, 2, 'Les CTE recursives changent tout.', 1, 0, 1);

INSERT INTO commentaires (commentaire_id, post_id, user_id, contenu, nb_likes)
VALUES
    (1, 1, 2, 'Super exemple, merci !', 0);

INSERT INTO likes (user_id, post_id)
VALUES
    (2, 1),
    (3, 1),
    (1, 2);

INSERT INTO abonnements (suiveur_id, suivi_id)
VALUES
    (2, 1),
    (3, 1),
    (1, 2);

INSERT INTO hashtags (hashtag_id, tag, nb_posts)
VALUES
    (1, 'sql', 2),
    (2, 'data', 1);

INSERT INTO post_hashtags (post_id, hashtag_id)
VALUES
    (1, 1),
    (2, 1),
    (1, 2);
