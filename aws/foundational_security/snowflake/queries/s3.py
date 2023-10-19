#S3.1
ACCOUNT_LEVEL_PUBLIC_ACCESS_BLOCKS = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'S3 Block Public Access setting should be enabled' as title,
    aws_iam_accounts.account_id,
    aws_iam_accounts.account_id AS resource_id,
    case when
        config_exists is distinct from TRUE
        or block_public_acls is distinct from TRUE
        or block_public_policy is distinct from TRUE
        or ignore_public_acls is distinct from TRUE
        or restrict_public_buckets is distinct from TRUE
    then 'fail' else 'pass' end as status
from
    aws_iam_accounts
left join
    aws_s3_accounts on
        aws_iam_accounts.account_id = aws_s3_accounts.account_id
"""
#S3.2
# Unverified
PUBLICLY_READABLE_BUCKETS = """
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
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'S3 buckets should prohibit public read access' AS title,
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
            AND aws_s3_bucket_grants.permission IN ('READ_ACP', 'FULL_CONTROL')
        )
    )
    OR (
        aws_s3_buckets.block_public_policy != TRUE
        AND policy_allow_public.statement_count > 0
    )
"""

#S3.3
# Unverified
PUBLICLY_WRITABLE_BUCKETS = """
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
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
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
"""

#S3.4
# Note: This query doesn't validate if a bucket policy requires encryption for `put-object` requests
S3_SERVER_SIDE_ENCRYPTION_ENABLED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'S3 buckets should have server-side encryption enabled' as title,
    aws_s3_buckets.account_id,
    arn as resource_id,
    case when
        aws_s3_bucket_encryption_rules.bucket_arn is null
    then 'fail' else 'pass' end as status
from
    aws_s3_buckets
left join aws_s3_bucket_encryption_rules on aws_s3_bucket_encryption_rules.bucket_arn=aws_s3_buckets.arn
"""

#S3.5
# Unverified
DENY_HTTP_REQUESTS = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
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
"""
#S3.6
# Unverified
RESTRICT_CROSS_ACCOUNT_ACTIONS = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
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
"""

#s8
S3_BUCKET_LEVEL_PUBLIC_ACCESS_PROHIBITED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'S3 Block Public Access setting should be enabled at the bucket-level' AS title,
    account_id,
    arn AS resource_id,
    CASE
    when block_public_acls
    and block_public_policy
    and ignore_public_acls
    and restrict_public_buckets THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_s3_buckets
"""

#s9
S3_BUCKET_LOGGING_ENABLED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'S3 bucket server access logging should be enabled' AS title,
    account_id,
    arn AS resource_id,
    CASE
        when logging_target_bucket IS NOT NULL
        THEN 'pass' ELSE 'fail'
    END AS status
FROM
    aws_s3_buckets
"""

#s10
S3_VERSION_LIFECYCLE_POLICY_CHECK = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'S3 buckets with versioning enabled should have lifecycle policies configured' AS title,
    b.account_id,
    b.arn AS resource_id,
    CASE
        WHEN l.STATUS = 'Enabled' THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_s3_buckets AS b
LEFT JOIN
    aws_s3_bucket_lifecycles AS l
ON
    b.arn = l.bucket_arn
where b.versioning_status = 'Enabled'
"""

#s11
S3_EVENT_NOTIFICATIONS_ENABLED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'S3 buckets should have event notifications enabled' AS title,
    account_id,
    bucket_arn AS resource_id,    
    CASE WHEN
        (EVENT_BRIDGE_CONFIGURATION::String IS NULL OR ARRAY_SIZE(EVENT_BRIDGE_CONFIGURATION) = 0)
        AND (LAMBDA_FUNCTION_CONFIGURATIONS::String IS NULL OR ARRAY_SIZE(LAMBDA_FUNCTION_CONFIGURATIONS) = 0)
        AND (QUEUE_CONFIGURATIONS::String IS NULL OR ARRAY_SIZE(QUEUE_CONFIGURATIONS) = 0)
        AND (TOPIC_CONFIGURATIONS::String IS NULL OR ARRAY_SIZE(TOPIC_CONFIGURATIONS) = 0)
    THEN 'fail'
    ELSE 'pass'
    END AS status
FROM
    aws_s3_bucket_notification_configurations;
"""

#s13
S3_LIFECYCLE_POLICY_CHECK = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'S3 buckets should have lifecycle policies configured' AS title,
    b.account_id,
    b.arn AS resource_id,
    CASE
        WHEN l.STATUS = 'Enabled' THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_s3_buckets AS b
LEFT JOIN
    aws_s3_bucket_lifecycles AS l
ON
    b.arn = l.bucket_arn
"""

#s15
S3_BUCKET_DEFAULT_LOCK_ENABLED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'S3 buckets should be configured to use Object Lock' AS title,
    a.account_id,
    a.arn AS resource_id,
    CASE WHEN b.object_lock_enabled = 'Enabled' THEN 'pass' ELSE 'fail' END AS status
FROM
    aws_s3_buckets a
LEFT JOIN
    aws_s3_bucket_object_lock_configurations b
ON
    a.arn = b.bucket_arn
GROUP BY
    a.account_id,
    a.arn,
    status;
"""