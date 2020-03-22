CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE IF NOT EXISTS "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "branches" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar, "kind" integer, "address" varchar, "serial_num" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE sqlite_sequence(name,seq);
CREATE UNIQUE INDEX "index_branches_on_serial_num" ON "branches" ("serial_num");
CREATE INDEX "index_branches_on_name" ON "branches" ("name");
CREATE INDEX "index_branches_on_kind" ON "branches" ("kind");
CREATE TABLE IF NOT EXISTS "users" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "uuid" varchar DEFAULT '', "status" integer DEFAULT 0, "is_confirmed" boolean DEFAULT 0, "registration_date" date, "branch_id" integer, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE INDEX "index_users_on_branch_id" ON "users" ("branch_id");
CREATE UNIQUE INDEX "index_users_on_uuid" ON "users" ("uuid");
CREATE INDEX "index_users_on_status" ON "users" ("status");
CREATE TABLE IF NOT EXISTS "profiles" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "first_name" varchar, "middle_name" varchar, "last_name" varchar, "postal_code" varchar, "city" varchar, "address" varchar, "email" varchar, "birth_date" date, "is_confirmed" boolean, "user_id" integer, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_e424190865"
FOREIGN KEY ("user_id")
  REFERENCES "users" ("id")
 ON DELETE CASCADE);
CREATE INDEX "index_profiles_on_user_id" ON "profiles" ("user_id");
CREATE INDEX "index_profiles_on_email" ON "profiles" ("email");
CREATE INDEX "index_profiles_on_first_name" ON "profiles" ("first_name");
CREATE INDEX "index_profiles_on_last_name" ON "profiles" ("last_name");
CREATE TABLE IF NOT EXISTS "accounts" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "kind" integer, "status" integer DEFAULT 0, "lock_state" integer DEFAULT 0, "currency" varchar DEFAULT 'usd', "balance" bigint DEFAULT 0, "interest_rate" integer DEFAULT 0, "interest_period" integer DEFAULT 0, "user_id" integer, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_b1e30bebc8"
FOREIGN KEY ("user_id")
  REFERENCES "users" ("id")
 ON DELETE CASCADE);
CREATE INDEX "index_accounts_on_user_id" ON "accounts" ("user_id");
CREATE TABLE IF NOT EXISTS "transactions" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "type" varchar, "status" integer, "amount" bigint, "receiver_id" integer, "account_id" integer, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_01f020e267"
FOREIGN KEY ("account_id")
  REFERENCES "accounts" ("id")
 ON DELETE CASCADE);
CREATE INDEX "index_transactions_on_account_id" ON "transactions" ("account_id");
CREATE INDEX "index_transactions_on_receiver_id" ON "transactions" ("receiver_id");
CREATE TABLE IF NOT EXISTS "exchange_rates" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "currency_from" varchar, "currency_to" varchar, "rate" bigint, "added_at" datetime, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE INDEX "index_exchange_rates_on_added_at" ON "exchange_rates" ("added_at");
INSERT INTO "schema_migrations" (version) VALUES
('20200318143235'),
('20200318143740'),
('20200318143954'),
('20200318144133'),
('20200318144440'),
('20200319071508');


