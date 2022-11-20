#!/bin/bash

DDS_CONF_FILE="./dds-conf-husarnet-simple-auto.xml"
cp $1 $DDS_CONF_FILE

while IFS="" read -r p || [ -n "$p" ]
do
    # printf 'line: %s\n' "$p"

    IPV6=$(echo $p | grep "# managed by Husarnet" | sed -r 's/([a-f0-9:]*)\s(.*)\s# managed by Husarnet/\1/g')
    #HOSTNAME=$(echo $p | grep "# managed by Husarnet" | sed -r 's/([a-f0-9:]*)\s(.*)\s# managed by Husarnet/\2/g')

    if [[ $IPV6 ]]; then
        array=( "defaultUnicastLocatorList" "builtin.initialPeersList" "builtin.metatrafficUnicastLocatorList" )
        for i in "${array[@]}"
        do
            yq --xml-strict-mode -p=xml -o=xml -i e \
                '.dds.profiles.participant.rtps.'$i'[] += {"udpv6": {"address": "'$IPV6'" }}' \
                $DDS_CONF_FILE
        done
    fi

done < /etc/hosts

echo $DDS_CONF_FILE
