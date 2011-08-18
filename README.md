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

* `bake` searches the current and parent directories for a  `Bakefile` to run.
* Tasks are functions.
* A comment on the same line of the function displays in the task list.
* Prefix private functions with underscore `_`. These are not displayed in task list.
* Use `invoke` to invoke a task only once.


## Functions

Prints a plain message
`bake_log <action> <description>`

Prints a red error message
`bake_error <action> <description>`

Prints a green ok message
`bake_ok <action> <descsription>`

Prints a cyan info message
`bake_info <action> <description>`

Determines if target is older than reference. Returns 1 if outdated.
`outdated <target> <reference>`

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
