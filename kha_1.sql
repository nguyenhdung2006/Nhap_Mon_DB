CREATE TABLE order_detail (
                              id SERIAL PRIMARY KEY,
                              order_id INT,
                              product_name VARCHAR(100),
                              quantity INT,
                              unit_price NUMERIC
);

INSERT INTO order_detail (order_id, product_name, quantity, unit_price) VALUES
                                                                            (101, 'Laptop Dell XPS 15', 1, 1500.00),
                                                                            (101, 'Chuột không dây Logitech', 2, 25.50),
                                                                            (102, 'Bàn phím cơ', 1, 120.00),
                                                                            (103, 'Màn hình LG 27 inch', 50, 300.00),
                                                                            (104, 'Tai nghe Bluetooth', 0, 50.00),
                                                                            (105, 'Sản phẩm tặng kèm', 1, 0.00),
                                                                            (106, NULL, 5, 10.00),
                                                                            (107, 'Cáp sạc USB-C', NULL, 15.00),
                                                                            (NULL, 'Sản phẩm mồ côi', 1, 100.00),
                                                                            (108, 'Ốp lưng điện thoại', 3, NULL);

CREATE OR REPLACE PROCEDURE calculate_order_total(
    order_id_input INT,
    OUT total NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT SUM(o.quantity * o.unit_price) INTO total
    FROM order_detail o
    WHERE o.order_id = order_id_input;

    if total IS NULL THEN
        total := 0;
    end if;
end;
$$;

DO $$
    DECLARE v_tong_tien_nhan NUMERIC;
BEGIN
    call calculate_order_total(101, v_tong_tien_nhan);

    Raise notice 'Tổng tiền của đơn hành số 101 là % VNĐ', v_tong_tien_nhan;
end;
$$;