#!/usr/bin/env bash

curl -s -O https://raw.githubusercontent.com/JohnnyMorganz/luau-lsp/master/scripts/globalTypes.d.lua

rojo sourcemap dev.project.json -o sourcemap.json

luau-lsp analyze --sourcemap=sourcemap.json --defs=globalTypes.d.lua --ignore=**/_Index/** src/
exit_code=$?

rm globalTypes.d.lua

exit $exit_code