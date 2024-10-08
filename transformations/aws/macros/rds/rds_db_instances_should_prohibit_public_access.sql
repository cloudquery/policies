{% macro rds_db_instances_should_prohibit_public_access(framework, check_id) %}
  {{ return(adapter.dispatch('rds_db_instances_should_prohibit_public_access')(framework, check_id)) }}
{% endmacro %}

{% macro default__rds_db_instances_should_prohibit_public_access(framework, check_id) %}{% endmacro %}

{% macro postgres__rds_db_instances_should_prohibit_public_access(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure that public access is not given to RDS Instance (Automated)' as title,
    account_id,
    arn AS resource_id,
    case when publicly_accessible is TRUE then 'fail' else 'pass' end as status
from aws_rds_instances
{% endmacro %}

{% macro bigquery__rds_db_instances_should_prohibit_public_access(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure that public access is not given to RDS Instance (Automated)' as title,
    account_id,
    arn AS resource_id,
    case when publicly_accessible is TRUE then 'fail' else 'pass' end as status
from {{ full_table_name("aws_rds_instances") }}
{% endmacro %}

{% macro snowflake__rds_db_instances_should_prohibit_public_access(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure that public access is not given to RDS Instance (Automated)' as title,
    account_id,
    arn AS resource_id,
    case when publicly_accessible = TRUE then 'fail' else 'pass' end as status
from aws_rds_instances
{% endmacro %}

{% macro athena__rds_db_instances_should_prohibit_public_access(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure that public access is not given to RDS Instance (Automated)' as title,
    account_id,
    arn AS resource_id,
    case when publicly_accessible = TRUE then 'fail' else 'pass' end as status
from aws_rds_instances
{% endmacro %}

