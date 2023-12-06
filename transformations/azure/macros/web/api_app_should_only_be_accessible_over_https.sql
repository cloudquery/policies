{% macro web_api_app_should_only_be_accessible_over_https(framework, check_id) %}

SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'API App should only be accessible over HTTPS',
  subscription_id,
  case
    when kind LIKE '%api' AND (properties ->> 'httpsOnly')::boolean IS NOT TRUE
      then 'fail' else 'pass'
  end
FROM azure_appservice_web_apps
{% endmacro %}