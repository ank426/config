[ -z "$1" ] && exit 1
[ -d "$1" ] || [ -f "$1" ] || (echo "Not Found: $1" && exit 1)

if [ -d "$1" ]; then
    LC_COLLATE=C ls --almost-all --color --format=commas --group-directories-first "$1" | tr ',' ' '
    exit 0
fi

mime_type=$(file --brief --mime-type "$1" 2>/dev/null || exit 1)
size=$(stat --format %s "$1" 2>/dev/null || stat -f %z "$1" 2>/dev/null || exit 1)

case "$mime_type" in
    inode/x-empty)
        ;;
    text/*)
        bat --color=always --style=plain "$1"
        ;;
    image/*)
        echo -e "\033[1;94mImage File: $mime_type\033[0m"
        identify "$1" | tr ' ' '\n'
        ;;
    video/*)
        echo -e "\033[1;94mVideo File: $mime_type\033[0m"
        ffprobe -loglevel quiet -show_format "$1" | tail -n +2 | sed '$d'
        ;;
    application/pdf)
        echo -e "\033[1;94mPDF File: $mime_type\033[0m"
        pdfinfo "$1"
        ;;
    application/zip|application/x-zip*)
        echo -e "\033[1;94mZip File: $mime_type\033[0m"
        unzip -l "$1" | tail -n +2
        ;;
    application/x-tar|application/x-gzip|application/x-bzip2)
        echo -e "\033[1;94mTar File: $mime_type\033[0m"
        tar tf "$1"
        ;;
    *)
        echo -e "\033[1;94mBinary File\033[0m"
        echo "Type: $mime_type"
        echo "Size: $size bytes"
        ;;
esac
