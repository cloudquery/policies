{% macro cloudtrail_enabled_all_regions(framework, check_id) %}
  {{ return(adapter.dispatch('cloudtrail_enabled_all_regions')(framework, check_id)) }}
{% endmacro %}

{% macro default__cloudtrail_enabled_all_regions(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure CloudTrail is enabled in all regions' as title,
    aws_cloudtrail_trails.account_id,
    arn as resource_id,
    case
        when aws_cloudtrail_trails.is_multi_region_trail = FALSE then 'fail'
        when exists(select *
                    from jsonb_array_elements(aws_cloudtrail_trail_event_selectors.event_selectors) as es
                    where es ->>'ReadWriteType' != 'All' or (es->>'IncludeManagementEvents')::boolean = FALSE)
            then 'fail'
        when exists(select *
                    from jsonb_array_elements(aws_cloudtrail_trail_event_selectors.advanced_event_selectors) as aes
                    where exists(select *
                                 from jsonb_array_elements(aes ->'FieldSelectors') as aes_fs
                                 where aes_fs ->>'Field' = 'readOnly'))
            then 'fail'
        else 'pass'
    end as status
from aws_cloudtrail_trails
inner join
    aws_cloudtrail_trail_event_selectors on
        aws_cloudtrail_trails.arn = aws_cloudtrail_trail_event_selectors.trail_arn
        and aws_cloudtrail_trails.region = aws_cloudtrail_trail_event_selectors.region
        and aws_cloudtrail_trails.account_id = aws_cloudtrail_trail_event_selectors.account_id
{% endmacro %}

{% macro bigquery__cloudtrail_enabled_all_regions(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure CloudTrail is enabled in all regions' as title,
    aws_cloudtrail_trails.account_id,
    arn as resource_id,
    case
        when aws_cloudtrail_trails.is_multi_region_trail = FALSE then 'fail'
        when exists(select *
                    from UNNEST(JSON_QUERY_ARRAY(aws_cloudtrail_trail_event_selectors.event_selectors)) AS es
                    where JSON_VALUE(es.ReadWriteType) != 'All' or (CAST( JSON_VALUE(es.IncludeManagementEvents) AS BOOL)= FALSE )
        )
            then 'fail'
        when exists(select *
                    from UNNEST(JSON_QUERY_ARRAY(aws_cloudtrail_trail_event_selectors.advanced_event_selectors)) AS aes
                    where exists(select *
                                 from UNNEST(JSON_QUERY_ARRAY(aes.FieldSelectors)) as aes_fs
                                 where JSON_VALUE(aes_fs.Field) = 'readOnly'))
            then 'fail'
        else 'pass'
    end as status
from {{ full_table_name("aws_cloudtrail_trails") }}
inner join
    {{ full_table_name("aws_cloudtrail_trail_event_selectors") }} on
        aws_cloudtrail_trails.arn = aws_cloudtrail_trail_event_selectors.trail_arn
        and aws_cloudtrail_trails.region = aws_cloudtrail_trail_event_selectors.region
        and aws_cloudtrail_trails.account_id = aws_cloudtrail_trail_event_selectors.account_id
{% endmacro %}

{% macro snowflake__cloudtrail_enabled_all_regions(framework, check_id) %}
with aes as
(
  select *
  from aws_cloudtrail_trail_event_selectors,
  LATERAL FLATTEN (advanced_event_selectors) as aes
)
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure CloudTrail is enabled in all regions' as title,
    aws_cloudtrail_trails.account_id,
    arn as resource_id,
    case
        when aws_cloudtrail_trails.is_multi_region_trail = FALSE then 'fail'
        when exists(select *
                    from aws_cloudtrail_trail_event_selectors,
                    LATERAL FLATTEN(event_selectors) as es
                    where es.value:ReadWriteType != 'All' or (es.value:IncludeManagementEvents)::boolean = FALSE
                    )
            then 'fail'
        when exists(
                    select *
                   from aes,
                  LATERAL FLATTEN (value:FieldSelectors) as aes_fs
                    where aes_fs.value:Field = 'readOnly'
                   )
            then 'fail'
        else 'pass'
    end as status
from aws_cloudtrail_trails
inner join
    aws_cloudtrail_trail_event_selectors on
        aws_cloudtrail_trails.arn = aws_cloudtrail_trail_event_selectors.trail_arn
        and aws_cloudtrail_trails.region = aws_cloudtrail_trail_event_selectors.region
        and aws_cloudtrail_trails.account_id = aws_cloudtrail_trail_event_selectors.account_id
{% endmacro %}