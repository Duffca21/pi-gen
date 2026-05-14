#!/bin/bash -e

# Add user to dialout group for serial modem access
on_chroot << EOF
usermod -aG dialout ${FIRST_USER_NAME}
EOF

# ofono main config — enable auto-detection of USB and serial modems
mkdir -p "${ROOTFS_DIR}/etc/ofono"
cat > "${ROOTFS_DIR}/etc/ofono/main.conf" << EOF
[ModemManager]
# Let ofono manage modems exclusively; disable if using ModemManager
Enabled=false

[DBus]
Enabled=true
EOF

# mmsd-tng config — MMS daemon linked to ofono
mkdir -p "${ROOTFS_DIR}/etc/mmsd-tng"
cat > "${ROOTFS_DIR}/etc/mmsd-tng/mmsd-tng.conf" << EOF
[Settings]
UseDeliveryReports=true
AutoProcessOnConnection=true
EOF

# udev rule: give dialout group rw access to USB serial modems (Quectel, SIM7600, etc.)
cat > "${ROOTFS_DIR}/etc/udev/rules.d/99-modem.rules" << EOF
SUBSYSTEM=="tty", ATTRS{idVendor}=="2c7c", MODE="0660", GROUP="dialout"
SUBSYSTEM=="tty", ATTRS{idVendor}=="1e0e", MODE="0660", GROUP="dialout"
SUBSYSTEM=="tty", ATTRS{idVendor}=="05c6", MODE="0660", GROUP="dialout"
EOF
