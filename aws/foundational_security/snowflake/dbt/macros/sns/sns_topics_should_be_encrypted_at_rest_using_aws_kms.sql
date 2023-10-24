{% macro sns_topics_should_be_encrypted_at_rest_using_aws_kms(framework, check_id) %}
insert into aws_policy_results
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'SNS topics should be encrypted at rest using AWS KMS' as title,
    account_id,
    arn as resource_id,
    case when
        kms_master_key_id is null or kms_master_key_id = ''
    then 'fail' else 'pass' end as status
from aws_sns_topics
{% endmacro %}