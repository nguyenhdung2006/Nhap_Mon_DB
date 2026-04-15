-- I.
CREATE TABLE Customer (
    customer_id VARCHAR(5) PRIMARY KEY ,
    customer_full_name VARCHAR(100) NOT NULL ,
    customer_email VARCHAR(100) NOT NULL UNIQUE ,
    customer_phone VARCHAR(15) NOT NULL ,
    customer_address VARCHAR(255) NOT NULL
);

CREATE TABLE Room (
    room_id VARCHAR(5) PRIMARY KEY ,
    room_type VARCHAR(50) NOT NULL ,
    room_price DECIMAL(10, 2) NOT NULL ,
    room_status VARCHAR(20) NOT NULL ,
    room_area DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Booking (
    booking_id SERIAL PRIMARY KEY ,
    customer_id VARCHAR(5) NOT NULL ,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ,
    room_id VARCHAR(5) NOT NULL ,
    FOREIGN KEY (room_id) REFERENCES Room(room_id) ,
    check_in_date DATE NOT NULL ,
    check_out_date DATE NOT NULL ,
    total_amount DECIMAL(10, 2)
);

CREATE TABLE Payment (
    payment_id SERIAL PRIMARY KEY ,
    booking_id INT NOT NULL ,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id) ,
    payment_method VARCHAR(50) NOT NULL ,
    payment_date DATE NOT NULL ,
    payment_amount DECIMAL(10, 2) NOT NULL
);

INSERT INTO Customer (customer_id, customer_full_name, customer_email, customer_phone, customer_address)
VALUES
    ('C001', 'Nguyen Anh Tu', 'tu.nguyen@example.com', '0912345678', 'Hanoi, Vietnam'),
    ('C002', 'Tran Thi Mai', 'mai.tran@example.com', '0923456789', 'Ho Chi Minh, Vietnam'),
    ('C003', 'Le Minh Hoang', 'hoang.le@example.com', '0934567890', 'Danang, Vietnam'),
    ('C004', 'Pham Hoang Nam', 'nam.pham@example.com', '0945678901', 'Hue, Vietnam'),
    ('C005', 'Vu Minh Thu', 'thu.vu@example.com', '0956789012', 'Hai Phong, Vietnam'),
    ('C006', 'Nguyen Thi Lan', 'lan.nguyen@example.com', '0967890123', 'Quang Ninh, Vietnam'),
    ('C007', 'Bui Minh Tuan', 'tuan.bui@example.com', '0978901234', 'Bac Giang, Vietnam'),
    ('C008', 'Pham Quang Hieu', 'hieu.pham@example.com', '0989012345', 'Quang Nam, Vietnam'),
    ('C009', 'Le Thi Lan', 'lan.le@example.com', '0990123456', 'Da Lat, Vietnam'),
    ('C010', 'Nguyen Thi Mai', 'mai.nguyen@example.com', '0901234567', 'Can Tho, Vietnam');

INSERT INTO Room (room_id, room_type, room_price, room_status, room_area)
VALUES
    ('R001', 'Single', 100.0, 'Available', 25),
    ('R002', 'Double', 150.0, 'Booked', 40),
    ('R003', 'Suite', 250.0, 'Available', 60),
    ('R004', 'Single', 120.0, 'Booked', 30),
    ('R005', 'Double', 160.0, 'Available', 35);

INSERT INTO Booking (booking_id, customer_id, room_id, check_in_date, check_out_date, total_amount)
VALUES
    (1, 'C001', 'R001', '2025-03-01', '2025-03-05', 400.0),
    (2, 'C002', 'R002', '2025-03-02', '2025-03-06', 600.0),
    (3, 'C003', 'R003', '2025-03-03', '2025-03-07', 1000.0),
    (4, 'C004', 'R004', '2025-03-04', '2025-03-08', 480.0),
    (5, 'C005', 'R005', '2025-03-05', '2025-03-09', 800.0),
    (6, 'C006', 'R001', '2025-03-06', '2025-03-10', 400.0),
    (7, 'C007', 'R002', '2025-03-07', '2025-03-11', 600.0),
    (8, 'C008', 'R003', '2025-03-08', '2025-03-12', 1000.0),
    (9, 'C009', 'R004', '2025-03-09', '2025-03-13', 480.0),
    (10, 'C010', 'R005', '2025-03-10', '2025-03-14', 800.0);

INSERT INTO Payment (payment_id, booking_id, payment_method, payment_date, payment_amount)
VALUES
    (1, 1, 'Cash', '2025-03-05', 400.0),
    (2, 2, 'Credit Card', '2025-03-06', 600.0),
    (3, 3, 'Bank Transfer', '2025-03-07', 1000.0),
    (4, 4, 'Cash', '2025-03-08', 480.0),
    (5, 5, 'Credit Card', '2025-03-09', 800.0),
    (6, 6, 'Bank Transfer', '2025-03-10', 400.0),
    (7, 7, 'Cash', '2025-03-11', 600.0),
    (8, 8, 'Credit Card', '2025-03-12', 1000.0),
    (9, 9, 'Bank Transfer', '2025-03-13', 480.0),
    (10, 10, 'Cash', '2025-03-14', 800.0);

-- 3.
UPDATE Booking b
SET total_amount = r.room_price * (b.check_out_date - b.check_in_date)
FROM Room r
WHERE b.room_id = r.room_id
    AND r.room_status = 'Booked'
    AND b.check_in_date < CURRENT_DATE;

-- 4.
DELETE FROM Payment
WHERE payment_method = 'Cash' AND payment.payment_amount < 500;

-- II.

-- 5.
SELECT customer_id, customer_full_name, customer_email, customer_phone, customer_address
FROM Customer
ORDER BY customer_full_name;

-- 6.
SELECT room_id, room_type, room_price, room_area
FROM Room
ORDER BY room_price DESC;

-- 7.
SELECT
    c.customer_id,
    c.customer_full_name,
    r.room_id,
    b.check_in_date,
    b.check_out_date
FROM Customer c
JOIN Booking B on c.customer_id = B.customer_id
JOIN Room r ON b.room_id = r.room_id;

-- 8.
SELECT
    c.customer_id,
    c.customer_full_name,
    p.payment_method,
    p.payment_amount
FROM Customer c
JOIN Booking b ON c.customer_id = b.customer_id
JOIN Payment p ON b.booking_id = p.booking_id
ORDER BY p.payment_amount DESC;

-- 9.
SELECT * FROM Customer
ORDER BY customer_full_name
OFFSET 1 LIMIT 3;

-- 10.
SELECT
    c.customer_id,
    c.customer_full_name,
    COUNT(b.room_id) AS so_luon_phong_dat
FROM Customer c
JOIN Booking b ON c.customer_id = b.customer_id
JOIN Payment p ON b.booking_id = p.booking_id
GROUP BY c.customer_id, c.customer_full_name
HAVING COUNT(b.room_id) >= 2
    AND SUM(p.payment_amount) > 1000;

-- 11.
SELECT
    r.room_id,
    r.room_type,
    r.room_price,
    SUM(p.payment_amount) AS tong_tien_thanh_toan
FROM Room r
JOIN Booking b ON r.room_id = b.room_id
JOIN Payment p ON b.booking_id = p.booking_id
GROUP BY r.room_id, r.room_type, r.room_price
HAVING SUM(p.payment_amount) < 1000
   AND COUNT(DISTINCT b.customer_id) >= 3;

-- 12.
SELECT
    c.customer_id,
    c.customer_full_name,
    b.room_id,
    SUM(p.payment_amount) AS tong_tien_thanh_toan
FROM Customer c
JOIN Booking b ON c.customer_id = b.customer_id
JOIN Payment p ON b.booking_id = p.booking_id
GROUP BY c.customer_id, c.customer_full_name, b.room_id
HAVING SUM(p.payment_amount) > 1000;

-- 13.
SELECT
    customer_id,
    customer_full_name,
    customer_email,
    customer_phone
FROM Customer
WHERE customer_full_name ILIKE '%Minh%'
   OR customer_address ILIKE '%Hanoi%'
ORDER BY customer_full_name;

-- 14.
SELECT
    room_id,
    room_type,
    room_price
FROM Room
ORDER BY room_price DESC
OFFSET 5 LIMIT 5;

-- III.

-- 15.
CREATE OR REPLACE VIEW vw_15 AS
    SELECT
        r.room_id,
        r.room_type,
        c.customer_id,
        c.customer_full_name
    FROM Booking b
    JOIN Customer c ON b.customer_id = c.customer_id
    JOIN Room r ON b.room_id = r.room_id
    WHERE b.check_in_date < DATE '2025-03-10';

-- 16.
CREATE OR REPLACE VIEW vw_16 AS
    SELECT
        c.customer_id,
        c.customer_full_name,
        r.room_id,
        r.room_area
    FROM Booking b
    JOIN Customer c ON b.customer_id = c.customer_id
    JOIN Room r ON b.room_id = r.room_id
    WHERE r.room_area > 30;

-- IV.

-- 17.
CREATE OR REPLACE FUNCTION check_insert_booking()
RETURNS TRIGGER AS $$
    begin
        IF NEW.check_in_date > NEW.check_out_date THEN
            RAISE EXCEPTION 'Ngày đặt phòng không thể sau ngày trả phòng được !';
        end if;

        RETURN NEW;
    end;
$$ language plpgsql;

CREATE OR REPLACE TRIGGER trigger_check_insert_booking
    BEFORE INSERT
    ON Booking
    FOR EACH ROW
    EXECUTE FUNCTION check_insert_booking();

-- 18.
CREATE OR REPLACE FUNCTION update_room_status_on_booking()
RETURNS TRIGGER AS $$
    begin
        UPDATE Room
        SET room_status = 'Booked'
        WHERE room_id = NEW.room_id;

        RETURN NEW;
    end;
$$ language plpgsql;

CREATE OR REPLACE TRIGGER trigger_update_room_status_on_booking
    AFTER INSERT
    ON Room
    FOR EACH ROW
    EXECUTE FUNCTION update_room_status_on_booking();

-- V.

-- 19.
CREATE OR REPLACE PROCEDURE add_customer (
    p_customer_id VARCHAR(5) ,
    p_customer_full_name VARCHAR(100) ,
    p_customer_email VARCHAR(100) ,
    p_customer_phone VARCHAR(15) ,
    p_customer_address VARCHAR(255)
)
AS $$
    begin
        INSERT INTO Customer (customer_id, customer_full_name, customer_email, customer_phone, customer_address)
        VALUES (p_customer_id, p_customer_full_name, p_customer_email, p_customer_phone, p_customer_address);
    end;
$$ language plpgsql;

-- 20.
CREATE OR REPLACE PROCEDURE add_payment (
    p_booking_id INT ,
    p_payment_method VARCHAR(50) ,
    p_payment_amount DECIMAL(10, 2) ,
    p_payment_date DATE
)
AS $$
    begin
        INSERT INTO Payment (booking_id, payment_method, payment_amount, payment_date)
        VALUES (p_booking_id,p_payment_method,p_payment_amount,p_payment_date);
    end;
$$ language plpgsql;