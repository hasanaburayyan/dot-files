#!/usr/bin/env bash

dot_file_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


function source_everything() {
  source_folder "aliases"
  source_folder "env_vars"
  source_folder "functions"
}

function source_folder() {
  folder=$1
  for file in "${dot_file_dir}/${folder}/"*;
  do
    source "${file}"
  done
}

source_everything