{% macro monitor_log_alert_for_delete_policy_assignment(framework, check_id) %}
  {{ return(adapter.dispatch('monitor_log_alert_for_delete_policy_assignment')(framework, check_id)) }}
{% endmacro %}

{% macro default__monitor_log_alert_for_delete_policy_assignment(framework, check_id) %}{% endmacro %}

{% macro postgres__monitor_log_alert_for_delete_policy_assignment(framework, check_id) %}
WITH fields AS (
    SELECT
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
        subscription_id,
        id,
        scope
    FROM azure_monitor_activity_log_alerts, jsonb_array_elements_text(properties->'scopes') AS scope
),
conditions AS (
    SELECT
        fields.subscription_id AS subscription_id,
        fields.id AS id,
        scopes.scope AS scope,
        location = 'global'
            AND enabled
            AND equals = 'Microsoft.Security/policies/delete'
            AND scopes.scope ~ '^\/subscriptions\/[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}$'
        AS condition
    FROM fields JOIN scopes ON fields.id = scopes.id
    WHERE field = 'operationName'
)
SELECT
    scope                                                                AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that Activity Log Alert exists for Delete Policy Assignment' AS title,
    subscription_id                                                      AS subscription_id,
    bool_or(condition)::text                                                   AS status
FROM conditions
GROUP BY subscription_id, scope
{% endmacro %}

{% macro snowflake__monitor_log_alert_for_delete_policy_assignment(framework, check_id) %}
WITH fields AS (
    SELECT
        subscription_id,
        id,
        location,
        (properties:enabled)::boolean AS enabled,
        conditions.value:field AS field,
        conditions.value:equals AS equals
    FROM azure_monitor_activity_log_alerts,
     LATERAL FLATTEN(input => properties:condition:allOf) AS conditions
),
scopes AS (
    SELECT
        subscription_id,
        id,
        value as scope
    FROM azure_monitor_activity_log_alerts,
  LATERAL FLATTEN(input => properties:scopes) AS scope
),
conditions AS (
    SELECT
        fields.subscription_id AS subscription_id,
        fields.id AS id,
        scopes.scope AS scope,
        location = 'global'
            AND enabled
            AND equals = 'Microsoft.Security/policies/delete'
            AND scopes.scope REGEXP '^\/subscriptions\/[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}$'
        AS condition
    FROM fields JOIN scopes ON fields.id = scopes.id
    WHERE field = 'operationName'
)
SELECT
    scope                                                                AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that Activity Log Alert exists for Delete Policy Assignment' AS title,
    subscription_id                                                      AS subscription_id,
    CASE WHEN BOOLOR_AGG(condition) THEN 'pass' ELSE 'fail' END AS status
FROM conditions
GROUP BY subscription_id, scope
{% endmacro %}

{% macro bigquery__monitor_log_alert_for_delete_policy_assignment(framework, check_id) %}
WITH fields AS (
    SELECT
        subscription_id,
        id,
        location,
        CAST( JSON_VALUE(properties.enabled) AS BOOL) AS enabled,
        JSON_VALUE(conditions.field) AS field,
        JSON_VALUE(conditions.equals) AS equals
    FROM {{ full_table_name("azure_monitor_activity_log_alerts") }},
    UNNEST(JSON_QUERY_ARRAY(properties.condition.allOf)) AS conditions
),
scopes AS (
    SELECT
        subscription_id,
        id,
        scope
    FROM {{ full_table_name("azure_monitor_activity_log_alerts") }},
    UNNEST(JSON_QUERY_ARRAY(properties.scopes)) AS scope
),
conditions AS (
    SELECT
        fields.subscription_id AS subscription_id,
        fields.id AS id,
        JSON_VALUE(scopes.scope) AS scope,
        location = 'global'
            AND enabled
            AND equals = 'Microsoft.Security/policies/delete'
           AND REGEXP_CONTAINS(JSON_VALUE(scopes.scope), r'^\/subscriptions\/[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}$')
        AS condition
    FROM fields JOIN scopes ON fields.id = scopes.id
    WHERE field = 'operationName'
)
SELECT
    scope                                                                AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that Activity Log Alert exists for Delete Policy Assignment' AS title,
    subscription_id                                                      AS subscription_id,
    CASE WHEN CAST( (LOGICAL_OR(condition)) AS BOOL) THEN 'pass' ELSE 'fail' END AS status
FROM conditions
GROUP BY subscription_id, scope
{% endmacro %}