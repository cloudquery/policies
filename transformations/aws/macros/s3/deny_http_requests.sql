{% macro deny_http_requests(framework, check_id) %}
  {{ return(adapter.dispatch('deny_http_requests')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__deny_http_requests(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'S3 buckets should deny non-HTTPS requests' AS title,
    account_id,
    arn AS resource_id,
    'fail' AS status
FROM
    aws_s3_buckets
WHERE
    arn NOT IN (
        SELECT foo.arn
        FROM (
            SELECT
                b.arn,
                statements.value AS statement
            FROM
                aws_s3_buckets AS b,
                LATERAL FLATTEN(INPUT => IFF(TYPEOF(b.policy:Statement) = 'STRING', TO_ARRAY(b.policy:Statement), b.policy:Statement)) AS statements
            WHERE
                GET_PATH(statement, 'Effect')::STRING = 'Deny'
                AND GET_PATH(statement, 'Condition.Bool.aws:SecureTransport')::STRING = 'false'
        ) AS foo
        WHERE
            GET_PATH(foo.statement, 'Principal')::STRING = '*'
            OR CONTAINS(GET_PATH(foo.statement, 'Principal')::STRING, '*')
    )
{% endmacro %}

{% macro postgres__deny_http_requests(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'S3 buckets should deny non-HTTPS requests' as title,
    account_id,
    arn as resource_id,
    'fail' as status
from
    aws_s3_buckets
where
    arn not in (
        -- Find all buckets that have a bucket policy that denies non-SSL requests
        select arn
        from (select aws_s3_buckets.arn,
                     statements,
                     statements -> 'Principal' as principals
              from aws_s3_buckets,
                   jsonb_array_elements(
                           case jsonb_typeof(policy -> 'Statement')
                               when
                                   'string' then jsonb_build_array(
                                       policy ->> 'Statement'
                                   )
                               when 'array' then policy -> 'Statement'
                               end
                       ) as statements
              where statements -> 'Effect' = '"Deny"') as foo,
             jsonb_array_elements_text(
                     statements -> 'Condition' -> 'Bool' -> 'aws:securetransport'
                 ) as ssl
        where principals = '"*"'
           or (
                          principals::JSONB ? 'AWS'
                      and (
                                          principals -> 'AWS' = '"*"'
                                  or principals -> 'AWS' @> '"*"'
                              )
                  )
            and ssl::BOOL = FALSE
        )
{% endmacro %}

{% macro default__deny_http_requests(framework, check_id) %}{% endmacro %}
                    