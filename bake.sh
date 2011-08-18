#!/bin/bash

# Credit: https://wiki.archlinux.org/index.php/Color_Bash_Prompt

# Reset
C_OFF='\033[0m'       # Text Reset

# Regular Colors
C_BLACK='\033[0;30m'        # Black
C_RED='\033[0;31m'          # Red
C_GREEN='\033[0;32m'        # Green
C_YELLOW='\033[0;33m'       # Yellow
C_BLUE='\033[0;34m'         # Blue
C_PURPLE='\033[0;35m'       # Purple
C_CYAN='\033[0;36m'         # Cyan
C_WHITE='\033[0;37m'        # White

# Bold
C_BBLACK='\033[1;30m'       # Black
C_BRED='\033[1;31m'         # Red
C_BGREEN='\033[1;32m'       # Green
C_BYELLOW='\033[1;33m'      # Yellow
C_BBLUE='\033[1;34m'        # Blue
C_BPURPLE='\033[1;35m'      # Purple
C_BCYAN='\033[1;36m'        # Cyan
C_BWHITE='\033[1;37m'       # White

# Underline
C_UBLACK='\033[4;30m'       # Black
C_URED='\033[4;31m'         # Red
C_UGREEN='\033[4;32m'       # Green
C_UYELLOW='\033[4;33m'      # Yellow
C_UBLUE='\033[4;34m'        # Blue
C_UPURPLE='\033[4;35m'      # Purple
C_UCYAN='\033[4;36m'        # Cyan
C_UWHITE='\033[4;37m'       # White

# Background
C_ON_BLACK='\033[40m'       # Black
C_ON_RED='\033[41m'         # Red
C_ON_GREEN='\033[42m'       # Green
C_ON_YELLOW='\033[43m'      # Yellow
C_ON_BLUE='\033[44m'        # Blue
C_ON_PURPLE='\033[45m'      # Purple
C_ON_CYAN='\033[46m'        # Cyan
C_ON_WHITE='\033[47m'       # White

# High Intensty
C_IBLACK='\033[0;90m'       # Black
C_IRED='\033[0;91m'         # Red
C_IGREEN='\033[0;92m'       # Green
C_IYELLOW='\033[0;93m'      # Yellow
C_IBLUE='\033[0;94m'        # Blue
C_IPURPLE='\033[0;95m'      # Purple
C_ICYAN='\033[0;96m'        # Cyan
C_IWHITE='\033[0;97m'       # White

# Bold High Intensty
C_BIBLACK='\033[1;90m'      # Black
C_BIRED='\033[1;91m'        # Red
C_BIGREEN='\033[1;92m'      # Green
C_BIYELLOW='\033[1;93m'     # Yellow
C_BIBLUE='\033[1;94m'       # Blue
C_BIPURPLE='\033[1;95m'     # Purple
C_BICYAN='\033[1;96m'       # Cyan
C_BIWHITE='\033[1;97m'      # White

# High Intensty backgrounds
C_ON_IBLACK='\033[0;100m'   # Black
C_ON_IRED='\033[0;101m'     # Red
C_ON_IGREEN='\033[0;102m'   # Green
C_ON_IYELLOW='\033[0;103m'  # Yellow
C_ON_IBLUE='\033[0;104m'    # Blue
C_ON_IPURPLE='\033[10;95m'  # Purple
C_ON_ICYAN='\033[0;106m'    # Cyan
C_ON_IWHITE='\033[0;107m'   # White


# Finds the directory containing a file.
#
# @param $1 The filename.
# @returns Assigns the directory to `bake_result`.
upsearch () {
  # from: http://unix.stackexchange.com/questions/13464/is-there-a-way-to-find-a-file-in-an-inverse-recursive-search
  local slashes=${PWD//[^\/]/}
  local directory=$PWD
  for (( n=${#slashes}; n>0; --n )); do
    test -e $directory/$1 && bake_result=$directory && return
    directory=$directory/..
  done
  bake_result=""
}


# Prints task list.
#
# @param $1 Bakefile
task_list () {
    grep "^[^_]\w\+ *().*" $1  | sed "s/[(){]/ /g"
    #grep "^function [^_]" $1 | sed "s/function \([a-zA-Z0-9_]*[^{]*\){*\(.*\)/\1 \2/g"
}


# Invokes function once
#
# @param $1 Function to invoke.
invoke () {
    local invoked
    eval "invoked=\$$1_invoked"
    if [ ! "$invoked" == "1" ]; then
        eval $1_invoked=1
        eval $1
    fi
}

# Prints a log message with no color.
#
# @example
#   bake_log "coffeescript" "compiling" "src/foo/test.coffee"
#
# @param $1 Action
# @param $2 Description
bake_log () {
    echo -e "      $1\t${2}"
}


# Prints an error message.
#
# @param $1 action
# @param $2 description
bake_error () {
    echo -e "${C_RED}ERROR $1\t${C_IRED}${2}${C_OFF}"
}


# Prints an info message.
#
# @param $1 action
# @param $2 description
bake_info () {
    echo -e "${C_CYAN}      $1\t${C_ICYAN}${2}${C_OFF}"
}


# Prints an ok message.
#
# @param $1 action
# @param $2 description
bake_ok () {
    echo -e "${C_GREEN}   OK ${C_IGREEN}$1\t${2}${C_OFF}"
}


# Determines if target file is outdated (older than) reference.
#
# @param $1 target
# @param $2 reference
# @returns 0 if outdated, else 1
outdated() {
    local target=$1
    local reference=$2

    # reference must exist
    [ ! -e $reference ] && bake_error "outdated" "Reference $2 not found" && return 1

    # outdated if target does not exist
    [ ! -e $target ] && return 0

    # outdated if target is older than reference
    [ $target -ot $reference ] && return 0

    return 1
}


# Main entry point into program.
main() {
    upsearch Bakefile
    bakefile_dir=$bake_result
    bakefile=$bakefile_dir/Bakefile

    if [ -f $bakefile ]; then
        if [ "_$1" == "_" ]; then
          task_list $bakefile
        else
          source $bakefile

          # ensure working directory is from Bakefile
          pushd $bakefile_dir >/dev/null
          "$@"
          popd > /dev/null
        fi
    else
        echo Bakefile not found in current or parent directories.
        exit 1
    fi
    unset bakefile
}



main $@
