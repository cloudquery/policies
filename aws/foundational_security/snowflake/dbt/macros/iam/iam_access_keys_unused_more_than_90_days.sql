{% macro iam_access_keys_unused_more_than_90_days(framework, check_id) %}
INSERT INTO aws_policy_results
SELECT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Unused IAM user credentials should be removed' AS title,
    account_id,
    access_key_id AS resource_id,
    CASE 
        WHEN DATEDIFF('DAY', last_used, CURRENT_TIMESTAMP()) > 90 THEN 'fail'
        ELSE 'pass'
    END AS status
FROM aws_iam_user_access_keys;
{% endmacro %}