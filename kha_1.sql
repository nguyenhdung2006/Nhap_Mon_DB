CREATE TABLE flights (
    flight_id SERIAL PRIMARY KEY ,
    flight_name varchar(100) ,
    avaiable_seats INT
);

CREATE TABLE bookings (
    booking_id SERIAL primary key ,
    flight_id INT REFERENCES flights(flight_id),
    customer_name varchar(100)
);

-- 1.
INSERT INTO flights(flight_name, avaiable_seats)
VALUES ('VN123', 3) , ('VN456', 2);

BEGIN;
    -- xóa, giảm số ghế chuyến bay
    UPDATE flights
    SET avaiable_seats = avaiable_seats - 1
    WHERE flight_name = 'VN123';

    -- thêm bản ghi đặt vé của khách hàng 'Nguyen Van A
    INSERT INTO bookings(booking_id, flight_id, customer_name)
    VALUES (1, 1, 'Nguyen Van A');
COMMIT;

-- 2.
BEGIN;

-- giảm ghế (tạm thời)
UPDATE flights
SET avaiable_seats = avaiable_seats - 1
WHERE flight_name = 'VN123';

-- cố tình sai flight_id (3 không tồn tại)
INSERT INTO bookings(flight_id, customer_name)
VALUES (3, 'Nguyen Van A');

-- rollback toàn bộ
ROLLBACK;

SELECT * FROM flights;

