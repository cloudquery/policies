
import os
import sys
import datetime
import argparse
import sections
import snowflake.connector
import views

from dotenv import load_dotenv

load_dotenv()  # take environment variables from .env.
snowflake.connector.paramstyle='numeric'

def get_connection():
    conn = snowflake.connector.connect(
        user=os.environ.get("SNOW_USER"),
        password=os.environ.get("SNOW_PASSWORD"),
        account=os.environ.get("SNOW_ACCOUNT"),
        warehouse=os.environ.get("SNOW_WAREHOUSE"),
        database=os.environ.get("SNOW_DATABASE"),
        schema=os.environ.get("SNOW_SCHEMA"),
        region=os.environ.get("SNOW_REGION"),
    )
    return conn

def run_policy(args):
    print("Running foundational security policy")
    conn = get_connection()
    execution_time = datetime.datetime.now()
    sections.execute_account(conn, execution_time)
    sections.execute_acm(conn, execution_time)
    sections.execute_apigateway(conn, execution_time)
    sections.execute_awsconfig(conn, execution_time)
    sections.execute_cloudfront(conn, execution_time)
    sections.execute_cloudtrail(conn, execution_time)
    sections.execute_codebuild(conn, execution_time)
    sections.execute_dynamodb(conn, execution_time)
    sections.execute_ec2(conn, execution_time)
    sections.execute_ecr(conn, execution_time)
    sections.execute_ecs(conn, execution_time)
    sections.execute_efs(conn, execution_time)
    sections.execute_eks(conn, execution_time)
    sections.execute_elastic_beanstalk(conn, execution_time)
    sections.execute_elasticsearch(conn, execution_time)
    sections.execute_emr(conn, execution_time)
    sections.execute_elb(conn, execution_time)
    sections.execute_elbv2(conn, execution_time)
    sections.execute_emr(conn, execution_time)
    sections.execute_iam(conn, execution_time)
    sections.execute_lambda(conn, execution_time)
    sections.execute_redshift(conn, execution_time)
    sections.execute_guardduty(conn, execution_time)
    sections.execute_s3(conn, execution_time)
    sections.execute_sagemaker(conn, execution_time)
    sections.execute_secretsmanager(conn, execution_time)
    sections.execute_sns(conn, execution_time)
    sections.execute_sqs(conn, execution_time)
    sections.execute_ssm(conn, execution_time)
    sections.execute_waf(conn, execution_time)
    sections.execute_rds(conn, execution_time)
    
    print("Finished running foundational security policy")

def create_view(args):
    print("Creating policy results view")
    conn = get_connection()
    conn.cursor().execute(views.CREATE_AWS_POLICY_RESULTS)
    conn.cursor().execute(views.API_GATEWAY_METHOD_SETTINGS)
    conn.cursor().execute(views.SECURITY_GROUP_INGRESS_RULES)

def main():
    parser = argparse.ArgumentParser(
                    prog='aws-foundational-snowflake',
                    description='Foundational security policy with Snowflake SQL')
    subparsers = parser.add_subparsers(help='sub-command help', required=True)
    parser_run_policy = subparsers.add_parser('run-policy', help='run policy')
    parser_run_policy.set_defaults(func=run_policy)
    parser_create_view = subparsers.add_parser('create-view', help='create policy results view')
    parser_create_view.set_defaults(func=create_view)
    if len(sys.argv[1:]) == 0:
        parser.print_help()
        sys.exit(1)
    args = parser.parse_args(sys.argv[1:])
    args.func(args)


if __name__ == '__main__':
    main()
