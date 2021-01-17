# Rumbl

This is my implementation of the Rumbl application described in the book Programming Phoenix.

## Project Structure

The application is structured as an umbrella project:

* The `info_sys` module includes business logic related to external integrations (e.g., WolframAlpha);
* The `rumbl` module includes all business logic;
* The `rumbl_dev` module includes all phoenix/web related code.

## How to run

Rumbl is a standard Phoenix project, it can be run with:

```
mix phx.server
```

The application needs a running PostgreSQL instance. Only `dev` env has been configures, see `config/dev.exs` for the configuration values.

The application uses the WolframAlpha APIs, so you will need a WolframAlpha application key. Ensure it is available in your session:

```
export WOLFRAM_APP_ID=<your API token>
```

## Run tests

Test can be run with `mix test`.


