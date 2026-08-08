# IPTV M3U Playlist

An automatically updated, lightweight IPTV playlist containing curated high-quality channels.

## Usage

Copy and paste the raw link directly into your favorite IPTV player (VLC, Tivimate, OTT Navigator, IPTV Smarters, etc.):

```Plaintext
https://raw.githubusercontent.com/sadiqAlAboudi/iptv-m3u8-list/main/playlist.m3u
```

## How to Add or Remove Channels

All channel metadata, logos, and streams are fetched dynamically from the iptv-org database using update.sh. You do not need to manually edit stream URLs or logo links.

### Step 1: Open update.sh

Find the TARGET_IDS array near the top of the file:
```Bash
TARGET_IDS='["AlRasheedTV.iq","AlSharqiya.iq","AlSharqiyaNews.iq","DijlahTV.iq","MBC1.ae","MBC1Egypt.eg","MBC4.ae","MBCIraq.iq","MBCMasr.eg","MBCMasr2.eg"]'
```

### Step 2: Modify the Channel Array

- To Add a Channel: Find the official channel ID from [iptv-org.github.io](https://iptv-org.github.io/) and add it to the array.
- To Remove a Channel: Delete the ID from the array.

Example:

To add BBC News (BBCNews.uk) and remove MBC4 (MBC4.ae):

```Bash
# Updated array:
TARGET_IDS='["AlRasheedTV.iq","AlSharqiya.iq","AlSharqiyaNews.iq","BBCNews.uk","DijlahTV.iq","MBC1.ae","MBC1Egypt.eg","MBCIraq.iq","MBCMasr.eg","MBCMasr2.eg"]'
```

### Step 3: Find Channel IDs

Search for any channel ID on the official database:

- Database / Search: [suspicious link removed]

- Format: IDs follow the ChannelName.countrycode format (e.g., AlJazeera.qa, CNN.us, SkyNews.uk).

### Step 4: Commit Your Changes

Once you push your updated update.sh to GitHub:

- GitHub Actions automatically executes the update script.
- playlist.m3u regenerates with updated stream URLs, logos, and quality tags within seconds.