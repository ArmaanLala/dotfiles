function notify --description "Run a command, then send a desktop notification with its exit status"
    $argv
    set -l ret $status

    set -l title Terminal
    if test $ret -eq 0
        set -l body "Done: $argv"
        if test (uname) = Darwin
            osascript -e 'display notification "'"$body"'" with title "'"$title"'" sound name "Glass"'
        else if command -v notify-send >/dev/null
            notify-send "$title" "$body"
        end
    else
        set -l body "Failed (exit $ret): $argv"
        if test (uname) = Darwin
            osascript -e 'display notification "'"$body"'" with title "'"$title"'" sound name "Basso"'
        else if command -v notify-send >/dev/null
            notify-send -u critical "$title" "$body"
        end
    end

    return $ret
end
