SELECT KMSKeyID, account_id, COUNT(arn)
FROM aws_encryption__encrypted_resources
GROUP BY KMSKeyID, account_id