{% macro iam_global_administrator_max_5(framework, check_id) %}
  {{ return(adapter.dispatch('iam_global_administrator_max_5')(framework, check_id)) }}
{% endmacro %}

{% macro default__iam_global_administrator_max_5(framework, check_id) %}{% endmacro %}

{% macro postgres__iam_global_administrator_max_5(framework, check_id) %}
WITH global_admin_count AS (
    SELECT
        count(distinct drm.id) AS num_global_admins
    FROM
        azure_ad_directory_roles as dr
    inner join azure_ad_directory_role_members as drm
    on dr._cq_id = drm._cq_parent_id
    WHERE
        dr.display_name = 'Global Administrator'
)
SELECT
    dr.id AS server_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure fewer than 5 users have global administrator assignment' as title,
    dr.id,
    CASE
        WHEN num_global_admins < 2 THEN 'fail'
        WHEN num_global_admins > 4 THEN 'fail'
        ELSE 'pass'
    END AS status
FROM
    global_admin_count,
    azure_ad_directory_roles as dr
WHERE dr.display_name = 'Global Administrator'

{% endmacro %}

{% macro snowflake__iam_global_administrator_max_5(framework, check_id) %}
abc
{% endmacro %}

{% macro bigquery__iam_global_administrator_max_5(framework, check_id) %}
abc
{% endmacro %}