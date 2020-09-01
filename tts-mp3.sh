#!/bin/bash
shopt -s nullglob

text_to_speech(){
  MP3_FOLDER=./mp3

  FILE=$1
  SUBFOLDER_WITH_FILE=${FILE#./*/}
  FOLDER=${SUBFOLDER_WITH_FILE%/*.json}
  FILENAME=${FILE##*/}
  NAME=${FILENAME%.*}
  LANGCODE=`cat $FILE | jq -r ".voice.languageCode | tostring"`

  echo "Processing ${FILENAME} file with language ${LANGCODE}..."
  
  curl -X POST \
  -H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
  -H "Content-Type: application/json; charset=utf-8" \
  -d @$FILE \
  https://texttospeech.googleapis.com/v1/text:synthesize | \
  jq -r '.audioContent | tostring' | \
  base64 --decode > "${MP3_FOLDER}/${FOLDER}/${NAME}.mp3"
  echo ""
}

batch_text_to_speech(){
  
  echo "Processing files in text folder \"${1}\""
  echo ""
  echo "#########################################################################"
  for FILE in ./text/$1/*.json
  do
    text_to_speech "${FILE}"
  done
  
  echo "#########################################################################"
  echo ""
}

batch_text_to_speech "de"
batch_text_to_speech "en"

# text_to_speech ./text/en/step-signup.json
# text_to_speech ./text/de/step-signup.json