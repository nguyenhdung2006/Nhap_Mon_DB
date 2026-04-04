CREATE TABLE inventory (
                           product_id SERIAL PRIMARY KEY,
                           product_name VARCHAR(100),
                           quantity INT
);

INSERT INTO inventory (product_name, quantity)
VALUES
    ('Laptop Dell XPS 15', 50),
    ('Chuột Logitech Master 3', 150),
    ('Bàn phím cơ Keychron K2', 3),
    ('Tai nghe Sony WH-1000XM5', 0),
    ('Màn hình LG 27 inch', -5);

CREATE OR REPLACE PROCEDURE check_stock(
    p_id INT, -- Tham số 1: Mã sản phẩm khách mua
    p_qty INT -- Tham số 2: Số lượng khách muốn mua
)
LANGUAGE plpgsql
AS $$
    DECLARE
        v_ton_kho INT; --so luong hang ton kho
BEGIN
    SELECT i.quantity INTO v_ton_kho
    FROM inventory i
    WHERE i.product_id = p_id;

    IF v_ton_kho < p_qty OR v_ton_kho IS NULL THEN
        RAISE EXCEPTION 'Kho đang có %, khách muốn mua %. Số lượng thiếu là % .',
                        COALESCE(v_ton_kho, 0),
                        p_qty,
                        (p_qty - COALESCE(v_ton_kho, 0));
    end if;

end;
$$;

DO $$
    DECLARE
        v_quantity_1 INT := 49;
        v_quantity_2 INT := 4;
BEGIN
    call check_stock(1, v_quantity_1);
    RAISE NOTICE 'Kiểm tra 1: Đủ số lượng, tổng số lượng khách mua là: %', v_quantity_1;

    BEGIN
        call check_stock(3, v_quantity_2);
        RAISE NOTICE 'Kiểm tra 2: Đủ hàng.';
        Exception WHEN OTHERS THEN
        RAISE NOTICE 'KIỂM TRA 2 THẤT BẠI: %', SQLERRM;
    end;
    RAISE NOTICE 'Kết thúc toàn bộ quá trình kiểm tra!';
END ;
$$;