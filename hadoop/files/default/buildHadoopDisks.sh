#!/bin/bash
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
#
#
# Quick explanation as to the purpose of this script:
#
# At Outbrain, I eschew RAID and LVM for Hadoop nodes.  We use cobbler to 
# create the initial disk layout on /dev/sda and additionally build the 
# first dfs.data.dir target on /data/a/.  Cobbler installs chef and registers
# the node.
#
# We then expect this recipe to build out rest of the directories on each disk.
# Unfortunately, we do not have a homogeneous cluster.  We have some nodes
# with 2 drives, others with up to 6, but never more.
#
# This script will search out all connected drives (ignoring /dev/sda) and 
# build /dev/sdX1 to use the whole disk, format it and mount it at /data/X.
# In the recipe proper there is some aweful code that builds out the rest
# of the directory hierachy and adds it to the dfs.{data,name}.dir.
#
# This script runs EVERY TIME Chef does a run.  If the mount point exists
# it skips the associated drive.  The upside of this is that if you add a disk
# and you have a hot-swap backplane, Chef will build it and add it to
# dfs.data.dir for you then restart the datanode to pick up the change.

declare -a disks
disks=( $(fdisk -l | grep Disk | cut -d":" -f1 | sed 's/Disk //g') )

function addToFstab() {
   echo "LABEL=/data/${disk:7}           /data/${disk:7}                 ext3    defaults        1 2" >> /etc/fstab
}

function buildMountPoint() {
   mkdir -p /data/${disk:7}
}

function buildPartition() {
   parted $disk --script -- mkpart primary 0 -1
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

