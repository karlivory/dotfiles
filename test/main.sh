#!/bin/bash

SCRIPTDIR=$PWD
USERNAME=karl
TEST_KEY_NAME=id_test_rsa
VM_IP=192.168.122.222
VM_BASE_IMAGE=/images/jammy-server-cloudimg-amd64.img
VM_LOCATION=/tmp/jammy-server-cloudimg-amd64.img
SSH_PARAMS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i $TEST_KEY_NAME"
echo "$SCRIPTDIR"

if [ ! -f $TEST_KEY_NAME ]
then
    echo "==================== Test key not found. Generating... ======================="
    ssh-keygen -f $TEST_KEY_NAME -C "TESTKEY" -t rsa -b 2048 -N ""
    echo "=============================================================================="
fi

if [ ! -f $VM_BASE_IMAGE ]
then
    echo "VM base image $VM_BASE_IMAGE not found! Exiting..."
    exit 1
fi
if [ ! -f $VM_LOCATION ]
then
    echo "====================== vm does not exist. Copying... ========================="
    sudo rsync $VM_BASE_IMAGE $VM_LOCATION
    sudo chmod 777 $VM_LOCATION
    echo "=============================================================================="
fi

sudo qemu-img resize $VM_LOCATION 20G
sudo virt-customize -a $VM_LOCATION \
    --ssh-inject root:file:$SCRIPTDIR/$TEST_KEY_NAME.pub \
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

echo "====================== Waiting until ssh is available... ========================="
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "$VM_IP"
attempts=40
SSH_EXIT_STATUS=1
while [[ $SSH_EXIT_STATUS -ne 0 ]]
do
    ssh $SSH_PARAMS -T root@$VM_IP "echo 0 /dev/zero"
    SSH_EXIT_STATUS=$?
    let "attempts-=1"
    if [ $attempts -lt 0 ]; then
        echo "Failed to connect!"
        break;
    fi
    echo "Trying again... ($attempts)"
    sleep 2
done
if [[ $SSH_EXIT_STATUS -eq 0 ]]
then
    echo "success"
else
    echo "Failed to connect! Out of attempts"
fi
echo "=================================================================================="

ssh $SSH_PARAMS root@$VM_IP "mkdir -p /root/tests"

SECONDS=0
echo "=================================== test 1 ======================================="
scp $SSH_PARAMS tests/test0.sh root@$VM_IP:/root/tests/
ssh $SSH_PARAMS -t root@$VM_IP "bash /root/tests/test0.sh"
echo "=================================================================================="
ELAPSED="$(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"
echo "Test finished in $ELAPSED"

sudo virsh shutdown --domain dotfiles_test_vm 
read -p "Finished. Press <ENTER> to terminate..."
