{% macro sqs_queues_should_be_encrypted_at_rest(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon SQS queues should be encrypted at rest' as title,
    account_id,
    arn as resource_id,
    case when
        (kms_master_key_id is null or kms_master_key_id = '') and sqs_managed_sse_enabled = false
    then 'fail' else 'pass' end as status
from aws_sqs_queues
{% endmacro %}