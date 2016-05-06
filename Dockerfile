FROM alpine:3.1

RUN apk add  --update wget ca-certificates \
 git \
 build-base gcc abuild binutils \
 cmake 


RUN echo `uname -r  | cut -d '-' -f 1` 
RUN export KERNELVER=`uname -r  | cut -d '-' -f 1` 

RUN export KERNELVER=`uname -r  | cut -d '-' -f 1`  && \
	export KERNELDIR=/linux-$KERNELVER && \
	wget https://www.kernel.org/pub/linux/kernel/v4.x/linux-$KERNELVER.tar.gz && \
	tar zxf linux-$KERNELVER.tar.gz && \
	cd linux-$KERNELVER && \
	zcat /proc/1/root/proc/config.gz > .config && \
	make modules_prepare && \
	mv .config ../config && \
	cd .. && \
	git clone https://github.com/draios/sysdig.git && \
	cd sysdig && \
	mkdir build && \
	cd build && \
	cmake .. && \
	make driver
	

CMD ["insmod","/sysdig/build/driver/sysdig-probe.ko"] 