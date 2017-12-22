#!/bin/bash
set -e -x
echo "=== brain.sh ==="

cd ..
readonly FACE_OUTPUT_DIR="/tmp/build/df6ad190/src-face/output"
readonly FACE_FILE="*.jpg"
readonly VOICE_DIR=${VOICE_HOME}

array=(`ls -1 ${VOICE_DIR}/mp3 | sed s/\.MP3//g`)
arr_len="${#array[@]}"

# face
export PYTHONPATH="/usr/local/lib/python2.7/site-packages/:$PYTHONPATH"
export PYTHONPATH="/usr/lib64/python2.7/site-packages:$PYTHONPATH"
/usr/bin/python /tmp/build/df6ad190/src-face/opencv-face-camera.py &

# watch pict existence
while true; do
    cd /tmp/build/df6ad190/src-face
    if [ "$(ls ${FACE_FILE})" != '' ]; then
        # voice
        cd "${VOICE_DIR}"
        v=${array[`expr $RANDOM % ${arr_len}`]}
        node voice.js "${v}" &

        cd ${FACE_OUTPUT_DIR}
        /bin/rm -f ${FACE_FILE}
    fi
    sleep 10s
done

ps aux | grep opencv-face-camera | grep -v grep | awk '{ print "kill -9", $2 }' | bash

exit 0
