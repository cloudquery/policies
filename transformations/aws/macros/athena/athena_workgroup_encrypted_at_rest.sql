{% macro athena_workgroup_encrypted_at_rest(framework, check_id) %}
  {{ return(adapter.dispatch('athena_workgroup_encrypted_at_rest')(framework, check_id)) }}
{% endmacro %}

{% macro default__athena_workgroup_encrypted_at_rest(framework, check_id) %}{% endmacro %}

{% macro postgres__athena_workgroup_encrypted_at_rest(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Athena workgroups should be encrypted at rest' AS "title",
  account_id,
  arn as resource_id,
  case  
        WHEN CONFIGURATION -> 'ResultConfiguration' ->> 'EncryptionConfiguration' IS NULL THEN 'fail'
        else 'pass' end as status
from aws_athena_work_groups
{% endmacro %}

{% macro snowflake__athena_workgroup_encrypted_at_rest(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Athena workgroups should be encrypted at rest' AS "title",
  account_id,
  arn as resource_id,
  case  
        WHEN CONFIGURATION:ResultConfiguration:EncryptionConfiguration::STRING IS NULL THEN 'fail'
        else 'pass' end as status
from aws_athena_work_groups
{% endmacro %}

{% macro bigquery__athena_workgroup_encrypted_at_rest(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Athena workgroups should be encrypted at rest' AS title,
  account_id,
  arn as resource_id,
  case  
        WHEN CAST(JSON_VALUE(CONFIGURATION.ResultConfiguration.EncryptionConfiguration) AS STRING) IS NULL THEN 'fail'
        else 'pass' end as status
from {{ full_table_name("aws_athena_work_groups") }}
{% endmacro %}