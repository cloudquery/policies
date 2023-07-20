
import os
import sys
import datetime
import argparse
import sections
import snowflake.connector
import views

from dotenv import load_dotenv

load_dotenv()  # take environment variables from .env.

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
    print("Running foundational Security Policy")
    conn = get_connection()
    execution_time = datetime.datetime.now()
    # sections.execute_account(conn, execution_time)
    # sections.execute_acm(conn, execution_time)
    # sections.execute_apigateway(conn, execution_time)
    # sections.execute_awsconfig(conn, execution_time)
    # sections.execute_cloudfront(conn, execution_time)
    # sections.execute_cloudtrail(conn, execution_time)
    # sections.execute_codebuild(conn, execution_time)
    # sections.execute_dynamodb(conn, execution_time)
    # sections.execute_ec2(conn, execution_time)
    # sections.execute_iam(conn, execution_time)
    # sections.execute_lambda(conn, execution_time)
    # sections.execute_redshift(conn, execution_time)
    # sections.execute_s3(conn, execution_time)
    # sections.execute_sagemaker(conn, execution_time)
    # sections.execute_secretsmanager(conn, execution_time)
    # sections.execute_sns(conn, execution_time)
    # sections.execute_sqs(conn, execution_time)
    # sections.execute_ssm(conn, execution_time)
    # sections.execute_waf(conn, execution_time)
    # sections.execute_lambda(conn, execution_time)
    sections.execute_rds(conn, execution_time)
    
    print("Finished running foundational security policy")

def create_view(args):
    print("Creating policy results view")
    conn = get_connection()
    conn.cursor().execute(views.CREATE_AWS_POLICY_RESULTS)

def main():
    parser = argparse.ArgumentParser(
                    prog='aws-foundational-snowflake',
                    description='Foundational security policy with Snowflake SQL')
    subparsers = parser.add_subparsers(help='sub-command help', required=True)
    parser_run_policy = subparsers.add_parser('run-policy', help='run policy')
    parser_run_policy.set_defaults(func=run_policy)
    parser_create_view = subparsers.add_parser('create-view', help='create policy results view')
    parser_create_view.set_defaults(func=create_view)
    args = parser.parse_args(sys.argv[1:])
    args.func(args)


if __name__ == '__main__':
    main()
