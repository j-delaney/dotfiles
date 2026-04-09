function files-changed
    switch $argv[1]
    case 'master'
        set -f changed_files (git diff --relative --name-only (git merge-base HEAD origin/master) --diff-filter=d)
    case 'parent'
        set -f changed_files (git diff --relative --name-only (git merge-base HEAD (git-parent)) --diff-filter=d)
    case 'commit'
        set -f changed_files (git diff --relative --name-only --diff-filter=d)
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