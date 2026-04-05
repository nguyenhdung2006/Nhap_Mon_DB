CREATE OR REPLACE PROCEDURE calculate_total_sales(
    start_date DATE,
    end_date DATE,
    OUT total NUMERIC
)
    LANGUAGE plpgsql
AS $$
BEGIN
    SELECT COALESCE(SUM(amount), 0)
    INTO total
    FROM Sales
    WHERE sale_date BETWEEN start_date AND end_date;
END;
$$;