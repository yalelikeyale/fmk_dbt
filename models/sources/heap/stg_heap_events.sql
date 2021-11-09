SELECT
    e.event_id as heap_event_id
  , e.event_table_name as heap_event_name
  , e.time as heap_event_time
  , e.user_id as heap_user_id
  , e.session_id as heap_session_id

FROM {{ source('heap', 'all_events') }} e