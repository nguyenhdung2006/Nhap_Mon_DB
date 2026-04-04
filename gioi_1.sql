CREATE TABLE employees (
                           emp_id SERIAL PRIMARY KEY,
                           emp_name VARCHAR(100),
                           job_level INT,
                           salary NUMERIC
);

INSERT INTO employees (emp_name, job_level, salary)
VALUES ('Nguyễn Văn A', 3, 1500.50);

INSERT INTO employees (emp_name, job_level, salary)
VALUES
    ('Trần Thị B', 2, 1200.00),
    ('Lê Văn C', 5, 2500.00),
    ('Phạm Minh D', 1, 800.00);

INSERT INTO employees (emp_name, job_level)
VALUES ('Hoàng Thị E', 4);

INSERT INTO employees (emp_name, salary)
VALUES ('Ngô Văn F', 1800.00);

INSERT INTO employees (emp_name, job_level, salary)
VALUES ('Lý Thị G', NULL, NULL);

CREATE OR REPLACE PROCEDURE adjust_salary(
    p_emp_id INT,
    OUT p_new_salary NUMERIC
)
LANGUAGE plpgsql
AS $$
    DECLARE
        v_salary NUMERIC;
        v_job_level INT;
   BEGIN
    SELECT
        e.job_level,
        e.salary
    INTO
        v_job_level,
        v_salary
    FROM employees e
    WHERE e.emp_id = p_emp_id;
    RAISE NOTICE 'emp_id = %, job_level = %, salary = %', p_emp_id, v_job_level, v_salary;

    IF v_job_level IS NULL THEN
        RAISE NOTICE 'Không có dữ liệu hoặc job_level NULL';
    ELSIF v_job_level = 1 THEN
        v_salary := v_salary * 1.05;
    ELSIF v_job_level = 2 THEN
        v_salary := v_salary * 1.1;
    ELSIF v_job_level = 3 THEN
        v_salary := v_salary * 1.15;
    ELSE
        RAISE NOTICE 'Không thay đổi';
    end if;

    UPDATE employees
    SET salary = v_salary
    WHERE emp_id = p_emp_id;

    p_new_salary := v_salary;
   end;
$$;

DO $$
    DECLARE
        v_id INT := 1;
        v_new_salary NUMERIC;
    BEGIN
       CALL adjust_salary(v_id, v_new_salary);
       Raise notice 'Lương mới là %', v_new_salary;
    END;
$$;