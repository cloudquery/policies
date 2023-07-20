# AWS Foundational Security Best Practices pack with Snowflake SQL

## Requirements

### CloudQuery Sync

Make sure you synced your AWS metadata with CloudQuery [AWS source plugin](https://www.cloudquery.io/docs/plugins/sources/overview) and [Snowflake destinatio](https://www.cloudquery.io/docs/plugins/destinations/snowflake/overview).

### Run the policy

- Install Python > 3.8
- Run `pip install -r requirements.txt`
- Run `cp env.example` to `.env` and fill the snowflake environment credentials
- Run `python main.py`
