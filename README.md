# Bake

Simple make utility for bash


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
* Prefix private functions ith underscore `_`. These are not displayed in task list.
* Use `invoke` to invoke a task only once.

## Example

Example Bakefile

    function _private {         # underscored functions do not display
        echo in private
    }

    function clean {            # cleans the project
        echo cleaning ...
        _private
    }

    function build {            # builds the project
        # invokes clean only once
        invoke "clean"
        echo building ...
    }



