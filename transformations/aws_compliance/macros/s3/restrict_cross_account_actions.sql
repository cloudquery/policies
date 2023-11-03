{% macro restrict_cross_account_actions(framework, check_id) %}
  {{ return(adapter.dispatch('restrict_cross_account_actions')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__restrict_cross_account_actions(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon S3 permissions granted to other AWS accounts in bucket policies should be restricted' AS title,
    account_id,
    arn AS resource_id,
    'fail' AS status -- TODO FIXME
FROM (
    SELECT
        aws_s3_buckets.arn,
        account_id,
        name,
        region,
        -- For each Statement return an array containing the principals
        CASE
            WHEN
                TYPEOF(statements.VALUE:Principal) = 'STRING' THEN
                TO_ARRAY(statements.VALUE:Principal)
            WHEN
                TYPEOF(statements.VALUE:Principal:AWS) = 'STRING' THEN
                TO_ARRAY(statements.VALUE:Principal:AWS)
            WHEN
                TYPEOF(statements.VALUE:Principal:AWS) = 'ARRAY' THEN
                statements.VALUE:Principal:AWS
        END AS principals,
        -- For each Statement return an array containing the Actions
        CASE
            WHEN
                TYPEOF(statements.VALUE:Action) = 'STRING' THEN
                TO_ARRAY(statements.VALUE:Action)
            WHEN
                TYPEOF(statements.VALUE:Action) = 'ARRAY' THEN
                statements.VALUE:Action
        END AS actions
    FROM
        aws_s3_buckets,
        LATERAL FLATTEN(
            INPUT => CASE
                WHEN TYPEOF(policy:Statement) = 'STRING' THEN TO_ARRAY(policy:Statement)
                WHEN TYPEOF(policy:Statement) = 'ARRAY' THEN policy:Statement
            END
        ) statements
    WHERE
        statements.VALUE:Effect = 'Allow'
) AS flatten_statements,
LATERAL FLATTEN(INPUT => actions) AS a,
LATERAL FLATTEN(INPUT => principals) AS p
WHERE
    -- Any cross account principals (or unknown principals) get flagged
    (
        p.VALUE::STRING NOT LIKE 'arn:aws:iam::' || account_id || ':%'
        OR p.VALUE::STRING = '*'
    )
    -- Any broad permissions or Deletes get flagged
    AND (a.VALUE::STRING LIKE 's3:%*'
        OR a.VALUE::STRING LIKE 's3:DeleteObject')

-- This will flag ALL canonical IDs as NOT COMPLIANT
-- This will flag ALL users that have been deleted as NOT COMPLIANT
-- This will not catch if an explicit deny supercedes the statement
{% endmacro %}

{% macro postgres__restrict_cross_account_actions(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Amazon S3 permissions granted to other AWS accounts in bucket policies should be restricted' as title,
    account_id,
    arn as resource_id,
    'fail' as status -- TODO FIXME
FROM (
    SELECT aws_s3_buckets.arn,
        account_id,
		name,
		region,
        -- For each Statement return an array containing the principals
        CASE
            WHEN
                JSONB_TYPEOF(statements -> 'Principal') = 'string' THEN
                JSONB_BUILD_ARRAY( statements -> 'Principal')
            WHEN
                JSONB_TYPEOF(statements -> 'Principal' -> 'AWS') = 'string' THEN
                JSONB_BUILD_ARRAY( statements -> 'Principal' -> 'AWS' )
            WHEN
                JSONB_TYPEOF(statements -> 'Principal' -> 'AWS') = 'array' THEN
                statements -> 'Principal' -> 'AWS' END AS principals,
        -- For each Statement return an array containing the Actions
        CASE
            WHEN
                JSONB_TYPEOF(statements -> 'Action') = 'string' THEN
                JSONB_BUILD_ARRAY(statements -> 'Action')
            WHEN
                JSONB_TYPEOF(statements -> 'Action') = 'array' THEN
                statements -> 'Action' END AS actions
    FROM aws_s3_buckets,
        jsonb_array_elements(
            CASE JSONB_TYPEOF(policy -> 'Statement')
                WHEN 'string' THEN JSONB_BUILD_ARRAY(policy ->> 'Statement')
                WHEN 'array' THEN policy -> 'Statement'
            END
        ) AS statements
    WHERE statements -> 'Effect' = '"Allow"') AS flatten_statements,
    JSONB_ARRAY_ELEMENTS(TO_JSONB(actions)) AS a,
    JSONB_ARRAY_ELEMENTS(TO_JSONB(principals)) AS p
WHERE
    -- Any cross account principals (or unknown principals) get flagged
    (
        p.value::TEXT NOT LIKE '"arn:aws:iam::' || account_id || ':%"'
        OR p.value::TEXT = '"*"'
    )
    -- Any broad permissions or Deletes get flagged
    AND (a.value::TEXT LIKE '"s3:%*"'
        OR a.value::TEXT LIKE '"s3:DeleteObject"')

-- This will flag ALL canoninical IDs as NOT COMPLIANT
-- This will flag ALL users that have been deleted as NOT COMPLIANT
-- This will not catch if an explicit deny supercedes the statement
{% endmacro %}
