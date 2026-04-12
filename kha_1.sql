CREATE table products (
    id serial primary key ,
    name varchar(255) not null,
    price numeric(10, 2) not null,
    last_modified timestamp not null default now()
);

CREATE OR REPLACE FUNCTION trg_update_last_modified()
RETURNS TRIGGER AS $$
    BEGIN
        new.last_modified = now();
        return new;
    end;
$$ language plpgsql;

CREATE OR REPLACE TRIGGER update_last_modified_trigger
BEFORE UPDATE
ON products
FOR EACH ROW
EXECUTE FUNCTION update_last_modified();

Update products
SET price = 3000
WHERE name ='Iphone 15';
