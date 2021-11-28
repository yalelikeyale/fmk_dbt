{{
    config(
        materialized='incremental',
        unique_key='heap_user_id'
    )
}}

WITH
    heap_active_users
        AS 
            (
                SELECT DISTINCT s.heap_user_id
                FROM {{ ref('src_heap_sessions') }} s 
                {% if is_incremental() %} 
                    WHERE s.heap_session_start > (SELECT MAX(t.dbt_last_run_start) FROM {{ this }} t)
                {% endif %}
            ),
    -- FIND USERS WHO HAVE BEEN UPDATED SINCE THE LAST RUN
    heap_updated_users
        AS 
            (
                SELECT DISTINCT u.heap_user_id 
                FROM {{ ref('src_heap_users') }} u 
                {% if is_incremental() %} 
                    WHERE u.heap_user_last_updated > (SELECT MAX(t.dbt_last_run_start) FROM {{ this }} t)
                {% endif %}
            )

-- Grab all user ids that have had a session or been updated since the last run of
SELECT
    COALESCE(au.heap_user_id, uu.heap_user_id) as heap_user_id
  , {{ run_started_at }} AS dbt_last_run_start

FROM heap_active_users au
FULL OUTER JOIN heap_updated_users uu 
    USING(heap_user_id)