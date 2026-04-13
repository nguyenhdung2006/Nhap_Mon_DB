ALTER TABLE products ADD COLUMN price NUMERIC;

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    quantity INT,
    total_amount NUMERIC
);

CREATE OR REPLACE FUNCTION calculate_total_amount()
RETURNS TRIGGER AS $$
DECLARE
    product_price NUMERIC;
BEGIN
    SELECT price INTO product_price
    FROM products
    WHERE product_id = NEW.product_id;

    NEW.total_amount := NEW.quantity * product_price;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_orders
BEFORE INSERT ON orders
FOR EACH ROW
EXECUTE FUNCTION calculate_total_amount();

INSERT INTO products (name, stock, price) VALUES ('C', 50, 10);

INSERT INTO orders (product_id, quantity) VALUES (1, 3);

SELECT * FROM orders;
