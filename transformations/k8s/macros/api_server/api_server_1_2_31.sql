{% macro api_server_1_2_31(framework, check_id) %}
  {{ return(adapter.dispatch('api_server_1_2_31')(framework, check_id)) }}
{% endmacro %}

{% macro default__api_server_1_2_31(framework, check_id) %}{% endmacro %}

{% macro postgres__api_server_1_2_31(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
        'Ensure that the API Server only makes use of Strong Cryptographic Ciphers' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case
      when 
        container ->> 'command' ~
        '.*TLS_AES_128_GCM_SHA256.*'
        '.*TLS_AES_256_GCM_SHA384.*'
        '.*TLS_CHACHA20_POLY1305_SHA256.*'
        '.*TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA.*'
        '.*TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256.*'
        '.*TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA.*'
        '.*TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384.*'
        '.*TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305.*'
        '.*TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256.*'
        '.*TLS_ECDHE_RSA_WITH_3DES_EDE_CBC_SHA.*'
        '.*TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA.*'
        '.*TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256.*'
        '.*TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA.*'
        '.*TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384.*'
        '.*TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305.*'
        '.*TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256.*'
        '.*TLS_RSA_WITH_3DES_EDE_CBC_SHA.*'
        '.*TLS_RSA_WITH_AES_128_CBC_SHA.*'
        '.*TLS_RSA_WITH_AES_128_GCM_SHA256.*'
        '.*TLS_RSA_WITH_AES_256_CBC_SHA.*'
        '.*TLS_RSA_WITH_AES_256_GCM_SHA384.*'
        '.*'
      then 'pass'
      else 'fail'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver'
{% endmacro %}

{% macro snowflake__api_server_1_2_31(framework, check_id) %}
SELECT 
    uid AS resource_id,
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'Ensure that the API Server only makes use of Strong Cryptographic Ciphers' AS title,
    context,
    namespace,
    name AS resource_name,
    CASE
        WHEN 
            container.value:command REGEXP '.*TLS_AES_128_GCM_SHA256.*' OR
            container.value:command REGEXP '.*TLS_AES_256_GCM_SHA384.*' OR
            container.value:command REGEXP '.*TLS_CHACHA20_POLY1305_SHA256.*' OR
            container.value:command REGEXP '.*TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA.*' OR
            container.value:command REGEXP '.*TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256.*' OR
            container.value:command REGEXP '.*TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA.*' OR
            container.value:command REGEXP '.*TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384.*' OR
            container.value:command REGEXP '.*TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305.*' OR
            container.value:command REGEXP '.*TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256.*' OR
            container.value:command REGEXP '.*TLS_ECDHE_RSA_WITH_3DES_EDE_CBC_SHA.*' OR
            container.value:command REGEXP '.*TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA.*' OR
            container.value:command REGEXP '.*TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256.*' OR
            container.value:command REGEXP '.*TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA.*' OR
            container.value:command REGEXP '.*TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384.*' OR
            container.value:command REGEXP '.*TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305.*' OR
            container.value:command REGEXP '.*TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256.*' OR
            container.value:command REGEXP '.*TLS_RSA_WITH_3DES_EDE_CBC_SHA.*' OR
            container.value:command REGEXP '.*TLS_RSA_WITH_AES_128_CBC_SHA.*' OR
            container.value:command REGEXP '.*TLS_RSA_WITH_AES_128_GCM_SHA256.*' OR
            container.value:command REGEXP '.*TLS_RSA_WITH_AES_256_CBC_SHA.*' OR
            container.value:command REGEXP '.*TLS_RSA_WITH_AES_256_GCM_SHA384.*'
        THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    k8s_core_pods,
    LATERAL FLATTEN(spec_containers) container
WHERE 
    namespace = 'kube-system' AND container.value:name = 'kube-apiserver'
{% endmacro %}

{% macro bigquery__api_server_1_2_31(framework, check_id) %}

{% endmacro %}