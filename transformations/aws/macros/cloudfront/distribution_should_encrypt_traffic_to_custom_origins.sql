{% macro distribution_should_encrypt_traffic_to_custom_origins(framework, check_id) %}
  {{ return(adapter.dispatch('distribution_should_encrypt_traffic_to_custom_origins')(framework, check_id)) }}
{% endmacro %}

{% macro default__distribution_should_encrypt_traffic_to_custom_origins(framework, check_id) %}{% endmacro %}

{% macro postgres__distribution_should_encrypt_traffic_to_custom_origins(framework, check_id) %}
with origins as (
    select distinct
        arn,
        f -> 'CustomOriginConfig' ->> 'OriginProtocolPolicy' as policy
    from
        aws_cloudfront_distributions d,
		JSONB_ARRAY_ELEMENTS(distribution_config -> 'Origins' -> 'Items') as f  
    WHERE
        f -> 'CustomOriginConfig' ->> 'OriginProtocolPolicy' = 'http-only'
        or f -> 'CustomOriginConfig' ->> 'OriginProtocolPolicy' = 'match-viewer'   

),
cache_behaviors as (
    select distinct 
        arn
    from
        aws_cloudfront_distributions d,
		JSONB_ARRAY_ELEMENTS(
                case 
					when d_1.distribution_config ->> 'CacheBehaviors' is NULL then '[]'::jsonb
					when (d_1.distribution_config -> 'CacheBehaviors'::text) ->> 'Items' is NULL then '[]'::jsonb
					else COALESCE((d_1.distribution_config -> 'CacheBehaviors'::text) -> 'Items'::text, '[]'::jsonb) 
				end
        ) as f  
    where
        f ->> 'ViewerProtocolPolicy' = 'allow-all'
)
select distinct
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CloudFront distributions should encrypt traffic to custom origins' as title,
    d.account_id,
    d.arn as resource_id,
    CASE
        WHEN o.policy = 'http-only' THEN 'fail'
        WHEN o.policy = 'match-viewer' and (cb.arn is not null 
                                            or
                                            distribution_config -> 'DefaultCacheBehavior' ->> 'ViewerProtocolPolicy' = 'allow-all') 
                                            THEN 'fail'
        ELSE 'pass'
    END as status
    
from
    aws_cloudfront_distributions d
    LEFT JOIN origins as o on d.arn = o.arn
    LEFT JOIN cache_behaviors as cb on d.arn = cb.arn  
{% endmacro %}

{% macro snowflake__distribution_should_encrypt_traffic_to_custom_origins(framework, check_id) %}
with origins as (
    select distinct
        arn,
        f.value:CustomOriginConfig:OriginProtocolPolicy as policy
    from
        aws_cloudfront_distributions d,
        LATERAL FLATTEN(input => distribution_config:Origins:Items) as f
  
    WHERE
        f.value:CustomOriginConfig:OriginProtocolPolicy = 'http-only'
        or f.value:CustomOriginConfig:OriginProtocolPolicy = 'match-viewer'   

),
cache_behaviors as (
    select distinct 
        arn
    from
        aws_cloudfront_distributions d,
        LATERAL FLATTEN(input => COALESCE(distribution_config:CacheBehaviors:Items, ARRAY_CONSTRUCT())) as f
    where
        f.value:ViewerProtocolPolicy = 'allow-all'
)
select distinct
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CloudFront distributions should encrypt traffic to custom origins' as title,
    d.account_id,
    d.arn as resource_id,
    CASE
        WHEN o.policy = 'http-only' THEN 'fail'
        WHEN o.policy = 'match-viewer' and (cb.arn is not null 
                                            or
                                            distribution_config:DefaultCacheBehavior:ViewerProtocolPolicy = 'allow-all') 
                                            THEN 'fail'
        ELSE 'pass'
    END as status
    

from
    aws_cloudfront_distributions d
    LEFT JOIN origins as o on d.arn = o.arn
    LEFT JOIN cache_behaviors as cb on d.arn = cb.arn  
{% endmacro %}

{% macro bigquery__distribution_should_encrypt_traffic_to_custom_origins(framework, check_id) %}
with origins as (
    select distinct
        arn,
        JSON_VALUE(f.CustomOriginConfig.OriginProtocolPolicy) as policy
    from
        {{ full_table_name("aws_cloudfront_distributions") }} d,
 UNNEST(JSON_QUERY_ARRAY(distribution_config.Origins.Items)) AS f
    WHERE
        JSON_VALUE(f.CustomOriginConfig.OriginProtocolPolicy) = 'http-only'
        or JSON_VALUE(f.CustomOriginConfig.OriginProtocolPolicy) = 'match-viewer'   

),
cache_behaviors as (
    select distinct 
        arn
    from
        {{ full_table_name("aws_cloudfront_distributions") }} d,
 UNNEST(JSON_QUERY_ARRAY(distribution_config.CacheBehaviors.Items)) AS f
    where
        JSON_VALUE(f.ViewerProtocolPolicy) = 'allow-all'
)
select distinct
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CloudFront distributions should encrypt traffic to custom origins' as title,
    d.account_id,
    d.arn as resource_id,
    CASE
        WHEN o.policy = 'http-only' THEN 'fail'
        WHEN o.policy = 'match-viewer' and (cb.arn is not null 
                                            or
                                            JSON_VALUE(distribution_config.DefaultCacheBehavior.ViewerProtocolPolicy) = 'allow-all') 
                                            THEN 'fail'
        ELSE 'pass'
    END as status
    

from
    {{ full_table_name("aws_cloudfront_distributions") }} d
    LEFT JOIN origins as o on d.arn = o.arn
    LEFT JOIN cache_behaviors as cb on d.arn = cb.arn   
{% endmacro %}