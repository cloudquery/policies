{% macro web_latest_tls_version_should_be_used_in_your_api_app(framework, check_id) %}

SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Latest TLS version should be used in your API App',
  subscription_id,
  'fail' as status
FROM azure_appservice_web_apps
WHERE
  kind LIKE '%api'
  AND (properties -> 'siteConfig' -> 'minTlsVersion' IS NULL
       OR properties -> 'siteConfig' ->> 'minTlsVersion' is distinct from '1.2')
{% endmacro %}