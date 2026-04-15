CREATE TABLE customers (
                           customer_id SERIAL PRIMARY KEY,
                           name VARCHAR(100),
                           balance NUMERIC(12,2)
);

CREATE TABLE products (
                          product_id SERIAL PRIMARY KEY,
                          name VARCHAR(100),
                          stock INT,
                          price NUMERIC(10,2)
);

CREATE TABLE orders (
                        order_id SERIAL PRIMARY KEY,
                        customer_id INT REFERENCES customers(customer_id),
                        total_amount NUMERIC(12,2),
                        created_at TIMESTAMP DEFAULT NOW(),
                        status VARCHAR(20) DEFAULT 'PENDING'
);

CREATE TABLE order_items (
                             item_id SERIAL PRIMARY KEY,
                             order_id INT REFERENCES orders(order_id),
                             product_id INT REFERENCES products(product_id),
                             quantity INT,
                             subtotal NUMERIC(10,2)
);

DO $$
        DECLARE
            v_customer_id INT := 1;
            v_balance INT;
            v_order_id INT;
            v_subtotal_1 NUMERIC(12, 2);
            v_subtotal_2 NUMERIC(12, 2);
            v_total_amount NUMERIC(12, 2);
            v_stock_1 INT;
            v_stock_2 INT;
            v_price_1 NUMERIC;
            v_price_2 NUMERIC;
        begin
            Select c.balance INTO v_balance
            FROM customers c
            WHERE c.customer_id = v_customer_id
            FOR UPDATE;

            SELECT stock, price INTO v_stock_1, v_price_1
            FROM products
            WHERE product_id = 1;

            SELECT stock, price INTO v_stock_2, v_price_2
            FROM products
            WHERE product_id = 3;

            IF v_stock_1 < 1 OR v_stock_2 < 2 THEN
                RAISE EXCEPTION 'Không đủ hàng. Vui lòng quay lại khi khác!';
            end if;

            v_subtotal_1 := v_price_1 * 1;
            v_subtotal_2 := v_price_2 * 2;
            v_total_amount := v_subtotal_1 + v_subtotal_2;

            IF v_balance < v_total_amount THEN
                RAISE EXCEPTION 'Số dư của bạn không đủ. Vui lòng kiểm tra lại!';
            end if;

            INSERT INTO orders (customer_id, total_amount, created_at)
            VALUES (1, v_total_amount, now())
            RETURNING order_id INTO v_order_id;

            INSERT INTO order_items (order_id, product_id, quantity, subtotal)
            VALUES
                (v_order_id, 1, 1, v_subtotal_1),
                (v_order_id, 3, 2, v_subtotal_2);

            UPDATE customers
            SET balance = balance - v_total_amount
            WHERE customer_id = v_customer_id;

            UPDATE products
            SET stock = stock - 1
            WHERE product_id = 1;

            UPDATE products
            SET stock = stock - 2
            WHERE product_id = 3;

            UPDATE orders
            SET status = 'COMPLETED'
            WHERE order_id = v_order_id;
        end
    $$ language plpgsql;


SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM customers;
SELECT * FROM products;

CREATE SCHEMA xs_2;
