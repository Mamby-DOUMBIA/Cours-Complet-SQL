-- ============================================================
-- SCHÉMA E-COMMERCE — sql-mastery
-- Compatible : MySQL 8.0+ | PostgreSQL 16+ | SQL Server 2022
-- ============================================================

-- ─── MySQL ───────────────────────────────────────────────────
-- Créer et sélectionner la base
CREATE DATABASE IF NOT EXISTS ecommerce_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ecommerce_db;

-- ─── Table : categories ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS categories (
    categorie_id        INT             NOT NULL AUTO_INCREMENT,
    nom                 VARCHAR(100)    NOT NULL,
    description         TEXT,
    slug                VARCHAR(120)    NOT NULL,
    categorie_parent_id INT             DEFAULT NULL,
    actif               TINYINT(1)      NOT NULL DEFAULT 1,
    date_creation       DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_categories        PRIMARY KEY (categorie_id),
    CONSTRAINT uq_categories_slug   UNIQUE (slug),
    CONSTRAINT fk_categorie_parent  FOREIGN KEY (categorie_parent_id)
        REFERENCES categories(categorie_id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- ─── Table : clients ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS clients (
    client_id       INT             NOT NULL AUTO_INCREMENT,
    nom             VARCHAR(100)    NOT NULL,
    prenom          VARCHAR(100)    NOT NULL,
    email           VARCHAR(255)    NOT NULL,
    telephone       VARCHAR(20)     DEFAULT NULL,
    date_naissance  DATE            DEFAULT NULL,
    adresse         VARCHAR(300)    DEFAULT NULL,
    ville           VARCHAR(100)    DEFAULT NULL,
    code_postal     VARCHAR(10)     DEFAULT NULL,
    pays            VARCHAR(50)     NOT NULL DEFAULT 'France',
    newsletter      TINYINT(1)      NOT NULL DEFAULT 0,
    date_creation   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_clients       PRIMARY KEY (client_id),
    CONSTRAINT uq_clients_email UNIQUE (email)
);

-- ─── Table : produits ────────────────────────────────────────
CREATE TABLE IF NOT EXISTS produits (
    produit_id      INT             NOT NULL AUTO_INCREMENT,
    reference       VARCHAR(50)     NOT NULL,
    nom             VARCHAR(200)    NOT NULL,
    description     TEXT            DEFAULT NULL,
    prix            DECIMAL(10,2)   NOT NULL,
    stock           INT             NOT NULL DEFAULT 0,
    poids_kg        DECIMAL(6,3)    DEFAULT NULL,
    categorie_id    INT             DEFAULT NULL,
    actif           TINYINT(1)      NOT NULL DEFAULT 1,
    date_creation   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_maj        DATETIME        DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_produits          PRIMARY KEY (produit_id),
    CONSTRAINT uq_produits_ref      UNIQUE (reference),
    CONSTRAINT fk_produits_cat      FOREIGN KEY (categorie_id)
        REFERENCES categories(categorie_id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT chk_prix_positif     CHECK (prix >= 0),
    CONSTRAINT chk_stock_positif    CHECK (stock >= 0)
);

-- ─── Table : commandes ───────────────────────────────────────
CREATE TABLE IF NOT EXISTS commandes (
    commande_id         INT             NOT NULL AUTO_INCREMENT,
    client_id           INT             NOT NULL,
    date_commande       DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    statut              VARCHAR(20)     NOT NULL DEFAULT 'en_attente',
    montant_total       DECIMAL(10,2)   NOT NULL,
    frais_livraison     DECIMAL(6,2)    NOT NULL DEFAULT 0.00,
    adresse_livraison   TEXT            DEFAULT NULL,
    note_client         TEXT            DEFAULT NULL,
    CONSTRAINT pk_commandes     PRIMARY KEY (commande_id),
    CONSTRAINT fk_cmd_client    FOREIGN KEY (client_id)
        REFERENCES clients(client_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_statut       CHECK (statut IN ('en_attente','en_cours','livree','annulee','remboursee')),
    CONSTRAINT chk_montant_total CHECK (montant_total >= 0),
    CONSTRAINT chk_frais_livraison CHECK (frais_livraison >= 0)
);

-- ─── Table : lignes_commande ──────────────────────────────────
CREATE TABLE IF NOT EXISTS lignes_commande (
    ligne_id        INT             NOT NULL AUTO_INCREMENT,
    commande_id     INT             NOT NULL,
    produit_id      INT             NOT NULL,
    quantite        INT             NOT NULL,
    prix_unitaire   DECIMAL(10,2)   NOT NULL,
    CONSTRAINT pk_lignes_cmd        PRIMARY KEY (ligne_id),
    CONSTRAINT fk_ligne_commande    FOREIGN KEY (commande_id)
        REFERENCES commandes(commande_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_ligne_produit     FOREIGN KEY (produit_id)
        REFERENCES produits(produit_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_quantite_pos     CHECK (quantite > 0),
    CONSTRAINT chk_prix_u_pos       CHECK (prix_unitaire >= 0)
);

-- ─── Table : avis ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS avis (
    avis_id         INT             NOT NULL AUTO_INCREMENT,
    produit_id      INT             NOT NULL,
    client_id       INT             NOT NULL,
    note            TINYINT         NOT NULL,
    titre           VARCHAR(200)    DEFAULT NULL,
    commentaire     TEXT            DEFAULT NULL,
    date_creation   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_avis          PRIMARY KEY (avis_id),
    CONSTRAINT fk_avis_produit  FOREIGN KEY (produit_id)
        REFERENCES produits(produit_id) ON DELETE CASCADE,
    CONSTRAINT fk_avis_client   FOREIGN KEY (client_id)
        REFERENCES clients(client_id) ON DELETE CASCADE,
    CONSTRAINT chk_note         CHECK (note BETWEEN 1 AND 5),
    CONSTRAINT uq_avis_client_produit UNIQUE (produit_id, client_id)
);

-- ─── Index de performance ────────────────────────────────────
CREATE INDEX idx_commandes_client      ON commandes(client_id);
CREATE INDEX idx_commandes_client_date ON commandes(client_id, date_commande);
CREATE INDEX idx_commandes_statut      ON commandes(statut);
CREATE INDEX idx_commandes_date        ON commandes(date_commande);
CREATE INDEX idx_lignes_commande       ON lignes_commande(commande_id);
CREATE INDEX idx_lignes_produit        ON lignes_commande(produit_id);
CREATE INDEX idx_produits_categorie    ON produits(categorie_id);
CREATE INDEX idx_produits_prix         ON produits(prix);
CREATE INDEX idx_avis_produit          ON avis(produit_id);
CREATE INDEX idx_avis_client_date      ON avis(client_id, date_creation);
