PRIVATE_REPOSITORIES_HAVE_IMAGE_SCANNING_CONFIGURED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id, 
     'ECR private repositories should have image scanning configured' as title,
     account_id,
     arn as resource_id,
     CASE
       WHEN image_scanning_configuration:ScanOnPush::text = 'false' THEN 'fail'
       ELSE 'pass'
     END as status
 FROM 
     aws_ecr_repositories
"""

PRIVATE_REPOSITORIES_HAVE_TAG_IMMUTABILITY_CONFIGURED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id, 
     'ECR private repositories should have tag immutability configured' as title,
     account_id,
     arn as resource_id,
     CASE
       WHEN image_tag_mutability <> 'IMMUTABLE' THEN 'fail'
       ELSE 'pass'
     END as status
 FROM 
     aws_ecr_repositories
"""

REPOSITORIES_HAVE_AT_LEAST_ONE_LIFECYCLE_POLICY = """
insert into aws_policy_results
SELECT DISTINCT
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,   
     'ECR repositories should have at least one lifecycle policy configured' as title,
     r.account_id,
     r.arn as resource_id,
     CASE
       WHEN p.policy_json is null OR p.lifecycle_policy_text is null THEN 'fail'
       ELSE 'pass'
     END as status
 FROM 
     aws_ecr_repositories r
 LEFT JOIN aws_ecr_repository_lifecycle_policies p
    ON r.repository_name = p.repository_name
"""