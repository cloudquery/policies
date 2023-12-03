{% macro publicly_readable_buckets(framework, check_id) %}
  {{ return(adapter.dispatch('publicly_readable_buckets')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__publicly_readable_buckets(framework, check_id) %}
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
                aws_s3_buckets
            inner join aws_s3_bucket_policies bp on aws_s3_buckets.arn = bp.bucket_arn,
                LATERAL FLATTEN(INPUT => IFF(TYPEOF(bp.policy_json:Statement) = 'STRING', 
                                              TO_ARRAY(bp.policy_json:Statement), 
                                              bp.policy_json:Statement)) AS statements
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
LEFT JOIN aws_s3_bucket_public_access_blocks ON
        aws_s3_buckets.arn = aws_s3_bucket_public_access_blocks.bucket_arn
WHERE
    (
        (aws_s3_bucket_public_access_blocks.public_access_block_configuration:BlockPublicAcls)::boolean != TRUE
        AND (
            aws_s3_bucket_grants.grantee:URI::STRING = 'http://acs.amazonaws.com/groups/global/AllUsers'
            AND aws_s3_bucket_grants.permission IN ('READ_ACP', 'FULL_CONTROL')
        )
    )
    OR (
        (aws_s3_bucket_public_access_blocks.public_access_block_configuration:BlockPublicPolicy)::boolean != TRUE
        AND policy_allow_public.statement_count > 0
    )
{% endmacro %}

{% macro postgres__publicly_readable_buckets(framework, check_id) %}
with policy_allow_public as (
    select
        arn,
        count(*) as statement_count
    from
        (
            select
                b.arn,
                bp.policy_json -> 'Statement' -> 'Principal' as principals
            from
                aws_s3_buckets b
                inner join aws_s3_bucket_policies bp on b.arn = bp.bucket_arn
            where
                bp.policy_json -> 'Statement' -> 'Effect' = '"Allow"'
        ) as foo
    where
        principals = '"*"'
        or (
            principals::JSONB ? 'AWS'
            and (
                principals -> 'AWS' = '"*"'
                or principals -> 'AWS' @> '"*"'
            )
        )
    group by
        arn
)

select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'S3 buckets should prohibit public read access' as title,
    aws_s3_buckets.account_id,
    aws_s3_buckets.arn as resource_id,
    'fail' as status -- TODO FIXME
from
    -- Find and join all bucket ACLS that givea public write access
    aws_s3_buckets
left join
    aws_s3_bucket_grants on
            aws_s3_buckets.arn = aws_s3_bucket_grants.bucket_arn
-- Find all statements that could give public allow access 
-- Statements that give public access have 1) Effect == Allow 2) One of the following principal:
--       Principal = {"AWS": "*"}
--       Principal = {"AWS": ["arn:aws:iam::12345678910:root", "*"]}
--       Principal = "*"
left join policy_allow_public on
        aws_s3_buckets.arn = policy_allow_public.arn
left join aws_s3_bucket_public_access_blocks on
        aws_s3_buckets.arn = aws_s3_bucket_public_access_blocks.bucket_arn
where
    (
        (aws_s3_bucket_public_access_blocks.public_access_block_configuration -> 'BlockPublicAcls')::boolean != TRUE
        and (
            grantee->>'URI' = 'http://acs.amazonaws.com/groups/global/AllUsers'
            and permission in ('READ_ACP', 'FULL_CONTROL')
        )
    )
    or (
        (aws_s3_bucket_public_access_blocks.public_access_block_configuration -> 'BlockPublicPolicy')::boolean != TRUE
        and policy_allow_public.statement_count > 0
    )
{% endmacro %}

{% macro default__publicly_readable_buckets(framework, check_id) %}{% endmacro %}

{% macro bigquery__publicly_readable_buckets(framework, check_id) %}
with policy_allow_public as (
    select
        arn,
        count(*) as statement_count
    from
        (
            select
                b.arn,
                bp.policy_json.Statement.Principal as principals
            from
                {{ full_table_name("aws_s3_buckets") }} b
                inner join {{ full_table_name("aws_s3_bucket_policies") }} bp on b.arn = bp.bucket_arn
            where
                JSON_VALUE(bp.policy_json.Statement.Effect) = '"Allow"'
        ) as foo
    where
        JSON_VALUE(principals) = '"*"'
        or (
            'AWS' IN UNNEST(JSON_EXTRACT_STRING_ARRAY(principals))
            and (
                JSON_VALUE(principals.AWS) = '"*"'
                or '"*"' IN UNNEST(JSON_EXTRACT_STRING_ARRAY(principals.AWS))
            )
        )
    group by
        arn
)
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'S3 buckets should prohibit public read access' as title,
    aws_s3_buckets.account_id,
    aws_s3_buckets.arn as resource_id,
    'fail' as status -- TODO FIXME
from
    -- Find and join all bucket ACLS that give a public write access
    {{ full_table_name("aws_s3_buckets") }}
left join
    {{ full_table_name("aws_s3_bucket_grants") }} on
        aws_s3_buckets.arn = aws_s3_bucket_grants.bucket_arn
-- Find all statements that could give public allow access 
-- Statements that give public access have 1) Effect == Allow 2) One of the following principal:
--       Principal = {"AWS": "*"}
--       Principal = {"AWS": ["arn:aws:iam::12345678910:root", "*"]}
--       Principal = "*"
left join policy_allow_public on
        aws_s3_buckets.arn = policy_allow_public.arn
left join {{ full_table_name("aws_s3_bucket_public_access_blocks") }} on
        aws_s3_buckets.arn = aws_s3_bucket_public_access_blocks.bucket_arn
where
    (
        CAST( JSON_VALUE(aws_s3_bucket_public_access_blocks.public_access_block_configuration.BlockPublicAcls) AS BOOL) != TRUE
        and (
            JSON_VALUE(grantee.URI) = 'http://acs.amazonaws.com/groups/global/AllUsers'
            and permission in ('READ_ACP', 'FULL_CONTROL')
        )
    )
    or (
       CAST( JSON_VALUE(aws_s3_bucket_public_access_blocks.public_access_block_configuration.BlockPublicPolicy) AS BOOL) != TRUE
        and policy_allow_public.statement_count > 0
    )
{% endmacro %} 