import os


# read in text file from /Users/benbernays/Documents/GitHub/policies-premium/to_migrate/k8s/queries_cis_v1_7_0/api_server_queries.sql
with open('/Users/benbernays/Documents/GitHub/policies-premium/to_migrate/k8s/queries_cis_v1_7_0/api_server_queries.sql', 'r') as file:
    data = file.read()
    # split on the following sring: `\echo`
    split = data.split('\\echo')
    for query in split:
        print(query)
        name = query.split('\n')[0]
        # create file with name of query and then write query to file
        with open(f'/Users/benbernays/Documents/GitHub/policies-premium/to_migrate/k8s/queries_cis_v1_7_0/api_server/{name}.sql', 'w') as file:
            file.write(query)
