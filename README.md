# StudentList

Web application to create student directories.

## Local Dev Installation

```
% mix ecto.create
% mix ecto.migrate
% mix phx.server
```

## Environment Variables
Needed for Production builds
`DATABASE_URL`, `SECRET_KEY_BASE`, `MAILGUN_API_KEY`, `MAILGUN_DOMAIN`, `HOST`

## Gigalixir Deployment
This project was built to run on [Gigalixir](https://www.gigalixir.com/). The [Getting Started Guide](https://gigalixir.readthedocs.io/en/latest/getting-started-guide.html) is a good starting point for account creation, etc.

To deploy there, follow these steps:
```
% gigalixir create
% gigalixir pg:create --free     # should create a production db for a real project
% gigalixir config:set HOST="my-directory.org"
% gigalixir config:set MAILGUN_DOMAIN="my-directory.org"
% gigalixir config:set MAILGUN_API_KEY="XXXXXXXXXXXXXXXXXX"
% git push gigalixir
% gigalixir run mix ecto.create
% gigalixir run mix ecto.migrate
# Gigalixir provides the DATABASE_URL and SECRET_KEY_BASE environment variables by default

% gigalixir domains:add my-directory.org
% gigalixir domains:add www.my-directory.org
```

To see the status of your app:
```
% gigalixir ps
{
  "cloud": "gcp",
  "pods": [
    {
      "lastState": {},
      "name": "navy-XXXXXXXX-borer-XXXXXXXXXX-XXXXXX",
      "sha": "XXXXXXXXXXXX",
      "status": "Healthy",
      "version": "11"
    }
  ],
  "region": "v2018-us-central1",
  "replicas_desired": 1,
  "replicas_running": 1,
  "size": 0.3,
  "stack": "gigalixir-20",
  "unique_name": "navy-XXXXXXXX-borer"
}
```

To see system logs:
```
% gigalixir logs
```

## Site Account Creation

When the server is started, if no users are present in the database, the `Registration` page will be available at `/users/register`. This account will be an admin account and can finish the server setup.

At setup time, under `Site Configuration`, create a `support_email` key to be displayed in the main page header. Set a value that is forwarded by your email service provider.

## Testing
Several tools are part of the `dev` build which validate the code:
```
% mix test
% mix credo
% mix sobelow
% mix dialyzer
```

## Issues
Ran into a few problems during initial project creation:
  - There is a bug with `node_sass`, needed to install `phoenix` from the main repo: <https://github.com/phoenixframework/phoenix/tree/master/installer>.
  - `mix ecto.migrate` did not work after running ` mix phx.gen.auth Accounts User users`. The create extension citext was failing because the user did not have `SUPERUSER` permissions.  To fix, manually connect to the db as a superuser and create the extension:
```
% psql -U jwarwick student_list_dev
student_list_dev=# CREATE EXTENSION citext;
```

## LICENSE

Software released under the [MIT License](LICENSE.txt).

Moose favicon from <https://openclipart.org/detail/169960/cartoon-moose-by-studiofibonacci>, released under [Creative Commons Zero 1.0 Public Domain License](https://creativecommons.org/publicdomain/zero/1.0/)
