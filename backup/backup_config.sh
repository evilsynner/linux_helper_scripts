#!/bin/bash

# COLOR SEQUENCES
# \e[COLORmSample Text\e[0m

SCRIPT_NAME=$(basename "$0")

usage() {
    cat << EOF
Usage:
    $SCRIPT_NAME [OPTIONS] <config.json>

Description:
    Creates a backup folder and copies the files/directories
    specified in the JSON configuration file.

Arguments:
    <config.json>    Path to the JSON configuration file.

Options:
    -h, --help
        Show this help message and exit.

    -c, --compress-folder
        Compress the backup folder into a .tar.gz archive
        after all files have been copied.

JSON format:
    {
        "backup_folder": "/path/to/backup",
        "backup_files": [
            "/path/to/file1",
            "/path/to/file2"
        ]
    }

Examples:
    # Create a normal backup
    $SCRIPT_NAME backup.json

    # Create a backup and compress it
    $SCRIPT_NAME -c backup.json

    # Same as above using the long option
    $SCRIPT_NAME --compress-folder backup.json

EOF
}


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

    backup_folder=$(jq -r ".backup_folder" $1)
    mapfile -t backup_files < <(
        jq -r ".backup_files[]" "$1"
    )
}


create_backup_folder() {
    if [ -d "$1" ]; then
        echo -e "\e[1;33m[!] The backup folder already exists, but the files will be copied anyways.\e[0m" >&2
        return 1
    fi
    mkdir "$1"
}


copy_files() {
    declare -n files_array=$2
    for file in "${files_array[@]}"; do
        if cp -ru "$file" "$1"; then
            echo -e "\e[1;32m[+] Copied succesfully: $file\e[0m"
        else
            echo -e "\e[1;31m[!]Error when copying: $file\e[0m" >&2
        fi
    done

    echo -e "\e[1;32mFiles copied successfully.\e[0m"
}


compress_backup_folder() {
    echo -e "\e[1;33m[!] Compressing backup folder to .tar.gz file.\e[0m"
    if tar -czvf "$1.tar.gz" "$1"; then
        echo -e "\e[1;32m[+] Compressed file created successfully.\e[0m"
    else
        echo -e "\e[1;31m[!] An error ocurred while creating the compressed file.\e[0m" >&2
    fi
}


if [[ $# -lt 1 ]]; then
    echo -e "\e[1;31m[!] Invalid number of arguments.\e[0m" >&2
    echo >&2
    usage >&2
    exit 1
fi

COMPRESS_BACKUP_FOLDER=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h | --help)
            usage
            exit 0
            ;;
        -c | --compress-folder)
            COMPRESS_BACKUP_FOLDER=true
            shift
            ;;
        -*)
            echo -e "\e[1;31m[!] Unknown option $1.\e[0m" >&2
            exit 1
            ;;
        *)
            JSON_FILE="$1"
            shift
            ;;
    esac
done

read_json_file "$JSON_FILE"

create_backup_folder "$backup_folder"

copy_files "$backup_folder" backup_files

if [[ "$COMPRESS_BACKUP_FOLDER" == true ]]; then
    compress_backup_folder "$backup_folder"
fi
