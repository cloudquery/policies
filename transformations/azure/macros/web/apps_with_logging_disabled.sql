{% macro web_apps_with_logging_disabled(framework, check_id) %}

SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Resource logs in App Services should be enabled',
  subscription_id,
  case
    when NOT (properties -> 'siteConfig' -> 'httpLoggingEnabled')::text::bool
      OR NOT (properties -> 'siteConfig' -> 'detailedErrorLoggingEnabled')::text::bool
      OR NOT (properties -> 'siteConfig' -> 'requestTracingEnabled')::text::bool
    then 'fail' else 'pass'
  end
FROM azure_appservice_web_apps{% endmacro %}