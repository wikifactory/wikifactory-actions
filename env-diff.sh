#!/bin/bash

keys_in_file2=$(mktemp)

get_key() {
    echo "$1" | cut -d= -f1
}

get_value() {
    echo "$1" | cut -d= -f2-
}

cat "$2" | tr -s '\n' | while read line || [[ -n $line ]]; do
    if [[ $line == \#* ]]; then
        continue
    fi

    key=$(get_key "$line")
    value=$(get_value "$line")

    if [[ $value == "value_undefined_flag" ]]; then
        continue
    fi

    echo "$key=$value"
    echo "$key" >> $keys_in_file2
done


cat "$1" | tr -s '\n' | while read line || [[ -n $line ]]; do
    if [[ $line == \#* ]]; then
        continue
    fi

    key=$(get_key "$line")
    value=$(get_value "$line")

    exists=$(grep "^$key$" $keys_in_file2)
    if [[ -n $exists ]]; then
        continue
    fi

    echo "$key=$value"
done

rm $keys_in_file2
