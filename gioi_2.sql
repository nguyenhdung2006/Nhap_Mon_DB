CREATE TABLE products (
                          id SERIAL PRIMARY KEY,
                          name VARCHAR(100),
                          stock INT
);

CREATE TABLE orders (
                        id SERIAL PRIMARY KEY,
                        product_id INT,
                        quantity INT
);

CREATE OR REPLACE FUNCTION update_stock()
    RETURNS TRIGGER AS
$$
BEGIN
    -- INSERT: trừ stock
    IF TG_OP = 'INSERT' THEN
        UPDATE products
        SET stock = stock - NEW.quantity
        WHERE id = NEW.product_id;

        RETURN NEW;

        -- UPDATE: điều chỉnh theo chênh lệch
    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE products
        SET stock = stock + OLD.quantity - NEW.quantity
        WHERE id = NEW.product_id;

        RETURN NEW;

        -- DELETE: cộng lại stock
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE products
        SET stock = stock + OLD.quantity
        WHERE id = OLD.product_id;

        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_stock
    AFTER INSERT OR UPDATE OR DELETE ON orders
    FOR EACH ROW
EXECUTE FUNCTION update_stock();

INSERT INTO products (name, stock)
VALUES ('Laptop', 10);

INSERT INTO orders (product_id, quantity)
VALUES (1, 3);

UPDATE orders
SET quantity = 5
WHERE id = 1;

DELETE FROM orders
WHERE id = 1;

SELECT * FROM products;