To update the pip packages:

``` bash
cd /path/to/release
mkdir -p blobs/python-pip-RedisLive
for package in tornado redis python-dateutil
do
  pip install -d blobs/python-pip-RedisLive ${package}
done
echo Package files to include in spec:
for file in $(ls -t blobs/python-pip-RedisLive/)
do
  echo "- python-pip-RedisLive/${file}"
done
```