#!/bin/bash
echo "{"
echo "  data: ["
while read curline; do
    echo "[${curline% *}000, ${curline#* }], "

done
echo "]"
echo "}"
