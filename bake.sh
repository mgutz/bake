#!/bin/bash

# Finds the directory containing a file.
#
# @param $1 The filename.
# @returns Echos the directory.
function upsearch {
  # from: http://unix.stackexchange.com/questions/13464/is-there-a-way-to-find-a-file-in-an-inverse-recursive-search

  local slashes=${PWD//[^\/]/}
  local directory=$PWD
  for (( n=${#slashes}; n>0; --n )); do
    test -e $directory/$1 && echo $directory && return
    directory=$directory/..
  done
}


# Prints help
function help {
    grep "^function [^_]" $1 | sed "s/function \([a-zA-Z0-9_]*\)[^#]*\(.*\)/\1 \2/g"
}


# Invokes function once
#
# @param {String} $1 Function to invoke.
function invoke {
    local invoked
    eval "invoked=\$$1_invoked"
    if [ ! "$invoked" == "1" ]; then
        eval $1_invoked=1
        eval $1
    fi
}

dirname=`upsearch Bakefile`
bakefile=$dirname/Bakefile
if [ "_$1" == "_" ]; then
  help $bakefile
else
  source $bakefile

  # ensure working directory is from Bakefile
  pushd $dirname >/dev/null
  "$@"
  popd > /dev/null
fi
