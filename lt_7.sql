CREATE OR REPLACE PROCEDURE add_order(
    p_customer_id INT,
    p_amount NUMERIC
)
LANGUAGE plpgsql
AS $$
    begin
        PERFORM 1
        FROM customers c
        WHERE c.customer_id = p_customer_id;
        IF NOT FOUND THEN
            Raise Exception 'Không tìm thấy đơn hàng nào cho khách hàng ID: %', p_customer_id;
        else
            INSERT INTO orders (customer_id, amount) VALUES (p_customer_id, p_amount);
        end if;
    end;
$$;