{% macro alarm_security_group_changes(framework, check_id) %}
  {{ return(adapter.dispatch('alarm_security_group_changes')(framework, check_id)) }}
{% endmacro %}

{% macro default__alarm_security_group_changes(framework, check_id) %}{% endmacro %}

{% macro postgres__alarm_security_group_changes(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure a log metric filter and alarm exist for security group changes (Scored)' as title,
  account_id,
  cloud_watch_logs_log_group_arn as resource_id,
  case when pattern NOT LIKE '%NOT%'
           AND pattern LIKE '%($.eventName = AuthorizeSecurityGroupIngress)%'
           AND pattern LIKE '%($.eventName = AuthorizeSecurityGroupEgress)%'
           AND pattern LIKE '%($.eventName = RevokeSecurityGroupIngress)%'
           AND pattern LIKE '%($.eventName = RevokeSecurityGroupEgress)%'
           AND pattern LIKE '%($.eventName = CreateSecurityGroup)%'
           AND pattern LIKE '%($.eventName = DeleteSecurityGroup)%' then 'pass'
      else 'fail'
  end as status
from {{ ref('aws_compliance__log_metric_filter_and_alarm') }}
{% endmacro %}

{% macro bigquery__alarm_security_group_changes(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure a log metric filter and alarm exist for security group changes (Scored)' as title,
  account_id,
  cloud_watch_logs_log_group_arn as resource_id,
  case when pattern NOT LIKE '%NOT%'
           AND pattern LIKE '%($.eventName = AuthorizeSecurityGroupIngress)%'
           AND pattern LIKE '%($.eventName = AuthorizeSecurityGroupEgress)%'
           AND pattern LIKE '%($.eventName = RevokeSecurityGroupIngress)%'
           AND pattern LIKE '%($.eventName = RevokeSecurityGroupEgress)%'
           AND pattern LIKE '%($.eventName = CreateSecurityGroup)%'
           AND pattern LIKE '%($.eventName = DeleteSecurityGroup)%' then 'pass'
      else 'fail'
  end as status
from {{ ref('aws_compliance__log_metric_filter_and_alarm') }}
{% endmacro %}

{% macro snowflake__alarm_security_group_changes(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure a log metric filter and alarm exist for security group changes (Scored)' as title,
  account_id,
  cloud_watch_logs_log_group_arn as resource_id,
  case when pattern NOT LIKE '%NOT%'
           AND pattern LIKE '%($.eventName = AuthorizeSecurityGroupIngress)%'
           AND pattern LIKE '%($.eventName = AuthorizeSecurityGroupEgress)%'
           AND pattern LIKE '%($.eventName = RevokeSecurityGroupIngress)%'
           AND pattern LIKE '%($.eventName = RevokeSecurityGroupEgress)%'
           AND pattern LIKE '%($.eventName = CreateSecurityGroup)%'
           AND pattern LIKE '%($.eventName = DeleteSecurityGroup)%' then 'pass'
      else 'fail'
  end as status
from {{ ref('aws_compliance__log_metric_filter_and_alarm') }}
{% endmacro %}

{% macro athena__alarm_security_group_changes(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure a log metric filter and alarm exist for security group changes (Scored)' as title,
  account_id,
  cloud_watch_logs_log_group_arn as resource_id,
  case when pattern NOT LIKE '%NOT%'
           AND pattern LIKE '%($.eventName = AuthorizeSecurityGroupIngress)%'
           AND pattern LIKE '%($.eventName = AuthorizeSecurityGroupEgress)%'
           AND pattern LIKE '%($.eventName = RevokeSecurityGroupIngress)%'
           AND pattern LIKE '%($.eventName = RevokeSecurityGroupEgress)%'
           AND pattern LIKE '%($.eventName = CreateSecurityGroup)%'
           AND pattern LIKE '%($.eventName = DeleteSecurityGroup)%' then 'pass'
      else 'fail'
  end as status
from {{ ref('aws_compliance__log_metric_filter_and_alarm') }}
{% endmacro %}