-- post hook or something to drop users who've not been modified or had a session since the last run

{{
    config(
        materialized='incremental',
        unique_key='heap_user_id'
    )
}}

WITH
    -- FIND USERS WHO HAVE HAD A SESSION SINCE THE LAST RUN
    heap_active_users
        AS
            (
                SELECT
                    s.heap_user_id
                  , MIN(s.heap_session_start) as heap_user_earliest_session
                FROM {{ ref('src_heap_sessions') }} s
                {% if is_incremental() %}
                    WHERE s.heap_session_start > (SELECT MAX(t.heap_user_earliest_session) FROM {{ this }} t)
                {% endif %}
                GROUP BY 1
            )

SELECT
    u.heap_user_id
  , u.heap_last_updated
  , au.heap_user_earliest_session
  , LEAST(u.heap_last_updated, au.heap_user_earliest_session) as heap_user_record_last_updated

FROM {{ ref('src_heap_users') }} u
JOIN heap_active_users au USING(heap_user_id)




