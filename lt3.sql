CREATE OR REPLACE FUNCTION update_stock_after_insert()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE products
    SET stock = stock - NEW.quantity
    WHERE product_id = NEW.product_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_insert_sales
AFTER INSERT ON sales
FOR EACH ROW
EXECUTE FUNCTION update_stock_after_insert();

INSERT INTO products (name, stock) VALUES ('B', 20);

INSERT INTO sales (product_id, quantity) VALUES (1, 5);

SELECT * FROM products;
