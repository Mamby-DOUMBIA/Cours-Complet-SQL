-- ============================================================
-- SCHÉMA BANCAIRE — sql-mastery
-- Compatible : MySQL 8.0+ | PostgreSQL 16+ | SQL Server 2022
-- ============================================================

CREATE DATABASE IF NOT EXISTS banking_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE banking_db;

CREATE TABLE IF NOT EXISTS clients_banque (
    client_id       INT             NOT NULL AUTO_INCREMENT,
    nom             VARCHAR(100)    NOT NULL,
    prenom          VARCHAR(100)    NOT NULL,
    email           VARCHAR(255)    NOT NULL UNIQUE,
    date_naissance  DATE            NOT NULL,
    score_credit    INT             DEFAULT 700,
    date_creation   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_clients_banque    PRIMARY KEY (client_id),
    CONSTRAINT chk_score            CHECK (score_credit BETWEEN 300 AND 850)
);

CREATE TABLE IF NOT EXISTS comptes (
    compte_id       INT             NOT NULL AUTO_INCREMENT,
    client_id       INT             NOT NULL,
    type_compte     VARCHAR(20)     NOT NULL,
    iban            VARCHAR(34)     NOT NULL,
    solde           DECIMAL(15,2)   NOT NULL DEFAULT 0.00,
    devise          VARCHAR(3)      NOT NULL DEFAULT 'EUR',
    statut          VARCHAR(20)     NOT NULL DEFAULT 'actif',
    date_ouverture  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_comptes           PRIMARY KEY (compte_id),
    CONSTRAINT uq_iban              UNIQUE (iban),
    CONSTRAINT fk_compte_client     FOREIGN KEY (client_id)
        REFERENCES clients_banque(client_id),
    CONSTRAINT chk_type_compte      CHECK (type_compte IN ('courant','epargne','livret_a','pea')),
    CONSTRAINT chk_solde_min        CHECK (solde >= -5000.00),
    CONSTRAINT chk_statut_compte    CHECK (statut IN ('actif','bloque','clos'))
);

CREATE TABLE IF NOT EXISTS transactions_bancaires (
    transaction_id      BIGINT          NOT NULL AUTO_INCREMENT,
    compte_source_id    INT             DEFAULT NULL,
    compte_dest_id      INT             DEFAULT NULL,
    montant             DECIMAL(15,2)   NOT NULL,
    type_operation      VARCHAR(30)     NOT NULL,
    description         VARCHAR(200)    DEFAULT NULL,
    reference           VARCHAR(50)     DEFAULT NULL,
    statut              VARCHAR(20)     NOT NULL DEFAULT 'effectuee',
    date_operation      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_transactions      PRIMARY KEY (transaction_id),
    CONSTRAINT fk_trans_source      FOREIGN KEY (compte_source_id)
        REFERENCES comptes(compte_id),
    CONSTRAINT fk_trans_dest        FOREIGN KEY (compte_dest_id)
        REFERENCES comptes(compte_id),
    CONSTRAINT chk_type_op          CHECK (type_operation IN ('virement','depot','retrait','paiement','frais','interet')),
    CONSTRAINT chk_montant_pos      CHECK (montant > 0),
    CONSTRAINT chk_statut_trans     CHECK (statut IN ('effectuee','en_attente','annulee','rejetee')),
    CONSTRAINT chk_trans_accounts   CHECK (
        compte_source_id IS NOT NULL
        OR compte_dest_id IS NOT NULL
    ),
    CONSTRAINT chk_trans_not_same   CHECK (
        compte_source_id IS NULL
        OR compte_dest_id IS NULL
        OR compte_source_id <> compte_dest_id
    )
);

CREATE TABLE IF NOT EXISTS cartes_bancaires (
    carte_id        INT             NOT NULL AUTO_INCREMENT,
    compte_id       INT             NOT NULL,
    numero_masque   VARCHAR(19)     NOT NULL,
    type_carte      VARCHAR(20)     NOT NULL DEFAULT 'debit',
    plafond_jour    DECIMAL(10,2)   NOT NULL DEFAULT 1000.00,
    date_expiration DATE            NOT NULL,
    statut          VARCHAR(20)     NOT NULL DEFAULT 'active',
    CONSTRAINT pk_cartes            PRIMARY KEY (carte_id),
    CONSTRAINT fk_carte_compte      FOREIGN KEY (compte_id)
        REFERENCES comptes(compte_id),
    CONSTRAINT chk_plafond_jour     CHECK (plafond_jour > 0),
    CONSTRAINT chk_statut_carte     CHECK (statut IN ('active','bloquee','expiree'))
);

CREATE TABLE IF NOT EXISTS credits (
    credit_id       INT             NOT NULL AUTO_INCREMENT,
    client_id       INT             NOT NULL,
    type_credit     VARCHAR(30)     NOT NULL,
    montant_initial DECIMAL(15,2)   NOT NULL,
    montant_restant DECIMAL(15,2)   NOT NULL,
    taux_interet    DECIMAL(5,3)    NOT NULL,
    duree_mois      INT             NOT NULL,
    mensualite      DECIMAL(10,2)   NOT NULL,
    date_debut      DATE            NOT NULL,
    statut          VARCHAR(20)     NOT NULL DEFAULT 'actif',
    CONSTRAINT pk_credits           PRIMARY KEY (credit_id),
    CONSTRAINT fk_credit_client     FOREIGN KEY (client_id)
        REFERENCES clients_banque(client_id),
    CONSTRAINT chk_credit_montants  CHECK (
        montant_initial > 0
        AND montant_restant >= 0
        AND montant_restant <= montant_initial
    ),
    CONSTRAINT chk_taux_interet     CHECK (taux_interet >= 0),
    CONSTRAINT chk_duree_mois       CHECK (duree_mois > 0),
    CONSTRAINT chk_mensualite       CHECK (mensualite > 0),
    CONSTRAINT chk_statut_credit    CHECK (statut IN ('actif','solde','impaye'))
);

CREATE INDEX idx_trans_source   ON transactions_bancaires(compte_source_id);
CREATE INDEX idx_trans_dest     ON transactions_bancaires(compte_dest_id);
CREATE INDEX idx_trans_date     ON transactions_bancaires(date_operation);
CREATE INDEX idx_trans_type_date ON transactions_bancaires(type_operation, date_operation);
CREATE INDEX idx_comptes_client ON comptes(client_id);
CREATE INDEX idx_comptes_statut_type ON comptes(statut, type_compte);
CREATE INDEX idx_credits_client_statut ON credits(client_id, statut);
