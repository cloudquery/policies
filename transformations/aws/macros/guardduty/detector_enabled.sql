{% macro detector_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('detector_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__detector_enabled(framework, check_id) %}
with enabled_detector_regions as (
    select request_account_id as account_id, request_region as region
    from aws_guardduty_detectors
    where status = 'ENABLED'
)

select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'GuardDuty should be enabled' AS title,
    r.account_id,
    r.region AS resource_id,
    case when
        enabled = TRUE and e.region is null
    then 'fail' else 'pass' end AS status
from aws_regions r
left join enabled_detector_regions e on e.region = r.region AND e.account_id = r.account_id
union
-- Add any detector that is enabled but all data sources are disabled
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'GuardDuty should be enabled (detectors)' AS title,
    request_account_id as account_id,
    request_region AS resource_id,
    case when
        data_sources:S3Logs:Status != 'ENABLED' AND
        data_sources:DNSLogs:Status != 'ENABLED' AND
        data_sources:CloudTrail:Status != 'ENABLED' AND
        data_sources:FlowLogs:Status != 'ENABLED'
    then 'fail' else 'pass' end AS status
from aws_guardduty_detectors
where
    status = 'ENABLED'
{% endmacro %}

{% macro postgres__detector_enabled(framework, check_id) %}
with enabled_detector_regions as (
    select request_account_id as account_id, request_region as region
    from aws_guardduty_detectors
    where status = 'ENABLED'
)

select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'GuardDuty should be enabled' AS title,
    r.account_id,
    r.region AS resource_id,
    case when
        enabled = TRUE and e.region is null
    then 'fail' else 'pass' end AS status
from aws_regions r
left join enabled_detector_regions e on e.region = r.region AND e.account_id = r.account_id
union
-- Add any detector that is enabled but all data sources are disabled
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'GuardDuty should be enabled (detectors)' AS title,
    request_account_id as account_id,
    request_region AS resource_id,
    case when
        data_sources->'S3Logs'->>'Status' != 'ENABLED' AND
        data_sources->'DNSLogs'->>'Status' != 'ENABLED' AND
        data_sources->'CloudTrail'->>'Status' != 'ENABLED' AND
        data_sources->'FlowLogs'->>'Status' != 'ENABLED'
    then 'fail' else 'pass' end AS status
from aws_guardduty_detectors
where
    status = 'ENABLED'
{% endmacro %}

{% macro default__detector_enabled(framework, check_id) %}{% endmacro %}
                    
{% macro bigquery__detector_enabled(framework, check_id) %}
with enabled_detector_regions as (
    select request_account_id as account_id, request_region as region
    from {{ full_table_name("aws_guardduty_detectors") }}
    where status = 'ENABLED'
)

select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'GuardDuty should be enabled' AS title,
    r.account_id,
    r.region AS resource_id,
    case when
        enabled = TRUE and e.region is null
    then 'fail' else 'pass' end AS status
from {{ full_table_name("aws_regions") }} r
left join enabled_detector_regions e on e.region = r.region AND e.account_id = r.account_id
union all
-- Add any detector that is enabled but all data sources are disabled
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'GuardDuty should be enabled (detectors)' AS title,
    request_account_id as account_id,
    request_region AS resource_id,
    case when
        JSON_VALUE(data_sources.S3Logs.Status) != 'ENABLED' AND
        JSON_VALUE(data_sources.DNSLogs.Status) != 'ENABLED' AND
        JSON_VALUE(data_sources.CloudTrail.Status) != 'ENABLED' AND
        JSON_VALUE(data_sources.FlowLogs.Status) != 'ENABLED'
    then 'fail' else 'pass' end AS status
from {{ full_table_name("aws_guardduty_detectors") }}
where
    status = 'ENABLED'
{% endmacro %}    

{% macro athena__detector_enabled(framework, check_id) %}
with enabled_detector_regions as (
    select request_account_id as account_id, request_region as region
    from aws_guardduty_detectors
    where status = 'ENABLED'
)

select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'GuardDuty should be enabled' AS title,
    r.account_id,
    r.region AS resource_id,
    case when
        enabled = TRUE and e.region is null
    then 'fail' else 'pass' end AS status
from aws_regions r
left join enabled_detector_regions e on e.region = r.region AND e.account_id = r.account_id
union
-- Add any detector that is enabled but all data sources are disabled
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'GuardDuty should be enabled (detectors)' AS title,
    request_account_id as account_id,
    request_region AS resource_id,
    case when
        json_extract_scalar(data_sources, '$.S3Logs.Status') != 'ENABLED' AND
        json_extract_scalar(data_sources, '$.DNSLogs.Status') != 'ENABLED' AND
        json_extract_scalar(data_sources, '$.CloudTrail.Status') != 'ENABLED' AND
        json_extract_scalar(data_sources, '$.FlowLogs.Status') != 'ENABLED'
    then 'fail' else 'pass' end AS status
from aws_guardduty_detectors
where
    status = 'ENABLED'
{% endmacro %}