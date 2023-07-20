
import os
import sys
import datetime
import argparse
import sections
import snowflake.connector

from dotenv import load_dotenv

load_dotenv()  # take environment variables from .env.

def run_policy(args):
    print("Running doundational Security Policy")
    conn = snowflake.connector.connect(
        user=os.environ.get("SNOW_USER"),
        password=os.environ.get("SNOW_PASSWORD"),
        account=os.environ.get("SNOW_ACCOUNT"),
        warehouse=os.environ.get("SNOW_WAREHOUSE"),
        database=os.environ.get("SNOW_DATABASE"),
        schema=os.environ.get("SNOW_SCHEMA"),
    )
    execution_time = datetime.datetime.now()
    # sections.execute_account(conn, execution_time)
    # sections.execute_acm(conn, execution_time)
    # sections.execute_apigateway(conn, execution_time)
    # sections.execute_awsconfig(conn, execution_time)
    # sections.execute_cloudfront(conn, execution_time)
    # sections.execute_cloudtrail(conn, execution_time)
    # sections.execute_codebuild(conn, execution_time)
    sections.execute_dynamodb(conn, execution_time)
    print("Finished running doundational security policy")

def create_views(args):
    pass

def main():
    parser = argparse.ArgumentParser(
                    prog='aws-foundational-snowflake',
                    description='Foundational security policy with Snowflake SQL')
    subparsers = parser.add_subparsers(help='sub-command help', required=True)
    parser_run_policy = subparsers.add_parser('run-policy', help='run policy')
    parser_run_policy.set_defaults(func=run_policy)
    parser_create_views = subparsers.add_parser('create-view', help='create all required views')
    parser_create_views.set_defaults(func=run_policy)
    args = parser.parse_args(sys.argv[1:])
    args.func(args)


if __name__ == '__main__':
    main()
