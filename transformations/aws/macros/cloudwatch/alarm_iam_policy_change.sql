{% macro alarm_iam_policy_change(framework, check_id) %}
  {{ return(adapter.dispatch('alarm_iam_policy_change')(framework, check_id)) }}
{% endmacro %}

{% macro default__alarm_iam_policy_change(framework, check_id) %}{% endmacro %}

{% macro postgres__alarm_iam_policy_change(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure a log metric filter and alarm exist for IAM policy changes (Score)' as title,
    account_id,
    cloud_watch_logs_log_group_arn as resource_id,
  case
      when pattern NOT LIKE '%NOT%'
          AND pattern LIKE '%($.eventName = DeleteGroupPolicy)%'
          AND pattern LIKE '%($.eventName = DeleteUserPolicy)%'
          AND pattern LIKE '%($.eventName = PutGroupPolicy)%'
          AND pattern LIKE '%($.eventName = PutRolePolicy)%'
          AND pattern LIKE '%($.eventName = PutUserPolicy)%'
          AND pattern LIKE '%($.eventName = CreatePolicy)%'
          AND pattern LIKE '%($.eventName = DeletePolicy)%'
          AND pattern LIKE '%($.eventName=CreatePolicyVersion)%'
          AND pattern LIKE '%($.eventName=DeletePolicyVersion)%'
          AND pattern LIKE '%($.eventName=AttachRolePolicy)%'
          AND pattern LIKE '%($.eventName=DetachRolePolicy)%'
          AND pattern LIKE '%($.eventName=AttachUserPolicy)%'
          AND pattern LIKE '%($.eventName = DetachUserPolicy)%'
          AND pattern LIKE '%($.eventName = AttachGroupPolicy)%'
          AND pattern LIKE '%($.eventName = DetachGroupPolicy)%' then 'pass'
      else 'fail'
  end as status
from {{ ref('aws_compliance__log_metric_filter_and_alarm') }}
{% endmacro %}

{% macro bigquery__alarm_iam_policy_change(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure a log metric filter and alarm exist for IAM policy changes (Score)' as title,
    account_id,
    cloud_watch_logs_log_group_arn as resource_id,
  case
      when pattern NOT LIKE '%NOT%'
          AND pattern LIKE '%($.eventName = DeleteGroupPolicy)%'
          AND pattern LIKE '%($.eventName = DeleteUserPolicy)%'
          AND pattern LIKE '%($.eventName = PutGroupPolicy)%'
          AND pattern LIKE '%($.eventName = PutRolePolicy)%'
          AND pattern LIKE '%($.eventName = PutUserPolicy)%'
          AND pattern LIKE '%($.eventName = CreatePolicy)%'
          AND pattern LIKE '%($.eventName = DeletePolicy)%'
          AND pattern LIKE '%($.eventName=CreatePolicyVersion)%'
          AND pattern LIKE '%($.eventName=DeletePolicyVersion)%'
          AND pattern LIKE '%($.eventName=AttachRolePolicy)%'
          AND pattern LIKE '%($.eventName=DetachRolePolicy)%'
          AND pattern LIKE '%($.eventName=AttachUserPolicy)%'
          AND pattern LIKE '%($.eventName = DetachUserPolicy)%'
          AND pattern LIKE '%($.eventName = AttachGroupPolicy)%'
          AND pattern LIKE '%($.eventName = DetachGroupPolicy)%' then 'pass'
      else 'fail'
  end as status
from {{ ref('aws_compliance__log_metric_filter_and_alarm') }}
{% endmacro %}

{% macro snowflake__alarm_iam_policy_change(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure a log metric filter and alarm exist for IAM policy changes (Score)' as title,
    account_id,
    cloud_watch_logs_log_group_arn as resource_id,
  case
      when pattern NOT LIKE '%NOT%'
          AND pattern LIKE '%($.eventName = DeleteGroupPolicy)%'
          AND pattern LIKE '%($.eventName = DeleteUserPolicy)%'
          AND pattern LIKE '%($.eventName = PutGroupPolicy)%'
          AND pattern LIKE '%($.eventName = PutRolePolicy)%'
          AND pattern LIKE '%($.eventName = PutUserPolicy)%'
          AND pattern LIKE '%($.eventName = CreatePolicy)%'
          AND pattern LIKE '%($.eventName = DeletePolicy)%'
          AND pattern LIKE '%($.eventName=CreatePolicyVersion)%'
          AND pattern LIKE '%($.eventName=DeletePolicyVersion)%'
          AND pattern LIKE '%($.eventName=AttachRolePolicy)%'
          AND pattern LIKE '%($.eventName=DetachRolePolicy)%'
          AND pattern LIKE '%($.eventName=AttachUserPolicy)%'
          AND pattern LIKE '%($.eventName = DetachUserPolicy)%'
          AND pattern LIKE '%($.eventName = AttachGroupPolicy)%'
          AND pattern LIKE '%($.eventName = DetachGroupPolicy)%' then 'pass'
      else 'fail'
  end as status
from {{ ref('aws_compliance__log_metric_filter_and_alarm') }}
{% endmacro %}

{% macro athena__alarm_iam_policy_change(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure a log metric filter and alarm exist for IAM policy changes (Score)' as title,
    account_id,
    cloud_watch_logs_log_group_arn as resource_id,
  case
      when pattern NOT LIKE '%NOT%'
          AND pattern LIKE '%($.eventName = DeleteGroupPolicy)%'
          AND pattern LIKE '%($.eventName = DeleteUserPolicy)%'
          AND pattern LIKE '%($.eventName = PutGroupPolicy)%'
          AND pattern LIKE '%($.eventName = PutRolePolicy)%'
          AND pattern LIKE '%($.eventName = PutUserPolicy)%'
          AND pattern LIKE '%($.eventName = CreatePolicy)%'
          AND pattern LIKE '%($.eventName = DeletePolicy)%'
          AND pattern LIKE '%($.eventName=CreatePolicyVersion)%'
          AND pattern LIKE '%($.eventName=DeletePolicyVersion)%'
          AND pattern LIKE '%($.eventName=AttachRolePolicy)%'
          AND pattern LIKE '%($.eventName=DetachRolePolicy)%'
          AND pattern LIKE '%($.eventName=AttachUserPolicy)%'
          AND pattern LIKE '%($.eventName = DetachUserPolicy)%'
          AND pattern LIKE '%($.eventName = AttachGroupPolicy)%'
          AND pattern LIKE '%($.eventName = DetachGroupPolicy)%' then 'pass'
      else 'fail'
  end as status
from {{ ref('aws_compliance__log_metric_filter_and_alarm') }}
{% endmacro %}

