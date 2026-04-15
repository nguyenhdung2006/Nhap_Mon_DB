CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    balance NUMERIC(12,2)
);

CREATE TABLE transactions (
                              trans_id SERIAL PRIMARY KEY,
                              account_id INT REFERENCES accounts(account_id),
                              amount NUMERIC(12,2),
                              trans_type VARCHAR(20), -- 'WITHDRAW-rut tien' hoặc 'DEPOSIT-nap tien'
                              created_at TIMESTAMP DEFAULT NOW()
);

BEGIN ;

DO $$
    DECLARE
        v_account_id INT := 1;
        v_amount NUMERIC := 100;
        v_balance NUMERIC;
    BEGIN

        -- 1. lấy balance
        SELECT balance
        INTO v_balance
        FROM accounts
        WHERE account_id = v_account_id
        FOR UPDATE;

        -- 2. kiểm tra đủ tiền
        IF v_balance < v_amount THEN
            RAISE EXCEPTION 'Không đủ tiền';
        END IF;

        -- 3. trừ tiền
        UPDATE accounts
        SET balance = balance - v_amount
        WHERE account_id = v_account_id;

        -- 4. ghi log transaction
        INSERT INTO transactions(account_id, amount, trans_type)
        VALUES (v_account_id, v_amount, 'WITHDRAW');

END $$ language plpgsql;

COMMIT ;

BEGIN;

DO $$
    DECLARE
        v_account_id INT := 1;
        v_amount NUMERIC := 100;
        v_balance NUMERIC;
    BEGIN

        -- 1. lấy balance
        SELECT balance
        INTO v_balance
        FROM accounts
        WHERE account_id = v_account_id
            FOR UPDATE;

        -- 2. kiểm tra
        IF v_balance < v_amount THEN
            RAISE EXCEPTION 'Không đủ tiền';
        END IF;

        -- 3. trừ tiền
        UPDATE accounts
        SET balance = balance - v_amount
        WHERE account_id = v_account_id;

        -- ❌ 4. CỐ Ý GÂY LỖI: account_id = 999999 không tồn tại
        INSERT INTO transactions(account_id, amount, trans_type)
        VALUES (999999, v_amount, 'WITHDRAW');

    END $$;

ROLLBACK;
