#!/bin/bash
set -e
/opt/consul/bin/run-consul --server --cluster-tag-name "${cluster_tag_name}"