#!/usr/bin/env bash
set -e

OUTPUT_FILE="playlist.m3u"
TMP_STREAMS="streams.json"
TMP_CHANNELS="channels.json"
TMP_LOGOS="logos.json"

echo "Fetching API datasets..."
curl -sL "https://iptv-org.github.io/api/streams.json" -o "$TMP_STREAMS"
curl -sL "https://iptv-org.github.io/api/channels.json" -o "$TMP_CHANNELS"
curl -sL "https://iptv-org.github.io/api/logos.json" -o "$TMP_LOGOS"

TARGET_IDS='["AlRasheedTV.iq","AlSharqiya.iq","AlSharqiyaNews.iq","DijlahTV.iq","MBC1.ae","MBC1Egypt.eg","MBC4.ae","MBCIraq.iq","MBCMasr.eg","MBCMasr2.eg"]'

echo "#EXTM3U" > "$OUTPUT_FILE"

# Parse quality string, logo URL, and channel category
jq -r \
  --argjson targets "$TARGET_IDS" \
  --slurpfile channels "$TMP_CHANNELS" \
  --slurpfile logos "$TMP_LOGOS" '
  INDEX($channels[0][]; .id) as $chan_map |
  INDEX($logos[0][]; .channel) as $logo_map |
  [
    .[] 
    | select(.channel as $c | $targets | index($c)) 
    | . as $stream
    | $chan_map[$stream.channel] as $chan
    | $logo_map[$stream.channel] as $logo_obj
    
    # 1. Read logo URL directly from logo object property .url
    | ($logo_obj.url // $chan.logo // "") as $logo
    
    # 2. Dynamic quality tagging parsed from .quality string (e.g., "720p", "1080p")
    | ($stream.quality // "") as $q
    | (if ($q | contains("1080")) then "@FHD"
       elif ($q | contains("720")) then "@HD"
       else "@SD" end) as $quality_tag
       
    | ($stream.channel + $quality_tag) as $tvg_id
    
    # 3. Capitalize group category
    | ($chan.categories[0] // "General" | .[0:1] | ascii_upcase) + ($chan.categories[0] // "General" | .[1:]) as $group
    
    | {
        key: $stream.channel,
        entry: ("#EXTINF:-1 tvg-id=\"" + $tvg_id + "\" tvg-logo=\"" + $logo + "\" group-title=\"" + $group + "\"," + ($chan.name // $stream.channel) + "\n" + $stream.url)
      }
  ]
  | unique_by(.key)
  | .[].entry
' "$TMP_STREAMS" >> "$OUTPUT_FILE"

rm -f "$TMP_STREAMS" "$TMP_CHANNELS" "$TMP_LOGOS"
echo "Updated $OUTPUT_FILE with dynamic quality tags."