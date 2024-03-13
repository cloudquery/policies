SELECT 
    instance_status->>'Status' AS status,
    COUNT(*) AS count
FROM 
    aws_ec2_instance_statuses
GROUP BY 
    instance_status->>'Status'