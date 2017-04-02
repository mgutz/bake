# Bake

Simple Bash build/project utility in the style of rake.

Not trying to reinvent wheel. Most node project Makefiles are just
Bash scripts.


## Installation

    npm install bake-bash


# Usage

Display tasks

    bake

Run task

    bake <task>


## Example Bakefile

```sh
function private {
    echo in private
}

#. Builds the project
function build {
    # ensures clean is called only once
    bake-invoke "clean"
    bake-ok building ...
    # clean will not run again
    bake-invoke "clean"
}

#. Cleans the project
function clean {
    bake-ok "cleaning ..."
    private
}

#. Renders hello-template.sh
function render-template {
    bake-ok "compiling template ..."
    bake-render-template hello-template.sh | cat
    bake-ok "coffe" "compiled"
}

function on-task-not-found {
    echo "Task not found $1"
}
```

## Rules

* `bake` searches the current and parent directories for a `Bakefile` to run.
* Tasks are defined as normal Bash functions.
* A task description is simply a comment that starts with `#.` and precedes
  a function.


## Functions

Prints a red error message.

    bake-error <action> <description>

    example: bake-error "compiling" "src/lib/test.coffee"

Prints a plain message.

    bake-log <action> <description>

    example: bake-log "bake" "Processing bakefile..."

Prints a green ok message.

    bake-ok <action> <description>

    example: bake-ok "compiling" "compiled src/lib/test.js"

Prints a cyan info message.

    bake-info <action> <description>

    example: bake-info "bake" "built project in 700ms"

Invokes a task only once.

    bake-invoke <function_name>

    example: bake-invoke "clean"

Determines if target is older than reference, returning 1 if outdated.

    bake-outdated <target> <reference>

    examples:

    bake-outdated build src || return 1      # skip rest of task
    outdated build src && invoke "compile"  # compile if outdated

Renders a heredoc file template

    bake-render-template template.sh > newfile.txt

Run a dynamic task when task `$1` is not found. For example, to run
a test as the first argument to `bake`, add this to `Bakefile`

```sh
function on-task-not-found {
    [[ -f test/$1.js ]] && mocha test/$1.js && return 0
    return 1
}
```
