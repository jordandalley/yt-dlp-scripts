#!/bin/sh

### Script for downloading albums from Youtube Music
# - Converts to MP3 from the best quality audio feed
# - Adds track number, album, artist, title, and release year into id3 tags
# - Adds album art embedded thumbnails

yt-dlp  --ignore-errors \
        --format "(bestaudio[acodec^=opus]/bestaudio)/best" \
        --extract-audio \
        --audio-format mp3 \
        --audio-quality 0 \
        --parse-metadata "%(release_year)s0101:%(upload_date)s" \
        --parse-metadata "playlist_index:%(track_number)s" \
        --parse-metadata "channel:%(artist)s" \
        --parse-metadata ":(?P<webpage_url>)" \
        --parse-metadata ":(?P<synopsis>)" \
        --parse-metadata ":(?P<description>)" \
        --add-metadata \
        --embed-thumbnail \
        --ppa "EmbedThumbnail+ffmpeg_o:-c:v mjpeg -vf crop=\"'if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)'\"" \
        -o "%(playlist_index)s. %(title)s.%(ext)s" "$1"
