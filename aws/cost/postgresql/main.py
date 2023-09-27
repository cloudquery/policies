
import os
import sys
import argparse
import cost
import psycopg
from psycopg import sql

from dotenv import load_dotenv

load_dotenv()  # take environment variables from .env.

def get_connection():
    conn = psycopg.connect(conninfo=os.environ.get("POSTGRESQL_CONNECTION_STRING"))
    return conn

def executeQuery(conn, query, table):
    conn.cursor().execute(sql.SQL(query).format(table=sql.Identifier(table)))

def create_views(args):
    print("Creating cost and usage views")
    conn = get_connection()
    executeQuery(conn, cost.RESOURCES_BY_COST, args.table)
    executeQuery(conn, cost.REGIONS_BY_COST, args.table)
    executeQuery(conn, cost.COST_OVER_TIME, args.table)
    executeQuery(conn, cost.GCP2_EBS_VOLUMES, args.table)
    executeQuery(conn, cost.UNUSED_ACM_CERTS, args.table)
    executeQuery(conn, cost.UNUSED_BACKUP_VAULTS, args.table)
    executeQuery(conn, cost.UNUSED_CLOUDFRONT_DISTRIBUTIONS, args.table)
    executeQuery(conn, cost.UNUSED_DIRECTCONNTECT_CONNECTIONS, args.table)
    executeQuery(conn, cost.UNUSED_DYNAMODB_TABLES, args.table)
    executeQuery(conn, cost.UNUSED_EC2_EBS_VOLUMES, args.table)
    executeQuery(conn, cost.UNUSED_EC2_EIPS, args.table)
    executeQuery(conn, cost.UNUSED_EC2_HOSTS, args.table)
    executeQuery(conn, cost.UNUSED_EC2_IMAGES, args.table)
    executeQuery(conn, cost.UNUSED_EC2_INTERNET_GATEWAYS, args.table)
    executeQuery(conn, cost.UNUSED_EC2_NETWORK_ACLS, args.table)
    executeQuery(conn, cost.UNUSED_EC2_TRANSIT_GATEWAYS, args.table)
    executeQuery(conn, cost.UNUSED_ECR_REPOSITORIES, args.table)
    executeQuery(conn, cost.UNUSED_EFS_FILESYSTEMS, args.table)
    executeQuery(conn, cost.UNUSED_LOAD_BALANCERS, args.table)
    executeQuery(conn, cost.UNUSED_LIGHTSAIL_CONTAINER_SERVICES, args.table)
    executeQuery(conn, cost.UNUSED_LIGHTSAIL_DISKS, args.table)
    executeQuery(conn, cost.UNUSED_LIGHTSAIL_DISTRIBUTIONS, args.table)
    executeQuery(conn, cost.UNUSED_LIGHTSAIL_LOAD_BALANCERS, args.table)
    executeQuery(conn, cost.UNUSED_LIGHTSAIL_STATIC_IPS, args.table)
    executeQuery(conn, cost.UNUSED_ROUTE53_HISTED_ZONES, args.table)
    executeQuery(conn, cost.UNUSED_SNS_TOPICS, args.table)
    conn.commit()

def main():
    parser = argparse.ArgumentParser(
                    prog='aws-cost-postgresql',
                    description='Views to analyze AWS cost and usage reports with PostgreSQL')
    subparsers = parser.add_subparsers(help='sub-command help', required=True)
    parser_create_view = subparsers.add_parser('create-views', help='creating cost and usage views')
    parser_create_view.set_defaults(func=create_views)
    parser_create_view.add_argument('--table', help='cost and usage report table name', required=True)
    if len(sys.argv[1:]) == 0:
        parser.print_help()
        sys.exit(1)
    args = parser.parse_args(sys.argv[1:])
    args.func(args)


if __name__ == '__main__':
    main()
