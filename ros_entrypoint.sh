#!/bin/bash
set -e

case $DDS_CONFIG in
    'HUSARNET_SIMPLE_AUTO')
        export RMW_IMPLEMENTATION=rmw_fastrtps_cpp
        export FASTRTPS_DEFAULT_PROFILES_FILE=/dds-husarnet-simple-auto.xml
        
        /gen-xml-husarnet-simple-auto.sh \
            /fastdds-simple-template.xml \
            $FASTRTPS_DEFAULT_PROFILES_FILE
        ;;
    'HUSARNET_DISCOVERY_SERVER')
        export RMW_IMPLEMENTATION=rmw_fastrtps_cpp
        export FASTRTPS_DEFAULT_PROFILES_FILE=/dds-husarnet-ds.xml

        if [[ -v ROS_DISCOVERY_SERVER ]]; then
            export DISCOVERY_SERVER_IPV6=$(cat /etc/hosts | grep $ROS_DISCOVERY_SERVER | sed -r 's/([a-f0-9:]*)\s(.*)\s# managed by Husarnet/\1/g')
            cat /fastdds-ds-client-template.xml | envsubst > $FASTRTPS_DEFAULT_PROFILES_FILE
        else
            export HOST_IPV6=$(cat /etc/hosts | grep $HOSTNAME | sed -r 's/([a-f0-9:]*)\s(.*)\s# managed by Husarnet/\1/g')
            cat /fastdds-ds-server-template.xml | envsubst > $FASTRTPS_DEFAULT_PROFILES_FILE
        fi
        ;;
    'ENVSUBST')
        if [ $RMW_IMPLEMENTATION == 'rmw_fastrtps_cpp' ]; then
            if [[ -v FASTRTPS_DEFAULT_PROFILES_FILE ]]; then
                auxfile="/dds-config-aux.xml"
                cp --attributes-only --preserve $FASTRTPS_DEFAULT_PROFILES_FILE $auxfile
                cat $FASTRTPS_DEFAULT_PROFILES_FILE | envsubst > $auxfile
                export FASTRTPS_DEFAULT_PROFILES_FILE=$auxfile
            fi
        fi
        ;;
esac

# setup ros environment
source "/opt/ros/$ROS_DISTRO/setup.bash"
test -f "/ros2_ws/install/setup.bash" && source "/ros2_ws/install/setup.bash"

exec "$@"
