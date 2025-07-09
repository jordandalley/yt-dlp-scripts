# Jordan's YT-DLP Script Repository

This is just a repo for some random scripts for downloading things using yt-dlp fork of youtube-dl

# wrapper.sh

Usage: ```./wrapper.sh -i <input_url> -ua <user_agent> [-proxy <proxy_url>]```

Eg. ```./wrapper.sh -i "https://url.to.strean/some-tv-channel.m3u8" -ua "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.3" -proxy "http://some.proxy.server:3128"```

A wrapper script for use in [Dispatcharr](https://github.com/Dispatcharr/Dispatcharr/) that does the following:
- Selects the highest quality streams before passing to ffmpeg which significantly speeds up stream starts
  - Uses 'streamlink' for MPEG-DASH parsing
  - Uses 'yt-dlp' for all other parsing
- Selects the highest quality audio/video streams
- HTTP Proxy support
- Use Youtube livestreams as channels!

Add to Dispatcharr as a 'Stream Profile' by mapping the script into the docker container, making the script executable and passing the following to it: ```-i {streamUrl} -ua {userAgent}```

![image](https://github.com/user-attachments/assets/e10638d0-864b-41f4-b0d1-097ae7575d13)

# yt-music-album-download.sh

- Downloads entire albums off Youtube Music using yt-dlp: https://github.com/yt-dlp/yt-dlp
- Converts tracks to MP3 from the best quality audio feed
- Adds track number, artist, album, title, and release year into id3 tags (removes superfluous information)
- Adds album art as embedded thumbnails into mp3 files
