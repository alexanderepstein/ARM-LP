#!/usr/bin/env bash
debug=false
wave=false
if [ -f executable.out ]; then rm executable.out;fi
files=$(ls *.v)
while getopts "dw" opt; do
  case "$opt" in
    d) debug=true;;
    w) wave=true;;
  esac
done

if $wave; then gtkwave -o wave.vcd && rm wave.vcd.fst && exit 0 || exit 1; fi

if $debug; then iverilog -o executable.out -s 'top'  $files -D DEBUG && echo "Compiled debug build." || echo "Failure"
else iverilog -o executable.out -s 'Processor'  $files && echo "Compiled release build." || echo "Failure"
fi
