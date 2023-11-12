{% macro backup_ec2() %}
    SELECT aws_ec2_instances.account_id, aws_ec2_instances.arn as resource_arn, tags,   last_backup_time, 'EC2' as resource_type
    FROM aws_ec2_instances
    LEFT JOIN aws_backup_protected_resources
    ON aws_backup_protected_resources.resource_arn = aws_ec2_instances.arn
{% endmacro %}