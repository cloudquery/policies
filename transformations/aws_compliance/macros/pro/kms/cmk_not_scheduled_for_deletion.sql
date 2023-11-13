{% macro cmk_not_scheduled_for_deletion(framework, check_id) %}
  {{ return(adapter.dispatch('cmk_not_scheduled_for_deletion')(framework, check_id)) }}
{% endmacro %}

{% macro default__cmk_not_scheduled_for_deletion(framework, check_id) %}{% endmacro %}

{% macro postgres__cmk_not_scheduled_for_deletion(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'AWS KMS keys should not be unintentionally deleted' as title,
    account_id,
    arn as resource_id,
    case when key_state = 'PendingDeletion' and key_manager = 'CUSTOMER' then 'fail' else 'pass' end as status
from aws_kms_keys
{% endmacro %}
