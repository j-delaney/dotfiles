function go-test
    switch $argv[1]
    case 'master'
        set -f changed_files (files-changed master)
    case 'parent'
        set -f changed_files (files-changed parent)
    case '' '*'
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

    set -f args $argv[2..-1]
    echo "Running: go test $args $targets"
    go test $args $targets
end