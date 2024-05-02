{% macro alarm_organization_changes(framework, check_id) %}
  {{ return(adapter.dispatch('alarm_organization_changes')(framework, check_id)) }}
{% endmacro %}

{% macro default__alarm_organization_changes(framework, check_id) %}{% endmacro %}

{% macro postgres__alarm_organization_changes(framework, check_id) %}
SELECT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'Ensure a log metric filter and alarm exist for usage of "root" account (Score)' AS title,
    account_id,
    cloud_watch_logs_log_group_arn AS resource_id,
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

{% macro athena__alarm_organization_changes(framework, check_id) %}
SELECT
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure a log metric filter and alarm exist for usage of "root" account (Score)' as title,
    account_id,
    cloud_watch_logs_log_group_arn as resource_id,
    CASE
        WHEN pattern NOT LIKE '%NOT%'
            AND (
                pattern LIKE '%($.eventName = AcceptHandshake)%' OR
                pattern LIKE '%($.eventName = AttachPolicy)%' OR
                pattern LIKE '%($.eventName = CreateAccount)%' OR
                pattern LIKE '%($.eventName = CreateOrganizationalUnit)%' OR
                pattern LIKE '%($.eventName = CreatePolicy)%' OR
                pattern LIKE '%($.eventName = DeclineHandshake)%' OR
                pattern LIKE '%($.eventName = DeleteOrganization)%' OR
                pattern LIKE '%($.eventName = DeleteOrganizationalUnit)%' OR
                pattern LIKE '%($.eventName = DeletePolicy)%' OR
                pattern LIKE '%($.eventName = DetachPolicy)%' OR
                pattern LIKE '%($.eventName = DisablePolicyType)%' OR
                pattern LIKE '%($.eventName = EnablePolicyType)%' OR
                pattern LIKE '%($.eventName = InviteAccountToOrganization)%' OR
                pattern LIKE '%($.eventName = LeaveOrganization)%' OR
                pattern LIKE '%($.eventName = MoveAccount)%' OR
                pattern LIKE '%($.eventName = RemoveAccountFromOrganization)%' OR
                pattern LIKE '%($.eventName = UpdatePolicy)%' OR
                pattern LIKE '%($.eventName = UpdateOrganizationalUnit)%'
            ) THEN 'pass'
        ELSE 'fail'
    END as status
from {{ ref('aws_compliance__log_metric_filter_and_alarm') }}
{% endmacro %}