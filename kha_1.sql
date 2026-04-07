CREATE TABLE products (
                          id SERIAL PRIMARY KEY,
                          name VARCHAR(100),
                          price NUMERIC,
                          last_modified TIMESTAMP
);

CREATE OR REPLACE FUNCTION update_last_modified()
    RETURNS TRIGGER AS
$$
BEGIN
    NEW.last_modified = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_last_modified
    BEFORE UPDATE ON products
    FOR EACH ROW
EXECUTE FUNCTION update_last_modified();

INSERT INTO products (name, price, last_modified)
VALUES
    ('Laptop', 1500, NOW()),
    ('Mouse', 20, NOW()),
    ('Keyboard', 50, NOW());

UPDATE products
SET price = 1600
WHERE name = 'Laptop';

SELECT * FROM products;