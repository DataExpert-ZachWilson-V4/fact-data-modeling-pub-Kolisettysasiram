INSERT INTO
  sasiram410.user_devices_cumulated  -- Inserting data into the user_devices_cumulated table
WITH
  -- CTE to fetch data for the previous day (2022-12-31)
  yesterday AS (
    SELECT
      *
    FROM
      sasiram410.user_devices_cumulated
    WHERE
      DATE = DATE('2022-12-31')  -- Selecting data for the previous day
  ),
  -- CTE to fetch data for the current day (2023-01-01)
  today AS (
    SELECT
      w.user_id as user_id,
      d.browser_type as browser_type,
      CAST(date_trunc('day', w.event_time) AS DATE) AS event_date,
      COUNT(1)
    FROM
      bootcamp.web_events w JOIN bootcamp.devices d ON w.device_id = d.device_id
    WHERE
      date_trunc('day', w.event_time) = DATE('2023-01-01')  -- Selecting data for the current day
    GROUP BY
      w.user_id,
      d.browser_type,
      CAST(date_trunc('day', w.event_time) AS DATE)
   )
-- Main query to insert aggregated data into user_devices_cumulated table
SELECT
  COALESCE(y.user_id, t.user_id) AS user_id,  -- Using COALESCE to handle NULL values
  COALESCE(y.browser_type, t.browser_type) AS browser_type,
  -- If user was active yesterday, append yesterday's dates to today's dates_active array
  CASE
    WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active
    ELSE ARRAY[t.event_date]  -- If user was not active yesterday, set today's date as the only active date
  END AS dates_active,
  DATE('2023-01-01') AS DATE  -- Setting the date as 2023-01-01 for all records
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.user_id = t.user_id AND y.browser_type = t.browser_type
