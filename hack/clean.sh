#!/bin/bash

export GOWORK=off

ROOT=$(dirname "${BASH_SOURCE[0]}")/..
source "${ROOT}/hack/util.sh"


require_and_replace_directives() {
    local rel_to=$1
    for mod in $(list_module_details); do
        local mod_name=`echo $mod | awk -F, '{ print $2}'`
        local mod_path=`echo $mod | awk -F, '{ print $1}'`
        local relpath=$mod_path

        # calculated the submodule path relative to another submodule
        if [ "$rel_to" != "." ]; then
            relpath=`realpath --relative-to="$rel_to" "$mod_path"`
        fi

        echo "-require $mod_name@v0.0.0"
        echo "-replace $mod_name=$relpath"
    done
}

prune_replace_directives() {
    comm -23 \
    <(go mod edit -json | jq -r '.Replace[] | select(.New.Path | startswith("./") | not) | .Old.Path' | sort) \
    <(go list -m -json all | jq -r .Path | sort) |
    while read -r X; do echo "-dropreplace=${X}"; done |
    xargs -L 100 go mod edit -fmt
}


(
    IFS=$'\n'
    # update main module go.mod
    require_and_replace_directives . | xargs -L 100 go mod edit -fmt

    #update sub modules go.mod 
    for mod_dir in $(list_module_dirs); do
        (   
            directives=$(require_and_replace_directives "$mod_dir")

            cd "$mod_dir"

            echo "$directives" | xargs -L 100 go mod edit -fmt

            go mod tidy 2> /dev/null
            prune_replace_directives
        )
    done
)
(
    unset GOWORK
    unset GOFLAGS
    go work sync
    go mod tidy 2> /dev/null
)