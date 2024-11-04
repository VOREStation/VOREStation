#!/bin/bash

DIR="$(dirname "$0")"

cargo build --release --target i686-pc-windows-msvc
cp "target/i686-pc-windows-msvc/release/verdigris.dll" "$DIR/../verdigris.dll"
