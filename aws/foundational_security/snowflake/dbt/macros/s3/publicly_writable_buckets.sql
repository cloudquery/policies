{% macro publicly_writable_buckets(framework, check_id) %}
WITH policy_allow_public AS (
    SELECT
        arn,
        COUNT(*) AS statement_count
    FROM
        (
            SELECT
                aws_s3_buckets.arn,
                statements.value:Principal AS principals
            FROM
                aws_s3_buckets,
                LATERAL FLATTEN(INPUT => IFF(TYPEOF(policy:Statement) = 'STRING', 
                                              TO_ARRAY(policy:Statement), 
                                              policy:Statement)) AS statements
            WHERE
                statements.value:Effect::STRING = 'Allow'
        ) AS foo
    WHERE
        foo.principals = '*'
        OR (
            CONTAINS(foo.principals::STRING, 'AWS')
            AND (
                GET(foo.principals::VARIANT, 'AWS') = '*'
                OR CONTAINS(foo.principals::STRING, '*')
            )
        )
    GROUP BY
        arn
)

SELECT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'S3 buckets should prohibit public write access' AS title,
    aws_s3_buckets.account_id,
    aws_s3_buckets.arn AS resource_id,
    'fail' AS status -- TODO FIXME
FROM
    aws_s3_buckets
LEFT JOIN
    aws_s3_bucket_grants ON
        aws_s3_buckets.arn = aws_s3_bucket_grants.bucket_arn
LEFT JOIN policy_allow_public ON
        aws_s3_buckets.arn = policy_allow_public.arn
WHERE
    (
        aws_s3_buckets.block_public_acls != TRUE
        AND (
            aws_s3_bucket_grants.grantee:URI::STRING = 'http://acs.amazonaws.com/groups/global/AllUsers'
            AND aws_s3_bucket_grants.permission IN ('WRITE_ACP', 'FULL_CONTROL')
        )
    )
    OR (
        aws_s3_buckets.block_public_policy != TRUE
        AND policy_allow_public.statement_count > 0
    )
{% endmacro %}