{% macro web_cors_should_not_allow_every_resource_to_access_your_web_applications(framework, check_id) %}

SELECT
  _cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'CORS should not allow every resource to access your Web Applications',
  subscription_id,
  id,
  case
    when array(select jsonb_array_elements_text(properties -> 'siteConfig' -> 'cors' -> 'allowedOrigins')) && ARRAY['*']
      AND kind LIKE 'app%'
    then 'fail' else 'pass'
  end
FROM azure_appservice_web_apps
{% endmacro %}