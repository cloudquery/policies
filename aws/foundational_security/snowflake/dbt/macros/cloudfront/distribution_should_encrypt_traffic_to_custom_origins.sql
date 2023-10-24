{% macro distribution_should_encrypt_traffic_to_custom_origins(framework, check_id) %}
insert into aws_policy_results
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