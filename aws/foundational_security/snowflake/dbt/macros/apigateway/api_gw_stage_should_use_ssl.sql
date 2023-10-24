{% macro api_gw_stage_should_use_ssl(framework, check_id) %}
insert into aws_policy_results
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'API Gateway REST API stages should be configured to use SSL certificates for backend authentication' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN client_certificate_id is not null THEN 'pass'
        ELSE 'fail'
    END as status

from aws_apigateway_rest_api_stages
{% endmacro %}