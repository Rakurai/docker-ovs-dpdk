#!/bin/bash

echo "Getting packages required for DPDK build..."
# OVS needs vhost library in DPDK, requires libfuse-dev to compile
apt-get update && apt-get install -y --no-install-recommends \
  libfuse-dev \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

echo "Modifying DPDK configuration..."
# OVS needs DPDK compiled with these...
sed -i s/CONFIG_RTE_BUILD_COMBINE_LIBS=n/CONFIG_RTE_BUILD_COMBINE_LIBS=y/ $RTE_SDK/config/common_linuxapp
sed -i s/CONFIG_RTE_LIBRTE_VHOST=n/CONFIG_RTE_LIBRTE_VHOST=y/ $RTE_SDK/config/common_linuxapp
sed -i s/CONFIG_RTE_LIBRTE_VHOST_USER=y/CONFIG_RTE_LIBRTE_VHOST_USER=n/ $RTE_SDK/config/common_linuxapp
