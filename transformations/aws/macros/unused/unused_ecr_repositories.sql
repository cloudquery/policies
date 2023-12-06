{% macro unused_ecr_repositories(framework, check_id) %}
  {{ return(adapter.dispatch('unused_ecr_repositories')(framework, check_id)) }}
{% endmacro %}

{% macro default__unused_ecr_repositories(framework, check_id) %}{% endmacro %}

{% macro postgres__unused_ecr_repositories(framework, check_id) %}
with image as (select distinct account_id, repository_name from aws_ecr_repository_images),
unused_repo as (
select 
       repository.account_id,
       repository.arn          as resource_id
from aws_ecr_repositories repository
         left join image on image.account_id = repository.account_id and image.repository_name = repository.repository_name
where image.repository_name is null)
SELECT 
    ur.account_id,
    ur.resource_id,
    rbc.cost
FROM unused_repo ur
JOIN {{ ref('aws_cost__by_resources') }} rbc ON ur.resource_id = rbc.line_item_resource_id
{% endmacro %}

{% macro snowflake__unused_ecr_repositories(framework, check_id) %}

{% endmacro %}