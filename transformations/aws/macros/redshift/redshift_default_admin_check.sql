{% macro redshift_default_admin_check(framework, check_id) %}
  {{ return(adapter.dispatch('redshift_default_admin_check')(framework, check_id)) }}
{% endmacro %}

{% macro default__redshift_default_admin_check(framework, check_id) %}{% endmacro %}

{% macro postgres__redshift_default_admin_check(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon Redshift clusters should not use the default Admin username' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN master_username = 'awsuser' THEN 'fail'
    ELSE 'pass'
    END AS status
from aws_redshift_clusters
{% endmacro %}

{% macro snowflake__redshift_default_admin_check(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon Redshift clusters should not use the default Admin username' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN master_username = 'awsuser' THEN 'fail'
    ELSE 'pass'
    END AS status
from aws_redshift_clusters
{% endmacro %}

{% macro bigquery__redshift_default_admin_check(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon Redshift clusters should not use the default Admin username' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN master_username = 'awsuser' THEN 'fail'
    ELSE 'pass'
    END AS status
from {{ full_table_name("aws_redshift_clusters") }}
{% endmacro %}

{% macro athena__redshift_default_admin_check(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon Redshift clusters should not use the default Admin username' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN master_username = 'awsuser' THEN 'fail'
    ELSE 'pass'
    END AS status
from aws_redshift_clusters
{% endmacro %}