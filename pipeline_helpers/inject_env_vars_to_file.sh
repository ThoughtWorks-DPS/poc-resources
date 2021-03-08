#!/bin/bash

runpath=$(dirname $0)
templateFile=""
outputFile=""

function usage {
    echo "$0 [--var|-v <key value>] [--in-file|-i <file_to_inject.json.tpl>] [--out-file|-o <output_file.json>]"
    echo "  --var|-v      key-value pair to inject (key value)"
    echo "  --in-file|-i  file to inject into"
    echo "  --out-file|-o output file"
    echo "  --help        display this help"
    echo "  NOTE: If --out-file is not supplied, will use 'file_to_inject.json' without the .tpl extension"
}

function inject_env_vars_to_file {
    local file=$1
    local sedFile=$2
    local outputFile=${3:-${file//.tpl}}
    sed -f "${sedFile}" "${file}" > "${outputFile}"
}

function create_sed_from_env {
    local file=$1
    env | sed -e "s:\(.*\)=\(.*\):s%{{[ ]*\1[ ]*}}%\2%:" > "${file}"
}

sedfile=$(mktemp /tmp/sedfile.XXXXXX)
create_sed_from_env "${sedfile}"

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

inject_env_vars_to_file "${templateFile}" "${sedfile}" "${outputFile}"

# Make sure we clean up our secrets before we go
trap "rm -f ${sedfile}" EXIT