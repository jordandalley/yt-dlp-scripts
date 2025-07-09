#!/bin/bash

# Binary paths
FFMPEG_LOCATION="/usr/local/bin/ffmpeg"
YTDLP_LOCATION="/dispatcharrpy/bin/yt-dlp"
STRMLNK_LOCATION="/dispatcharrpy/bin/streamlink"

# Configuration variables for streamlink (used to parse MPD manifests before passing to ffmpeg)
STRMLNK_FORMAT_SELECT="best"
STRMLNK_ARGS="--ffmpeg-fout mpegts --ffmpeg-copyts --ffmpeg-verbose"

# Configuration variables for yt-dlp (used to parse everything else before passing to ffmpeg)
YTDLP_FORMAT_SELECT="bv+ba/b"
YTDLP_FORMAT_SORT="br"
YTDLP_FF_IN_ARGS="-allowed_extensions ALL -re -readrate_initial_burst 30 -copyts"
YTDLP_FF_OUT_ARGS="-dn -mpegts_copyts 1"

# Function to show usage
usage() {
  echo "Usage: $0 -i <input_url> -ua <user_agent> [-proxy <proxy_url>]"
  exit 1
}

# Initialise input variables
INPUT_URL=""
USER_AGENT=""
PROXY=""

# Parse arguments for input url, user-agent and optionally an http proxy server
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -i)
      INPUT_URL="$2"
      shift 2
      ;;
    -ua)
      USER_AGENT="$2"
      shift 2
      ;;
    -proxy)
      PROXY="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      usage
      ;;
  esac
done

# Validate required arguments for input url and user-agent
if [[ -z "$INPUT_URL" || -z "$USER_AGENT" ]]; then
  echo "Error: -i and -ua are required."
  usage
fi

# Check $PROXY amd create additional vars for using http proxy
if [[ "$PROXY" ]]; then
  # yt-dlp will pass the the user agent string, but not the proxy. Add to $YTDLP_FF_IN_ARGS
  YTDLP_PROXY="--proxy \"$PROXY\""
  STRMLNK_ARGS="--http-proxy \"$PROXY\" $STRMLNK_ARGS"
  YTDLP_FF_IN_ARGS="$YTDLP_FF_IN_ARGS -http_proxy $PROXY"
fi

# Check the url path for matching mpd file, and if so send it to streamlink instead
if [[ "${INPUT_URL,,}" =~ ^[^?]*\.mpd([/?]|$) ]]; then
  # Stream is an DASH MPD manifest - pass to streamlink
  CMD="\"$STRMLNK_LOCATION\" --ffmpeg-ffmpeg \"$FFMPEG_LOCATION\" --http-header User-Agent=\"$USER_AGENT\" $STRMLNK_ARGS --stdout \"$INPUT_URL\" $STRMLNK_FORMAT_SELECT"
else
  # Stream is NOT a DASH MPD manifest, so pass to yt-dlp
  CMD="\"$YTDLP_LOCATION\" $YTDLP_PROXY -f \"$YTDLP_FORMAT_SELECT\" -S \"$YTDLP_FORMAT_SORT\" --user-agent \"$USER_AGENT\" --hls-use-mpegts --downloader \"ffmpeg\" --ffmpeg-location \"$FFMPEG_LOCATION\" --downloader-args \"ffmpeg_i:$YTDLP_FF_IN_ARGS\" --downloader-args \"ffmpeg_o:$YTDLP_FF_OUT_ARGS\" -o - \"$INPUT_URL\""
fi

# Spawn the command as a background process and capture the PID
bash -c "$CMD" &
PID=$!
# disown the PID and close the script
disown "$PID"
