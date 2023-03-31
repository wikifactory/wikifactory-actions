# !/bin/bash

# handle changed env
cat "${1}" | tr -s '\n' | while read line || [[ -n ${line} ]]; do
    a=$(echo ${line} | grep "^#")
    if [[ -n ${a} ]]; then
        continue;
    fi

    key=(${line//=/ })
    data=$(grep "${key[0]}=" $2)
    value=${line/$key'='/}

    key2=(${data//=/ })
    value2=${data/$key2'='/}

    if [[ -z $value2 ]]; then
        echo "${key[0]}=${value}"
        >&2 echo "${key[0]}=${value}"
        continue
    fi

    if [[ ${key[0]} == ${key2[0]} ]] && [[ ${key[1]} != ${value2} ]] && [[ ${value2} != "value_undefined_flag" ]]; then
        echo "${key[0]}=${value2}"
        >&2 echo "${key[0]}=${value2}"
    else
        echo "${key[0]}=${value}"
        >&2 echo "${key[0]}=${value}"
    fi
done

cat "${2}" | tr -s '\n'  | while read line || [[ -n ${line} ]]
do
    a=$(echo ${line} | grep "^#")
    if [[ -n ${a} ]]; then
        continue;
    fi

    key=(${line//=/ })
    data=$(grep "${key[0]}=" $1)
    value=${line/$key'='/}

    # if data is empty string
    if [[ -z ${data} ]] && [[ ${value} != "value_undefined_flag" ]]; then
        echo "${key[0]}=${value}" >> .env.diff
    fi
done
