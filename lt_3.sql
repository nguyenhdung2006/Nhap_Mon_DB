CREATE INDEX idx_products_category_id ON products(category_id);
cluster products using idx_products_category_id;

CREATE INDEX idx_products_price ON products(price);

SELECT * FROM Products WHERE category_id = 45 ORDER BY price;

-- cách index hỗ trợ:
-- lọc theo category_id: dữ liệu cùng category_id nằm gần nhau và DB chỉ đọc 1 đoạn liên tục
-- sắp xếp theo price: có index price giúp -> lấy giữ liệu đã có thứ tự -> khong tốn time sort