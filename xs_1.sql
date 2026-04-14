CREATE TABLE customers (
    id serial primary key ,
    name varchar(255) not null ,
    email VARCHAR(255) UNIQUE NOT NULL ,
    phone VARCHAR(16) CHECK (phone ~ '^\+[1-9][0-9]{7,14}$') ,
    address VARCHAR(255)
);

CREATE TABLE customers_log (
    customer_id int ,
    CONSTRAINT fk_customers_log_customers FOREIGN KEY (customer_id) REFERENCES customers(id) ,
    operation text not null ,
    old_data TEXT ,
    new_data TEXT ,
    changed_by varchar(255) ,
    change_time timestamp DEFAULT current_timestamp(0)
);

CREATE OR REPLACE FUNCTION log_customers_changes()
RETURNS TRIGGER AS $$
begin
    IF TG_OP = 'INSERT' THEN
        INSERT INTO customers_log (customer_id, operation, old_data, new_data, changed_by, change_time)
        VALUES (NEW.id,TG_OP,NULL,ROW(NEW.*)::text,current_user,current_timestamp(0));

        RETURN NEW;
    END IF;
    IF TG_OP = 'UPDATE' THEN
        INSERT INTO customers_log (customer_id,operation,old_data,new_data,changed_by,change_time)
        VALUES (NEW.id,TG_OP,ROW(OLD.*)::text,ROW(NEW.*)::text,current_user,now());
        RETURN NEW;
    END IF;
    IF TG_OP = 'DELETE' THEN
        INSERT INTO customers_log (customer_id,operation,old_data,new_data,changed_by,change_time)
        VALUES (OLD.id,TG_OP,ROW(OLD.*)::text,NULL,current_user,now());
        RETURN OLD;
    END IF;

    RETURN NULL;
end;
$$ language plpgsql;

CREATE OR REPLACE TRIGGER trg_log_customers_changes
    AFTER INSERT OR UPDATE OR DELETE ON customers
    FOR EACH ROW
EXECUTE FUNCTION log_customers_changes();


