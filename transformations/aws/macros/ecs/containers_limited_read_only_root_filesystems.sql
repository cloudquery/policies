{% macro containers_limited_read_only_root_filesystems(framework, check_id) %}
  {{ return(adapter.dispatch('containers_limited_read_only_root_filesystems')(framework, check_id)) }}
{% endmacro %}

{% macro default__containers_limited_read_only_root_filesystems(framework, check_id) %}{% endmacro %}

{% macro postgres__containers_limited_read_only_root_filesystems(framework, check_id) %}
with latest_revisions as (
    SELECT
        regexp_replace(arn, ':[^:]+$', '') AS versionless_arn,
        account_id,
        task_role_arn,
        max(revision) AS latest_revision
    FROM
        aws_ecs_task_definitions
    WHERE
        status = 'ACTIVE'
    GROUP BY
        regexp_replace(arn, ':[^:]+$', ''),
        account_id,
        task_role_arn
),
flat_containers as (
    SELECT
        t.arn,
        t.account_id,
        CASE
            WHEN (container_definition ->> 'readonlyRootFilesystem')::BOOLEAN = FALSE
            OR container_definition ->> 'readonlyRootFilesystem' IS NULL THEN 1
            ELSE 0
        END AS status,
        t.task_role_arn,
        lr.latest_revision
    FROM
        latest_revisions lr
    JOIN
        aws_ecs_task_definitions t
    ON
        CONCAT(lr.versionless_arn, ':', latest_revision) = t.arn
        AND lr.account_id = t.account_id
        AND lr.task_role_arn = t.task_role_arn
        AND lr.latest_revision = t.revision,
        JSONB_ARRAY_ELEMENTS(t.container_definitions) as container_definition
    WHERE
        t.status = 'ACTIVE'
)
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'ECS containers should be limited to read-only access to root filesystems' as title,
    account_id,
    arn,
    CASE
        WHEN max(status) OVER (PARTITION BY arn) = 1 THEN 'fail'
        ELSE 'pass'
    END as status
from
    flat_containers
{% endmacro %}

{% macro snowflake__containers_limited_read_only_root_filesystems(framework, check_id) %}
with latest_revisions as (
        SELECT
            REGEXP_REPLACE(arn, ':[^:]+$', '') AS versionless_arn,
            account_id,
            task_role_arn,
            max (revision) AS latest_revision
        FROM
            aws_ecs_task_definitions
        WHERE
            status = 'ACTIVE'
        GROUP BY
            REGEXP_REPLACE(arn, ':[^:]+$', ''),
            account_id,
            task_role_arn
), flat_containers as (
        SELECT
             t.arn,
             t.account_id,
             CASE
                 WHEN container_definition.value:readonlyRootFilesystem::BOOLEAN = FALSE
                 OR container_definition.value:readonlyRootFilesystem IS NULL THEN 1
                 ELSE 0
             END AS status,
             t.task_role_arn,
             lr.latest_revision
        FROM
             latest_revisions lr
        JOIN
             aws_ecs_task_definitions t
        ON
             CONCAT(lr.versionless_arn, ':', latest_revision) = t.arn
             AND lr.account_id = t.account_id
             AND lr.task_role_arn = t.task_role_arn
             AND lr.latest_revision = t.revision,
             LATERAL FLATTEN(input => t.container_definitions) AS container_definition
        WHERE
            t.status = 'ACTIVE'
)
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'ECS containers should be limited to read-only access to root filesystems' as title,
    account_id,
    arn,
    CASE
        WHEN max(status) OVER (PARTITION BY arn) = 1 THEN 'fail'
        ELSE 'pass'
    END as status
from
    flat_containers
{% endmacro %}

{% macro bigquery__containers_limited_read_only_root_filesystems(framework, check_id) %}
with latest_revisions as (
    SELECT
        REGEXP_REPLACE(arn, ':[^:]+$', '') AS versionless_arn,
        account_id,
        task_role_arn,
        max(revision) AS latest_revision
    FROM
        {{ full_table_name("aws_ecs_task_definitions") }}
    WHERE
        status = 'ACTIVE'
    GROUP BY
        REGEXP_REPLACE(arn, ':[^:]+$', ''),
        account_id,
        task_role_arn
),
flat_containers as (
    SELECT
        t.arn,
        t.account_id,
        CASE
            WHEN CAST(JSON_VALUE(container_definition.readonlyRootFilesystem) AS BOOL) = FALSE
            OR JSON_VALUE(container_definition.readonlyRootFilesystem) IS NULL THEN 1
            ELSE 0
        END AS status,
        t.task_role_arn,
        lr.latest_revision
    FROM
        latest_revisions lr
    JOIN
        {{ full_table_name("aws_ecs_task_definitions") }} t
    ON
        CONCAT(lr.versionless_arn, ':', latest_revision) = t.arn
        AND lr.account_id = t.account_id
        AND lr.task_role_arn = t.task_role_arn
        AND lr.latest_revision = t.revision,
        UNNEST(JSON_QUERY_ARRAY(t.container_definitions)) AS container_definition
    WHERE
    t.status = 'ACTIVE'
)
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'ECS containers should be limited to read-only access to root filesystems' as title,
    account_id,
    arn,
    CASE
        WHEN max(status) OVER (PARTITION BY arn) = 1 THEN 'fail'
        ELSE 'pass'
        END as status
from
    flat_containers
{% endmacro %}

{% macro athena__containers_limited_read_only_root_filesystems(framework, check_id) %}
select * from (
with latest_revisions as (
    SELECT
        REGEXP_REPLACE(arn, ':[^:]+$', '') AS versionless_arn,
        account_id,
        task_role_arn,
        max(revision) AS latest_revision
    FROM
        aws_ecs_task_definitions
    WHERE
        status = 'ACTIVE'
    GROUP BY
        REGEXP_REPLACE(arn, ':[^:]+$', ''),
        account_id,
        task_role_arn
),
flat_containers as (
    SELECT
        t.arn,
        t.account_id,
        CASE
            WHEN cast(json_extract_scalar(container_definition, '$.readonlyRootFilesystem') as BOOLEAN) = FALSE
                OR json_extract_scalar(container_definition, '$.readonlyRootFilesystem') IS NULL THEN 1
            ELSE 0
            END AS status,
        t.task_role_arn,
        lr.latest_revision
    FROM
        latest_revisions lr
            JOIN
        aws_ecs_task_definitions t
        ON
            CONCAT(lr.versionless_arn, ':', latest_revision) = t.arn
                AND lr.account_id = t.account_id
                AND lr.task_role_arn = t.task_role_arn
                AND lr.latest_revision = t.revision,
        unnest(cast(json_parse(t.container_definitions) as array(json))) as t(container_definition)
    WHERE
        t.status = 'ACTIVE'
)
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'ECS containers should be limited to read-only access to root filesystems' as title,
    account_id,
    arn,
    CASE
        WHEN max(status) OVER (PARTITION BY arn) = 1 THEN 'fail'
        ELSE 'pass'
    END as status
from
    flat_containers)
{% endmacro %}