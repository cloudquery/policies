{% macro instances_should_prohibit_public_access(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS DB instances should prohibit public access, determined by the PubliclyAccessible configuration' as title,
    account_id,
    arn AS resource_id,
    case when publicly_accessible = TRUE then 'fail' else 'pass' end as status
from aws_rds_instances
{% endmacro %}