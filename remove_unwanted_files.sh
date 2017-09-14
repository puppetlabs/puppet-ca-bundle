#!/bin/bash
export PATH=/bin:/usr/bin

# Remove files that have something in the distrust field
grep -l '^# distrust=.' ./*.crt | xargs rm

# Remove files that don't have serverAuth in the openssl-trust field
for cert in $(ls *.crt); do
  if ! grep -q 'serverAuth' "$cert"; then
    rm "$cert"
  fi
done
