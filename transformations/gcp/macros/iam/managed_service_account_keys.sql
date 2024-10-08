{% macro iam_managed_service_account_keys(framework, check_id) %}
  {{ return(adapter.dispatch('iam_managed_service_account_keys')(framework, check_id)) }}
{% endmacro %}

{% macro default__iam_managed_service_account_keys(framework, check_id) %}{% endmacro %}

{% macro postgres__iam_managed_service_account_keys(framework, check_id) %}
select distinct
        gisa.name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure that there are only GCP-managed service account keys for each service account (Automated)'
        as title,
        gisa.project_id as project_id,
        case
            when
                gisa.email like '%iam.gserviceaccount.com'
                and gisak."key_type" = 'USER_MANAGED'
            then 'fail'
            else 'pass'
        end as status
    from gcp_iam_service_accounts gisa
    join
        gcp_iam_service_account_keys gisak
        on gisa.project_id = gisak.project_id
        and gisa.unique_id = gisak.service_account_unique_id
{% endmacro %}

{% macro snowflake__iam_managed_service_account_keys(framework, check_id) %}
select distinct
        gisa.name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure that there are only GCP-managed service account keys for each service account (Automated)'
        as title,
        gisa.project_id as project_id,
        case
            when
                gisa.email like '%iam.gserviceaccount.com'
                and gisak.key_type = 'USER_MANAGED'
            then 'fail'
            else 'pass'
        end as status
    from gcp_iam_service_accounts gisa
    join
        gcp_iam_service_account_keys gisak
        on gisa.project_id = gisak.project_id
        and gisa.unique_id = gisak.service_account_unique_id
{% endmacro %}

{% macro bigquery__iam_managed_service_account_keys(framework, check_id) %}
select distinct
        gisa.name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure that there are only GCP-managed service account keys for each service account (Automated)'
        as title,
        gisa.project_id as project_id,
        case
            when
                gisa.email like '%iam.gserviceaccount.com'
                and gisak.key_type = 'USER_MANAGED'
            then 'fail'
            else 'pass'
        end as status
    from {{ full_table_name("gcp_iam_service_accounts") }} gisa
    join
        {{ full_table_name("gcp_iam_service_account_keys") }} gisak
        on gisa.project_id = gisak.project_id
        and gisa.unique_id = gisak.service_account_unique_id
{% endmacro %}