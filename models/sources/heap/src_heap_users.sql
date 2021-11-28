
SELECT
    u.identity as fmk_identity 
  , u.user_id as heap_user_id
  , u.email as heap_user_email
  , u.first_name as heap_user_first
  , u.last_name as heap_user_last
  , u.joindate as heap_first_detected
  , u.last_modified as heap_last_updated

FROM {{ source('heap','users') }} u 