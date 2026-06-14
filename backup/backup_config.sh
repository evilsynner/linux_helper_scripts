#!/bin/bash

# COLOR SEQUENCES
# \e[COLORmSample Text\e[0m

read_json_file() {
    jq ".backup_folder" $1
}


echo "$@"

if [ "$#" -gt 1 ]; then
    echo -e "\e[1;31m[!] You must specify only the JSON file that contains the files and folders to be backed up.\e[0m"
    exit 1
elif [ "$#" -lt 1 ]; then
    echo -e "\e[1;31m[!] You must specify the JSON file that contains the files and folders to be backed up.\e[0m"
    exit 1
fi

read_json_file "$1"
