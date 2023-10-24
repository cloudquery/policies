{% macro rsa_certificate_key_length_should_be_more_than_2048_bits(framework, check_id) %}

insert into aws_policy_results
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id
  'rsa certificate key length is less than 2048 bits' as title,
  account_id,
  arn AS resource_id,
  CASE
  WHEN key_algorithm IN ('RSA-1024', 'RSA 1024', 'RSA_1024')
  THEN 'fail' 
  ELSE 'pass'
  END AS status
FROM aws_acm_certificates
WHERE left(key_algorithm, 3) = 'RSA'
{% endmacro %}