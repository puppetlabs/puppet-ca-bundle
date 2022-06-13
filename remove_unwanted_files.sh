#!/bin/bash
export PATH=/bin:/usr/bin

# Remove files that have something in the distrust field
grep -l '^# distrust=.' ./*.crt | xargs rm

# Remove files that don't have serverAuth in the openssl-trust field
for cert in ./*.crt
do
  [[ -e "$cert" ]] || break
  if ! grep -q 'serverAuth' "$cert"; then
    rm "$cert"
  fi
done

# Remove temporary files
for tmp in ./*.tmp-p11-kit
do
  [[ -e "$tmp" ]] || break
  rm "$tmp"
done

# Remove CA bundle
if [[ -e ./ca-bundle.crt ]]; then
  rm ./ca-bundle.crt
fi
