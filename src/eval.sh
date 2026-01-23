#!/bin/bash

SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
PROJECT_DIR=$(dirname "$SCRIPT_DIR")
OUT_DIR="${PROJECT_DIR}/out"
OUT_PATH="${OUT_DIR}/out.txt"
FILTERED_PATH="${OUT_DIR}/filtered.txt"

function main(){

  out_last=$(cat "$OUT_PATH" | grep "" -n | tail -n 1)
  out_len=$(echo "$out_last" | cut -d':' -f1)
  echo "Orignial Length: $out_len"

  filt_last=$(cat "$FILTERED_PATH" | grep "" -n | tail -n 1)
  filt_len=$(echo "$filt_last" | cut -d':' -f1)
  echo "Filtered Length: $filt_len"
}

main
