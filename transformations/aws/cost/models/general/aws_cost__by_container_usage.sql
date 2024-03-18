SELECT 
  bill_payer_account_id,
  line_item_usage_account_id,
  line_item_resource_id, 
  line_item_operation,
  line_item_product_code,
  SUM(CAST(line_item_usage_amount AS DOUBLE PRECISION)) AS sum_line_item_usage_amount,
  SUM(line_item_unblended_cost) sum_line_item_unblended_cost
FROM 
  {{ var('cost_usage_table') }} 
WHERE 
  line_item_product_code IN ('AmazonECS','AmazonEKS')
  AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage')
GROUP BY 
  bill_payer_account_id,
  line_item_usage_account_id,
  line_item_resource_id,
  line_item_operation,
  line_item_product_code