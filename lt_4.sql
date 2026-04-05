CREATE OR REPLACE VIEW CustomerSales AS
    SELECT customer_id, SUM(amount) AS total_amount
    FROM Sales
    GROUP BY customer_id;

SELECT * FROM CustomerSales cs
WHERE total_amount > 1000;

CREATE OR REPLACE VIEW CustomerSales AS
SELECT customer_id, SUM(amount) AS total_amount
FROM Sales
GROUP BY customer_id;

UPDATE Sales
SET amount = amount * 1.2
WHERE customer_id BETWEEN 2000 AND 5000;