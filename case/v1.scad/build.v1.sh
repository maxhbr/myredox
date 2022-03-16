#!/usr/bin/env nix-shell
#! nix-shell -i bash -p parallel openscad

set -euo pipefail
openscad --hardwarnings -o redox.v1.left.stl redox.v1.left.scad
openscad --hardwarnings -o redox.v1.right.stl redox.v1.right.scad
openscad --hardwarnings -o redox.v1.left.lipo.stl redox.v1.left.lipo.scad
openscad --hardwarnings -o redox.v1.right.lipo.stl redox.v1.right.lipo.scad
