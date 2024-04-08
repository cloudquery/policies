{% macro security_defender_on_for_containers(framework, check_id) %}
  {{ return(adapter.dispatch('security_defender_on_for_containers')(framework, check_id)) }}
{% endmacro %}

{% macro default__security_defender_on_for_containers(framework, check_id) %}{% endmacro %}

{% macro postgres__security_defender_on_for_containers(framework, check_id) %}
SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that Auto provisioning of Microsoft Defender for Containers components is Set to ON' as title,
  subscription_id,
  case
    when properties ->> 'pricingTier' = 'Standard'
    then 'pass' else 'fail'
  end
FROM azure_security_pricings asp
WHERE name = 'Containers'
{% endmacro %}

{% macro snowflake__security_defender_on_for_containers(framework, check_id) %}
SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that Auto provisioning of Microsoft Defender for Containers components is Set to ON' as title,
  subscription_id,
  case
    when properties:pricingTier = 'Standard'
    then 'pass' else 'fail'
  end
FROM azure_security_pricings asp
WHERE name = 'Containers'
{% endmacro %}

{% macro bigquery__security_defender_on_for_containers(framework, check_id) %}
SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that Auto provisioning of Microsoft Defender for Containers components is Set to ON' as title,
  subscription_id,
  case
    when JSON_VALUE(properties.pricingTier) = 'Standard'
    then 'pass' else 'fail'
  end
FROM {{ full_table_name("azure_security_pricings") }} asp
WHERE name = 'Containers'
{% endmacro %}