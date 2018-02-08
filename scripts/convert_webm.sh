#!/bin/bash

for FILE in *.webm *.mkv; do
  echo $FILE
  # ffmpeg -i "$FILE" -b:a 128k -vcodec mpeg4 -b:v 1200k -flags +aic+mv4 "${FILE}.mp4"
  avconv -i "$FILE" "${FILE}.mp4"
done
