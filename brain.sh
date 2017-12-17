#!/bin/bash
cd ..
readonly HOME_DIR=`pwd`
readonly FACE_DIR="${HOME_DIR}/face"
readonly FACE_OUTPUT_DIR="${HOME_DIR}/face/output"
readonly FACE_FILE="*.jpg"
readonly VOICE_DIR="${HOME_DIR}/voice"

# face
export PYTHONPATH="/usr/local/lib/python2.7/site-packages/:$PYTHONPATH"
cd ${FACE_DIR}
/usr/bin/python opencv-face-camera.py &

# watch pict existence
while true; do
    cd ${FACE_OUTPUT_DIR}
    if [ "$(ls ${FACE_FILE})" != '' ]; then
        # voice
        cd "${VOICE_DIR}"
        node voice.js Hello &

        cd ${FACE_OUTPUT_DIR}
        /bin/rm -f ${FACE_FILE}
    fi
    sleep 5s
done

ps aux | grep opencv-face-camera | grep -v grep | awk '{ print "\
kill -9", $2 }' | bash

exit 0
