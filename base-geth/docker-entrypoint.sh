#!/usr/bin/env bash
set -e

if [[ ! -f /var/lib/base-geth/ee-secret/jwtsecret ]]; then
  echo "Generating JWT secret"
  __secret1=$(head -c 8 /dev/urandom | od -A n -t u8 | tr -d '[:space:]' | sha256sum | head -c 32)
  __secret2=$(head -c 8 /dev/urandom | od -A n -t u8 | tr -d '[:space:]' | sha256sum | head -c 32)
  echo -n "${__secret1}""${__secret2}" > /var/lib/base-geth/ee-secret/jwtsecret
fi

if [[ -O "/var/lib/base-geth/ee-secret/jwtsecret" ]]; then
  chmod 666 /var/lib/base-geth/ee-secret/jwtsecret
fi

# Set verbosity
shopt -s nocasematch
case ${LOG_LEVEL} in
  error)
    __verbosity="--verbosity 1"
    ;;
  warn)
    __verbosity="--verbosity 2"
    ;;
  info)
    __verbosity="--verbosity 3"
    ;;
  debug)
    __verbosity="--verbosity 4"
    ;;
  trace)
    __verbosity="--verbosity 5"
    ;;
  *)
    echo "LOG_LEVEL ${LOG_LEVEL} not recognized"
    __verbosity=""
    ;;
esac

__chainid=$(jq -r .config.chainId < /tmp/network/genesis-l2.json)

# Prep datadir
if [ ! -d "/var/lib/base-geth/geth/" ]; then
  echo "Chaindata missing, running init"
  geth ${__verbosity} init --datadir /var/lib/base-geth /tmp/network/genesis-l2.json 
fi

if [ -f /var/lib/base-geth/prune-marker ]; then
  rm -f /var/lib/base-geth/prune-marker
  exec "$@" --networkid="${__chainid}" snapshot prune-state
else
# Word splitting is desired for the command line parameters
# shellcheck disable=SC2086
  exec "$@" --networkid="${__chainid}" ${__verbosity} ${EL_EXTRAS}
fi
