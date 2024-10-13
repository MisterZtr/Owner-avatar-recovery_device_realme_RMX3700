#!/sbin/sh

# Если modules.img есть только в ksu
if [ -f "/data/adb/ksu/modules.img" ] && [ ! -f "/data/adb/ap/modules.img" ]; then
  e2fsck -fy /data/adb/ksu/modules.img
  size=$(du -m /data/adb/ksu/modules.img | awk '{print $1}')
  let "rsize = $size + 100"
  resize2fs /data/adb/ksu/modules.img "$rsize"m
  mount -t auto -o loop /data/adb/ksu/modules.img /data/adb/modules

# Если modules.img есть в ap
elif [ -f "/data/adb/ap/modules.img" ] && [ ! -f "/data/adb/ksu/modules.img" ]; then
  e2fsck -fy /data/adb/ap/modules.img
  mount -t auto -o loop /data/adb/ap/modules.img /data/adb/modules

# Если modules.img есть и в ksu и в ap
elif [ -f "/data/adb/ksu/modules.img" ] && [ -f "/data/adb/ap/modules.img" ]; then

  mkdir /data/adb/ksu-modules
  mkdir /data/adb/ap-modules

  e2fsck -fy /data/adb/ap/modules.img
  e2fsck -fy /data/adb/ksu/modules.img
  size=$(du -m /data/adb/ksu/modules.img | awk '{print $1}')
  let "rsize = $size + 100"
  resize2fs /data/adb/ksu/modules.img "$rsize"m
  mount -t auto -o loop /data/adb/ksu/modules.img /data/adb/ksu-modules
  mount -t auto -o loop /data/adb/ap/modules.img /data/adb/ap-modules

  # Модуль для удаления папок (допустим так, но наверно можно как то и получше)
  mkdir /data/adb/ksu-modules/ModulesTemp
  mkdir /data/adb/ap-modules/ModulesTemp

  echo '#!/system/bin/sh' >/data/adb/ksu-modules/ModulesTemp/service.sh
  echo '#!/system/bin/sh' >/data/adb/ap-modules/ModulesTemp/service.sh
  echo 'rm -rf /data/adb/ksu-modules' >>/data/adb/ksu-modules/ModulesTemp/service.sh
  echo 'rm -rf /data/adb/ap-modules' >>/data/adb/ap-modules/ModulesTemp/service.sh
  echo 'rm -rf /data/adb/modules/ModulesTemp' >>/data/adb/ksu-modules/ModulesTemp/service.sh
  echo 'rm -rf /data/adb/modules/ModulesTemp' >>/data/adb/ap-modules/ModulesTemp/service.sh
  chmod +x /data/adb/ksu-modules/ModulesTemp/service.sh
  chmod +x /data/adb/ap-modules/ModulesTemp/service.sh

fi
