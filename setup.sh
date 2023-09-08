apt update -y
apt upgrade -y
apt install qemu qemu-utils wget -y
apt install qemu-kvm -y
apt install ovmf -y
apt install novnc python3 websockify -y
cd /root
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=15Lt1skHXq5yaP5-cWpYxsuv5yEywfbgP' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=15Lt1skHXq5yaP5-cWpYxsuv5yEywfbgP" -O cdrom.iso && rm -rf /tmp/cookies.txt
wget -O 'virtio-win.iso' https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.229-1/virtio-win.iso
mkdir fdisk
cd fdisk
wget -O 'ChromeSetup.msi' https://github.com/kmille36/thuonghai/releases/download/1.0.0/googlechromestandaloneenterprise64.msi
websockify -D --web=/usr/share/novnc/ --cert=novnc.pem 8080 localhost:5900
cd /root
qemu-img create -f raw disk.img 32G
qemu-system-x86_64 \
-name CodespacesQemu \
-m 8G,slots=8,maxmem=16G \
-object memory-backend-ram,size=1G,id=m0 \
-object memory-backend-ram,size=1G,id=m1 \
-object memory-backend-ram,size=1G,id=m2 \
-object memory-backend-ram,size=1G,id=m3 \
-object memory-backend-ram,size=1G,id=m4 \
-object memory-backend-ram,size=1G,id=m5 \
-object memory-backend-ram,size=1G,id=m6 \
-object memory-backend-ram,size=1G,id=m7 \
-numa node,nodeid=0,memdev=m0,cpus=0 \
-numa node,nodeid=1,memdev=m1,cpus=1 \
-numa node,nodeid=1,memdev=m2,cpus=2 \
-numa node,nodeid=1,memdev=m3,cpus=3 \
-numa node,nodeid=1,memdev=m4,cpus=4 \
-numa node,nodeid=1,memdev=m5,cpus=5 \
-numa node,nodeid=1,memdev=m6,cpus=6 \
-numa node,nodeid=1,memdev=m7,cpus=7 \
-smp 8,threads=1,cores=8,sockets=1 \
-cpu host,hv_relaxed,hv_spinlocks=8191,hv_vapic,hv_time,hv_synic,hv_stimer,hv_vpindex,hv_reset,hv_frequencies,+nx \
-enable-kvm \
-drive file=/root/virtio-win.iso,media=cdrom \
-drive file=/root/cdrom.iso,media=cdrom \
-drive file=/root/disk.img,media=disk,format=raw,if=virtio,cache=none,aio=native \
-drive file=fat:rw:/root/fdisk,media=disk,format=raw
-device usb-ehci,id=usb \
-device usb-tablet \
-device usb-kbd \
-object rng-random,filename=/dev/random,id=rng0 \
-device virtio-rng-pci,rng=rng0 \
-device intel-iommu,intremap=on,device-iotlb=on \
-device ioh3420,id=pcie.1,chassis=1 \
-vga virtio \
-machine q35,accel=kvm:tcg,kernel-irqchip=split \
-rtc base=localtime,clock=vm \
-device virtio-net-pci,bus=pcie.1,netdev=net0,disable-legacy=on,disable-modern=off,iommu_platform=on,ats=on \
-bios /usr/share/ovmf/OVMF.fd \
-netdev user,id=net0 \
-vnc :0
