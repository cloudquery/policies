{% macro logs_encrypted(framework, check_id) %}
insert into aws_policy_results
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CloudTrail should have encryption at rest enabled' as title,
    account_id,
    arn as resource_id,
    case
        when kms_key_id is NULL then 'fail'
        else 'pass'
    end as status
FROM aws_cloudtrail_trails
{% endmacro %}