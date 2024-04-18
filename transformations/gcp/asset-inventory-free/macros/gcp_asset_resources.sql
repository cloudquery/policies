{% macro gcp_asset_resources(table_name, project_id_exist, id_exist, region_exist, description_exist, name_exist) %}
  {{ return(adapter.dispatch('gcp_asset_resources')(table_name, project_id_exist, id_exist, region_exist, description_exist, name_exist)) }}
{% endmacro %}

{% macro postgres__gcp_asset_resources(table_name, project_id_exist, id_exist, region_exist, description_exist, name_exist) %}
SELECT
_cq_id, _cq_source_name, _cq_sync_time,
{% if project_id_exist %}
project_id
{% else %}
'unavailable'
{% endif %} AS project_id,
{% if id_exist %}
id::text
{% else %}
'unavailable'
{% endif %} AS id, 
{% if region_exist %}
split_part(region, '/', 9)
{% else %}
'unavailable'
{% endif %} as region,
{% if description_exist %}
description
{% else %}
'unavailable'
{% endif %} AS description,
{% if name_exist %}
name
{% else %}
'unavailable'
{% endif %} AS name,
'{{ table_name | string }}' AS _cq_table
FROM {{ table_name | string }}
{% endmacro %}    

{% macro snowflake__gcp_asset_resources(table_name, project_id_exist, id_exist, region_exist, description_exist, name_exist) %}
SELECT
_cq_id, _cq_source_name, _cq_sync_time,
{% if project_id_exist %}
project_id
{% else %}
'unavailable'
{% endif %} AS project_id,
{% if id_exist %}
id::text
{% else %}
'unavailable'
{% endif %} AS id, 
{% if region_exist %}
split_part(region, '/', 9)
{% else %}
'unavailable'
{% endif %} as region,
{% if description_exist %}
description
{% else %}
'unavailable'
{% endif %} AS description,
{% if name_exist %}
name
{% else %}
'unavailable'
{% endif %} AS name,
'{{ table_name | string }}' AS _cq_table
FROM {{ table_name | string }}
{% endmacro %} 

{% macro bigquery__gcp_asset_resources(table_name, project_id_exist, id_exist, region_exist, description_exist, name_exist) %}
SELECT
_cq_id, _cq_source_name, _cq_sync_time,
{% if project_id_exist %}
project_id
{% else %}
'unavailable'
{% endif %} AS project_id,
{% if id_exist %}
cast(id as string)
{% else %}
'unavailable'
{% endif %} AS id, 
{% if region_exist %}
region
{% else %}
'unavailable'
{% endif %} as region,
{% if description_exist %}
description
{% else %}
'unavailable'
{% endif %} AS description,
{% if name_exist %}
name
{% else %}
'unavailable'
{% endif %} AS name,
'{{ table_name | string }}' AS _cq_table
FROM {{ full_table_name(table_name | string) }}
{% endmacro %}  