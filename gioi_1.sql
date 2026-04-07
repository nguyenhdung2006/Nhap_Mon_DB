CREATE TABLE employees (
                           id SERIAL PRIMARY KEY,
                           name VARCHAR(100),
                           position VARCHAR(50),
                           salary NUMERIC
);

CREATE TABLE employees_log (
                               id SERIAL PRIMARY KEY,
                               employee_id INT,
                               operation VARCHAR(10),
                               old_data JSONB,
                               new_data JSONB,
                               change_time TIMESTAMP DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION log_employee_changes()
    RETURNS TRIGGER AS
$$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO employees_log(employee_id, operation, old_data, new_data)
        VALUES (
                   NEW.id,
                   'INSERT',
                   NULL,
                   to_jsonb(NEW)
               );

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO employees_log(employee_id, operation, old_data, new_data)
        VALUES (
                   NEW.id,
                   'UPDATE',
                   to_jsonb(OLD),
                   to_jsonb(NEW)
               );

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO employees_log(employee_id, operation, old_data, new_data)
        VALUES (
                   OLD.id,
                   'DELETE',
                   to_jsonb(OLD),
                   NULL
               );

        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_log_employee_changes
    AFTER INSERT OR UPDATE OR DELETE ON employees
    FOR EACH ROW
EXECUTE FUNCTION log_employee_changes();

INSERT INTO employees (name, position, salary)
VALUES ('An', 'Developer', 1000);

UPDATE employees
SET salary = 1200
WHERE name = 'An';

DELETE FROM employees
WHERE name = 'An';

SELECT * FROM employees_log;