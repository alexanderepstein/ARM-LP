#!/usr/bin/env bash
if [ -f executable.out ]; then rm executable.out;fi
files=$(ls ./src/*.v)
iverilog -o executable.out -s 'top'  $files
