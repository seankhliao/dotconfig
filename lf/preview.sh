#!/bin/sh

case "$1" in
    *) bat --color always --style changes,numbers -r :"$2" "$1";;
esac
