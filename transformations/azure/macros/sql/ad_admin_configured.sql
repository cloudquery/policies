{% macro sql_ad_admin_configured(framework, check_id) %}
  {{ return(adapter.dispatch('sql_ad_admin_configured')(framework, check_id)) }}
{% endmacro %}

{% macro default__sql_ad_admin_configured(framework, check_id) %}{% endmacro %}

{% macro postgres__sql_ad_admin_configured(framework, check_id) %}
WITH ad_admins_count AS ( SELECT ass._cq_id, count(*) AS admins_count
    FROM azure_sql_servers ass
        LEFT JOIN azure_sql_server_admins assa ON
            ass._cq_id = assa._cq_parent_id WHERE assa.properties->>'administratorType' = 'ActiveDirectory' GROUP BY ass._cq_id,
            assa.properties->>'administratorType'
)

SELECT
  s.id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that Azure Active Directory Admin is configured (Automated)' as title,
  s.subscription_id,
  case
    when a.admins_count IS NULL
      OR a.admins_count = 0
    then 'fail' else 'pass'
  end
FROM azure_sql_servers s
    LEFT JOIN ad_admins_count a ON
        s._cq_id = a._cq_id
{% endmacro %}

{% macro snowflake__sql_ad_admin_configured(framework, check_id) %}
WITH ad_admins_count AS ( SELECT ass._cq_id, count(*) AS admins_count
    FROM azure_sql_servers ass
        LEFT JOIN azure_sql_server_admins assa ON
            ass._cq_id = assa._cq_parent_id WHERE assa.properties:administratorType = 'ActiveDirectory' GROUP BY ass._cq_id,
            assa.properties:administratorType
)

SELECT
  s.id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that Azure Active Directory Admin is configured (Automated)' as title,
  s.subscription_id,
  case
    when a.admins_count IS NULL
      OR a.admins_count = 0
    then 'fail' else 'pass'
  end
FROM azure_sql_servers s
    LEFT JOIN ad_admins_count a ON
        s._cq_id = a._cq_id
{% endmacro %}

{% macro bigquery__sql_ad_admin_configured(framework, check_id) %}
WITH ad_admins_count AS ( SELECT ass._cq_id, count(*) AS admins_count
    FROM {{ full_table_name("azure_sql_servers") }} ass
        LEFT JOIN {{ full_table_name("azure_sql_server_admins") }} assa ON
            ass._cq_id = assa._cq_parent_id WHERE JSON_VALUE(assa.properties.administratorType) = 'ActiveDirectory' GROUP BY ass._cq_id,
            JSON_VALUE(assa.properties.administratorType)
)

SELECT
  s.id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that Azure Active Directory Admin is configured (Automated)' as title,
  s.subscription_id,
  case
    when a.admins_count IS NULL
      OR a.admins_count = 0
    then 'fail' else 'pass'
  end
FROM {{ full_table_name("azure_sql_servers") }} s
    LEFT JOIN ad_admins_count a ON
        s._cq_id = a._cq_id
{% endmacro %}