import os
from queries import (
    apigateway,
    appsync,
    athena,
    autoscaling,
    awsconfig,
    cloudformation,
    cloudfront,
    cloudtrail,
    codebuild,
    dms,
    documentdb,
    dynamodb,
    ec2,
    ecr,
    ecs,
    efs,
    elasticache,
    eks,
    elastic_beanstalk,
    elasticsearch,
    elb,
    elbv2,
    emr,
    guardduty,
    iam,
    kinesis,
    kms,
    neptune,
    networkfirewall,
    awslambda,
    redshift,
    s3,
    sagemaker,
    secretmanager,
    sns,
    sqs,
    ssm,
    stepfunctions,
    waf,
    rds,
)

queries = [apigateway,
           appsync,
           athena,
           autoscaling,
           awsconfig,
           cloudformation,
           cloudfront,
           cloudtrail,
           codebuild,
           dms,
           documentdb,
           dynamodb,
           ec2,
           ecr,
           ecs,
           efs,
           elasticache,
           eks,
           elastic_beanstalk,
           elasticsearch,
           elb,
           elbv2,
           emr,
           guardduty,
           iam,
           kinesis,
           kms,
           neptune,
           networkfirewall,
           awslambda,
           redshift,
           s3,
           sagemaker,
           secretmanager,
           sns,
           sqs,
           ssm,
           stepfunctions,
           waf,
           rds]


for query in queries:
    svc = query.__name__.split('.')[-1]
    # create folder if not exists
    # write to file
    for key in dir(query):
        if not key.startswith('_'):
            # write contents to file
            directory = f'/Users/benbernays/Documents/GitHub/policies-premium/aws/foundational_security/snowflake/dbt/macros/{svc}'
            if not os.path.exists(directory):
                os.makedirs(directory)
            with open(f'{directory}/{key.lower()}.sql', 'w+') as f:
                check = getattr(query, key)
                check = check.replace(
                    ":2 as framework", ''''{{framework}}' As framework''')
                check = check.replace(
                    ":3 as check_id", ''''{{check_id}}' As check_id''')
                f.write('''{% macro ''' + key.lower() +
                        '''(framework, check_id) %}''')
                f.write(check)
                f.write('''{% endmacro %}''')

            # print(getattr(query, key))
