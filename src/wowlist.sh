#!/bin/bash

# Paths
SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
PROJECT_DIR=$(dirname "$SCRIPT_DIR")
OUT_DIR="${PROJECT_DIR}/out"
OUT_PATH="${OUT_DIR}/out.txt"
FILTERED_PATH="${OUT_DIR}/filtered.txt"
FORMAT_PATH="${SCRIPT_DIR}/format.csv"

# Inputs
SYMS=( '!' '#' '&' '*'
       '-' '_' '=' '+'
       ',' '.' '?' '~' '|' )
NUMS=(1 2 3 4 5 6 7 8 9 0)
SPACE=" "
FORMAT=()

# Placeholders
FILTERED=()
PERM=()

# Throws a specified exception.
#
# Parameters:
#   1 - An exception
# Returns:
#   None
function throw_exec(){
  if [ "$1" = "params" ]; then
    echo "[ERR] Requires valid parameters."
    help params
    exit
  elif [ "$1" = "url" ]; then
    echo "[ERR] Missing URL."
    help url
    exit
  elif [ "$1" = "len" ]; then
    echo "[ERR] Missing min word length."
    help len
    exit
  elif [ "$1" = "dep" ]; then
    echo "[ERR] Missing crawl depth."
    help dep
    exit
  elif [ "$1" = "dur" ]; then
    echo "[ERR] Missing crawl duration."
    help dur
    exit
  fi
}

# Displays the logo.
#
# Returns:
#   None
function logo(){
RED='\033[31m'
NC='\033[0m'
printf "${RED}"
cat << 'EOF'
 __      __.____
/  \    /  \    |
\   \/\/   /    |
 \        /|    |___
  \__/\  / |_______ \
       \/          \/
EOF
printf "${NC}"
}

# Iterates through array rows.
#
# Returns:
#   None
function iterate_rows(){
  for rowname in "${FORMAT[@]}"; do
    eval "cols=(\"\${$rowname[@]}\")"

    for i in "${!cols[@]}"; do
      if [ "$i" -eq 0 ]; then
        printf "${cols[$i]}: "
      else
        printf "${cols[$i]}\n"
      fi
    done
  done
}

function apply(){
  echo
}

function permutate(){
  echo
}

# Combines filtered words.
#
# Results:
#   None
function findformats(){
  echo '[!] Grabbing formatting.'

  local row=0
  local -a fields
  FORMAT=() # reset

  while IFS=',' read -r -a fields; do
    local rowname="row_$row"
    FORMAT+=("$rowname") # create the row array dynamically
    eval "$rowname=()"
    for i in "${!fields[@]}"; do
      eval "$rowname[$i]=\"${fields[$i]}\""
    done
    ((row++))
  done < "$FORMAT_PATH"

  echo '[!] Formatting acquired.'
  iterate_rows "${FORMAT[@]}"
}

# Combines filtered words based on formatting.
#
# Returns:
#   None
function combine(){
  echo '[!] Combining filtered words ...'

  findformats
  permutate
  apply

  echo '[!] Finished combining words ...'
}

# Filters the found words.
#
# Parameters:
#   1 - The chosen minimum word length
# Returns:
#   None
function filter(){
  echo '[!] Filtering found words ...'

  len="$1"
  next=$((len++))
  FILTERED=()

  while IFS= read -r line; do
    if [ "${#line}" -eq "$len" ]; then
      FILTERED+=("$line")
      echo "$line" >> "$FILTERED_PATH"
    elif [ "${#line}" -eq "$next" ]; then
      FILTERED+=("$line")
      echo "$line" >> "$FILTERED_PATH"
    fi
  done < "$OUT_PATH"
  echo '[!] Finished filtering.'
}

# Grabs words from websites with CEWL.
#
# Parameters:
#   1 - A full URL
#   2 - A minimum word length
#   3 - A maximum crawl depth
#   4 - A run duration
# Returns:
#   None
function grab(){
  echo '[!] Grabbing words ...'
  sudo timeout --signal=INT "$4" cewl "$1" -w "$OUT_PATH" -m $2 --with-numbers -d $3
}

# Runs wowlist.
#
# Parameters:
#   1 - A full URL
#   2 - A minimum word length
#   3 - A maximum crawl depth
#   4 - A run duration
# Returns:
#   None
function wow(){

  grab $1 $2 $3 $4
  filter $2
  combine
}

# Displays the section help.
#
# Parameters:
#   1 - A section
# Returns:
#   None
function help(){
  if [ "$1" = "params" ]; then
    logo
    echo
    echo "|--------------------------------------------------|"
    echo "| Welcome to the WowList wordlist generation tool. |"
    echo "|                                                  |"
    echo "| Enter the following parameters in order:         |"
    echo "|                                                  |"
    echo "|     [1] Full URL                                 |"
    echo "|     [2] Min Word Length                          |"
    echo "|     [3] Max Crawl Depth                          |"
    echo "|     [4] Run Duration                             |"
    echo "|--------------------------------------------------|"
    echo
  elif [ "$1" = "url" ]; then
    logo
    echo
    echo "|----------------------------------------------|"
    echo "| You need to indicate a valid URL for wowlist |"
    echo "| to spider.                                   |"
    echo "|                                              |"
    echo "| * - Required                                 |"
    echo "| $ - Optional                                 |"
    echo "|                                              |"
    echo "|     [*] Scheme (ex. 'https://')              |"
    echo "|     [*] Subdomain (ex. 'www.')               |"
    echo "|     [*] Domain (ex. 'target.com')            |"
    echo "|     [$] Path/Port (ex: '/careers')           |"
    echo "|     [$] Query (ex. '/search?q=')             |"
    echo "|----------------------------------------------|"
    echo
  elif [ "$1" = "len" ]; then
    logo
    echo
    echo "|----------------------------------------------|"
    echo "| You need to indicate the minimum word length |"
    echo "| for wowlist to process.                      |"
    echo "|                                              |"
    echo "| Enter an integer as the second parameters.   |"
    echo "|                                              |"
    echo "|     [!] Integers only                        |"
    echo "|     [!] URL may not contain words that long  |"
    echo "|----------------------------------------------|"
    echo
  elif [ "$1" = "dep" ]; then
    logo
    echo
    echo "|----------------------------------------------|"
    echo "| You need to indicate the maximum crawl depth |"
    echo "| for wowlist to spider.                       |"
    echo "|                                              |"
    echo "| Enter an integer as the third parameters.    |"
    echo "|                                              |"
    echo "|     [!] Integers only                        |"
    echo "|     [!] URL may not have that depth          |"
    echo "|----------------------------------------------|"
    echo
  elif [ "$1" = "dur" ]; then
    logo
    echo
    echo "|----------------------------------------------|"
    echo "| You need to indicate how long wowlist will   |"
    echo "| search for words (in seconds).               |"
    echo "|                                              |"
    echo "| Enter an integer as the fourth parameters.   |"
    echo "|                                              |"
    echo "|     [!] Integers only                        |"
    echo "|     [!] Events may conclude before timer.    |"
    echo "|----------------------------------------------|"
    echo
  fi
}

# Resolves wowlist directories.
#
# Returns:
#   None
function diresolve(){
  echo "[!] Resolving directory structure ..."
  if [ ! -d "$OUT_DIR" ]; then
    echo "[!] Creating output directory."
    mkdir -p "$OUT_DIR"
  fi
  echo "[!] Prepping output file."
  touch "$OUT_PATH"
}

# Resolves wowlist dependencies.
#
# Returns:
#   None
function pkgresolve(){
  echo "[!] Resolving dependencies ..."
  reqs="${PROJECT_DIR}/requirements.txt"
  while IFS= read -r pkg; do
      sudo apt-get install "${pkg}" -y > /dev/null
  done < "$reqs"
  echo "[!] Requirments satisfied."
}

# Defines the main function.
#
# Parameters:
#   1 - A full URL
#   2 - A minimum word length
#   3 - A maximum crawl depth
#   4 - A run duration
# Returns:
#   None
function main(){
  clear
  if [ -n "$1" ]; then
    if [ -n "$2" ]; then
      if [ -n "$3" ]; then
	if [ -n "$4" ]; then
          logo
	  diresolve
	  pkgresolve
          wow $1 $2 $3 $4
	else
	  throw_exec "dur"
	fi
      else
        throw_exec "dep"
      fi
    else
      throw_exec "len"
    fi
  else
    throw_exec "url"
  fi
  exit
}

main $1 $2 $3 $4
