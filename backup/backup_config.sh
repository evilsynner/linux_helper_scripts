#!/bin/bash

# COLOR SEQUENCES
# \e[COLORmSample Text\e[0m

check_json_file_structure() {
    # Check that the required keys are present in the JSON file.
    # First, check for "backup_folder" key
    backup_folder_exists=$(jq 'has("backup_folder")' $1)
    if [[ $backup_folder_exists != "true" ]]; then
        echo -e "\e[31m\"\e[0m\e[1;32mbackup_folder\e[0m\e[31m\" key doesn't exist in provided JSON file.\e[0m" >&2
        # exit 1
        return 1
    fi

    # Then check for "backup_files" key
    backup_files_exists=$(jq 'has("backup_files")' $1)
    if [[ $backup_files_exists != "true" ]]; then
        echo -e "\e[31m\"\e[0m\e[1;32mbackup_files\e[0m\e[31m\" key doesn't exist in provided JSON file.\e[0m" >&2
        # exit 1
        return 1
    fi

    return 0
}

read_json_file() {
    if ! check_json_file_structure "$1"; then
        exit 1
    fi

    echo "$(jq -cM ".backup_folder" $1)"
    echo "$(jq -r ".backup_files" $1)"
}


if [ "$#" -gt 1 ]; then
    echo -e "\e[1;31m[!] You must specify only the JSON file that contains the files and folders to be backed up.\e[0m"
    exit 1
elif [ "$#" -lt 1 ]; then
    echo -e "\e[1;31m[!] You must specify the JSON file that contains the files and folders to be backed up.\e[0m"
    exit 1
fi

json_file_content=$(read_json_file "$1")
# for key in $json_file_content; do
#     echo $key
# done
