CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(50)
);

CREATE TABLE customer_log (
    log_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(50),
    action_time TIMESTAMP
);

CREATE OR REPLACE FUNCTION log_customer_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO customer_log(customer_name, action_time)
    VALUES (NEW.name, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_after_insert_customer
AFTER INSERT ON customers
FOR EACH ROW
EXECUTE FUNCTION log_customer_insert();

INSERT INTO customers(name, email) VALUES ('Nguyen Van A', 'a@gmail.com');
INSERT INTO customers(name, email) VALUES ('Tran Thi B', 'b@gmail.com');

SELECT * FROM customer_log;
