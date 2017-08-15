#!/bin/bash

for FILE in ls *.mp4; do
  echo $FILE
  ffmpeg -i "$FILE" -vn -c:a copy "${FILE}.m4a"
done
