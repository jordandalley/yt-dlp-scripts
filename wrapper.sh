#!/bin/bash

# Configuration variables for yt-dlp
YTDLP_LOCATION="/dispatcharrpy/bin/yt-dlp"
YTDLP_FORMAT_SELECT="bv+ba/b"
YTDLP_FORMAT_SORT="br"
# Configuration variables for ffmpeg
FFMPEG_LOCATION="/usr/local/bin/ffmpeg"
FFMPEG_IN_ARGS="-allowed_extensions ALL -re -readrate_initial_burst 30 -copyts"
FFMPEG_OUT_ARGS="-dn -mpegts_copyts 1"

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
  FFMPEG_IN_ARGS="$FFMPEG_IN_ARGS -http_proxy $PROXY"
  YTDLP_PROXY="--proxy \"$PROXY\""
fi

# Construct the command
CMD="\"$YTDLP_LOCATION\" -q $YTDLP_PROXY -f \"$YTDLP_FORMAT_SELECT\" -S \"$YTDLP_FORMAT_SORT\" --user-agent \"$USER_AGENT\" --hls-use-mpegts --downloader \"ffmpeg\" --ffmpeg-location \"$FFMPEG_LOCATION\" --downloader-args \"ffmpeg_i:$FFMPEG_IN_ARGS\" --downloader-args \"ffmpeg_o:$FFMPEG_OUT_ARGS\" -o - \"$INPUT_URL\""

# Spawn the command as a background process and capture the PID
bash -c "$CMD" &
PID=$!
# disown the PID and close the script
disown "$PID"
