-- ============================================================
-- DONNEES DE TEST — Analytics
-- ============================================================

USE analytics_db;

INSERT INTO dim_date (
    date_id, annee, trimestre, mois, nom_mois, semaine, jour_semaine, nom_jour, est_weekend, est_ferie
)
VALUES
    ('2026-03-01', 2026, 1, 3, 'mars', 9, 7, 'dimanche', 1, 0),
    ('2026-03-02', 2026, 1, 3, 'mars', 10, 1, 'lundi', 0, 0),
    ('2026-03-03', 2026, 1, 3, 'mars', 10, 2, 'mardi', 0, 0);

INSERT INTO dim_utilisateurs (
    user_id, segment, canal_acquisition, date_premiere_visite, date_dernier_achat, nb_sessions_total
)
VALUES
    (1001, 'premium', 'seo', '2025-11-03', '2026-02-15', 42),
    (1002, 'standard', 'ads', '2026-01-10', NULL, 9);

INSERT INTO evenements (
    event_id, session_id, user_id, event_type, page_url, referrer_url, device_type, pays, ville, duree_secondes, created_at
)
VALUES
    (1, 'sess_001', 1001, 'page_view', '/home', 'https://google.com', 'desktop', 'France', 'Paris', 45, '2026-03-01 08:10:00'),
    (2, 'sess_001', 1001, 'add_to_cart', '/product/12', '/home', 'desktop', 'France', 'Paris', 22, '2026-03-01 08:11:10'),
    (3, 'sess_002', 1002, 'page_view', '/pricing', NULL, 'mobile', 'France', 'Lyon', 31, '2026-03-02 17:03:00');

INSERT INTO metriques_journalieres (
    date_id, canal, device_type, nb_sessions, nb_utilisateurs, nb_nouveaux, pages_vues, duree_moy_sec, taux_rebond, conversions, revenus
)
VALUES
    ('2026-03-01', 'seo', 'desktop', 120, 98, 12, 420, 51.20, 36.50, 8, 1299.90),
    ('2026-03-02', 'ads', 'mobile', 80, 70, 18, 260, 42.80, 44.20, 3, 349.00);
