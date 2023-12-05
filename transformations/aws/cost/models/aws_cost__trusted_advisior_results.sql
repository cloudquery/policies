SELECT *
FROM (
	SELECT checks.account_id, category, description, id, name, flagged_resources, resources_summary, status, timestamp
	FROM aws_support_trusted_advisor_checks as checks
	LEFT JOIN aws_support_trusted_advisor_check_results as results
	ON checks.id = results.check_id
	WHERE category='cost_optimizing' and checks.language_code='en' 
) as trust_adv