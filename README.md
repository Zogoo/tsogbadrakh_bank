# VisableBank app

[![Build Status](https://travis-ci.com/Zogoo/tsogbadrakh_bank.svg?token=zzoN1RmBn4p1Bc2sPFKC&branch=master)](https://travis-ci.com/Zogoo/tsogbadrakh_bank)

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
  bundle exec rails db:create
  bundle exec rails db:migrate
  bundle exec rails s
```

## Development

You can create some test data on your local environment with following command

```bash
  bundle exec rails db:create
  bundle exec rails db:migrate
  bundle exec rails db:seed
  bundle exec rails s
```

Then you test with `curl` as like following examples:

Last 10 transaction list

```
curl localhost:3000/transactions
```

Or specify limit with 1

```
curl localhost:3000/transactions?limit_number=1
```

Do some transfer with `curl`

```
 curl -X POST -H "Content-Type: application/json" -d '{"account_from":"2", "account_to":"4", "transfer_amount": "100"}' localhost:3000/transactions/transfer
```

## TODO

1. Add more edge case tests
2. Create Docker compose file for local environment
3. Create API document with Swagger
