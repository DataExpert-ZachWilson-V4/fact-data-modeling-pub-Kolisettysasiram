INSERT INTO
  sasiram410.hosts_cumulated  -- Inserting data into the hosts_cumulated table
WITH
  -- CTE to fetch data for the previous day (2022-12-31)
  yesterday AS (
    SELECT
      *
    FROM
      sasiram410.hosts_cumulated
    WHERE
      DATE = DATE('2022-12-31')  -- Selecting data for the previous day
  ),
  -- CTE to fetch data for the current day (2023-01-01)
  today AS (
    SELECT
      host,                                    -- Selecting the host name
      CAST(date_trunc('day', event_time) AS DATE) AS event_date,  -- Truncating event_time to get the event_date
      COUNT(1) AS activity_count              -- Counting the number of events for each host and date
    FROM
      bootcamp.web_events
    WHERE
      date_trunc('day', event_time) = DATE('2023-01-01')  -- Selecting data for the current day
    GROUP BY
      host, CAST(date_trunc('day', event_time) AS DATE)  -- Grouping by host and event date
  )
-- Main query to insert aggregated data into hosts_cumulated table
SELECT
  COALESCE(y.host, t.host) AS host,  -- Handling NULL values with COALESCE
  CASE
    -- If host was active yesterday, append yesterday's activity dates to today's activity list
    WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.event_date] || y.host_activity_datelist
    ELSE ARRAY[t.event_date]  -- If host was not active yesterday, set today's date as the only activity date
  END AS host_activity_datelist,
  DATE('2023-01-01') AS DATE  -- Setting the date as 2023-01-01 for all records
FROM
  yesterday y
  FULL OUTER JOIN today t ON y.host = t.host
