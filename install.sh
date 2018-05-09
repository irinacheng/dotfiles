#!/usr/bin/env zsh

for f in $(ls -d *(/))
do
    stow $f
done
