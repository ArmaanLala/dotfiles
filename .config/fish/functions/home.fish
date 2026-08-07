function home
    if test (uname) = Darwin
        set dest /Users/armaanlala/
    else
        set dest /home/armaan/
    end
    cp -r $argv $dest
end
