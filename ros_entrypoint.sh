#!/bin/bash
set -e

case $DDS_CONFIG in
    'HUSARNET_SIMPLE_AUTO')
        export FASTRTPS_DEFAULT_PROFILES_FILE=/dds-conf-husarnet-simple-auto.xml
        
        /gen-xml-husarnet-simple-auto.sh \
            /fastdds-simple-template.xml \
            $FASTRTPS_DEFAULT_PROFILES_FILE
        ;;
    'HUSARNET_DISCOVERY_SERVER')
        echo DDS_CONFIG=$DDS_CONFIG
        ;;
    'ENVSUBST')
        if [ $RMW_IMPLEMENTATION == 'rmw_fastrtps_cpp' ]
        then
            if [[ -v FASTRTPS_DEFAULT_PROFILES_FILE ]]; then
                auxfile="/dds-config-aux.xml"
                cp --attributes-only --preserve $FASTRTPS_DEFAULT_PROFILES_FILE $auxfile
                cat $FASTRTPS_DEFAULT_PROFILES_FILE | envsubst > $auxfile
                export FASTRTPS_DEFAULT_PROFILES_FILE=$auxfile
            fi
        fi
        ;;
esac

echo FASTRTPS_DEFAULT_PROFILES_FILE=$FASTRTPS_DEFAULT_PROFILES_FILE

# setup ros environment
source "/opt/ros/$ROS_DISTRO/setup.bash"
test -f "/ros2_ws/install/setup.bash" && source "/ros2_ws/install/setup.bash"

exec "$@"
