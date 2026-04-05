CREATE INDEX idx_Orders_customer_id ON orders(customer_id);

EXPLAIN ANALYSE SELECT * FROM Orders WHERE customer_id = 100;
-- chưa có index
-- Planning Time: 0.054 ms
-- Execution Time: 4.370 ms

-- có index
-- Planning Time: 2.680 ms
-- Execution Time: 0.553 ms