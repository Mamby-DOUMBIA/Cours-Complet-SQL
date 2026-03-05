-- ============================================================
-- SCHÉMA RÉSEAU SOCIAL — sql-mastery
-- Compatible : MySQL 8.0+ | PostgreSQL 16+ | SQL Server 2022
-- ============================================================

CREATE DATABASE IF NOT EXISTS social_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE social_db;

CREATE TABLE IF NOT EXISTS utilisateurs (
    user_id         BIGINT          NOT NULL AUTO_INCREMENT,
    username        VARCHAR(50)     NOT NULL,
    email           VARCHAR(255)    NOT NULL,
    nom_affiche     VARCHAR(100)    NOT NULL,
    bio             TEXT            DEFAULT NULL,
    avatar_url      VARCHAR(500)    DEFAULT NULL,
    compte_prive    TINYINT(1)      NOT NULL DEFAULT 0,
    nb_abonnes      INT             NOT NULL DEFAULT 0,
    nb_abonnements  INT             NOT NULL DEFAULT 0,
    date_creation   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_utilisateurs      PRIMARY KEY (user_id),
    CONSTRAINT uq_username          UNIQUE (username),
    CONSTRAINT uq_email_social      UNIQUE (email),
    CONSTRAINT chk_nb_abonnes       CHECK (nb_abonnes >= 0),
    CONSTRAINT chk_nb_abonnements   CHECK (nb_abonnements >= 0)
);

CREATE TABLE IF NOT EXISTS publications (
    post_id         BIGINT          NOT NULL AUTO_INCREMENT,
    user_id         BIGINT          NOT NULL,
    contenu         TEXT            NOT NULL,
    image_url       VARCHAR(500)    DEFAULT NULL,
    nb_likes        INT             NOT NULL DEFAULT 0,
    nb_commentaires INT             NOT NULL DEFAULT 0,
    nb_partages     INT             NOT NULL DEFAULT 0,
    post_parent_id  BIGINT          DEFAULT NULL,
    date_creation   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_publications      PRIMARY KEY (post_id),
    CONSTRAINT fk_post_user         FOREIGN KEY (user_id)
        REFERENCES utilisateurs(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_post_parent       FOREIGN KEY (post_parent_id)
        REFERENCES publications(post_id) ON DELETE SET NULL,
    CONSTRAINT chk_nb_likes         CHECK (nb_likes >= 0),
    CONSTRAINT chk_nb_commentaires  CHECK (nb_commentaires >= 0),
    CONSTRAINT chk_nb_partages      CHECK (nb_partages >= 0)
);

CREATE TABLE IF NOT EXISTS commentaires (
    commentaire_id  BIGINT          NOT NULL AUTO_INCREMENT,
    post_id         BIGINT          NOT NULL,
    user_id         BIGINT          NOT NULL,
    contenu         TEXT            NOT NULL,
    nb_likes        INT             NOT NULL DEFAULT 0,
    date_creation   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_commentaires      PRIMARY KEY (commentaire_id),
    CONSTRAINT fk_comment_post      FOREIGN KEY (post_id)
        REFERENCES publications(post_id) ON DELETE CASCADE,
    CONSTRAINT fk_comment_user      FOREIGN KEY (user_id)
        REFERENCES utilisateurs(user_id) ON DELETE CASCADE,
    CONSTRAINT chk_comment_likes    CHECK (nb_likes >= 0)
);

CREATE TABLE IF NOT EXISTS likes (
    user_id         BIGINT          NOT NULL,
    post_id         BIGINT          NOT NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_likes             PRIMARY KEY (user_id, post_id),
    CONSTRAINT fk_like_user         FOREIGN KEY (user_id)
        REFERENCES utilisateurs(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_like_post         FOREIGN KEY (post_id)
        REFERENCES publications(post_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS abonnements (
    suiveur_id      BIGINT          NOT NULL,
    suivi_id        BIGINT          NOT NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_abonnements       PRIMARY KEY (suiveur_id, suivi_id),
    CONSTRAINT fk_suiveur           FOREIGN KEY (suiveur_id)
        REFERENCES utilisateurs(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_suivi             FOREIGN KEY (suivi_id)
        REFERENCES utilisateurs(user_id) ON DELETE CASCADE,
    CONSTRAINT chk_no_self_follow   CHECK (suiveur_id <> suivi_id)
);

CREATE TABLE IF NOT EXISTS hashtags (
    hashtag_id  INT         NOT NULL AUTO_INCREMENT,
    tag         VARCHAR(100) NOT NULL,
    nb_posts    INT         NOT NULL DEFAULT 0,
    CONSTRAINT pk_hashtags      PRIMARY KEY (hashtag_id),
    CONSTRAINT uq_tag           UNIQUE (tag),
    CONSTRAINT chk_nb_posts     CHECK (nb_posts >= 0)
);

CREATE TABLE IF NOT EXISTS post_hashtags (
    post_id     BIGINT  NOT NULL,
    hashtag_id  INT     NOT NULL,
    CONSTRAINT pk_post_hashtags PRIMARY KEY (post_id, hashtag_id),
    CONSTRAINT fk_ph_post       FOREIGN KEY (post_id) REFERENCES publications(post_id) ON DELETE CASCADE,
    CONSTRAINT fk_ph_hashtag    FOREIGN KEY (hashtag_id) REFERENCES hashtags(hashtag_id) ON DELETE CASCADE
);

CREATE INDEX idx_publications_user  ON publications(user_id);
CREATE INDEX idx_publications_date  ON publications(date_creation);
CREATE INDEX idx_commentaires_post  ON commentaires(post_id);
CREATE INDEX idx_abonnements_suivi  ON abonnements(suivi_id);
CREATE INDEX idx_likes_post_user    ON likes(post_id, user_id);
