#!/bin/bash

echo 'Starting Cron'
service cron start

echo 'Starting Influx'
influxd
