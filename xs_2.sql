CREATE TABLE accounts (
                          account_id SERIAL PRIMARY KEY,
                          owner_name VARCHAR(100),
                          balance NUMERIC(12,2),
                          status VARCHAR(10) DEFAULT 'ACTIVE'
);

CREATE TABLE transactions (
                              trans_id SERIAL PRIMARY KEY,
                              from_account INT REFERENCES accounts(account_id),
                              to_account INT REFERENCES accounts(account_id),
                              amount NUMERIC(12,2),
                              status VARCHAR(20) DEFAULT 'PENDING',
                              created_at TIMESTAMP DEFAULT NOW()
);

DO $$
    declare
        v_from INT := 1;
        v_to INT := 2;
        v_balance NUMERIC(12, 2);
        v_amount NUMERIC(12, 2) := 500.00;
        v_trans_id INT;
    begin
        SELECT 1 FROM accounts WHERE account_id IN (1, 2) FOR UPDATE;

        SELECT balance INTO v_balance
        FROM accounts
        WHERE account_id = v_from;

        IF v_balance < v_amount THEN
            RAISE EXCEPTION 'Số dư không đủ!';
        end if;

        UPDATE accounts
        SET balance = balance - v_amount
        WHERE account_id = v_from;

        UPDATE accounts
        SET balance = balance + v_amount
        WHERE account_id = v_to;

        INSERT INTO transactions (from_account, to_account, amount, status, created_at)
        VALUES (1, 2, v_amount, 'COMPLETED', now())
        RETURNING trans_id INTO v_trans_id;
    end;
$$ language plpgsql;

CRE
