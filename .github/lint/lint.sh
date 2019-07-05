#!/bin/sh

verilator --lint-only *.v > results.txt 2>&1

if [ -z "$(cat results.txt)" ] ; then
    echo "Lint on branch" $GITHUB_REF " passed!"
    exit 0
else
    echo "Lint on branch" $GITHUB_REF " failed:"
    cat results.txt
    exit 1
fi
