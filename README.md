# redislive-boshrelease - BOSH Release

A BOSH release for [RedisLive](https://github.com/kumarnitin/RedisLive/).

[![redislive](https://img.skitch.com/20120728-8yk1qsyrciq8qdn6abje95iwy.png)](https://github.com/kumarnitin/RedisLive/)

Specify one or more Redis instances to monitor and visualize via the BOSH deployment manifest for your deployment, then re-deploy to update RedisLive's configuration.

For example, to monitor `23.23.218.35` and `23.23.214.254` then add the following to your manifest before you deploy/redeploy. Note that one example shows how to specify a password, if required by the target redis.

``` yaml
properties:
  description: "RedisLive with postgresql to monitor Redis DBs"
  webapp:
    package: RedisLive
  redislive:
    targets:
      - server: 23.23.218.35
        port: 6379
        password: password
      - server: 23.23.214.254
        port: 6379
```

A complete example BOSH deployment manifest is [available](https://gist.github.com/330a09327fedf4d4b149).

## Deployment - End to End


## Development

To develop this BOSH release, follow the steps below to fetch the source, the RedisLive source and all the package blobs used to build python, redis, etc.

```
git clone git@github.com:engineyard/redislive-boshrelease.git
cd redislive-boshrelease
git submodule update --init
bosh create release --force
```

When you want to test a release, upload it and deploy it.

```
bosh upload release
bosh deployment path/to/deployments/redislive-dev.yml
```


