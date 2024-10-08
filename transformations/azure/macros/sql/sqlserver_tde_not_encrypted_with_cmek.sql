{% macro sql_sqlserver_tde_not_encrypted_with_cmek(framework, check_id) %}
  {{ return(adapter.dispatch('sql_sqlserver_tde_not_encrypted_with_cmek')(framework, check_id)) }}
{% endmacro %}

{% macro default__sql_sqlserver_tde_not_encrypted_with_cmek(framework, check_id) %}{% endmacro %}

{% macro postgres__sql_sqlserver_tde_not_encrypted_with_cmek(framework, check_id) %}
SELECT
  s.id AS server_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure SQL server"s TDE protector is encrypted with Customer-managed key (Automated)' as title,
  s.subscription_id,
  case
    when p.kind != 'azurekeyvault'
      OR p.properties->>'serverKeyType' IS DISTINCT FROM 'AzureKeyVault'
      OR p.properties->>'uri' IS NULL
    then 'fail' else 'pass'
  end
FROM azure_sql_servers s
         LEFT JOIN azure_sql_server_encryption_protectors p ON
    s._cq_id = p._cq_parent_id
{% endmacro %}

{% macro snowflake__sql_sqlserver_tde_not_encrypted_with_cmek(framework, check_id) %}
SELECT
  s.id AS server_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure SQL server"s TDE protector is encrypted with Customer-managed key (Automated)' as title,
  s.subscription_id,
  case
    when p.kind != 'azurekeyvault'
      OR p.properties:serverKeyType IS DISTINCT FROM 'AzureKeyVault'
      OR p.properties:uri IS NULL
    then 'fail' else 'pass'
  end
FROM azure_sql_servers s
         LEFT JOIN azure_sql_server_encryption_protectors p ON
    s._cq_id = p._cq_parent_id
{% endmacro %}

{% macro bigquery__sql_sqlserver_tde_not_encrypted_with_cmek(framework, check_id) %}
SELECT
  s.id AS server_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure SQL server"s TDE protector is encrypted with Customer-managed key (Automated)' as title,
  s.subscription_id,
  case
    when p.kind != 'azurekeyvault'
      OR JSON_VALUE(p.properties.serverKeyType) IS DISTINCT FROM 'AzureKeyVault'
      OR JSON_VALUE(p.properties.uri) IS NULL
    then 'fail' else 'pass'
  end
FROM {{ full_table_name("azure_sql_servers") }} s
         LEFT JOIN {{ full_table_name("azure_sql_server_encryption_protectors") }} p ON
    s._cq_id = p._cq_parent_id
{% endmacro %}