{% macro rds_snapshots_public_prohibited(framework, check_id) %}
  {{ return(adapter.dispatch('rds_snapshots_public_prohibited')(framework, check_id)) }}
{% endmacro %}

{% macro default__rds_snapshots_public_prohibited(framework, check_id) %}{% endmacro %}

{% macro postgres__rds_snapshots_public_prohibited(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS snapshot should be private' AS title,
    account_id,
    arn AS resource_id,
    CASE 
        WHEN a ->> 'AttributeName' = 'restore'
		AND a -> 'AttributeValues' ? 'all'
		THEN 'fail'
        ELSE 'pass'
    END AS status
FROM
    aws_rds_cluster_snapshots,
	JSONB_ARRAY_ELEMENTS(ATTRIBUTES) AS a
UNION
SELECT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS snapshot should be private' AS title,
    account_id,
    arn AS resource_id,
    CASE 
        WHEN a ->> 'AttributeName' = 'restore' 
		AND a -> 'AttributeValues' ? 'all'
		THEN 'fail'
        ELSE 'pass'
    END AS status
FROM
    aws_rds_db_snapshots,
	JSONB_ARRAY_ELEMENTS(ATTRIBUTES) AS a
{% endmacro %}

{% macro snowflake__rds_snapshots_public_prohibited(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS snapshot should be private' AS title,
    account_id,
    arn AS resource_id,
    CASE 
        WHEN a.value:AttributeName = 'restore' and ARRAY_CONTAINS('all'::variant, a.value:AttributeValues) THEN 'fail'
        ELSE 'pass'
    END AS status
FROM
    aws_rds_cluster_snapshots,
    LATERAL FLATTEN(ATTRIBUTES) a

UNION

SELECT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS snapshot should be private' AS title,
    account_id,
    arn AS resource_id,
    CASE 
        WHEN a.value:AttributeName = 'restore' and ARRAY_CONTAINS('all'::variant, a.value:AttributeValues) THEN 'fail'
        ELSE 'pass'
    END AS status
FROM
    aws_rds_db_snapshots,
    LATERAL FLATTEN(ATTRIBUTES) a
{% endmacro %}

{% macro bigquery__rds_snapshots_public_prohibited(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS snapshot should be private' AS title,
    account_id,
    arn AS resource_id,
    CASE 
        WHEN JSON_VALUE(a.AttributeName) = 'restore' and 'all' IN UNNEST(JSON_EXTRACT_STRING_ARRAY(a.AttributeValues)) THEN 'fail'
        ELSE 'pass'
    END AS status
FROM
    {{ full_table_name("aws_rds_cluster_snapshots") }},
    UNNEST(JSON_QUERY_ARRAY(ATTRIBUTES)) AS a

UNION ALL

SELECT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS snapshot should be private' AS title,
    account_id,
    arn AS resource_id,
    CASE 
        WHEN JSON_VALUE(a.AttributeName) = 'restore' and 'all' IN UNNEST(JSON_EXTRACT_STRING_ARRAY(a.AttributeValues)) THEN 'fail'
        ELSE 'pass'
    END AS status
FROM
    {{ full_table_name("aws_rds_db_snapshots") }},
    UNNEST(JSON_QUERY_ARRAY(ATTRIBUTES)) AS a
{% endmacro %}

{% macro athena__rds_snapshots_public_prohibited(framework, check_id) %}
select * from (
WITH Snapshot_Attributes AS (
    SELECT
        '{{framework}}' AS framework,
        '{{check_id}}' AS check_id,
        'RDS snapshot should be private' AS title,
        account_id,
        arn AS resource_id,
        attribute
    FROM aws_rds_cluster_snapshots
    CROSS JOIN UNNEST(CAST(json_parse(attributes) as array(json))) AS t(attribute)
    
    UNION ALL
    
    SELECT
        '{{framework}}' AS framework,
        '{{check_id}}' AS check_id,
        'RDS snapshot should be private' AS title,
        account_id,
        arn AS resource_id,
        attribute
    FROM aws_rds_db_snapshots
    CROSS JOIN UNNEST(CAST(json_parse(attributes) as array(json))) AS t(attribute)
)

SELECT
    framework,
    check_id,
    title,
    account_id,
    resource_id,
    CASE 
        WHEN json_extract_scalar(attribute, '$.Name') = 'restore' AND contains(cast(json_extract(attribute, '$.Value') as array(varchar)), 'all')
        THEN 'fail'
        ELSE 'pass'
    END AS status
FROM Snapshot_Attributes
)
{% endmacro %}