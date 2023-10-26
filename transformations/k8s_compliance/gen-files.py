import os


def queryName(name):
    return (
        f'({{{{ {name}(\'Kubernetes CIS v1.7.0\',\'{name}\') }}}})\n'
        f'        union'
    )


source = "./to_migrate/k8s/queries_cis_v1_7_0"
dest = "./transformations/k8s_compliance/macros"

filesToTransform = [
    ("api_server_queries.sql", "api_server"),
    ("controller_manager_1_3_queries.sql", "controller_manager"),



    ("etcd_queries.sql", "etcd"),
    ("general_policies_5_7_queries.sql", "general_policies"),
    ("logging_queries.sql", "logging"),
    ("network_policies_and_cni_5_3_queries.sql", "network_policies_and_cni"),
    ("pod_security_standards_5_2_queries.sql", "pod_security_standards"),
    ("rbac_and_service_accounts_queries.sql", "rbac_and_service_accounts"),
    ("scheduler_queries.sql", "scheduler"),
    ("secrets_managment_5_4_queries.sql", "secrets_management"),
]


def genTransforms(sourceName, destName):
    with open(source+'/'+sourceName, 'r') as file:
        data = file.read()
        # split on the following sring: `\echo`
        split = data.split('\\echo')
        for query in split:
            query = query.lstrip()
            # print(query)
            split_query = query.split('\n', 1)
            if len(split_query) == 1:
                continue
            name = split_query[0]
            query = split_query[1]
            name = name.replace('"', '')
            name = name.replace('.', '_')
            # strip leading white space from name
            name = name.lstrip()
            if len(name) == 0 or len(query) == 0:
                continue
            query = query.replace('''INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                    resource_name, status)''', '')

            query = query.split('-- query')[0]
            # check if destination exists and if not create it
            if not os.path.exists(f'{dest}/{destName}'):
                os.makedirs(f'{dest}/{destName}')
            # create file with name of query and then write query to file

            with open(f'{dest}/{destName}/{name}.sql', 'w') as file:
                file.write('{% macro '+name+'(framework, check_id) %}')
                for line in query.split('\n'):
                    if 'INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace' in line:
                        continue
                    if ' resource_name, status)' in line:
                        continue
                    elif 'AS execution_time' in line:
                        continue
                    elif 'AS framework' in line:
                        file.write("        \'{{framework}}\' As framework,\n")
                    elif 'AS check_id' in line:
                        file.write("        \'{{check_id}}\'  As check_id,\n")
                    else:

                        file.write(line.removesuffix(';')+'\n')
                file.write('{% endmacro %}')
                print(queryName(name))


for tup in filesToTransform:
    genTransforms(tup[0], tup[1])
