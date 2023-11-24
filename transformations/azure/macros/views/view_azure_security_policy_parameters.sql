{% macro view_azure_security_policy_parameters() %}
  {{ return(adapter.dispatch('view_azure_security_policy_parameters')()) }}
{% endmacro %}

{% macro default__view_azure_security_policy_parameters() %}{% endmacro %}

{% macro postgres__view_azure_security_policy_parameters() %}
SELECT
    _cq_sync_time,
    id,
    azure_policy_assignments.subscription_id,
    azure_policy_assignments."name",
    parameters.*,
    azure_policy_assignments.properties -> 'parameters' -> parameters.param ->> 'value' AS value
FROM
    azure_policy_assignments,
    jsonb_object_keys(azure_policy_assignments.properties -> 'parameters') AS parameters ("param")
WHERE azure_policy_assignments."name" = 'SecurityCenterBuiltIn'
{% endmacro %}

{% macro snowflake__view_azure_security_policy_parameters() %}
SELECT
    _cq_sync_time,
    id,
    azure_policy_assignments.subscription_id,
    azure_policy_assignments.name,
    parameters.key AS param,
    parameters.value AS value
FROM
    azure_policy_assignments,
    LATERAL FLATTEN(input => azure_policy_assignments.properties:parameters) AS parameters
WHERE azure_policy_assignments.name = 'SecurityCenterBuiltIn'
{% endmacro %}