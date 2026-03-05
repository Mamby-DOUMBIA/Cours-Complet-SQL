-- ============================================================
-- SCHÉMA ANALYTIQUE — sql-mastery
-- Jeu de données orienté Business Intelligence
-- Compatible : MySQL 8.0+ | PostgreSQL 16+ | SQL Server 2022
-- ============================================================

CREATE DATABASE IF NOT EXISTS analytics_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE analytics_db;

-- Table de faits : événements web
CREATE TABLE IF NOT EXISTS evenements (
    event_id        BIGINT          NOT NULL AUTO_INCREMENT,
    session_id      VARCHAR(50)     NOT NULL,
    user_id         BIGINT          DEFAULT NULL,
    event_type      VARCHAR(50)     NOT NULL,
    page_url        VARCHAR(500)    NOT NULL,
    referrer_url    VARCHAR(500)    DEFAULT NULL,
    device_type     VARCHAR(20)     NOT NULL DEFAULT 'desktop',
    pays            VARCHAR(50)     DEFAULT NULL,
    ville           VARCHAR(100)    DEFAULT NULL,
    duree_secondes  INT             DEFAULT NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_evenements    PRIMARY KEY (event_id),
    CONSTRAINT chk_device       CHECK (device_type IN ('desktop','mobile','tablet'))
);

-- Dimension : utilisateurs
CREATE TABLE IF NOT EXISTS dim_utilisateurs (
    user_id         BIGINT          NOT NULL AUTO_INCREMENT,
    segment         VARCHAR(50)     NOT NULL DEFAULT 'standard',
    canal_acquisition VARCHAR(50)   DEFAULT NULL,
    date_premiere_visite DATE       NOT NULL,
    date_dernier_achat  DATE        DEFAULT NULL,
    nb_sessions_total   INT         NOT NULL DEFAULT 0,
    CONSTRAINT pk_dim_users PRIMARY KEY (user_id)
);

-- Dimension : date (table calendrier)
CREATE TABLE IF NOT EXISTS dim_date (
    date_id         DATE            NOT NULL,
    annee           INT             NOT NULL,
    trimestre       INT             NOT NULL,
    mois            INT             NOT NULL,
    nom_mois        VARCHAR(20)     NOT NULL,
    semaine         INT             NOT NULL,
    jour_semaine    INT             NOT NULL,
    nom_jour        VARCHAR(20)     NOT NULL,
    est_weekend     TINYINT(1)      NOT NULL DEFAULT 0,
    est_ferie       TINYINT(1)      NOT NULL DEFAULT 0,
    CONSTRAINT pk_dim_date PRIMARY KEY (date_id)
);

-- Table de faits : métriques agrégées par jour
CREATE TABLE IF NOT EXISTS metriques_journalieres (
    date_id         DATE            NOT NULL,
    canal           VARCHAR(50)     NOT NULL,
    device_type     VARCHAR(20)     NOT NULL,
    nb_sessions     INT             NOT NULL DEFAULT 0,
    nb_utilisateurs INT             NOT NULL DEFAULT 0,
    nb_nouveaux     INT             NOT NULL DEFAULT 0,
    pages_vues      INT             NOT NULL DEFAULT 0,
    duree_moy_sec   DECIMAL(8,2)    DEFAULT NULL,
    taux_rebond     DECIMAL(5,2)    DEFAULT NULL,
    conversions     INT             NOT NULL DEFAULT 0,
    revenus         DECIMAL(12,2)   NOT NULL DEFAULT 0,
    CONSTRAINT pk_metriques PRIMARY KEY (date_id, canal, device_type),
    CONSTRAINT fk_metriques_date FOREIGN KEY (date_id)
        REFERENCES dim_date(date_id),
    CONSTRAINT chk_nb_sessions CHECK (nb_sessions >= 0),
    CONSTRAINT chk_nb_utilisateurs CHECK (nb_utilisateurs >= 0),
    CONSTRAINT chk_nb_nouveaux CHECK (nb_nouveaux >= 0),
    CONSTRAINT chk_pages_vues CHECK (pages_vues >= 0),
    CONSTRAINT chk_conversions CHECK (conversions >= 0),
    CONSTRAINT chk_revenus CHECK (revenus >= 0),
    CONSTRAINT chk_taux_rebond CHECK (taux_rebond IS NULL OR (taux_rebond >= 0 AND taux_rebond <= 100))
);

CREATE INDEX idx_evt_user     ON evenements(user_id);
CREATE INDEX idx_evt_date     ON evenements(created_at);
CREATE INDEX idx_evt_type     ON evenements(event_type);
CREATE INDEX idx_evt_session_date ON evenements(session_id, created_at);
CREATE INDEX idx_met_date     ON metriques_journalieres(date_id);
CREATE INDEX idx_met_canal_device ON metriques_journalieres(canal, device_type);
