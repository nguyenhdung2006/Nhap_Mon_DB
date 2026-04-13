BEGIN;

UPDATE flights 
SET available_seats = available_seats - 1 
WHERE flight_name = 'VN123';

INSERT INTO bookings (flight_id, customer_name) 
VALUES ((SELECT flight_id FROM flights WHERE flight_name = 'VN123'), 'Nguyen Van A');

COMMIT;

SELECT * FROM flights;
SELECT * FROM bookings;

BEGIN;

UPDATE flights 
SET available_seats = available_seats - 1 
WHERE flight_name = 'VN123';

INSERT INTO bookings (flight_id, customer_name) 
VALUES (346, 'Khach Hang Loi'); 

ROLLBACK;

SELECT * FROM flights WHERE flight_name = 'VN123';
