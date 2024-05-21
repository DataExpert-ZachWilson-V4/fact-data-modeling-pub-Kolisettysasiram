WITH
  -- CTE to select data for the current date (2023-01-07)
  today AS (
    SELECT
      user_id,
      browser_type,
      dates_active,
      date
    FROM
      sasiram410.user_devices_cumulated
    WHERE
      date = DATE('2023-01-07')  -- Selecting data for the specified date
  ),
  -- CTE to calculate the integer representation of the user's activity history
  date_list_int AS (
    SELECT
      user_id,
      browser_type,
      CAST(
        SUM(
          CASE
            -- Calculating the integer representation of activity history using bitwise operations
            WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 31 - DATE_DIFF('day', sequence_date, date))
            ELSE 0
          END
        ) AS BIGINT
      ) AS history_int
    FROM
      today
      -- Generating a sequence of dates from 2023-01-01 to 2023-01-07
      CROSS JOIN UNNEST (SEQUENCE(DATE('2023-01-01'), DATE('2023-01-07'))) AS t (sequence_date)
    GROUP BY
      user_id,
      browser_type
  )
-- Selecting user_id, browser_type, activity history as integer, and activity history in binary
SELECT
  user_id,
  browser_type,
  history_int,
  TO_BASE(history_int, 2) AS history_in_binary  -- Converting activity history to binary
FROM
  date_list_int
