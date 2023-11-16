{% macro compute_ssl_proxy_with_weak_cipher(framework, check_id) %}
  {{ return(adapter.dispatch('compute_ssl_proxy_with_weak_cipher')(framework, check_id)) }}
{% endmacro %}

{% macro default__compute_ssl_proxy_with_weak_cipher(framework, check_id) %}{% endmacro %}

{% macro postgres__compute_ssl_proxy_with_weak_cipher(framework, check_id) %}
select DISTINCT
                gctsp.id::text                                                                   AS resource_id,
                gctsp._cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure no HTTPS or SSL proxy load balancers permit SSL policies with weak cipher suites (Manual)' AS title,
                gctsp.project_id                                                                AS project_id,
                CASE
                WHEN
                        gctsp.ssl_policy NOT LIKE
                        'https://www.googleapis.com/compute/v1/projects/%/global/sslPolicies/%'
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_compute_target_ssl_proxies gctsp
    UNION ALL
    select DISTINCT
                gctsp.id::text                                                                 AS resource_id,
                gctsp._cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure no HTTPS or SSL proxy load balancers permit SSL policies with weak cipher suites (Manual)' AS title,
                gctsp.project_id                                                                AS project_id,
                CASE
                    WHEN
                                gctsp.ssl_policy LIKE
                                'https://www.googleapis.com/compute/v1/projects/%/global/sslPolicies/%'
                            AND (p.min_tls_version != 'TLS_1_2' OR p.min_tls_version != 'TLS_1_3')
                            AND (
                                        (p.profile = 'MODERN' OR p.profile = 'RESTRICTED')
                                        OR (
                                                    p.profile = 'CUSTOM' AND ARRAY [
                                                                                 'TLS_RSA_WITH_AES_128_GCM_SHA256',
                                                                                 'TLS_RSA_WITH_AES_256_GCM_SHA384',
                                                                                 'TLS_RSA_WITH_AES_128_CBC_SHA',
                                                                                 'TLS_RSA_WITH_AES_256_CBC_SHA',
                                                                                 'TLS_RSA_WITH_3DES_EDE_CBC_SHA'
                                                                                 ] @> p.enabled_features
                                            )
                                    )
                        THEN 'fail'
                    ELSE 'pass'
                    END                                                                                            AS status
    FROM gcp_compute_target_ssl_proxies gctsp
        JOIN gcp_compute_ssl_policies p ON
        gctsp.ssl_policy = p.self_link
{% endmacro %}

{% macro snowflake__compute_ssl_proxy_with_weak_cipher(framework, check_id) %}
select DISTINCT
                gctsp.id::text                                                                   AS resource_id,
                gctsp._cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure no HTTPS or SSL proxy load balancers permit SSL policies with weak cipher suites (Manual)' AS title,
                gctsp.project_id                                                                AS project_id,
                CASE
                WHEN
                        gctsp.ssl_policy NOT LIKE
                        'https://www.googleapis.com/compute/v1/projects/%/global/sslPolicies/%'
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_compute_target_ssl_proxies gctsp
    UNION ALL
    select DISTINCT
                gctsp.id::text                                                                 AS resource_id,
                gctsp._cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure no HTTPS or SSL proxy load balancers permit SSL policies with weak cipher suites (Manual)' AS title,
                gctsp.project_id                                                                AS project_id,
                CASE
                    WHEN
                                gctsp.ssl_policy LIKE
                                'https://www.googleapis.com/compute/v1/projects/%/global/sslPolicies/%'
                            AND (p.min_tls_version != 'TLS_1_2' OR p.min_tls_version != 'TLS_1_3')
                            AND (
                                        (p.profile = 'MODERN' OR p.profile = 'RESTRICTED')
                                        OR (
                                                    p.profile = 'CUSTOM' AND ARRAY_CONTAINS(p.enabled_features::variant, array_construct('TLS_RSA_WITH_AES_128_GCM_SHA256',
                                                                                 'TLS_RSA_WITH_AES_256_GCM_SHA384',
                                                                                 'TLS_RSA_WITH_AES_128_CBC_SHA',
                                                                                 'TLS_RSA_WITH_AES_256_CBC_SHA',
                                                                                 'TLS_RSA_WITH_3DES_EDE_CBC_SHA'))
                                    )
                              )
                        THEN 'fail'
                    ELSE 'pass'
                    END                                                                                            AS status
    FROM gcp_compute_target_ssl_proxies gctsp
        JOIN gcp_compute_ssl_policies p ON
        gctsp.ssl_policy = p.self_link
{% endmacro %}