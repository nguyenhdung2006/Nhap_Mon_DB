CREATE OR REPLACE PROCEDURE update_product_price(
    p_category_id INT,
    p_increase_percent NUMERIC
)
    LANGUAGE plpgsql
AS $$
DECLARE
    r_product RECORD;
    v_new_price NUMERIC;
BEGIN
    FOR r_product IN
        SELECT product_id, price FROM Products WHERE category_id = p_category_id
        LOOP
            v_new_price := r_product.price * (1 + p_increase_percent / 100);

            UPDATE Products
            SET price = v_new_price
            WHERE product_id = r_product.product_id;

        END LOOP;

    RAISE NOTICE 'Đã cập nhật xong bằng vòng lặp cho category %', p_category_id;
END;
$$;