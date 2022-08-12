#!/bin/sh
#
# Computes statistics about LibJade
# To be run from the root directory of the library (i.e., ./scripts/stats/compute.sh)
# Set the JASMIN environment variable to the appropriate jasminc binary
#
# This will produce, next to each .jazz file, a .csv file with the values of some counters

find -name '*.jazz' | while read p
do
	echo $p
	pushd $(dirname $p) >/dev/null
	make JFLAGS=-pstats | tee $(basename $p .jazz).csv
	popd >/dev/null
done
