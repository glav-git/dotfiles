# yt-dlp installation:
# uv tool install yt-dlp[default,curl-cffi] --with secretstorage
#
# or a one-off command:
# uvx yt-dlp[default,curl-cffi] --with secretstorage
#
# for js-challeng to work (see https://github.com/yt-dlp/yt-dlp/wiki/EJS):
# npm install -g deno
# or
# cargo install deno --locked

# yt-dlp \
uvx --with secretstorage yt-dlp[default,curl-cffi] \
  -x --audio-format mp3 \
  --embed-metadata \
  --embed-thumbnail \
  --add-metadata \
  --metadata-from-title "%(artist)s - %(title)s" \
  -o "%(artist)s - %(title)s.%(ext)s" \
  --cookies-from-browser "brave+gnomekeyring" \
  "$1"
