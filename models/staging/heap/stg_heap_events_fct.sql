



{{
    config(
        materialized='incremental',
        unique_key='heap_event_id'
    )
}}

WITH 
    updated_users 
        AS 
            (
                SELECT DISTINCT uh.heap_user_id
                FROM {{ ref('stg_heap_base_updated_users_view') }} uh
            )

-- would be helpful to have an invocation id and update time for auditing 
SELECT * 

FROM {{ ref('src_heap_events') }} e
WHERE e.heap_user_id IN (SELECT * FROM updated_users)

