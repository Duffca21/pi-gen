#!/bin/bash -e

# Enable SDDM (display manager) to start Plasma Mobile on boot
on_chroot << EOF
systemctl enable sddm
EOF

# SDDM config: autologin as the default user into Plasma Mobile session
install -m 644 /dev/null "${ROOTFS_DIR}/etc/sddm.conf"
cat > "${ROOTFS_DIR}/etc/sddm.conf" << EOF
[Autologin]
User=${FIRST_USER_NAME}
Session=plasma-mobile

[General]
DisplayServer=wayland
GreeterEnvironment=QT_WAYLAND_SHELL_INTEGRATION=layer-shell
EOF

# Ensure the pi user's session is Wayland/Plasma Mobile by default
mkdir -p "${ROOTFS_DIR}/var/lib/AccountsService/users"
cat > "${ROOTFS_DIR}/var/lib/AccountsService/users/${FIRST_USER_NAME}" << EOF
[User]
Session=plasma-mobile
SystemAccount=false
EOF

# Allow video/input group access for touchscreen and GPU
on_chroot << EOF
usermod -aG video,input,render ${FIRST_USER_NAME}
EOF
