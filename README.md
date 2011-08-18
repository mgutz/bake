# Bake

Simple make-like utility for bash


## Installation

    npm install bake-bash

Or,

    git clone https://github.com/mgutz/bake
    sudo ln -sf `pwd`/bake/bake.sh /usr/local/bin/bake

## Usage

Display tasks

    bake

Run a task

    bake <task>

## Rules

* `bake` searches the current and parent directories for a `Bakefile` to run.
* Tasks are functions.
* A comment on the same line of the function displays in the task list.
* Prefix private functions with underscore `_`. These are not displayed in task list.


## Functions

Prints a red error message.

    bake_error <action> <description>

    example: bake_error "compiling" "src/lib/test.coffee"

Prints a plain message.

    bake_log <action> <description>

    example: bake_log "bake" "Processing bakefile..."

Prints a green ok message.

    bake_ok <action> <descsription>

    example: bake_ok "compiling" "compiled src/lib/test.js"

Prints a cyan info message.

    bake_info <action> <description>

    example: bake_info "bake" "built project in 700ms"

Invokes a task only once.

    invoke <function_name>

    example: invoke "clean"

Determines if target is older than reference, returning 1 if outdated.

    outdated <target> <reference>

    examples:

    outdated build src || return 1          # skip rest of task
    outdated build src && invoke compile    # compile if outdated


## Example

Example Bakefile

    _private() {         # underscored functions do not display in task list
        echo in private
    }


    clean() {            # cleans the project
        echo cleaning ...
        _private
    }


    build() {            # builds the project
        # invokes a function once, otherwise call function directly
        invoke "clean"
        echo building ...
    }


    coffeescripts() {    # compiles coffee scripts
        outdated build src || return 0
        coffee -c -o build src
        bake_ok "coffee" "compiled"
    }
