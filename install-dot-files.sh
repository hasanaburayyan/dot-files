#!/usr/bin/env bash
script_name=$(basename "$0")

source ./generate_rc_entries.sh

declare installed_entries=()
declare skipped_entries=()

function usage() {
    echo "${script_name} usage:"
    printf "====================================\n"
    printf "Description: Installs dot file entries from rc file\n\n"
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
      skipped_entries+=( "${entry}" )
    else
      add_entry "${entry}"
    fi
  done

  echo "Install complete!"
  echo

  if [[ ${verbose_mode} = true ]];
  then
    print_summary
  fi

  # Keep this at end of main function
  dry_mode_disclaimer
}


function add_entry() {
  entry=$1
  installed_entries+=( "${entry}" )
  if [[ "$dry_mode" = false ]];
  then
    echo "${entry}" >> "${rc_file}"
  fi
}

function print_summary() {
  printf "Installed:\n"
  printf "=============\n"
  list_entries "${installed_entries[@]}"
  printf "\nSkipped:\n"
  printf "===========\n"
  list_entries "${skipped_entries[@]}"
}

main "$@"