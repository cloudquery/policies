{% macro web_latest_tls_version_should_be_used_in_your_web_app(framework, check_id) %}

SELECT
  _cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Latest TLS version should be used in your Web App',
  subscription_id,
  id,
  case
    when kind LIKE 'app%'
      AND (properties -> 'siteConfig' -> 'minTlsVersion' IS NULL
      OR properties -> 'siteConfig' ->> 'minTlsVersion' is distinct from '1.2')
    then 'fail' else 'pass'
  end
FROM azure_appservice_web_apps
{% endmacro %}