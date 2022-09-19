#!/bin/bash
timeout 600 bash -c 'while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' localhost:9000/api/v3/root/config/)" != "200" ]]; do sleep 5; done' || false
