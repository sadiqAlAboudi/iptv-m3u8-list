#!/usr/bin/env bash
set -e

OUTPUT_FILE="playlist.m3u"
CHANNELS_FILE="channels.txt"

if [[ ! -f "$CHANNELS_FILE" ]]; then
  echo "Error: $CHANNELS_FILE not found!"
  exit 1
fi

echo "#EXTM3U" > "$OUTPUT_FILE"

jq -r \
  --rawfile targets_raw "$CHANNELS_FILE" \
  --slurpfile channels <(curl -sL "https://iptv-org.github.io/api/channels.json") \
  --slurpfile logos <(curl -sL "https://iptv-org.github.io/api/logos.json") '
  
  # Parse channel IDs from text file safely (splits on newlines & strips empty lines)
  ($targets_raw | split("\n") | map(select(length > 0))) as $targets |

  # Fast O(1) memory lookup maps
  INDEX($channels[0][] | select(.id as $id | $targets | index($id)); .id) as $chan_map |
  INDEX($logos[0][] | select(.channel as $c | $targets | index($c)); .channel) as $logo_map |

  [
    .[] 
    | select(.channel as $c | $targets | index($c)) 
    | . as $stream
    | $chan_map[$stream.channel] as $chan
    | $logo_map[$stream.channel] as $logo_obj
    
    # 1. Logo URL fallback
    | ($logo_obj.url // $chan.logo // "") as $logo
    
    # 2. Quality tag (@FHD, @HD, @SD)
    | ($stream.quality // "") as $q
    | (if ($q | contains("1080")) then "@FHD"
       elif ($q | contains("720")) then "@HD"
       else "@SD" end) as $quality_tag
       
    # 3. Clean capitalization without string addition traps
    | ($chan.categories[0] // "general") as $cat
    | ($cat | .[0:1] | ascii_upcase) as $first
    | ($cat | .[1:]) as $rest
    
    | {
        key: $stream.channel,
        tvg_id: ($stream.channel + $quality_tag),
        logo: $logo,
        group: "\($first)\($rest)",
        name: ($chan.name // $stream.channel),
        url: $stream.url
      }
    | "#EXTINF:-1 tvg-id=\"\(.tvg_id)\" tvg-logo=\"\(.logo)\" group-title=\"\(.group)\",\(.name)\n\(.url)"
  ]
  | unique
  | .[]
' <(curl -sL "https://iptv-org.github.io/api/streams.json") >> "$OUTPUT_FILE"

echo "Updated $OUTPUT_FILE successfully."