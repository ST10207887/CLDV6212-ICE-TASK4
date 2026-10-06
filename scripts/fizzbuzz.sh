#!/usr/bin/env bash
# FizzBuzz 1-20
#   divisible by 3 and 5 -> FizzBuzz
#   divisible by 3       -> Fizz
#   divisible by 5       -> Buzz
#   otherwise            -> the number

for (( i = 1; i <= 20; i++ )); do
    if (( i % 15 == 0 )); then        # divisible by both 3 and 5
        echo "FizzBuzz"
    elif (( i % 3 == 0 )); then
        echo "Fizz"
    elif (( i % 5 == 0 )); then
        echo "Buzz"
    else
        echo "$i"
    fi
done
