#!/bin/bash
set -e

cd ..

mkdir -p prod_contextual-cueing-chun-jiang/webroot
cp -r src/* prod_contextual-cueing-chun-jiang/webroot
cp -r jspsych prod_contextual-cueing-chun-jiang/webroot

cd prod_contextual-cueing-chun-jiang
docker-compose build --no-cache
docker-compose up -d
chown 33:33 -R data
