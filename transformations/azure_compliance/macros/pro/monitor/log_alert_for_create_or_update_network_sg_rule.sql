{% macro monitor_log_alert_for_create_or_update_network_sg_rule(framework, check_id) %}

WITH fields AS (
    SELECT
        _cq_sync_time,
        subscription_id,
        id,
        location,
        (properties->'enabled')::boolean AS enabled,
        conditions->>'field' AS field,
        conditions->>'equals' AS equals
    FROM azure_monitor_activity_log_alerts, jsonb_array_elements(properties->'condition'->'allOf') AS conditions
),
scopes AS (
    SELECT
        _cq_sync_time,
        subscription_id,
        id,
        scope
    FROM azure_monitor_activity_log_alerts, jsonb_array_elements_text(properties->'scopes') AS scope
),
conditions AS (
    SELECT
        fields._cq_sync_time,
        fields.subscription_id AS subscription_id,
        fields.id AS id,
        scopes.scope AS scope,
        location = 'global'
            AND enabled
            AND equals = 'Microsoft.Network/networkSecurityGroups/securityRules/write'
            AND scopes.scope ~ '^\/subscriptions\/[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}$'
        AS condition
    FROM fields JOIN scopes ON fields.id = scopes.id
    WHERE field = 'operationName'
)
SELECT
    _cq_sync_time As sync_time,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that Activity Log Alert exists for Create or Update Network Security Group Rule' AS title,
    subscription_id                                                                          AS subscription_id,
    scope                                                                                    AS resrouce_id,
    bool_or(condition)::text                                                                       AS status
FROM conditions
GROUP BY _cq_sync_time, subscription_id, scope
{% endmacro %}