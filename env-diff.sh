#!/bin/bash

# Create a temporary file to store keys in the second file
keys_in_file2=$(mktemp)

# Process the second file (the new env)
cat "${2}" | tr -s '\n' | while read line || [[ -n ${line} ]]; do
    check_is_start_with_comment=$(echo ${line} | grep "^#")
    if [[ -n ${check_is_start_with_comment} ]]; then
        continue;
    fi

    key=(${line//=/ })
    echo "${key[0]}=${key[1]}"
    echo "${key[0]}" >> ${keys_in_file2}
done

# Process the first file (the old env)
cat "${1}" | tr -s '\n' | while read line || [[ -n ${line} ]]; do
    check_is_start_with_comment=$(echo ${line} | grep "^#")
    if [[ -n ${check_is_start_with_comment} ]]; then
        continue;
    fi

    key=(${line//=/ })
    value=${line/$key'='/}

    # If the key exists in the second file, skip this line
    exists=$(grep "^${key[0]}$" ${keys_in_file2})
    if [[ -n ${exists} ]]; then
        continue
    fi

    echo "${key[0]}=${value}"
done

# Process the second file again to add keys not found in the first file
cat "${2}" | tr -s '\n'  | while read line || [[ -n ${line} ]]
do
    a=$(echo ${line} | grep "^#")
    if [[ -n ${a} ]]; then
        continue;
    fi

    key=(${line//=/ })
    data=$(grep "${key[0]}=" $1)
    value=${line/$key'='/}

    # If data is empty string and the value is not "value_undefined_flag"
    if [[ -z ${data} ]] && [[ ${value} != "value_undefined_flag" ]]; then
        echo "${key[0]}=${value}"
    fi
done

# Remove the temporary file
rm ${keys_in_file2}
