CREATE TABLE products (
    id serial primary key ,
    name varchar(255) not null ,
    stock int not null
);

CREATE TYPE status AS ENUM (
    'pending',
    'confirmed',
    'shipped',
    'cancelled' ,
    'delivered' ,
    'received'
);

CREATE TABLE orders (
    id serial primary key ,
    product_id int not null ,
    CONSTRAINT fk_orders_products FOREIGN KEY (product_id) REFERENCES products(id) ,
    quantity int NOT NULL CHECK (quantity > 0) ,
    order_status status DEFAULT 'pending'
);

CREATE TABLE orders_log (
                            id serial primary key,
                            order_id int,
                            product_id int,
                            operation varchar(10),
                            old_data text,
                            new_data text,
                            changed_by text,
                            change_time timestamp default now()
);

CREATE OR REPLACE FUNCTION log_products_changes()
RETURNS TRIGGER AS $$
    declare
        v_stock int;
    begin
        SELECT stock into v_stock
        From products
        Where id = NEW.product_id
        FOR UPDATE;

        IF v_stock IS NULL THEN
            RAISE EXCEPTION 'product không tồn tại';
        END IF;

        IF TG_OP = 'INSERT' THEN
            IF v_stock < NEW.quantity THEN
                RAISE EXCEPTION 'không đủ số lương sản phẩm: chỉ còn % sản phẩm.', v_stock;
            end if;

            UPDATE products
            SET stock = stock - NEW.quantity
            WHERE id = NEW.product_id;

            INSERT INTO orders_log(product_id, order_id, operation, old_data, new_data, changed_by, change_time)
            VALUES (NEW.product_id, NEW.id, TG_OP, null, to_json(NEW)::text, current_user, current_timestamp);

            RETURN NEW;
        end if;

        IF TG_OP = 'UPDATE' THEN
            IF v_stock + OLD.quantity < NEW.quantity THEN
                RAISE EXCEPTION 'không đủ số lương sản phẩm: chỉ còn % sản phẩm.', v_stock;
            end if;

            UPDATE products
            SET stock = stock - (NEW.quantity - OLD.quantity)
            WHERE id = NEW.product_id;

            INSERT INTO orders_log(product_id, order_id, operation, old_data, new_data, changed_by, change_time)
            VALUES (NEW.product_id, NEW.id, TG_OP, to_json(OLD)::text, to_json(NEW)::text, current_user, current_timestamp);

            RETURN NEW;
        end if;

        IF TG_OP = 'DELETE' THEN
            UPDATE products
            SET stock = stock + OLD.quantity
            WHERE id = OLD.product_id;

            INSERT INTO orders_log(product_id, order_id, operation, old_data, new_data, changed_by, change_time)
            VALUES (OLD.product_id, OLD.id, TG_OP, to_json(OLD)::text, NULL, current_user, current_timestamp);

            RETURN OLD;
        end if;

        RETURN NULL;
    end;
$$ language plpgsql;

CREATE OR REPLACE TRIGGER trg_log_products_changes
    BEFORE INSERT OR UPDATE
    ON orders
    FOR EACH ROW
EXECUTE FUNCTION log_products_changes();

CREATE OR REPLACE TRIGGER trg_log_products_changes
    AFTER DELETE
    ON orders
    FOR EACH ROW
EXECUTE FUNCTION log_products_changes();
