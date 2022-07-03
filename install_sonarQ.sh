#!/usr/bin/env bash

# Install Sonar Qube

CONF="/etc/sysctl.conf"

function insertAfter # file line newText
{
   local file="$1" 
   line="$2" 
   newText="$3"
   sed -i -e "/^$line$/a"$'\\\n'"$newText"$'\n' "$file"
}


prepare_env () {

    echo "The first thing we must do is modify the kernel system limits. For this we must set the following:"
    echo "vm.max_map_count must be greater than or equal to 524288"
    echo "fs.file-max must be greater than or equal to 131072"
    echo "The SonarQube user must be able to open at least 131072 file descriptors"
    echo "The SonarQube user must be able to open at least 8192 threads"

    echo "Checking:  [/etc/sysctl.conf]"
    if [[ ! -f /etc/sysctl.conf ]]; then
        echo "Not present: /etc/sysctl.conf"
    fi

    echo "Checking is set: [vm.max_map_count=262144]"

    if [[ ! -f /etc/sysctl.conf ]]; then
        echo "Not present: /etc/sysctl.conf"
    fi

    grep "vm.max_map_count" $CONF

    if [[ $? -eq 0 ]]; then
       echo "Config Present"
    else
        echo "Adding Config now"
        echo "vm.max_map_count=262144" >> $CONF
        echo "fs.file-max=65536" >> $CONF
        echo "ulimit -n 65536" >> $CONF
        echo "ulimit -u 4096" >> $CONF
    fi 
    
}

main () {
    prepare_env
}

main
