#!/bin/bash
if [ ! -d tools/viewer/build ]; then 
    build_scripts/build_viewer.sh
fi;
tools/viewer/build/start.sh