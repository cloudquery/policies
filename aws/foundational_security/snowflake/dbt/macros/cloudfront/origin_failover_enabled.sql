{% macro origin_failover_enabled(framework, check_id) %}
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
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CloudFront distributions should have origin failover configured' as title,
    account_id,
    resource_id,
    status
from oids
{% endmacro %}