#!/bin/bash

set -e

# Add the selected package bundles to the predefined list for the flavor.
IFS=","
for b in $BUNDLES; do
	cat bundles/$b >> tools/samplefs/nvubuntu-jammy-$FLAVOR-aarch64-packages
done


# Generate the sample filesystem.
(
	cd tools/samplefs
	./nv_build_samplefs.sh \
		--abi aarch64 \
		--distro ubuntu \
		--flavor $FLAVOR \
		--version jammy
)

# Unpack the sample filesystem into the target directory.
tar xpf tools/samplefs/sample_fs.tbz2 -C rootfs/

# Apply patches to avoid installing incompatible Linux for Tegra (L4T) packages.
if [ -f "patches/nv-apply-debs-$FLAVOR.diff" ]; then
	patch nv_tegra/nv-apply-debs.sh < patches/nv-apply-debs-$FLAVOR.diff
fi

# Layer binaries from the Board Support Package (BSP) onto the root filesystem.
./apply_binaries.sh

# Add a default user and accept the license to skip the manual OEM config.
./tools/l4t_create_default_user.sh \
	--hostname $HOSTNAME \
	--username $USERNAME \
	--password $PASSWORD \
	--accept-license

# Check that the device is connected over USB and in recovery mode.
if lsusb | grep -q "7523 Nvidia Corp."; then
	# Flash the internal QSPI storage and external microSD card.
	./tools/kernel_flash/l4t_initrd_flash.sh \
		-c tools/kernel_flash/flash_l4t_external.xml \
		-p "-c bootloader/generic/cfg/flash_t234_qspi.xml" \
		--external-device mmcblk0p1 \
		--network usb0 \
		--showlogs \
		jetson-orin-nano-devkit \
		internal
fi 

