{% macro cloudtrail_s3_object_read_events_audit_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('cloudtrail_s3_object_read_events_audit_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__cloudtrail_s3_object_read_events_audit_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__cloudtrail_s3_object_read_events_audit_enabled(framework, check_id) %}
with audit_enabled AS (
    select
    c.arn,
    case
	when is_multi_region_trail and data_resource ->> 'Type' = 'AWS::S3::Object'
    and data_resource -> 'Values' ? 'arn:aws:s3'
    and event_selectors ->> 'ReadWriteType' in ('ReadOnly', 'All')
     then True
	else False
	end as read_event
from aws_cloudtrail_trails AS c
join aws_cloudtrail_trail_event_selectors AS es ON c._cq_id = es._cq_parent_id,
jsonb_array_elements(es.event_selectors -> 'DataResources') as data_resource
)

select 
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure that Object-level logging for write events is enabled for S3 bucket' as title,
	c.account_id,
	c.arn as resource_id,
	case
	when bool_or(read_event) then 'pass'
	else 'fail'
	end as status
from aws_cloudtrail_trails AS c
join audit_enabled AS cae ON c.arn = cae.arn
group by c.arn, c.account_id
{% endmacro %}

{% macro bigquery__cloudtrail_s3_object_read_events_audit_enabled(framework, check_id) %}
with audit_enabled AS (
    select
    c.arn,
    case
	when is_multi_region_trail and JSON_VALUE(data_resource.Type) = 'AWS::S3::Object'
    and 'arn:aws:s3' in UNNEST(JSON_EXTRACT_STRING_ARRAY(data_resource.Values))
    and JSON_VALUE(event_selectors.ReadWriteType) in ('ReadOnly', 'All')
     then True
	else False
	end as read_event
from {{ full_table_name("aws_cloudtrail_trails") }} AS c
join {{ full_table_name("aws_cloudtrail_trail_event_selectors") }} AS es ON c._cq_id = es._cq_parent_id,
UNNEST(JSON_QUERY_ARRAY(es.event_selectors.DataResources)) AS data_resource
)

select 
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure that Object-level logging for write events is enabled for S3 bucket' as title,
	c.account_id,
	c.arn as resource_id,
	case
	when LOGICAL_OR(read_event) then 'pass'
	else 'fail'
	end as status
from {{ full_table_name("aws_cloudtrail_trails") }} AS c
join audit_enabled AS cae ON c.arn = cae.arn
group by c.arn, c.account_id
{% endmacro %}

{% macro snowflake__cloudtrail_s3_object_read_events_audit_enabled(framework, check_id) %}
with audit_enabled AS (
    select
    c.arn,
    case
	when is_multi_region_trail and data_resource.value:Type = 'AWS::S3::Object'
    and ARRAY_CONTAINS('arn:aws:s3'::variant, data_resource.value:Values)
    and event_selectors:ReadWriteType in ('ReadOnly', 'All')
     then True
	else False
	end as read_event
from aws_cloudtrail_trails AS c
join aws_cloudtrail_trail_event_selectors AS es ON c._cq_id = es._cq_parent_id,
  LATERAL FLATTEN(es.event_selectors:DataResources) as data_resource
)

select 
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure that Object-level logging for write events is enabled for S3 bucket' as title,
	c.account_id,
	c.arn as resource_id,
	case
	when BOOLOR_AGG(read_event) then 'pass'
	else 'fail'
	end as status
from aws_cloudtrail_trails AS c
join audit_enabled AS cae ON c.arn = cae.arn
group by c.arn, c.account_id
{% endmacro %}
