FROM ubuntu:22.04

ARG RELEASE_URL="https://developer.nvidia.com/downloads/embedded/l4t/r36_release_v2.0/release"
ARG L4T_DRIVER_PACKAGE="jetson_linux_r36.2.0_aarch64.tbz2"
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	bzip2 \
	ca-certificates \
	patch \
	qemu-user-static \
	sudo \
	usbutils \
	wget \
	&& rm -rf /var/lib/apt/lists/* \
	&& update-ca-certificates \
	&& wget "$RELEASE_URL/$L4T_DRIVER_PACKAGE" \
	&& tar xf $L4T_DRIVER_PACKAGE -C /tmp \
	&& /tmp/Linux_for_Tegra/tools/l4t_flash_prerequisites.sh

WORKDIR /tmp/Linux_for_Tegra
COPY jetson-easy-flash.sh ./
COPY bundles bundles/
COPY patches patches/
ENTRYPOINT [ "./jetson-easy-flash.sh" ]
