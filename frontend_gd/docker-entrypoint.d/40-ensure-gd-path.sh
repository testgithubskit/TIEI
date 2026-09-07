#!/bin/sh
# Vite base + nginx location are /tiei_dynamic_gd/. Older images copied dist to tiei_dynamic.
set -e
html=/usr/share/nginx/html
if [ ! -f "$html/tiei_dynamic_gd/index.html" ] && [ -f "$html/tiei_dynamic/index.html" ]; then
  ln -sfn tiei_dynamic "$html/tiei_dynamic_gd"
fi
