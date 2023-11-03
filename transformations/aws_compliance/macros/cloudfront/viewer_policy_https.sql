{% macro viewer_policy_https(framework, check_id) %}
  {{ return(adapter.dispatch('viewer_policy_https')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__viewer_policy_https(framework, check_id) %}
wITH cachebeviors AS (
    -- Handle all non-defaults as well as when there is only a default route
    SELECT DISTINCT arn, account_id 
    FROM (
        SELECT arn, account_id, d.value AS CacheBehavior 
        FROM aws_cloudfront_distributions, 
        LATERAL FLATTEN(input => distribution_config:CacheBehaviors:Items) AS d 
        WHERE distribution_config:CacheBehaviors:Items IS NOT NULL
        UNION 
        -- Handle default Cachebehaviors
        SELECT arn, account_id, distribution_config:DefaultCacheBehavior AS CacheBehavior 
        FROM aws_cloudfront_distributions
    ) AS cachebeviors 
    WHERE CacheBehavior:ViewerProtocolPolicy::STRING = 'allow-all'
)
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CloudFront distributions should require encryption in transit' as title,
    account_id,
    arn as resource_id,
    'fail' as status
from cachebeviors
{% endmacro %}

{% macro postgres__viewer_policy_https(framework, check_id) %}
with cachebeviors as (
	-- Handle all non defaults as well as when there is only a default route
	select distinct arn, account_id from (select arn,account_id, d as CacheBehavior from aws_cloudfront_distributions, jsonb_array_elements(distribution_config->'CacheBehaviors'->'Items') as d where distribution_config->'CacheBehaviors'->'Items' != 'null' 
	union 
	-- 	Handle default Cachebehaviors
	select arn,account_id, distribution_config->'DefaultCacheBehavior' as CacheBehavior from aws_cloudfront_distributions) as cachebeviors where CacheBehavior->>'ViewerProtocolPolicy' = 'allow-all'
)

select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'CloudFront distributions should require encryption in transit' as title,
    account_id,
    arn as resource_id,
    'fail' as status
from cachebeviors{% endmacro %}
