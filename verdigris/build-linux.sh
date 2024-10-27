#!/bin/bash

DIR="$(dirname "$0")"

cargo build --release --target i686-unknown-linux-gnu
cp "target/i686-unknown-linux-gnu/release/libverdigris.so" "$DIR/../libverdigris.so"
