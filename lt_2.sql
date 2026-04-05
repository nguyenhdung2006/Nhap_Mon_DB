CREATE INDEX idx_hash_users_email ON users USING hash(email);

EXPLAIN SELECT * FROM Users WHERE email = 'user500@example.com';