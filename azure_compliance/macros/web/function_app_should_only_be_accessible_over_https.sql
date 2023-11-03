{% macro web_function_app_should_only_be_accessible_over_https(framework, check_id) %}

SELECT
  _cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Function App should only be accessible over HTTPS',
  subscription_id,
  id,
  case
    when kind LIKE 'functionapp%' AND (properties ->> 'httpsOnly')::boolean IS NOT TRUE
    then 'fail' else 'pass'
  end
FROM azure_appservice_web_apps
{% endmacro %}