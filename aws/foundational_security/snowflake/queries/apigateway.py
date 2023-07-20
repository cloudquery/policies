
API_GW_EXECUTION_LOGGING_ENABLED = """
insert into aws_policy_results
(select distinct
    %s as execution_time,
    %s as framework,
    %s as check_id,
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
     %s as execution_time,
     %s as framework,
     %s as check_id,
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