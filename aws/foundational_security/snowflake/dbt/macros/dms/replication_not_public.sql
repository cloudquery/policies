{% macro replication_not_public(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'AWS Database Migration Service replication instances should not be public' as title,
    account_id,
    arn as resource_id,
    case when
        publicly_accessible = true
        then 'fail'
        else 'pass'
    end as status
from aws_dms_replication_instances
{% endmacro %}