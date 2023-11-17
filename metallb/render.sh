#!/bin/bash
yq -i ".spec.peerAddress = $(docker inspect bird | jq  .[0].NetworkSettings.Networks.kind.IPAddress)" peer.yaml
