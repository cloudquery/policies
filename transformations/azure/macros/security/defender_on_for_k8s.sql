{% macro security_defender_on_for_k8s(framework, check_id) %}
  {{ return(adapter.dispatch('security_defender_on_for_k8s')(framework, check_id)) }}
{% endmacro %}

{% macro default__security_defender_on_for_k8s(framework, check_id) %}{% endmacro %}

{% macro postgres__security_defender_on_for_k8s(framework, check_id) %}
SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that Azure Defender is set to On for Kubernetes (Automatic)' as title,
  subscription_id,
  case
   when properties ->> 'pricingTier' = 'Standard'
   then 'pass' else 'fail'
  end
FROM azure_security_pricings asp
WHERE "name" = 'KubernetesService'
{% endmacro %}

{% macro snowflake__security_defender_on_for_k8s(framework, check_id) %}
SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that Azure Defender is set to On for Kubernetes (Automatic)' as title,
  subscription_id,
  case
   when properties:pricingTier = 'Standard'
   then 'pass' else 'fail'
  end
FROM azure_security_pricings asp
WHERE name = 'KubernetesService'
{% endmacro %}