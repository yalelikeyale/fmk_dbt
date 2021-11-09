SELECT
    p.user_id as heap_user_id
  , p.event_id as heap_page_id
  , p.session_id as heap_session_id
  , p.time as heap_page_time
  , p.library as heap_page_library
  , p.platform as heap_page_platform
  , p.device_type as heap_page_device_type
  , p.country as heap_page_country
  , p.region as heap_page_region
  , p.city as heap_page_city
  , p.ip as heap_page_ip
  , p.referrer as heap_page_referrer
  , p.landing_page as heap_page_lp
  , p.landing_page_query as heap_page_lp_query
  , p.landing_page_hash as heap_page_lp_hash
  , p.browser as heap_page_browser
  , p.search_keyword as heap_page_search_kw
  , p.utm_source as heap_page_utm_source
  , p.utm_campaign as heap_page_utm_campaign
  , p.utm_medium as heap_page_utm_medium
  , p.utm_term as heap_page_utm_term
  , p.utm_content as heap_page_utm_content
  , p.device as heap_page_device
  , p.carrier as heap_page_carrier
  , p.app_name as heap_page_app_name
  , p.app_version as heap_page_app_version
  , p.domain as heap_page_domain
  , p.query as heap_page_query
  , p.path as heap_page_path
  , p.hash as heap_page_hash
  , p.title as heap_page_title

FROM {{ source('heap','pageviews')}} p