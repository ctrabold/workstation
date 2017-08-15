#!/bin/bash

set -e

for file in *.webm; do
  echo $file
  ffmpeg -i "$file" -ab 128k -ar 44100 -y "${file}.mp3"
done
