{% macro repositories_have_at_least_one_lifecycle_policy(framework, check_id) %}
insert into aws_policy_results
SELECT DISTINCT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,   
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
{% endmacro %}