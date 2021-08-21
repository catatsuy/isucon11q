#!/bin/bash

# App: isucondition

set -x

echo "start deploy ${USER}"
GOOS=linux GOARCH=amd64 go build -o isucondition_linux
for server in isu01; do # isu02, isu03
  ssh -t $server "sudo systemctl stop isucondition.go.service"
  scp ./isucondition_linux $server:/home/isucon/webapp/go/isucondition
  rsync -vau ../sql/ $server:/home/isucon/webapp/sql/
  # rsync -vau ../public/img/ $server:/home/isucon/webapp/public/img/ # 画像アップロード時
  ssh -t $server "sudo systemctl start isucondition.go.service"
done

echo "finish deploy ${USER}"
