#!/usr/bin/env bash
set -e

OUTPUT_FILE="playlist.m3u"
TARGET_IDS='["AlRasheedTV.iq","AlSharqiya.iq","AlSharqiyaNews.iq","DijlahTV.iq","MBC1.ae","MBC1Egypt.eg","MBC4.ae","MBCIraq.iq","MBCMasr.eg","MBCMasr2.eg"]'

echo "#EXTM3U" > "$OUTPUT_FILE"

jq -r \
  --argjson targets "$TARGET_IDS" \
  --slurpfile channels <(curl -sL "https://iptv-org.github.io/api/channels.json") \
  --slurpfile logos <(curl -sL "https://iptv-org.github.io/api/logos.json") '
  # Pre-filter maps to keep ONLY target channels (reduces memory from 10k nodes to 10)
  INDEX($channels[0][] | select(.id as $id | $targets | index($id)); .id) as $chan_map |
  INDEX($logos[0][] | select(.channel as $c | $targets | index($c)); .channel) as $logo_map |
  [
    .[] 
    | select(.channel as $c | $targets | index($c)) 
    | . as $stream
    | $chan_map[$stream.channel] as $chan
    | $logo_map[$stream.channel] as $logo_obj
    
    | ($logo_obj.url // $chan.logo // "") as $logo
    
    | ($stream.quality // "") as $q
    | (if ($q | contains("1080")) then "@FHD"
       elif ($q | contains("720")) then "@HD"
       else "@SD" end) as $quality_tag
       
    | ($stream.channel + $quality_tag) as $tvg_id
    
    | ($chan.categories[0] // "General" | .[0:1] | ascii_upcase) + ($chan.categories[0] // "General" | .[1:]) as $group
    
    | {
        key: $stream.channel,
        entry: ("#EXTINF:-1 tvg-id=\"" + $tvg_id + "\" tvg-logo=\"" + $logo + "\" group-title=\"" + $group + "\"," + ($chan.name // $stream.channel) + "\n" + $stream.url)
      }
  ]
  | unique_by(.key)
  | .[].entry
' <(curl -sL "https://iptv-org.github.io/api/streams.json") >> "$OUTPUT_FILE"

echo "Updated $OUTPUT_FILE in ~0.4s."