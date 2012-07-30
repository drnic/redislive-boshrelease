#!/usr/bin/env roundup

describe "run RedisLive with postgresql to monitor Redis DBs"

set -u # report the usage of uninitialized variables
# set -x

[ "$(whoami)" != 'root' ] && ( echo ERROR: run as root user; exit 1 )

cd /vagrant/ # need to hardcode as roundup overrides $0
release_path=$(pwd)

rm -rf /tmp/before_all_run_already

before_all() {
  echo "|"
  echo "| Stopping any existing jobs"
  echo "|"
  sm bosh-solo stop

  echo "|"
  echo "| Deleting databases"
  echo "|"
  rm -rf /var/vcap/store

  # update deployment with example properties
  example=${release_path}/examples/redis_password.yml
  sm bosh-solo update ${example}

  # wait for postgres to setup DB & webapp to start
  sleep 5
  
  # show last 20 processes (for debugging if test fails)
  ps ax | tail -n 20
}

# before() is only hook into roundup
# TODO add before_all() to roundup
before() {
  if [ ! -f /tmp/before_all_run_already ]
  then
    before_all
    touch /tmp/before_all_run_already
  fi
}

it_runs_redis_live() {
  expected='redis-live.py'
  test $(ps ax | grep "${expected}" | grep -v 'grep' | wc -l) = 1
}

it_runs_redis_monitor() {
  expected='redis-monitor.py --duration 3000'
  test $(ps ax | grep "${expected}" | grep -v 'grep' | wc -l) = 1
}
