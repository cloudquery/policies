{% macro alarm_console_no_mfa(framework, check_id) %}
  {{ return(adapter.dispatch('alarm_console_no_mfa')(framework, check_id)) }}
{% endmacro %}

{% macro default__alarm_console_no_mfa(framework, check_id) %}{% endmacro %}

{% macro postgres__alarm_console_no_mfa(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure management console sign-in without MFA is monitored' as title,
    account_id,
    cloud_watch_logs_log_group_arn as resource_id,
    case
        when pattern NOT LIKE '%NOT%'
            AND pattern LIKE '%($.errorCode = "ConsoleLogin")%'
            AND pattern LIKE '%($.additionalEventData.MFAUsed != "Yes"%' then 'pass'
        else 'fail'
    end as status
from {{ ref('aws_compliance__log_metric_filter_and_alarm') }}
{% endmacro %}

{% macro snowflake__alarm_console_no_mfa(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure management console sign-in without MFA is monitored' as title,
    account_id,
    cloud_watch_logs_log_group_arn as resource_id,
    case
        when pattern NOT LIKE '%NOT%'
            AND pattern LIKE '%($.errorCode = "ConsoleLogin")%'
            AND pattern LIKE '%($.additionalEventData.MFAUsed != "Yes"%' then 'pass'
        else 'fail'
    end as status
from {{ ref('aws_compliance__log_metric_filter_and_alarm') }}
{% endmacro %}

{% macro bigquery__alarm_console_no_mfa(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure management console sign-in without MFA is monitored' as title,
    account_id,
    cloud_watch_logs_log_group_arn as resource_id,
    case
        when pattern NOT LIKE '%NOT%'
            AND pattern LIKE '%($.errorCode = "ConsoleLogin")%'
            AND pattern LIKE '%($.additionalEventData.MFAUsed != "Yes"%' then 'pass'
        else 'fail'
    end as status
from {{ ref('aws_compliance__log_metric_filter_and_alarm') }}
{% endmacro %}

{% macro athena__alarm_console_no_mfa(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure management console sign-in without MFA is monitored' as title,
    account_id,
    cloud_watch_logs_log_group_arn as resource_id,
    case
        when pattern NOT LIKE '%NOT%'
            AND pattern LIKE '%($.errorCode = "ConsoleLogin")%'
            AND pattern LIKE '%($.additionalEventData.MFAUsed != "Yes"%' then 'pass'
        else 'fail'
    end as status
from {{ ref('aws_compliance__log_metric_filter_and_alarm') }}
{% endmacro %}