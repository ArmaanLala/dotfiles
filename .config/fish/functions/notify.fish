function notify
    $argv
    set STATUS $status
    if test $STATUS -eq 0
        osascript -e 'display notification "Done" with title "Terminal" sound name "Glass"'
    else
        osascript -e 'display notification "Failed (exit '$STATUS')" with title "Terminal" sound name "Basso"'
    end
    return $STATUS
end
