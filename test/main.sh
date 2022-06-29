#!/bin/bash

SCRIPTDIR=$PWD
VM_IP=192.168.122.222
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
    sudo rsync /images/jammy-server-cloudimg-amd64.img $vm_location
    chmod 777 $vm_location
    echo "=============================================================================="
fi

sudo qemu-img resize $vm_location 20G
sudo virt-customize -a $vm_location \
    --ssh-inject root:file:$SCRIPTDIR/test_key_rsa.pub \
    --copy-in $SCRIPTDIR/files/01-netcfg.yaml:/etc/netplan/ \
    --root-password password:root \
    --uninstall cloud-init \
    --firstboot-command "growpart /dev/vda 1" \
    --firstboot-command "resize2fs /dev/vda1" \
    --firstboot-command "netplan generate && netplan apply" \
    --firstboot-command "dpkg-reconfigure openssh-server" \
    --firstboot-command "ip link set dev enp0s2 up"
    
sudo virsh define files/dotfiles_test_vm.xml
sudo virsh start dotfiles_test_vm
st -e "virsh console dotfiles_test_vm"

echo "====================== Waiting until ssh is available... ========================="
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "$VM_IP"
attempts=10
ssh_params="-T root@$VM_IP"
ssh $ssh_params
while test $? -gt 0
do
    ssh $ssh_params
    let "attempts-=1"
    if [ $attempts -lt 0 ]; then
        echo "Failed to connect!"
        break;
    fi
    echo "Trying again..."
    sleep 2
done
echo "=================================================================================="

echo "====================== Waiting until ssh is available... ========================="
echo "=================================================================================="

read -p "Finished. Press <ENTER> to terminate..."
sudo virsh destroy dotfiles_test_vm
sudo virsh undefine dotfiles_test_vm
# rm /tmp/jammy-server-cloudimg-amd64.img
