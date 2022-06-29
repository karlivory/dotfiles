#!/bin/bash

SCRIPTDIR=$PWD
echo "$SCRIPTDIR"

if [ ! -f ./test_key_rsa ]
then
    echo "==================== Test key not found. Generating... ======================="
    ssh-keygen -f test_key_rsa -C "TESTKEY" -t rsa -b 2048 -N ""
    echo "=============================================================================="
fi

vm_location=/tmp/jammy-server-cloudimg-amd64.img
if [ ! -f $vm_location ]
then
    echo "====================== vm does not exist. Copying... ========================="
    rsync /images/jammy-server-cloudimg-amd64.img $vm_location
    chmod 777 $vm_location
    echo "=============================================================================="
fi

qemu-img resize $vm_location 20G
virt-customize -a $vm_location \
    --ssh-inject root:file:$SCRIPTDIR/test_key_rsa.pub \
    --copy-in $SCRIPTDIR/files/01-netcfg.yaml:/etc/netplan/ \
    --root-password password:root \
    --uninstall cloud-init \
    --firstboot-command "netplan generate && netplan apply" \
    --firstboot-command "dpkg-reconfigure openssh-server" \
    --firstboot-command "ip link set dev enp0s2 up"
    

virsh define files/dotfiles_test_vm.xml
virsh start dotfiles_test_vm
# virsh console dotfiles_test_vm

read -p "Continue?"

# do stuff
virsh destroy dotfiles_test_vm
virsh undefine dotfiles_test_vm
rm /tmp/jammy-server-cloudimg-amd64.img
