SELECT *
FROM (SELECT * 
  FROM aws_computeoptimizer_ec2_instance_recommendations
  FULL JOIN aws_computeoptimizer_lambda_function_recommendations on true
  FULL JOIN aws_computeoptimizer_ebs_volume_recommendations on true
  FULL JOIN aws_computeoptimizer_ecs_service_recommendations on true
  FULL JOIN aws_computeoptimizer_autoscaling_group_recommendations on true
) as compute_opt
