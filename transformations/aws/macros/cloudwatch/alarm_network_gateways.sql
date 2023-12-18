{% macro alarm_network_gateways(framework, check_id) %}
  {{ return(adapter.dispatch('alarm_network_gateways')(framework, check_id)) }}
{% endmacro %}

{% macro default__alarm_network_gateways(framework, check_id) %}{% endmacro %}

{% macro postgres__alarm_network_gateways(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure a log metric filter and alarm exist for changes to network gateways (Scored)' as title,
  account_id,
  cloud_watch_logs_log_group_arn as resource_id,
  case
      when pattern NOT LIKE '%NOT%'
          AND pattern LIKE '%($.eventName = CreateCustomerGateway)%'
          AND pattern LIKE '%($.eventName = DeleteCustomerGateway)%'
          AND pattern LIKE '%($.eventName = AttachInternetGateway)%'
          AND pattern LIKE '%($.eventName = CreateInternetGateway)%'
          AND pattern LIKE '%($.eventName = DeleteInternetGateway)%'
          AND pattern LIKE '%($.eventName = DetachInternetGateway)%' then 'pass'
      else 'fail'
  end as status
from {{ ref('aws_compliance__log_metric_filter_and_alarm') }}
{% endmacro %}

{% macro bigquery__alarm_network_gateways(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure a log metric filter and alarm exist for changes to network gateways (Scored)' as title,
  account_id,
  cloud_watch_logs_log_group_arn as resource_id,
  case
      when pattern NOT LIKE '%NOT%'
          AND pattern LIKE '%($.eventName = CreateCustomerGateway)%'
          AND pattern LIKE '%($.eventName = DeleteCustomerGateway)%'
          AND pattern LIKE '%($.eventName = AttachInternetGateway)%'
          AND pattern LIKE '%($.eventName = CreateInternetGateway)%'
          AND pattern LIKE '%($.eventName = DeleteInternetGateway)%'
          AND pattern LIKE '%($.eventName = DetachInternetGateway)%' then 'pass'
      else 'fail'
  end as status
from {{ ref('aws_compliance__log_metric_filter_and_alarm') }}
{% endmacro %}

{% macro snowflake__alarm_network_gateways(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure a log metric filter and alarm exist for changes to network gateways (Scored)' as title,
  account_id,
  cloud_watch_logs_log_group_arn as resource_id,
  case
      when pattern NOT LIKE '%NOT%'
          AND pattern LIKE '%($.eventName = CreateCustomerGateway)%'
          AND pattern LIKE '%($.eventName = DeleteCustomerGateway)%'
          AND pattern LIKE '%($.eventName = AttachInternetGateway)%'
          AND pattern LIKE '%($.eventName = CreateInternetGateway)%'
          AND pattern LIKE '%($.eventName = DeleteInternetGateway)%'
          AND pattern LIKE '%($.eventName = DetachInternetGateway)%' then 'pass'
      else 'fail'
  end as status
from {{ ref('aws_compliance__log_metric_filter_and_alarm') }}
{% endmacro %}
