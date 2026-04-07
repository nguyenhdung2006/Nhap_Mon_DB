CREATE OR REPLACE PROCEDURE add_order_and_update_customer(
    p_customer_id INT,
    p_amount NUMERIC
)
AS $$
    DECLARE v_total_spent NUMERIC;
    begin
        Perform 1
        FROM Customers
        WHERE customer_id = p_customer_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Customer with ID % does not exist', p_customer_id;
    END IF;
    insert into orders(customer_id, total_amount) VALUES (p_customer_id,p_amount);
    Select c.total_spent into v_total_spent
    From Customers c
    Where c.customer_id = p_customer_id;

    UPDATE Customers
    SET total_spent = v_total_spent + p_amount
    WHERE customer_id = p_customer_id;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Insert Failed: %', SQLERRM;
    end;

$$ Language plpgsql;

CALL add_order_and_update_customer(1, 500);
SELECT * FROM Orders;
SELECT * FROM customers;