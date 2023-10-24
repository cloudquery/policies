{% macro private_repositories_have_tag_immutability_configured(framework, check_id) %}
insert into aws_policy_results
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id, 
     'ECR private repositories should have tag immutability configured' as title,
     account_id,
     arn as resource_id,
     CASE
       WHEN image_tag_mutability <> 'IMMUTABLE' THEN 'fail'
       ELSE 'pass'
     END as status
 FROM 
     aws_ecr_repositories
{% endmacro %}