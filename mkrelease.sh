#!/usr/bin/env bash

set -euo pipefail

zip_filename="dali-${1:-unknown-version}.zip"

cp DALI.EXE dist/dali.exe

cd dist
zip -X --exclude=README.md ../$zip_filename *
