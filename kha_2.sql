CREATE TABLE customers (
                           id SERIAL PRIMARY KEY,
                           name VARCHAR(100),
                           credit_limit NUMERIC
);

CREATE TABLE orders (
                        id SERIAL PRIMARY KEY,
                        customer_id INT,
                        order_amount NUMERIC
);

CREATE OR REPLACE FUNCTION check_credit_limit()
    RETURNS TRIGGER AS
$$
DECLARE
    total_orders NUMERIC;
    customer_limit NUMERIC;
BEGIN
    -- Lấy tổng đơn hàng hiện tại
    SELECT COALESCE(SUM(order_amount), 0)
    INTO total_orders
    FROM orders
    WHERE customer_id = NEW.customer_id;

    -- Lấy hạn mức của khách
    SELECT credit_limit
    INTO customer_limit
    FROM customers
    WHERE id = NEW.customer_id;

    -- Kiểm tra vượt hạn mức
    IF total_orders + NEW.order_amount > customer_limit THEN
        RAISE EXCEPTION 'Vuot han muc tin dung!';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_credit
    BEFORE INSERT ON orders
    FOR EACH ROW
EXECUTE FUNCTION check_credit_limit();

INSERT INTO customers (name, credit_limit)
VALUES
    ('Alice', 1000),
    ('Bob', 500);

INSERT INTO orders (customer_id, order_amount)
VALUES (1, 300);
INSERT INTO orders (customer_id, order_amount)
VALUES (1, 400);

INSERT INTO orders (customer_id, order_amount)
VALUES (1, 400);

SELECT * FROM orders;
