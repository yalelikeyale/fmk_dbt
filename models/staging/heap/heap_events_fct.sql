{{
  config(
    unique_key='event_id'
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
          WHERE u.heap_user_record_last_updated > (SELECT MAX(t.heap_event_time) FROM {{this}} t)
        {% endif %}
      )

SELECT
    e.*
  , ROW_NUMBER() OVER (PARTITION BY e.heap_user_id ORDER BY e.heap_event_time)  as heap_event_sequence_num
  , ROW_NUMBER() OVER (PARTITION BY e.heap_user_id, e.heap_session_id ORDER BY e.heap_event_time) as heap_event_session_position
  , ROW_NUMBER() OVER (PARTITION BY e.heap_user_id, e.heap_session_id, e.heap_event_name ORDER BY e.heap_event_time) as heap_event_session_occurrence_num
  , e.heap_event_name in (
        {% for funnel_event in var('heap:topline_funnel') %}
        '{{funnel_event}}'
        {% if not loop.last %}
        ,
        {% endif %}
        {% endfor %}
    ) as heap_event_is_funnel
  , e.heap_event_name = '{{ var("heap:signup_event") }}' as heap_event_is_signup
  , e.heap_event_name = '{{ var("heap:conversion_event") }}' as heap_event_is_conversion

FROM {{ ref('src_heap_events') }} e
{% if is_incremental() %}
  WHERE e.heap_user_id IN (SELECT * FROM updated_users)
{% endif %}



