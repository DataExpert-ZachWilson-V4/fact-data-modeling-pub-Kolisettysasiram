CREATE OR REPLACE TABLE sasiram410.user_devices_cumulated (
  user_id BIGINT,                -- User ID as a big integer
  browser_type VARCHAR,          -- Type of browser used by the user
  dates_active ARRAY(DATE),      -- Array of dates the user was active
  date DATE                      -- Date of record activity
)
WITH (
  FORMAT = 'PARQUET',            -- Storage format as Parquet
  partitioning = ARRAY['date']   -- Partitioned by the 'date' column
)
