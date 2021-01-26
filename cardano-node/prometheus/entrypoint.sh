#!/bin/bash
set -e

cat /etc/prometheus/prometheus.yml

exec prometheus --config.file=/etc/prometheus/prometheus.yml
