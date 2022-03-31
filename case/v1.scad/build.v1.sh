#!/usr/bin/env nix-shell
#! nix-shell -i bash -p parallel openscad

set -euo pipefail

buildConfig() {
    local stl="$(echo "$1" | cut -d':' -f1)"
    local part="$(echo "$1" | cut -d':' -f2)"

    (set -x;
     openscad --hardwarnings -o "$stl" -p "v1.configs.json" -P "$part" v1.scad
    )
}
export -f buildConfig

mkdir -p out
mkdir -p out/wip

cat <<EOF | parallel --progress buildConfig {} 1>&2
out/redox.v1.left.stl:case
out/redox.v1.right.stl:case_right
out/redox.v1.left.lipo.stl:caseWithLipo
out/redox.v1.right.lipo.stl:caseWithLipo_right
out/redox.v1.left.printedPlate.stl:caseWithPrintedPlate
out/redox.v1.right.printedPlate.stl:caseWithPrintedPlate_right
out/tentKit20.stl:tentKit20
out/tentKit30.stl:tentKit30
out/tentKit40.stl:tentKit40
out/tentKit50.stl:tentKit50
EOF

wait
times
