
#APIGateway.1
API_GW_EXECUTION_LOGGING_ENABLED = """
insert into aws_policy_results
(select distinct
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'API Gateway REST and WebSocket API logging should be enabled' as title,
    r.account_id,
    'arn:' || 'aws' || ':apigateway:' || r.region || ':/restapis/' || r.id as resource_id,
    case
        when s.logging_level not in ('"ERROR"', '"INFO"') then 'fail'
        else 'pass'
    end as status
from
    view_aws_apigateway_method_settings s
left join
    aws_apigateway_rest_apis r on s.rest_api_arn = r.arn
)

union

(select distinct
     :1 as execution_time,
     :2 as framework,
     :3 as check_id,
     'API Gateway REST and WebSocket API logging should be enabled' as title,
     a.account_id,
     'arn:' || 'aws' || ':apigateway:' || a.region || ':/apis/' || a.id as resource_id,
     case
         WHEN s.default_route_settings:LoggingLevel IN (NULL, 'OFF') THEN 'fail'
         else 'pass'
         end as status
from
    aws_apigatewayv2_api_stages s
left join
    aws_apigatewayv2_apis a on s.api_arn = a.arn
)
"""

#APIGateway.2
API_GW_STAGE_SHOULD_USE_SSL = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'API Gateway REST API stages should be configured to use SSL certificates for backend authentication' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN client_certificate_id is not null THEN 'pass'
        ELSE 'fail'
    END as status

from aws_apigateway_rest_api_stages
"""

#APIGateway.3
API_GW_STAGE_SHOULD_HAVE_XRAY_TRACING_ENABLED = """
insert into aws_policy_results
SELECT 
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'API Gateway REST API stages should have AWS X-Ray tracing enabled' as title,
    account_id, 
    arn as resource_id,
    CASE
        WHEN tracing_enabled = true THEN 'pass'
        ELSE 'fail'
    END as status
FROM 
    aws_apigateway_rest_api_stages
"""

#APIGateway.4
API_GW_ASSOCIATED_WTH_WAF = """
insert into aws_policy_results
SELECT 
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'API Gateway should be associated with a WAF Web ACL' as title,
    account_id, 
    arn as resource_id,
    CASE
        WHEN web_acl_arn is not null THEN 'pass'
        ELSE 'fail'
    END as status
FROM 
    aws_apigateway_rest_api_stages
"""

#APIGateway.5
API_GW_CACHE_DATA_ENCRYPTED = """
insert into aws_policy_results
with bad_methods as (
select DISTINCT
    arn

from aws_apigateway_rest_api_stages as s,
  LATERAL FLATTEN(input => COALESCE(s.method_settings, ARRAY_CONSTRUCT())) as ms
  
  WHERE
    ms.value:CachingEnabled = 'true'
    AND
    ms.value:CacheDataEncrypted <> 'true'
)
SELECT
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'API Gateway REST API cache data should be encrypted at rest' as title,
    s.account_id,
    s.arn as resource_id,
    CASE
        WHEN b.arn is not null THEN 'fail'
        ELSE 'pass'
    END as status
FROM 
    aws_apigateway_rest_api_stages s
    LEFT JOIN bad_methods as b
        ON s.arn = b.arn
"""

#APIGateway.8
API_GW_ROUTES_SHOULD_SPECIFY_AUTHORIZATION_TYPE = """
insert into aws_policy_results
SELECT
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'API Gateway routes should specify an authorization type' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN authorization_type IS NULL OR authorization_type = '' OR authorization_type = 'NONE' THEN 'fail'
        ELSE 'pass'
    END AS status
FROM 
    aws_apigatewayv2_api_routes
"""

#APIGateway.9
API_GW_ACCESS_LOGGING_SHOULD_BE_CONFIGURED = """
insert into aws_policy_results
SELECT
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Access logging should be configured for API Gateway V2 Stages' as title,
    account_id, 
    arn AS resource_id,
    CASE
        WHEN access_log_settings::text IS NULL OR access_log_settings = '' THEN 'fail'
        ELSE 'pass'
    END AS status
FROM 
    aws_apigatewayv2_api_stages
"""