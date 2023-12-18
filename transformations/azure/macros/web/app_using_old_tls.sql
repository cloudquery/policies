{% macro web_app_using_old_tls(framework, check_id) %}
  {{ return(adapter.dispatch('web_app_using_old_tls')(framework, check_id)) }}
{% endmacro %}

{% macro default__web_app_using_old_tls(framework, check_id) %}{% endmacro %}

{% macro postgres__web_app_using_old_tls(framework, check_id) %}
SELECT
       id                                                                     AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure web app is using the latest version of TLS encryption (Automated)' AS title,
       subscription_id                                                        AS subscription_id,
       CASE
           WHEN properties -> 'siteConfig' -> 'minTlsVersion' IS NULL OR properties -> 'siteConfig' ->> 'minTlsVersion' is distinct from '1.2'
               THEN 'fail'
           ELSE 'pass'
           END                                                                    AS status
FROM azure_appservice_web_apps
{% endmacro %}

{% macro snowflake__web_app_using_old_tls(framework, check_id) %}
SELECT
       id                                                                     AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure web app is using the latest version of TLS encryption (Automated)' AS title,
       subscription_id                                                        AS subscription_id,
       CASE
           WHEN properties:siteConfig:minTlsVersion IS NULL OR properties:siteConfig:minTlsVersion is distinct from '1.2'
               THEN 'fail'
           ELSE 'pass'
           END                                                                    AS status
FROM azure_appservice_web_apps
{% endmacro %}

{% macro bigquery__web_app_using_old_tls(framework, check_id) %}
SELECT
       id                                                                     AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure web app is using the latest version of TLS encryption (Automated)' AS title,
       subscription_id                                                        AS subscription_id,
       CASE
           WHEN JSON_VALUE(properties.siteConfig.minTlsVersion) IS NULL OR JSON_VALUE(properties.siteConfig.minTlsVersion) is distinct from '1.2'
               THEN 'fail'
           ELSE 'pass'
           END                                                                    AS status
FROM {{ full_table_name("azure_appservice_web_apps") }}
{% endmacro %}