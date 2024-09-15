# Basic Python Project Setup

## Project Init

### Python `virtualenv`

Create:

```bash
$ python3 -m venv .venv
```

Activate:

```bash
$ source ./venv/bin/activate
```

### Python Dependencies

Install/update:

```bash
$ pip install -U pip poetry
```


## Docker

### Environment Variables

Environment variables are set in `compose/env.local` files. See the `env.local.example` for variable names & description.

### Initial Migrations

If you're running app for the first time, you'll need to manually apply the migrations (migrations won't run automatically in development environment):

```bash
# ./bin/django_migrate.sh
```

### Run Services

```bash
# ./bin/local_run.sh [optional service names]
```

## Default Credentials

Users and data sample are loaded from fixtures. You'll need to manually load fixtures:

```bash
# ./bin/django_exec.sh loaddata /fixtures/01-superuser

# ./bin/django_exec.sh loaddata /fixtures/02-valueset
```

Default username is `admin` & password is `admin`. You can use it to log in to admin panel at http://localhost:8000/admin/.
