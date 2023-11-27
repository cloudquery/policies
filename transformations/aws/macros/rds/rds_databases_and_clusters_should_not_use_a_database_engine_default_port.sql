{% macro rds_databases_and_clusters_should_not_use_a_database_engine_default_port(framework, check_id) %}
  {{ return(adapter.dispatch('rds_databases_and_clusters_should_not_use_a_database_engine_default_port')(framework, check_id)) }}
{% endmacro %}

{% macro default__rds_databases_and_clusters_should_not_use_a_database_engine_default_port(framework, check_id) %}{% endmacro %}

{% macro postgres__rds_databases_and_clusters_should_not_use_a_database_engine_default_port(framework, check_id) %}
(
    select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'RDS databases and clusters should not use a database engine default port' as title,
    account_id,
    arn AS resource_id,
    case when
        (engine in ('aurora', 'aurora-mysql', 'mysql') and port = 3306) or (engine like '%postgres%' and port = 5432)
    then 'fail' else 'pass' end as status
    from aws_rds_clusters
)
union
(
    select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'RDS databases and clusters should not use a database engine default port' as title,
    account_id,
    arn AS resource_id,
    case when
        (
            engine in ('aurora', 'aurora-mysql', 'mariadb', 'mysql')
            and (endpoint ->> 'Port')::integer = 3306
        )
        or (engine like '%postgres%' and (endpoint ->> 'Port')::integer = 5432)
        or (engine like '%oracle%' and (endpoint ->> 'Port')::integer = 1521)
        or (engine like '%sqlserver%' and (endpoint ->> 'Port')::integer = 1433)
    then 'fail' else 'pass' end as status
    from aws_rds_instances
)
{% endmacro %}
