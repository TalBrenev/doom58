#!/bin/sh

slack_msg()
{
    curl -X POST -H 'Content-type: application/json' --data '{"text":"'+"$1"+'"}' $SLACK_HOOK
}

verilator --lint-only *.v > results.txt 2>&1

if [ -z "$(cat results.txt)" ] ; then
    slack_msg "Lint on branch" $GITHUB_REF "passed!"
    exit 0
else
    msg="Lint on branch" $GITHUB_REF "failed:"
    msg=$msg+"$(cat results.txt)"
    exit 1
fi
