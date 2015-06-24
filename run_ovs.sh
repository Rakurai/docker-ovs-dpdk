#!/bin/bash

export DB_SOCK=/usr/local/var/run/openvswitch/db.sock

ovsdb-server --remote=punix:$DB_SOCK \
  --remote=db:Open_vSwitch,Open_vSwitch,manager_options \
  --private-key=db:Open_vSwitch,SSL,private_key \
  --certificate=Open_vSwitch,SSL,certificate \
  --bootstrap-ca-cert=db:Open_vSwitch,SSL,ca_cert \
  --pidfile \
  --detach

ovs-vsctl --no-wait init

ovs-vswitchd --dpdk -c 0x1 -n 4 -- unix:$DB_SOCK --pidfile
