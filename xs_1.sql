CREATE TABLE employees (
                           id SERIAL PRIMARY KEY,
                           name VARCHAR(100) NOT NULL,
                           department VARCHAR(50),
                           salary NUMERIC(10,2),
                           bonus NUMERIC(10,2) DEFAULT 0
);

INSERT INTO employees (name, department, salary) VALUES
                                                     ('Nguyen Van A', 'HR', 4000),
                                                     ('Tran Thi B', 'IT', 6000),
                                                     ('Le Van C', 'Finance', 10500),
                                                     ('Pham Thi D', 'IT', 8000),
                                                     ('Do Van E', 'HR', 12000);

CREATE OR REPLACE PROCEDURE update_employee_status(
    p_emp_id INT,
    p_status TEXT
)
LANGUAGE plpgsql
AS $$
    DECLARE v_salary NUMERIC(10, 2);
    BEGIN
        SELECT e.salary INTO v_salary
        FROM employees e
        WHERE e.id = p_emp_id;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Employee not found';
        end if;

        IF v_salary < 5000 AND v_salary >= 0 THEN
            p_status := 'Junior';
        ELSIF v_salary <= 10000 AND v_salary >= 5000 THEN
            p_status := 'Mid-level';
        ELSE
            p_status := 'Senior';
        end if;

        UPDATE employees
        SET status = p_status
        WHERE id = p_emp_id;
    end;
$$;

ALTER Table employees
ADD column status VARCHAR(20) DEFAULT NULL;