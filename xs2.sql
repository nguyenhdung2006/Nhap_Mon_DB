CREATE OR REPLACE PROCEDURE calculate_bonus (
    p_emp_id INT ,
    p_percent NUMERIC,
    OUT p_bonus NUMERIC
)
LANGUAGE plpgsql
AS $$
    DECLARE v_salary NUMERIC(10,2);
    begin
        SELECT salary INTO v_salary
        FROM employees
        WHERE id = p_emp_id;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Employee not found';
        end if;

        IF p_percent <= 0 THEN
            p_bonus := 0;
        ELSE
            p_bonus := v_salary * p_percent / 100;
        END IF;

        UPDATE employees
        SET bonus = p_bonus
        WHERE id = p_emp_id;
    end;
$$;