ffmpeg -i $1 -vf "fps=10,scale=320:-1:flags=lanczos" -c:v pam \
    -f image2pipe - | \
    convert -delay 10 - -loop 0 -layers optimize $2

# ffmpeg -ss 30 -t 3 -i $1 \
#     -vf "fps=10,scale=320:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
#     -loop 0 $2
