CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    stock INT
);

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    quantity INT
);

CREATE OR REPLACE FUNCTION check_stock()
RETURNS TRIGGER AS $$
DECLARE
    current_stock INT;
BEGIN
    SELECT stock INTO current_stock
    FROM products
    WHERE product_id = NEW.product_id;

    IF NEW.quantity > current_stock THEN
        RAISE EXCEPTION 'Not enough stock';
    END IF;

    UPDATE products
    SET stock = stock - NEW.quantity
    WHERE product_id = NEW.product_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_sales
BEFORE INSERT ON sales
FOR EACH ROW
EXECUTE FUNCTION check_stock();

INSERT INTO products (name, stock) VALUES ('A', 10);

INSERT INTO sales (product_id, quantity) VALUES (1, 5);

INSERT INTO sales (product_id, quantity) VALUES (1, 20);
