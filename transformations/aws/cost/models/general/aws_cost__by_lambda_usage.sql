SELECT
  bill_payer_account_id,
  line_item_usage_account_id, 
  line_item_line_item_type,
  product_region_code,
  CASE
	WHEN line_item_usage_type LIKE '%Lambda-Edge-GB-Second%' THEN 'Lambda EDGE GB x Sec.'
	WHEN line_item_usage_type LIKE '%Lambda-Edge-Request%' THEN 'Lambda EDGE Requests'
	WHEN line_item_usage_type LIKE '%Lambda-GB-Second%' THEN 'Lambda GB x Sec.'
	WHEN line_item_usage_type LIKE '%Request%' THEN 'Lambda Requests'
	WHEN line_item_usage_type LIKE '%In-Bytes%' THEN 'Data Transfer (IN)'
	WHEN line_item_usage_type LIKE '%Out-Bytes%' THEN 'Data Transfer (Out)'
	WHEN line_item_usage_type LIKE '%Regional-Bytes%' THEN 'Data Transfer (Regional)'
	ELSE 'Other'
  END AS case_line_item_usage_type,
  line_item_resource_id,
  pricing_term,
  SUM(CAST(line_item_usage_amount AS DOUBLE PRECISION)) AS sum_line_item_usage_amount,
  SUM(line_item_unblended_cost) AS sum_line_item_unblended_cost
FROM {{ var('cost_usage_table') }}
  WHERE 
  line_item_product_code = 'AWS Lambda'
  AND line_item_line_item_type LIKE '%Usage%'
  AND product_product_family IN ('Data Transfer', 'Serverless')
GROUP BY
  bill_payer_account_id,
  line_item_usage_account_id,
  line_item_line_item_type,
  product_region_code,
  case_line_item_usage_type,
  line_item_resource_id,
  pricing_term
ORDER BY
  sum_line_item_usage_amount,
  sum_line_item_unblended_cost