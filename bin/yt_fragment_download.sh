uvx --with secretstorage yt-dlp[default,curl-cffi] \
  --cookies-from-browser "brave+gnomekeyring" \
  --download-sections "*$2" \
  --force-keyframes-at-cuts \
  $1
