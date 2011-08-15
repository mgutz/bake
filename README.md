# Bake

Simple make utility using bash

Many of the makefiles for node.js projects seem to be nothing more
than runners for bash. `bake` lets you manage simple projects with bash.

## Installation

    npm install bake

## Usage

Display tasks

    bake

Run a task

    bake <task>


## Example

Example Bakefile

    function clean {            # Clean the project
        echo cleaning ...
    }


    function build {            # Build the project
        # invokes clean only once
        invoke "clean"
        invoke "clean"
        echo building ...
    }

Function should have a comment on the same line.
