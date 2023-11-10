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