{% macro iam_access_keys_unused_more_than_90_days(framework, check_id) %}
  {{ return(adapter.dispatch('iam_access_keys_unused_more_than_90_days')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__iam_access_keys_unused_more_than_90_days(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Unused IAM user credentials should be removed' AS title,
    account_id,
    access_key_id AS resource_id,
    CASE 
        WHEN DATEDIFF('DAY', last_used, CURRENT_TIMESTAMP()) > 90 THEN 'fail'
        ELSE 'pass'
    END AS status
FROM aws_iam_user_access_keys
{% endmacro %}

{% macro postgres__iam_access_keys_unused_more_than_90_days(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Unused IAM user credentials should be removed' AS title,
    account_id,
    access_key_id AS resource_id,
    case when date_part('day', now() - last_used) > 90 then 'fail'
         else 'pass'
    end as status
from aws_iam_user_access_keys
{% endmacro %}
