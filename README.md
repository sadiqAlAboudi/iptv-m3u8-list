# IPTV M3U Playlist

An automatically updated, lightweight IPTV playlist containing curated high-quality channels.

## Usage

Copy and paste the raw link directly into your favorite IPTV player (VLC, Tivimate, OTT Navigator, IPTV Smarters, etc.):

```Plaintext
https://raw.githubusercontent.com/sadiqAlAboudi/iptv-m3u8-list/main/playlist.m3u
```

## How to Add or Remove Channels

All channel metadata, logos, and streams are fetched dynamically from the iptv-org database using `update.sh`. You do not need to manually edit stream URLs or logo links.

### Step 1: Open `channels.txt`

Locate and open the `channels.txt` file in the root directory of the repository. Channel IDs are listed one per line:

```Plaintext
AlRasheedTV.iq
AlSharqiya.iq
AlSharqiyaNews.iq
DijlahTV.iq
MBC1.ae
MBC1Egypt.eg
MBC4.ae
MBCIraq.iq
MBCMasr.eg
MBCMasr2.eg
KarbalaTV.iq
AlIraqia.iq
```

### Step 2: Modify `channels.txt`

- To Add a Channel: Add its official ID on a new line.
- To Remove a Channel: Delete its line from the file.

#### Example:

To add BBC News (BBCNews.uk) and remove MBC4 (MBC4.ae), edit `channels.txt` to:

```Plaintext
AlRasheedTV.iq
AlSharqiya.iq
AlSharqiyaNews.iq
BBCNews.uk
DijlahTV.iq
MBC1.ae
MBC1Egypt.eg
MBCIraq.iq
MBCMasr.eg
MBCMasr2.eg
KarbalaTV.iq
AlIraqia.iq
```

### Step 3: Find Channel IDs

Search for any channel ID on the official database:

- Database / Search: [iptv-org](https://github.com/iptv-org/iptv)

- Format: IDs follow the `ChannelName.countrycode` format (e.g., AlJazeera.qa, CNN.us, SkyNews.uk).

### Step 4: Commit Your Changes

Once you push your updated channels.txt to GitHub:

- GitHub Actions automatically executes the update script.
- `playlist.m3u` regenerates with updated stream URLs, logos, and quality tags within seconds.

---

## Legal & DMCA Disclaimer

* **No Media Hosted:** This repository does not host, store, stream, or re-transmit any video or audio content. It only contains pointer links (M3U files) generated from publicly available datasets provided by [iptv-org](https://github.com/iptv-org/iptv).
* **Content Ownership:** All logos, channel names, trademarks, and stream URLs belong exclusively to their respective owners and broadcasters.
* **No Control Over External Links:** The maintainer of this repository has no affiliation with or control over external stream links, servers, or content availability.
* **DMCA Notice:** If you are a copyright owner and want a link removed, please contact the third-party server hosting the actual media file or submit a removal request directly to the upstream database maintainers at [iptv-org](https://github.com/iptv-org/iptv).