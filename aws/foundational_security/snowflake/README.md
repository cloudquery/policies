# AWS Foundational Security Best Practices pack with Snowflake SQL

## Requirements

### CloudQuery Sync

Make sure you synced your AWS metadata with CloudQuery [AWS source plugin](https://www.cloudquery.io/docs/plugins/sources/overview) and [Snowflake destinatio](https://www.cloudquery.io/docs/plugins/destinations/snowflake/overview).

### Run the policy

- Install Python >= 3.9
- Run `pip install -r requirements.txt`
- Run `cp env.example` to `.env` and fill the snowflake environment credentials
- Run `python main.py`

#### VirtualEnv

- Run `pip install virtualenv`
- Run `virtualenv venv`
- Run `source venv/bin/activate`
- Follow the steps above. This way you will have a virtual environment for dependencies. `deactivate` to exit the virtual environment.
- Alternatively, you can use the `pip` and `python` binaries from the virtual environment (inside `venv/bin/`) directly.
