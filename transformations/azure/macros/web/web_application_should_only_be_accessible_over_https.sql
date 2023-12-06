{% macro web_web_application_should_only_be_accessible_over_https(framework, check_id) %}

SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Web Application should only be accessible over HTTPS',
  subscription_id,
  case
    when kind LIKE 'app%' AND (properties ->> 'httpsOnly')::boolean IS NOT TRUE
    then 'fail' else 'pass'
  end
FROM azure_appservice_web_apps
{% endmacro %}