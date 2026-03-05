function go-test
    argparse 'help' 'master' 'parent' 'skip-jdome' 'depth=?' -- $argv
    or return

    if set -q _flag_help
        echo "Usage: go-test [--help] [--master|--parent] [--skip-jdome] [--depth=1]" >&2
        echo "  --help       Prints this!"
        echo "  --master     Compares changed files to `master` branch"
        echo "  --parent     Compares changed files to parent branch"
        echo "  --skip-jdome Skip running tests for transitive reverse-deps"
        echo "  --depth      How many layers to traverse transitive reverse-deps"
        return 1
    end

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

    echo "Running direct tests"
    go test $targets
    or return

    if set -q _flag_skip_jdome
        return 0
    end

    # Run transitive dependencies
    if set -q JDOME_PATH
        set -f jdome_depth 1
        if set -q _flag_depth
            set jdome_depth $_flag_depth
        end

        set -f module (head -n 1 go.mod | awk '{print $2}')
        for target in $targets
            set -f rdeps_file "$JDOME_PATH/$module/$target.rdeps"
            if test -e "$rdeps_file"
                set -f rdep_targets (awk '$1 > '$jdome_depth' { next } {print $2}' $rdeps_file | sed "s|^$module|.|")
                echo "Running "(count $rdep_targets)"indirect tests for $target"
                go test $rdep_targets
            else
                echo "Skipping $target because $rdeps_file did not exist"
            end
        end
    else
        echo "Skipping rdep tests because JDOME_PATH is not defined"
    end
end