{% macro elbv1_desync_migration_mode_defensive_or_strictest(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Classic Load Balancer should be configured with defensive or strictest desync mitigation mode' as title,
    account_id,
    arn as resource_id,
    case
        WHEN aa.value:Value in ('defensive', 'strictest') THEN 'pass'
        ELSE 'fail'
    END as status
FROM
    aws_elbv1_load_balancers as lb,
    LATERAL FLATTEN(input => attributes:AdditionalAttributes) aa
WHERE
    aa.value:Key = 'elb.http.desyncmitigationmode'   
{% endmacro %}