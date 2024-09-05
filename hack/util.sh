#!/bin/bash

list_module_details() {
    find . -mindepth 2 -name go.mod \
    | xargs -n 1 -I{} bash -c 'GOMODPATH={}; head -1 $GOMODPATH | awk -v mod=`dirname $GOMODPATH` '"'"'{ print mod","$2 }'"'"''
}

list_module_dirs() {
    find . -mindepth 2 -name go.mod | xargs dirname
}

