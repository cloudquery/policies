{% macro keys_not_unintentionally_deleted(framework, check_id) %}
  {{ return(adapter.dispatch('keys_not_unintentionally_deleted')(framework, check_id)) }}
{% endmacro %}

{% macro default__keys_not_unintentionally_deleted(framework, check_id) %}{% endmacro %}

{% macro postgres__keys_not_unintentionally_deleted(framework, check_id) %}
select 
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'AWS KMS keys should not be deleted unintentionally' AS title,
    account_id,
    arn AS resource_id,
    CASE 
        WHEN key_state IN ('PendingDeletion', 'PendingReplicaDeletion') AND key_manager = 'CUSTOMER' THEN 'fail'
        ELSE 'pass'
    END AS status
FROM    
    aws_kms_keys
{% endmacro %}

{% macro snowflake__keys_not_unintentionally_deleted(framework, check_id) %}
select 
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'AWS KMS keys should not be deleted unintentionally' AS title,
    account_id,
    arn AS resource_id,
    CASE 
        WHEN key_state IN ('PendingDeletion', 'PendingReplicaDeletion') AND key_manager = 'CUSTOMER' THEN 'fail'
        ELSE 'pass'
    END AS status
FROM    
    aws_kms_keys
{% endmacro %}

{% macro bigquery__keys_not_unintentionally_deleted(framework, check_id) %}
select 
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'AWS KMS keys should not be deleted unintentionally' AS title,
    account_id,
    arn AS resource_id,
    CASE 
        WHEN key_state IN ('PendingDeletion', 'PendingReplicaDeletion') AND key_manager = 'CUSTOMER' THEN 'fail'
        ELSE 'pass'
    END AS status
FROM    
    {{ full_table_name("aws_kms_keys") }}
{% endmacro %}