#!/bin/bash

### Script for downloading albums from Youtube Music ##########
### Usage: ./yt-music-album-download.sh <youtube music url> ###

# - Converts to MP3 from the best quality audio feed
# - Adds track number, album, artist, title, and release year into id3 tags
# - Adds album art embedded thumbnails
# - Saves to '{Artist}/{Album}/{Track} - {Song}.mp3'

yt-dlp \
  --ignore-errors \
  -f "(bestaudio[acodec^=opus]/bestaudio)/best" \
  --extract-audio \
  --audio-format mp3 \
  --audio-quality 0 \
  --add-metadata \
  --parse-metadata "artist:(?P<artist>[^,]+)" \
  --parse-metadata "playlist_index:%(track)s" \
  --parse-metadata "release_year:%(year)s" \
  --parse-metadata ":(?P<webpage_url>)" \
  --parse-metadata ":(?P<synopsis>)" \
  --parse-metadata ":(?P<description>)" \
  --embed-thumbnail \
  --ppa "EmbedThumbnail+ffmpeg_o:-c:v mjpeg -vf crop=\"'if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)'\"" \
  -o "%(artist)s/%(album)s/%(track)s - %(title)s.%(ext)s" \
  $1
