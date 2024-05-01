{% macro private_repositories_have_image_scanning_configured(framework, check_id) %}
  {{ return(adapter.dispatch('private_repositories_have_image_scanning_configured')(framework, check_id)) }}
{% endmacro %}

{% macro default__private_repositories_have_image_scanning_configured(framework, check_id) %}{% endmacro %}

{% macro postgres__private_repositories_have_image_scanning_configured(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id, 
     'ECR private repositories should have image scanning configured' as title,
     account_id,
     arn as resource_id,
     CASE
       WHEN image_scanning_configuration ->> 'ScanOnPush' = 'false' THEN 'fail'
       ELSE 'pass'
     END as status
 FROM 
     aws_ecr_repositories
{% endmacro %}

{% macro snowflake__private_repositories_have_image_scanning_configured(framework, check_id) %}
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

{% macro bigquery__private_repositories_have_image_scanning_configured(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id, 
     'ECR private repositories should have image scanning configured' as title,
     account_id,
     arn as resource_id,
     CASE
       WHEN CAST(JSON_VALUE(image_scanning_configuration.ScanOnPush) AS STRING) = 'false' THEN 'fail'
       ELSE 'pass'
     END as status
 FROM 
     {{ full_table_name("aws_ecr_repositories") }}
{% endmacro %}

{% macro athena__private_repositories_have_image_scanning_configured(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id, 
     'ECR private repositories should have image scanning configured' as title,
     account_id,
     arn as resource_id,
     CASE
       WHEN json_extract_scalar(image_scanning_configuration, '$.ScanOnPush') = 'false' THEN 'fail'
       ELSE 'pass'
     END as status
 FROM 
     aws_ecr_repositories
{% endmacro %}