CREATE TABLE products (
                          id SERIAL PRIMARY KEY,
                          name VARCHAR(100),
                          price NUMERIC,
                          discount_percent INT
);

INSERT INTO products (name, price, discount_percent)
VALUES ('Laptop Gaming', 2500.00, 10);

INSERT INTO products (name, price, discount_percent)
VALUES
    ('Chuột không dây', 25.50, 5),
    ('Bàn phím cơ', 120.00, 15),
    ('Màn hình 4K', 450.00, 0);

INSERT INTO products (name, price)
VALUES ('Tai nghe Bluetooth', 80.00);

INSERT INTO products (name, price, discount_percent)
VALUES ('Loa thông minh', NULL, NULL);

CREATE OR REPLACE PROCEDURE calculate_discount(
    p_id INT,
    OUT p_final_price NUMERIC(10, 2)
)
    LANGUAGE plpgsql
AS
$$
DECLARE
    v_price            NUMERIC(10, 2);
    v_discount_percent INT;
    v_name             VARCHAR(100);
BEGIN
    SELECT p.name,
           p.price,
           p.discount_percent
    INTO
        v_name, v_price, v_discount_percent
    From products p
    WHERE p.id = p_id;
    RAISE NOTICE 'id = %, name = %, price = %, discount_percent = %', p_id, v_name, v_price, v_discount_percent;
    IF v_price IS NULL OR v_discount_percent IS NULL THEN
        RAISE NOTICE 'Invalid value!';
        p_final_price := NULL;
    ELSIF v_discount_percent > 50 THEN
        v_discount_percent := 50;
        p_final_price := v_price - (v_price * v_discount_percent) / 100;
    ELSE
        p_final_price := v_price - (v_price * v_discount_percent) / 100;
    end if;

    UPDATE products
    SET price = v_price
    WHERE id = p_id;
end;
$$;


DO $$
   DECLARE
    v_id INT := 1;
    p_final_price NUMERIC(10, 2);
   Begin
    call calculate_discount(v_id, p_final_price);
    RAISE NOTICE 'final price = %', p_final_price;
   end;
$$;