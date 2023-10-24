{% macro private_repositories_have_image_scanning_configured(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id, 
     'ECR private repositories should have image scanning configured' as title,
     account_id,
     arn as resource_id,
     CASE
       WHEN image_scanning_configuration:ScanOnPush::text = 'false' THEN 'fail'
       ELSE 'pass'
     END as status
 FROM 
     aws_ecr_repositories
{% endmacro %}