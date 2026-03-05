-- ============================================================
-- DONNEES DE TEST — Banking
-- ============================================================

USE banking_db;

INSERT INTO clients_banque (client_id, nom, prenom, email, date_naissance, score_credit)
VALUES
    (1, 'Martin', 'Alice', 'alice.martin@bank.test', '1990-04-18', 780),
    (2, 'Dupont', 'Bob', 'bob.dupont@bank.test', '1987-10-06', 690);

INSERT INTO comptes (compte_id, client_id, type_compte, iban, solde, devise, statut)
VALUES
    (1, 1, 'courant', 'FR7630004000031234567890143', 3250.00, 'EUR', 'actif'),
    (2, 1, 'epargne', 'FR7630004000031234567890144', 9850.00, 'EUR', 'actif'),
    (3, 2, 'courant', 'FR7630004000031234567890145', 610.00, 'EUR', 'actif');

INSERT INTO transactions_bancaires (
    transaction_id, compte_source_id, compte_dest_id, montant, type_operation, description, reference, statut
)
VALUES
    (1, NULL, 1, 3500.00, 'depot', 'Depot salaire', 'TXN-2026-0001', 'effectuee'),
    (2, 1, 3, 120.00, 'virement', 'Remboursement repas', 'TXN-2026-0002', 'effectuee'),
    (3, 1, NULL, 80.00, 'paiement', 'Paiement carte', 'TXN-2026-0003', 'effectuee');

INSERT INTO cartes_bancaires (carte_id, compte_id, numero_masque, type_carte, plafond_jour, date_expiration, statut)
VALUES
    (1, 1, '**** **** **** 1024', 'debit', 1500.00, '2028-07-31', 'active');

INSERT INTO credits (
    credit_id, client_id, type_credit, montant_initial, montant_restant, taux_interet, duree_mois, mensualite, date_debut, statut
)
VALUES
    (1, 2, 'auto', 15000.00, 9200.00, 4.100, 48, 338.00, '2024-01-01', 'actif');
