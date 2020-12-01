#!/bin/bash
set -e
/opt/consul/bin/run-consul --client --cluster-tag-name "${cluster_tag_name}"

