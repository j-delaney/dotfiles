function git-fix --argument commit
    if test (git diff --name-only --cached | count) -eq 0
        echo "Aborting: no files are staged"
        return 1
    end

    git commit --fixup $commit; or return $status
    env GIT_SEQUENCE_EDITOR=: git rebase --autosquash --autostash --interactive (git merge-base HEAD (git-parent)); or return $status

    return 0
end

function git-fix-all --argument commit
    git add .
    gfix "$commit"
end

function _git_commits_in_branch
    for line in (git log --oneline --no-decorate (git-parent)..HEAD)
        set parts (string split --max 1 " " "$line")
        printf "%s\t%s\n" $parts[1] $parts[2]
    end
end

complete --command git-fix --no-files --keep-order -a "(_git_commits_in_branch)"
complete --command git-fix-all --no-files --keep-order -a "(_git_commits_in_branch)"