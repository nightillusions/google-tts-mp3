#!/bin/bash
shopt -s nullglob

MP3_FOLDER=./mp3

for FILE in ./text/*.json
do
  FILENAME=${FILE##*/}
  NAME=${FILENAME%.*}
  LANGCODE=`cat $FILE | jq -r ".voice.languageCode | tostring"`
  VOICE=`cat $FILE | jq -r ".voice.ssmlGender | tostring"`

  echo "Processing ${FILENAME} file with language ${LANGCODE} and ${VOICE}..."
  
  curl -X POST \
  -H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
  -H "Content-Type: application/json; charset=utf-8" \
  -d @$FILE \
  https://texttospeech.googleapis.com/v1/text:synthesize | \
  jq -r '.audioContent | tostring' | \
  base64 --decode > "${MP3_FOLDER}/${NAME}.mp3"
done
