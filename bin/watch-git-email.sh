#!/usr/bin/env bash

set -eu

. $(dirname $0)/../lib/bash/functions
. $(dirname $0)/../lib/bash/logger

: ${INTERVAL:=1} #監視間隔, 秒で指定

_wge.get_stamp() {
  ls -l --full-time $1 | awk '{print $1 $6 $7 $8 $9}' | openssl sha
}

_wge.run() {
  local target_directory=$1
  local expect_email=$2
  logger.debug "Find in $target_directory"
  while read; do
    logger.debug "Change directory: $REPLY"
    cd $(dirname $REPLY)
    local actual_email=$(git config user.email)
    if [ "$expect_email" = "$actual_email" ]; then
      continue
    fi
    logger.debug "Change git user emal in: $REPLY"
    git config user.email $expect_email
  done <<EOS
$(find $target_directory -type d -name ".git")
EOS
}

_wge.watch() {
  local target_directory=$1
  local last=$(_wge.get_stamp $target_directory)
  while true; do
    sleep $INTERVAL
    local current=$(_wge.get_stamp $target_directory)
    logger.debug "Stamp: $current"
    if [ "$last" = "$current" ]; then
        continue
    fi
    _wge.run $*
    last=$current
  done
}

if [ $# -ne 2 ]; then
  logger.error "not enough arguments"
  exit 1
fi

TARGET_DIRECTORY=$1
EXPECT_EMAIL=$2

_wge.watch $TARGET_DIRECTORY $EXPECT_EMAIL
