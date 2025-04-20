#!/bin/bash
URL=https://radarr.crt.house/api/v3
TAG="sync"
TOKEN=
AUTH="X-Api-Key:${TOKEN}"

tagID=$(curl -s -H $AUTH $URL/tag | jq -r '.[] | select(.label=="${TAG}") .id')

for i in $(curl -s -H $AUTH $URL/tag/detail/$tagID | jq -r .movieIds[]); do
    actualPath=$(curl -s -H $AUTH $URL/movie/$i | jq -r .movieFile.path | sed s/mnt/volume1/)
    linkPath=$(echo "${actualPath}" | sed 's/movies/sync\/movies/')
    if [ ! -e "${linkPath}" ]; then
        mkdir -p $(dirname "${linkPath}")
        ln "${actualPath}" "${linkPath}"
    fi
done
