#!/usr/bin/env bash
# Crop one part out of a reference screenshot.
#
#   refcrop.sh [--sharp <url>] <image-path-or-url> <left> <top> <right> <bottom> <out.png> [pad]
#
# <image> must be the image the box was measured on.
# left/top/right/bottom are percentages (0-100) of that image's width/height.
# pad is extra margin in percent of the image's shorter side (default 2).
#
# --sharp <url> names a higher-resolution copy of the same screenshot. It is
# used only when it has the same shape as <image>; some sharper copies show
# just the top viewport of a long page, and the same box would land on the
# wrong place there, so those are ignored and <image> is cropped instead.
#
# Prints which source was used, the pixel box and the output path.
set -euo pipefail

usage() { sed -n '2,15p' "$0" | sed 's/^# \{0,1\}//'; }

sharp=""
if [ "${1:-}" = "--sharp" ]; then
  sharp=${2:-}
  shift 2 || { usage; exit 2; }
fi
if [ "$#" -lt 6 ]; then usage; exit 2; fi

src=$1 l=$2 t=$3 r=$4 b=$5 out=$6 pad=${7:-2}

if command -v magick >/dev/null 2>&1; then im=(magick); idf=(magick identify)
elif command -v convert >/dev/null 2>&1; then im=(convert); idf=(identify)
else echo "refcrop: ImageMagick not found (need magick or convert)" >&2; exit 1
fi

tmps=()
trap '[ "${#tmps[@]}" -gt 0 ] && rm -f "${tmps[@]}"' EXIT

# Resolve a path or URL to a local file; prints the path, empty on failure.
fetch() {
  case "$1" in
    http://*|https://*)
      local f
      f=$(mktemp --suffix=.img)
      tmps+=("$f")
      if curl -fsSL "$1" -o "$f" 2>/dev/null; then echo "$f"; fi ;;
    *)
      if [ -f "$1" ]; then echo "$1"; fi ;;
  esac
}

size() { "${idf[@]}" -format '%w %h\n' "$1" 2>/dev/null | head -n1; }

file=$(fetch "$src")
[ -n "$file" ] || { echo "refcrop: cannot read image: $src" >&2; exit 1; }
read -r W H < <(size "$file")
used="image"

if [ -n "$sharp" ]; then
  sfile=$(fetch "$sharp")
  if [ -z "$sfile" ]; then
    echo "refcrop: sharp copy not reachable, using image" >&2
  else
    read -r SW SH < <(size "$sfile")
    same=$(awk -v w="$W" -v h="$H" -v sw="$SW" -v sh="$SH" 'BEGIN {
      d = (w / h) / (sw / sh); print (d > 0.97 && d < 1.03 && sw > w) ? 1 : 0 }')
    if [ "$same" = 1 ]; then
      file=$sfile W=$SW H=$SH used="sharp"
    else
      echo "refcrop: sharp copy is ${SW}x${SH}, image is ${W}x${H}; different shape or not larger, using image" >&2
    fi
  fi
fi

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
"${im[@]}" "$file" -crop "${CW}x${CH}+${X}+${Y}" +repage -strip "$out"
echo "used ${used} ${W}x${H}  crop ${CW}x${CH}+${X}+${Y}  ->  $out"
