function mvmatch
    set name $argv[1]
    mkdir -p $name
    fd -i $name -t f -x mv {} $name/
end
