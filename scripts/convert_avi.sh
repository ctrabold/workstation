#!/bin/bash

for FILE in ls *.avi; do
  echo $FILE
  avconv -i "$FILE" "${FILE}-aconv.mp4"
done
