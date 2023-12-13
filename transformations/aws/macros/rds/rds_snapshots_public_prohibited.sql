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