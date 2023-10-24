{% macro databases_and_clusters_should_not_use_database_engine_default_port(framework, check_id) %}

(
    SELECT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS databases and clusters should not use a database engine default port' AS title,
    account_id,
    arn AS resource_id,
    CASE WHEN
        (engine IN ('aurora', 'aurora-mysql', 'mysql') AND port = 3306) OR (engine LIKE '%postgres%' AND port = 5432)
    THEN 'fail' ELSE 'pass' END AS status
    FROM aws_rds_clusters
)
UNION ALL
(
    SELECT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS databases and clusters should not use a database engine default port' AS title,
    account_id,
    arn AS resource_id,
    CASE WHEN
        (
            engine IN ('aurora', 'aurora-mysql', 'mariadb', 'mysql')
            AND db_instance_port = 3306
        )
        OR (engine LIKE '%postgres%' AND db_instance_port = 5432)
        OR (engine LIKE '%oracle%' AND db_instance_port = 1521)
        OR (engine LIKE '%sqlserver%' AND db_instance_port = 1433)
    THEN 'fail' ELSE 'pass' END AS status
    FROM aws_rds_instances
)
{% endmacro %}