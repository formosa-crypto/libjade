#!/usr/bin/env bash

SCRIPTDIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
LIBJADE_ROOT="$SCRIPTDIR/.."
LIBJADE_SRC="$LIBJADE_ROOT/src"

rm -r "$LIBJADE_SRC"

for SUBMODULE in "$LIBJADE_ROOT"/submodules/formosa-*;do
  EXTRACT="$SUBMODULE/extract-libjade.sh"
  for IMPLEMENTATION in $($EXTRACT --list-implementations); do

    IMPLPATH="$LIBJADE_SRC/$IMPLEMENTATION"

    if [ -e "$IMPLPATH" ];then
      echo "Error: $IMPLPATH already exists"
    else
      mkdir -p "$IMPLPATH"
      $EXTRACT --gen-implementation "$IMPLEMENTATION" "$IMPLPATH"
    fi
  done
done
