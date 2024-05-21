CREATE OR REPLACE TABLE sasiram410.hosts_cumulated (
  host VARCHAR,                          -- Host name
  host_activity_datelist ARRAY(DATE),    -- Array of dates representing host activity
  date DATE                              -- Date for partitioning
)
WITH
(
FORMAT = 'PARQUET',                      -- Storage format: Parquet
partitioning = ARRAY['date']             -- Partitioned by date
)
