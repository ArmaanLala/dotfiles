function rectumcollapse
    set -l counter 1
    for file in (find . -mindepth 2 -type f | sort)
        set -l ext (string match -r '\.[^.]+$' -- (basename $file) | string lower)
        set -l newname (printf "%04d%s" $counter $ext)
        mv -- $file $newname
        set counter (math $counter + 1)
    end
end
