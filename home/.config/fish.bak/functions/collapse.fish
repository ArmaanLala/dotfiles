function collapse
    find . -mindepth 2 -type f -exec mv -i {} . \;
end
