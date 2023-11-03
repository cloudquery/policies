{% macro web_app_client_cert_disabled(framework, check_id) %}

SELECT _cq_sync_time As sync_time,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure the web app has ''Client Certificates (Incoming client certificates)'' set to ''On'' (Automated)' AS title,
       subscription_id                                                                                        AS subscription_id,
       id                                                                                                     AS resource_id,
       CASE
           WHEN kind LIKE 'app%' AND (properties ->> 'clientCertEnabled')::boolean is distinct from  TRUE
               THEN 'fail'
           ELSE 'pass'
           END                                                                                                    AS status
FROM azure_appservice_web_apps
{% endmacro %}