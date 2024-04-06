#!/sbin/sh
if [ -f "/data/adb/ksu/modules.img" ]; then
  e2fsck -fy /data/adb/ksu/modules.img;
  resize2fs -M /data/adb/ksu/modules.img;
  mount -t auto -o loop /data/adb/ksu/modules.img /data/adb/ksu-modules;
fi;

if [ -f "/data/adb/ap/modules.img" ]; then
  e2fsck -fy /data/adb/ap/modules.img;
  mount -t auto -o loop /data/adb/ap/modules.img /data/adb/ap-modules;
fi;
