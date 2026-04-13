BEGIN;

UPDATE accounts 
SET balance = balance - 100.00 
WHERE owner_name = 'A';

UPDATE accounts 
SET balance = balance + 100.00 
WHERE owner_name = 'B';

COMMIT;

SELECT * FROM accounts;

BEGIN;

UPDATE accounts 
SET balance = balance - 100.00 
WHERE owner_name = 'A';

UPDATE accounts 
SET balance = balance + 100.00 
WHERE account_id = 999;

ROLLBACK;

SELECT * FROM accounts;
