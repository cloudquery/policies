{% macro alarm_root_account(framework, check_id) %}
  {{ return(adapter.dispatch('alarm_root_account')(framework, check_id)) }}
{% endmacro %}

{% macro default__alarm_root_account(framework, check_id) %}{% endmacro %}

{% macro postgres__alarm_root_account(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure a log metric filter and alarm exist for usage of "root" account (Score)' as title,
  account_id,
  cloud_watch_logs_log_group_arn as resource_id,
  case
    when pattern NOT LIKE '%NOT%'
        AND pattern LIKE '%$.userIdentity.type = "Root"%'
        AND pattern LIKE '%$.userIdentity.invokedBy NOT EXISTS%'
        AND pattern LIKE '%$.eventType != "AwsServiceEvent"%' then 'pass'
    else 'fail'
  end as status
from {{ ref('aws_compliance__log_metric_filter_and_alarm') }}
{% endmacro %}

{% macro bigquery__alarm_root_account(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure a log metric filter and alarm exist for usage of "root" account (Score)' as title,
  account_id,
  cloud_watch_logs_log_group_arn as resource_id,
  case
    when pattern NOT LIKE '%NOT%'
        AND pattern LIKE '%$.userIdentity.type = "Root"%'
        AND pattern LIKE '%$.userIdentity.invokedBy NOT EXISTS%'
        AND pattern LIKE '%$.eventType != "AwsServiceEvent"%' then 'pass'
    else 'fail'
  end as status
from {{ ref('aws_compliance__log_metric_filter_and_alarm') }}
{% endmacro %}