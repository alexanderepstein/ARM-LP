#!/usr/bin/env bash
debug=false
if [ -f executable.out ]; then rm executable.out;fi
files=$(ls *.v)
while getopts "d" opt; do
  case "$opt" in
    d) debug=true;;
  esac
done

if $debug; then iverilog -o executable.out -s 'top'  $files -D DEBUG && echo "Compiled debug build." || echo "Failure"
else iverilog -o executable.out -s 'Processor'  $files && echo "Compiled release build." || echo "Failure"
fi
