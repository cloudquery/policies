{% macro sql_ad_admin_configured(framework, check_id) %}
WITH ad_admins_count AS ( SELECT ass._cq_id, count(*) AS admins_count
    FROM azure_sql_servers ass
        LEFT JOIN azure_sql_server_admins assa ON
            ass._cq_id = assa._cq_parent_id WHERE assa.properties->>'administratorType' = 'ActiveDirectory' GROUP BY ass._cq_id,
            assa.properties->>'administratorType'
)

SELECT
  s._cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that Azure Active Directory Admin is configured (Automated)' as title,
  s.subscription_id,
  s.id,
  case
    when a.admins_count IS NULL
      OR a.admins_count = 0
    then 'fail' else 'pass'
  end
FROM azure_sql_servers s
    LEFT JOIN ad_admins_count a ON
        s._cq_id = a._cq_id
{% endmacro %}