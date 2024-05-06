{% macro dax_encrypted_at_rest(framework, check_id) %}
  {{ return(adapter.dispatch('dax_encrypted_at_rest')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__dax_encrypted_at_rest(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'DynamoDB Accelerator (DAX) clusters should be encrypted at rest' as title,
    account_id,
    arn as resource_id,
  case when
    sse_description:Status is distinct from 'ENABLED'
    then 'fail'
    else 'pass'
  end as status
from aws_dax_clusters
{% endmacro %}

{% macro postgres__dax_encrypted_at_rest(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'DynamoDB Accelerator (DAX) clusters should be encrypted at rest' as title,
    account_id,
    arn as resource_id,
  case when
    sse_description->>'Status' is distinct from 'ENABLED'
    then 'fail'
    else 'pass'
  end as status
from aws_dax_clusters
{% endmacro %}

{% macro default__dax_encrypted_at_rest(framework, check_id) %}{% endmacro %}

{% macro bigquery__dax_encrypted_at_rest(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'DynamoDB Accelerator (DAX) clusters should be encrypted at rest' as title,
    account_id,
    arn as resource_id,
  case when
    JSON_VALUE(sse_description.Status) is distinct from 'ENABLED'
    then 'fail'
    else 'pass'
  end as status
from {{ full_table_name("aws_dax_clusters") }}
{% endmacro %}

{% macro athena__dax_encrypted_at_rest(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'DynamoDB Accelerator (DAX) clusters should be encrypted at rest' as title,
    account_id,
    arn as resource_id,
  case when
    json_extract_scalar(sse_description, '$.Status') is distinct from 'ENABLED'
    then 'fail'
    else 'pass'
  end as status
from aws_dax_clusters
{% endmacro %}