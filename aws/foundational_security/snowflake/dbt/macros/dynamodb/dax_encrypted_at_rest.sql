{% macro dax_encrypted_at_rest(framework, check_id) %}
insert into aws_policy_results
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