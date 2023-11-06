{% macro web_app_using_old_tls(framework, check_id) %}

SELECT _cq_sync_time As sync_time,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure web app is using the latest version of TLS encryption (Automated)' AS title,
       subscription_id                                                        AS subscription_id,
       id                                                                     AS resource_id,
       CASE
           WHEN properties -> 'siteConfig' -> 'minTlsVersion' IS NULL OR properties -> 'siteConfig' ->> 'minTlsVersion' is distinct from '1.2'
               THEN 'fail'
           ELSE 'pass'
           END                                                                    AS status
FROM azure_appservice_web_apps
{% endmacro %}