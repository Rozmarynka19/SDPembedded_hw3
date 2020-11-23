#!/usr/bin/env bash

curl -H "LinuxClass: True" -H "UboxDate: $(date)" -X POST "https://wat11.azurewebsites.net/api/log" -d "" > token.txt