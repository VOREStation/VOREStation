#!/bin/bash
# Generate maps
map_files=(
    "./maps/tether/tether-01-surface1.dmm"
    "./maps/tether/tether-02-surface2.dmm"
    "./maps/tether/tether-03-surface3.dmm"
    "./maps/tether/tether-04-transit.dmm"
    "./maps/tether/tether-05-station1.dmm"
    "./maps/tether/tether-06-station2.dmm"
    "./maps/tether/tether-07-station3.dmm"
    "./maps/tether/tether-08-mining.dmm"
    "./maps/tether/tether-09-solars.dmm"
    "./maps/offmap_vr/talon/talon1.dmm"
    "./maps/offmap_vr/talon/talon2.dmm"
)

tools/github-actions/nanomap-renderer minimap -w 2240 -h 2240 "${map_files[@]}"

# Move and rename files so the game understands them
cd "data/nanomaps"

mv "talon1_nanomap_z1.png" "tether_nanomap_z13.png"
mv "talon2_nanomap_z1.png" "tether_nanomap_z14.png"
mv "tether-01-surface1_nanomap_z1.png" "tether_nanomap_z1.png"
mv "tether-02-surface2_nanomap_z1.png" "tether_nanomap_z2.png"
mv "tether-03-surface3_nanomap_z1.png" "tether_nanomap_z3.png"
mv "tether-04-transit_nanomap_z1.png" "tether_nanomap_z4.png"
mv "tether-05-station1_nanomap_z1.png" "tether_nanomap_z5.png"
mv "tether-06-station2_nanomap_z1.png" "tether_nanomap_z6.png"
mv "tether-07-station3_nanomap_z1.png" "tether_nanomap_z7.png"
mv "tether-08-mining_nanomap_z1.png" "tether_nanomap_z8.png"
mv "tether-09-solars_nanomap_z1.png" "tether_nanomap_z9.png"

cd "../../"
cp data/nanomaps/* "icons/_nanomaps/"