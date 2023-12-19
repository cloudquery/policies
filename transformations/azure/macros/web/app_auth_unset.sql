{% macro web_app_auth_unset(framework, check_id) %}
  {{ return(adapter.dispatch('web_app_auth_unset')(framework, check_id)) }}
{% endmacro %}

{% macro default__web_app_auth_unset(framework, check_id) %}{% endmacro %}

{% macro postgres__web_app_auth_unset(framework, check_id) %}
SELECT
        awa.id                                                                      AS resource_id,
        '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure App Service Authentication is set on Azure App Service (Automated)' AS title,
       awa.subscription_id                                                         AS subscription_id,
       CASE
           WHEN (awaas.properties ->> 'enabled')::boolean is distinct from TRUE
               THEN 'fail'
           ELSE 'pass'
           END                                                                     AS status
FROM azure_appservice_web_apps awa
         LEFT JOIN azure_appservice_web_app_auth_settings awaas ON
    awa._cq_id = awaas._cq_parent_id
{% endmacro %}

{% macro snowflake__web_app_auth_unset(framework, check_id) %}
SELECT
       awa.id                                                                      AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure App Service Authentication is set on Azure App Service (Automated)' AS title,
       awa.subscription_id                                                         AS subscription_id,
       CASE
           WHEN (awaas.properties:enabled)::boolean is distinct from TRUE
               THEN 'fail'
           ELSE 'pass'
           END                                                                     AS status
FROM azure_appservice_web_apps awa
         LEFT JOIN azure_appservice_web_app_auth_settings awaas ON
    awa._cq_id = awaas._cq_parent_id
{% endmacro %}