{% macro neptune_cluster_snapshot_public_prohibited(framework, check_id) %}
  {{ return(adapter.dispatch('neptune_cluster_snapshot_public_prohibited')(framework, check_id)) }}
{% endmacro %}

{% macro default__neptune_cluster_snapshot_public_prohibited(framework, check_id) %}{% endmacro %}

{% macro postgres__neptune_cluster_snapshot_public_prohibited(framework, check_id) %}
SELECT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'Neptune DB cluster snapshots should not be public' AS title,
    account_id,
    arn AS resource_id,
    CASE
        WHEN a ->> 'AttributeName' = 'restore' AND a -> 'AttributeValues' ? 'all'
        THEN 'fail'
        ELSE 'pass'
    END AS status
FROM 
    aws_neptune_cluster_snapshots,
    JSONB_ARRAY_ELEMENTS(attributes) AS a
{% endmacro %}

{% macro snowflake__neptune_cluster_snapshot_public_prohibited(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Neptune DB cluster snapshots should not be public' as title,
    account_id,
    arn as resource_id,
    case when
    a.value:AttributeName = 'restore' and ARRAY_CONTAINS('all'::variant, attributes[0]:AttributeValues) then 'fail'
    else 'pass'
    end as status
from 
    aws_neptune_cluster_snapshots,
    LATERAL FLATTEN(attributes) a
{% endmacro %}

{% macro bigquery__neptune_cluster_snapshot_public_prohibited(framework, check_id) %}
SELECT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'Neptune DB cluster snapshots should not be public' AS title,
    account_id,
    arn AS resource_id,
    CASE
        WHEN JSON_VALUE(a.AttributeName) = 'restore' 
        AND 'all' IN UNNEST(JSON_EXTRACT_STRING_ARRAY(a.AttributeValues))
        THEN 'fail'
        ELSE 'pass'
    END AS status
FROM 
    {{ full_table_name("aws_neptune_cluster_snapshots") }},
    UNNEST(JSON_QUERY_ARRAY(attributes)) AS a
{% endmacro %}

{% macro athena__neptune_cluster_snapshot_public_prohibited(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Neptune DB cluster snapshots should not be public' as title,
    account_id,
    arn as resource_id,
    case when
    json_extract_scalar(a, '$.AttributeName') = 'restore' and contains(cast(json_extract(a, '$.AttributeValues') as array(varchar)), 'all')
    then 'fail'
    else 'pass'
    end as status
from 
    aws_neptune_cluster_snapshots,
    unnest(cast(json_parse(attributes) as array(json))) as a(a)
    {% endmacro %}