CREATE OR REPLACE TABLE sasiram410.host_activity_reduced (
  host VARCHAR,                   -- Host name
  metric_name VARCHAR,            -- Name of the metric
  metric_array ARRAY(INTEGER),    -- Array of metric values
  month_start VARCHAR             -- Start date of the month
)
WITH
(
  FORMAT = 'PARQUET',                     -- Storage format: Parquet
  partitioning = ARRAY['metric_name', 'month_start']  -- Partitioned by 'metric_name' column and 'month_start' column
)
