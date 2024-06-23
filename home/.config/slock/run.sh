#!/usr/bin/env bash

set -e

if [[ -z "${FLEXIPATCH}" ]]; then
  echo "FLEXIPATCH not set"
  exit 1
fi

cd "$FLEXIPATCH-flexipatch"

git apply "../$FLEXIPATCH.patch"

if [ ! -f config.h ] || ! cmp -s config.def.h config.h; then
  sudo cp config.def.h config.h
fi
if [ ! -f patches.h ] || ! cmp -s ../patches.h patches.h; then
  sudo cp ../patches.h patches.h
fi

sudo cp "$FLEXIPATCH" "../$FLEXIPATCH.bak"
sudo make install

if [ "$(md5sum "../$FLEXIPATCH.bak" | cut -d ' ' -f1)" != "$(md5sum "$FLEXIPATCH" | cut -d ' ' -f1)" ]; then
  echo "TASK_CHANGED"
fi

git apply "../$FLEXIPATCH.patch" --reverse
