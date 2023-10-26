{% macro web_remote_debugging_should_be_turned_off_for_api_apps(framework, check_id) %}

SELECT
  _cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Remote debugging should be turned off for API Apps',
  subscription_id,
  id,
  case
    when kind LIKE '%api'
      AND properties -> 'siteConfig' ->> 'remoteDebuggingEnabled' = 'true'
    then 'fail' else 'pass'
  end
FROM azure_appservice_web_apps
{% endmacro %}