SELECT
    s.session_id as heap_session_id
  , s.time as heap_session_start
  , s.user_id as heap_user_id
  , s.event_id as heap_event_id
  , s.library as heap_session_library
  , s.platform as heap_session_platform
  , s.device as heap_session_device
  , s.device_type as heap_session_device_type
  , s.country as heap_session_country
  , s.region as heap_session_region
  , s.city as heap_session_city
  , s.ip as heap_session_ip
  , s.referrer as heap_session_referrer
  , s.landing_page as heap_session_lp
  , s.landing_page_query as heap_session_lp_query
  , s.browser as heap_session_browser
  , s.search_keyword as heap_session_search_keyword
  , s.utm_source as heap_session_utm_source
  , s.utm_medium as heap_session_utm_medium
  , s.utm_campaign as heap_session_utm_campaign
  , s.utm_content as heap_session_utm_content
  , s.utm_term as heap_session_utm_term
  , s.carrier as heap_session_carrier
  , s.app_name as heap_session_app_name
  , s.app_version as heap_session_app_version
  , s.heap_device_id
  , s.heap_app_name
  , s.heap_device

FROM {{ source('heap','sessions') }} s