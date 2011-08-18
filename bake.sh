#!/bin/bash

# Finds the directory containing a file.
#
# @param $1 The filename.
# @returns Echos the directory.
upsearch () {
  # from: http://unix.stackexchange.com/questions/13464/is-there-a-way-to-find-a-file-in-an-inverse-recursive-search

  local slashes=${PWD//[^\/]/}
  local directory=$PWD
  for (( n=${#slashes}; n>0; --n )); do
    test -e $directory/$1 && echo $directory && return
    directory=$directory/..
  done
}


# Prints help
task_list () {
    grep "^[^_]\w\+ *().*" $1  | sed "s/[(){]/ /g"
    #grep "^function [^_]" $1 | sed "s/function \([a-zA-Z0-9_]*[^{]*\){*\(.*\)/\1 \2/g"
}


# Invokes function once
#
# @param {String} $1 Function to invoke.
invoke () {
    local invoked
    eval "invoked=\$$1_invoked"
    if [ ! "$invoked" == "1" ]; then
        eval $1_invoked=1
        eval $1
    fi
}

# Logs a statement with ansi colors.
#
# @example
#   bake_log "coffeescript" "compiling" "src/foo/test.coffee"
#
# @param {String} $1 One word task description.
# @param {String} $2 Full description.
bake_log () {
    echo TBD
}


# Logs an error with ansi colors.
bake_error () {
    echo TBD
}

dirname=`upsearch Bakefile`
bakefile=$dirname/Bakefile
if [ -f $bakefile ]; then
    if [ "_$1" == "_" ]; then
      task_list $bakefile
    else
      source $bakefile

      # ensure working directory is from Bakefile
      pushd $dirname >/dev/null
      "$@"
      popd > /dev/null
    fi
else
    echo Bakefile not found in current or parent directories.
    exit 1
fi

unset dirname
unset bakefile
