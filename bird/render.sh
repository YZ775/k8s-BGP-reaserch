#!/bin/bash

ADDRESS=$(kubectl get node --no-headers -o wide | awk '{print $6}')
echo ${ADDRESS}

cp bird.conf.template bird.conf

for i in ${ADDRESS}
do
    sed -i "0,/__NODE_IP__/ s/__NODE_IP__/$i/" bird.conf
done

