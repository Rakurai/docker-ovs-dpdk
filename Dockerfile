FROM rakurai/dpdk:2.0.0-onbuild

RUN apt-get update && apt-get install -y --no-install-recommends \
  autoconf automake \
  libtool \
  openssl libssl-dev \
  python \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV OVS_DIR=/usr/src/ovs

RUN curl -ksSL http://github.com/openvswitch/ovs/archive/master.tar.gz | tar -xz; \
  mv ovs-master ${OVS_DIR}

RUN . ${RTE_SDK}/dpdk_env.sh; \
  cd ${OVS_DIR} \
  && ./boot.sh \
  && ./configure --with-dpdk=${RTE_SDK}/${RTE_TARGET} \
  && make install CFLAGS='-O3 -march=native' \
  && make clean

# create database configuration
RUN ovsdb-tool create /usr/local/etc/openvswitch/conf.db /usr/local/share/openvswitch/vswitch.ovsschema

COPY run_ovs.sh run_ovs.sh

CMD ["./run_ovs.sh"]
