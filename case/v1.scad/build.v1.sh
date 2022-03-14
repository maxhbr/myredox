#!/usr/bin/env nix-shell
#! nix-shell -i bash -p parallel openscad

set -euo pipefail
openscad --hardwarnings -o redox.v1.left.stl redox.v1.left.scad
openscad --hardwarnings -o redox.v1.right.stl redox.v1.right.scad
