
DEFAULT_ROOT_OBJECT_CONFIGURED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'CloudFront distributions should have a default root object configured' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN distribution_config:DefaultRootObject::STRING = '' THEN 'fail'
        ELSE 'pass'
    END AS status
from aws_cloudfront_distributions
where $where$
"""

ORIGIN_ACCESS_IDENTITY_ENABLED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'CloudFront distributions should have origin access identity enabled' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN o.value:DomainName::STRING LIKE '%s3.amazonaws.com' AND o.value:S3OriginConfig:OriginAccessIdentity::STRING = '' THEN 'fail'
        ELSE 'pass'
    END AS status
from aws_cloudfront_distributions, LATERAL FLATTEN(input => distribution_config:Origins:Items) o
where $where:aws_cloudfront_distributions$
"""

VIEWER_POLICY_HTTPS = """
insert into aws_policy_results
WITH cachebeviors AS (
    -- Handle all non-defaults as well as when there is only a default route
    SELECT DISTINCT arn, account_id 
    FROM (
        SELECT arn, account_id, d.value AS CacheBehavior 
        FROM aws_cloudfront_distributions, 
        LATERAL FLATTEN(input => distribution_config:CacheBehaviors:Items) AS d 
        WHERE distribution_config:CacheBehaviors:Items IS NOT NULL AND $where:aws_cloudfront_distributions$
        UNION 
        -- Handle default Cachebehaviors
        SELECT arn, account_id, distribution_config:DefaultCacheBehavior AS CacheBehavior 
        FROM aws_cloudfront_distributions
        WHERE $where:aws_cloudfront_distributions$
    ) AS cachebeviors 
    WHERE CacheBehavior:ViewerProtocolPolicy::STRING = 'allow-all'
)
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'CloudFront distributions should require encryption in transit' as title,
    account_id,
    arn as resource_id,
    'fail' as status
from cachebeviors
"""

ORIGIN_FAILOVER_ENABLED = """
insert into aws_policy_results
with origin_groups as ( select acd.arn, distribution_config:OriginGroups:Items as ogs from aws_cloudfront_distributions acd),
     oids as (
select distinct
    account_id,
    acd.arn as resource_id,
    case
            when o.ogs = 'null' or
            o.ogs:Members:Items = 'null' or
            ARRAY_SIZE(o.ogs:Members:Items) = 0  then 'fail'
    else 'pass'
    end as status
from aws_cloudfront_distributions acd
    left join origin_groups o on o.arn = acd.arn
where $where:acd$
)
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'CloudFront distributions should have origin failover configured' as title,
    account_id,
    resource_id,
    status
from oids
"""

ACCESS_LOGS_ENABLED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'CloudFront distributions should have logging enabled' as title,
    account_id,
    arn as resource_id,
    case
        when (distribution_config:Logging:Enabled)::boolean is distinct from true then 'fail'
        else 'pass'
    end as status
from aws_cloudfront_distributions
where $where$
"""

ASSOCIATED_WITH_WAF = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'API Gateway should be associated with an AWS WAF web ACL' as title,
    account_id,
    arn as resource_id,
    case
        when distribution_config:WebACLId = '' then 'fail'
        else 'pass'
    end as status
from aws_cloudfront_distributions
where $where$
"""
