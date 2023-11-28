SELECT arn, enabled, key_manager, key_usage, multi_region, aws_account_id, region
FROM aws_kms_keys
WHERE key_usage = 'ENCRYPT_DECRYPT'
