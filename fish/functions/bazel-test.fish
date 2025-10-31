function bazel-test
    switch $argv[1]
    case 'master'
        set -f changed_files (git files-since-master)
    case 'parent'
        set -f changed_files (git files-since-parent)
    case '' '*'
        set -f changed_files (git status --porcelain | awk '{print $2}')
    end

    set -f possible_targets (
        string join0 $changed_files |
        string split0 |
        grep --extended-regexp '\.(go|bazel|proto)$' |
        xargs dirname |
        sort --unique
    )
    
    set -f targets
    for target in $possible_targets
        if test (ag 'go_default_test' "$target/BUILD.bazel" >/dev/null 2>&1; echo $status) -eq 0
            set targets $targets "//$target:go_default_test"
        else
            echo "Skipping $target: no tests found"
        end
    end

    set -f args $argv[2..-1]
    echo "Running: bazel test $args $targets"
    bazel test $args $targets
end