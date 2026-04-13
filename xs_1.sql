BEGIN;

DO $$
DECLARE
    v_customer_id INT;
    v_balance NUMERIC(12,2);
    v_total NUMERIC(12,2) := 0;
    v_order_id INT;
    v_price NUMERIC(10,2);
    v_stock INT;
BEGIN
    SELECT customer_id, balance INTO v_customer_id, v_balance
    FROM customers
    WHERE name = 'Tran Thi B'
    FOR UPDATE;

    SELECT price, stock INTO v_price, v_stock FROM products WHERE product_id = 1 FOR UPDATE;
    IF v_stock < 1 THEN
        RAISE EXCEPTION 'OUT_OF_STOCK';
    END IF;
    v_total := v_total + v_price * 1;

    SELECT price, stock INTO v_price, v_stock FROM products WHERE product_id = 3 FOR UPDATE;
    IF v_stock < 2 THEN
        RAISE EXCEPTION 'OUT_OF_STOCK';
    END IF;
    v_total := v_total + v_price * 2;

    IF v_balance < v_total THEN
        RAISE EXCEPTION 'INSUFFICIENT_BALANCE';
    END IF;

    INSERT INTO orders(customer_id, total_amount, status)
    VALUES (v_customer_id, v_total, 'PENDING')
    RETURNING order_id INTO v_order_id;

    UPDATE products SET stock = stock - 1 WHERE product_id = 1;
    INSERT INTO order_items(order_id, product_id, quantity, subtotal)
    VALUES (v_order_id, 1, 1, (SELECT price FROM products WHERE product_id = 1) * 1);

    UPDATE products SET stock = stock - 2 WHERE product_id = 3;
    INSERT INTO order_items(order_id, product_id, quantity, subtotal)
    VALUES (v_order_id, 3, 2, (SELECT price FROM products WHERE product_id = 3) * 2);

    UPDATE customers SET balance = balance - v_total WHERE customer_id = v_customer_id;

    UPDATE orders SET status = 'COMPLETED' WHERE order_id = v_order_id;

END $$;

COMMIT;
