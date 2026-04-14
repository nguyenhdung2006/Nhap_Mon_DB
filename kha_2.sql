CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY ,
    owner_name varchar(100) ,
    balance NUMERIC(10, 2)
);

INSERT INTO accounts (owner_name, balance)
VALUES ('A', 500.00), ('B', 300.00);

BEGIN;

SELECT *
FROM accounts
WHERE owner_name IN ('A','B') FOR UPDATE;

UPDATE accounts
SET balance = balance - 100.00
WHERE owner_name = 'A';

UPDATE accounts
SET balance = balance + 100.00
WHERE owner_name = 'B';

COMMIT;

select * from accounts;

BEGIN;

SELECT *
FROM accounts
WHERE owner_name IN ('A','B') FOR UPDATE;

UPDATE accounts
SET balance = balance - 100.00
WHERE owner_name = 'A';

UPDATE accounts
SET balance = balance + 100.00
WHERE owner_name = 'C';

ROLLBACK ;
