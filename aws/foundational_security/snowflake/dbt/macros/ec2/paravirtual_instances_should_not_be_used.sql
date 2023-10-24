{% macro paravirtual_instances_should_not_be_used(framework, check_id) %}
insert into aws_policy_results
SELECT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon EC2 paravirtual instance types should not be used' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN virtualization_type = 'paravirtual' THEN 'fail'
    ELSE 'pass'
    END as status
FROM aws_ec2_instances
{% endmacro %}