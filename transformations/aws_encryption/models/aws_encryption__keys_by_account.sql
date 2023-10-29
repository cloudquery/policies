SELECT COUNT(arn), account_id
FROM aws_kms_keys 
WHERE key_usage = 'ENCRYPT_DECRYPT'
GROUP BY account_id