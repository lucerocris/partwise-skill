#!/usr/bin/env bash
# Put several images on one labeled contact sheet, so they can be looked at in
# a single read instead of one read each.
#
#   refsheet.sh <out.png> <label>=<image-path-or-url> [<label>=<image-path-or-url> ...]
#
# Each tile is captioned with its label. Use it to compare candidate
# screenshots before choosing references (pass Thumbnail URLs), and to check
# finished crops (pass the crop files).
# Downloaded images are kept next to the sheet in <out-without-extension>/ as
# 1.jpg, 2.jpg ... in argument order, so a chosen one can be opened or cropped
# without downloading it again.
# TILE sets the largest tile edge in pixels (default 480), COLS the tiles per
# row (default 3).
set -euo pipefail

if [ "$#" -lt 2 ]; then
  sed -n '2,14p' "$0" | sed 's/^# \{0,1\}//'
  exit 2
fi

if command -v magick >/dev/null 2>&1; then mont=(magick montage)
elif command -v montage >/dev/null 2>&1; then mont=(montage)
else echo "refsheet: ImageMagick not found (need magick or montage)" >&2; exit 1
fi

out=$1; shift
tile=${TILE:-480} cols=${COLS:-3}
keep=${out%.*}
mkdir -p "$(dirname "$out")"

args=() n=0 i=0
for pair in "$@"; do
  i=$((i + 1))
  label=${pair%%=*} src=${pair#*=}
  case "$src" in
    http://*|https://*)
      mkdir -p "$keep"
      f="$keep/$i.jpg"
      if ! curl -fsSL "$src" -o "$f" 2>/dev/null; then
        echo "refsheet: skipped $label (download failed)" >&2; continue
      fi ;;
    *)
      f=$src
      [ -f "$f" ] || { echo "refsheet: skipped $label (no such file)" >&2; continue; } ;;
  esac
  args+=(-label "$label" "$f")
  n=$((n + 1))
done

[ "$n" -gt 0 ] || { echo "refsheet: no readable images" >&2; exit 1; }

"${mont[@]}" "${args[@]}" -resize "${tile}x${tile}>" -tile "${cols}x" -geometry "+10+10" \
  -background '#eeeeee' -fill '#111111' -pointsize 15 -depth 8 "$out"
echo "$n images  ->  $out"
