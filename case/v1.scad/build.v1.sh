#!/usr/bin/env nix-shell
#! nix-shell -i bash -p parallel openscad

set -euo pipefail
openscad --hardwarnings -o out/redox.v1.left.stl left.scad
openscad --hardwarnings -o out/redox.v1.right.stl right.scad
openscad --hardwarnings -o out/redox.v1.left.lipo.stl left.lipo.scad
openscad --hardwarnings -o out/redox.v1.right.lipo.stl right.lipo.scad
