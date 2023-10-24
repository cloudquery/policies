{% macro api_gw_routes_should_specify_authorization_type(framework, check_id) %}
insert into aws_policy_results
SELECT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'API Gateway routes should specify an authorization type' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN authorization_type IS NULL OR authorization_type = '' OR authorization_type = 'NONE' THEN 'fail'
        ELSE 'pass'
    END AS status
FROM 
    aws_apigatewayv2_api_routes
{% endmacro %}