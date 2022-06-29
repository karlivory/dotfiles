#!/bin/bash

echo "=============================== Cleaning up...  =================================="
sudo virsh destroy dotfiles_test_vm
sudo virsh undefine dotfiles_test_vm
sudo rm /tmp/jammy-server-cloudimg-amd64.img
echo "================================== Done! ========================================="
