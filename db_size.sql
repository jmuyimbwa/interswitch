USE interswitch;

-- Create a new table to store archived transactions
CREATE TABLE IF NOT EXISTS archived_transactions (
  transaction_id INT PRIMARY KEY,
  user_id INT,
  amount DECIMAL(10,2),
  transaction_date TIMESTAMP,
  description VARCHAR(255)
);

-- Move transactions older than 36 months to the archive table
INSERT INTO archived_transactions (transaction_id, user_id, amount, transaction_date, description)
SELECT transaction_id, user_id, amount, transaction_date, description
FROM transactions
WHERE transaction_date < DATE_SUB(NOW(), INTERVAL 36 MONTH);

-- Delete archived transactions from the transactions table
DELETE FROM transactions
WHERE transaction_date < DATE_SUB(NOW(), INTERVAL 36 MONTH);

-- Optimize the table to reclaim disk space
OPTIMIZE TABLE transactions;

-- Show the total size of the database after archiving
SELECT 
  CONCAT(ROUND(SUM(data_length + index_length) / 1024 / 1024, 2), ' MB') AS `database_size`
FROM 
  information_schema.tables 
WHERE 
  table_schema = 'interswitch';
