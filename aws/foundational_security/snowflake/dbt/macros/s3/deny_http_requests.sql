{% macro deny_http_requests(framework, check_id) %}
insert into aws_policy_results
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