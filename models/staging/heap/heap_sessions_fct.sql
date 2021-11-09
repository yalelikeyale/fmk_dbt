{{
  config(
    unique_key='session_id'
  )
}}

WITH
  -- GRAB USERS WITH UPDATED AT OR SESSION TIME THAT OCCURED SINCE THE LAST RUN OF THIS MODEL
  updated_users
    AS
      (
        SELECT DISTINCT u.heap_user_id
        FROM {{ ref('base_heap_updated_users') }} u
        {% if is_incremental() %}
          WHERE u.heap_user_record_last_updated > (SELECT MAX(t.heap_session_start) FROM {{this}} t)
        {% endif %}
      ),

  heap_events
    AS
      (
        SELECT
            e.heap_session_id
          , MAX(e.heap_event_time) as heap_session_last_event_time
          , BOOLOR_AGG(e.heap_event_is_funnel) as heap_session_is_funnel
          -- feature to capture funnel penetration during the session
          , BOOLOR_AGG(e.heap_event_is_signup) as heap_session_is_signup
          , BOOLOR_AGG(e.heap_event_is_conversion) as heap_session_is_conversion

        FROM {{ ref('heap_events_fct') }} e
        WHERE e.heap_user_id IN (SELECT * FROM updated_users)
        GROUP BY 1
      )

SELECT
    s.*
  , ROW_NUMBER() OVER( PARTITION BY s.heap_user_id ORDER BY s.heap_session_start ) as heap_session_sequence_num
  , e.heap_session_last_event_time
  , DATEDIFF('second', s.heap_session_start, e.heap_session_last_event_time) as heap_session_duration_est
  , e.heap_session_is_funnel
  , e.heap_session_is_signup
  , e.heap_session_is_conversion


FROM {{ ref('src_heap_sessions') }} s
JOIN heap_events e USING(heap_session_id)
{% if is_incremental() %}
  WHERE s.heap_user_id IN (SELECT * FROM updated_users)
{% endif %}






