#!/bin/bash

SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
PROJECT_DIR=$(dirname "$SCRIPT_DIR")
OUT_DIR="${PROJECT_DIR}/out"
OUT_PATH="${OUT_DIR}/out.txt"

function throw_exec(){
  if [ "$1" = "params" ]; then
    echo "[ERR] Requires valid parameters."
    help main
  elif [ "$1" = "url" ]; then
    echo "[ERR] Missing URL."
    help main
    exit
  elif [ "$1" = "len" ]; then
    echo "[ERR] Missing min word length."
    help main
    exit
  elif [ "$1" = "dep" ]; then
    echo "[ERR] Missing crawl depth."
    help main
    exit
  elif [ "$1" = "time" ]; then
    echo "[ERR] Missing crawl duration."
    help main
    exit
  fi
}

function logo(){
  figlet "WowList"
}

function wow(){
  sudo timeout --signal=INT "$4" cewl "$1" -w "$OUT_PATH" -m $2 --with-numbers -d $3
}

function help(){
  if [ "$1" = "main" ]; then
    logo
    echo
    echo "Welcome to the WowList wordlist generation tool."
    echo "Enter the following parameters in order:"
    echo
    echo "[1] Full URL"
    echo "[2] Min Word Length"
    echo "[3] Max Crawl Depth"
    echo "[4] Run Duration"
    echo
  fi

}

function diresolve(){
  echo "[!] Resolving directory structure."
  if [ ! -d "$OUT_DIR" ]; then
    echo "[!] Creating output directory."
    mkdir -p "$OUT_DIR"
  fi
  echo "[!] Prepping output file."
  touch "$OUT_PATH"
}

function pkgresolve(){
  echo "[!] Resolving dependencies."
  reqs="${PROJECT_DIR}/requirements.txt"
  while IFS= read -r pkg; do
      sudo apt-get install "${pkg}" -y > /dev/null
  done < "$reqs"
  echo "[!] Requirments satisfied."
}

function main(){
#  clear
  if [ -n "$1" ]; then
    if [ -n "$2" ]; then
      if [ -n "$3" ]; then
	if [ -n "$4" ]; then
	  diresolve
	  pkgresolve
	  logo
          wow $1 $2 $3 $4
	else
	  throw_exec "time"
	  throw_exec "params"
	fi
      else
        throw_exec "dep"
        throw_exec "params"
      fi
    else
      throw_exec "len"
      throw_exec "params"
    fi
  else
    throw_exec "params"
  fi
  exit
}

main $1 $2 $3 $4
