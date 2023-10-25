{% macro iam_access_keys_rotated_more_than_90_days(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'IAM users access keys should be rotated every 90 days or less' AS title,
    account_id,
    access_key_id AS resource_id,
    CASE 
        WHEN DATEDIFF('DAY', last_rotated, CURRENT_TIMESTAMP()) > 90 THEN 'fail'
        ELSE 'pass'
    END AS status
FROM aws_iam_user_access_keys
{% endmacro %}