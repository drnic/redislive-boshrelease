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

```
mkdir -p ~/Sites/boshdeployments/
cd ~/Sites/boshdeployments/
curl https://raw.github.com/gist/330a09327fedf4d4b149/a3a0cc8843fd8427a61b20985a8ca35f96ac86d4/manifest.yml > redislive.yml
```

Now create an IP address in AWS us-east using fog or the AWS console. Say, `1.2.3.3`.

Now replace the example IP `23.23.216.183` with your `1.2.3.4`:

``` yaml
...
- name: redislive
  template: redislive
  instances: 1
  resource_pool: common
  networks:
  - name: default
    default:
    - dns
    - gateway
  - name: vip_network
    static_ips:
    - 1.2.3.4
...
```

Modify the `properties` section to specify the redis databases you want to monitor.

Deploy!

```
bosh deployment redislive.yml
bosh deploy
```

If you are asked for a BOSH user/password, please see Dr Nic for one.

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

### Development with Vagrant

This project includes development support within Vagrant

```
$ vagrant up
[default] Booting VM...
[default] Waiting for VM to boot. This can take a few minutes.
[default] VM booted and ready for use!
[default] Mounting shared folders...
[default] -- bosh-src: /bosh
[default] -- v-root: /vagrant

$ vagrant ssh
```

Inside the VM:

```
[as vagrant user]
sudo su -

[as root]
cd /vagrant
rvm 1.9.3 --default
sm bosh-solo update examples/redis_password.yml
sm bosh-solo tail_logs -f
```

### Testing new development releases

Whenever you make changes to your BOSH release, including updating the RedisLive source code (at `src/redislive`), then it is a simple process to create a new development release and deploy it into your vagrant VM:

```
[outside vagrant]
bosh create release --force

[inside vagrant as root user]
cd /vagrant
sm bosh-solo update examples/redis_password.yml
sudo sm bosh-solo tail_logs -f
```

All logs will be sent to the terminal so you can watch for any errors as quickly as possible.

### Finalizing and uploading a release

If you create a final release `bosh create release --final`, you must immediately create a new development release. Yeah, this is a bug I guess.

```
[outside vagrant]
bosh create release --final
bosh upload release

bosh create release

[inside vagrant as root user]
sm bosh-solo update examples/redis_password.yml
```


