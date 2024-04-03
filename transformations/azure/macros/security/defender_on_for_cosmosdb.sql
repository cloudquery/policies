{% macro security_defender_on_for_cosmosdb(framework, check_id) %}
  {{ return(adapter.dispatch('security_defender_on_for_cosmosdb')(framework, check_id)) }}
{% endmacro %}

{% macro default__security_defender_on_for_cosmosdb(framework, check_id) %}{% endmacro %}

{% macro postgres__security_defender_on_for_cosmosdb(framework, check_id) %}
SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure That Microsoft Defender for Azure Cosmos DB Is Set To ON' as title,
  subscription_id,
  case
    when properties ->> 'pricingTier' = 'Standard'
    then 'pass' else 'fail'
  end
FROM azure_security_pricings asp
WHERE name = 'CosmosDbs'
{% endmacro %}

{% macro snowflake__security_defender_on_for_cosmosdb(framework, check_id) %}
{% endmacro %}

{% macro bigquery__security_defender_on_for_cosmosdb(framework, check_id) %}
{% endmacro %}