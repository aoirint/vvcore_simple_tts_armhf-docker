#!/bin/bash
set -u

cd /opt/voicevox_core/example/cpp/unix

./simple_tts $@
EXIT_CODE=$?

# if [ -f audio.wav ]; then
gosu user cp ./audio.wav /work/
# fi

exit $EXIT_CODE

