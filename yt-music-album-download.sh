#!/bin/bash

### Script for downloading albums from Youtube Music #
### Usage: ./yt-music-dl.sh <youtube music url> ###

# - Converts to M4A AAC from the best quality audio feed
# - Adds track number, album, artist, title, and release year into metadata
# - Adds album art embedded thumbnails
# - Saves to DOWNLOAD_PATH as '{Artist}/{Album}/{Track} - {Song}.m4a'
# - Place yt-dlp, ffmpeg and deno binaries into ./bin
# - Extract cookies from youtube.com and place in the base directory as cookies.txt

BIN_PATH=./bin
JS_TYPE=deno
COOKIE_PATH=./cookies.txt
DOWNLOAD_PATH=/mnt/Media/Music

$BIN_PATH/yt-dlp \
  --cookies $COOKIE_PATH \
  --js-runtimes $JS_TYPE:$BIN_PATH/$JS_TYPE \
  --ignore-errors \
  -f "bestaudio/best" \
  --extract-audio \
  --audio-format m4a \
  --audio-quality 0 \
  --parse-metadata "artist:(?P<meta_artist>[^,]+)" \
  --parse-metadata "playlist_index:%(meta_track)s" \
  --parse-metadata "album:%(meta_album)s" \
  --parse-metadata "title:%(meta_title)s" \
  --parse-metadata "release_year:%(meta_year)s" \
  --parse-metadata ":(?P<meta_genre>)" \
  --parse-metadata ":(?P<meta_comment>)" \
  --parse-metadata ":(?P<meta_webpage_url>)" \
  --parse-metadata ":(?P<meta_synopsis>)" \
  --parse-metadata ":(?P<meta_description>)" \
  --add-metadata \
  --embed-thumbnail \
  --ppa "EmbedThumbnail+ffmpeg_o:-c:v mjpeg -vf crop=\"'if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)'\"" \
  --ffmpeg-location $BIN_PATH \
  -o "${DOWNLOAD_PATH}/%(meta_artist)s/%(meta_album)s/%(meta_track)s - %(meta_title)s.%(ext)s" \
  $1
