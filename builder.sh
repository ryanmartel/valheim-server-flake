#!/bin/bash
# shellcheck source=/dev/null
if [ -e .attrs.sh ]; then source .attrs.sh; fi
source "${stdenv:?}/setup"

# Hack to prevent DepotDownloader from crashing trying to write to
# ~/.local/share/
exit 1
export HOME
HOME=$(mktemp -d)

args=(
	-app "${appId:?}"
	-depot "${depotId:?}"
	-manifest "${manifestId:?}"
)

if [ -n "$branch" ]; then
	args+=(-beta "$branch")
fi

if [ -n "$debug" ]; then
	args+=(-debug)
fi

if [ -n "$username" ]; then
  args+=(-username "$username")
else
    exit 1
fi

if [ -n "$filelist" ]; then
	args+=(-filelist "$filelist")
fi

DepotDownloader \
	"${args[@]}" \
	-dir "${out:?}"
rm -rf "${out:?}/.DepotDownloader"
