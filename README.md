# StudentList

Web application to create student directories.

## Installing

There is a bug with `node_sass`, needed to install `phoenix` from the main repo: <https://github.com/phoenixframework/phoenix/tree/master/installer>.

`mix ecto.migrate` did not work after running ` mix phx.gen.auth Accounts User users`. The create extension citext was failing because the user did not have `SUPERUSER` permissions.

To fix, manually connect to the db as a superuser and create the extension:
```
% psql -U jwarwick student_list_dev
student_list_dev=# CREATE EXTENSION citext;
```

## LICENSE

Software released under the [MIT License](LICENSE.txt).

Moose favicon from <https://openclipart.org/detail/169960/cartoon-moose-by-studiofibonacci>, released under [Creative Commons Zero 1.0 Public Domain License](https://creativecommons.org/publicdomain/zero/1.0/)
