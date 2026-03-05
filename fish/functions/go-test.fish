function go-test
    argparse master parent -- $argv
    or return

    if set -q _flag_master
        set -f changed_files (files-changed master)
    else if set -q _flag_parent
        set -f changed_files (files-changed parent)
    else
        set -f changed_files (files-changed commit)
    end

    set -f targets
    for target in $changed_files
        if test (ls $target | ag '_test\.go$' >/dev/null 2>&1; echo $status) -eq 0
            set targets $targets "./$target"
        else
            echo "Skipping $target: no tests found"
        end
    end

    echo "Running: go test $targets"
    go test $targets
end