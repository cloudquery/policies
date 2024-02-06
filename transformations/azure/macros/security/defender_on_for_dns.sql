{% macro security_defender_on_for_dns(framework, check_id) %}
  {{ return(adapter.dispatch('security_defender_on_for_dns')(framework, check_id)) }}
{% endmacro %}

{% macro default__security_defender_on_for_dns(framework, check_id) %}{% endmacro %}

{% macro postgres__security_defender_on_for_dns(framework, check_id) %}
SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that Microsoft Defender is set to On for DNS (Automatic)' as title,
  subscription_id,
  case
    when properties ->> 'pricingTier' = 'Standard'
    then 'pass' else 'fail'
  end
FROM azure_security_pricings asp
WHERE "name" = 'DNS'
{% endmacro %}

{% macro snowflake__security_defender_on_for_dns(framework, check_id) %}
SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that Microsoft Defender is set to On for DNS (Automatic)' as title,
  subscription_id,
  case
    when properties:pricingTier = 'Standard'
    then 'pass' else 'fail'
  end
FROM azure_security_pricings asp
WHERE name = 'DNS'
{% endmacro %}

{% macro bigquery__security_defender_on_for_dns(framework, check_id) %}
SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that Microsoft Defender is set to On for DNS (Automatic)' as title,
  subscription_id,
  case
    when JSON_VALUE(properties.pricingTier) = 'Standard'
    then 'pass' else 'fail'
  end
FROM {{ full_table_name("azure_security_pricings") }} asp
WHERE name = 'DNS'
{% endmacro %}