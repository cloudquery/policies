{% set resource_tables = [{"dynamodb", "aws_dynamodb_tables"}, {"s3", "aws_s3_buckets"}, {"ec2", "aws_ec2_instances"}] %}

{% macro backup_resource(resource_type) %}
    SELECT {{resource_type}}.account_id, {{resource_type}}.arn as resource_arn, tags, last_backup_time, 'DynamoDB' as resource_type
    FROM {{resource_type}}
    LEFT JOIN aws_backup_protected_resources
    ON aws_backup_protected_resources.resource_arn = {{resource_type}}.arn
{% endmacro %}


