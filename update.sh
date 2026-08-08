#!/usr/bin/env bash
set -e

# Fetch master playlist from iptv-org
SOURCE_URL="https://iptv-org.github.io/iptv/index.m3u"
OUTPUT_FILE="playlist.m3u"
TMP_SOURCE="master_temp.m3u"

# Define target TVG IDs or Channel Names separated by |
# Matching by tvg-id ensures exact matching without accidental duplicates
TARGETS="tvg-id=\"AlRasheedTV.iq|tvg-id=\"AlSharqiya.iq|tvg-id=\"AlSharqiyaNews.iq|tvg-id=\"DijlahTV.iq|tvg-id=\"MBC1.ae|tvg-id=\"MBC1Egypt.eg|tvg-id=\"MBC4.ae|tvg-id=\"MBCIraq.iq|tvg-id=\"MBCMasr2.eg|tvg-id=\"MBCMasr.eg"

echo "Downloading iptv-org master list..."
curl -sL -A "Mozilla/5.0" "$SOURCE_URL" -o "$TMP_SOURCE"

echo "#EXTM3U" > "$OUTPUT_FILE"

# Extract matched #EXTINF block and stream URL via AWK
awk -v pattern="$TARGETS" '
  BEGIN { IGNORECASE = 1 }
  /^#EXTINF:/ {
    if ($0 ~ pattern) {
      extinf = $0
      is_match = 1
    } else {
      is_match = 0
    }
    next
  }
  !/^#/ && is_match {
    print extinf
    print $0
    is_match = 0
  }
' "$TMP_SOURCE" >> "$OUTPUT_FILE"

rm -f "$TMP_SOURCE"
echo "Updated $OUTPUT_FILE with your custom channel list."