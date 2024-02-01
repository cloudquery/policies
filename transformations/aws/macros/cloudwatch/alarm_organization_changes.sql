{% macro alarm_organization_changes(framework, check_id) %}
  {{ return(adapter.dispatch('alarm_organization_changes')(framework, check_id)) }}
{% endmacro %}

{% macro default__alarm_organization_changes(framework, check_id) %}{% endmacro %}

{% macro postgres__alarm_organization_changes(framework, check_id) %}
CASE
        WHEN pattern NOT LIKE '%NOT%'
            AND pattern LIKE ANY (ARRAY[
                '%($.eventName = AcceptHandshake)%',
                '%($.eventName = AttachPolicy)%',
                '%($.eventName = CreateAccount)%',
                '%($.eventName = CreateOrganizationalUnit)%',
                '%($.eventName = CreatePolicy)%',
                '%($.eventName = DeclineHandshake)%',
                '%($.eventName = DeleteOrganization)%',
                '%($.eventName = DeleteOrganizationalUnit)%',
                '%($.eventName = DeletePolicy)%',
                '%($.eventName = DetachPolicy)%',
                '%($.eventName = DisablePolicyType)%',
                '%($.eventName = EnablePolicyType)%',
                '%($.eventName = InviteAccountToOrganization)%',
                '%($.eventName = LeaveOrganization)%',
                '%($.eventName = MoveAccount)%',
                '%($.eventName = RemoveAccountFromOrganization)%',
                '%($.eventName = UpdatePolicy)%',
                '%($.eventName = UpdateOrganizationalUnit)%'
            ]) THEN 'pass'
        ELSE 'fail'
        end as status
from {{ ref('aws_compliance__log_metric_filter_and_alarm') }}
{% endmacro %}

{% macro snowflake__alarm_organization_changes(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure a log metric filter and alarm exist for usage of "root" account (Score)' as title,
    account_id,
    cloud_watch_logs_log_group_arn as resource_id,
    CASE
        WHEN pattern NOT LIKE '%NOT%'
            AND pattern LIKE ANY (
                '%($.eventName = AcceptHandshake)%',
                '%($.eventName = AttachPolicy)%',
                '%($.eventName = CreateAccount)%',
                '%($.eventName = CreateOrganizationalUnit)%',
                '%($.eventName = CreatePolicy)%',
                '%($.eventName = DeclineHandshake)%',
                '%($.eventName = DeleteOrganization)%',
                '%($.eventName = DeleteOrganizationalUnit)%',
                '%($.eventName = DeletePolicy)%',
                '%($.eventName = DetachPolicy)%',
                '%($.eventName = DisablePolicyType)%',
                '%($.eventName = EnablePolicyType)%',
                '%($.eventName = InviteAccountToOrganization)%',
                '%($.eventName = LeaveOrganization)%',
                '%($.eventName = MoveAccount)%',
                '%($.eventName = RemoveAccountFromOrganization)%',
                '%($.eventName = UpdatePolicy)%',
                '%($.eventName = UpdateOrganizationalUnit)%'
            ) THEN 'pass'
        ELSE 'fail'
        end as status
from {{ ref('aws_compliance__log_metric_filter_and_alarm') }}
{% endmacro %}

{% macro bigquery__alarm_organization_changes(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure a log metric filter and alarm exist for usage of "root" account (Score)' as title,
    account_id,
    cloud_watch_logs_log_group_arn as resource_id,
    CASE
        WHEN pattern NOT LIKE '%NOT%'
            AND pattern LIKE ANY (
                '%($.eventName = AcceptHandshake)%',
                '%($.eventName = AttachPolicy)%',
                '%($.eventName = CreateAccount)%',
                '%($.eventName = CreateOrganizationalUnit)%',
                '%($.eventName = CreatePolicy)%',
                '%($.eventName = DeclineHandshake)%',
                '%($.eventName = DeleteOrganization)%',
                '%($.eventName = DeleteOrganizationalUnit)%',
                '%($.eventName = DeletePolicy)%',
                '%($.eventName = DetachPolicy)%',
                '%($.eventName = DisablePolicyType)%',
                '%($.eventName = EnablePolicyType)%',
                '%($.eventName = InviteAccountToOrganization)%',
                '%($.eventName = LeaveOrganization)%',
                '%($.eventName = MoveAccount)%',
                '%($.eventName = RemoveAccountFromOrganization)%',
                '%($.eventName = UpdatePolicy)%',
                '%($.eventName = UpdateOrganizationalUnit)%'
            ) THEN 'pass'
        ELSE 'fail'
        end as status
from {{ ref('aws_compliance__log_metric_filter_and_alarm') }}
{% endmacro %}