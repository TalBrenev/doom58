#!/bin/sh

slack_msg()
{
    data="{\"text\":\"$1\"}"
    curl -X POST -H 'Content-type: application/json' --data "$data" $SLACK_HOOK
}

verilator --lint-only *.v > results.txt 2>&1

if [ -z "$(cat results.txt)" ] ; then
    slack_msg "Lint on branch $GITHUB_REF passed!"
    exit 0
else
    slack_msg "Lint on branch $GITHUB_REF failed:\n$(cat results.txt | tr -d "\"")"
    exit 1
fi
