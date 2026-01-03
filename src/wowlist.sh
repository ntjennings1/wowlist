#!/bin/bash

function wow(){
  sudo cewl -m $2 $1 -w $3 --with-numbers
}

function list(){
  echo o
}

function logo(){
  figlet "WowList"
}

function help(){
  if [ "$1" = "main" ]; then
    logo
    echo
    echo "Welcome to the WowList wordlist generation tool."
    echo "Enter the following parameters in order:"
    echo
    echo "[1] URL"
    echo "[2] Output file"
    echo "[3] Min word length"
    echo
  fi

}

function main(){
  if [ -n "$1" ]; then
    logo
    if [ -n "$2" ]; then
      if [ -n "$3" ]; then
        wow $1 $2 $3
      fi
    fi
  else
    help main
    echo help
  fi
}

main $1 $2 $3
