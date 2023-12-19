{% macro web_app_register_with_ad_disabled(framework, check_id) %}
  {{ return(adapter.dispatch('web_app_register_with_ad_disabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__web_app_register_with_ad_disabled(framework, check_id) %}{% endmacro %}

{% macro postgres__web_app_register_with_ad_disabled(framework, check_id) %}
SELECT
       id                                                                                   AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that Register with Azure Active Directory is enabled on App Service (Automated)' AS title,
       subscription_id                                                                      AS subscription_id,
       CASE
           WHEN identity->>'principalId' IS NULL OR identity->>'principalId' = ''
               THEN 'fail'
           ELSE 'pass'
           END                                                                                  AS status
FROM azure_appservice_web_apps
{% endmacro %}

{% macro snowflake__web_app_register_with_ad_disabled(framework, check_id) %}
SELECT
       id                                                                                   AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that Register with Azure Active Directory is enabled on App Service (Automated)' AS title,
       subscription_id                                                                      AS subscription_id,
       CASE
           WHEN identity:principalId IS NULL OR identity:principalId = ''
               THEN 'fail'
           ELSE 'pass'
           END                                                                                  AS status
FROM azure_appservice_web_apps
{% endmacro %}