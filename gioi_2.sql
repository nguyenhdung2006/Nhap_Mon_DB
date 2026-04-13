BEGIN;

UPDATE accounts 
SET balance = balance - 500.00 
WHERE account_id = 1 AND balance >= 500.00;

INSERT INTO transactions (account_id, amount, trans_type) 
VALUES (1, 500.00, 'WITHDRAW');

COMMIT;

BEGIN;

UPDATE accounts 
SET balance = balance - 200.00 
WHERE account_id = 1 AND balance >= 200.00;

INSERT INTO transactions (account_id, amount, trans_type) 
VALUES (999, 200.00, 'WITHDRAW');

ROLLBACK;

SELECT * FROM accounts;
SELECT * FROM transactions;
