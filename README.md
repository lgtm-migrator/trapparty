[![build status](https://github.com/dargmuesli/trapparty/workflows/CI/badge.svg)](https://github.com/dargmuesli/trapparty/actions?query=workflow%3ACI "build status")
[![Language grade: JavaScript](https://img.shields.io/lgtm/grade/javascript/g/dargmuesli/trapparty.svg?logo=lgtm&logoWidth=18)](https://lgtm.com/projects/g/dargmuesli/trapparty/context:javascript)

# TrapParty

TrapParty's online version: [trapparty.jonas-thelemann.de](https://trapparty.jonas-thelemann.de/).

<!-- ![Welcome](images/welcome.jpg "TrapParty") -->

## Table of Contents
1. **[Development](#development)**
1. **[Technology](#technology)**

## Development

This project is deployed within the [jonas-thelemann_stack](https://github.com/dargmuesli/jonas-thelemann_stack/) in accordance to the [DargStack template](https://github.com/dargmuesli/dargstack_template/) to make deployment a breeze.


### Sqitch

The database management tool *Sqitch* needs special configuration.

- run `mkdir -p /mnt/dev/postgresql/` to create the database's socket mount point, which Sqitch uses to connect to the database
- run `cd sqitch` from this project's root directory
- run `cp SQITCH_TARGET.env.template SQITCH_TARGET.env` and fill in the correct target
- run `./sqitch` with appropriate parameters

  (optionally, add an `alias sqitch="./sqitch"` to your shell, so that you can run `sqitch` like a binary without the preceding location indicator)


## Technology

<img src="https://nuxtjs.org/design-kit/colored-text.svg" alt="Nuxt.js" width="1000"/>
<img src="https://www.graphile.org/static/postgres_postgraphile_graphql-4b238552d875fe06196ba3bda74c6d2b.png" alt="PostGraphile" width="1000"/>
<img src="https://sqitch.org/img/sqitch-logo.svg" alt="Sqitch" width="1000"/>
