#!/bin/bash

# Paths
SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
PROJECT_DIR=$(dirname "$SCRIPT_DIR")
OUT_DIR="${PROJECT_DIR}/out"
OUT_PATH="${OUT_DIR}/temp.txt"
FILTERED_PATH="${OUT_DIR}/filtered.txt"
SHORTS_PATH="${OUT_DIR}/shorts.txt"
LONGS_PATH="${OUT_DIR}/longs.txt"
WOW_PATH="${OUT_DIR}/wowlist.txt"

# Evaluates wordlist lengths.
#
# Returns:
#   None
function evl(){
  out_last=$(cat "$OUT_PATH" | grep "" -n | tail -n 1)
  out_len=$(echo "$out_last" | cut -d':' -f1)
  echo "Orignial Length: $out_len"

  filt_last=$(cat "$FILTERED_PATH" | grep "" -n | tail -n 1)
  filt_len=$(echo "$filt_last" | cut -d':' -f1)
  echo "Filtered Length: $filt_len"

  shorts_last=$(cat "$SHORTS_PATH" | grep "" -n | tail -n 1)
  shorts_len=$(echo "$shorts_last" | cut -d':' -f1)
  echo "Shorts Length: $shorts_len"

  longs_last=$(cat "$LONGS_PATH" | grep "" -n | tail -n 1)
  longs_len=$(echo "$longs_last" | cut -d':' -f1)
  echo "Longs Length: $longs_len"

  wow_last=$(cat "$WOW_PATH" | grep "" -n | tail -n 1)
  wow_len=$(echo "$wow_last" | cut -d':' -f1)
  echo "Wow Length: $wow_len"
}

# Defines the main function.
#
# Returns:
#    None
function main(){
  evl
}

main
