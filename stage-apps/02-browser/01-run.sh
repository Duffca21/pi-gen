#!/bin/bash -e

# Chromium flags for touch/mobile use on Wayland
mkdir -p "${ROOTFS_DIR}/etc/chromium.d"
cat > "${ROOTFS_DIR}/etc/chromium.d/mobile-flags" << EOF
--enable-features=TouchpadOverscrollHistoryNavigation
--touch-events=enabled
--enable-pinch
--ozone-platform=wayland
--enable-wayland-ime
EOF
