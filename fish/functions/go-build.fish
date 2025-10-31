function go-build
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
        set targets $targets "./$target"
    end

    set -f args $argv[2..-1]
    echo "Running: go build $args $targets"
    go build $args $targets
end