# Deprecation

This project has been sunset. Please use [Optimism Docker](https://github.com/CryptoManufaktur-io/optimism-docker) instead.

# Overview

docker compose for Coinbase Base L2.

Copy `default.env` to `.env`, adjust values for the right network.

Meant to be used with https://github.com/CryptoManufaktur-io/base-docker-environment for traefik and Prometheus remote write;
use `ext-network.yml` in that case

If you want the base-geth RPC ports exposed locally, use `base-shared.yml` in `COMPOSE_FILE` inside `.env`

The `./ethd` script can be used as a quick-start:

`./ethd install` brings in docker-ce, if you don't have a Docker install already.

`cp default.env .env`

Adjust variables as needed, particularly `NETWORK`, `BASENODE_P2P_BOOTNODES` and `L1_RPC`

`./ethd up`

To update the software, run `./ethd update` and then `./ethd up`

This is base-docker v1.1.0
