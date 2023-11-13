{% set resource_tables = [{"dynamodb", "aws_dynamodb_tables"}, {"s3", "aws_s3_buckets"}, {"ec2", "aws_ec2_instances"}] %}

{% macro backup_resource(resource_table, resource_type) %}
    SELECT {{resource_table}}.account_id, {{resource_table}}.arn as resource_arn, tags, last_backup_time, '{{resource_type}}' as resource_type
    FROM {{resource_table}}
    LEFT JOIN aws_backup_protected_resources
    ON aws_backup_protected_resources.resource_arn = {{resource_table}}.arn
{% endmacro %}


