{% macro sql_mysql_tls_v_1_2_set(framework, check_id) %}
  {{ return(adapter.dispatch('sql_mysql_tls_v_1_2_set')(framework, check_id)) }}
{% endmacro %}

{% macro default__sql_mysql_tls_v_1_2_set(framework, check_id) %}{% endmacro %}

{% macro postgres__sql_mysql_tls_v_1_2_set(framework, check_id) %}
WITH value_check AS (
    SELECT msql_fss._cq_id, msql_fsc.properties->>'value' as "value"
    FROM azure_mysqlflexibleservers_servers msql_fss
        LEFT JOIN azure_mysqlflexibleservers_server_configurations msql_fsc ON
            msql_fss._cq_id = msql_fsc._cq_parent_id
        WHERE msql_fsc.name = 'tls_version'
)

SELECT
  s.id AS server_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure "TLS Version" is set to "TLSV1.2" for MySQL flexible Database Server (Automated)' as title,
  s.subscription_id,
  case
    when v.value IS NULL OR v.value != 'TLSv1.2'
      then 'fail' else 'pass'
  end
FROM azure_mysqlflexibleservers_servers s
    LEFT JOIN value_check v ON
        s._cq_id = v._cq_id
{% endmacro %}

{% macro snowflake__sql_mysql_tls_v_1_2_set(framework, check_id) %}
WITH value_check AS (
    SELECT msql_fss._cq_id, msql_fsc.properties:infrastructureEncryption as value
    FROM azure_mysqlflexibleservers_servers msql_fss
        LEFT JOIN azure_mysqlflexibleservers_server_configurations msql_fsc ON
            msql_fss._cq_id = msql_fsc._cq_parent_id
        WHERE msql_fsc.name = 'tls_version'
)

SELECT
  s.id AS server_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure "TLS Version" is set to "TLSV1.2" for MySQL flexible Database Server (Automated)' as title,
  s.subscription_id,
  case
    when v.value IS NULL OR v.value != 'TLSv1.2'
      then 'fail' else 'pass'
  end
FROM azure_mysqlflexibleservers_servers s
    LEFT JOIN value_check v ON
        s._cq_id = v._cq_id
{% endmacro %}

{% macro bigquery__sql_mysql_tls_v_1_2_set(framework, check_id) %}
WITH value_check AS (
    SELECT msql_fss._cq_id, JSON_VALUE(msql_fsc.properties.infrastructureEncryption) as prop
    FROM {{ full_table_name("azure_mysqlflexibleservers_servers") }} msql_fss
        LEFT JOIN {{ full_table_name("azure_mysqlflexibleservers_server_configurations") }} msql_fsc ON
            msql_fss._cq_id = msql_fsc._cq_parent_id
        WHERE msql_fsc.name = 'tls_version'
)

SELECT
  s.id AS server_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure "TLS Version" is set to "TLSV1.2" for MySQL flexible Database Server (Automated)' as title,
  s.subscription_id,
  case
    when v.prop IS NULL OR v.prop != 'TLSv1.2'
      then 'fail' else 'pass'
  end
FROM {{ full_table_name("azure_mysqlflexibleservers_servers") }} s
    LEFT JOIN value_check v ON
        s._cq_id = v._cq_id
{% endmacro %}
