-- Deploy trapparty:role_postgraphile to pg

BEGIN;

\set role_trapparty_postgraphile_password `cat /run/secrets/postgres_role_trapparty-postgraphile_password`
CREATE ROLE trapparty_postgraphile LOGIN PASSWORD :'role_trapparty_postgraphile_password';

COMMIT;
