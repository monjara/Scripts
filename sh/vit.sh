#!/bin/sh

if [ ! $1 ]; then
  tttt | xargs -o nvim
else
  tttt --ext $1 | xargs -o nvim
fi

