
import os
import sys
import argparse
import cost
import psycopg

from dotenv import load_dotenv

load_dotenv()  # take environment variables from .env.

def get_connection():
    conn = psycopg.connect(conninfo=os.environ.get("POSTGRESQL_CONNECTION_STRING"))
    return conn


def create_views(args):
    print("Creating cost and usage views")
    conn = get_connection()
    conn.cursor().execute(cost.REGIONS_BY_COST)
    conn.cursor().execute(cost.RESOURCES_BY_COST)
    conn.commit()

def main():
    parser = argparse.ArgumentParser(
                    prog='aws-cost-postgresql',
                    description='Views to analyze AWS cost and usage reports with PostgreSQL')
    subparsers = parser.add_subparsers(help='sub-command help', required=True)
    parser_create_view = subparsers.add_parser('create-views', help='creating cost and usage views')
    parser_create_view.set_defaults(func=create_views)
    if len(sys.argv[1:]) == 0:
        parser.print_help()
        sys.exit(1)
    args = parser.parse_args(sys.argv[1:])
    args.func(args)


if __name__ == '__main__':
    main()
