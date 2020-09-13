#!/usr/bin/env bash

text=""
class="none"
if pgrep wf-recorder > /dev/null 2>&1; then
    class="recording"
fi

echo "{\"text\": \"$text\", \"class\": \"$class\"}"
