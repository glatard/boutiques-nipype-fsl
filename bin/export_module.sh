#!/bin/bash

if [ $# != 4 ]
then
    echo "usage: $0 <module_name> <docker_image> <ignore_file> <skip_file>"
    echo "  module_name: Nipype module where to extract interfaces."
    echo "  docker_image: name of the Docker image (stored in Docker Hub) where the module is available."
    echo "  ignore_file: csv file with two columns: (1) interface name, (2) value to pass to option '-t' of nipype2boutiques."
    echo "  skip_file: text file containing the list of interfaces to skip."
  exit 1
fi

MODULE=$1 
DOCKER_IMAGE=$2
IGNORE_FILE=$3
SKIP_PRESENT=true
SKIP_FILE=$4

for INTERFACE in `./nipype_cmd ${MODULE} | sed 1d | sort`
do
    # Check the skip file.
    A=`awk -v I=${INTERFACE} '$1==I {print}' ${SKIP_FILE}` 
    if [ "${A}" != "" ]
    then
	echo
	echo "XXX Skipping ${INTERFACE} (as it is in ${SKIP_FILE})."
	continue
    fi
    # Check if interface was already generated.
    if [ "${SKIP_PRESENT}" = "true" ]
    then
	test -f ${INTERFACE}.json
	if [ $? = 0 ]
	then
	    echo
	    echo "XXX Skipping ${INTERFACE} (as ${INTERFACE}.json already exists)."
	    continue
	fi
    fi

    echo 
    echo "||| Generating ${INTERFACE}"
    # Check fields to ignore in path template generation.
    IGNORE=`awk -F ',' -v I=${INTERFACE} '$1==I {print $2}' ${IGNORE_FILE}`
    IGNORE_OPTION=""
    if [ "${IGNORE}" != "" ]
    then
	IGNORE_OPTION="-t ${IGNORE}"
    fi
    echo ./nipype2boutiques -v -n -m ${MODULE} -i ${INTERFACE} -o ${INTERFACE}.json -d ${DOCKER_IMAGE} -r http://index.docker.io ${IGNORE_OPTION}
    ./nipype2boutiques -v -n -m ${MODULE} -i ${INTERFACE} -o ${INTERFACE}.json -d ${DOCKER_IMAGE} -r http://index.docker.io ${IGNORE_OPTION}
    if [ $? != 0 ]
    then
	echo "!!! Cannot generate interface ${INTERFACE}."
	exit 1
    fi
done
