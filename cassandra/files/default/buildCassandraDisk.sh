# Copyright 2011, Outbrain, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#!/bin/bash
declare -a disks
disks=( $(fdisk -l | grep Disk | cut -d":" -f1 | sed 's/Disk //g') )


function addToFstab() {

   echo "LABEL=/data/${disk:7}           /data/${disk:7}                 ext3    defaults        1 2" >> /etc/fstab

}

function buildMountPoint() {

   mkdir -p /data/${disk:7}
}

function buildPartition() {

   fdisk $disk <<EOF
n
p
1


w
EOF

}

function formatVolume() {

   mkfs.ext3 -F -L /data/${disk:7} ${disk}1

}

function mountVolume() {

   mount /data/${disk:7} 

}

for disk in "${disks[@]}"; do
   if [ $disk = "/dev/sda" ]; then
      echo "skipping $disk"
   elif [ -d /data/${disk:7} ]; then
      echo "skipping $disk"
   else
      buildMountPoint
      buildPartition
      formatVolume
      addToFstab
      mountVolume 
   fi
done


