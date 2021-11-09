{% snapshot snap_heap_users %}

{{
    config(
      target_database='FMK_TRANSFORMED',
      target_schema='HEAP_TRANSFORMED',
      unique_key='identity',
      strategy='timestamp',
      updated_at='last_modified',
    )
}}

select * from {{ source('heap', 'users') }}

{% endsnapshot %}