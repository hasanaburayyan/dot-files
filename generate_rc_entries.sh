#!/usr/bin/env bash

#TODO: Determine what rc folder to use (maybe as flag)
rc_file="${HOME}/.bashrc"

dot_file_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

dry_mode=false
verbose_mode=false

rc_entries=(
  "export MY_DOT_FILES_DIR=${dot_file_dir}"
  "source ${dot_file_dir}/.sources.sh"
)

function parse_flags() {
  if [[ $* == *--help* ]];
  then
    usage
  fi

  if [[ $* == *--verbose* ]];
  then
    printf "Verbose Mode On!\n\n"
    verbose_mode=true
  fi

  if [[ $* == *--dry* ]];
  then
    printf "*****Dry Run ONLY!*****\n\n"
    dry_mode=true
    verbose_mode=true
  fi
}
function flag_usage() {
    printf "Available flags\n"
    printf "===================\n"
    printf "verbose \t\t Toggle on verbose mode to view summary\n\n"
    printf "dry \t\t\t Toggle dry run, will not add or remove entries (will automatically turn on verbose mode)\n\n"
    exit 0
}

function list_entries() {
  entries=("$@")
  for entry in "${entries[@]}"; do
    echo "${entry}"
  done
}

function dry_mode_disclaimer() {
  if [[ "${dry_mode}" = true ]];
    then
      echo "***********************************************************************"
      echo "*  Note: The following was not applied due to Dry Run being toggled   *"
      echo "***********************************************************************"
  fi
}
