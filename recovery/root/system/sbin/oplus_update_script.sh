#!/system/bin/sh
para_list=$@

#Symlink funtion
if [ "$1" = "symlink" ]; then
    shift
    link_src=$1
    shift
    for link_dest in "$@"
    do
        if [ ${link_dest:0:1} != "/" ]; then
            echo "link dest path not start with root dir"
            exit 1
        fi

        link_dir=$(dirname ${link_dest})
        rm -rf link_dest
        cd ${link_dir}
        ln -sf ${link_src} ${link_dest}
    done
    exit 0
fi

if [ "$1" = "fpdata_migrate" ]; then
    #change facedata file mode and lebel from P to Q
    echo "fpdata migrate start."
    facedata="/data/vendor_de/0/facedata"
    mount -o ro /dev/block/bootdevice/by-name/system /system_root
    if [ -d $facedata ]; then
        chmod -R 700 $facedata
        chown -R 1000:1000 $facedata
        chcon -R u:object_r:face_vendor_data_file:s0 $facedata
        echo "fpdata migrate done."
    fi
    umount /system_root

fi
#Other fuction

if [ "$1" = "update_data" ]; then
    #operate data file from R to all
    echo "operate data start."

    #remove old apks and data directory
    #Breeno Space
    rm -rf /data/app/PersonalAssistant
    rm -rf /data/app/com.coloros.personalassistant-*
    rm -rf /data/data/com.coloros.personalassistant
    rm -rf /data/user_de/0/com.coloros.personalassistant

    echo "operate data end."

fi
