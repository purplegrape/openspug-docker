#!/usr/bin/env bash

set -x

if [ ! -d /data/spug ];then
    unzip -d /data /opt/spug.zip
fi

exec $@