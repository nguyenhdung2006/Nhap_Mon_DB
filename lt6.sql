CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    account_name VARCHAR(50),
    balance NUMERIC
);

INSERT INTO accounts (account_name, balance) VALUES ('A', 1000);
INSERT INTO accounts (account_name, balance) VALUES ('B', 500);

BEGIN;

DO $$
DECLARE
    sender_balance NUMERIC;
    transfer_amount NUMERIC := 300;
BEGIN
    SELECT balance INTO sender_balance
    FROM accounts
    WHERE account_id = 1;

    IF sender_balance >= transfer_amount THEN
        UPDATE accounts
        SET balance = balance - transfer_amount
        WHERE account_id = 1;

        UPDATE accounts
        SET balance = balance + transfer_amount
        WHERE account_id = 2;
    ELSE
        RAISE EXCEPTION 'Insufficient balance';
    END IF;
END;
$$;

COMMIT;

SELECT * FROM accounts;
