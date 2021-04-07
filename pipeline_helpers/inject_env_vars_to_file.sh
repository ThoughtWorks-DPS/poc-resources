#!/bin/bash

runpath=$(dirname $0)
templateFile=""
outputFile=""
sedDelimiter='%'

function usage {
    echo "$0 [--var|-v <key> <value>] [--in-file|-i <file_to_inject.json.tpl>] [--out-file|-o <output_file.json>]"
    echo "  --var|-v      key-value pair to inject [will override keys from environment] (key value)"
    echo "  --in-file|-i  file to inject into"
    echo "  --out-file|-o output file"
    echo "  --help        display this help"
    echo "  NOTE: If --out-file is not supplied, will use 'file_to_inject.json' without the .tpl extension"
}

function inject_env_vars_to_file {
    local file=$1
    local sedFile=$2
    local outputFile=${3:-${$(basename file)//.tpl}}
    sed -f "${sedFile}" "${file}" > "${outputFile}"
}

function create_sed_from_env {
    local file=$1
    for i in `compgen -v`
    do
        if [ ! "${i}" == "IFS" -a ! "${i}" == "COMP_WORDBREAKS" -a ! "${i}" == "sedDelimiter" ];
        then
            local key=${i}
            local value=$(echo "${!i}" | sed -e '$ ! s/$/\\/')
            # Remove this when we fix how we store the REVOCATION_CERT in AWS Secrets
            #if [ "${i}" == "REVOCATION_CERT" ]; then value="${value}
#Comment: Fix newline"; fi

            echo "s${sedDelimiter}{{[ ]*${key}[ ]*}}${sedDelimiter}${value}${sedDelimiter}" >> "${file}"
        fi
    done
}

sedfile=$(mktemp /tmp/sedfile.XXXXXX)

while [ $# -gt 0 ]
do
    case $1 in
    --var|-v)
        shift;
        key=$1;
        value=$2;
        echo "s%{{[ ]*$key[ ]*}}%$value%" >> "${sedfile}"
        shift;;
    --in-file|-i)
        shift;
        templateFile=$1;;
    --out-file|-o)
        shift;
        outputFile=$1;;
    --help|-h) usage; exit 0;;
    *) usage; exit -1;;
    esac
    shift;
done

create_sed_from_env "${sedfile}"

inject_env_vars_to_file "${templateFile}" "${sedfile}" "${outputFile}"

# Make sure we clean up our secrets before we go
trap "rm -f ${sedfile}" EXIT