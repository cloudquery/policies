{% macro redshift_default_admin_check(framework, check_id) %}
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