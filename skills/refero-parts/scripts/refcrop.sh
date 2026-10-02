#!/usr/bin/env bash
# Crop one part out of a reference screenshot.
#
#   refcrop.sh <image-path-or-url> <left> <top> <right> <bottom> <out.png> [pad]
#
# left/top/right/bottom are percentages (0-100) of the image width/height, so
# the same box works whatever resolution the image was viewed or saved at.
# pad is extra margin in percent of the image's shorter side (default 2).
# Prints the source size, the pixel box used and the output size.
set -euo pipefail

if [ "$#" -lt 6 ]; then
  sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'
  exit 2
fi

src=$1 l=$2 t=$3 r=$4 b=$5 out=$6 pad=${7:-2}

if command -v magick >/dev/null 2>&1; then im=(magick); idf=(magick identify)
elif command -v convert >/dev/null 2>&1; then im=(convert); idf=(identify)
else echo "refcrop: ImageMagick not found (need magick or convert)" >&2; exit 1
fi

tmp=""
trap '[ -n "$tmp" ] && rm -f "$tmp"' EXIT
case "$src" in
  http://*|https://*)
    tmp=$(mktemp --suffix=.img)
    curl -fsSL "$src" -o "$tmp" || { echo "refcrop: download failed: $src" >&2; exit 1; }
    src=$tmp ;;
  *)
    [ -f "$src" ] || { echo "refcrop: no such file: $src" >&2; exit 1; } ;;
esac

read -r W H < <("${idf[@]}" -format '%w %h\n' "$src" | head -n1)

read -r X Y CW CH < <(awk -v W="$W" -v H="$H" -v l="$l" -v t="$t" -v r="$r" -v b="$b" -v p="$pad" 'BEGIN {
  if (r <= l || b <= t) { print "bad"; exit }
  m = (W < H ? W : H) * p / 100
  x0 = W * l / 100 - m; y0 = H * t / 100 - m
  x1 = W * r / 100 + m; y1 = H * b / 100 + m
  if (x0 < 0) x0 = 0; if (y0 < 0) y0 = 0
  if (x1 > W) x1 = W; if (y1 > H) y1 = H
  printf "%d %d %d %d\n", x0, y0, x1 - x0, y1 - y0
}')

if [ "$X" = "bad" ]; then
  echo "refcrop: right must be > left and bottom > top (percent 0-100)" >&2
  exit 2
fi

mkdir -p "$(dirname "$out")"
"${im[@]}" "$src" -crop "${CW}x${CH}+${X}+${Y}" +repage "$out"
echo "source ${W}x${H}  box ${CW}x${CH}+${X}+${Y}  ->  $out"
