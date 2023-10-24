{% macro kinesis_stream_encrypted(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Kinesis streams should be encrypted at rest' as title,
  account_id,
  arn as resource_id,
  case  
        WHEN ENCRYPTION_TYPE = 'KMS' THEN 'pass'
        else 'fail' end as status
from aws_kinesis_streams
{% endmacro %}