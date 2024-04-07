{% macro app_using_latest_java_version(framework, check_id) %}
  {{ return(adapter.dispatch('app_using_latest_java_version')(framework, check_id)) }}
{% endmacro %}

{% macro default__app_using_latest_java_version(framework, check_id) %}{% endmacro %}

{% macro postgres__app_using_latest_java_version(framework, check_id) %}
SELECT
       id                                                                     AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that Java version is the latest, if used to run the Web App' AS title,
       subscription_id                                                        AS subscription_id,
       CASE
        WHEN properties -> 'SiteConfig' ->> 'linuxFxVersion' not like 'JAVA%' then 'pass'
        WHEN properties -> 'SiteConfig' ->> 'linuxFxVersion' = '%11' then 'pass'
        ELSE 'fail'
        END AS status
FROM azure_appservice_web_apps
{% endmacro %}

{% macro snowflake__app_using_latest_java_version(framework, check_id) %}
SELECT
       id                                                                     AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that Java version is the latest, if used to run the Web App' AS title,
       subscription_id                                                        AS subscription_id,
       CASE
        WHEN properties:SiteConfig:linuxFxVersion not like 'JAVA%' then 'pass'
        WHEN properties:SiteConfig:linuxFxVersion = '%11' then 'pass'
        ELSE 'fail'
        END AS status
FROM azure_appservice_web_apps
{% endmacro %}

{% macro bigquery__app_using_latest_java_version(framework, check_id) %}
{% endmacro %}