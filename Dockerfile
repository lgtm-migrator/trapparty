#############
# Serve Nuxt in development mode.

# Should be the specific version of node:slim.
FROM node:16.18.1-slim@sha256:e41a70d089deb43717a834c5c966842dab760e56257bfe391f3f161ce5b28c52 AS development

# Update and install dependencies.
# - `git` is required by the `yarn` command
# - `sqitch` is required by the entrypoint
# - `wget` is required by the healthcheck
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        git \
    && apt-get install --no-install-recommends -y \
        libdbd-pg-perl \
        postgresql-client \
        sqitch \
    && apt-get install --no-install-recommends -y \
        wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /srv/app/

COPY ./nuxt/package.json ./nuxt/yarn.lock ./

RUN yarn install

COPY ./nuxt/ ./

COPY ./sqitch/ /srv/sqitch/
COPY ./docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["dev", "--hostname", "0.0.0.0"]
HEALTHCHECK --interval=10s CMD wget -O /dev/null http://localhost:3000/api/healthcheck || exit 1


########################
# Build Nuxt.

# Should be the specific version of node:slim.
FROM node:16.18.1-slim@sha256:e41a70d089deb43717a834c5c966842dab760e56257bfe391f3f161ce5b28c52 AS build

ARG NUXT_ENV_STACK_DOMAIN=jonas-thelemann.de
ENV NUXT_ENV_STACK_DOMAIN=${NUXT_ENV_STACK_DOMAIN}
ENV NODE_ENV=production

# Update and install dependencies.
# - `git` is required by the `yarn` command
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /srv/app/

COPY --from=development /srv/app/ ./

RUN yarn run nuxi prepare \
    && yarn run lint \
    && yarn run build

# Discard devDependencies.
RUN yarn install


#######################
# Provide a web server.
# Requires node (cannot be static) as the server acts as backend too.

# Should be the specific version of node:slim.
FROM node:16.18.1-slim@sha256:e41a70d089deb43717a834c5c966842dab760e56257bfe391f3f161ce5b28c52 AS production

ENV NODE_ENV=production

# Update and install dependencies.
# - `sqitch` is required by the entrypoint
# - `wget` is required by the healthcheck
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        libdbd-pg-perl \
        postgresql-client \
        sqitch \
    && apt-get install --no-install-recommends -y \
        wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /srv/app/

COPY --from=build /srv/app/ ./

COPY ./sqitch/ /srv/sqitch/
COPY ./docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["start"]
HEALTHCHECK --interval=10s CMD wget -O /dev/null http://localhost:3000/api/healthcheck || exit 1