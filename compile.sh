#!/usr/bin/env bash
files=$(ls ./src/*.v)
iverilog -o executable.out -s 'top'  $files
