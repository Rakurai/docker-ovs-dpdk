FROM rakurai/dpdk:2.0.0-onbuild

RUN apt-get update && apt-get install -y --no-install-recommends \
  git \
  g++ \
  autoconf \
  automake \
  libtool \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV OVS_VERSION=2.3.2 \
  OVS_DIR=/usr/src/ovs

RUN curl -sSL http://openvswitch.org/releases/openvswitch-${OVS_VERSION}.tar.gz | tar -xz; \
  mv openvswitch-${OVS_VERSION} ${OVS_DIR}

RUN . ${RTE_SDK}/dpdk_env.sh; \
  cd ${OVS_DIR} \
  && ./boot.sh \
  && ./configure --with-dpdk=${RTE_SDK}/${RTE_TARGET} \
  && make install CFLAGS='-O3 -march=native' \
  && make clean

#CMD ["click"]
