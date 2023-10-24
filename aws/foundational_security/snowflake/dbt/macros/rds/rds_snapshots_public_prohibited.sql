{% macro rds_snapshots_public_prohibited(framework, check_id) %}
INSERT INTO aws_policy_results
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
    LATERAL FLATTEN(ATTRIBUTES) a;
{% endmacro %}