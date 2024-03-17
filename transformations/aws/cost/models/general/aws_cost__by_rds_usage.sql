SELECT 
  bill_payer_account_id,
  line_item_usage_account_id,
  product_instance_type, 
  line_item_operation, 
  line_item_usage_type, 
  line_item_line_item_type,
  pricing_term, 
  product_product_family, 
  line_item_resource_id,
  SUM(CASE WHEN line_item_line_item_type = 'DiscountedUsage' THEN line_item_usage_amount
    WHEN line_item_line_item_type = 'Usage' THEN line_item_usage_amount
    ELSE 0 
  END) AS sum_line_item_usage_amount, 
  SUM(line_item_unblended_cost) AS sum_line_item_unblended_cost 
FROM 
  {{ var('cost_usage_table') }} 
WHERE  
  line_item_product_code = 'Amazon Relational Database Service'
GROUP BY 
  bill_payer_account_id,
  line_item_usage_account_id,
  product_instance_type, 
  line_item_operation, 
  line_item_usage_type, 
  line_item_line_item_type,
  pricing_term, 
  product_product_family, 
  line_item_resource_id

