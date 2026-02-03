# Jordan's YT-DLP Script Repo

This is just a repo for some random scripts for downloading things using yt-dlp

# yt-music-dl.sh

- Downloads entire albums off Youtube Music using yt-dlp: https://github.com/yt-dlp/yt-dlp
- Converts tracks to M4A AAC from the best quality audio format
- Adds track number, artist, album, title, and release year into metadata, and removes superfluous information
- Adds album art as embedded thumbnails into mp3 files
- Saves to DOWNLOAD_PATH as '{Artist}/{Album}/{Track} - {Song}.m4a'
- Place yt-dlp, ffmpeg and deno binaries into ./bin
- Extract cookies from youtube.com and place in the base directory as cookies.txt
