#!/usr/bin/env nix-shell
#! nix-shell -i bash -p parallel openscad

set -euo pipefail
openscad --hardwarnings -o redox.v1b.left.stl redox.v1b.left.scad
openscad --hardwarnings -o redox.v1b.right.stl redox.v1b.right.scad
openscad --hardwarnings -o redox.v1b.left.tent.stl redox.v1b.left.tent.scad
openscad --hardwarnings -o redox.v1b.right.tent.stl redox.v1b.right.tent.scad
