{% macro app_using_latest_http_version(framework, check_id) %}
  {{ return(adapter.dispatch('app_using_latest_http_version')(framework, check_id)) }}
{% endmacro %}

{% macro default__app_using_latest_http_version(framework, check_id) %}{% endmacro %}

{% macro postgres__app_using_latest_http_version(framework, check_id) %}
SELECT
       id                                                                     AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that HTTP Version is the Latest, if Used to Run the Web App' AS title,
       subscription_id                                                        AS subscription_id,
       CASE
        WHEN not (properties -> 'SiteConfig' ->> 'http20Enabled')::boolean then 'fail'
        ELSE 'pass'
        END AS status
FROM azure_appservice_web_apps
{% endmacro %}

{% macro snowflake__app_using_latest_http_version(framework, check_id) %}
{% endmacro %}

{% macro bigquery__app_using_latest_http_version(framework, check_id) %}
{% endmacro %}