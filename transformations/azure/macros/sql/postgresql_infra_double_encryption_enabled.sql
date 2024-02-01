{% macro sql_postgresql_infrastructure_double_encryption(framework, check_id) %}
  {{ return(adapter.dispatch('sql_postgresql_infrastructure_double_encryption')(framework, check_id)) }}
{% endmacro %}

{% macro default__sql_postgresql_infrastructure_double_encryption(framework, check_id) %}{% endmacro %}

{% macro postgres__sql_postgresql_infrastructure_double_encryption(framework, check_id) %}
WITH value_check AS (
    SELECT aps._cq_id, apsc.properties->>'infrastructureEncryption' as "value"
    FROM azure_postgresql_servers aps
        LEFT JOIN azure_postgresql_server_configurations apsc ON
            aps._cq_id = apsc._cq_parent_id
)

SELECT
  s.id AS server_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure "Infrastructure double encryption" for PostgreSQL Database Server is "Enabled" (Automated)' as title,
  s.subscription_id,
  case
    when v.value IS NULL OR v.value != 'Enabled'
      then 'fail' else 'pass'
  end
FROM azure_postgresql_servers s
    LEFT JOIN value_check v ON
        s._cq_id = v._cq_id
{% endmacro %}

{% macro snowflake__sql_postgresql_infrastructure_double_encryption(framework, check_id) %}
WITH value_check AS (
    SELECT aps._cq_id, apsc.properties:infrastructureEncryption as value
    FROM azure_postgresql_servers aps
        LEFT JOIN azure_postgresql_server_configurations apsc ON
            aps._cq_id = apsc._cq_parent_id
)

SELECT
  s.id AS server_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure "Infrastructure double encryption" for PostgreSQL Database Server is "Enabled" (Automated)' as title,
  s.subscription_id,
  case
    when v.value IS NULL OR v.value != 'Enabled'
      then 'fail' else 'pass'
  end
FROM azure_postgresql_servers s
    LEFT JOIN value_check v ON
        s._cq_id = v._cq_id
{% endmacro %}

{% macro bigquery__sql_postgresql_infrastructure_double_encryption(framework, check_id) %}
WITH value_check AS (
    SELECT aps._cq_id, JSON_VALUE(apsc.properties.infrastructureEncryption) as prop
    FROM {{ full_table_name("azure_postgresql_servers") }} aps
        LEFT JOIN {{ full_table_name("azure_postgresql_server_configurations") }} apsc ON
            aps._cq_id = apsc._cq_parent_id
)

SELECT
  s.id AS server_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure "Infrastructure double encryption" for PostgreSQL Database Server is "Enabled" (Automated)' as title,
  s.subscription_id,
  case
    when v.prop IS NULL OR v.prop != 'Enabled'
      then 'fail' else 'pass'
  end
FROM {{ full_table_name("azure_postgresql_servers") }} s
    LEFT JOIN value_check v ON
        s._cq_id = v._cq_id
{% endmacro %}
