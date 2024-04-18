{% macro azure_asset_resources(table_name, subscription_id_exist, id_exist, location_exist, kind_exist, name_exist) %}
  {{ return(adapter.dispatch('azure_asset_resources')(table_name, subscription_id_exist, id_exist, location_exist, kind_exist, name_exist)) }}
{% endmacro %}

{% macro postgres__azure_asset_resources(table_name, subscription_id_exist, id_exist, location_exist, kind_exist, name_exist) %}
SELECT
_cq_id, _cq_source_name, _cq_sync_time,
{% if subscription_id_exist %}
subscription_id
{% else %}
'unavailable'
{% endif %} AS subscription_id,
{% if id_exist %}
reverse(split_part(reverse(id), '/'::TEXT, 1))
{% else %}
'unavailable'
{% endif %} AS id, 
{% if location_exist %}
location
{% else %}
'unavailable'
{% endif %} as location,
{% if kind_exist %}
kind
{% else %}
'unavailable'
{% endif %} AS kind,
{% if name_exist %}
name
{% else %}
'unavailable'
{% endif %} AS name,
'{{ table_name | string }}' AS _cq_table
FROM {{ table_name | string }}
{% endmacro %}    

{% macro snowflake__azure_asset_resources(table_name, subscription_id_exist, id_exist, location_exist, kind_exist, name_exist) %}
SELECT
_cq_id, _cq_source_name, _cq_sync_time,
{% if subscription_id_exist %}
subscription_id
{% else %}
'unavailable'
{% endif %} AS subscription_id,
{% if id_exist %}
reverse(split_part(reverse(id), '/'::TEXT, 1))
{% else %}
'unavailable'
{% endif %} AS id, 
{% if location_exist %}
location
{% else %}
'unavailable'
{% endif %} as location,
{% if kind_exist %}
kind
{% else %}
'unavailable'
{% endif %} AS kind,
{% if name_exist %}
name
{% else %}
'unavailable'
{% endif %} AS name,
'{{ table_name | string }}' AS _cq_table
FROM {{ table_name | string }}
{% endmacro %} 

{% macro bigquery__azure_asset_resources(table_name, subscription_id_exist, id_exist, location_exist, kind_exist, name_exist) %}
SELECT
_cq_id, _cq_source_name, _cq_sync_time,
{% if subscription_id_exist %}
subscription_id
{% else %}
'unavailable'
{% endif %} AS subscription_id,
{% if id_exist %}
reverse(split(reverse(id), '/')[0])
{% else %}
'unavailable'
{% endif %} AS id, 
{% if location_exist %}
location
{% else %}
'unavailable'
{% endif %} as location,
{% if kind_exist %}
kind
{% else %}
'unavailable'
{% endif %} AS kind,
{% if name_exist %}
name
{% else %}
'unavailable'
{% endif %} AS name,
'{{ table_name | string }}' AS _cq_table
FROM {{ full_table_name(table_name | string) }}
{% endmacro %}  