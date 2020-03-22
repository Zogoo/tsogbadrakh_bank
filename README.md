# VisableBank app

[![Build Status](https://travis-ci.org/Zogoo/tsogbadrakh_bank.png)](https://travis-ci.org/Zogoo/tsogbadrakh_bank.png)

## Main requirements for this app.

1. You need to transfer funds between accounts. Think about what classes and DB tables you need for this task. Implement the models and a service class that wires them together.
2. Build a REST endpoint to show the balance of the account and 10 latest transactions.
3. Build a REST endpoint to transfer money between accounts. Your REST action should use the service class you built in task 1.

Framework and language dependencies:

- Rails version: 6.0
- Ruby version: 2.5.3
- PostgreSql: 9.6
- SQLite for development environment only

## How to configure application

For development environment you don't need to do anything.

For production environment you need to setup PostgreSQL connection credential in `.env.production` file.

Here is the example:

```bash
RDS_HOST=localhost
RDS_DATABASE=visable_development
RDS_USER=visable_user
RDS_PASSWORD=<STRONG PASSWORD>
```

## How to run

```bash
  gem install bundler
  bundle install
```

- Make sure all tests are passes on your environment

```bash
  bundle exec rspec
```

- Start rails

```bash
  bundle exec rails s
```

## TODO

1. Add more edge case tests
2. Create Docker compose file for local environment
3. Create API document with Swagger
