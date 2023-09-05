
#CloudFront.1
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
"""

#CloudFront.2
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
"""

#CloudFront.3
VIEWER_POLICY_HTTPS = """
insert into aws_policy_results
WITH cachebeviors AS (
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
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'CloudFront distributions should require encryption in transit' as title,
    account_id,
    arn as resource_id,
    'fail' as status
from cachebeviors
"""

#CloudFront.4
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

#CloudFront.5
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
"""

#CloudFront.6
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
"""

#CloudFront.7
DISTRIBUTION_SHOULD_USE_SSL_TLS_CERTIFICATES = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'CloudFront distributions should use custom SSL/TLS certificates' as title,
    account_id,
    arn as resource_id,
    CASE 
        WHEN (distribution_config:ViewerCertificate:ACMCertificateArn is null
            AND
            distribution_config:ViewerCertificate:IAMCertificateId is null
            ) 
            OR distribution_config:ViewerCertificate:CloudFrontDefaultCertificate = true
        THEN 'fail'
        ELSE 'pass'
    END as status
from aws_cloudfront_distributions
"""

#CloudFront.8
DISTRIBUTION_SHOULD_USE_SNI = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'CloudFront distributions should use SNI to serve HTTPS requests' as title,
    account_id,
    arn as resource_id,
    CASE 
        WHEN distribution_config:ViewerCertificate:SSLSupportMethod <> 'sni-only'
        THEN 'fail'
        ELSE 'pass'
    END as status
from aws_cloudfront_distributions
"""

#CloudFront.9
DISTRIBUTION_SHOULD_ENCRYPT_TRAFFIC_TO_CUSTOM_ORIGINS = """
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
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
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
"""

#CloudFront.10
DISTRIBUTION_SHOULD_NOT_USE_DEPRICATED_SSL_PROTOCOLS = """
insert into aws_policy_results
WITH origins_with_sslv3 AS (
SELECT DISTINCT
    arn,
    o.value:Id AS origin_id
FROM
    aws_cloudfront_distributions
, LATERAL FLATTEN(input => COALESCE(distribution_config:Origins:Items, ARRAY_CONSTRUCT())) AS o
WHERE
    ARRAY_CONTAINS('SSLv3'::variant, o.value:CustomOriginConfig:OriginSslProtocols:Items::ARRAY)
)

SELECT
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'CloudFront distributions should not use deprecated SSL protocols between edge locations and custom origins' as title,
    d.arn as resource_id,
    d.account_id,
    CASE
        WHEN o.arn is null THEN 'pass'
        ELSE 'fail'
    END as status
FROM
    aws_cloudfront_distributions d
    LEFT JOIN origins_with_sslv3 o
    ON d.arn = o.arn
"""

#CloudFront.12
DISTRIBUTION_SHOULD_NOT_POINT_TO_NON_EXISTENT_S3_ORIGINS = """
insert into aws_policy_results
WITH s3_origins AS (
    SELECT DISTINCT
        arn,
        o.value:DomainName AS s3_domain_name
    FROM
        aws_cloudfront_distributions
    , LATERAL FLATTEN(input => COALESCE(distribution_config:Origins:Items, ARRAY_CONSTRUCT())) AS o
    WHERE
        (o.value:S3OriginConfig IS NOT NULL OR o.value:S3OriginConfig <> 'null')
        AND o.value:DomainName LIKE '%.s3.%'
),
s3_origins_no_bucket AS (
SELECT DISTINCT
    s.arn
FROM
    s3_origins s
LEFT JOIN aws_s3_buckets b ON SPLIT_PART(s3_domain_name, '.', 1) = b.name
WHERE b.name is null
 
 )
SELECT DISTINCT
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'CloudFront distributions should not point to non-existent S3 origins' as title,
    d.account_id,
    d.arn as resouce_id,
    CASE
        WHEN o.arn is null THEN 'pass'
        ELSE 'fail'
    END as status
    
FROM aws_cloudfront_distributions d 
    LEFT JOIN s3_origins_no_bucket o 
    ON d.arn = o.arn
"""

#CloudFront.13
DISTRIBUTION_SHOULD_USE_ORIGIN_ACCESS_CONTROL = """
WITH s3_origins AS (
    SELECT DISTINCT
        arn,
        o.value:DomainName AS s3_domain_name,
        o.value:OriginAccessControlId::STRING AS origin_access_control_id
    FROM
        aws_cloudfront_distributions
    , LATERAL FLATTEN(input => COALESCE(distribution_config:Origins:Items, ARRAY_CONSTRUCT())) AS o
    WHERE
        o.value:S3OriginConfig IS NOT NULL
        AND o.value:DomainName LIKE '%.s3.%'
),
s3_origins_with_buckets AS (
SELECT DISTINCT
    s.arn,
    s.origin_access_control_id
FROM
    s3_origins s
INNER JOIN aws_s3_buckets b ON SPLIT_PART(s3_domain_name, '.', 1) = b.name
 )
  
SELECT DISTINCT
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'CloudFront distributions should use origin access control' as title,
    d.account_id,
    d.arn as resouce_id,
    CASE
        WHEN o.arn is not null 
            and (o.origin_access_control_id is null 
            or o.origin_access_control_id = '') THEN 'fail'
        ELSE 'pass'
    END as status
    
FROM aws_cloudfront_distributions as d 
LEFT JOIN s3_origins_with_buckets as o ON d.arn = o.arn
"""