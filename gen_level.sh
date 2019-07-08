#! /bin/sh

# Example usage:
# ./gen_level.sh 0 1 2

for num in $@; do
    python3 gen_level.py "levels/$num.txt" "level_$num" > "level_$num.v"
done
