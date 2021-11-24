#!/bin/zsh

if ! [ $# = 3 ]; then
    echo "Usage: $0 model.spthy timelimit lemma"
    exit 1
fi

model=$1
timelimit=$2
lemma=$3

heuristics=("s" "c" "i" "S" "C" "I" "cs" "is")

for heuristic in $heuristics; do
    echo -n "$(date) Trying heuristic '$heuristic' "
    output=$(mktemp)
    timeout --signal=KILL --foreground "$timelimit" tamarin-prover "$model" --prove="$lemma" --heuristic=$heuristic 2>/dev/null > $output
    if [ $? = 124 ]; then
        echo "Timed out after $3 and was killed"
    else 
        result=$(grep -o "verified ([0-9]\+ steps)" $output)
        echo "Success! $result"
    fi
    rm $output
done
