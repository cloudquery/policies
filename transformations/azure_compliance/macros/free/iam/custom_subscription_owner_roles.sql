{% macro iam_custom_subscription_owner_roles(framework, check_id) %}
  {{ return(adapter.dispatch('iam_custom_subscription_owner_roles')(framework, check_id)) }}
{% endmacro %}

{% macro default__iam_custom_subscription_owner_roles(framework, check_id) %}{% endmacro %}

{% macro postgres__iam_custom_subscription_owner_roles(framework, check_id) %}
WITH custom_roles AS (
    SELECT *
    FROM azure_authorization_role_definitions
    WHERE properties->>'type' = 'CustomRole'
),
assignable_scopes AS (
    SELECT
        _cq_id,
        scope AS assignable_scope
    FROM custom_roles,
         jsonb_array_elements_text(properties->'assignableScopes') scope
),
meets_scopes AS (
    SELECT
        _cq_id,
        bool_or(assignable_scope = '/' OR assignable_scope ~ '^\/subscriptions\/[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}$') AS has_wide_scope
    FROM assignable_scopes
    GROUP BY _cq_id
),
--check if definition matches actions
definition_actions AS (
    SELECT
        _cq_id,
        actions AS action
    FROM custom_roles,
         jsonb_array_elements(properties->'permissions') p,
         jsonb_array_elements_text(p->'actions') actions
),
meets_actions AS (
    SELECT
        _cq_id,
        bool_or("action" = '*') AS has_all_action
    FROM definition_actions
    GROUP BY _cq_id
)
SELECT
    _cq_sync_time As sync_time,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure That No Custom Subscription Administrator Roles Exist' AS title,
    subscription_id                                                AS subscription_id,
    id                                                             AS resource_id,
    CASE
        WHEN has_wide_scope AND has_all_action
        THEN 'fail'
        ELSE 'pass'
    END                                                            AS status
FROM custom_roles 
    JOIN meets_scopes USING (_cq_id) JOIN meets_actions USING (_cq_id)
{% endmacro %}

{% macro snowflake__iam_custom_subscription_owner_roles(framework, check_id) %}
--check if definition matches scopes
WITH custom_roles AS (
    SELECT *
    FROM azure_authorization_role_definitions
    WHERE properties:type = 'CustomRole'
),
assignable_scopes AS (
    SELECT
        _cq_id,
        value AS assignable_scope
    FROM custom_roles,
   LATERAL FLATTEN(input => properties:assignableScopes) AS scope
),
meets_scopes AS (
    SELECT
        _cq_id,
        CASE WHEN MAX(CASE WHEN assignable_scope = '/' OR assignable_scope REGEXP '^\/subscriptions\/[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}$' THEN 1 ELSE 0 END) = 1 THEN 'pass' ELSE 'fail' END AS has_wide_scope
    FROM assignable_scopes
    GROUP BY _cq_id
),
--check if definition matches actions
definition_actions AS (
    SELECT
        _cq_id,
        actions.value AS action
    FROM custom_roles,
    LATERAL FLATTEN(input => properties:permissions) AS p,
    LATERAL FLATTEN(input => p.value:actions) AS actions
),
meets_actions AS (
    SELECT
        _cq_id,
        CASE WHEN MAX(CASE WHEN action = '*' THEN 1 ELSE 0 END) = 1 THEN 'pass' ELSE 'fail' END AS has_all_action
    FROM definition_actions
    GROUP BY _cq_id
)
SELECT
    _cq_sync_time As sync_time,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure That No Custom Subscription Administrator Roles Exist' AS title,
    subscription_id                                                AS subscription_id,
    id                                                             AS resource_id,
    CASE
        WHEN has_wide_scope AND has_all_action
        THEN 'fail'
        ELSE 'pass'
    END                                                            AS status
FROM custom_roles 
    JOIN meets_scopes USING (_cq_id) JOIN meets_actions USING (_cq_id)
{% endmacro %}