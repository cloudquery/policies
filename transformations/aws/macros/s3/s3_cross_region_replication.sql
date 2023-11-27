{% macro s3_cross_region_replication(framework, check_id) %}
  {{ return(adapter.dispatch('s3_cross_region_replication')(framework, check_id)) }}
{% endmacro %}

{% macro default__s3_cross_region_replication(framework, check_id) %}{% endmacro %}

{% macro postgres__s3_cross_region_replication(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'S3 buckets with replication rules should be enabled' as title,
    aws_s3_buckets.account_id,
    aws_s3_buckets.arn as resource_id,
    case when
        r->>'Status' is distinct from 'Enabled'
    then 'fail' else 'pass' end as status
from
     aws_s3_buckets, JSONB_ARRAY_ELEMENTS(
         case jsonb_typeof(replication_rules)
         when 'array' then replication_rules
         else '[]' end
     ) as r
-- Note: This query doesn't validate that the destination bucket is actually in a different region
{% endmacro %}
