{% macro repositories_unused(framework, check_id) %}
  {{ return(adapter.dispatch('repositories_unused')(framework, check_id)) }}
{% endmacro %}

{% macro default__repositories_unused(framework, check_id) %}{% endmacro %}

{% macro postgres__repositories_unused(framework, check_id) %}
with image as (select distinct account_id, repository_name from aws_ecr_repository_images)
select
       '{{framework}}'            as framework,
       '{{check_id}}'             as check_id,
       'Unused ECR repository' as title,
       repository.account_id,
       repository.arn          as resource_id,
       'fail'                  as status
from aws_ecr_repositories repository
         left join image on image.account_id = repository.account_id and image.repository_name = repository.repository_name
where image.repository_name is null;
{% endmacro %}
