{% macro storage_buckets_publicly_accessible(framework, check_id) %}
  {{ return(adapter.dispatch('storage_buckets_publicly_accessible')(framework, check_id)) }}
{% endmacro %}

{% macro default__storage_buckets_publicly_accessible(framework, check_id) %}{% endmacro %}

{% macro postgres__storage_buckets_publicly_accessible(framework, check_id) %}
WITH project_policy_roles AS (SELECT
                                     p.project_id,
                                     p.name,
                                     CASE WHEN p.name like '%.appspot.com' THEN 'https://'||p.name ELSE 'https://' || p.name || '.storage.googleapis.com' END AS self_link,
                                     jsonb_array_elements(pp.bindings) AS binding
                              FROM gcp_storage_buckets p LEFT JOIN gcp_storage_bucket_policies pp ON pp.project_id=p.project_id AND pp.bucket_name=p.name
     ),
     role_members AS (SELECT
                             project_id,
                             name,
                             self_link,
                             binding ->> 'role'                              AS "role",
                             jsonb_array_elements_text(binding -> 'members') AS MEMBER
                      FROM project_policy_roles),
    gcp_public_buckets_accesses AS (
        SELECT project_id, name, self_link, "role", MEMBER
        FROM role_members
    )
select 
                "name"                                                                    AS resource_id,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that Cloud Storage bucket is not anonymously or publicly accessible (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                            member LIKE '%allUsers%'
                        OR member LIKE '%allAuthenticatedUsers%'
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_public_buckets_accesses
{% endmacro %}

{% macro snowflake__storage_buckets_publicly_accessible(framework, check_id) %}
 WITH 
    bindings as (
    select
      project_id,
      bucket_name,
        binding.value as value             
    FROM gcp_storage_bucket_policies pp,
    LATERAL FLATTEN(input => bindings) AS binding
    ),
    project_policy_roles AS (
    SELECT
       p.project_id,
       p.name,
       CASE WHEN p.name like '%.appspot.com' THEN 'https://'||p.name ELSE 'https://' || p.name || '.storage.googleapis.com' END AS self_link,
       pp.value AS binding
FROM gcp_storage_buckets p LEFT JOIN bindings pp ON pp.project_id=p.project_id AND pp.bucket_name=p.name
    ),
    role_members AS (
      SELECT
             project_id,
             name,
             self_link,
             binding:role                              AS role,
             MEMBER.value AS MEMBER
      FROM project_policy_roles,
      LATERAL FLATTEN(input => binding:members) AS MEMBER
    ), gcp_public_buckets_accesses AS (
        SELECT project_id, name, self_link, role, MEMBER
        FROM role_members
    )
 select 
                name                                                                    AS resource_id,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that Cloud Storage bucket is not anonymously or publicly accessible (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                            member LIKE '%allUsers%'
                        OR member LIKE '%allAuthenticatedUsers%'
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_public_buckets_accesses
{% endmacro %}

{% macro bigquery__storage_buckets_publicly_accessible(framework, check_id) %}
WITH 
    bindings as (
    select
      project_id,
      bucket_name,
        binding as value             
    FROM {{ full_table_name("gcp_storage_bucket_policies") }} pp,
    UNNEST(JSON_QUERY_ARRAY(bindings)) AS binding
    ),
    project_policy_roles AS (
    SELECT
       p.project_id,
       p.name,
       CASE WHEN p.name like '%.appspot.com' THEN 'https://'||p.name ELSE 'https://' || p.name || '.storage.googleapis.com' END AS self_link,
       pp.value AS binding
FROM {{ full_table_name("gcp_storage_buckets") }} p LEFT JOIN bindings pp ON pp.project_id=p.project_id AND pp.bucket_name=p.name
    ),
    role_members AS (
      SELECT
             project_id,
             name,
             self_link,
             binding.role                              AS role,
             MEMBER AS MEMBER
      FROM project_policy_roles,
      UNNEST(JSON_QUERY_ARRAY(binding.members)) AS MEMBER
    ), gcp_public_buckets_accesses AS (
        SELECT project_id, name, self_link, role, MEMBER
        FROM role_members
    )
 select 
                name                                                                    AS resource_id,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that Cloud Storage bucket is not anonymously or publicly accessible (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                            JSON_VALUE(member) LIKE '%allUsers%'
                        OR JSON_VALUE(member) LIKE '%allAuthenticatedUsers%'
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_public_buckets_accesses
{% endmacro %}