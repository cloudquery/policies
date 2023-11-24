{% macro web_app_ftp_deployment_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('web_app_ftp_deployment_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__web_app_ftp_deployment_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__web_app_ftp_deployment_enabled(framework, check_id) %}
SELECT
    aawac._cq_sync_time As sync_time,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure FTP deployments are disabled (Automated)' AS title,
    aawac.subscription_id                             AS subscription_id,
    aawac.id                                          AS resource_id,
    CASE
        WHEN aawac.properties->>'ftpsState' = 'AllAllowed'
        THEN 'fail'
        ELSE 'pass'
    END                                               AS status
FROM azure_appservice_web_apps as aawa
    JOIN azure_appservice_web_app_configurations aawac
        ON aawa._cq_id = aawac._cq_parent_id
{% endmacro %}

{% macro snowflake__web_app_ftp_deployment_enabled(framework, check_id) %}
SELECT
    aawac._cq_sync_time As sync_time,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure FTP deployments are disabled (Automated)' AS title,
    aawac.subscription_id                             AS subscription_id,
    aawac.id                                          AS resource_id,
    CASE
        WHEN aawac.properties:ftpsState = 'AllAllowed'
        THEN 'fail'
        ELSE 'pass'
    END                                               AS status
FROM azure_appservice_web_apps as aawa
    JOIN azure_appservice_web_app_configurations aawac
        ON aawa._cq_id = aawac._cq_parent_id
{% endmacro %}