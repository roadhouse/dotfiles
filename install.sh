#!/usr/bin/env bash

for i in $(ls files); do
  ln -s $PWD/$i ~/.$i;
done
