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
* Tasks are defined as a normal function using the keyword `function some_task`
* A comment on the same line of the function displays in the task list.
* Private functions are declared with `some_function ()`. These are not displayed in task list.

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
    outdated build src && invoke "compile"  # compile if outdated


## Example

Example Bakefile

    # Private functions use the alternate form of function declaration.
    private() {
        echo in private
    }


    function clean {            # cleans the project
        echo cleaning ...
        _private
    }


    function build {            # builds the project
        # invokes a function once, otherwise call function directly
        invoke "clean"
        echo building ...
    }


    function coffeescripts {    # compiles coffee scripts
        outdated build src || return 0
        coffee -c -o build src
        bake_ok "coffee" "compiled"
    }
