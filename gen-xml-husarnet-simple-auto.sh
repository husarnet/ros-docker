#!/bin/bash

cp $1 $2

HOST_IPV6=$(ifconfig hnet0 | grep 'inet6 .* prefixlen 16' | sed -r 's/\s*inet6 ([a-f0-9:]*)\s\sprefixlen 16.*/\1/g')

array=( "defaultUnicastLocatorList" "builtin.metatrafficUnicastLocatorList" )
for i in "${array[@]}"
do
    yq --xml-strict-mode -p=xml -o=xml -i e \
        '.dds.profiles.participant.rtps.'$i'[] += {"udpv6": {"address": "'$HOST_IPV6'" }}' \
        $2
done
            

while IFS="" read -r p || [ -n "$p" ]
do
    # printf 'line: %s\n' "$p"

    PEER_IPV6=$(echo $p | grep "# managed by Husarnet" | sed -r 's/([a-f0-9:]*)\s(.*)\s# managed by Husarnet/\1/g')
    #HOSTNAME=$(echo $p | grep "# managed by Husarnet" | sed -r 's/([a-f0-9:]*)\s(.*)\s# managed by Husarnet/\2/g')

    if [[ $PEER_IPV6 ]]; then
        yq --xml-strict-mode -p=xml -o=xml -i e \
            '.dds.profiles.participant.rtps.builtin.initialPeersList[] += {"udpv6": {"address": "'$PEER_IPV6'" }}' \
            $2
    fi

done < /etc/hosts

# clear [0] and [1] dummy elements added in fastdds-simple-template.xml
for a in {0..1}
do
    array=( "defaultUnicastLocatorList" "builtin.initialPeersList" "builtin.metatrafficUnicastLocatorList" )
    for i in "${array[@]}"
    do
        yq --xml-strict-mode -p=xml -o=xml -i \
            'del(.dds.profiles.participant.rtps.'$i'.locator[0])' \
            $2
    done
done

# print as yaml for nicer look
# yq --xml-strict-mode -p=xml -o=yaml '.' $2