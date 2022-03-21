#!/usr/bin/env nix-shell
#! nix-shell -i bash -p parallel openscad

set -euo pipefail

buildConfig() {
    openscad --hardwarnings -o "$1" -p "v1.configs.json" -P "$2" v1.scad
    git add "$1"
}

mkdir -p out
buildConfig out/redox.v1.left.stl case
buildConfig out/redox.v1.right.stl case_right
buildConfig out/redox.v1.left.lipo.stl caseWithLipo
buildConfig out/redox.v1.right.lipo.stl caseWithLipo_right
buildConfig out/tentKit.stl tentKit
mkdir -p out/wip
buildConfig out/wip/redox.v1.left.lipo-no-switch.stl test_caseWithLipo
buildConfig out/wip/redox.v1.right.lipo-no-switch.stl test_caseWithLipo_right
