SELECT
    checks.account_id,
    arn.value::text AS arn,
    checks.category,
    checks.id,
    checks.name,
    checks.description,
	results.status,
	results.timestamp
FROM
    aws_support_trusted_advisor_checks AS checks
    LEFT JOIN aws_support_trusted_advisor_check_results AS results ON checks.id = results.check_id,
	jsonb_array_elements(results.flagged_resources->'resourceId') AS arn
WHERE
    category = 'cost_optimizing'
    AND checks.language_code = 'en'