FROM rakurai/dpdk:1.7.0-onbuild

RUN apt-get update && apt-get install -y --no-install-recommends \
  autoconf automake \
  libtool \
  openssl libssl-dev \
  python \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV OVS_DIR=/usr/src/ovs \
  OVS_VERSION=2.3.2

RUN curl -ksSL http://openvswitch.org/releases/openvswitch-${OVS_VERSION}.tar.gz | tar -xz; \
  mv openvswitch-${OVS_VERSION} ${OVS_DIR}

RUN /bin/bash -c "sed -i s:rte_memzone_dump://rte_memzone_dump: /usr/src/ovs/lib/netdev-dpdk.c"

RUN . ${RTE_SDK}/dpdk_env.sh; \
  cd ${OVS_DIR} \
#  && ./boot.sh \
#  && sed -i s/DPDK_EXTRA_LIB="-lfuse"/#DPDK_EXTRA_LIB="-lfuse"/ ./configure \
  && CFLAGS="-g -O2 -Wno-cast-align" ./configure --with-dpdk=${RTE_SDK}/${RTE_TARGET} \
  && make install CFLAGS='-O3 -march=native' -j20 LIBS='-ldl' \
  && make clean

# create database configuration
RUN ovsdb-tool create /usr/local/etc/openvswitch/conf.db /usr/local/share/openvswitch/vswitch.ovsschema

COPY run_ovs.sh run_ovs.sh

CMD ["./run_ovs.sh"]
