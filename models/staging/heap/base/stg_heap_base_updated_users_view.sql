{{
  config(
    materialized='view'
  )
}}

SELECT 
    DISTINCT h.heap_user_id
  , h.dbt_last_run_start
FROM {{ ref('base_heap_user_update_history') }} h
-- Look for users that have been updated during this run
WHERE h.dbt_last_run_start) = {{ run_started_at }}