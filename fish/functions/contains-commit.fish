function contains-commit
    if test (count $argv) -eq 1
        # Check if the current HEAD contains the given commit
        if git merge-base --is-ancestor $argv[1] HEAD 2>/dev/null
            echo "yes"
        else
            echo "no"
        end
    else if test (count $argv) -eq 2
        # Check if the first commit has the second as an ancestor
        if git merge-base --is-ancestor $argv[2] $argv[1] 2>/dev/null
            echo "yes"
        else
            echo "no"
        end
    else
        echo "Usage: contains-commit <commit> [ancestor-commit]" >&2
        return 1
    end
end