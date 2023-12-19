{% macro web_remote_debugging_should_be_turned_off_for_function_apps(framework, check_id) %}

SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Remote debugging should be turned off for Function Apps',
  subscription_id,
  case
    when kind LIKE 'functionapp%'
      AND properties -> 'siteConfig' ->> 'remoteDebuggingEnabled' = 'true'
    then 'fail' else 'pass'
  end
FROM azure_appservice_web_apps
{% endmacro %}