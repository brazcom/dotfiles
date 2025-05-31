function mplay
    set folder $argv[1]
    if test -z "$folder"
        set folder "."
    end

    find "$folder" -type f \( -iname "*.mp3" -o -iname "*.flac" -o -iname "*.wav" -o -iname "*.ogg" -o -iname "*.opus" \) -print0 | sort -z | xargs -0 -- mpv
end

