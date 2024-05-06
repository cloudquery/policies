{% macro snapshots_should_prohibit_public_access(framework, check_id) %}
  {{ return(adapter.dispatch('snapshots_should_prohibit_public_access')(framework, check_id)) }}
{% endmacro %}

{% macro default__snapshots_should_prohibit_public_access(framework, check_id) %}{% endmacro %}

{% macro postgres__snapshots_should_prohibit_public_access(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'RDS snapshots should be private' as title,
    account_id,
    arn AS resource_id,
    case when
         (attrs ->> 'AttributeName' is not distinct from 'restore')
         and (attrs -> 'AttributeValues')::jsonb ? 'all'
    then 'fail' else 'pass' end as status
from aws_rds_cluster_snapshots, jsonb_array_elements(attributes) as attrs
{% endmacro %}
{% macro snowflake__snapshots_should_prohibit_public_access(framework, check_id) %}
SELECT
    'pci_dss_v3.2.1' AS framework,
    'rds.1' AS check_id,
    'RDS snapshots should be private' AS title,
    account_id,
    arn AS resource_id,
    CASE
        WHEN PARSE_JSON(attrs.value):AttributeName IS NOT DISTINCT FROM 'restore'
             AND ARRAY_CONTAINS(CAST('all' AS VARIANT), PARSE_JSON(attrs.value):AttributeValues)
        THEN 'fail'
        ELSE 'pass'
    END AS status
FROM aws_rds_cluster_snapshots,
LATERAL FLATTEN(INPUT => PARSE_JSON(attributes)) AS attrs
{% endmacro %}

{% macro bigquery__snapshots_should_prohibit_public_access(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'RDS snapshots should be private' as title,
    account_id,
    arn AS resource_id,
    case when
         (JSON_VALUE(attrs.AttributeName) is not distinct from 'restore')
         and JSON_VALUE(attrs.AttributeValues) = 'all'
    then 'fail' else 'pass' end as status
from {{ full_table_name("aws_rds_cluster_snapshots") }},
      UNNEST(JSON_QUERY_ARRAY(attributes)) as attrs
{% endmacro %}

{% macro athena__snapshots_should_prohibit_public_access(framework, check_id) %}
SELECT
    'pci_dss_v3.2.1' AS framework,
    'rds.1' AS check_id,
    'RDS snapshots should be private' AS title,
    account_id,
    arn AS resource_id,
    CASE
        WHEN json_extract_scalar(attrs, '$.AttributeName') IS NOT DISTINCT FROM 'restore'
             AND json_array_contains(json_extract(attrs, '$.AttributeValues'), 'all')
        THEN 'fail'
        ELSE 'pass'
    END AS status
FROM aws_rds_cluster_snapshots,
UNNEST(cast(json_extract(attributes, '$') as array(json))) as t(attrs)
{% endmacro %}