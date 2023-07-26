RESOURCES_BY_COST = """
CREATE OR REPLACE VIEW resources_by_cost as
SELECT
  line_item_resource_id,
  line_item_product_code,
  sum(line_item_blended_cost) AS cost
FROM erez_test_cost_usage_report_00001_snappy
WHERE line_item_resource_id !=''
GROUP BY line_item_resource_id, line_item_product_code
HAVING sum(line_item_blended_cost) > 0
ORDER BY cost DESC;
"""

REGIONS_BY_COST = """
CREATE OR REPLACE VIEW regions_by_cost as
SELECT
  product_location,
  sum(line_item_blended_cost) AS cost
FROM erez_test_cost_usage_report_00001_snappy
WHERE line_item_resource_id !='' and product_location_type = 'AWS Region'
GROUP BY product_location
HAVING sum(line_item_blended_cost) > 0
ORDER BY cost DESC;
"""