{% macro aws_asset_resources(table_name, ARN_EXIST, ACCOUNT_ID_EXIST, REQUEST_ACCOUNT_ID_EXIST, REGION_EXIST, TAGS_EXIST) %}
  {{ return(adapter.dispatch('aws_asset_resources')(table_name, ARN_EXIST, ACCOUNT_ID_EXIST, REQUEST_ACCOUNT_ID_EXIST, REGION_EXIST, TAGS_EXIST)) }}
{% endmacro %}

{% macro postgres__aws_asset_resources(table_name, ARN_EXIST, ACCOUNT_ID_EXIST, REQUEST_ACCOUNT_ID_EXIST, REGION_EXIST, TAGS_EXIST) %}
SELECT
_cq_id, _cq_source_name, _cq_sync_time,
{% if ACCOUNT_ID_EXIST %}
account_id
{% else %}
SPLIT_PART(arn, ':', 5)
{% endif %} AS account_id,
{% if REQUEST_ACCOUNT_ID_EXIST %}
request_account_id
{% else %}
SPLIT_PART(arn, ':', 5)
{% endif %} AS request_account_id, 
CASE
WHEN SPLIT_PART(SPLIT_PART(arn, ':', 6), '/', 2) = '' AND SPLIT_PART(arn, ':', 7) = '' THEN NULL
ELSE SPLIT_PART(SPLIT_PART(arn, ':', 6), '/', 1)
END AS TYPE,
arn,
{% if REGION_EXIST %}
region
{% else %}
'unavailable'
{% endif %} AS region,
{% if TAGS_EXIST %}
tags
{% else %}
'{}'::jsonb
{% endif %} AS tags,
SPLIT_PART(arn, ':', 2) AS PARTITION,
SPLIT_PART(arn, ':', 3) AS service,
'{{ table_name | string }}' AS _cq_table
FROM {{ table_name | string }}
{% endmacro %}    

{% macro snowflake__aws_asset_resources(table_name, ARN_EXIST, ACCOUNT_ID_EXIST, REQUEST_ACCOUNT_ID_EXIST, REGION_EXIST, TAGS_EXIST) %}
SELECT
_cq_id, _cq_source_name, _cq_sync_time,
{% if ACCOUNT_ID_EXIST %}
account_id
{% else %}
SPLIT_PART(arn, ':', 5)
{% endif %}
AS account_id,
{% if REQUEST_ACCOUNT_ID_EXIST %}
request_account_id
{% else %}
SPLIT_PART(arn, ':', 5)
{% endif %}
AS request_account_id, 
CASE
WHEN SPLIT_PART(SPLIT_PART(arn, ':', 6), '/', 2) = '' AND SPLIT_PART(arn, ':', 7) = '' THEN NULL
ELSE SPLIT_PART(SPLIT_PART(arn, ':', 6), '/', 1)
END AS TYPE,
arn,
{% if REGION_EXIST %}
region
{% else %}
'unavailable'
{% endif %} AS region,

{% if TAGS_EXIST %}
trim(tags::varchar)
{% else %}
'{}'::varchar
{% endif %} AS tags,
SPLIT_PART(arn, ':', 2) AS PARTITION,
SPLIT_PART(arn, ':', 3) AS service,
'{{ table_name | string }}' AS _cq_table
FROM {{ table_name | string }}
{% endmacro %} 

{%- macro bigquery__aws_asset_resources(table_name, ARN_EXIST, ACCOUNT_ID_EXIST, REQUEST_ACCOUNT_ID_EXIST, REGION_EXIST, TAGS_EXIST) -%}
SELECT 
_cq_id, _cq_source_name, _cq_sync_time,{% if ACCOUNT_ID_EXIST %} account_id {% else %} SPLIT(arn, ':')[5] {% endif %} AS account_id, {% if REQUEST_ACCOUNT_ID_EXIST %} request_account_id {% else %} SPLIT(arn, ':')[5] {% endif %} AS request_account_id, CASE WHEN SPLIT(SPLIT(arn, ':')[6], '/')[2] = '' AND SPLIT(arn, ':')[7] = '' THEN NULL ELSE SPLIT(SPLIT(arn, ':')[6], '/')[1] END AS TYPE, arn, {% if REGION_EXIST %} region {% else %} 'unavailable' {% endif %} AS region, {% if TAGS_EXIST %} TO_JSON_STRING(tags) {% else %} TO_JSON_STRING(STRUCT()) {% endif %} AS tags, SPLIT(arn, ':')[2] AS PARTITIONS, SPLIT(arn, ':')[3] AS service, '{{ table_name | string }}' AS _cq_table 
FROM {{ full_table_name(table_name | string) }} 
{%- endmacro -%}  

{% macro clickhouse__aws_asset_resources(table_name, ARN_EXIST, ACCOUNT_ID_EXIST, REQUEST_ACCOUNT_ID_EXIST, REGION_EXIST, TAGS_EXIST) %}
SELECT
_cq_id, _cq_source_name, _cq_sync_time,
{% if ACCOUNT_ID_EXIST %}
account_id
{% else %}
splitByChar(':', COALESCE(arn, ''))[5]
{% endif %} AS account_id,
{% if REQUEST_ACCOUNT_ID_EXIST %}
request_account_id
{% else %}
splitByChar(':', COALESCE(arn, ''))[5]
{% endif %} AS request_account_id,
CASE WHEN 
splitByChar('/', COALESCE(splitByChar(':', COALESCE(arn, ''))[6], ''))[2] = ''
AND splitByChar(':', COALESCE(arn, ''))[7] = '' THEN NULL
ELSE splitByChar('/', COALESCE(splitByChar(':', COALESCE(arn, ''))[6], ''))[1] 
END AS TYPE,
arn,
{% if REGION_EXIST %}
region
{% else %}
'unavailable'
{% endif %} AS region,
{% if TAGS_EXIST %}
tags
{% else %}
'{}' 
{% endif %} AS tags,
splitByChar(':', COALESCE(arn, ''))[2] AS PARTITION,
splitByChar(':', COALESCE(arn, ''))[3] AS service,
'{{ table_name | string }}' AS _cq_table FROM {{ table_name | string }}
{% endmacro %}