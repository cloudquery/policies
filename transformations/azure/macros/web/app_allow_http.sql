{% macro web_app_allow_http(framework, check_id) %}
  {{ return(adapter.dispatch('web_app_allow_http')(framework, check_id)) }}
{% endmacro %}

{% macro default__web_app_allow_http(framework, check_id) %}{% endmacro %}

{% macro postgres__web_app_allow_http(framework, check_id) %}
SELECT
       id                                                                                AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure web app redirects all HTTP traffic to HTTPS in Azure App Service (Automated)' AS title,
       subscription_id                                                                   AS subscription_id,
       CASE
           WHEN (properties ->> 'httpsOnly')::boolean IS  distinct from TRUE
               THEN 'fail'
           ELSE 'pass'
           END                                                                               AS status
FROM azure_appservice_web_apps
{% endmacro %}

{% macro snowflake__web_app_allow_http(framework, check_id) %}
SELECT
       id                                                                                AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure web app redirects all HTTP traffic to HTTPS in Azure App Service (Automated)' AS title,
       subscription_id                                                                   AS subscription_id,
       CASE
           WHEN (properties:httpsOnly)::boolean IS  distinct from TRUE
               THEN 'fail'
           ELSE 'pass'
           END                                                                               AS status
FROM azure_appservice_web_apps
{% endmacro %}

{% macro bigquery__web_app_allow_http(framework, check_id) %}
SELECT
       id                                                                                AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure web app redirects all HTTP traffic to HTTPS in Azure App Service (Automated)' AS title,
       subscription_id                                                                   AS subscription_id,
       CASE
           WHEN CAST( JSON_VALUE(properties.httpsOnly) AS BOOL) IS distinct from TRUE
               THEN 'fail'
           ELSE 'pass'
           END                                                                               AS status
FROM {{ full_table_name("azure_appservice_web_apps") }}
{% endmacro %}