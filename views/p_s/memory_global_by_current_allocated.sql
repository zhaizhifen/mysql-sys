/* 
 * View: memory_global_by_current_allocated
 * 
 * Shows the current memory usage within the server globally broken down by allocation type
 *
 * mysql> select * from memory_global_by_current_allocated;
 * +----------------------------------------+---------------+---------------+-------------------+------------+------------+----------------+
 * | event_name                             | current_count | current_alloc | current_avg_alloc | high_count | high_alloc | high_avg_alloc |
 * +----------------------------------------+---------------+---------------+-------------------+------------+------------+----------------+
 * | memory/sql/TABLE_SHARE::mem_root       |           269 | 568.21 KiB    | 2.11 KiB          |        339 | 706.04 KiB | 2.08 KiB       |
 * | memory/sql/TABLE                       |           214 | 366.56 KiB    | 1.71 KiB          |        245 | 481.13 KiB | 1.96 KiB       |
 * | memory/sql/sp_head::main_mem_root      |            32 | 334.97 KiB    | 10.47 KiB         |        421 | 9.73 MiB   | 23.66 KiB      |
 * | memory/sql/Filesort_buffer::sort_keys  |             1 | 255.89 KiB    | 255.89 KiB        |          1 | 256.00 KiB | 256.00 KiB     |
 * | memory/mysys/array_buffer              |            82 | 121.66 KiB    | 1.48 KiB          |       1124 | 852.55 KiB | 777 bytes      |
 * ...
 * +----------------------------------------+---------------+---------------+-------------------+------------+------------+----------------+
 * 26 rows in set (0.30 sec)
 *
 * Versions: 5.7.2+
 */

DROP VIEW IF EXISTS memory_global_by_current_allocated;

CREATE SQL SECURITY INVOKER VIEW memory_global_by_current_allocated AS
SELECT event_name,
       current_count_used AS current_count,
       format_bytes(current_number_of_bytes_used) AS current_alloc,
       format_bytes(current_number_of_bytes_used / current_count_used) AS current_avg_alloc,
       high_count_used AS high_count,
       format_bytes(high_number_of_bytes_used) AS high_alloc,
       format_bytes(high_number_of_bytes_used / high_count_used) AS high_avg_alloc
  FROM performance_schema.memory_summary_global_by_event_name
 WHERE current_number_of_bytes_used > 0
 ORDER BY current_number_of_bytes_used DESC;

/* 
 * View: memory_global_by_current_allocated_raw
 * 
 * Shows the current memory usage within the server globally broken down by allocation type
 *
 * mysql> select * from memory_global_by_current_allocated_raw;
 * +----------------------------------------+---------------+---------------+-------------------+------------+------------+----------------+
 * | event_name                             | current_count | current_alloc | current_avg_alloc | high_count | high_alloc | high_avg_alloc |
 * +----------------------------------------+---------------+---------------+-------------------+------------+------------+----------------+
 * | memory/sql/TABLE_SHARE::mem_root       |           270 |        582656 |         2157.9852 |        339 |     722984 |      2132.6962 |
 * | memory/sql/TABLE                       |           214 |        375353 |         1753.9860 |        245 |     492672 |      2010.9061 |
 * | memory/sql/sp_head::main_mem_root      |            32 |        343008 |        10719.0000 |        421 |   10200008 |     24228.0475 |
 * | memory/sql/Filesort_buffer::sort_keys  |             1 |        262036 |       262036.0000 |          1 |     262140 |    262140.0000 |
 * | memory/mysys/array_buffer              |            82 |        124576 |         1519.2195 |       1124 |     873008 |       776.6975 |
 * ...
 * +----------------------------------------+---------------+---------------+-------------------+------------+------------+----------------+
 * 26 rows in set (0.00 sec)
 *
 * Versions: 5.7.2+
 */

DROP VIEW IF EXISTS memory_global_by_current_allocated_raw;

CREATE SQL SECURITY INVOKER VIEW memory_global_by_current_allocated_raw AS
SELECT event_name,
       current_count_used AS current_count,
       current_number_of_bytes_used AS current_alloc,
       current_number_of_bytes_used / current_count_used AS current_avg_alloc,
       high_count_used AS high_count,
       high_number_of_bytes_used AS high_alloc,
       high_number_of_bytes_used / high_count_used AS high_avg_alloc
  FROM performance_schema.memory_summary_global_by_event_name
 WHERE current_number_of_bytes_used > 0
 ORDER BY current_number_of_bytes_used DESC;