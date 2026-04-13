CREATE TABLE employees (
    id serial primary key ,
    name varchar(255) not null ,
    position varchar(50) not null ,
    salary decimal(10, 2) not null
);

CREATE TABLE employees_log (
    employee_id int not null,
    CONSTRAINT fk_employees_log_employee_id FOREIGN KEY (employee_id) REFERENCES employees(id) ,
    operation text not null , -- action
    old_data TEXT ,
    new_data TEXT ,
    change_time timestamp DEFAULT current_timestamp(0)
);

CREATE OR REPLACE FUNCTION ghi_log()
RETURNS TRIGGER AS $$
    BEGIN
        INSERT INTO employees_log(employee_id, operation, new_data)
        values (new.id,'INSERT', to_json(NEW)::text);

        return new;
    END;
$$ language plpgsql;

CREATE OR REPLACE TRIGGER trg_ghi_log
    AFTER INSERT
    ON employees
    FOR EACH ROW
    EXECUTE FUNCTION ghi_log();

INSERT INTO employees(id, name, position, salary)
VALUES (1, 'dung', 'giám đốc', 10000);

