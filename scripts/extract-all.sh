#!/usr/bin/env bash

SCRIPTDIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
LIBJADE_ROOT="$SCRIPTDIR/.."

for SUBMODULE in "$LIBJADE_ROOT"/submodules/formosa-*;do
  EXTRACT="$SUBMODULE/extract-libjade.sh"
  for IMPLEMENTATION in $($EXTRACT --list-implementations); do
    $EXTRACT --gen-implementation "$IMPLEMENTATION" "$LIBJADE_ROOT/src/$IMPLEMENTATION"
  done
done
