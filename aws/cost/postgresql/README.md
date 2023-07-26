# AWS Cost and Usage reports views with PostgreSQL

## Requirements

### CloudQuery Sync

Make sure you synced your AWS metadata with CloudQuery [AWS source plugin](https://www.cloudquery.io/docs/plugins/sources/overview), Cost and Usage data with the [file plugin](https://github.com/cloudquery/plugins-premium/tree/main/plugins/file), and [PostgreSQL destination](https://www.cloudquery.io/docs/plugins/destinations/postgresql/overview).

### Run the policy

- Install Python >= 3.9
- Run `pip install -r requirements.txt`
- Run `cp env.example` to `.env` and fill the PostgreSQL environment credentials
- Run `python main.py`

#### VirtualEnv

- Run `pip install virtualenv`
- Run `virtualenv venv`
- Run `source venv/bin/activate`
- Follow the steps above. This way you will have a virtual environment for dependencies. `deactivate` to exit the virtual environment.
- Alternatively, you can use the `pip` and `python` binaries from the virtual environment (inside `venv/bin/`) directly.
