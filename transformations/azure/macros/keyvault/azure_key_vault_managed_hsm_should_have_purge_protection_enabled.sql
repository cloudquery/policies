{% macro keyvault_azure_key_vault_managed_hsm_should_have_purge_protection_enabled(framework, check_id) %}

SELECT
        id                                                                                    AS resource_id,
        '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Azure Key Vault Managed HSM should have purge protection enabled' AS title,
       subscription_id                                                                       AS subscription_id,
       CASE
           WHEN (properties ->> 'enablePurgeProtection')::boolean IS NOT TRUE
               OR (properties ->> 'enableSoftDelete')::boolean IS NOT TRUE THEN 'fail'
           ELSE 'pass'
      END                                                                               AS status
FROM azure_keyvault_keyvault_managed_hsms
{% endmacro %}