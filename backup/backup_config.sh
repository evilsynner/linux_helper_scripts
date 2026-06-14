#!/bin/bash

# COLOR SEQUENCES
# \e[COLORmSample Text\e[0m

read_json_file() {
    # Check that the required keys are present in the JSON file.
    backup_folder_exists=$(jq 'has("backup_folder")' $1)
    if [[ $backup_folder_exists != "true" ]]; then
        echo -e "\e[31m\"\e[0m\e[1;32mbackup_folder\e[0m\e[31m\" key doesn't exist in provided JSON file.\e[0m"
        exit 1
    fi

    backup_files_exists=$(jq 'has("backup_files")' $1)
    if [[ $backup_files_exists != "true" ]]; then
        echo -e "\e[31m\"\e[0m\e[1;32mbackup_files\e[0m\e[31m\" key doesn't exist in provided JSON file.\e[0m"
        exit 1
    fi
}


if [ "$#" -gt 1 ]; then
    echo -e "\e[1;31m[!] You must specify only the JSON file that contains the files and folders to be backed up.\e[0m"
    exit 1
elif [ "$#" -lt 1 ]; then
    echo -e "\e[1;31m[!] You must specify the JSON file that contains the files and folders to be backed up.\e[0m"
    exit 1
fi

read_json_file "$1"
