USE interswitch;

-- Show the total size of the database
SELECT 
  CONCAT(ROUND(SUM(data_length + index_length) / 1024 / 1024, 2), ' MB') AS `database_size`
FROM 
  information_schema.tables 
WHERE 
  table_schema = 'interswitch';

-- Show the size of each table in the database
SELECT 
  table_name AS `Table`,
  CONCAT(ROUND(data_length / 1024 / 1024, 2), ' MB') AS `Data Size`,
  CONCAT(ROUND(index_length / 1024 / 1024, 2), ' MB') AS `Index Size`
FROM 
  information_schema.tables
WHERE 
  table_schema = 'interswitch';

-- Show the top 10 queries by execution time
SELECT 
  query, 
  execution_count, 
  ROUND(total_latency / 1000000000000, 6) AS `Total Latency (s)`,
  ROUND(mean_latency / 1000000000000, 6) AS `Mean Latency (s)`
FROM 
  performance_schema.events_statements_summary_by_digest
WHERE 
  schema_name = 'interswitch'
ORDER BY 
  total_latency DESC 
LIMIT 10;

-- Show the current status of the database
SHOW STATUS LIKE 'Threads_connected';
SHOW STATUS LIKE 'Innodb_buffer_pool_size';
SHOW STATUS LIKE 'Innodb_buffer_pool_read_requests';
SHOW STATUS LIKE 'Innodb_buffer_pool_reads';
SHOW STATUS LIKE 'Innodb_buffer_pool_pages_flushed';
