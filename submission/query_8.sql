INSERT INTO
  sasiram410.host_activity_reduced  -- Inserting data into the host_activity_reduced table
WITH
  -- CTE to fetch data for the previous month start (2023-08-01)
  yesterday AS (
    SELECT
      host,                      -- Host Name
      metric_name,               -- Name of the metric
      metric_array,              -- Array of metric values
      month_start                -- Start month of the metric data
    FROM
      sasiram410.host_activity_reduced
    WHERE
      month_start = '2023-08-01' -- Filtering for the start of the month
  ),
  -- CTE to fetch data for the current day (2023-08-02)
  today AS (
    SELECT
      host,                      -- Host Name
      metric_name,               -- Name of the metric
      metric_value,              -- Value of the metric for the current day
      DATE                      -- Current date
    FROM
      sasiram410.daily_web_metrics
    WHERE
      DATE = DATE('2023-08-02')  -- Filtering for the current date
  )
-- Main query to insert data in the host_activity_reduced table
SELECT
  COALESCE(t.host, y.host) AS host,  -- Handling NULL values with COALESCE to get the host ID
  COALESCE(t.metric_name, y.metric_name) AS metric_name,  -- Handling NULL values with COALESCE to get the metric name
  -- Updating or creating the metric_array
  COALESCE(
    y.metric_array,  -- If the metric_array exists from yesterday
    -- If not, create an array of NULLs with length based on the difference in days
    REPEAT(
      NULL,
      CAST(
        DATE_DIFF('day', DATE('2023-08-01'), t.date) AS INTEGER
      )
    )
  ) || ARRAY[t.metric_value] AS metric_array,  -- Append today's metric_value to the metric_array
  '2023-08-01' AS month_start  -- Keeping the month_start as 2023-08-01 for consistency
FROM
  today t
  FULL OUTER JOIN yesterday y ON t.host = y.host  
  AND t.metric_name = y.metric_name  -- Joining today's and yesterday's data on host and metric_name
