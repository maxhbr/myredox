#!/usr/bin/env nix-shell
#! nix-shell -i bash -p parallel openscad

set -euo pipefail

buildConfig() {
    if [[ "$1" ]]; then
        local stl="$(echo "$1" | cut -d':' -f1)"
        local part="$(echo "$1" | cut -d':' -f2)"

        mkdir -p "$(dirname "$stl")"

        (set -x;
        openscad --hardwarnings -o "$stl" -p "v1.configs.json" -P "$part" v1.scad
        )
    fi
}
export -f buildConfig

buildCases() {
    cat <<EOF
out/case/redox.v1.left.stl:case
out/case/redox.v1.right.stl:case_right
out/caseWithLipo/redox.v1.left.lipo.stl:caseWithLipo
out/caseWithLipo/redox.v1.right.lipo.stl:caseWithLipo_right
out/caseWithPrintedPlate/redox.v1.left.printedPlate.stl:caseWithPrintedPlate
out/caseWithPrintedPlate/redox.v1.right.printedPlate.stl:caseWithPrintedPlate_right
EOF
}

buildTentKits() {
    return 0
    cat <<EOF
out/tentKits/tentKit20.stl:tentKit20
out/tentKits/tentKit30.stl:tentKit30
out/tentKits/tentKit40.stl:tentKit40
out/tentKits/tentKit70.stl:tentKit70
EOF
}

cat <<EOF | parallel --progress buildConfig {} 1>&2
$(buildCases)
$(buildTentKits)
EOF

wait
times
