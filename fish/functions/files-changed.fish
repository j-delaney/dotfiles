function files-changed
    switch $argv[1]
    case 'master'
        set -f changed_files (git files-since-master)
    case 'parent'
        set -f changed_files (git files-since-parent)
    case 'commit'
        set -f changed_files (git status --porcelain | awk '{print $2}')
    case '*'
        echo "Must specify (master|parent|commit)"
        return 1
    end

    if set -q argv[2]
        set -f regex $argv[2]
    else
        set -f regex '\.(go|bazel|proto)$'
    end
    
    string join0 $changed_files |
        string split0 |
        grep --extended-regexp "$regex" |
        xargs dirname |
        sort --unique
end