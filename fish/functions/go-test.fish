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

    set -f all_targets
    set -f test_targets
    set -f build_targets
    for target in $changed_files
        set all_targets $all_targets "./$target"

        if test (ls $target | ag '_test\.go$' >/dev/null 2>&1; echo $status) -eq 0
            set test_targets $test_targets "./$target"
        else
            set build_targets $build_targets "./$target"
        end
    end

    set_color -o; echo "Running gazelle on "(count $all_targets)" packages"; set_color normal
    ~/stripe/gocode/bin/gazelle $all_targets
    or return

    set_color -o; echo "Running goimports on "(count $all_targets)" packages"; set_color normal
    ~/stripe/gocode/bin/goimports $all_targets
    or return

    set -f total_tested 0
    set -f total_built 0

    if test (count $test_targets) -gt 0
        set_color -o; echo "Running "(count $test_targets)" direct tests"; set_color normal
        go test $test_targets
        or return
        set total_tested (math $total_tested + (count $test_targets))
    end

    if test (count $build_targets) -gt 0
        set_color -o; echo "Building "(count $build_targets)" direct packages with no tests"; set_color normal
        go build -o /dev/null $build_targets
        or return
        set total_built (math $total_built + (count $build_targets))
    end

    if set -q _flag_skip_jdome
        echo ""
        set_color -o; echo "Done: $total_tested tested, $total_built built"; set_color normal
        return 0
    end

    # Run transitive dependencies
    if set -q JDOME_PATH
        set -f jdome_depth 1
        if set -q _flag_depth
            set jdome_depth $_flag_depth
        end

        set -f handled_targets $all_targets
        set -f all_rdep_test_targets
        set -f all_rdep_build_targets
        set -f module (head -n 1 go.mod | awk '{print $2}')

        set_color -o; echo "Discovering indirect targets"; set_color normal
        for target in $all_targets
            set -f rdeps_file "$JDOME_PATH/$module/$target.rdeps"
            if test -e "$rdeps_file"
                for rdep in (awk '$1 > '$jdome_depth' { next } {print $2}' $rdeps_file | sed "s|^$module|.|")
                    if contains -- $rdep $handled_targets
                        continue
                    end
                    set handled_targets $handled_targets $rdep
                    echo $rdep

                    if test (ls $rdep | ag '_test\.go$' >/dev/null 2>&1; echo $status) -eq 0
                        set all_rdep_test_targets $all_rdep_test_targets $rdep
                    else
                        set all_rdep_build_targets $all_rdep_build_targets $rdep
                    end
                end
            end
        end

        if test (count $all_rdep_test_targets) -gt 0
            set_color -o; echo "Running "(count $all_rdep_test_targets)" indirect tests"; set_color normal
            go test $all_rdep_test_targets
            or return
            set total_tested (math $total_tested + (count $all_rdep_test_targets))
        end
        if test (count $all_rdep_build_targets) -gt 0
            set_color -o; echo "Building "(count $all_rdep_build_targets)" indirect packages with no tests"; set_color normal
            go build -o /dev/null $all_rdep_build_targets
            or return
            set total_built (math $total_built + (count $all_rdep_build_targets))
        end
    else
        echo "Skipping rdep tests because JDOME_PATH is not defined"
    end

    echo ""
    set_color -o; echo "Done: $total_tested tested, $total_built built"; set_color normal
end