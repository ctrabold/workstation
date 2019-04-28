#!/bin/bash

for FILE in *.ogg *.opus; do
  if [[ -f "$FILE.mp3" ]]; then
    echo "$FILE"
  else
    echo "Converting..."
    avconv -i "$FILE" "${FILE}.mp3"
  fi
done
