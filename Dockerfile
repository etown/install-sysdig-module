FROM alpine:3.4
ARG SYSDIGVER=0.13.0

RUN apk add --no-cache --update wget ca-certificates \
    build-base gcc abuild binutils \
    bc \
    cmake && \

  export KERNELVER=`uname -r  | cut -d '-' -f 1`  && \
  export KERNELDIR=/src/linux-$KERNELVER && \
  mkdir /src && \
  cd /src && \
  wget https://www.kernel.org/pub/linux/kernel/v4.x/linux-$KERNELVER.tar.gz && \
  tar zxf linux-$KERNELVER.tar.gz && \
  cd /src/linux-$KERNELVER && \
  zcat /proc/1/root/proc/config.gz > .config && \
  make modules_prepare && \
  mv .config /src/config && \
  cd /src && \
  wget https://github.com/draios/sysdig/archive/$SYSDIGVER.tar.gz && \
  tar zxf $SYSDIGVER.tar.gz && \
  mkdir -p /sysdig/build && \
  cd /sysdig/build && \
  cmake /src/sysdig-$SYSDIGVER && \
  make driver && \

  rm -rf /src && \
  apk del wget ca-certificates \
    build-base gcc abuild binutils \
    bc \
    cmake

CMD ["insmod","/sysdig/build/driver/sysdig-probe.ko"] 
