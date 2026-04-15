BEGIN;

-- 1. Kiểm tra tồn kho
DO $$
    DECLARE
        stock_p1 INT;
        stock_p2 INT;
        price_p1 NUMERIC;
        price_p2 NUMERIC;
        orderId INT;
        total NUMERIC := 0;
    BEGIN
        -- Lấy tồn kho + giá
        SELECT stock, price INTO stock_p1, price_p1 FROM products WHERE product_id = 1;
        SELECT stock, price INTO stock_p2, price_p2 FROM products WHERE product_id = 2;

        -- Nếu thiếu hàng → rollback
        IF stock_p1 < 2 OR stock_p2 < 1 THEN
            RAISE EXCEPTION 'Không đủ hàng trong kho!';
        END IF;

        -- 2. Trừ kho
        UPDATE products SET stock = stock - 2 WHERE product_id = 1;
        UPDATE products SET stock = stock - 1 WHERE product_id = 2;

        -- 3. Tạo order
        INSERT INTO orders(customer_name)
        VALUES ('Nguyen Van A')
        RETURNING order_id INTO orderId; -- lấy ngay dữ liệu từ insert/update/delete thay vì select

        --SELECT order_id
        --FROM orders
        --WHERE customer_name = 'Nguyen Van A'
        --ORDER BY order_id DESC
        --LIMIT 1;

        -- 4. Thêm order_items
        INSERT INTO order_items(order_id, product_id, quantity, subtotal)
        VALUES
            (orderId, 1, 2, price_p1 * 2),
            (orderId, 2, 1, price_p2 * 1);

        -- 5. Tính tổng tiền
        total := price_p1 * 2 + price_p2 * 1;

        UPDATE orders
        SET total_amount = total
        WHERE order_id = orderId;

    END $$;

COMMIT;
