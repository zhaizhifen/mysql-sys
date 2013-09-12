/* View: innodb_buffer_stats_by_table
 * 
 * Summarizes the output of the INFORMATION_SCHEMA.INNODB_BUFFER_PAGE 
 * table, aggregating by schema and table name
 *
 * mysql> select * from innodb_buffer_stats_by_table;
 * +---------------+-------------+-----------+-----------+-------+--------------+-----------+-------------+
 * | object_schema | object_name | allocated | data      | pages | pages_hashed | pages_old | rows_cached |
 * +---------------+-------------+-----------+-----------+-------+--------------+-----------+-------------+
 * | InnoDB System | SYS_FOREIGN | 32.00 KiB | 0 bytes   |     2 |            2 |         2 |           0 |
 * | InnoDB System | SYS_COLUMNS | 16.00 KiB | 501 bytes |     1 |            1 |         1 |           8 |
 * | InnoDB System | SYS_FIELDS  | 16.00 KiB | 203 bytes |     1 |            1 |         1 |           5 |
 * | InnoDB System | SYS_INDEXES | 16.00 KiB | 266 bytes |     1 |            1 |         1 |           4 |
 * | InnoDB System | SYS_TABLES  | 16.00 KiB | 149 bytes |     1 |            1 |         1 |           2 |
 * +---------------+-------------+-----------+-----------+-------+--------------+-----------+-------------+
 * 5 rows in set (2.16 sec)
 *
 * Versions: 5.5.28+
 */

DROP VIEW IF EXISTS innodb_buffer_stats_by_table;

CREATE SQL SECURITY INVOKER VIEW innodb_buffer_stats_by_table AS
SELECT IF(LOCATE('.', ibp.table_name) = 0, 'InnoDB System', REPLACE(SUBSTRING_INDEX(ibp.table_name, '.', 1), '`', '')) AS object_schema,
       REPLACE(SUBSTRING_INDEX(ibp.table_name, '.', -1), '`', '') AS object_name,
       format_bytes(SUM(IF(ibp.compressed_size = 0, 16384, compressed_size))) AS allocated,
       format_bytes(SUM(ibp.data_size)) AS data,
       COUNT(ibp.page_number) AS pages,
       COUNT(IF(ibp.is_hashed = 'YES', 1, 0)) AS pages_hashed,
       COUNT(IF(ibp.is_old = 'YES', 1, 0)) AS pages_old,
       ROUND(SUM(ibp.number_records)/COUNT(DISTINCT ibp.index_name)) AS rows_cached 
  FROM information_schema.innodb_buffer_page ibp 
 WHERE table_name IS NOT NULL
 GROUP BY object_schema, object_name
 ORDER BY SUM(IF(ibp.compressed_size = 0, 16384, compressed_size)) DESC;

/* View: innodb_buffer_stats_by_table_raw
 * 
 * Summarizes the output of the INFORMATION_SCHEMA.INNODB_BUFFER_PAGE 
 * table, aggregating by schema and table name
 *
 * mysql> select * from innodb_buffer_stats_by_table_raw;
 * +---------------+-------------+-----------+------+-------+--------------+-----------+-------------+
 * | object_schema | object_name | allocated | data | pages | pages_hashed | pages_old | rows_cached |
 * +---------------+-------------+-----------+------+-------+--------------+-----------+-------------+
 * | InnoDB System | SYS_FOREIGN |     32768 |    0 |     2 |            2 |         2 |           0 |
 * | InnoDB System | SYS_COLUMNS |     16384 |  501 |     1 |            1 |         1 |           8 |
 * | InnoDB System | SYS_FIELDS  |     16384 |  203 |     1 |            1 |         1 |           5 |
 * | InnoDB System | SYS_INDEXES |     16384 |  266 |     1 |            1 |         1 |           4 |
 * | InnoDB System | SYS_TABLES  |     16384 |  149 |     1 |            1 |         1 |           2 |
 * +---------------+-------------+-----------+------+-------+--------------+-----------+-------------+
 * 5 rows in set (1.80 sec)
 *
 * Versions: 5.5.28+
 */

DROP VIEW IF EXISTS innodb_buffer_stats_by_table_raw;

CREATE SQL SECURITY INVOKER VIEW innodb_buffer_stats_by_table_raw AS
SELECT IF(LOCATE('.', ibp.table_name) = 0, 'InnoDB System', REPLACE(SUBSTRING_INDEX(ibp.table_name, '.', 1), '`', '')) AS object_schema,
       REPLACE(SUBSTRING_INDEX(ibp.table_name, '.', -1), '`', '') AS object_name,
       SUM(IF(ibp.compressed_size = 0, 16384, compressed_size)) AS allocated,
       SUM(ibp.data_size) AS data,
       COUNT(ibp.page_number) AS pages,
       COUNT(IF(ibp.is_hashed = 'YES', 1, 0)) AS pages_hashed,
       COUNT(IF(ibp.is_old = 'YES', 1, 0)) AS pages_old,
       ROUND(SUM(ibp.number_records)/COUNT(DISTINCT ibp.index_name)) AS rows_cached 
  FROM information_schema.innodb_buffer_page ibp 
 WHERE table_name IS NOT NULL
 GROUP BY object_schema, object_name
 ORDER BY SUM(IF(ibp.compressed_size = 0, 16384, compressed_size)) DESC;