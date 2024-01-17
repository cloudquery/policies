{% macro web_app_client_cert_disabled(framework, check_id) %}
  {{ return(adapter.dispatch('web_app_client_cert_disabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__web_app_client_cert_disabled(framework, check_id) %}{% endmacro %}

{% macro postgres__web_app_client_cert_disabled(framework, check_id) %}
SELECT
       id                                                                                                     AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure the web app has ''Client Certificates (Incoming client certificates)'' set to ''On'' (Automated)' AS title,
       subscription_id                                                                                        AS subscription_id,
       CASE
           WHEN kind LIKE 'app%' AND (properties ->> 'clientCertEnabled')::boolean is distinct from  TRUE
               THEN 'fail'
           ELSE 'pass'
           END                                                                                                    AS status
FROM azure_appservice_web_apps
{% endmacro %}

{% macro snowflake__web_app_client_cert_disabled(framework, check_id) %}
SELECT
       id                                                                                                     AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure the web app has ''Client Certificates (Incoming client certificates)'' set to ''On'' (Automated)' AS title,
       subscription_id                                                                                        AS subscription_id,
       CASE
           WHEN kind LIKE 'app%' AND (properties:clientCertEnabled)::boolean is distinct from  TRUE
               THEN 'fail'
           ELSE 'pass'
           END                                                                                                    AS status
FROM azure_appservice_web_apps
{% endmacro %}

{% macro bigquery__web_app_client_cert_disabled(framework, check_id) %}
SELECT
       id                                                                                                     AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure the web app has "Client Certificates (Incoming client certificates)" set to "On" (Automated)' AS title,
       subscription_id                                                                                        AS subscription_id,
       CASE
           WHEN kind LIKE 'app%' AND CAST( JSON_VALUE(properties.clientCertEnabled) AS BOOL) is distinct from  TRUE
               THEN 'fail'
           ELSE 'pass'
           END                                                                                                    AS status
FROM {{ full_table_name("azure_appservice_web_apps") }}
{% endmacro %}