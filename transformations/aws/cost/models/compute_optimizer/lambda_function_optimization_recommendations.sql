/*
This query retrieves recommendations for Lambda function optimization from AWS Compute Optimizer.
 It includes information such as the function's account ID, ARN, name, version, code size,
 region, and various performance metrics.
 It also includes recommendations for memory size optimization.
*/
SELECT 
	r.account_id,
	function_arn,
	configuration ->> 'FunctionName' as function_name,
	region,
	r.tags,
	function_version,
	configuration ->> 'CodeSize' as code_size,
	lookback_period_in_days,
	number_of_invocations,
	current_performance_risk,
	finding,
	finding_reason_codes,
	current_memory_size,
	memory_size_recommendation_options ->> 'memorySize' as recommend_memory_size
FROM 
    aws_computeoptimizer_lambda_function_recommendations r
LEFT JOIN
    aws_lambda_functions as alf ON alf.arn = r.function_arn