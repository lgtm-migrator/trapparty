#!/bin/sh
set -e

sqitch -C /srv/sqitch/ deploy "$(cat /run/secrets/trapparty_sqitch-target)"

exec yarn run "$@"