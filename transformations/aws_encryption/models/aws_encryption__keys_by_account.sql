SELECT COUNT(arn), account_id
FROM aws_kms_keys 
GROUP BY account_id