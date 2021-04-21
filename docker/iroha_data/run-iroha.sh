#!/usr/bin/env bash
set -e

# if first arg looks like a flag, assume we want to run irohad server
if [ "${1:0:1}" = '-' ]; then
  set -- irohad "$@"
fi

if [ "$1" = 'irohad' ]; then
  # change to script path
  cd "$(dirname "$0")"
  echo key=$KEY
  echo $PWD
	exec "$@" --genesis_block genesis.block --config config.docker --keypair_name $KEY
fi

exec "$@"
