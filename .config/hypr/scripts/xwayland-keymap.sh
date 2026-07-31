#!/usr/bin/env bash
layout="latam"

for _ in $(seq 1 100); do
  if setxkbmap -query >/dev/null 2>&1; then
    break
  fi
  sleep 0.1
done

setxkbmap -layout "$layout"
