#!/usr/bin/env bash

SCRIPTDIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
LIBJADE_ROOT="$SCRIPTDIR/.."
LIBJADE_SRC="$LIBJADE_ROOT/src"

if [ -e "$LIBJADE_SRC" ];then
  rm -r "$LIBJADE_SRC"
fi

for SUBMODULE in "$LIBJADE_ROOT"/submodules/formosa-*;do
  EXTRACT="$SUBMODULE/extract-libjade.sh"
  for IMPLEMENTATION in $($EXTRACT --list-implementations); do

    IMPLPATH="$LIBJADE_SRC/$IMPLEMENTATION"
    FUNC=$(echo "$IMPLEMENTATION" | sed "s/crypto_\([^\/]*\).*/\1/")
    JAZZFILE=$FUNC.jazz
    RELSTRING=$(echo "$IMPLEMENTATION" | sed "s/[^\/]*/../g")
    echo $RELSTRING

    if [ -e "$IMPLPATH" ];then
      echo "Error: $IMPLPATH already exists"
    else
      mkdir -p "$IMPLPATH"
      mkdir "$IMPLPATH/include"
      $EXTRACT --gen-implementation "$IMPLEMENTATION" "$IMPLPATH"

      echo "SRCS := $JAZZFILE" > "$IMPLPATH/Makefile"
      echo "include $RELSTRING/build-common/Makefile.common" >> "$IMPLPATH/Makefile"
    fi
  done
done
