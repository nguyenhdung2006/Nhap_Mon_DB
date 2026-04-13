BEGIN;

UPDATE products SET stock = stock - 2 WHERE product_id = 1;
UPDATE products SET stock = stock - 1 WHERE product_id = 2;

INSERT INTO orders (customer_name, total_amount) 
VALUES ('Nguyen Van A', (SELECT price * 2 FROM products WHERE product_id = 1) + (SELECT price * 1 FROM products WHERE product_id = 2))
RETURNING order_id;

INSERT INTO order_items (order_id, product_id, quantity, subtotal)
VALUES 
(currval('orders_order_id_seq'), 1, 2, (SELECT price * 2 FROM products WHERE product_id = 1)),
(currval('orders_order_id_seq'), 2, 1, (SELECT price * 1 FROM products WHERE product_id = 2));

COMMIT;

UPDATE products SET stock = 0 WHERE product_id = 1;

BEGIN;

UPDATE products SET stock = stock - 2 WHERE product_id = 1;

UPDATE products SET stock = stock - 1 WHERE product_id = 2;

ROLLBACK;

SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;
