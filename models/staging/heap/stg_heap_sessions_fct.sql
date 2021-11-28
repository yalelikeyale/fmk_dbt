{{
    config(
        materialized='incremental',
        unique_key='heap_session_id'
    )
}}

WITH 
    updated_users 
        AS 
            (
                SELECT DISTINCT uh.heap_user_id
                FROM {{ ref('stg_heap_base_updated_users_view') }} uh
            )

SELECT * 
FROM {{ ref('src_heap_sessions') }} s
WHERE s.heap_user_id IN (SELECT * FROM updated_users)