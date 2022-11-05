#!/usr/bin/env bash

script_name=$(basename "$0")

# source in shared rc data
source ./generate_rc_entries.sh

declare -a removed_entries=()
declare -a skipped_entries=()

function usage() {
    echo "${script_name} usage:"
    printf "====================================\n"
    printf "Description: Uninstalls dot file entries from rc file\n\n"
    flag_usage
}

function main() {
  parse_flags "$@"

  # Make backup of rc file just in case :)
  cp "${rc_file}" "${rc_file}-SAVE" #TODO: maybe add time stamps and keep last x saves


  # shellcheck disable=SC2154
  for entry in "${rc_entries[@]}"; do
    if grep -Fxq "${entry}" "${rc_file}"
    then
      remove_entry "${entry}"
    else
      skipped_entries+=( "${entry}" )
    fi
  done

  printf "Uninstall complete!\n"
  printf "\n"

  if [[ ${verbose_mode} = true ]];
  then
    print_summary
  fi

  # Keep this at end of main function
  dry_mode_disclaimer
}

function remove_entry() {
  entry=$1
  removed_entries+=( "${entry}" )
  sed_friendly_entry=$(echo "${entry}" | sed 's/\//\\\//g')
  if [[ "${dry_mode}" = false ]];
  then
    sed -i "/${sed_friendly_entry}/d" "${rc_file}"
  fi
}

function print_summary() {
  printf "Uninstalled:\n"
  printf "=============\n"
  list_entries "${removed_entries[@]}"
  printf "\nSkipped:\n"
  printf "===========\n"
  list_entries "${skipped_entries[@]}"
}

main "$@"